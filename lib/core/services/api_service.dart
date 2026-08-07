import 'dart:convert';

import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import 'storage_service.dart';

/// Dio 封装(迁移自旧项目 dio_util.dart)。
///
/// 默认 headers 含 `access_token` + `app_pass`,与旧实现一致。
/// 错误时返回 `{'error': ...}` 而非抛异常,与旧 DioUtil 行为对齐,
/// 由上层(AuthRepository / AuthNotifier)判断返回值。
class ApiService {
  ApiService(this._storage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: <String, Object>{
          ApiConstants.headerAccessToken: _storage.accessToken ?? '',
          ApiConstants.headerAppPass: ApiConstants.appPass,
        },
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );
  }

  final StorageService _storage;
  late final Dio _dio;

  /// 登录成功后更新内存中的 access_token header。
  void updateAccessToken(String? token) {
    _dio.options.headers[ApiConstants.headerAccessToken] = token ?? '';
  }

  /// POST 请求。
  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        url,
        queryParameters: queryParameters,
        data: data,
        options: options,
      );
      return _asMap(response.data);
    } on DioException catch (e) {
      return {'error': e.message ?? 'Network error'};
    }
  }

  /// GET 请求。
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
      );
      return _asMap(response.data);
    } on DioException catch (e) {
      return {'error': e.message ?? 'Network error'};
    }
  }

  /// PUT 请求(旧项目修改密码等用)。
  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        url,
        queryParameters: queryParameters,
        data: data,
        options: options,
      );
      return _asMap(response.data);
    } on DioException catch (e) {
      return {'error': e.message ?? 'Network error'};
    }
  }

  /// 带 access_token 的 GET(用于需要登录的接口)。
  Future<Map<String, dynamic>> authedGet(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final token = _storage.accessToken;
    final resp = await _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(
        headers: {
          ApiConstants.headerAppPass: ApiConstants.appPass,
          if (token != null) ApiConstants.headerAccessToken: token,
        },
      ),
    );
    return resp.data as Map<String, dynamic>;
  }

  /// 带 access_token 的 PUT。
  Future<Map<String, dynamic>> authedPut(String path, {dynamic data}) async {
    final token = _storage.accessToken;
    final resp = await _dio.put(
      path,
      data: data,
      options: Options(
        headers: {
          ApiConstants.headerAppPass: ApiConstants.appPass,
          if (token != null) ApiConstants.headerAccessToken: token,
        },
      ),
    );
    return resp.data as Map<String, dynamic>;
  }

  /// 把 dio 返回的 dynamic 统一转成 `Map<String, dynamic>`。
  /// 兼容 Map / JSON 字符串 / 空内容三种情况。
  Map<String, dynamic> _asMap(dynamic raw) {
    if (raw is Map) return Map<String, dynamic>.from(raw);
    if (raw is String) {
      if (raw.isEmpty) return {};
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {
        return {'error': 'Invalid response: $raw'};
      }
    }
    return {};
  }
}
