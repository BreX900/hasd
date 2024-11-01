import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/jira/jira_api.dart';
import 'package:hasd/apis/redmine/redmine_api.dart';
import 'package:hasd/redmine/hasd_providers.dart';
import 'package:mekart/mekart.dart';

class WorkLogDto {
  final int issueId;
  final String author;
  final Date spentOn;
  final Duration timeSpent;
  final String activity;
  final String comments;

  const WorkLogDto({
    required this.issueId,
    required this.author,
    required this.spentOn,
    required this.timeSpent,
    required this.activity,
    required this.comments,
  });
}

abstract interface class AppService {
  static final AppService instance = JiraAppService();

  Future<IList<WorkLogDto>> fetchWorkLogs({Date? spentFrom, Date? spentTo, int? issueId});
}

class JiraAppService implements AppService {
  final _jiraApi = JiraApi();

  @override
  Future<IList<WorkLogDto>> fetchWorkLogs({Date? spentFrom, Date? spentTo, int? issueId}) async {
    final worklogIds = await _jiraApi.fetchWorkLogsBySince(since: spentFrom?.asDateTime());
    final workLogs = await _jiraApi.fetchWorkLogsByIds(worklogIds);

    return workLogs.where((e) {
      if (issueId != null && e.issueId == issueId) return false;
      return e.author.accountId == '60d193aaa1746300708b3367';
    }).map((workLog) {
      return WorkLogDto(
        issueId: workLog.issueId,
        author: workLog.author.displayName,
        spentOn: workLog.started.asDate(),
        timeSpent: workLog.timeSpent,
        activity: '',
        comments: jsonEncode(workLog.comment),
      );
    }).toIList();
  }
}

class RedmineAppService implements AppService {
  RedmineApi get _redmineApi => RedmineApi.instance;

  @override
  Future<IList<WorkLogDto>> fetchWorkLogs({Date? spentFrom, Date? spentTo, int? issueId}) async {
    final timeEntries = await HasdProviders.fetchAll((limit, offset) async {
      return await _redmineApi.fetchTimeEntries(
        userId: -1,
        limit: limit,
        offset: offset,
        spentFrom: spentFrom,
        spentTo: spentTo,
        issueId: issueId,
      );
    });

    return timeEntries.map((timeEntry) {
      return WorkLogDto(
        issueId: timeEntry.entityId,
        author: timeEntry.user.name,
        spentOn: timeEntry.spentOn,
        timeSpent: timeEntry.hours,
        activity: timeEntry.activity.name,
        comments: timeEntry.comments,
      );
    }).toIList();
  }
}
