import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'api_response.dart';

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) parser,
  }) async {
    return _request<T>(
      'GET',
      path,
      queryParameters: queryParameters,
      options: options,
      parser: parser,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    Options? options,
    required T Function(dynamic json) parser,
  }) async {
    return _request<T>(
      'POST',
      path,
      queryParameters: queryParameters,
      data: data,
      options: options,
      parser: parser,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    Options? options,
    required T Function(dynamic json) parser,
  }) async {
    return _request<T>(
      'PUT',
      path,
      queryParameters: queryParameters,
      data: data,
      options: options,
      parser: parser,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    Options? options,
    required T Function(dynamic json) parser,
  }) async {
    return _request<T>(
      'DELETE',
      path,
      queryParameters: queryParameters,
      data: data,
      options: options,
      parser: parser,
    );
  }

  Future<ApiResponse<T>> _request<T>(
    String method,
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    Options? options,
    required T Function(dynamic json) parser,
  }) async {
    try {
      late final Response<dynamic> response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _dio.get(
            path,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case 'POST':
          response = await _dio.post(
            path,
            queryParameters: queryParameters,
            data: data,
            options: options,
          );
          break;
        case 'PUT':
          response = await _dio.put(
            path,
            queryParameters: queryParameters,
            data: data,
            options: options,
          );
          break;
        case 'DELETE':
          response = await _dio.delete(
            path,
            queryParameters: queryParameters,
            data: data,
            options: options,
          );
          break;
        default:
          throw UnsupportedError('HTTP method $method not supported');
      }

      final rawData = response.data;
      if (rawData is! Map<String, dynamic>) {
        throw const ApiException(
          code: 'INVALID_RESPONSE',
          message: 'Response body is not a JSON object',
        );
      }

      return ApiResponse<T>.fromJson(rawData, parser);
    } on DioException catch (e) {
      final apiError = e.error;
      if (apiError is ApiException) {
        rethrow;
      }
      throw ApiException(
        code: 'NETWORK_ERROR',
        message: e.message ?? 'Network request failed',
        rawError: e,
      );
    }
  }
}
