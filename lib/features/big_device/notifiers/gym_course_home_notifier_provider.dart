import 'package:riverpod/riverpod.dart';

import 'gym_course_home_notifier.dart';
import '../states/gym_course_home_state.dart';

final gymCourseHomeNotifierProvider = NotifierProvider<GymCourseHomeNotifier, GymCourseHomeState>(GymCourseHomeNotifier.new);