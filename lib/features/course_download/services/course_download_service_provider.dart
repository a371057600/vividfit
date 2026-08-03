import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/network_providers.dart';
import 'course_download_service.dart';
import 'course_local_storage_provider.dart';

part 'course_download_service_provider.g.dart';

/// 全局单例(keepAlive)。
@Riverpod(keepAlive: true)
Future<CourseDownloadService> courseDownloadService(Ref ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  final storage = await ref.watch(courseLocalStorageProvider.future);
  return CourseDownloadService(dio: dio, storage: storage);
}
