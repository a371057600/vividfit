import 'package:dio/dio.dart';

import '../api_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiException = _convert(err);
    final newError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: apiException,
      message: apiException.message,
    );
    handler.next(newError);
  }

  ApiException _convert(DioException err) {
    final response = err.response;

    if (response != null) {
      final statusCode = response.statusCode;
      final data = response.data;

      String? backendMessage;
      if (data is Map) {
        backendMessage = data['message']?.toString() ?? data['msg']?.toString();
      }

      final message = backendMessage ?? err.message ?? 'HTTP $statusCode error';

      if (statusCode == 401) {
        return ApiException(code: '401', message: message, rawError: err);
      }
      if (statusCode != null && statusCode >= 500) {
        return ApiException(code: 'SERVER_ERROR', message: message, rawError: err);
      }
      return ApiException(code: '$statusCode', message: message, rawError: err);
    }

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          code: 'TIMEOUT',
          message: 'Request timeout: ${err.message}',
          rawError: err,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          code: 'NETWORK_ERROR',
          message: 'Network unavailable: ${err.message}',
          rawError: err,
        );
      default:
        return ApiException(
          code: 'NETWORK_ERROR',
          message: err.message ?? 'Unknown network error',
          rawError: err,
        );
    }
  }
}
