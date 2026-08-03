import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'storage_service.dart';

part 'storage_service_provider.g.dart';

@Riverpod(keepAlive: true)
StorageService storageService(Ref ref) {
  throw UnimplementedError(
    'storageServiceProvider 必须在 main() 中用 overrideWithValue 覆盖',
  );
}
