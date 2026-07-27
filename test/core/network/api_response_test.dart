import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/core/network/api_response.dart';
import 'package:vividfit_v2/core/network/api_response_extension.dart';
import 'package:vividfit_v2/core/network/api_exception.dart';

void main() {
  group('ApiResponse', () {
    test('fromJson parses success response with data', () {
      final response = ApiResponse<Map<String, dynamic>>.fromJson(
        {'code': '200', 'data': {'id': 1}, 'message': 'ok'},
        (json) => json as Map<String, dynamic>,
      );
      expect(response.code, '200');
      expect(response.isSuccess, isTrue);
      expect(response.data, {'id': 1});
      expect(response.message, 'ok');
    });

    test('fromJson parses error response without data', () {
      final response = ApiResponse<Map<String, dynamic>>.fromJson(
        {'code': '500', 'message': 'server error'},
        (json) => json as Map<String, dynamic>,
      );
      expect(response.code, '500');
      expect(response.isSuccess, isFalse);
      expect(response.data, isNull);
    });

    test('fromJson handles null data', () {
      final response = ApiResponse<Map<String, dynamic>>.fromJson(
        {'code': '200'},
        (json) => json as Map<String, dynamic>,
      );
      expect(response.data, isNull);
      expect(response.isSuccess, isTrue);
    });
  });

  group('ApiResponseX.getOrThrow', () {
    test('returns data when success', () {
      const response = ApiResponse<int>(code: '200', data: 42);
      expect(response.getOrThrow(), 42);
    });

    test('throws ApiException when code is not 200', () {
      const response = ApiResponse<int>(code: '400', message: 'bad request');
      expect(() => response.getOrThrow(), throwsA(isA<ApiException>()));
    });

    test('throws ApiException when data is null', () {
      const response = ApiResponse<int>(code: '200');
      expect(() => response.getOrThrow(), throwsA(isA<ApiException>()));
    });
  });
}
