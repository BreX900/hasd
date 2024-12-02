import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/jira/jira_api.dart';
import 'package:hasd/apis/jira/jira_dto.dart';
import 'package:hasd/apis/jira/jira_markup_dto.dart';
import 'package:hasd/apis/jira/jira_markup_resolver.dart';
import 'package:hasd/apis/jira/jql_spec.dart';
import 'package:hasd/apis/redmine/redmine_dto.dart';
import 'package:hasd/dto/jira_config_dto.dart';
import 'package:hasd/models/models.dart';
import 'package:hasd/services/service.dart';
import 'package:mekart/mekart.dart';

class JiraService implements Service {
  final JiraConfigDto config;
  late final JiraApi api = JiraApi(
    baseUrl: config.baseUrl,
    userEmail: config.userEmail,
    token: config.apiToken,
  );

  JiraService(this.config);

  @override
  Map<String, String> get authorizationHeaders => api.authorizationHeaders;

  @override
  Uri joinApiKey(Uri uri) => throw UnimplementedError();

  @override
  Future<int> resolveIssueIdentification(String data) async {
    final issueKey = data.split('/').last;
    final issue = await api.fetchIssue(IdOrUid.uid(issueKey));
    return issue.id;
  }

  @override
  Future<ProjectModel> fetchProject(int projectId) async {
    final project = await api.fetchProject(IdOrUid.id(projectId));
    return ProjectModel(
      id: project.id,
      workLogActivities: null,
    );
  }

  @override
  Future<IList<Reference>> fetchProjectMembers(int projectId) async {
    final project = await api.fetchProject(IdOrUid.id(projectId));
    final users = await api.fetchProjectMembers(
      query: '',
      projectKeys: ISet([project.key]),
    );
    return users.map((e) => e.toModel()).toIList();
  }

  @override
  Future<IList<Reference>> fetchAllIssueStatues() async {
    final statutes = await api.fetchIssueStatutes();
    return statutes.where((e) => e.scope.isEmpty).map((e) => Reference(e.id, e.name)).toIList();
  }

  @override
  Future<IList<IssueModel>> fetchIssues() async {
    final issues = await api.searchIssues(
      jql: JqlExpression.and([
        JqlFilter(JiraIssueFields.project, equalTo: 'TN'),
        JqlFilter(JiraIssueFields.parent, equalTo: '16494'),
      ]),
      orderBy: 'created',
      descending: true,
    );
    return issues.records.map((e) => e.toModel(config)).toIList();
  }

  @override
  Future<IssueModel> fetchIssue(int issueId) async {
    final issue = await api.fetchIssue(IdOrUid.id(issueId));
    return issue.toModel(config);
  }

  @override
  Future<IList<WorkLogModel>> fetchWorkLogs({Date? spentFrom, Date? spentTo, int? issueId}) async {
    final worklogIds = await api.fetchWorkLogsBySince(since: spentFrom?.asDateTime());
    final workLogs = await api.fetchWorkLogsByIds(worklogIds);

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
      comment: null,
    );
  }

  Future<void> createWorkLogV2({
    required IdOrUid issueIdOrUid,
    required int? activityId,
    required DateTime started,
    required WorkDuration timeSpent,
    required String? comment,
  }) async {
    final issue = await api.fetchIssue(issueIdOrUid);
    final remainingEstimate = issue.timeTracking.remainingEstimate ?? WorkDuration.zero;
    final newEstimate = remainingEstimate - timeSpent;
    final data = JiraWorkLogCreateDto(
      started: started
          .copyWith(minute: 0, second: 0, microsecond: 0, millisecond: 0)
          .toLocal()
          .copyWith(hour: 9)
          .toUtc(),
      timeSpent: timeSpent,
      comment: comment != null
          ? JiraMarkupDocDto(
              content: IList([
                JiraMarkupParagraphDto(
                  content: comment.split('\n').map((line) {
                    return JiraMarkupTextDto(
                      text: line,
                      marks: const IList.empty(),
                    );
                  }).expandIndexed((index, child) sync* {
                    if (index > 0) yield const JiraMarkupHardBreakDto();
                    yield child;
                  }).toIList(),
                ),
              ]),
            )
          : null,
    );

    await api.createWorkLog(
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
  IssueModel toModel(JiraConfigDto config) {
    final description = this.description;
    return IssueModel(
      id: id,
      key: key,
      project: project.toModel(),
      parentId: null,
      hrefUrl: '${config.baseUrl}/browse/$key',
      status: status.toModel(),
      author: creator.toModel(),
      assignedTo: assignee?.toModel(),
      closedOn: null,
      dueDate: null,
      subject: summary,
      description: description != null
          ? JiraMarkdownBuilder(attachments: attachment, data: description)
          : '',
      attachments: _filterAttachments(attachment, description).map((e) => e.toModel()).toIList(),
      journals: const IList.empty(),
      children: const IList.empty(),
    );
  }

  IList<JiraAttachmentDto> _filterAttachments(
      IList<JiraAttachmentDto> attachments, JiraMarkupDto? data) {
    return switch (data) {
      null => attachments,
      JiraMarkupTextDto() => attachments,
      JiraMarkupParagraphDto() => data.content.fold(attachments, _filterAttachments),
      JiraMarkupDocDto() => data.content.fold(attachments, _filterAttachments),
      JiraMarkupHardBreakDto() => attachments,
      JiraMarkupMediaSingleDto() => data.content.fold(attachments, _filterAttachments),
      JiraMarkupMediaDto() => attachments.removeWhere((e) => e.filename == data.attrs.alt),
      JiraMarkupMediaInlineDto() => attachments,
      JiraMarkupMentionDto() => attachments,
      JiraMarkupOrderedListDto() => data.content.fold(attachments, _filterAttachments),
      JiraMarkupBulletListDto() => data.content.fold(attachments, _filterAttachments),
      JiraMarkupListItemDto() => data.content.fold(attachments, _filterAttachments),
      JiraMarkupInlineCardDto() => attachments,
      JiraMarkupCodeBlockDto() => data.content.fold(attachments, _filterAttachments),
      JiraMarkupHeadingDto() => data.content.fold(attachments, _filterAttachments),
    };
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
