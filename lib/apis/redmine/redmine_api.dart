import 'package:dio/dio.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/redmine/redmine_dto.dart';
import 'package:hasd/apis/redmine/redmine_serializable.dart';
import 'package:intl/intl.dart';
import 'package:mekart/mekart.dart';

class RedmineApi {
  static late RedmineApi instance;

  final String _baseUrl;
  final String _apiKey;
  late final Dio httpClient = Dio(BaseOptions(
    baseUrl: _baseUrl,
    headers: {
      ...authorizationHeaders,
      Headers.contentTypeHeader: '${Headers.jsonMimeType}',
      Headers.acceptHeader: '${Headers.jsonMimeType}',
    },
    listFormat: ListFormat.csv,
  ));

  RedmineApi(this._apiKey, this._baseUrl);

  Map<String, String> get authorizationHeaders => {'X-Redmine-API-Key': _apiKey};

  Future<ProjectDto> fetchProject(int id) async {
    final response =
        await httpClient.get<Map<String, dynamic>>('/projects/$id.json', queryParameters: {
      'include': ['time_entry_activities'],
    });
    final data = response.data!['project'] as Map<String, dynamic>;
    // print(jsonEncode(data));
    return ProjectDto.fromJson(data);
  }

  Future<IList<MembershipDto>> fetchProjectMemberships(int id, {int? offset}) async {
    final response = await httpClient
        .get<Map<String, dynamic>>('/projects/$id/memberships.json', queryParameters: {
      'include': ['time_entry_activities'],
      'limit': 100,
      if (offset != null) 'offset': offset,
      'inherited': true,
    });
    final data = response.data!['memberships'] as List<dynamic>;
    // print(jsonEncode(data));
    return data.map((e) => MembershipDto.fromJson(e as Map<String, dynamic>)).toIList();
  }

  Future<IList<IssueDto>> fetchIssues({
    IList<IssueStatusDto> status = const IListConst([]),
    bool isOpen = false,

    /// -1 =me
    required int? assignedToId,
    IList<IssuesExtensions> extensions = const IListConst([]),
  }) async {
    final response = await httpClient.get<Map<String, dynamic>>('/issues.json', queryParameters: {
      'set_filter': 1,
      if (assignedToId != null) 'f[assigned_to_id]': assignedToId < 0 ? '=me' : assignedToId,
      if (status.isNotEmpty || isOpen)
        'f[status_id]': isOpen ? 'o1' : status.map((e) => e.id).join('|'),
      if (extensions.isNotEmpty) 'include': extensions.map((e) => e.code).toList(),
    });
    final issues = response.data!['issues'] as List<dynamic>;
    // print(jsonEncode(issues));
    return issues.map((e) => IssueDto.fromJson(e as Map<String, dynamic>)).toIList();
  }

  Future<IssueDto> fetchIssue(
    int id, {
    IList<IssueExtensions> extensions = const IListConst([]),
  }) async {
    final response =
        await httpClient.get<Map<String, dynamic>>('/issues/$id.json', queryParameters: {
      if (extensions.isNotEmpty) 'include': extensions.map((e) => e.code).toList(),
    });
    final issue = response.data!['issue'] as Map<String, dynamic>;
    // print(jsonEncode(issue));
    return IssueDto.fromJson(issue);
  }

  Future<void> updateIssue(int id, IssueUpdateDto data) async {
    await httpClient.put<Map<String, dynamic>>('/issues/$id.json', data: {
      'issue': data,
    });
  }

  // Future<void> addIssueToFavorites(int id) async {
  //   await httpClient.post<void>('/issues/$id/favorite.json', data: <String, dynamic>{});
  // }
  // Future<void> removeIssueToFavorites(int id) async {
  //   await httpClient.post<void>('/issues/$id/unfavorite.json');
  // }

  Future<IList<IssueStatusDto>> fetchIssueStatutes() async {
    final response = await httpClient.get<Map<String, dynamic>>('/issue_statuses.json');
    final statutes = response.data!['issue_statuses'] as List<dynamic>;
    // print(jsonEncode(statutes));
    return statutes.map((e) => IssueStatusDto.fromJson(e as Map<String, dynamic>)).toIList();
  }

  /// [userId] -1: =me
  Future<IList<TimEntryDto>> fetchTimeEntries({
    int? issueId,
    Date? spentFrom,
    Date? spentTo,
    int? userId,
    int? limit,
    int? offset,
  }) async {
    final filters = <String, dynamic>{
      if (issueId != null) 'f[issue_id]': issueId,
      if (spentFrom != null && spentTo != null) 'f[spent_on]': '$spentFrom|$spentTo',
      if (userId != null) 'f[user_id]': userId < 0 ? '=me' : userId,
    };
    final response =
        await httpClient.get<Map<String, dynamic>>('/time_entries.json', queryParameters: {
      if (filters.isNotEmpty) 'set_filter': 1,
      ...filters,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    });
    final statutes = response.data!['time_entries'] as List<dynamic>;
    // print(jsonEncode(statutes));
    return statutes.map((e) => TimEntryDto.fromJson(e as Map<String, dynamic>)).toIList();
  }

  Future<void> createTimeEntry({
    int? issueId,
    int? activityId,
    required DateTime date,
    required Duration duration,
  }) async {
    await httpClient.post<Map<String, dynamic>>('/time_entries.json', data: {
      'time_entry': {
        if (issueId != null) 'issue_id': issueId,
        if (activityId != null) 'activity_id': activityId,
        'spent_on': DateFormat('yyyy-MM-dd').format(date),
        'hours': const HoursConverter().toJson(duration),
      },
    });
  }

  Uri joinApiKey(Uri uri) => uri.replace(queryParameters: {'key': _apiKey});
}
