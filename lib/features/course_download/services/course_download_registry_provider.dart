import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/storage_service_provider.dart';
import '../services/course_download_registry.dart';

part 'course_download_registry_provider.g.dart';

/// 全局单例(keepAlive)。
/// 复用项目 StorageService 持有的 SharedPreferences 实例。
@Riverpod(keepAlive: true)
CourseDownloadRegistry courseDownloadRegistry(Ref ref) {
  final storage = ref.watch(storageServiceProvider);
  return CourseDownloadRegistry(prefs: storage.prefs);
}
