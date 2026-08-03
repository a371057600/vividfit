import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/course_list.dart';
import '../states/course_list_state.dart';

part 'course_list_notifier.g.dart';

@riverpod
class CourseListNotifier extends _$CourseListNotifier {
  @override
  CourseListState build() {
    return const CourseListState();
  }

  void selectDeviceType(int index) {
    state = state.copyWith(deviceType: index);
  }

  Future<void> getCourseList() async {
    // TODO: 后续接入真实 API
    state = state.copyWith(isLoading: false);
  }

  CourseList? get currentCourseList => state.courseDataMap[state.deviceType];

  void setAllowToGamePage(bool value) {
    state = state.copyWith(allowToGamePage: value);
  }
}