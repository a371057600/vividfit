import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/device_category.dart';
import '../data/entry_card_data.dart';
import '../states/gym_course_home_state.dart';

/// 课程首页状态管理(替代旧 `ControllerBigCourseHome`)。
///
/// 职责:
/// - 根据路由传入的 `deviceCategory` int 初始化 `selectedDeviceCategory`。
/// - 提供 `entryCards` 数据源(5 张默认卡片)。
/// - 提供当前设备类型的中文/英文标题键和背景图解析。
class GymCourseHomeNotifier extends StateNotifier<GymCourseHomeState> {
  GymCourseHomeNotifier() : super(const GymCourseHomeState());

  /// 从路由参数初始化(对应旧 `onInit` 中的 `deviceTypeIndex` 处理)。
  void bootstrap(int deviceCategoryIndex) {
    final category = DeviceCategoryExtension.fromIndex(deviceCategoryIndex);
    state = state.copyWith(
      selectedDeviceCategory: category,
      entryCards: EntryCardData.defaultCards,
    );
  }

  /// 解析指定索引卡片的背景图(对应旧 `setImageaboutFirstScreen`)。
  String resolveCardImage(int dataIndex) {
    return EntryCardData.resolveCardImage(state.selectedDeviceCategory, dataIndex);
  }

  /// 当前设备类型的中文标题 i18n 键(对应旧 `titleList`)。
  String get deviceTitleKey =>
      EntryCardData.deviceTitleKey(state.selectedDeviceCategory);

  /// 当前设备类型的英文标题(对应旧 `enTiltleList`)。
  String get deviceEnglishTitle =>
      EntryCardData.deviceEnglishTitle(state.selectedDeviceCategory);
}
