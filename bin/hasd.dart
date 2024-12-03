// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:args/args.dart';
// ignore: depend_on_referenced_packages
import 'package:args/command_runner.dart';
// ignore: depend_on_referenced_packages
import 'package:cli_util/cli_logging.dart';
// ignore: depend_on_referenced_packages
import 'package:cli_util/cli_util.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/youtrack/youtrack_api.dart';
import 'package:hasd/apis/youtrack/youtrack_dto.dart';
import 'package:hasd/dto/jira_config_dto.dart';
import 'package:hasd/dto/youtrack_config_dto.dart';
import 'package:hasd/models/models.dart';
import 'package:hasd/services/jira_service.dart';
import 'package:hasd/services/service.dart';
import 'package:hasd/services/youtrack_service.dart';
import 'package:mekart/mekart.dart';
// ignore: depend_on_referenced_packages
import 'package:mekcli/mekcli.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

void main(List<String> args) async {
  final runner = CommandRunner('hasd', '')
    ..addCommand(_ConfigCommand())
    ..addCommand(_CreteCommand())
    ..addCommand(_FetchCommand());

  try {
    await runner.run(args);
    // ignore: avoid_catching_errors
  } on ArgumentError catch (error) {
    stderr.write(error);
    exit(-1);
  }
}

final _bin = BinConnection(BinEngine(directoryPath: applicationConfigHome('com.doonties.hasd')));
Ansi get _ansi => Ansi(Ansi.terminalSupportsAnsi);
final Logger _logger = Logger.standard(ansi: _ansi);

class _ConfigCommand extends Command<void> {
  @override
  String get name => 'config';

  @override
  String get description => 'Sub-commands to handle the configurations.';

  _ConfigCommand() {
    addSubcommand(_ConfigPrintCommand());
    addSubcommand(_ConfigYoutrackCommand());
    addSubcommand(_ConfigJiraCommand());
    addSubcommand(_ConfigProjectCommand());
  }
}

class _ConfigPrintCommand extends Command<void> {
  @override
  String get name => 'show';

  @override
  String get description => 'Print configurations.';

  @override
  Future<void> run() async {
    final youtrackConfig = await _bin.youtrackConfig.read();
    if (youtrackConfig != null) _printConfig('YouTrack', youtrackConfig.toJson());

    final jiraConfig = await _bin.jiraConfig.read();
    if (jiraConfig != null) _printConfig('Jira', jiraConfig.toJson());

    if (youtrackConfig == null && jiraConfig == null) print('Configurations is empty.');
  }

  void _printConfig(String name, Map<String, dynamic> data) {
    print('${_ansi.yellow}$name:${_ansi.none}');
    data.forEach((key, value) {
      print('- $key: ${jsonEncode(value)}');
    });
  }
}

class _ConfigProjectCommand extends Command<void> {
  @override
  String get name => 'jira-project';

  @override
  String get description => 'Configure projects.';

  _ConfigProjectCommand() {
    argParser
      ..addOption('key', mandatory: true)
      ..addOption('youtrack-issue', mandatory: true);
  }

  @override
  Future<void> run() async {
    final jiraProjectKey = argResults!.requireOption('key');
    final youtrackIssueId = argResults!.requireOption('youtrack-issue');

    await _bin.runTransaction((tx) async {
      final config = await tx.jiraConfig.requireRead();
      await tx.jiraConfig.write(config.change((c) => c
        ..youtrackIssueByProject =
            config.youtrackIssueByProject.add(jiraProjectKey, youtrackIssueId)));
    });
    print('Configured Jira "$jiraProjectKey" project to YouTrack $youtrackIssueId issue.');
  }
}

class _ConfigYoutrackCommand extends Command<void> {
  @override
  String get name => 'youtrack';

  @override
  String get description => 'Configure YouTrack.';

  _ConfigYoutrackCommand() {
    argParser
      ..addOption('base-url', mandatory: true)
      ..addOption('api-token', mandatory: true);
  }

  @override
  Future<void> run() async {
    final argResults = this.argResults!;

    await _bin.youtrackConfig.write(YoutrackConfigDto(
      baseUrl: argResults.requireOption('base-url'),
      apiToken: argResults.requireOption('api-token'),
    ));
  }
}

class _ConfigJiraCommand extends Command<void> {
  @override
  String get name => 'jira';

  @override
  String get description => 'Configure Jira.';

  _ConfigJiraCommand() {
    argParser
      ..addOption('base-url', mandatory: true)
      ..addOption('user-email', mandatory: true)
      ..addOption('api-token', mandatory: true);
  }

  @override
  Future<void> run() async {
    final argResults = this.argResults!;

    await _bin.jiraConfig.write(JiraConfigDto(
      baseUrl: argResults.requireOption('base-url'),
      userEmail: argResults.requireOption('user-email'),
      apiToken: argResults.requireOption('api-token'),
    ));
  }
}

enum _Tracker { jira, youTrack }

JiraService get _service => Service.instance as JiraService;
YoutrackApi get _youtrackApi => YoutrackApi.instance!;

enum _FetchType { short, daily, monthly }

