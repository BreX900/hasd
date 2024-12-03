import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/redmine/redmine_dto.dart';
import 'package:hasd/apis/youtrack/youtrack_api.dart';
import 'package:hasd/dto/youtrack_config_dto.dart';
import 'package:hasd/models/models.dart';
import 'package:hasd/services/service.dart';
import 'package:mekart/mekart.dart';

class YoutrackService implements Service {
  final YoutrackConfigDto config;
  late final YoutrackApi api = YoutrackApi(
    baseUrl: config.baseUrl,
    token: config.apiToken,
  );

  YoutrackService(this.config);

  @override
  Map<String, String> get authorizationHeaders => {};

  @override
  Uri joinApiKey(Uri uri) => throw UnimplementedError();

  @override
  Future<void> createWorkLog({
    required int issueId,
    required int? activityId,
    required DateTime started,
    required WorkDuration timeSpent,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<IList<Reference>> fetchAllIssueStatues() => throw UnimplementedError();

  @override
  Future<IssueModel> fetchIssue(int issueId) => throw UnimplementedError();

  @override
  Future<IList<IssueModel>> fetchIssues() => throw UnimplementedError();

  @override
  Future<ProjectModel> fetchProject(int projectId) => throw UnimplementedError();

  @override
  Future<IList<Reference>> fetchProjectMembers(int projectId) => throw UnimplementedError();

  @override
  Future<IList<WorkLogModel>> fetchWorkLogs({Date? spentFrom, Date? spentTo, int? issueId}) async {
    assert(issueId == null);
    final workLogs = await api.fetchIssueWorkItems(
      startDate: spentFrom,
      endDate: spentTo,
    );

    return workLogs.map((e) {
      return WorkLogModel(
        issueId: -1,
        author: '',
        spentOn: e.date.asDate(),
        timeSpent: e.duration,
        activity: null,
        comments: e.text ?? '',
      );
    }).toIList();
  }

  @override
  Future<int> resolveIssueIdentification(String data) => throw UnimplementedError();
}
