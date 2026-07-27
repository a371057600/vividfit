import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/core/network/api_exception.dart';
import 'package:vividfit_v2/core/network/interceptors/error_interceptor.dart';

void main() {
  late ErrorInterceptor interceptor;

  setUp(() {
    interceptor = ErrorInterceptor();
  });

  group('ErrorInterceptor', () {
    test('converts 401 response to ApiException with code 401', () {
      final requestOptions = RequestOptions(path: '/test');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response(
          statusCode: 401,
          requestOptions: requestOptions,
          data: {'message': 'Token expired'},
        ),
        type: DioExceptionType.badResponse,
      );

      final handler = _TestErrorHandler();
      interceptor.onError(error, handler);

      final apiError = handler.error!.error as ApiException;
      expect(apiError.code, '401');
      expect(apiError.message, 'Token expired');
      expect(apiError.isUnauthorized, isTrue);
    });

    test('converts timeout to TIMEOUT ApiException', () {
      final requestOptions = RequestOptions(path: '/test');
      final error = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionTimeout,
        message: 'Connection timeout',
      );

      final handler = _TestErrorHandler();
      interceptor.onError(error, handler);

      final apiError = handler.error!.error as ApiException;
      expect(apiError.code, 'TIMEOUT');
      expect(apiError.message, contains('Connection timeout'));
    });

    test('converts connection error to NETWORK_ERROR', () {
      final requestOptions = RequestOptions(path: '/test');
      final error = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionError,
        message: 'No internet',
      );

      final handler = _TestErrorHandler();
      interceptor.onError(error, handler);

      final apiError = handler.error!.error as ApiException;
      expect(apiError.code, 'NETWORK_ERROR');
      expect(apiError.isNetworkError, isTrue);
    });

    test('converts 500 response to SERVER_ERROR', () {
      final requestOptions = RequestOptions(path: '/test');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response(
          statusCode: 500,
          requestOptions: requestOptions,
          data: {'message': 'Internal error'},
        ),
        type: DioExceptionType.badResponse,
      );

      final handler = _TestErrorHandler();
      interceptor.onError(error, handler);

      final apiError = handler.error!.error as ApiException;
      expect(apiError.code, 'SERVER_ERROR');
      expect(apiError.message, 'Internal error');
    });

    test('reads msg field as fallback when message is absent', () {
      final requestOptions = RequestOptions(path: '/test');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response(
          statusCode: 400,
          requestOptions: requestOptions,
          data: {'msg': 'Bad params'},
        ),
        type: DioExceptionType.badResponse,
      );

      final handler = _TestErrorHandler();
      interceptor.onError(error, handler);

      final apiError = handler.error!.error as ApiException;
      expect(apiError.message, 'Bad params');
    });
  });
}

class _TestErrorHandler extends ErrorInterceptorHandler {
  DioException? error;

  @override
  void next(DioException err) {
    error = err;
  }

  @override
  void resolve(Response response) {}

  @override
  void reject(DioException err, [bool callFollowingErrorInterceptor = false]) {
    error = err;
  }
}