// class _Fetch {
//   final Iterable<WorkDuration>
// }

class DateTimeRange {
  final DateTime startAt;
  final DateTime endAt;

  DateTimeRange(this.startAt, this.endAt);

  bool contains(DateTime dateTime) => dateTime.isAfter(startAt) && dateTime.isBefore(endAt);
}

abstract class _CommandWithDependencies extends Command<void> {
  // late final ConfigDto config;
  late final YoutrackConfigDto youtrackConfig;
  late final JiraConfigDto jiraConfig;

  YoutrackService get _youtrackService => YoutrackService(youtrackConfig);

  @mustCallSuper
  @override
  Future<void> run() async {
    // config = await _bin.config.read();
    youtrackConfig = await _bin.youtrackConfig.requireRead();
    jiraConfig = await _bin.jiraConfig.requireRead();

    YoutrackApi.instance = YoutrackApi(
      baseUrl: youtrackConfig.baseUrl,
      token: youtrackConfig.apiToken,
    );
    Service.instance = JiraService(jiraConfig);
  }

  Future<void> _fetch({required _FetchType type}) async {
    WorkDuration sumYoutrack(WorkDuration total, IssueWorkItemDto issue) => total + issue.duration;
    WorkDuration sum(WorkDuration total, WorkLogModel issue) => total + issue.timeSpent;

    for (var retryCount = 0; retryCount < 5; retryCount++) {
      final now = Date.timestamp();
      final monthRange = DateRange(
        start: now.copyWith(day: 1),
        end: now.copyWith(month: now.month + 1, day: 0),
      );
      final yearDate = now.copyWith(day: 1).copySubtracting(months: 1);

      final youtrackProjectsWorkLogs = await _youtrackApi.fetchIssueWorkItems(startDate: yearDate);
      final youtrackWorkLogs = youtrackProjectsWorkLogs.where((e) {
        return e.issue.project.name == 'Toonie';
        final projectUid = e.issue.project.name.toUpperCase();
        return jiraConfig.youtrackIssueByProject.values
            .contains('$projectUid-${e.issue.numberInProject}');
      }).toList();
      final youtrackAllTimeSpent = youtrackWorkLogs.fold(WorkDuration.zero, sumYoutrack);

      final jiraWorkLogs = await _service.fetchWorkLogs(spentFrom: yearDate);
      final jiraAllTimeSpent = jiraWorkLogs.fold(WorkDuration.zero, sum);

      final workLogs = <_Tracker, IList<WorkLogModel>>{
        _Tracker.youTrack: await _youtrackService.fetchWorkLogs(spentFrom: yearDate),
        _Tracker.jira: await _service.fetchWorkLogs(spentFrom: yearDate),
      };

      switch (type) {
        case _FetchType.short:
          print(const Table(verticalDivisor: ' | ').render([
            ['Project', 'Monthly', 'Daily'],
            ...workLogs.mapTo((tracker, workLogs) {
              final dailyTimeSpent =
                  workLogs.where((e) => e.spentOn == now).map((e) => e.timeSpent).sum;
              final monthlyTimeSpent =
                  workLogs.where((e) => monthRange.contains(e.spentOn)).map((e) => e.timeSpent).sum;

              return [tracker.name, dailyTimeSpent, monthlyTimeSpent];
            }),
          ]));
        case _FetchType.daily:
          final monthDates = [
            for (var offset = monthRange.start;
                offset.isBefore(now) || offset == now;
                offset = offset.copyAdding(days: 1))
              if (offset.weekday != DateTime.saturday && offset.weekday != DateTime.sunday) offset
          ];
          print(const Table(verticalDivisor: ' | ').render([
            ['Project', for (final date in monthDates) date.day],
            ...workLogs.mapTo((tracker, workLogs) {
              return [
                tracker.name,
                for (final date in monthDates)
                  workLogs.fold<WorkDuration>(WorkDuration.zero, (total, workLog) {
                    if (workLog.spentOn != date) return total;
                    return total + workLog.timeSpent;
                  }).toString(short: true),
              ];
            }),
          ]));
          return;
        case _FetchType.monthly:
          final monthDates = [
            for (var offset = yearDate;
                offset.isBefore(now) || offset == now;
                offset = offset.copyAdding(months: 1))
              offset
          ];
          print(const Table(verticalDivisor: ' | ').render([
            [yearDate.year, for (final date in monthDates) date.month],
            ...workLogs.mapTo((tracker, workLogs) {
              return [
                tracker.name,
                for (final date in monthDates)
                  workLogs.fold<WorkDuration>(WorkDuration.zero, (total, workLog) {
                    if (workLog.spentOn.isBefore(date)) return total;
                    if (workLog.spentOn.isAfter(date.copyAdding(months: 1))) return total;

                    return total + workLog.timeSpent;
                  }).toString(short: true)
              ];
            }),
          ]));
          return;
      }

      if (youtrackAllTimeSpent == jiraAllTimeSpent) return;

      await _logger.wait(const Duration(seconds: 3), 'Retry ${retryCount + 1}');
    }

    throw StateError('Times is different!');
  }
}

