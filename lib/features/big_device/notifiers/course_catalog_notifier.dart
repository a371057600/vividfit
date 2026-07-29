import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../../../core/services/storage_service_provider.dart';
import '../data/course_catalog.dart';
import '../repositories/course_catalog_repository.dart';
import '../states/course_catalog_state.dart';

part 'course_catalog_notifier.g.dart';

/// 课程目录 Notifier(Riverpod 3.0 代码生成)。
///
/// 1:1 迁移自旧 `BigCourseHomeController` 的课程列表相关逻辑,
/// 蓝牙部分不迁移。所有 JSON 请求通过 `CourseCatalogRepository`。
@Riverpod(keepAlive: true)
class CourseCatalogNotifier extends _$CourseCatalogNotifier {
  @override
  CourseCatalogState build() => const CourseCatalogState();

  /// 设置设备类型(对应旧 initData 的 newMainSelectType 赋值)。
  void setDeviceType(FtmsDeviceType type) {
    state = state.copyWith(deviceType: type);
  }

  /// 加载课程列表(对应旧 hc.getNewCourseList)。
  ///
  /// 按 deviceType 切换 JSON URL,跑步机特殊处理葡萄牙语。
  Future<void> loadCourses() async {
    state = state.copyWith(isLoading: true, isEmpty: false);
    try {
      final repository = ref.read(courseCatalogRepositoryProvider);
      final storage = ref.read(storageServiceProvider);
      final catalog = await repository.fetchCatalog(
        deviceType: state.deviceType,
        languageNum: storage.languageNum,
      );
      final categories = catalog.categories;
      final empty = categories == null || categories.isEmpty;
      state = state.copyWith(
        catalog: catalog,
        isLoading: false,
        isEmpty: empty,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, isEmpty: true);
      Fluttertoast.showToast(msg: '获取课程列表失败: $e');
    }
  }

  /// 选中某个分类(对应旧 hc.courseTypeSelect.value = index)。
  void selectCategory(int index) {
    state = state.copyWith(selectedCategoryIndex: index);
  }

  /// 选中某个课程(对应旧 hc.bigDeviceCourseDetailIndex.value = index)。
  void selectCourse(int index) {
    state = state.copyWith(selectedCourseIndex: index);
  }

  /// 获取当前分类下的课程列表(对应旧 _buildDataList 的读取逻辑)。
  List<CourseEntry> get currentCourseList {
    final categories = state.catalog?.categories;
    if (categories == null || categories.isEmpty) return [];
    final idx = state.selectedCategoryIndex;
    if (idx < 0 || idx >= categories.length) return [];
    return categories[idx].courseList ?? [];
  }

  /// 获取当前选中课程的 courseId(对应旧 gotoTheCourseDetailPage 的读取)。
  int? get currentCourseId {
    final list = currentCourseList;
    final idx = state.selectedCourseIndex;
    if (idx < 0 || idx >= list.length) return null;
    return list[idx].courseId;
  }
}
