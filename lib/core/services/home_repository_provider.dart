import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/home/repositories/home_repository.dart';
import 'api_service_provider.dart';
import 'storage_service_provider.dart';

part 'home_repository_provider.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository(
    ref.watch(apiServiceProvider),
    ref.watch(storageServiceProvider),
  );
}
