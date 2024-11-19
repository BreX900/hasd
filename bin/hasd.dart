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
import 'package:hasd/apis/youtrack/youtrack_api.dart';
import 'package:hasd/apis/youtrack/youtrack_dto.dart';
import 'package:hasd/dto/jira_config_dto.dart';
import 'package:hasd/dto/youtrack_config_dto.dart';
import 'package:hasd/models/models.dart';
import 'package:hasd/services/jira_service.dart';
import 'package:hasd/services/service.dart';
import 'package:mekart/mekart.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

void main(List<String> args) async {
  final runner = CommandRunner('hasd', '')
    ..addCommand(_ConfigCommand())
    ..addCommand(_ConfigYoutrackCommand())
    ..addCommand(_ConfigJiraCommand())
    ..addCommand(_CreteCommand())
    ..addCommand(_FetchCommand());

  await runner.run(args);
}

final _bin = BinConnection(BinEngine(directoryPath: applicationConfigHome('com.doonties.hasd')));
Ansi get _ansi => Ansi(Ansi.terminalSupportsAnsi);
final Logger _logger = Logger.standard(ansi: _ansi);

class _ConfigCommand extends Command<void> {
  @override
  String get name => 'config';

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

class _ConfigYoutrackCommand extends Command<void> {
  @override
  String get name => 'config-youtrack';

  @override
  String get description => 'Configure YouTrack.';

  _ConfigYoutrackCommand() {
    argParser
      ..addOption('base-url', mandatory: true)
      ..addOption('api-token', mandatory: true)
      ..addOption('ticket', mandatory: true);
  }

  @override
  Future<void> run() async {
    final argResults = this.argResults!;

    await _bin.youtrackConfig.write(YoutrackConfigDto(
      baseUrl: argResults.requireOption('base-url'),
      apiToken: argResults.requireOption('api-token'),
      ticketId: argResults.requireOption('ticket'),
    ));
  }
}

class _ConfigJiraCommand extends Command<void> {
  @override
  String get name => 'config-jira';

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

JiraService get _service => Service.instance as JiraService;
YoutrackApi get _youtrackApi => YoutrackApi.instance!;

abstract class _CommandWithDependencies extends Command<void> {
  late final YoutrackConfigDto youtrackConfig;
  late final JiraConfigDto jiraConfig;

  @mustCallSuper
  @override
  Future<void> run() async {
    youtrackConfig = await _bin.youtrackConfig.requireRead();
    jiraConfig = await _bin.jiraConfig.requireRead();

    YoutrackApi.instance = YoutrackApi(
      baseUrl: youtrackConfig.baseUrl,
      token: youtrackConfig.apiToken,
    );
    Service.instance = JiraService(jiraConfig);
  }
}

class _CreteCommand extends _CommandWithDependencies {
  @override
  String get name => 'create';

  @override
  String get description => 'Create work time log';

  _CreteCommand() {
    argParser
      ..addOption('ticket', mandatory: true)
      ..addOption('hours')
      ..addOption('minutes')
      ..addOption('date');
  }

