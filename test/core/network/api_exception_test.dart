import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/core/network/api_exception.dart';

void main() {
  group('ApiException', () {
    test('constructs with required fields', () {
      const e = ApiException(code: '401', message: 'Unauthorized');
      expect(e.code, '401');
      expect(e.message, 'Unauthorized');
      expect(e.isUnauthorized, isTrue);
      expect(e.isNetworkError, isFalse);
    });

    test('identifies network error', () {
      const e = ApiException(code: 'NETWORK_ERROR', message: 'No connection');
      expect(e.isNetworkError, isTrue);
      expect(e.isServerError, isFalse);
    });

    test('identifies server error', () {
      const e = ApiException(code: 'SERVER_ERROR', message: 'Server down');
      expect(e.isServerError, isTrue);
    });

    test('toString contains code and message', () {
      const e = ApiException(code: '400', message: 'Bad request');
      expect(e.toString(), contains('400'));
      expect(e.toString(), contains('Bad request'));
    });
  });
}
