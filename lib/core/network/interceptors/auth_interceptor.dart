import 'package:dio/dio.dart';

import '../../constants/api_constants.dart';
import '../../services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final StorageService _storage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiConstants.headerAppPass] = ApiConstants.appPass;

    final token = _storage.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.headerAccessToken] = token;
    }

    handler.next(options);
  }
}
