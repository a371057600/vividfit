import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_constants.dart';
import '../services/storage_service_provider.dart';
import 'api_client.dart';
import 'dio_client.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

part 'network_providers.g.dart';

@Riverpod(keepAlive: true)
DioClient dioClient(Ref ref) {
  final storage = ref.watch(storageServiceProvider);
  return DioClient(
    baseUrl: ApiConstants.baseUrl,
    interceptors: [
      LoggingInterceptor(),
      AuthInterceptor(storage),
      ErrorInterceptor(),
    ],
  );
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  return ApiClient(ref.watch(dioClientProvider).dio);
}
