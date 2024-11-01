import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/jira/jira_dto.dart';
import 'package:hasd/common/env.dart';

// https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/#api-rest-api-3-search-get
class JiraApi {
  static final _utf8ToBase64 = utf8.fuse(base64);

  final httpClient = Dio(BaseOptions(
    baseUrl: '${Env.jiraApiUrl}/rest/api',
    headers: {
      Headers.contentTypeHeader: Headers.jsonContentType,
      'authorization': 'Basic ${_utf8ToBase64.encode('${Env.jiraEmail}:${Env.jiraApiToken}')}',
    },
  ));

  Future<JiraPage<JiraIssueDto>> searchIssues({String? project, int? maxResults}) async {
    final response = await httpClient.get<Map<String, dynamic>>('/3/search', queryParameters: {
      if (project != null) 'project': project,
      if (maxResults != null) 'maxResults': maxResults,
    });
    return JiraPage.fromJson(response.data!, 'issues', JiraIssueDto.fromJson);
  }

  Future<JiraIssueDto> fetchIssue(String issueIdOrKey) async {
    final response = await httpClient.get<Map<String, dynamic>>('/3/issue/$issueIdOrKey');
    return JiraIssueDto.fromJson(response.data!);
  }

  // Future<Object?> fetchIssueTypes(String issueIdOrKey) async {
  //   final response = await httpClient.get<Map<String, dynamic>>('/3/issue/$issueIdOrKey');
  //   return response.data;
  // }

  Future<Object?> fetchIssueTypes(String issueIdOrKey) async {
    final response = await httpClient.get<Map<String, dynamic>>('/3/issue/$issueIdOrKey');
    return response.data;
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
