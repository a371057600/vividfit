import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_service_provider.dart';
import '../../../core/services/home_repository_provider.dart';
import '../../../core/services/storage_service_provider.dart';
import '../repositories/course_repository.dart';
import '../states/course_detail_state.dart';
import '../states/course_list_state.dart';
import 'course_detail_notifier.dart';
import 'course_list_notifier.dart';

export 'course_list_notifier.dart';
export 'course_detail_notifier.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository(
    ref.read(apiServiceProvider),
    ref.read(storageServiceProvider),
  );
});

final courseListNotifierProvider =
    StateNotifierProvider<CourseListNotifier, CourseListState>((ref) {
  return CourseListNotifier(
    ref.read(courseRepositoryProvider),
    ref.read(storageServiceProvider),
    ref.read(homeRepositoryProvider),
  );
});

final courseDetailNotifierProvider =
    StateNotifierProvider<CourseDetailNotifier, CourseDetailState>((ref) {
  return CourseDetailNotifier(
    ref.read(courseRepositoryProvider),
    ref.read(storageServiceProvider),
    ref.read(homeRepositoryProvider),
  );
});
