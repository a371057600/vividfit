import 'package:riverpod/riverpod.dart';

import 'course_detail_notifier.dart';
import '../states/course_detail_state.dart';

final courseDetailNotifierProvider = NotifierProvider<CourseDetailNotifier, CourseDetailState>(CourseDetailNotifier.new);