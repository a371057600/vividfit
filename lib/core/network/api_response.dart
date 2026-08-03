import 'package:dio/dio.dart';

class ApiResponse<T> {
  final String code;
  final String? msg;
  final T? data;

  const ApiResponse({
    required this.code,
    this.msg,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) parser,
  ) {
    return ApiResponse(
      code: json['code']?.toString() ?? '',
      msg: json['msg']?.toString(),
      data: json['data'] != null ? parser(json['data']) : null,
    );
  }
}

extension ApiResponseExtension on ApiResponse {
  bool get isSuccess => code == '200';

  String get message => msg ?? '';

  void assertSuccess() {
    if (!isSuccess) {
      throw DioException(
        requestOptions: RequestOptions(),
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: int.tryParse(code),
          data: {'code': code, 'msg': msg},
        ),
        type: DioExceptionType.badResponse,
        error: msg ?? 'Unknown error',
      );
    }
  }
}
