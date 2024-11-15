import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/jira/jira_dto.dart';
import 'package:hasd/apis/youtrack/youtrack_dto.dart';
import 'package:hasd/common/env.dart';
import 'package:mekart/mekart.dart';

class YoutrackApi {
  static YoutrackApi? instance;

  final Dio _httpClient;

  YoutrackApi(String apiToken)
      : _httpClient = Dio(BaseOptions(
          // ignore: avoid_redundant_argument_values
          baseUrl: Env.youtrackApiUrl,
          headers: {
            'authorization': 'Bearer $apiToken',
            Headers.acceptHeader: '${Headers.jsonMimeType}',
            Headers.contentTypeHeader: '${Headers.jsonMimeType}',
          },
        ));

  Future<IList<IssueWorkItemDto>> fetchIssueWorkItems({
    Date? startDate,
    Date? endDate,
  }) async {
    final response = await _httpClient.get<List<Object?>>(
      '/workItems',
      queryParameters: youtrackConverters.encodeQueryParameters({
        'fields':
            'created,duration(presentation,minutes),author(name),creator(name),date,id,issue(project(id,name))',
        'startDate': startDate,
        'endDate': endDate,
        'author': 'me',
        // '\$top': 3,
      }),
    );
    return response.data!.map((e) {
      return IssueWorkItemDto.fromJson(e! as Map<String, dynamic>);
    }).toIList();
  }

  Future<void> createIssueWorkItem(String issueId, IssueWorkItemCreateDto data) async {
    final response = await _httpClient.post('/issues/$issueId/timeTracking/workItems', data: data);
    // ignore: avoid_print
    print(jsonEncode(response.data));
  }
}
