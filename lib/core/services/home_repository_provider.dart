import 'package:riverpod/riverpod.dart';

import '../../features/home/repositories/home_repository.dart';
import 'api_service_provider.dart';
import 'storage_service_provider.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(
    ref.watch(apiServiceProvider),
    ref.watch(storageServiceProvider),
  );
});