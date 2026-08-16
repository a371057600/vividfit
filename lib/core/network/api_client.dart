import 'package:dio/dio.dart';
import 'package:vividfit_v2/core/constants/api_constants.dart';
import 'api_response.dart';

/// 类型安全的 API 请求客户端。
///
/// 支持两种响应格式：
/// - ResultDto 包装型（标准格式）：使用 get/post/put/delete
/// - 直接返回型（非标准格式）：使用 getRaw/postRaw/putRaw/deleteRaw
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<T> get<T>(
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

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) parser,
  }) async {
    return _request<T>(
      'POST',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      parser: parser,
    );
  }

  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) parser,
  }) async {
    return _request<T>(
      'PUT',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      parser: parser,
    );
  }

  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) parser,
  }) async {
    return _request<T>(
      'DELETE',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      parser: parser,
    );
  }

  // ============ 直接返回型（Raw）方法 ============

  Future<T> getRaw<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) parser,
  }) async {
    return _requestRaw('GET', path,
        queryParameters: queryParameters, options: options, parser: parser);
  }

  Future<T> postRaw<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) parser,
  }) async {
    return _requestRaw('POST', path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        parser: parser);
  }

  Future<T> putRaw<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) parser,
  }) async {
    return _requestRaw('PUT', path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        parser: parser);
  }

  Future<T> deleteRaw<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) parser,
  }) async {
    return _requestRaw('DELETE', path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        parser: parser);
  }

  /// 发送 FormData(文件上传)。支持 PUT/POST,返回原始响应。
  /// 用于头像上传等 multipart 场景,headers 由调用方传入(app_pass + access_token)。
  Future<T> uploadFormData<T>(
    String method,
    String path, {
    required FormData data,
    Map<String, dynamic>? queryParameters,
    required Map<String, String> headers,
    required T Function(dynamic json) parser,
  }) async {
    final url = '${ApiConstants.baseUrl}$path';
    print('📤 Upload: [$method] $url');
    try {
      final response = await _dio.fetch<dynamic>(
        RequestOptions(
          path: url,
          method: method,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
        ),
      );
      print('📥 Upload Response [${response.statusCode}] $url');
      print('📥 Body: ${response.data}');
      return parser(response.data);
    } on DioException catch (e) {
      print('❌ Upload DioError: ${e.message}');
      if (e.response != null) {
        print('❌ Response: ${e.response!.data}');
      }
      rethrow;
    } catch (e) {
      print('❌ Upload UnknownError: $e');
      rethrow;
    }
  }

  // ============ 内部实现 ============

  Future<T> _request<T>(
    String method,
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
    required T Function(dynamic json) parser,
  }) async {
    final url = '${ApiConstants.baseUrl}$path';
    print('📤 Request: [$method] $url');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      print('📤 Query: $queryParameters');
    }
    if (data != null) {
      print('📤 Body: $data');
    }

    try {
      final response = await _dio.fetch<Map<String, dynamic>>(
        RequestOptions(
          path: url,
          method: method,
          queryParameters: queryParameters,
          data: data,
        ),
      );

      final body = response.data;
      print('📥 Response [${response.statusCode}] $url');
      print('📥 Body: $body');

      final apiResponse = ApiResponse<T>.fromJson(body!, parser);
      if (!apiResponse.isSuccess) {
        print('❌ Error: code=${apiResponse.code}, msg=${apiResponse.msg}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: apiResponse.msg,
        );
      }

      return apiResponse.data as T;
    } on DioException catch (e) {
      print('❌ DioError: ${e.message}');
      if (e.response != null) {
        print('❌ Response: ${e.response!.data}');
      }
      rethrow;
    } catch (e) {
      print('❌ UnknownError: $e');
      rethrow;
    }
  }

  Future<T> _requestRaw<T>(
    String method,
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
    required T Function(dynamic json) parser,
  }) async {
    final url = '${ApiConstants.baseUrl}$path';
    print('📤 Request: [$method] $url');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      print('📤 Query: $queryParameters');
    }
    if (data != null) {
      print('📤 Body: $data');
    }

    try {
      final response = await _dio.fetch<dynamic>(
        RequestOptions(
          path: url,
          method: method,
          queryParameters: queryParameters,
          data: data,
        ),
      );

      print('📥 Raw Response [${response.statusCode}] ${response.requestOptions.uri}');
      print('📥 Body: ${response.data}');
      return parser(response.data);
    } on DioException catch (e) {
      print('❌ DioError: ${e.message}');
      if (e.response != null) {
        print('❌ Response: ${e.response!.data}');
      }
      rethrow;
    } catch (e) {
      print('❌ UnknownError: $e');
      rethrow;
    }
  }
}
