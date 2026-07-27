import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vividfit_v2/core/constants/api_constants.dart';
import 'package:vividfit_v2/core/network/interceptors/auth_interceptor.dart';
import 'package:vividfit_v2/core/services/storage_service.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  late MockStorageService storage;
  late AuthInterceptor interceptor;

  setUp(() {
    storage = MockStorageService();
    interceptor = AuthInterceptor(storage);
  });

  group('AuthInterceptor', () {
    test('adds app_pass and access_token when token exists', () {
      when(() => storage.accessToken).thenReturn('test_token_123');

      final options = RequestOptions(path: '/test');
      final handler = RequestInterceptorHandler();

      interceptor.onRequest(options, handler);

      expect(options.headers[ApiConstants.headerAppPass], ApiConstants.appPass);
      expect(options.headers[ApiConstants.headerAccessToken], 'test_token_123');
    });

    test('adds app_pass but not access_token when token is null', () {
      when(() => storage.accessToken).thenReturn(null);

      final options = RequestOptions(path: '/test');
      final handler = RequestInterceptorHandler();

      interceptor.onRequest(options, handler);

      expect(options.headers[ApiConstants.headerAppPass], ApiConstants.appPass);
      expect(options.headers.containsKey(ApiConstants.headerAccessToken), isFalse);
    });

    test('adds app_pass but not access_token when token is empty', () {
      when(() => storage.accessToken).thenReturn('');

      final options = RequestOptions(path: '/test');
      final handler = RequestInterceptorHandler();

      interceptor.onRequest(options, handler);

      expect(options.headers.containsKey(ApiConstants.headerAccessToken), isFalse);
    });
  });
}
