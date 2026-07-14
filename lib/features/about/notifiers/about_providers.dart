import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_settings_notifier.dart';
import '../states/user_settings_state.dart';

final userSettingsNotifierProvider =
    StateNotifierProvider<UserSettingsNotifier, UserSettingsState>(
  (ref) => UserSettingsNotifier(),
);
