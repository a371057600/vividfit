import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vividfit_v2/core/network/api_client.dart';
import 'package:vividfit_v2/core/network/api_exception.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late ApiClient apiClient;

  setUp(() {
    mockDio = MockDio();
    apiClient = ApiClient(mockDio);
  });

  group('ApiClient.get', () {
    test('returns ApiResponse on success', () async {
      when(() => mockDio.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      )).thenAnswer((_) async => Response(
            data: {'code': '200', 'data': 42},
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      final response = await apiClient.get<int>(
        '/test',
        parser: (json) => json as int,
      );

      expect(response.isSuccess, isTrue);
      expect(response.data, 42);
    });

    test('returns error ApiResponse when backend returns non-200', () async {
      when(() => mockDio.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      )).thenAnswer((_) async => Response(
            data: {'code': '400', 'message': 'Invalid params'},
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      final response = await apiClient.get<int>(
        '/test',
        parser: (json) => json as int,
      );

      expect(response.isSuccess, isFalse);
      expect(response.code, '400');
      expect(response.message, 'Invalid params');
    });

    test('throws ApiException on DioException', () async {
      when(() => mockDio.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionError,
      ));

      expect(
        () => apiClient.get<int>('/test', parser: (json) => json as int),
        throwsA(isA<ApiException>()),
      );
    });

    test('throws ApiException on non-JSON response', () async {
      when(() => mockDio.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      )).thenAnswer((_) async => Response(
            data: 'plain text',
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      expect(
        () => apiClient.get<int>('/test', parser: (json) => json as int),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('ApiClient.post', () {
    test('returns ApiResponse on success', () async {
      when(() => mockDio.post(
        any(),
        queryParameters: any(named: 'queryParameters'),
        data: any(named: 'data'),
        options: any(named: 'options'),
      )).thenAnswer((_) async => Response(
            data: {'code': '200', 'data': {'id': 1}},
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      final response = await apiClient.post<Map<String, dynamic>>(
        '/test',
        data: {'key': 'value'},
        parser: (json) => json as Map<String, dynamic>,
      );

      expect(response.isSuccess, isTrue);
      expect(response.data, {'id': 1});
    });
  });

  group('ApiClient.put', () {
    test('returns ApiResponse on success', () async {
      when(() => mockDio.put(
        any(),
        queryParameters: any(named: 'queryParameters'),
        data: any(named: 'data'),
        options: any(named: 'options'),
      )).thenAnswer((_) async => Response(
            data: {'code': '200'},
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      final response = await apiClient.put<Map<String, dynamic>>(
        '/test',
        parser: (json) => json as Map<String, dynamic>,
      );

      expect(response.isSuccess, isTrue);
    });
  });
}
