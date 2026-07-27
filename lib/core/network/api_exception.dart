class ApiException implements Exception {
  final String code;
  final String message;
  final dynamic rawError;

  const ApiException({
    required this.code,
    required this.message,
    this.rawError,
  });

  bool get isUnauthorized => code == '401';
  bool get isNetworkError => code == 'NETWORK_ERROR';
  bool get isServerError => code == 'SERVER_ERROR';

  @override
  String toString() => 'ApiException(code: $code, message: $message)';
}
