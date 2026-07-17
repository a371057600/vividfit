import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/home_repository_provider.dart';
import '../../../core/services/storage_service_provider.dart';
import '../notifiers/home_notifier.dart';
import '../states/home_state.dart';

final homeNotifierProvider =
    StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(
    ref.watch(homeRepositoryProvider),
    ref.watch(storageServiceProvider),
  );
});
