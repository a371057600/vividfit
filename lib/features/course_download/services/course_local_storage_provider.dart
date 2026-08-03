import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'course_local_storage.dart';

part 'course_local_storage_provider.g.dart';

/// 全局单例(keepAlive)。
/// 用 FutureProvider 因依赖 getApplicationDocumentsDirectory 异步。
@Riverpod(keepAlive: true)
Future<CourseLocalStorage> courseLocalStorage(Ref ref) async {
  final storage = await CourseLocalStorage.create();
  await storage.ensureCourseDirs();
  return storage;
}
