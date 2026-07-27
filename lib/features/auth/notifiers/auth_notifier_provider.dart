import 'package:riverpod/riverpod.dart';

import 'auth_notifier.dart';
import '../states/auth_state.dart';

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);