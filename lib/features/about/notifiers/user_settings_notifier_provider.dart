import 'package:riverpod/riverpod.dart';

import 'user_settings_notifier.dart';
import '../states/user_settings_state.dart';

final userSettingsNotifierProvider = NotifierProvider<UserSettingsNotifier, UserSettingsState>(UserSettingsNotifier.new);