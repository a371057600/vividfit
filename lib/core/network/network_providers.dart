import 'package:riverpod/riverpod.dart';

import '../constants/api_constants.dart';
import '../services/storage_service_provider.dart';
import 'api_client.dart';
import 'dio_client.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return DioClient(
    baseUrl: ApiConstants.baseUrl,
    interceptors: [
      LoggingInterceptor(),
      AuthInterceptor(storage),
      ErrorInterceptor(),
    ],
  );
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioClientProvider).dio);
});
