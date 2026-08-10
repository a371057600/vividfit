import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'privacy_service.dart';
import 'storage_service_provider.dart';

part 'privacy_service_provider.g.dart';

@Riverpod(keepAlive: true)
PrivacyService privacyService(Ref ref) {
  final storage = ref.watch(storageServiceProvider);
  return PrivacyService(storage);
}
