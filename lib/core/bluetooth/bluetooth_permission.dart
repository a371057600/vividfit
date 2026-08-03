import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';
import '../constants/storage_keys.dart';

/// 蓝牙权限请求模块。
///
/// 1:1 迁移自旧 `device_connect_all_device_screen.dart` 的 `checkPermission()`。
///
/// - Android < 12: 检查 `Permission.location`
/// - Android >= 12: 检查 `Permission.bluetoothScan` + `Permission.bluetoothConnect`
/// - iOS: 检查 `Permission.bluetooth`
///
/// 权限被拒绝时返回提示文案（不直接弹窗，由 UI 层决定）。
class BluetoothPermission {
  BluetoothPermission._();

  /// 确保用户已被告知权限用途，然后申请权限。
  ///
  /// - Android 首次: 弹 dialog → 用户选择 → 申请权限
  /// - Android 非首次: 直接申请权限
  /// - iOS: 直接申请权限（无 dialog）
  ///
  /// 返回 true 表示权限已授予，false 表示被拒或未授予。
  /// 即使返回 false，也不阻塞后续流程（允许用户继续，由系统权限兜底）。
  static Future<bool> ensureInformedAndRequest(BuildContext context) async {
    if (Platform.isIOS) {
      return _requestPermissions();
    }

    // Android: 首次弹窗
    if (!await _hasShownDialog()) {
      if (!context.mounted) return false;
      final agreed = await _showPermissionDialog(context);
      await _markDialogShown();
      if (!agreed) {
        return false; // 用户拒绝告知，不申请权限，但不阻塞
      }
    }

    // 申请权限
    return _requestPermissions();
  }

  /// 检查权限是否已授予（不弹窗）。
  static Future<bool> isGranted() async {
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();
      if (androidVersion < 12) {
        final status = await Permission.location.status;
        return status.isGranted;
      } else {
        final scanStatus = await Permission.bluetoothScan.status;
        final connectStatus = await Permission.bluetoothConnect.status;
        return scanStatus.isGranted && connectStatus.isGranted;
      }
    } else if (Platform.isIOS) {
      final status = await Permission.bluetooth.status;
      return status.isGranted;
    }
    return true;
  }

  /// 检查蓝牙适配器是否开启。
  static Future<bool> isAdapterOn() async {
    final adapterState = await FlutterBluePlus.adapterState.first;
    return adapterState == BluetoothAdapterState.on;
  }

  /// 检查蓝牙权限是否已授予。
  ///
  /// 返回 `null` 表示权限已授予；返回非 null 字符串表示权限被拒绝的提示文案。
  static Future<String?> checkPermissions() async {
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();
      print('[BluetoothPermission] androidVersion=$androidVersion');

      if (androidVersion < 12) {
        final status = await Permission.location.status;
        print('[BluetoothPermission] location status=$status');
        if (status.isDenied) {
          return _permissionDeniedMessage;
        }
      } else {
        final scanStatus = await Permission.bluetoothScan.status;
        final connectStatus = await Permission.bluetoothConnect.status;
        print(
            '[BluetoothPermission] bluetoothScan=$scanStatus, bluetoothConnect=$connectStatus');
        if (scanStatus.isDenied || connectStatus.isDenied) {
          return _permissionDeniedMessage;
        }
      }
    } else if (Platform.isIOS) {
      final status = await Permission.bluetooth.status;
      print('[BluetoothPermission] ios bluetooth status=$status');
      if (status.isDenied) {
        return _permissionDeniedMessage;
      }
    }
    return null;
  }

  /// 请求蓝牙权限。
  ///
  /// 返回 `true` 表示权限已授予；返回 `false` 表示权限被拒绝。
  static Future<bool> requestPermissions() => _requestPermissions();

  /// 请求蓝牙权限（内部实现）。
  static Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();

      if (androidVersion < 12) {
        final result = await [Permission.location].request();
        return result[Permission.location]?.isGranted ?? false;
      } else {
        final result = await [
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
        ].request();
        final scanGranted = result[Permission.bluetoothScan]?.isGranted ?? false;
        final connectGranted =
            result[Permission.bluetoothConnect]?.isGranted ?? false;
        return scanGranted && connectGranted;
      }
    } else if (Platform.isIOS) {
      final result = await [Permission.bluetooth].request();
      return result[Permission.bluetooth]?.isGranted ?? false;
    }
    return true;
  }

  /// 读取“权限告知弹窗是否已展示”标志（仅 Android 首次弹窗机制）。
  static Future<bool> _hasShownDialog() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(StorageKeys.btPermissionDialogShown) ?? false;
  }

  /// 标记“权限告知弹窗已展示”。
  static Future<void> _markDialogShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.btPermissionDialogShown, true);
  }

  /// 弹出权限告知 dialog。
  ///
  /// 用户偏好：白底黑字、取消按钮更大、标题更大、占用屏幕更小。
  static Future<bool> _showPermissionDialog(BuildContext context) async {
    final tr = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // 白底
        title: Text(
          tr.permissionRequestInstructions, // "权限申请说明"
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          tr.permissionDialogMessage,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        actions: [
          // 取消按钮更大
          SizedBox(
            width: 120,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                tr.disagree, // "不同意"
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                tr.agree, // "同意"
                style: const TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// 获取 Android 版本号（对应旧 `getAndroidVersion()`）。
  static Future<int> _getAndroidVersion() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return int.tryParse(androidInfo.version.release) ?? 0;
  }

  /// 权限被拒绝时的提示文案（对应旧 `Get.snackbar` 文案）。
  static const _permissionDeniedMessage =
      '附近设备权限：当您使用蓝牙配对等功能时，我们需要向您申请并获取该权限,'
      '以便完成蓝牙设备的配对使用.如果您不同意此权限，这可能会影响到健身怪兽的正常使用.'
      '您可以随时访问系统设置来管理您的系统权限,如果拒绝,48小时内不会再进行提醒.';
}
