import 'dart:convert';
import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/jira/jira_api.dart';
import 'package:hasd/apis/jira/jira_dto.dart';
import 'package:hasd/apis/jira/jira_markup_resolver.dart';
import 'package:hasd/apis/redmine/redmine_dto.dart';
import 'package:hasd/models/models.dart';
import 'package:hasd/services/service.dart';
import 'package:mekart/mekart.dart';

class JiraService implements Service {
  static JiraService get instance => const JiraService._();

  JiraApi get _jiraApi => JiraApi.instance;

  const JiraService._();

  @override
  Map<String, String> get authorizationHeaders => _jiraApi.authorizationHeaders;

  @override
  Future<ProjectModel> fetchProject(int projectId) async {
    final project = await _jiraApi.fetchProject(IdOrUid.id(projectId));
    return ProjectModel(
      id: project.id,
      workLogActivities: null,
    );
  }

  @override
  Future<IList<Reference>> fetchProjectMembers(int projectId) async {
    final project = await _jiraApi.fetchProject(IdOrUid.id(projectId));
    final users = await _jiraApi.fetchProjectMembers(
      query: '',
      projectKeys: ISet([project.key]),
    );
    return users.map((e) => e.toModel()).toIList();
  }

  @override
  Future<IList<Reference>> fetchAllIssueStatues() async {
    final statutes = await _jiraApi.fetchIssueStatutes();
    return statutes.where((e) => e.scope.isEmpty).map((e) => Reference(e.id, e.name)).toIList();
  }

  @override
  Future<IList<IssueModel>> fetchIssues() async {
    final issues = await _jiraApi.searchIssues(
      jql: JqlExpression.and([
        JqlFilter(JiraIssueFields.project, equalTo: 'TN'),
        JqlFilter(JiraIssueFields.parent, equalTo: '16494'),
      ]),
      orderBy: 'created',
      descending: true,
    );
    return issues.records.map((e) => e.toModel()).toIList();
  }

  @override
  Future<IssueModel> fetchIssue(int issueId) async {
    final issue = await _jiraApi.fetchIssue(IdOrUid.id(issueId));
    return issue.toModel();
  }

  @override
  Future<IList<WorkLogModel>> fetchWorkLogs({Date? spentFrom, Date? spentTo, int? issueId}) async {
    final worklogIds = await _jiraApi.fetchWorkLogsBySince(since: spentFrom?.asDateTime());
    final workLogs = await _jiraApi.fetchWorkLogsByIds(worklogIds);

    return workLogs.where((e) {
      if (issueId != null && e.issueId == issueId) return false;
      return e.author.accountId == '60d193aaa1746300708b3367';
    }).map((workLog) {
      return WorkLogModel(
        issueId: workLog.issueId,
        author: workLog.author.displayName,
        spentOn: workLog.started.asDate(),
        timeSpent: workLog.timeSpent,
        activity: null,
        comments: jsonEncode(workLog.comment),
      );
    }).toIList();
  }

  @override
  Future<void> createWorkLog({
    required int issueId,
    required int? activityId,
    required DateTime started,
    required WorkDuration timeSpent,
  }) async {
    await createWorkLogV2(
      issueIdOrUid: IdOrUid.id(issueId),
      activityId: activityId,
      started: started,
      timeSpent: timeSpent,
    );
  }

  Future<void> createWorkLogV2({
    required IdOrUid issueIdOrUid,
    required int? activityId,
    required DateTime started,
    required WorkDuration timeSpent,
  }) async {
    final issue = await _jiraApi.fetchIssue(issueIdOrUid);
    final remainingEstimate = issue.timeTracking.remainingEstimate ?? WorkDuration.zero;
    final newEstimate = remainingEstimate - timeSpent;
    final data = JiraWorkLogCreateDto(
      started: started
          .copyWith(minute: 0, second: 0, microsecond: 0, millisecond: 0)
          .toLocal()
          .copyWith(hour: 9)
          .toUtc(),
      timeSpent: timeSpent,
    );

    await _jiraApi.createWorkLog(
      issueIdOrUid,
      newEstimate: WorkDuration(seconds: max(newEstimate.inSeconds, 0)),
      data: data,
    );
  }
}

extension on JiraProjectDto {
  Reference toModel() => Reference(id, name);
}

extension on UserDto {
  Reference toModel() => Reference(-1, displayName);
}

extension on JiraIssueDto {
  IssueModel toModel() {
    return IssueModel(
      id: id,
      project: project.toModel(),
      parentId: null,
      hrefUrl: 'hrefUrl',
      status: status.toModel(),
      author: creator.toModel(),
      assignedTo: assignee?.toModel(),
      closedOn: null,
      dueDate: null,
      subject: summary,
      description: description != null
          ? JiraMarkdownBuilder(attachments: attachment, data: description!)
          : '',
      attachments: attachment.map((e) => e.toModel()).toIList(),
      journals: const IList.empty(),
      children: const IList.empty(),
    );
  }
}

extension on JiraIssueStatusDto {
  Reference toModel() => Reference(id, name);
}

extension on JiraAttachmentDto {
  AttachmentModel toModel() {
    return AttachmentModel(
      filename: filename,
      mimeType: mimeType,
      thumbnailUrl: thumbnail,
      contentUrl: content,
    );
  }
}
