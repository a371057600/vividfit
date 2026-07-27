import 'package:riverpod/riverpod.dart';

import 'course_list_notifier.dart';
import '../states/course_list_state.dart';

final courseListNotifierProvider = NotifierProvider<CourseListNotifier, CourseListState>(CourseListNotifier.new);