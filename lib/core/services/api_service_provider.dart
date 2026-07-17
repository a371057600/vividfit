import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'api_service.dart';
import 'storage_service_provider.dart';

part 'api_service_provider.g.dart';

@riverpod
ApiService apiService(Ref ref) {
  final storage = ref.watch(storageServiceProvider);
  return ApiService(storage);
}
