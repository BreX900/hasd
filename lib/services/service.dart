import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/redmine/redmine_dto.dart';
import 'package:hasd/models/models.dart';
import 'package:mekart/mekart.dart';

abstract interface class Service {
  static late Service instance;

  Map<String, String> get authorizationHeaders;

  Uri joinApiKey(Uri uri) => uri;

  Future<int> resolveIssueIdentification(String data);

  Future<ProjectModel> fetchProject(int projectId);

  Future<IList<Reference>> fetchProjectMembers(int projectId);

  Future<IList<Reference>> fetchAllIssueStatues();

  Future<IList<IssueModel>> fetchIssues();

  Future<IssueModel> fetchIssue(int issueId);

  Future<IList<WorkLogModel>> fetchWorkLogs({Date? spentFrom, Date? spentTo, int? issueId});

  Future<void> createWorkLog({
    required int issueId,
    required int? activityId,
    required DateTime started,
    required WorkDuration timeSpent,
  });
}
