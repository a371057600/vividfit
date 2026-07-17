import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/bluetooth_connection_service.dart';
import '../../../core/services/storage_service_provider.dart';
import '../states/gym_course_home_state.dart';
import '../states/gym_device_connect_state.dart';
import 'gym_course_home_notifier.dart';
import 'gym_device_connect_notifier.dart';

export 'gym_course_home_notifier.dart';
export 'gym_device_connect_notifier.dart';
export '../states/gym_course_home_state.dart';
export '../states/gym_device_connect_state.dart';

/// 课程首页状态(对应旧 Get.put(BigCourseHomeController())).
final gymCourseHomeNotifierProvider =
    StateNotifierProvider<GymCourseHomeNotifier, GymCourseHomeState>((ref) {
  return GymCourseHomeNotifier();
});

/// 共享蓝牙连接服务 Provider(course/connect/big_device 共用).
final bluetoothConnectionServiceProvider = Provider<BluetoothConnectionService>(
  (ref) => BluetoothConnectionService(),
);

/// 大设备搜索+连接状态(对应旧 Get.put(ControllerNewFourBigDeviceSprot())).
/// 注入 BluetoothConnectionService 和 StorageService.
final gymDeviceConnectNotifierProvider =
    StateNotifierProvider<GymDeviceConnectNotifier, GymDeviceConnectState>(
        (ref) {
  final service = ref.read(bluetoothConnectionServiceProvider);
  final notifier = GymDeviceConnectNotifier(service);
  notifier.setStorage(ref.read(storageServiceProvider));
  return notifier;
});
