// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:args/args.dart';
// ignore: depend_on_referenced_packages
import 'package:args/command_runner.dart';
// ignore: depend_on_referenced_packages
import 'package:cli_util/cli_util.dart';
import 'package:hasd/apis/jira/jira_api.dart';
import 'package:hasd/apis/youtrack/youtrack_api.dart';
import 'package:hasd/apis/youtrack/youtrack_dto.dart';
import 'package:hasd/dto/jira_config_dto.dart';
import 'package:hasd/dto/youtrack_config_dto.dart';
import 'package:hasd/models/models.dart';
import 'package:hasd/services/jira_service.dart';
import 'package:hasd/services/service.dart';
import 'package:mekart/mekart.dart';

void main(List<String> args) async {
  BinEngine.instance = _BinEngine();

  final runner = CommandRunner('hasd', '')
    ..addCommand(_ConfigCommand())
    ..addCommand(_ConfigYoutrackCommand())
    ..addCommand(_ConfigJiraCommand())
    ..addCommand(_CreteCommand())
    ..addCommand(_FetchCommand());

  await runner.run(args);
}

JiraService get _service => Service.instance as JiraService;
YoutrackApi get _youtrackApi => YoutrackApi.instance!;

Future<void> _show() async {
  final startDate = DateTime.now().copyDateWith(day: 1).asDate();

  final jiraWorkLogs = await _service.fetchWorkLogs(spentFrom: startDate);

  final jiraTimeSpent =
      jiraWorkLogs.fold(WorkDuration.zero, (total, workLog) => total + workLog.timeSpent);
  print('Jira(${jiraWorkLogs.length}): $jiraTimeSpent');

  final youtrackWorkLogs = await _youtrackApi.fetchIssueWorkItems(startDate: startDate);
  final toonieWorkLogs = youtrackWorkLogs.where((e) {
    return e.issue.project.id == '0-22';
  }).toList();

  final youtrackTimeSpent = toonieWorkLogs.fold(WorkDuration.zero, (total, workLog) {
    return total + WorkDuration(minutes: workLog.duration.minutes);
  });
  print('Youtrack(${toonieWorkLogs.length}): $youtrackTimeSpent');
}

class _BinEngine extends BinEngineBase {
  @override
  Future<String?> getDirectoryPath() async => applicationConfigHome('com.doonties.hasd');
}

class _ConfigCommand extends Command<void> {
  @override
  String get name => 'config';

  @override
  String get description => 'Print configurations.';

  @override
  Future<void> run() async {
    final youtrackConfig = await YoutrackConfigDto.bin.read();
    if (youtrackConfig != null) print('YouTrack: ${jsonEncode(youtrackConfig)}');

    final jiraConfig = await JiraConfigDto.bin.read();
    if (jiraConfig != null) print('Jira: ${jsonEncode(jiraConfig)}');

    if (youtrackConfig == null && jiraConfig == null) print('Configurations is empty.');
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

    await YoutrackConfigDto.bin.write(YoutrackConfigDto(
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

    await JiraConfigDto.bin.write(JiraConfigDto(
      baseUrl: argResults.requireOption('base-url'),
      userEmail: argResults.requireOption('user-email'),
      apiToken: argResults.requireOption('api-token'),
    ));
  }
}

abstract class _CommandWithDependencies extends Command<void> {
  late final YoutrackConfigDto youtrackConfig;
  late final JiraConfigDto jiraConfig;

  @override
  Future<void> run() async {
    youtrackConfig = await YoutrackConfigDto.bin.requireRead();
    jiraConfig = await JiraConfigDto.bin.requireRead();

    YoutrackApi.instance = YoutrackApi(
      baseUrl: youtrackConfig.baseUrl,
      token: youtrackConfig.apiToken,
    );
    Service.instance = JiraService(JiraApi(
      baseUrl: jiraConfig.baseUrl,
      userEmail: jiraConfig.userEmail,
      token: jiraConfig.apiToken,
    ));
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
    final argResults = this.argResults!;
    final ticketId = argResults.option('ticket')!;
    var dateTime =
        argResults.wasParsed('date') ? DateTime.parse(argResults.option('date')!) : DateTime.now();
    dateTime = dateTime.copyWith(hour: 9);
    final hours = argResults.wasParsed('hours') ? int.parse(argResults.option('hours')!) : null;
    final minutes =
        argResults.wasParsed('minutes') ? int.parse(argResults.option('minutes')!) : null;

    final duration = WorkDuration(hours: hours ?? 0, minutes: minutes ?? 0);

    print('Log "$duration" to issue "$ticketId"?');
    final line = stdin.readLineSync();
    if (line?.toLowerCase() != 'y') return;

    await _show();

    await _service.createWorkLogV2(
      issueIdOrUid: IdOrUid.uid(ticketId),
      activityId: null,
      started: dateTime,
      timeSpent: duration,
    );
    await YoutrackApi.instance!.createIssueWorkItem(
      youtrackConfig.ticketId,
      IssueWorkItemCreateDto(
        date: dateTime,
        duration: DurationValueDto(minutes: duration.inMinutes),
        text: '${jiraConfig.baseUrl}/browse/$ticketId',
      ),
    );
    print('Logged!');

    await _show();
  }
}

class _FetchCommand extends _CommandWithDependencies {
  @override
  String get name => 'fetch';

  @override
  String get description => 'Fetch all log work times';

  @override
  Future<void> run() async {
    await _show();
  }
}

extension on ArgResults {
  String requireOption(String name) {
    final option = this.option(name);
    if (option == null) throw ArgumentError('Option $name is mandatory.');
    return option;
  }
}
