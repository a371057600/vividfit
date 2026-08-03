import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vividfit_v2/core/network/api_client.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late ApiClient apiClient;

  setUpAll(() {
    registerFallbackValue(RequestOptions());
  });

  setUp(() {
    mockDio = MockDio();
    apiClient = ApiClient(mockDio);
  });

  group('ApiClient.get', () {
    test('returns parsed data on success', () async {
      when(() => mockDio.fetch<Map<String, dynamic>>(any())).thenAnswer(
          (_) async => Response(
                data: {'code': '200', 'data': 42},
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final response = await apiClient.get<int>(
        '/test',
        parser: (json) => json as int,
      );

      expect(response, 42);
    });

    test('throws DioException on non-200 code', () async {
      when(() => mockDio.fetch<Map<String, dynamic>>(any())).thenAnswer(
          (_) async => Response(
                data: {'code': '400', 'msg': 'Invalid params'},
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      expect(
        () => apiClient.get<int>('/test', parser: (json) => json as int),
        throwsA(isA<DioException>()),
      );
    });

    test('throws DioException on DioException', () async {
      when(() => mockDio.fetch<Map<String, dynamic>>(any())).thenThrow(
          DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionError,
      ));

      expect(
        () => apiClient.get<int>('/test', parser: (json) => json as int),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('ApiClient.post', () {
    test('returns parsed data on success', () async {
      when(() => mockDio.fetch<Map<String, dynamic>>(any())).thenAnswer(
          (_) async => Response(
                data: {'code': '200', 'data': {'id': 1}},
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final response = await apiClient.post<Map<String, dynamic>>(
        '/test',
        data: {'key': 'value'},
        parser: (json) => json as Map<String, dynamic>,
      );

      expect(response, {'id': 1});
    });
  });

  group('ApiClient.getRaw', () {
    test('returns raw parsed data', () async {
      when(() => mockDio.fetch<dynamic>(any())).thenAnswer((_) async =>
          Response(
            data: {'id': 1, 'name': 'test'},
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      final response = await apiClient.getRaw<Map<String, dynamic>>(
        '/test',
        parser: (json) => json as Map<String, dynamic>,
      );

      expect(response, {'id': 1, 'name': 'test'});
    });
  });
}