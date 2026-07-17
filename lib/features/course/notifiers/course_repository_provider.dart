import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/api_service_provider.dart';
import '../../../core/services/storage_service_provider.dart';
import '../repositories/course_repository.dart';

part 'course_repository_provider.g.dart';

@riverpod
CourseRepository courseRepository(Ref ref) {
  return CourseRepository(
    ref.watch(apiServiceProvider),
    ref.watch(storageServiceProvider),
  );
}
