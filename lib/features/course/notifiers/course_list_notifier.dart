import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/home_repository_provider.dart';
import '../../../data/models/course_list.dart';
import '../../home/repositories/home_repository.dart';
import '../repositories/course_repository.dart';
import '../states/course_list_state.dart';
import 'course_repository_provider.dart';

part 'course_list_notifier.g.dart';

/// 课程列表状态机（对应旧 NewCourseListHomeController + NewCourseListController）。
@riverpod
class CourseListNotifier extends _$CourseListNotifier {
  @override
  CourseListState build() {
    _repo = ref.watch(courseRepositoryProvider);
    _homeRepo = ref.watch(homeRepositoryProvider);
    Future.delayed(const Duration(milliseconds: 500), () {
      getCourseList();
    });
    return const CourseListState();
  }

  late CourseRepository _repo;
  late HomeRepository _homeRepo;

  void selectDeviceType(int index) {
    state = state.copyWith(deviceType: index);
    getCourseList();
  }

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

  CourseList? get currentCourseList => state.courseDataMap[state.deviceType];

  void setAllowToGamePage(bool value) {
    state = state.copyWith(allowToGamePage: value);
  }
}
