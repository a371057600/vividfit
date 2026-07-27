import 'package:riverpod/riverpod.dart';

import '../../../core/services/api_service_provider.dart';
import '../../../core/services/storage_service_provider.dart';
import '../repositories/course_repository.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository(
    ref.watch(apiServiceProvider),
    ref.watch(storageServiceProvider),
  );
});