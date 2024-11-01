import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hasd/apis/youtrack/youtrack_dto.dart';
import 'package:hasd/common/env.dart';

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

  ///
  Future<void> createIssueWorkItem(String issueId, IssueWorkItemDto data) async {
    final response = await _httpClient.post('/issues/$issueId/timeTracking/workItems', data: data);
    // ignore: avoid_print
    print(jsonEncode(response.data));
  }
}
