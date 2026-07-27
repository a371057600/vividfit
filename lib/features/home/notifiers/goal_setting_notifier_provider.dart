import 'package:riverpod/riverpod.dart';

import 'goal_setting_notifier.dart';
import '../states/goal_setting_state.dart';

final goalSettingNotifierProvider = NotifierProvider<GoalSettingNotifier, GoalSettingState>(GoalSettingNotifier.new);