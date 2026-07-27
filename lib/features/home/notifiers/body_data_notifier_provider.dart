import 'package:riverpod/riverpod.dart';

import 'body_data_notifier.dart';
import '../states/body_data_state.dart';

final bodyDataNotifierProvider = NotifierProvider<BodyDataNotifier, BodyDataState>(BodyDataNotifier.new);