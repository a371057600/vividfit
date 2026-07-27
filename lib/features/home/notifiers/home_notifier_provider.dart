import 'package:riverpod/riverpod.dart';

import 'home_notifier.dart';
import '../states/home_state.dart';

final homeNotifierProvider = NotifierProvider<HomeNotifier, HomeState>(HomeNotifier.new);