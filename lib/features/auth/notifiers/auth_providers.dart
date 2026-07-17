import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_service_provider.dart';
import '../../../core/services/storage_service_provider.dart';
import '../repositories/auth_repository.dart';
import '../states/auth_state.dart';
import 'auth_notifier.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final api = ref.watch(apiServiceProvider);
  return AuthRepository(api);
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final storage = ref.watch(storageServiceProvider);
  return AuthNotifier(repository, storage);
});
