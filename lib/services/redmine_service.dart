import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/redmine/redmine_api.dart';
import 'package:hasd/apis/redmine/redmine_dto.dart';
import 'package:hasd/models/models.dart';
import 'package:hasd/providers/providers.dart';
import 'package:hasd/services/service.dart';
import 'package:mekart/mekart.dart';

class RedmineService implements Service {
  final RedmineApi _redmineApi;

  const RedmineService(this._redmineApi);

  RedmineApi get api => _redmineApi;

  @override
  Map<String, String> get authorizationHeaders => _redmineApi.authorizationHeaders;

  @override
  Uri joinApiKey(Uri uri) => _redmineApi.joinApiKey(uri);

  @override
  Future<ProjectModel> fetchProject(int projectId) async {
    final project = await _redmineApi.fetchProject(projectId);
    return ProjectModel(
      id: project.id,
      workLogActivities: project.timeEntryActivities,
    );
  }

  @override
  Future<IList<Reference>> fetchProjectMembers(int projectId) async {
    var memberships = const IList<MembershipDto>.empty();
    while (true) {
      final pagedMemberships = await _redmineApi.fetchProjectMemberships(
        projectId,
        offset: memberships.length,
      );
      memberships = memberships.addAll(pagedMemberships);
      if (pagedMemberships.length < 100) {
        return memberships
            .mapNonNulls((e) => e.user)
            .toIList()
            .removeDuplicates()
            .sortedBy((e) => e.name)
            .toIList();
      }
    }
  }

  @override
  Future<IList<Reference>> fetchAllIssueStatues() async {
    final statutes = await _redmineApi.fetchIssueStatutes();
    return statutes.where((e) => !e.isClosed).map((e) => Reference(e.id, e.name)).toIList();
  }

  @override
  Future<IList<IssueModel>> fetchIssues() async {
    final issues = await _redmineApi.fetchIssues(
      assignedToId: -1,
      isOpen: true,
      extensions: const IListConst([
        IssuesExtensions.attachments,
        IssuesExtensions.spentTime,
        IssuesExtensions.relations,
      ]),
    );
    return issues.map((issue) => issue.toModel()).toIList();
  }

  @override
  Future<IssueModel> fetchIssue(int issueId) async {
    final issue = await _redmineApi.fetchIssue(
      issueId,
      extensions: const IListConst(IssueExtensions.values),
    );
    return issue.toModel();
  }

  @override
  Future<IList<WorkLogModel>> fetchWorkLogs({Date? spentFrom, Date? spentTo, int? issueId}) async {
    final timeEntries = await Providers.fetchAll((limit, offset) async {
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
      return WorkLogModel(
        issueId: timeEntry.entityId,
        author: timeEntry.user.name,
        spentOn: timeEntry.spentOn,
        timeSpent: timeEntry.hours.workDuration,
        activity: timeEntry.activity.name,
        comments: timeEntry.comments,
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
    await _redmineApi.createTimeEntry(
      issueId: issueId,
      activityId: activityId,
      date: started,
      duration: timeSpent.duration,
    );
  }
}

extension on IssueDto {
  IssueModel toModel() {
    return IssueModel(
      id: id,
      project: project,
      parentId: parentId,
      hrefUrl: hrefUrl,
      status: status,
      author: author,
      assignedTo: assignedTo,
      closedOn: closedOn,
      dueDate: dueDate,
      subject: subject,
      description: description,
      attachments: attachments.map((e) => e.toModel()).toIList(),
      journals: journals,
      children: children.map((e) => e.toModel()).toIList(),
    );
  }
}

extension on IssueChildDto {
  IssueChildModel toModel() {
    return IssueChildModel(
      id: id,
      subject: subject,
      children: children.map((e) => e.toModel()).toIList(),
    );
  }
}

extension on AttachmentDto {
  AttachmentModel toModel() {
    return AttachmentModel(
      filename: filename,
      mimeType: contentType,
      thumbnailUrl: null,
      contentUrl: hrefUrl,
    );
  }
}
