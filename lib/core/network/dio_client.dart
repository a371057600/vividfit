import 'package:dio/dio.dart';

class DioClient {
  DioClient({
    required String baseUrl,
    required List<Interceptor> interceptors,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout ?? const Duration(seconds: 10),
        receiveTimeout: receiveTimeout ?? const Duration(seconds: 15),
        sendTimeout: sendTimeout,
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.addAll(interceptors);
  }

  late final Dio _dio;

  Dio get dio => _dio;
}
