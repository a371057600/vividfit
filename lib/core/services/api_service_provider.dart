import 'package:riverpod/riverpod.dart';

import 'api_service.dart';
import 'storage_service_provider.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ApiService(storage);
});