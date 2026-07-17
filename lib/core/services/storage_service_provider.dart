import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'storage_service.dart';

part 'storage_service_provider.g.dart';

/// StorageService provider。
///
/// **必须在 `main()` 中用 `overrideWithValue` 覆盖**,
/// 因为 StorageService 需要异步初始化,在 ProviderScope 创建前完成。
@Riverpod(keepAlive: true)
StorageService storageService(Ref ref) {
  throw UnimplementedError(
    'storageServiceProvider 必须在 main() 中用 overrideWithValue 覆盖',
  );
}
