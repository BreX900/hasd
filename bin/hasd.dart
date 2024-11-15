// ignore_for_file: avoid_print

import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:args/command_runner.dart';
import 'package:hasd/apis/youtrack/youtrack_api.dart';
import 'package:hasd/common/env.dart';
import 'package:hasd/models/models.dart';
import 'package:hasd/services/jira_service.dart';
import 'package:mekart/mekart.dart';

// mek compile-exe bin/hasd.dart --define-from-file=_/.env && ./build/hasd.exe fetch
void main(List<String> args) async {
  YoutrackApi.instance = YoutrackApi(Env.youtrackApiToken);

  final runner = CommandRunner('hasd', '')
    ..addCommand(_CreteCommand())
    ..addCommand(_FetchCommand());

  await runner.run(args);
}

JiraService get _service => JiraService.instance;
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

class _CreteCommand extends Command<void> {
  static JiraService get _service => JiraService.instance;

  @override
  String get name => 'create';

  @override
  String get description => 'Create work time log';

  _CreteCommand() {
    argParser
      ..addOption('issue', mandatory: true)
      ..addOption('hours')
      ..addOption('minutes')
      ..addOption('date');
  }

  @override
  Future<void> run() async {
    final argResults = this.argResults!;
    final issueId = argResults.option('issue')!;
    final date = argResults.option('date');
    final hours = argResults.wasParsed('hours') ? int.parse(argResults.option('hours')!) : null;
    final minutes =
        argResults.wasParsed('minutes') ? int.parse(argResults.option('minutes')!) : null;

    final duration = WorkDuration(hours: hours ?? 0, minutes: minutes ?? 0);

    print('Log "$duration" to issue "$issueId"?');
    final line = stdin.readLineSync();
    if (line?.toLowerCase() != 'y') return;

    await _service.createWorkLogV2(
      issueIdOrUid: IdOrUid.uid(issueId),
      activityId: null,
      started: date != null ? DateTime.parse(date) : DateTime.now().copyWith(hour: 9),
      timeSpent: duration,
    );
    print('Logged!');

    await _show();
  }
}

class _FetchCommand extends Command<void> {
  @override
  String get name => 'fetch';

  @override
  String get description => 'Fetch all log work times';

  @override
  Future<void> run() async {
    await _show();
  }
}
