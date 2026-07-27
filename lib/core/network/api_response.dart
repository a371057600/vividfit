class ApiResponse<T> {
  final String code;
  final String? message;
  final T? data;

  const ApiResponse({
    required this.code,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) parser,
  ) {
    return ApiResponse(
      code: json['code']?.toString() ?? '',
      message: json['message']?.toString(),
      data: json['data'] != null ? parser(json['data']) : null,
    );
  }

  bool get isSuccess => code == '200';

  @override
  String toString() =>
      'ApiResponse(code: $code, message: $message, data: $data)';
}
