import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/core/network/interceptors/logging_interceptor.dart';

void main() {
  late LoggingInterceptor interceptor;

  setUp(() {
    interceptor = LoggingInterceptor();
  });

  group('LoggingInterceptor', () {
    test('onRequest prints request info and calls next', () {
      final options = RequestOptions(path: '/test', method: 'GET');
      final handler = _TestRequestHandler();

      interceptor.onRequest(options, handler);

      expect(handler.nextCalled, isTrue);
    });

    test('onResponse prints response info and calls next', () {
      final response = Response(
        data: {'code': '200'},
        statusCode: 200,
        requestOptions: RequestOptions(path: '/test'),
      );
      final handler = _TestResponseHandler();

      interceptor.onResponse(response, handler);

      expect(handler.nextCalled, isTrue);
    });

    test('onError prints error info and calls next', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );
      final handler = _TestErrorHandler();

      interceptor.onError(error, handler);

      expect(handler.nextCalled, isTrue);
    });
  });
}

class _TestRequestHandler extends RequestInterceptorHandler {
  bool nextCalled = false;

  @override
  void next(RequestOptions requestOptions) {
    nextCalled = true;
  }
}

class _TestResponseHandler extends ResponseInterceptorHandler {
  bool nextCalled = false;

  @override
  void next(Response response) {
    nextCalled = true;
  }
}

class _TestErrorHandler extends ErrorInterceptorHandler {
  bool nextCalled = false;

  @override
  void next(DioException err) {
    nextCalled = true;
  }
}
