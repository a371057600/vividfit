import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_service.dart';
import 'storage_service.dart';

/// StorageService provider。
///
/// **必须在 `main()` 中用 `overrideWithValue` 覆盖**,
/// 因为 StorageService 需要异步初始化,在 ProviderScope 创建前完成。
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError(
    'storageServiceProvider 必须在 main() 中用 overrideWithValue 覆盖',
  );
});

/// ApiService provider(依赖 StorageService)。
final apiServiceProvider = Provider<ApiService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ApiService(storage);
});
