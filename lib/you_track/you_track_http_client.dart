import 'package:dio/dio.dart';

abstract class ApiClient {
  Future<T> request<T>(
    String method,
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? data,
  });
}

class DioApiClient implements ApiClient {
  final Dio _dio;

  DioApiClient([Dio? dio]) : _dio = dio ?? Dio();

  @override
  Future<T> request<T>(
    String method,
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? data,
  }) async {
    final response = await _dio.request(
      path,
      queryParameters: queryParams,
      data: data,
      options: Options(method: method),
    );
    return response.data;
  }
}
