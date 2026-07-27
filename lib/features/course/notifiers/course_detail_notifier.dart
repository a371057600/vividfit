import 'package:riverpod/riverpod.dart';

import '../../../core/services/home_repository_provider.dart';
import '../../home/repositories/home_repository.dart';
import '../repositories/course_repository.dart';
import '../states/course_detail_state.dart';
import 'course_repository_provider.dart';

class CourseDetailNotifier extends Notifier<CourseDetailState> {
  @override
  CourseDetailState build() {
    _repo = ref.watch(courseRepositoryProvider);
    _homeRepo = ref.watch(homeRepositoryProvider);
    _checkVersion();
    return const CourseDetailState();
  }

  late CourseRepository _repo;
  late HomeRepository _homeRepo;

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
    state = state.copyWith(isNeedUpdate: true);
  }

  void _determineDeviceAvailability() {
    state = state.copyWith(playWithDevice: false);
  }

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

  Future<void> startAction() async {
    if (state.isNeedUpdate) {
      state = state.copyWith(isDownloading: true, downloadProgress: 0);
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(
        isDownloading: false,
        downloadProgress: 100,
        isNeedUpdate: false,
      );
    }
  }

  void cancelDownload() {
    state = state.copyWith(isDownloading: false, downloadProgress: 0);
  }

  void loadActionImages(int index) {
    state = state.copyWith(
      isPlaying: !state.isPlaying,
      selectedActionIndex: index,
    );
  }
}