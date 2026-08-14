import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/bluetooth/bluetooth_permission.dart';
import '../../auth/notifiers/auth_notifier.dart';
import '../notifiers/gym_device_connect_notifier.dart';

/// 快速开始模块准入校验守卫。
///
/// 在进入快速开始模块前，统一校验设备连接、蓝牙权限、蓝牙开关、
/// 用户登录状态、设备类型等 5 项前置条件，避免在不符合条件时进入模块
/// 导致后续流程异常。
///
/// 校验顺序固定为 C1 → C2 → C3 → C4 → C5，任一项失败立即返回对应错误文案，
/// 不再继续后续校验。全部通过返回 null。
class QuickStartEntryGuard {
  QuickStartEntryGuard._();

  /// 校验是否可以进入快速开始模块。
  ///
  /// 返回 `null` 表示全部校验通过，可以进入；
  /// 返回非 null 字符串表示校验失败，字符串内容为对应的错误提示文案。
  static Future<String?> check({
    required WidgetRef ref,
  }) async {
    // === C1 设备已连接（Layer 2） ===
    // 读取 gymDeviceConnectProvider 的 state，检查 isEquipmentConnected
    final connectState = ref.read(gymDeviceConnectProvider);
    final isEquipmentConnected = connectState.isEquipmentConnected;
    debugPrint(
      '[EntryGuard] check C1: isEquipmentConnected=$isEquipmentConnected '
      '${isEquipmentConnected ? '✅' : '❌'}',
    );
    if (!isEquipmentConnected) {
      const failure = 'pleaseConnectDevice';
      debugPrint('[EntryGuard] ❌ entry denied: $failure');
      return failure;
    }

    // === C2 蓝牙权限已授予 ===
    final permissionGranted = await BluetoothPermission.isGranted();
    debugPrint(
      '[EntryGuard] check C2: permissionGranted=$permissionGranted '
      '${permissionGranted ? '✅' : '❌'}',
    );
    if (!permissionGranted) {
      // 权限被拒，取提示文案；checkPermissions 返回 null 时用兜底文案
      final deniedMsg = await BluetoothPermission.checkPermissions();
      final failure = deniedMsg ?? 'pleaseGrantBluetoothPermission';
      debugPrint('[EntryGuard] ❌ entry denied: $failure');
      return failure;
    }

    // === C3 蓝牙适配器已开启 ===
    final adapterOn = await BluetoothPermission.isAdapterOn();
    debugPrint(
      '[EntryGuard] check C3: adapterOn=$adapterOn '
      '${adapterOn ? '✅' : '❌'}',
    );
    if (!adapterOn) {
      const failure = 'pleaseOpenBluetooth';
      debugPrint('[EntryGuard] ❌ entry denied: $failure');
      return failure;
    }

    // === C4 用户已登录 ===
    // 读取 authProvider 的 isAuthenticated 字段判断登录状态
    final authState = ref.read(authProvider);
    final userLoggedIn = authState.isAuthenticated;
    debugPrint(
      '[EntryGuard] check C4: userLoggedIn=$userLoggedIn '
      '${userLoggedIn ? '✅' : '❌'}',
    );
    if (!userLoggedIn) {
      const failure = 'pleaseLoginFirst';
      debugPrint('[EntryGuard] ❌ entry denied: $failure');
      return failure;
    }

    // === C5 设备类型已确定 ===
    // deviceCategory 为 FtmsDeviceType 枚举（非空），Notifier 初始化时默认 indoorBike。
    // 此处读取并记录当前设备类型；枚举非空故恒为已确定，不阻断进入。
    final notifier = ref.read(gymDeviceConnectProvider.notifier);
    final deviceCategory = notifier.deviceCategory;
    debugPrint(
      '[EntryGuard] check C5: deviceCategory=$deviceCategory ✅',
    );

    debugPrint('[EntryGuard] ✅ all checks passed, entering quick start');
    return null;
  }
}
