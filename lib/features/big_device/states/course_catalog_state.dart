import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../data/course_catalog.dart';

part 'course_catalog_state.freezed.dart';

@freezed
abstract class CourseCatalogState with _$CourseCatalogState {
  const factory CourseCatalogState({
    /// 课程目录(对应旧 courseTypeList)。
    CourseCatalog? catalog,

    /// 是否正在加载(对应旧 hc.isLoading)。
    @Default(false) bool isLoading,

    /// 是否为空数据(对应旧 hc.isEmpty)。
    @Default(false) bool isEmpty,

    /// 当前设备类型(对应旧 newMainSelectType,用 FtmsDeviceType 枚举替代 magic number)。
    @Default(FtmsDeviceType.indoorBike) FtmsDeviceType deviceType,

    /// 当前选中的分类索引(对应旧 courseTypeSelect)。
    @Default(0) int selectedCategoryIndex,

    /// 选中的课程索引(对应旧 bigDeviceCourseDetailIndex)。
    @Default(0) int selectedCourseIndex,
  }) = _CourseCatalogState;
}
