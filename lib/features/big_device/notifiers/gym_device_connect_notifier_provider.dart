import 'package:riverpod/riverpod.dart';

import 'gym_device_connect_notifier.dart';
import '../states/gym_device_connect_state.dart';

final gymDeviceConnectNotifierProvider = NotifierProvider<GymDeviceConnectNotifier, GymDeviceConnectState>(GymDeviceConnectNotifier.new);