import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/redmine/redmine_api.dart';
import 'package:hasd/apis/redmine/redmine_dto.dart';
import 'package:hasd/dto/redmine_config_dto.dart';
import 'package:hasd/models/models.dart';
import 'package:hasd/providers/providers.dart';
import 'package:hasd/services/service.dart';
import 'package:mekart/mekart.dart';

class RedmineService implements Service {
  final RedmineConfigDto config;
  late final RedmineApi api = RedmineApi(
    baseUrl: config.baseUrl,
    key: config.apiKey,
  );

  RedmineService(this.config);

  @override
  Map<String, String> get authorizationHeaders => api.authorizationHeaders;

  @override
  Uri joinApiKey(Uri uri) => api.joinApiKey(uri);

  @override
  Future<int> resolveIssueIdentification(String data) async => int.parse(data);

  @override
  Future<ProjectModel> fetchProject(int projectId) async {
    final project = await api.fetchProject(projectId);
    return ProjectModel(
      id: project.id,
      workLogActivities: project.timeEntryActivities,
    );
  }

  @override
  Future<IList<Reference>> fetchProjectMembers(int projectId) async {
    var memberships = const IList<MembershipDto>.empty();
    while (true) {
      final pagedMemberships = await api.fetchProjectMemberships(
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
    final statutes = await api.fetchIssueStatutes();
    return statutes.where((e) => !e.isClosed).map((e) => Reference(e.id, e.name)).toIList();
  }

  @override
  Future<IList<IssueModel>> fetchIssues() async {
    final issues = await api.fetchIssues(
      assignedToId: -1,
      isOpen: true,
      extensions: const IListConst([
        IssuesExtensions.attachments,
        IssuesExtensions.spentTime,
        IssuesExtensions.relations,
      ]),
    );
    return issues.map((issue) => issue.toModel(config)).toIList();
  }

  @override
  Future<IssueModel> fetchIssue(int issueId) async {
    final issue = await api.fetchIssue(
      issueId,
      extensions: const IListConst(IssueExtensions.values),
    );
    return issue.toModel(config);
  }

  @override
  Future<IList<WorkLogModel>> fetchWorkLogs({Date? spentFrom, Date? spentTo, int? issueId}) async {
    final timeEntries = await Providers.fetchAll((limit, offset) async {
      return await api.fetchTimeEntries(
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
    await api.createTimeEntry(
      issueId: issueId,
      activityId: activityId,
      date: started,
      duration: timeSpent.duration,
    );
  }
}

extension on IssueDto {
  IssueModel toModel(RedmineConfigDto config) {
    return IssueModel(
      id: id,
      key: '$id',
      project: project,
      parentId: parentId,
      hrefUrl: '${config.baseUrl}/issues/$id',
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
      key: '$id',
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