class _CreteCommand extends _CommandWithDependencies {
  @override
  String get name => 'create';

  @override
  String get description => 'Create work time log';

  _CreteCommand() {
    argParser
      ..addOption('issue', mandatory: true)
      ..addOption('hours')
      ..addOption('minutes')
      ..addOption('date')
      ..addOption('comment');
  }

  @override
  Future<void> run() async {
    await super.run();

    final argResults = this.argResults!;
    var issueId = argResults.option('issue')!;
    if (issueId.startsWith('http')) issueId = issueId.split('/').last;
    var dateTime = argResults.value('date', DateTime.parse) ?? DateTime.now();
    dateTime = dateTime.copyWith(hour: 9);
    final hours = argResults.value('hours', int.parse);
    final minutes = argResults.value('minutes', int.parse);
    final comment = argResults.option('comment');

    final duration = WorkDuration(hours: hours ?? 0, minutes: minutes ?? 0);

    final issue = await _service.api.fetchIssue(IdOrUid.uid(issueId));

    final youtrackIssueId = jiraConfig.youtrackIssueByProject[issue.project.key];
    if (youtrackIssueId == null) {
      throw ArgumentError('Please configure project using "config project" command.');
    }

    await _fetch(type: _FetchType.short);

    print('Log "$duration" to issue "$issueId" at ${dateTime.asDate()}: ${issue.summary}"?');
    if (comment != null) print(comment.split('\n').map((e) => '> $e').join('\n'));
    final line = stdin.readLineSync();
    if (line?.toLowerCase() != 'y') return;

    await _service.createWorkLogV2(
      issueIdOrUid: IdOrUid.uid(issueId),
      activityId: null,
      started: dateTime,
      timeSpent: duration,
      comment: comment,
    );
    await _youtrackApi.createIssueWorkItem(
      youtrackIssueId,
      IssueWorkItemCreateDto(
        date: dateTime,
        duration: WorkDuration(minutes: duration.inMinutes),
        text: '${jiraConfig.baseUrl}/browse/$issueId\n'
            '${issue.summary}'
            '${comment != null ? '\n$comment' : ''}',
      ),
    );
    print('Logged!');

    await _logger.wait(const Duration(seconds: 60), 'Checking time logged waiting Jira cache');
    await _fetch(type: _FetchType.short);
  }
}

class _FetchCommand extends _CommandWithDependencies {
  @override
  String get name => 'fetch';

  @override
  String get description => 'Fetch all log work times';

  _FetchCommand() {
    argParser.addOption(
      'type',
      allowed: [_FetchType.daily.name, _FetchType.monthly.name],
      defaultsTo: _FetchType.daily.name,
    );
  }

  @override
  Future<void> run() async {
    await super.run();

    final type = argResults!
        .requireValue('type', (value) => _FetchType.values.firstWhere((e) => e.name == value));

    await _fetch(type: type);
  }
}

extension on ArgResults {
  String requireOption(String name) {
    final option = this.option(name);
    if (option == null) throw ArgumentError('Option $name is mandatory.', name);
    return option;
  }

  T? value<T>(String name, T Function(String value) converter) {
    final option = this.option(name);
    return option != null ? converter(option) : null;
  }

  T requireValue<T>(String name, T Function(String value) converter) {
    final option = requireOption(name);
    return converter(option);
  }
}

extension on Logger {
  Future<void> wait(Duration duration, String message) async {
    final progress = timedProgress('$message in ${duration.toShortString(milliseconds: false)}');
    await Future<void>.delayed(duration);
    progress.finish();
  }

  Progress timedProgress(String message) => _TimedProgress(ansi, message);
}

class _TimedProgress extends Progress {
  final Ansi ansi;
  late final Timer _timer;

  _TimedProgress(this.ansi, String message) : super(message) {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      _updateDisplay();
    });
    stdout.write('$message... '.padRight(40));
    _updateDisplay();
  }

  @override
  void cancel() {
    if (!_timer.isActive) return;
    _timer.cancel();
    _updateDisplay(cancelled: true);
  }

  @override
  void finish({String? message, bool showTiming = false}) {
    if (!_timer.isActive) return;
    _timer.cancel();
    _updateDisplay(isFinal: true, message: message, showTiming: showTiming);
  }

  String _prevChars = '';

  void _updateDisplay({
    bool isFinal = false,
    bool cancelled = false,
    String? message,
    bool showTiming = false,
  }) {
    final time = (elapsed.inMilliseconds / 1000.0).toStringAsFixed(1);
    var chars = '${time}s';
    if (isFinal || cancelled) {
      chars = '';
    }
    stdout.write('${ansi.backspace * _prevChars.length}$chars');
    _prevChars = chars;
    if (isFinal || cancelled) {
      if (message != null) {
        stdout.write(message.isEmpty ? ' ' : message);
      } else if (showTiming) {
        final time = (elapsed.inMilliseconds / 1000.0).toStringAsFixed(1);
        stdout.write('${time}s');
      } else {
        stdout.write(' ');
      }
      stdout.writeln();
    }
  }
}