  @override
  Future<void> run() async {
    await super.run();

    final argResults = this.argResults!;
    var ticketId = argResults.option('ticket')!;
    if (ticketId.startsWith('http')) ticketId = ticketId.split('/').last;
    var dateTime =
        argResults.wasParsed('date') ? DateTime.parse(argResults.option('date')!) : DateTime.now();
    dateTime = dateTime.copyWith(hour: 9);
    final hours = argResults.wasParsed('hours') ? int.parse(argResults.option('hours')!) : null;
    final minutes =
        argResults.wasParsed('minutes') ? int.parse(argResults.option('minutes')!) : null;

    final duration = WorkDuration(hours: hours ?? 0, minutes: minutes ?? 0);

    await _fetch();

    print('Log "$duration" to issue "$ticketId"?');
    final line = stdin.readLineSync();
    if (line?.toLowerCase() != 'y') return;

    await _service.createWorkLogV2(
      issueIdOrUid: IdOrUid.uid(ticketId),
      activityId: null,
      started: dateTime,
      timeSpent: duration,
    );
    await _youtrackApi.createIssueWorkItem(
      youtrackConfig.ticketId,
      IssueWorkItemCreateDto(
        date: dateTime,
        duration: DurationValueDto(minutes: duration.inMinutes),
        text: '${jiraConfig.baseUrl}/browse/$ticketId',
      ),
    );
    print('Logged!');

    await _logger.wait(const Duration(seconds: 48), 'Checking time logged');
    await _fetch();
  }
}

Future<void> _fetch() async {
  for (var retryCount = 0; retryCount < 5; retryCount++) {
    final startDate = DateTime.now().copyDateWith(day: 1).asDate();
    final endDate = DateTime.now().add(const Duration(days: 1)).asDate();
    final now = Date.timestamp();

    final youtrackWorkLogs = await _youtrackApi.fetchIssueWorkItems(
      startDate: startDate,
      endDate: endDate,
    );
    final toonieWorkLogs = youtrackWorkLogs.where((e) {
      return e.issue.project.id == '0-22';
    }).toList();

    final youtrackAllTimeSpent = toonieWorkLogs.fold(WorkDuration.zero, (total, workLog) {
      return total + WorkDuration(minutes: workLog.duration.minutes);
    });
    final youtrackTodayWorkLogs = toonieWorkLogs.where((e) => e.date.asDate() == now).toList();
    final youtrackTodayTimeSpent = youtrackTodayWorkLogs.fold(WorkDuration.zero, (total, workLog) {
      return total + WorkDuration(minutes: workLog.duration.minutes);
    });

    final jiraWorkLogs = await _service.fetchWorkLogs(spentFrom: startDate, spentTo: endDate);

    final jiraAllTimeSpent = jiraWorkLogs.fold(WorkDuration.zero, (total, workLog) {
      return total + workLog.timeSpent;
    });
    final jiraTodayWorkLogs = jiraWorkLogs.where((e) => e.spentOn == now).toList();
    final jiraTodayTimeSpent = jiraTodayWorkLogs.fold(WorkDuration.zero, (total, workLog) {
      return total + workLog.timeSpent;
    });

    print('Project  | All               | Today');
    print(
        'Youtrack | $youtrackAllTimeSpent (${toonieWorkLogs.length}) | $youtrackTodayTimeSpent (${youtrackTodayWorkLogs.length})');
    print(
        'Jira     | $jiraAllTimeSpent (${jiraWorkLogs.length}) | $jiraTodayTimeSpent (${jiraTodayWorkLogs.length})');

    if (youtrackAllTimeSpent == jiraAllTimeSpent) return;

    await _logger.wait(const Duration(seconds: 5), 'Retry ${retryCount + 1}');
  }

  throw StateError('Times is different!');
}

class _FetchCommand extends _CommandWithDependencies {
  @override
  String get name => 'fetch';

  @override
  String get description => 'Fetch all log work times';

  @override
  Future<void> run() async {
    await super.run();

    await _fetch();
  }
}

extension on ArgResults {
  String requireOption(String name) {
    final option = this.option(name);
    if (option == null) throw ArgumentError('Option $name is mandatory.');
    return option;
  }
}

extension on Logger {
  Future<void> wait(Duration duration, String message) async {
    final progress = timedProgress('$message in ${duration.toShortString()}');
    await Future<void>.delayed(duration);
    progress.finish();
  }

  Progress timedProgress(String message) => _TimedProgress(ansi, message);
}

extension on Duration {
  String toShortString({bool all = false}) {
    return [
      if (all || days > 0) '${days}d',
      if (all || hours > 0) '${hours}h',
      if (all || minutes > 0) '${minutes}m',
      if (all || seconds > 0) '${seconds}s',
    ].join(' ');
  }
}

class _TimedProgress extends Progress {
  final Ansi ansi;
  late final Timer _timer;

  _TimedProgress(this.ansi, String message) : super(message) {
    _timer = Timer.periodic(const Duration(milliseconds: 80), (t) {
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
