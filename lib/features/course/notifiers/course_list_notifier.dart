import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/storage_service.dart';
import '../../../data/models/course_list.dart';
import '../../home/repositories/home_repository.dart';
import '../repositories/course_repository.dart';
import '../states/course_list_state.dart';

/// 课程列表状态机（对应旧 NewCourseListHomeController + NewCourseListController）。
class CourseListNotifier extends StateNotifier<CourseListState> {
  CourseListNotifier(this._repo, this._storage, this._homeRepo)
      : super(const CourseListState()) {
    _initData();
  }

  final CourseRepository _repo;
  // TODO: 接入本地存储后使用
  // ignore: unused_field
  final StorageService _storage;
  final HomeRepository _homeRepo;

  void _initData() {
    Future.delayed(const Duration(milliseconds: 500), () {
      getCourseList();
    });
  }

  /// 切换设备类型并加载对应课程。
  void selectDeviceType(int index) {
    state = state.copyWith(deviceType: index);
    getCourseList();
  }

  /// 获取课程列表。
  Future<void> getCourseList() async {
    final tags = _getTagsForDeviceType(state.deviceType);
    state = state.copyWith(isLoading: true);

    final data = await _repo.getCourseList(tags);

    if (data.code == '200') {
      final newMap = Map<int, CourseList>.from(state.courseDataMap);
      newMap[state.deviceType] = data;
      state = state.copyWith(
        courseDataMap: newMap,
        isLoading: false,
        isFirstIn: false,
      );
    } else {
      // token 过期尝试刷新
      final ok = await _homeRepo.refreshToken();
      if (ok) {
        await getCourseList();
      } else {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  List<int> _getTagsForDeviceType(int deviceType) {
    switch (deviceType) {
      case 0:
        return [1];
      case 1:
        return [3];
      case 2:
        return [3];
      case 3:
        return [7];
      case 4:
        return [6];
      case 5:
        return [8];
      default:
        return [1];
    }
  }

  /// 获取当前设备类型对应的课程列表。
  CourseList? get currentCourseList => state.courseDataMap[state.deviceType];

  /// 设置是否允许跳转游戏页（防重复点击）。
  void setAllowToGamePage(bool value) {
    state = state.copyWith(allowToGamePage: value);
  }
}
