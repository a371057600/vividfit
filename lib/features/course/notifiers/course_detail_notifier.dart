import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/storage_service.dart';
import '../../home/repositories/home_repository.dart';
import '../repositories/course_repository.dart';
import '../states/course_detail_state.dart';

/// 课程详情状态机（对应旧 NewCourseDetailControler）。
class CourseDetailNotifier extends StateNotifier<CourseDetailState> {
  CourseDetailNotifier(this._repo, this._storage, this._homeRepo)
      : super(const CourseDetailState()) {
    _checkVersion();
  }

  final CourseRepository _repo;
  // TODO: 接入本地存储后使用
  // ignore: unused_field
  final StorageService _storage;
  final HomeRepository _homeRepo;

  /// 从路由参数初始化课程基础信息。
  void initFromArguments(Map<String, dynamic> args) {
    state = state.copyWith(
      courseIndex: args['courseIndex'] as int? ?? 0,
      courseId: args['courseId']?.toString() ?? '',
      courseTitle: args['courseTitle']?.toString() ?? '',
      courseCover: args['courseCover']?.toString() ?? '',
      version: args['version'] as int? ?? 0,
      proposal: args['proposal']?.toString() ?? '',
      describe: args['describe']?.toString() ?? '',
      carefulthing: args['carefulthing']?.toString() ?? '',
      interactiveEquipment: args['interactiveEquipment'] as int? ?? 0,
    );
    getCourseDetailData();
  }

  /// 获取课程动作详情。
  Future<void> getCourseDetailData() async {
    if (state.courseId.isEmpty) return;
    state = state.copyWith(isActionDataLoading: true);

    final detail = await _repo.getCourseDetail(state.courseId);
    if (detail.code == '200') {
      state = state.copyWith(
        courseDetail: detail,
        isActionDataLoading: false,
      );
      _determineDeviceAvailability();
    } else {
      final ok = await _homeRepo.refreshToken();
      if (ok) {
        await getCourseDetailData();
      } else {
        state = state.copyWith(isActionDataLoading: false);
      }
    }
  }

  void _checkVersion() {
    // TODO: 接入本地存储的课程版本检测
    state = state.copyWith(isNeedUpdate: true);
  }

  void _determineDeviceAvailability() {
    // TODO: 检测已连接设备是否匹配当前课程
    state = state.copyWith(playWithDevice: false);
  }

  /// 判断动作列表是否全部相同（用于 UI 折叠展示）。
  bool areAllElementsSame() {
    final data = state.courseDetail?.data;
    if (data == null || data.length < 2) return true;
    final first = data[1].actionName;
    for (int i = 1; i < data.length; i++) {
      if (data[i].actionName != first && data[i].actionType != -1) {
        return false;
      }
    }
    return true;
  }

  /// 开始下载/播放按钮点击。
  Future<void> startAction() async {
    if (state.isNeedUpdate) {
      // TODO: 实现下载逻辑（下载 zip、解压、下载 bgm）
      state = state.copyWith(isDownloading: true, downloadProgress: 0);
      // 模拟下载完成
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(
        isDownloading: false,
        downloadProgress: 100,
        isNeedUpdate: false,
      );
    } else {
      // TODO: 跳转到课程播放页
    }
  }

  /// 取消下载。
  void cancelDownload() {
    state = state.copyWith(isDownloading: false, downloadProgress: 0);
  }

  /// 获取动作图片路径（底部 sheet 用）。
  void loadActionImages(int index) {
    // TODO: 加载本地解压后的动作图片列表
    state = state.copyWith(
      isPlaying: !state.isPlaying,
      selectedActionIndex: index,
    );
  }
}
