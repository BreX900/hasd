import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/jira/jira_dto.dart';
import 'package:hasd/common/env.dart';
import 'package:hasd/models/models.dart';

class JqlSpec {}

class JqlFilter implements JqlSpec {
  final String field;
  final String operator;
  final String value;

  JqlFilter(this.field, {required String equalTo})
      : operator = '=',
        value = equalTo;

  @override
  String toString() => '$field $operator "$value"';
}

class JqlExpression implements JqlSpec {}

// https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/#api-rest-api-3-search-get
class JiraApi {
  static final _utf8ToBase64 = utf8.fuse(base64);
  static final JiraApi instance = JiraApi._();

  final httpClient = Dio(BaseOptions(
    baseUrl: '${Env.jiraApiUrl}/rest/api',
    headers: {
      Headers.contentTypeHeader: Headers.jsonContentType,
      'authorization': 'Basic ${_utf8ToBase64.encode('${Env.jiraEmail}:${Env.jiraApiToken}')}',
    },
  ));

  JiraApi._();

  Future<UserDto> fetchCurrentUser(String username) async {
    final response = await httpClient.get<Map<String, dynamic>>('/3/myself');
    return UserDto.fromJson(response.data!);
  }

  Future<JiraProjectDto> fetchProject(IdOrUid projectIdOrKey) async {
    final response = await httpClient.get<Map<String, dynamic>>('/3/project/$projectIdOrKey');
    return JiraProjectDto.fromJson(response.data!);
  }

  Future<IList<UserDto>> fetchProjectMembers({
    required String accountId,
    required ISet<String> projectKeys,
  }) async {
    print({
      'accountId': accountId,
      'projectKeys': projectKeys.join(','),
    });
    final response = await httpClient
        .get<List<dynamic>>('/3/user/assignable/multiProjectSearch', queryParameters: {
      'accountId': accountId,
      'projectKeys': projectKeys.join(','),
    });
    return response.data!.map((e) => UserDto.fromJson(e as Map<String, dynamic>)).toIList();
  }

  Future<JiraPageV2<JiraIssueDto>> searchIssues({
    JqlSpec? jql,
    String? orderBy, // created
    bool descending = false,
    int? maxResults,
  }) async {
    final response = await httpClient.get<Map<String, dynamic>>('/3/search/jql', queryParameters: {
      if (jql != null)
        'jql': '$jql${orderBy != null ? ' ORDER BY $orderBy ${descending ? 'DESC' : 'ASC'}' : ''}',
      if (maxResults != null) 'maxResults': maxResults,
      'fields': '*all',
    });
    return JiraPageV2.fromJson(response.data!, 'issues', JiraIssueDto.fromJson);
  }

  Future<JiraIssueDto> fetchIssue(IdOrUid issueIdOrKey) async {
    final response = await httpClient.get<Map<String, dynamic>>('/3/issue/$issueIdOrKey');
    return JiraIssueDto.fromJson(response.data!);
  }

  Future<IList<JiraIssueStatusDto>> fetchIssueStatutes() async {
    final response = await httpClient.get<List<dynamic>>('/3/status');
    return response.data!.map((e) {
      return JiraIssueStatusDto.fromJson(e as Map<String, dynamic>);
    }).toIList();
  }

  Future<JiraPage<JiraWorkLogDto>> fetchWorkLogs(String issueIdOrKey) async {
    final response = await httpClient.get<Map<String, dynamic>>('/3/issue/$issueIdOrKey/worklog');
    return JiraPage.fromJson(response.data!, 'worklogs', JiraWorkLogDto.fromJson);
  }

  Future<IList<JiraWorkLogDto>> fetchWorkLogsByIds(IList<int> ids) async {
    final response = await httpClient.post<List<dynamic>>('/3/worklog/list', data: {
      'ids': ids.unlockView,
    });
    return response.data!.map((e) => JiraWorkLogDto.fromJson(e as Map<String, dynamic>)).toIList();
  }

  Future<IList<int>> fetchWorkLogsBySince({required DateTime? since}) async {
    final response =
        await httpClient.get<Map<String, dynamic>>('/3/worklog/updated', queryParameters: {
      if (since != null) 'since': since.millisecondsSinceEpoch,
    });
    final values = response.data!['values'] as List<dynamic>;
    return values.map((data) {
      data as Map<String, dynamic>;
      return data['worklogId'] as int;
    }).toIList();
  }
}
