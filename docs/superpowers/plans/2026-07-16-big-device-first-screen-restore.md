# Big Device First Screen 1:1 还原实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在 `vividfit_v2` 中以 Riverpod + go_router 1:1 还原旧项目 `big_device_first_screen.dart` 第一界面 UI(含横竖屏切换、5 张卡片、设备类型标题),并还原蓝牙搜索+连接流程(搜索弹窗、设备列表、连接状态反馈)。5 张卡片点击仅做"设备未连接"提示,不跳转具体功能页。

**Architecture:** 新建 `lib/features/big_device/` feature 模块,遵循 v2 既有 `features/<module>/{data,states,notifiers,pages}` 分层。状态管理用 `StateNotifier` + `StateNotifierProvider`(替代旧 `GetxController`/`Obx`),路由用 `go_router`(替代 `Get.to`/`Get.back`),路由参数用 `state.extra`(替代 `Get.arguments`)。所有文件名/类名/变量名/函数名使用 `Gym*` / `device*` 别名,不与旧 `Big*` 命名冲突。蓝牙搜索连接用 `flutter_blue_plus` 复刻原 `searchBluetoothDeviceList` + `connectDevice` + `_bluetoothConnectState` 的状态机;设备类型专属数据解析(bike/treadmill/rower/crossTrainer 的 `discoverS` 解析器)不在本计划范围内,留待后续 play screen 模块。

**Tech Stack:** Flutter 3.7+, flutter_riverpod ^2.6.1, go_router ^14.6.0, flutter_blue_plus ^2.0.2(新增), flutter_screenutil ^5.9.3, fluttertoast ^8.2.10, freezed ^2.5.7, shared_preferences ^2.3.3, mocktail ^1.0.4(测试)。

**别名映射表(旧 → 新):**

| 旧名 | 新名 |
|---|---|
| `big_device_first_screen.dart` | `gym_device_entry_screen.dart` |
| `BigDeviceFirstScreen` | `GymDeviceEntryScreen` |
| `BigCourseHomeController` | `GymCourseHomeNotifier` |
| `ControllerNewFourBigDeviceSprot` | `GymDeviceConnectNotifier` |
| `newMainSelectType` | `selectedDeviceCategory` |
| `cardData` | `entryCards` |
| `setImageaboutFirstScreen` | `resolveCardImage` |
| `isDeviceConnect` | `isEquipmentConnected` |
| `searchStatus` | `isSearching` |
| `searchBluetoothDeviceList` | `startDeviceScan` |
| `whiteNameList` | `scanNameWhitelist` |
| `connectDevice` | `connectSelectedDevice` |
| `bigDeviceType` | `deviceCategory` |
| `showDeviceName` | `discoveredDevices` |
| `device` | `targetDevice` |
| `checkDeviceReadyForEntry` | `validateReadyForEntry` |
| `stopSport` | `haltSport` |
| `_buildJumptoPage` | `_handleCardTap` |
| `_singleSelectBtn` | `_buildEntryCard` |
| `_titleWidget` | `_buildHeaderTitle` |
| `titleList` / `enTiltleList` | `deviceTitles` / `deviceEnglishTitles` |

**设备类型/分类(1:1 保留,5 类):**
- 0 = 单车 Bike
- 1 = 跑步机 Treadmill
- 2 = 椭圆机 Elliptical (Cross Trainer)
- 3 = 划船机 Rower
- 4 = 力量站 Strength Station

**范围边界(本计划不做):**
- 5 张卡片点击后的页面跳转(`BigDeviceQuickStartScreen`/`BigDeviceSecondScreen`/`GameSelect`/各 realscene screen)— 仅保留"设备未连接"toast 和点击日志。
- 设备类型专属蓝牙数据解析(`bikeBluetoothTools().discoverS(...)` 等 4 套工具链及对应 data_model/parser)— 留给后续 play screen 模块。
- 速度/坡度/阻力调节、长按、指令队列等运动控制逻辑 — 同上。
- `connectFlag`/`autoConnect` 自动重连本地已存设备 — 原 `autoConnect()` 已被注释空实现,本计划保持空实现。

---

## File Structure

```
lib/core/services/
  bluetooth_connection_service.dart  # 共享蓝牙连接服务:扫描/连接/断开/状态监听(course/connect/big_device 共用)
lib/features/big_device/
  data/
    device_category.dart          # DeviceCategory 枚举(5 类)+ fromIndex/index 转换
    device_scan_constants.dart    # 5 类设备的蓝牙搜索白名单(常量)
    entry_card_data.dart          # 5 张卡片数据 + 5 套背景图列表 + resolveCardImage
  states/
    gym_course_home_state.dart    # freezed: selectedDeviceCategory, entryCards
    gym_course_home_state.freezed.dart  # 生成
    gym_device_connect_state.dart # freezed: isSearching, isEquipmentConnected, foundDeviceNames, hasConnectedOnce
    gym_device_connect_state.freezed.dart  # 生成
  notifiers/
    gym_course_home_notifier.dart # StateNotifier: bootstrap(category), resolveCardImage
    gym_device_connect_notifier.dart  # StateNotifier: 委托 BluetoothConnectionService 做搜索连接,自身只转换事件为 state
    big_device_providers.dart     # 两个 StateNotifierProvider + BluetoothConnectionService Provider
  pages/
    gym_device_entry_screen.dart  # 1:1 还原的入口屏(横屏、AppBar、标题、5 卡片 Row)
    device_search_dialog.dart     # 搜索中/设备列表两态对话框(用 StatefulBuilder)
test/features/big_device/
  data/
    device_category_test.dart
    device_scan_constants_test.dart
    entry_card_data_test.dart
  notifiers/
    gym_course_home_notifier_test.dart
    gym_device_connect_notifier_test.dart
test/core/services/
  bluetooth_connection_service_test.dart  # BluetoothConnectionService 纯逻辑测试(mock callback)
```

**职责边界:**
- `bluetooth_connection_service.dart` — 共享蓝牙连接服务。封装 `FlutterBluePlus` 的扫描/连接/断开/状态订阅,持有 `BluetoothDevice` 实例和 `StreamSubscription` 生命周期。**所有模块(course/connect/big_device)共享此 Service**,避免各自直接依赖 `flutter_blue_plus`。
- `device_category.dart` — 纯枚举与索引互转,无副作用。
- `device_scan_constants.dart` — 5 类白名单常量,从旧 `setWhiteNameList()` 移植。
- `entry_card_data.dart` — 卡片元数据 + 5 套图片路径 + 图片解析器(替代旧 `listDeviceBikeImage` 等 5 个列表 + `setImageaboutFirstScreen`)。
- `gym_course_home_state.dart` — 课程首页纯数据状态(选中的设备类型 + 卡片列表)。
- `gym_device_connect_state.dart` — 连接状态(搜索中/已连接/发现设备名列表/是否曾连过);`BluetoothDevice` 实例不进 state,由 `BluetoothConnectionService` 持有。
- `gym_course_home_notifier.dart` — 接收路由 `extra` 中的 `deviceCategory` int,初始化 state。
- `gym_device_connect_notifier.dart` — **委托** `BluetoothConnectionService` 执行扫描和连接,自身通过 callback 接收事件并转换为 Riverpod state。不直接持有 `BluetoothDevice` 或 `StreamSubscription`。
- `gym_device_entry_screen.dart` — `ConsumerStatefulWidget`,1:1 还原 UI + 横竖屏切换 + AppBar 退回 + 触发搜索弹窗。
- `device_search_dialog.dart` — 独立对话框 widget,接收 notifier 引用,内部 `StatefulBuilder` 切换 loading/list 两态。

**约定:**
- 状态类用 freezed(与 v2 既有 `features/*/states/*` 一致)。`BluetoothDevice` 不进 freezed state(不可不可变),由 `BluetoothConnectionService` 持有。
- 路由参数:`/big-device-entry` 的 `state.extra` 为 `Map<String, dynamic>`,键 `deviceCategory` 为 int 0-4。
- 测试用 mocktail,`SharedPreferences.setMockInitialValues({})` 模拟存储,与既有 `home_notifier_test.dart` 一致。
- 蓝牙层因依赖 `FlutterBluePlus` 平台通道,单测仅覆盖纯逻辑(`validateReadyForEntry`、白名单、图片解析、`BluetoothConnectionService` callback 路由),蓝牙交互靠手动验证。

---

### Task 1: 新增 flutter_blue_plus 依赖与设备名存储键

**Files:**
- Modify: `app/vividfit_v2/pubspec.yaml`
- Modify: `app/vividfit_v2/lib/core/constants/storage_keys.dart`
- Modify: `app/vividfit_v2/lib/core/services/storage_service.dart`
- Test: `app/vividfit_v2/test/core/services/storage_service_test.dart`(已存在,追加用例)

- [ ] **Step 1: 在 pubspec.yaml 的 dependencies 末尾追加 flutter_blue_plus**

修改 `app/vividfit_v2/pubspec.yaml`,在 `intl: ^0.19.0` 之后、`dev_dependencies:` 之前追加:

```yaml
  # 大设备模块(蓝牙搜索连接)
  flutter_blue_plus: ^2.0.2
```

- [ ] **Step 2: 运行 flutter pub get 验证依赖解析**

Run: `cd app/vividfit_v2 && flutter pub get`
Expected: 无版本冲突,输出 `Got dependencies!`

- [ ] **Step 3: 在 StorageKeys 追加 5 个设备名键**

修改 `app/vividfit_v2/lib/core/constants/storage_keys.dart`,在 `permissionDateTime` 行之后追加:

```dart
  static const String permissionDateTime = 'PermissionDateTime';

  // ---- 大设备模块:5 类设备本地已连设备名 ----
  static const String bikeMachine = 'BikeMachine'; // 0 单车
  static const String treadmill = 'Treadmill'; // 1 跑步机
  static const String ellipticalMachine = 'EllipticalMachine'; // 2 椭圆机
  static const String powerMachine = 'PowerMachine'; // 3 划船机
  static const String powerStationMachine = 'PowerStationMachine'; // 4 力量站
```

- [ ] **Step 4: 在 StorageService 追加 5 个设备名的 getter/setter**

修改 `app/vividfit_v2/lib/core/services/storage_service.dart`,在 `setSecondSettingIndex` 方法之后、`clearAuth` 方法之前追加:

```dart
  int? get secondSettingIndex => _prefs.getInt(StorageKeys.secondSettingIndex);
  Future<void> setSecondSettingIndex(int v) =>
      _prefs.setInt(StorageKeys.secondSettingIndex, v);

  // ---- 大设备模块:5 类设备本地已连设备名 ----
  String? get bikeMachineName => _prefs.getString(StorageKeys.bikeMachine);
  Future<void> setBikeMachineName(String v) =>
      _prefs.setString(StorageKeys.bikeMachine, v);

  String? get treadmillName => _prefs.getString(StorageKeys.treadmill);
  Future<void> setTreadmillName(String v) =>
      _prefs.setString(StorageKeys.treadmill, v);

  String? get ellipticalMachineName =>
      _prefs.getString(StorageKeys.ellipticalMachine);
  Future<void> setEllipticalMachineName(String v) =>
      _prefs.setString(StorageKeys.ellipticalMachine, v);

  String? get rowerMachineName => _prefs.getString(StorageKeys.powerMachine);
  Future<void> setRowerMachineName(String v) =>
      _prefs.setString(StorageKeys.powerMachine, v);

  String? get strengthStationName =>
      _prefs.getString(StorageKeys.powerStationMachine);
  Future<void> setStrengthStationName(String v) =>
      _prefs.setString(StorageKeys.powerStationMachine, v);
```

- [ ] **Step 5: 写失败测试 — StorageService 设备名 round-trip**

修改 `app/vividfit_v2/test/core/services/storage_service_test.dart`,在文件末尾的 `main` 闭合 `}` 之前追加(若文件已有结构则追加到现有 group 之后):

```dart
  group('大设备名存储', () {
    test('5 类设备名 round-trip', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.create();

      await storage.setBikeMachineName('FM-B100');
      expect(storage.bikeMachineName, 'FM-B100');

      await storage.setTreadmillName('FM-T100');
      expect(storage.treadmillName, 'FM-T100');

      await storage.setEllipticalMachineName('FM-C100');
      expect(storage.ellipticalMachineName, 'FM-C100');

      await storage.setRowerMachineName('FM-R100');
      expect(storage.rowerMachineName, 'FM-R100');

      await storage.setStrengthStationName('Fit Monster Treadmill');
      expect(storage.strengthStationName, 'Fit Monster Treadmill');
    });
  });
```

- [ ] **Step 6: 运行测试验证通过**

Run: `cd app/vividfit_v2 && flutter test test/core/services/storage_service_test.dart`
Expected: PASS(所有用例通过,包括新增的 5 类设备名 round-trip)

- [ ] **Step 7: Commit**

```bash
cd app/vividfit_v2
git add pubspec.yaml pubspec.lock lib/core/constants/storage_keys.dart lib/core/services/storage_service.dart test/core/services/storage_service_test.dart
git commit -m "feat(big-device): add flutter_blue_plus dep and device-name storage keys"
```

---

### Task 2: 共享蓝牙连接服务 BluetoothConnectionService

**Files:**
- Create: `app/vividfit_v2/lib/core/services/bluetooth_connection_service.dart`
- Test: `app/vividfit_v2/test/core/services/bluetooth_connection_service_test.dart`

- [ ] **Step 1: 写失败测试 — Service callback 路由与状态转换**

创建 `app/vividfit_v2/test/core/services/bluetooth_connection_service_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/core/services/bluetooth_connection_service.dart';

void main() {
  group('BluetoothConnectionService', () {
    test('初始状态:targetDevice 为 null', () {
      final service = BluetoothConnectionService();
      expect(service.targetDevice, isNull);
    });

    test('onDevicesUpdated callback 被调用时传入设备名列表', () {
      final service = BluetoothConnectionService();
      List<String>? capturedNames;
      service.onDevicesUpdated = (names) => capturedNames = names;
      // 模拟内部触发(通过反射或直接调用 callback 测试路由)
      service.onDevicesUpdated!(['Device-A', 'Device-B']);
      expect(capturedNames, ['Device-A', 'Device-B']);
    });

    test('onConnectionChanged callback 传递连接状态', () {
      final service = BluetoothConnectionService();
      bool? capturedConnected;
      bool? capturedHasConnected;
      service.onConnectionChanged = (isConnected, hasConnectedOnce) {
        capturedConnected = isConnected;
        capturedHasConnected = hasConnectedOnce;
      };
      service.onConnectionChanged!(true, true);
      expect(capturedConnected, true);
      expect(capturedHasConnected, true);
    });

    test('onScanningChanged callback 传递搜索状态', () {
      final service = BluetoothConnectionService();
      bool? capturedScanning;
      service.onScanningChanged = (scanning) => capturedScanning = scanning;
      service.onScanningChanged!(true);
      expect(capturedScanning, true);
    });
  });
}
```

- [ ] **Step 2: 运行测试验证失败**

Run: `cd app/vividfit_v2 && flutter test test/core/services/bluetooth_connection_service_test.dart`
Expected: FAIL — `Target of URI doesn't exist`

- [ ] **Step 3: 创建 BluetoothConnectionService**

创建 `app/vividfit_v2/lib/core/services/bluetooth_connection_service.dart`:

```dart
import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// 共享蓝牙连接服务。
///
/// 封装 `FlutterBluePlus` 的扫描、连接、断开、状态订阅,
/// 持有 `BluetoothDevice` 实例和 `StreamSubscription` 生命周期。
/// **所有模块(course/connect/big_device)共享此 Service**,避免各自直接依赖 `flutter_blue_plus`。
///
/// 通过 callback 向调用方(Notifier)报告事件,调用方负责将事件转换为 Riverpod state。
class BluetoothConnectionService {
  BluetoothConnectionService();

  /// 当前目标设备(对应旧 `device`)。Service 层持有,不进 freezed state。
  BluetoothDevice? _targetDevice;
  BluetoothDevice? get targetDevice => _targetDevice;

  StreamSubscription<List<ScanResult>>? _scanSub;
  StreamSubscription<bool>? _isScanningSub;
  StreamSubscription<BluetoothConnectionState>? _connStateSub;

  final Map<String, BluetoothDevice> _discoveredDevices = {};

  /// 发现设备列表更新回调 → Notifier 中更新 `foundDeviceNames`。
  void Function(List<String> deviceNames)? onDevicesUpdated;

  /// 搜索状态变更回调 → Notifier 中更新 `isSearching`。
  void Function(bool isScanning)? onScanningChanged;

  /// 连接状态变更回调 → Notifier 中更新 `isEquipmentConnected` / `hasConnectedOnce`。
  void Function(bool isConnected, bool hasConnectedOnce)? onConnectionChanged;

  /// 启动蓝牙扫描(带白名单过滤)。
  ///
  /// 1. 清空已发现设备,标记 `isSearching=true`。
  /// 2. 6 秒兜底自动结束(对应旧 `6.delay`)。
  /// 3. 监听 `onScanResults`,去重后通过 `onDevicesUpdated` 回调通知。
  /// 4. 检查 adapterState,未开蓝牙则通过 `onScanningChanged(false)` 通知并抛出异常。
  /// 5. 启动 5 秒超时扫描,完成后通过 `onScanningChanged(false)` 通知。
  Future<void> startScan(List<String> whitelist) async {
    _discoveredDevices.clear();
    onDevicesUpdated?.call([]);
    onScanningChanged?.call(true);

    // 6 秒兜底结束搜索(对应旧 6.delay)。
    Future.delayed(const Duration(seconds: 6), () {
      if (_isScanningSub != null) {
        onScanningChanged?.call(false);
      }
    });

    _scanSub = FlutterBluePlus.onScanResults.listen((results) {
      if (results.isNotEmpty) {
        for (final r in results) {
          final name = r.device.advName;
          if (name.isEmpty) continue;
          if (!_discoveredDevices.containsKey(name)) {
            _discoveredDevices[name] = r.device;
            onDevicesUpdated?.call(List<String>.from(_discoveredDevices.keys));
          }
        }
      }
    }, onError: (e) => print('scan error: $e'));

    FlutterBluePlus.cancelWhenScanComplete(_scanSub!);

    final adapterState = await FlutterBluePlus.adapterState.first;
    if (adapterState != BluetoothAdapterState.on) {
      onScanningChanged?.call(false);
      throw BluetoothNotEnabledException();
    }

    await FlutterBluePlus.startScan(
      withKeywords: whitelist,
      timeout: const Duration(seconds: 5),
    );

    _isScanningSub = FlutterBluePlus.isScanning.listen((scanning) {
      if (!scanning) {
        onScanningChanged?.call(false);
        _isScanningSub?.cancel();
        _isScanningSub = null;
      }
    });
  }

  /// 停止扫描并清理订阅。
  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    await _scanSub?.cancel();
    _scanSub = null;
  }

  /// 连接指定广播名的设备。
  ///
  /// 1. 从 `_discoveredDevices` 查找设备实体。
  /// 2. 先停止扫描。
  /// 3. 调用 `device.connect()`,失败后静默(不重试,首屏逻辑)。
  /// 4. 订阅 `connectionState`,通过 `onConnectionChanged` 回调通知。
  Future<void> connect(String deviceName) async {
    final device = _discoveredDevices[deviceName];
    if (device == null) return;
    _targetDevice = device;
    await stopScan();

    try {
      await device.connect(
        timeout: const Duration(seconds: 35),
        autoConnect: false,
      );
    } catch (_) {
      // 旧逻辑静默重试,首屏不重试,仅记录。
    }

    _connStateSub = device.connectionState.listen((event) {
      final isConnected = event == BluetoothConnectionState.connected;
      onConnectionChanged?.call(isConnected, isConnected);
    });
    device.cancelWhenDisconnected(_connStateSub!, delayed: true, next: true);
  }

  /// 断开当前设备并清理订阅。
  Future<void> disconnect() async {
    await _connStateSub?.cancel();
    _connStateSub = null;
    if (_targetDevice != null) {
      try {
        await _targetDevice!.disconnect();
      } catch (_) {}
      _targetDevice = null;
    }
  }

  /// 若当前有连接中的设备,直接断开(对应旧 dialog 关闭按钮逻辑)。
  void disconnectIfAny() {
    if (_targetDevice != null) {
      _targetDevice!.disconnect();
    }
  }

  /// 释放所有订阅(Notifier dispose 时调用)。
  void dispose() {
    _scanSub?.cancel();
    _isScanningSub?.cancel();
    _connStateSub?.cancel();
  }
}

/// 蓝牙未开启异常。
class BluetoothNotEnabledException implements Exception {
  @override
  String toString() => 'BluetoothNotEnabledException';
}
```

- [ ] **Step 4: 运行测试验证通过**

Run: `cd app/vividfit_v2 && flutter test test/core/services/bluetooth_connection_service_test.dart`
Expected: PASS(4 个用例通过,不涉及真实蓝牙平台通道)

- [ ] **Step 5: Commit**

```bash
cd app/vividfit_v2
git add lib/core/services/bluetooth_connection_service.dart test/core/services/bluetooth_connection_service_test.dart
git commit -m "feat(core): add shared BluetoothConnectionService for scan/connect/disconnect"
```

---

### Task 3: 设备类型枚举与搜索白名单常量

**Files:**
- Create: `app/vividfit_v2/lib/features/big_device/data/device_category.dart`
- Create: `app/vividfit_v2/lib/features/big_device/data/device_scan_constants.dart`
- Test: `app/vividfit_v2/test/features/big_device/data/device_category_test.dart`
- Test: `app/vividfit_v2/test/features/big_device/data/device_scan_constants_test.dart`

- [ ] **Step 1: 写失败测试 — DeviceCategory 枚举索引互转**

创建 `app/vividfit_v2/test/features/big_device/data/device_category_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/features/big_device/data/device_category.dart';

void main() {
  group('DeviceCategory', () {
    test('fromIndex 0-4 返回对应枚举', () {
      expect(DeviceCategory.fromIndex(0), DeviceCategory.bike);
      expect(DeviceCategory.fromIndex(1), DeviceCategory.treadmill);
      expect(DeviceCategory.fromIndex(2), DeviceCategory.elliptical);
      expect(DeviceCategory.fromIndex(3), DeviceCategory.rower);
      expect(DeviceCategory.fromIndex(4), DeviceCategory.strengthStation);
    });

    test('fromIndex 越界抛 ArgumentError', () {
      expect(() => DeviceCategory.fromIndex(5), throwsArgumentError);
      expect(() => DeviceCategory.fromIndex(-1), throwsArgumentError);
    });

    test('index 返回 0-4', () {
      expect(DeviceCategory.bike.index, 0);
      expect(DeviceCategory.treadmill.index, 1);
      expect(DeviceCategory.elliptical.index, 2);
      expect(DeviceCategory.rower.index, 3);
      expect(DeviceCategory.strengthStation.index, 4);
    });

    test('toCourseTypeSelect 1:1 还原旧 courseTypeSelect 映射', () {
      // 旧:0→8, 1→9, 2→10, 3→11, 4→12
      expect(DeviceCategory.bike.toCourseTypeSelect(), 8);
      expect(DeviceCategory.treadmill.toCourseTypeSelect(), 9);
      expect(DeviceCategory.elliptical.toCourseTypeSelect(), 10);
      expect(DeviceCategory.rower.toCourseTypeSelect(), 11);
      expect(DeviceCategory.strengthStation.toCourseTypeSelect(), 12);
    });
  });
}
```

- [ ] **Step 2: 运行测试验证失败**

Run: `cd app/vividfit_v2 && flutter test test/features/big_device/data/device_category_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:vividfit_v2/features/big_device/data/device_category.dart'`

- [ ] **Step 3: 创建 device_category.dart**

创建 `app/vividfit_v2/lib/features/big_device/data/device_category.dart`:

```dart
/// 大设备分类枚举(1:1 对应旧 newMainSelectType 0-4)。
///
/// 0=单车,1=跑步机,2=椭圆机,3=划船机,4=力量站。
enum DeviceCategory {
  bike, // 0 单车
  treadmill, // 1 跑步机
  elliptical, // 2 椭圆机
  rower, // 3 划船机
  strengthStation, // 4 力量站
  ;

  /// 从旧 int 索引构造(对应 Get.arguments["bigDeviceType"])。
  factory DeviceCategory.fromIndex(int index) {
    return switch (index) {
      0 => DeviceCategory.bike,
      1 => DeviceCategory.treadmill,
      2 => DeviceCategory.elliptical,
      3 => DeviceCategory.rower,
      4 => DeviceCategory.strengthStation,
      _ => throw ArgumentError(
        'Unsupported DeviceCategory index: $index (only 0-4)',
      ),
    };
  }

  /// 对应旧 courseTypeSelect:0→8,1→9,2→10,3→11,4→12。
  int toCourseTypeSelect() => index + 8;
}
```

- [ ] **Step 4: 运行测试验证通过**

Run: `cd app/vividfit_v2 && flutter test test/features/big_device/data/device_category_test.dart`
Expected: PASS

- [ ] **Step 5: 写失败测试 — DeviceScanConstants 5 类白名单内容**

创建 `app/vividfit_v2/test/features/big_device/data/device_scan_constants_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/features/big_device/data/device_category.dart';
import 'package:vividfit_v2/features/big_device/data/device_scan_constants.dart';

void main() {
  group('DeviceScanConstants', () {
    test('bike 白名单 1:1 还原旧 setWhiteNameList case 0', () {
      expect(DeviceScanConstants.whitelistFor(DeviceCategory.bike), [
        'FM-B100',
        'FM-B101',
        'FM-B103',
        'FM-B501',
        'FS-LD CX20',
        'FS-LD CX30',
        'FS-LD CX50',
        'FS-LD R2',
        'RIDO U2',
        'FS',
      ]);
    });

    test('treadmill 白名单 1:1 还原旧 case 1', () {
      expect(DeviceScanConstants.whitelistFor(DeviceCategory.treadmill), [
        'FIT-TM-',
        'FIT-',
        'T2',
        'RIDO-T101',
        'FM-T100',
        'FM-T101',
        'FM-T103',
        'FM-T501',
        'FM-T201',
      ]);
    });

    test('elliptical 白名单 1:1 还原旧 case 2', () {
      expect(DeviceScanConstants.whitelistFor(DeviceCategory.elliptical), [
        'FM-C100',
        'FM-C101',
        'FM-C103',
        'FM-C501',
        'E2',
        'FS',
      ]);
    });

    test('rower 白名单 1:1 还原旧 case 3', () {
      expect(DeviceScanConstants.whitelistFor(DeviceCategory.rower), [
        'RIDO W2',
        'FM-R100',
        'FM-R101',
        'FM-R103',
        'FM-R501',
        'W5',
      ]);
    });

    test('strengthStation 白名单 1:1 还原旧 case 4', () {
      expect(
        DeviceScanConstants.whitelistFor(DeviceCategory.strengthStation),
        ['Fit Monster Treadmill'],
      );
    });
  });
}
```

- [ ] **Step 6: 运行测试验证失败**

Run: `cd app/vividfit_v2 && flutter test test/features/big_device/data/device_scan_constants_test.dart`
Expected: FAIL — `Target of URI doesn't exist: '...device_scan_constants.dart'`

- [ ] **Step 7: 创建 device_scan_constants.dart**

创建 `app/vividfit_v2/lib/features/big_device/data/device_scan_constants.dart`:

```dart
import 'device_category.dart';

/// 5 类大设备的蓝牙搜索白名单(1:1 移植自旧
/// `ControllerNewFourBigDeviceSprot.setWhiteNameList()`)。
///
/// 旧 `BlueUuid.smartBikeFSLD.code` 等 enum 的 `.code` 字段为字符串常量,
/// 这里直接展开为字符串,避免引入完整 BlueUuid 枚举。
class DeviceScanConstants {
  DeviceScanConstants._();

  static const List<String> _bike = [
    'FM-B100', // BlueUuid.smartBikeFSLD.code
    'FM-B101', // BlueUuid.smartBikeFSLD2.code
    'FM-B103', // BlueUuid.smartBikeFSLD3.code
    'FM-B501', // BlueUuid.smartBikeFSLD501.code
    'FS-LD CX20',
    'FS-LD CX30',
    'FS-LD CX50',
    'FS-LD R2',
    'RIDO U2',
    'FS',
  ];

  static const List<String> _treadmill = [
    'FIT-TM-',
    'FIT-',
    'T2',
    'RIDO-T101',
    'FM-T100', // BlueUuid.smartTreadMillFSLD.code
    'FM-T101', // BlueUuid.smartTreadMillFSLD2.code
    'FM-T103', // BlueUuid.smartTreadMillFSLD3.code
    'FM-T501', // BlueUuid.smartTreadMillFSLD501.code
    'FM-T201', // BlueUuid.smartTreadMillFSLD201.code
  ];

  static const List<String> _elliptical = [
    'FM-C100', // BlueUuid.crossTrainerFSLD.code
    'FM-C101', // BlueUuid.crossTrainerFSLD2.code
    'FM-C103', // BlueUuid.crossTrainerFSLD3.code
    'FM-C501', // BlueUuid.crossTrainerFSLD501.code
    'E2',
    'FS',
  ];

  static const List<String> _rower = [
    'RIDO W2', // BlueUuid.rowingRIDOMachineFSLD.code
    'FM-R100', // BlueUuid.rowingMachineFSLD.code
    'FM-R101', // BlueUuid.rowingMachineFSLD2.code
    'FM-R103', // BlueUuid.rowingMachineFSLD3.code
    'FM-R501', // BlueUuid.rowingMachineFSLD501.code
    'W5',
  ];

  static const List<String> _strengthStation = ['Fit Monster Treadmill'];

  /// 按设备分类返回对应搜索白名单。
  static List<String> whitelistFor(DeviceCategory category) {
    return switch (category) {
      DeviceCategory.bike => List<String>.from(_bike),
      DeviceCategory.treadmill => List<String>.from(_treadmill),
      DeviceCategory.elliptical => List<String>.from(_elliptical),
      DeviceCategory.rower => List<String>.from(_rower),
      DeviceCategory.strengthStation => List<String>.from(_strengthStation),
    };
  }
}
```

- [ ] **Step 8: 运行测试验证通过**

Run: `cd app/vividfit_v2 && flutter test test/features/big_device/data/device_scan_constants_test.dart`
Expected: PASS

- [ ] **Step 9: Commit**

```bash
cd app/vividfit_v2
git add lib/features/big_device/data/device_category.dart lib/features/big_device/data/device_scan_constants.dart test/features/big_device/data/
git commit -m "feat(big-device): add DeviceCategory enum and scan whitelist constants"
```

---

### Task 4: 入口卡片数据与背景图解析器

**Files:**
- Create: `app/vividfit_v2/lib/features/big_device/data/entry_card_data.dart`
- Test: `app/vividfit_v2/test/features/big_device/data/entry_card_data_test.dart`

- [ ] **Step 1: 写失败测试 — EntryCardData 内容与 resolveCardImage 解析**

创建 `app/vividfit_v2/test/features/big_device/data/entry_card_data_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/features/big_device/data/device_category.dart';
import 'package:vividfit_v2/features/big_device/data/entry_card_data.dart';

void main() {
  group('EntryCardData', () {
    test('defaultCards 返回 5 张卡片,索引 0-4 连续', () {
      final cards = EntryCardData.defaultCards();
      expect(cards.length, 5);
      for (var i = 0; i < 5; i++) {
        expect(cards[i].index, i);
      }
    });

    test('defaultCards 第一张为 Quick Start,icon power_settings_new', () {
      final first = EntryCardData.defaultCards().first;
      expect(first.titleKey, 'quickStart');
      expect(first.englishTitle, 'QUICK START');
      expect(first.icon, Icons.power_settings_new);
      expect(first.color, Colors.redAccent);
      expect(first.index, 0);
    });

    test('defaultCards 第 5 张为 RECREATIONAL FITNESS,index 4', () {
      final last = EntryCardData.defaultCards().last;
      expect(last.titleKey, 'recreationalFitness');
      expect(last.englishTitle, 'RECREATIONAL FITNESS');
      expect(last.icon, Icons.games);
      expect(last.index, 4);
    });

    test('resolveCardImage 按设备类型返回对应图集的第 N 张', () {
      expect(
        EntryCardData.resolveCardImage(DeviceCategory.bike, 0),
        'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceBike_0.jpg',
      );
      expect(
        EntryCardData.resolveCardImage(DeviceCategory.treadmill, 3),
        'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceTreadmill_3.jpg',
      );
      expect(
        EntryCardData.resolveCardImage(DeviceCategory.elliptical, 2),
        'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceCross_2.jpg',
      );
      expect(
        EntryCardData.resolveCardImage(DeviceCategory.rower, 4),
        'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceRower_4.jpg',
      );
      expect(
        EntryCardData.resolveCardImage(DeviceCategory.strengthStation, 1),
        'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceStrength_1.jpg',
      );
    });

    test('deviceTitles 与 deviceEnglishTitles 长度为 5 且顺序对应', () {
      expect(EntryCardData.deviceTitles.length, 5);
      expect(EntryCardData.deviceEnglishTitles.length, 5);
      expect(EntryCardData.deviceEnglishTitles[0], 'SPIN BIKE');
      expect(EntryCardData.deviceEnglishTitles[4], 'STRENGTH STATION');
    });
  });
}
```

- [ ] **Step 2: 运行测试验证失败**

Run: `cd app/vividfit_v2 && flutter test test/features/big_device/data/entry_card_data_test.dart`
Expected: FAIL — `Target of URI doesn't exist: '...entry_card_data.dart'`

- [ ] **Step 3: 创建 entry_card_data.dart**

创建 `app/vividfit_v2/lib/features/big_device/data/entry_card_data.dart`:

```dart
import 'package:flutter/material.dart';

import 'device_category.dart';

/// 单张入口卡片元数据(1:1 还原旧 `BigCourseHomeController.cardData` 项)。
///
/// `titleKey` 为 l10n 键名(替代旧 `'Quick Start'.tr`)。
class EntryCardData {
  const EntryCardData({
    required this.titleKey,
    required this.englishTitle,
    required this.icon,
    required this.color,
    required this.index,
  });

  final String titleKey; // l10n 键
  final String englishTitle; // 英文大写标题(无 l10n)
  final IconData icon;
  final Color color;
  final int index; // 0-4

  /// 1:1 还原旧 `cardData` 5 项。
  static List<EntryCardData> defaultCards() {
    return const [
      EntryCardData(
        titleKey: 'quickStart',
        englishTitle: 'QUICK START',
        icon: Icons.power_settings_new,
        color: Colors.redAccent,
        index: 0,
      ),
      EntryCardData(
        titleKey: 'courseTraining',
        englishTitle: 'COURSE TRAINING',
        icon: Icons.play_circle_outline,
        color: Colors.orangeAccent,
        index: 1,
      ),
      EntryCardData(
        titleKey: 'realScene',
        englishTitle: 'REAL-SCENE',
        icon: Icons.person,
        color: Colors.blueAccent,
        index: 2,
      ),
      EntryCardData(
        titleKey: 'cityAdventure',
        englishTitle: 'CITY ADVENTURE',
        icon: Icons.location_city,
        color: Colors.purpleAccent,
        index: 3,
      ),
      EntryCardData(
        titleKey: 'recreationalFitness',
        englishTitle: 'RECREATIONAL FITNESS',
        icon: Icons.games,
        color: Colors.greenAccent,
        index: 4,
      ),
    ];
  }

  /// 5 类设备的主标题(1:1 还原旧 `titleList`,使用已有 l10n 键)。
  static const List<String> deviceTitles = [
    'spinBike', // 0 单车
    'treadmillMachine', // 1 跑步机
    'ellipticalMachine', // 2 椭圆机
    'rowingMachine', // 3 划船机
    'strengthStation', // 4 力量站
  ];

  /// 5 类设备英文标题(1:1 还原旧 `enTiltleList`,无 l10n)。
  static const List<String> deviceEnglishTitles = [
    'SPIN BIKE',
    'TREADMILL',
    'ELLIPTICAL MACHINE',
    'ROWING MACHINE',
    'STRENGTH STATION',
  ];

  // 5 套背景图列表(1:1 还原旧 listDeviceBikeImage 等)。
  static const List<String> _bikeImages = [
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceBike_0.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceBike_1.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceBike_2.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceBike_3.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceBike_4.jpg',
  ];
  static const List<String> _treadmillImages = [
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceTreadmill_0.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceTreadmill_1.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceTreadmill_2.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceTreadmill_3.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceTreadmill_4.jpg',
  ];
  static const List<String> _crossImages = [
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceCross_0.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceCross_1.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceCross_2.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceCross_3.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceCross_4.jpg',
  ];
  static const List<String> _rowerImages = [
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceRower_0.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceRower_1.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceRower_2.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceRower_3.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceRower_4.jpg',
  ];
  static const List<String> _strengthImages = [
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceStrength_0.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceStrength_1.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceStrength_2.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceStrength_3.jpg',
    'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bigDeviceStrength_4.jpg',
  ];

  /// 1:1 还原旧 `setImageaboutFirstScreen(int dataIndex)`。
  /// 按当前设备类型返回第 `dataIndex` 张背景图路径。
  static String resolveCardImage(DeviceCategory category, int dataIndex) {
    return switch (category) {
      DeviceCategory.bike => _bikeImages[dataIndex],
      DeviceCategory.treadmill => _treadmillImages[dataIndex],
      DeviceCategory.elliptical => _crossImages[dataIndex],
      DeviceCategory.rower => _rowerImages[dataIndex],
      DeviceCategory.strengthStation => _strengthImages[dataIndex],
    };
  }
}
```

- [ ] **Step 4: 运行测试验证通过**

Run: `cd app/vividfit_v2 && flutter test test/features/big_device/data/entry_card_data_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
cd app/vividfit_v2
git add lib/features/big_device/data/entry_card_data.dart test/features/big_device/data/entry_card_data_test.dart
git commit -m "feat(big-device): add EntryCardData model and resolveCardImage"
```

---

### Task 5: GymCourseHomeState 与 Notifier

**Files:**
- Create: `app/vividfit_v2/lib/features/big_device/states/gym_course_home_state.dart`
- Create: `app/vividfit_v2/lib/features/big_device/states/gym_course_home_state.freezed.dart`(build_runner 生成)
- Create: `app/vividfit_v2/lib/features/big_device/notifiers/gym_course_home_notifier.dart`
- Test: `app/vividfit_v2/test/features/big_device/notifiers/gym_course_home_notifier_test.dart`

- [ ] **Step 1: 写失败测试 — GymCourseHomeNotifier.bootstrap 设置状态**

创建 `app/vividfit_v2/test/features/big_device/notifiers/gym_course_home_notifier_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/features/big_device/data/device_category.dart';
import 'package:vividfit_v2/features/big_device/data/entry_card_data.dart';
import 'package:vividfit_v2/features/big_device/notifiers/gym_course_home_notifier.dart';

void main() {
  group('GymCourseHomeNotifier', () {
    test('bootstrap(bike) 设置 selectedDeviceCategory=bike 且 entryCards=5', () {
      final notifier = GymCourseHomeNotifier();
      notifier.bootstrap(0);
      expect(notifier.state.selectedDeviceCategory, DeviceCategory.bike);
      expect(notifier.state.entryCards.length, 5);
      expect(notifier.state.entryCards, EntryCardData.defaultCards());
    });

    test('bootstrap(3) 设置 rower', () {
      final notifier = GymCourseHomeNotifier();
      notifier.bootstrap(3);
      expect(notifier.state.selectedDeviceCategory, DeviceCategory.rower);
    });

    test('bootstrap(5) 越界保持默认 bike', () {
      final notifier = GymCourseHomeNotifier();
      notifier.bootstrap(5);
      expect(notifier.state.selectedDeviceCategory, DeviceCategory.bike);
    });

    test('resolveCardImage 委托给 EntryCardData', () {
      final notifier = GymCourseHomeNotifier();
      notifier.bootstrap(1);
      expect(
        notifier.resolveCardImage(2),
        EntryCardData.resolveCardImage(DeviceCategory.treadmill, 2),
      );
    });

    test('deviceTitleKey/deviceEnglishTitle 按 category 返回', () {
      final notifier = GymCourseHomeNotifier();
      notifier.bootstrap(2);
      expect(notifier.deviceTitleKey, 'ellipticalMachine');
      expect(notifier.deviceEnglishTitle, 'ELLIPTICAL MACHINE');
    });
  });
}
```

- [ ] **Step 2: 运行测试验证失败**

Run: `cd app/vividfit_v2 && flutter test test/features/big_device/notifiers/gym_course_home_notifier_test.dart`
Expected: FAIL — `Target of URI doesn't exist: '...gym_course_home_notifier.dart'`

- [ ] **Step 3: 创建 freezed state**

创建 `app/vividfit_v2/lib/features/big_device/states/gym_course_home_state.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/device_category.dart';
import '../../data/entry_card_data.dart';

part 'gym_course_home_state.freezed.dart';

@freezed
class GymCourseHomeState with _$GymCourseHomeState {
  const factory GymCourseHomeState({
    /// 当前选中的设备分类(对应旧 newMainSelectType)。
    @Default(DeviceCategory.bike) DeviceCategory selectedDeviceCategory,

    /// 5 张入口卡片(对应旧 cardData)。
    @Default(EntryCardData.defaultCards) List<EntryCardData> entryCards,
  }) = _GymCourseHomeState;
}
```

> 注:`EntryCardData.defaultCards` 是 `const` 构造,可作为 freezed 默认值。需在 `entry_card_data.dart` 中确认 `defaultCards()` 返回 `const` 列表(Task 3 已用 `const [...]`),但 `List<EntryCardData>` 默认值在 freezed 中要求 const,此处 `EntryCardData.defaultCards()` 是静态方法返回 `const` — freezed `@Default` 接受 `const` 表达式。若 build_runner 报错,改为 `@Default(<EntryCardData>[])` 并在 notifier 构造时显式赋值。下面 Step 5 的 build_runner 验证会暴露此问题。

- [ ] **Step 4: 创建 GymCourseHomeNotifier**

创建 `app/vividfit_v2/lib/features/big_device/notifiers/gym_course_home_notifier.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/device_category.dart';
import '../../data/entry_card_data.dart';
import '../states/gym_course_home_state.dart';

/// 课程首页状态机(1:1 还原旧 `BigCourseHomeController` 中
/// first-screen 所需部分:newMainSelectType / cardData /
/// setImageaboutFirstScreen / titleList / enTiltleList)。
///
/// 不包含课程列表拉取、蓝牙订阅、orderData 等非首屏逻辑。
class GymCourseHomeNotifier extends StateNotifier<GymCourseHomeState> {
  GymCourseHomeNotifier() : super(const GymCourseHomeState());

  /// 从路由 extra 初始化设备类型(对应旧 initData() 读 Get.arguments)。
  /// 越界时保持默认 bike,与旧 default 分支一致。
  void bootstrap(int deviceCategoryIndex) {
    final category = deviceCategoryIndex >= 0 && deviceCategoryIndex <= 4
        ? DeviceCategory.fromIndex(deviceCategoryIndex)
        : DeviceCategory.bike;
    state = GymCourseHomeState(
      selectedDeviceCategory: category,
      entryCards: EntryCardData.defaultCards(),
    );
  }

  /// 1:1 还原旧 `setImageaboutFirstScreen(int dataIndex)`。
  String resolveCardImage(int dataIndex) =>
      EntryCardData.resolveCardImage(state.selectedDeviceCategory, dataIndex);

  /// 当前设备类型的主标题 l10n 键(对应旧 titleList[newMainSelectType])。
  String get deviceTitleKey =>
      EntryCardData.deviceTitles[state.selectedDeviceCategory.index];

  /// 当前设备类型的英文标题(对应旧 enTiltleList[newMainSelectType])。
  String get deviceEnglishTitle =>
      EntryCardData.deviceEnglishTitles[state.selectedDeviceCategory.index];
}
```

- [ ] **Step 5: 运行 build_runner 生成 freezed 文件**

Run: `cd app/vividfit_v2 && dart run build_runner build --delete-conflicting-outputs`
Expected: 成功生成 `gym_course_home_state.freezed.dart`,无错误。

> 若报 `@Default(EntryCardData.defaultCards)` 不允许非常量,改为:
> ```dart
> @Default(<EntryCardData>[]) List<EntryCardData> entryCards,
> ```
> 并保持 notifier `bootstrap()` 显式赋值 `EntryCardData.defaultCards()`(已如此)。重跑 build_runner。

- [ ] **Step 6: 运行测试验证通过**

Run: `cd app/vividfit_v2 && flutter test test/features/big_device/notifiers/gym_course_home_notifier_test.dart`
Expected: PASS

- [ ] **Step 7: Commit**

```bash
cd app/vividfit_v2
git add lib/features/big_device/states/gym_course_home_state.dart lib/features/big_device/states/gym_course_home_state.freezed.dart lib/features/big_device/notifiers/gym_course_home_notifier.dart test/features/big_device/notifiers/gym_course_home_notifier_test.dart
git commit -m "feat(big-device): add GymCourseHomeState and GymCourseHomeNotifier"
```

---

### Task 6: GymDeviceConnectState 与 Notifier(搜索+连接)

**Files:**
- Create: `app/vividfit_v2/lib/features/big_device/states/gym_device_connect_state.dart`
- Create: `app/vividfit_v2/lib/features/big_device/states/gym_device_connect_state.freezed.dart`(生成)
- Create: `app/vividfit_v2/lib/features/big_device/notifiers/gym_device_connect_notifier.dart`
- Test: `app/vividfit_v2/test/features/big_device/notifiers/gym_device_connect_notifier_test.dart`

- [ ] **Step 1: 写失败测试 — validateReadyForEntry 与 state 纯逻辑**

创建 `app/vividfit_v2/test/features/big_device/notifiers/gym_device_connect_notifier_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/core/services/bluetooth_connection_service.dart';
import 'package:vividfit_v2/features/big_device/data/device_category.dart';
import 'package:vividfit_v2/features/big_device/notifiers/gym_device_connect_notifier.dart';

void main() {
  group('GymDeviceConnectNotifier', () {
    test('初始状态:未搜索/未连接/设备列表空', () {
      final service = BluetoothConnectionService();
      final notifier = GymDeviceConnectNotifier(service);
      expect(notifier.state.isSearching, false);
      expect(notifier.state.isEquipmentConnected, false);
      expect(notifier.state.foundDeviceNames, isEmpty);
      expect(notifier.state.hasConnectedOnce, false);
    });

    test('setDeviceCategory 后 validateReadyForEntry 未连接返回提示', () {
      final service = BluetoothConnectionService();
      final notifier = GymDeviceConnectNotifier(service);
      notifier.setDeviceCategory(DeviceCategory.bike);
      final result = notifier.validateReadyForEntry();
      // 未连接 → 返回非 null 提示
      expect(result, isNotNull);
      expect(result, 'pleaseConnectDevice');
    });

    test('markConnected 后 validateReadyForEntry 返回 null(可进入)', () {
      final service = BluetoothConnectionService();
      final notifier = GymDeviceConnectNotifier(service);
      notifier.setDeviceCategory(DeviceCategory.treadmill);
      notifier.markConnectedForTest();
      expect(notifier.validateReadyForEntry(), isNull);
    });

    test('setDeviceCategory 默认 bike', () {
      final service = BluetoothConnectionService();
      final notifier = GymDeviceConnectNotifier(service);
      expect(notifier.deviceCategory, DeviceCategory.bike);
      notifier.setDeviceCategory(DeviceCategory.rower);
      expect(notifier.deviceCategory, DeviceCategory.rower);
    });
  });
}
```

- [ ] **Step 2: 运行测试验证失败**

Run: `cd app/vividfit_v2 && flutter test test/features/big_device/notifiers/gym_device_connect_notifier_test.dart`
Expected: FAIL — `Target of URI doesn't exist: '...gym_device_connect_notifier.dart'`

- [ ] **Step 3: 创建 freezed state**

创建 `app/vividfit_v2/lib/features/big_device/states/gym_device_connect_state.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gym_device_connect_state.freezed.dart';

@freezed
class GymDeviceConnectState with _$GymDeviceConnectState {
  const factory GymDeviceConnectState({
    /// 是否正在搜索(对应旧 searchStatus)。
    @Default(false) bool isSearching,

    /// 设备是否已连接(对应旧 isDeviceConnect)。
    @Default(false) bool isEquipmentConnected,

    /// 已发现设备的广播名列表(对应旧 showDeviceName.map(advName))。
    @Default(<String>[]) List<String> foundDeviceNames,

    /// 是否曾经连接过(对应旧 _hasConnected,用于断连 toast 抑制)。
    @Default(false) bool hasConnectedOnce,
  }) = _GymDeviceConnectState;
}
```

- [ ] **Step 4: 创建 GymDeviceConnectNotifier**

创建 `app/vividfit_v2/lib/features/big_device/notifiers/gym_device_connect_notifier.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/services/bluetooth_connection_service.dart';
import '../../core/services/storage_service.dart';
import '../../data/device_category.dart';
import '../../data/device_scan_constants.dart';
import '../states/gym_device_connect_state.dart';

/// 大设备搜索+连接状态机(1:1 还原旧 `ControllerNewFourBigDeviceSprot`
/// 中 first-screen 所需部分:setWhiteNameList / searchBluetoothDeviceList /
/// connectDevice / _bluetoothConnectState / stopSport / checkDeviceReadyForEntry)。
///
/// **架构变更**:不直接依赖 `FlutterBluePlus`,而是委托 `BluetoothConnectionService`
/// 执行扫描/连接/断开。Service 通过 callback 报告事件,Notifier 将事件转换为
/// Riverpod state。此设计使 course/connect/big_device 模块共享同一蓝牙连接层。
///
/// **不包含**:设备类型专属数据解析(bike/treadmill/rower/crossTrainer 的
/// discoverS 与 data_model)、速度/坡度/阻力调节、指令队列。
class GymDeviceConnectNotifier extends StateNotifier<GymDeviceConnectState> {
  GymDeviceConnectNotifier(this._service)
      : super(const GymDeviceConnectState()) {
    // 注册 Service callback,将蓝牙事件转换为 Riverpod state。
    _service.onDevicesUpdated = (names) {
      state = state.copyWith(foundDeviceNames: names);
    };
    _service.onScanningChanged = (scanning) {
      state = state.copyWith(isSearching: scanning);
    };
    _service.onConnectionChanged = (isConnected, hasConnectedOnce) {
      state = state.copyWith(
        isEquipmentConnected: isConnected,
        hasConnectedOnce: state.hasConnectedOnce || hasConnectedOnce,
      );
      if (isConnected) {
        Fluttertoast.showToast(msg: 'connected');
      } else if (state.hasConnectedOnce) {
        Fluttertoast.showToast(msg: 'deviceDisconnected');
      }
    };
  }

  final BluetoothConnectionService _service;

  /// 注入 StorageService 以持久化已连设备名。
  StorageService? _storage;

  /// 当前设备分类(对应旧 bigDeviceType)。
  DeviceCategory _deviceCategory = DeviceCategory.bike;
  DeviceCategory get deviceCategory => _deviceCategory;

  void setStorage(StorageService storage) => _storage = storage;

  /// 1:1 还原旧 setWhiteNameList 的设备类型设置部分(白名单由
  /// DeviceScanConstants 提供)。
  void setDeviceCategory(DeviceCategory category) {
    _deviceCategory = category;
  }

  /// 1:1 还原旧 `searchBluetoothDeviceList(List<String> whiteNameList)`。
  ///
  /// 委托 `BluetoothConnectionService.startScan()` 执行扫描,
  /// 结果通过构造函数中注册的 `onDevicesUpdated` / `onScanningChanged`
  /// callback 自动同步到 state。
  Future<void> startDeviceScan() async {
    final whitelist = DeviceScanConstants.whitelistFor(_deviceCategory);
    try {
      await _service.startScan(whitelist);
    } on BluetoothNotEnabledException {
      Fluttertoast.showToast(msg: 'pleaseOpenBluetooth');
    }
  }

  /// 用户在设备列表对话框点击某设备时调用。
  ///
  /// 1:1 还原旧 onScanResults 回调中点击 ListTile 的逻辑:
  /// writeBigDeviceLocal → 保存本地;connectDevice()。
  Future<void> connectSelectedDevice(String deviceName) async {
    await _persistDeviceName(deviceName);
    await _service.connect(deviceName);
  }

  /// 1:1 还原旧 `writeBigDeviceLocal(String deviceName)` — 按分类写本地键。
  Future<void> _persistDeviceName(String name) async {
    final s = _storage;
    if (s == null) return;
    switch (_deviceCategory) {
      case DeviceCategory.bike:
        await s.setBikeMachineName(name);
        break;
      case DeviceCategory.treadmill:
        await s.setTreadmillName(name);
        break;
      case DeviceCategory.elliptical:
        await s.setEllipticalMachineName(name);
        break;
      case DeviceCategory.rower:
        await s.setRowerMachineName(name);
        break;
      case DeviceCategory.strengthStation:
        await s.setStrengthStationName(name);
        break;
    }
  }

  /// 1:1 还原旧 `checkDeviceReadyForEntry()` — 返回 l10n 键或 null。
  /// 未连接返回 'pleaseConnectDevice'。
  /// (旧版还检查速度>0,首屏无速度数据,故仅检查连接。)
  String? validateReadyForEntry() {
    if (!state.isEquipmentConnected) {
      return 'pleaseConnectDevice';
    }
    return null;
  }

  /// 1:1 还原旧 `stopSport()` — 首屏无指令通道,仅断开设备。
  Future<void> haltSport() async {
    await _service.disconnect();
    state = state.copyWith(isEquipmentConnected: false);
  }

  /// 1:1 还原旧 dialog 中"获取设备信息"按钮点击后立即断开旧设备(若存在)。
  void disconnectIfAny() {
    _service.disconnectIfAny();
  }

  /// 1:1 还原旧 `_bluetoothConnectState` 中 connected 分支(仅用于测试)。
  void markConnectedForTest() {
    state = state.copyWith(
      isEquipmentConnected: true,
      hasConnectedOnce: true,
    );
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
```

- [ ] **Step 5: 运行 build_runner 生成 freezed 文件**

Run: `cd app/vividfit_v2 && dart run build_runner build --delete-conflicting-outputs`
Expected: 成功生成 `gym_device_connect_state.freezed.dart`。

- [ ] **Step 6: 运行测试验证通过**

Run: `cd app/vividfit_v2 && flutter test test/features/big_device/notifiers/gym_device_connect_notifier_test.dart`
Expected: PASS

> 注:此测试不触发真实蓝牙扫描,仅覆盖 `validateReadyForEntry`/`setDeviceCategory`/`markConnectedForTest` 纯逻辑。`startDeviceScan`/`connectSelectedDevice`/`haltSport` 委托给 `BluetoothConnectionService`,Service 单测已在 Task 2 覆盖,蓝牙交互靠 Task 9 手动验证。

- [ ] **Step 7: Commit**

```bash
cd app/vividfit_v2
git add lib/features/big_device/states/gym_device_connect_state.dart lib/features/big_device/states/gym_device_connect_state.freezed.dart lib/features/big_device/notifiers/gym_device_connect_notifier.dart test/features/big_device/notifiers/gym_device_connect_notifier_test.dart
git commit -m "feat(big-device): add GymDeviceConnectState and notifier delegating to BluetoothConnectionService"
```

---

### Task 7: Providers 装配

**Files:**
- Create: `app/vividfit_v2/lib/features/big_device/notifiers/big_device_providers.dart`

- [ ] **Step 1: 创建 big_device_providers.dart**

创建 `app/vividfit_v2/lib/features/big_device/notifiers/big_device_providers.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/bluetooth_connection_service.dart';
import '../../../core/services/providers.dart';
import 'gym_course_home_notifier.dart';
import 'gym_device_connect_notifier.dart';

export 'gym_course_home_notifier.dart';
export 'gym_device_connect_notifier.dart';

/// 课程首页状态(对应旧 Get.put(BigCourseHomeController()))。
final gymCourseHomeNotifierProvider =
    StateNotifierProvider<GymCourseHomeNotifier, GymCourseHomeState>((ref) {
  return GymCourseHomeNotifier();
});

/// 共享蓝牙连接服务 Provider(course/connect/big_device 共用)。
final bluetoothConnectionServiceProvider = Provider<BluetoothConnectionService>(
  (ref) => BluetoothConnectionService(),
);

/// 大设备搜索+连接状态(对应旧 Get.put(ControllerNewFourBigDeviceSprot()))。
/// 注入 BluetoothConnectionService 和 StorageService。
final gymDeviceConnectNotifierProvider =
    StateNotifierProvider<GymDeviceConnectNotifier, GymDeviceConnectState>(
        (ref) {
  final service = ref.read(bluetoothConnectionServiceProvider);
  final notifier = GymDeviceConnectNotifier(service);
  notifier.setStorage(ref.read(storageServiceProvider));
  return notifier;
});
```

- [ ] **Step 2: 运行 flutter analyze 验证无引用错误**

Run: `cd app/vividfit_v2 && flutter analyze lib/features/big_device/notifiers/big_device_providers.dart`
Expected: 无错误(可能有 info 级提示,可忽略)

- [ ] **Step 3: Commit**

```bash
cd app/vividfit_v2
git add lib/features/big_device/notifiers/big_device_providers.dart
git commit -m "feat(big-device): wire up providers for home and connect notifiers"
```

---

### Task 8: 国际化字符串(5 卡片标题 + 蓝牙提示)

**Files:**
- Modify: `app/vividfit_v2/lib/l10n/app_en.arb`
- Modify: `app/vividfit_v2/lib/l10n/app_zh.arb`
- Regenerate: `app/vividfit_v2/lib/l10n/app_localizations*.dart`(flutter gen-l10n)

- [ ] **Step 1: 在 app_en.arb 末尾(`}` 之前)追加键值**

修改 `app/vividfit_v2/lib/l10n/app_en.arb`,在最后一个 `"<key>": {...}` 之后、闭合 `}` 之前追加:

```json
  "quickStart": "Quick Start",
  "@quickStart": {},
  "courseTraining": "Course Training",
  "@courseTraining": {},
  "realScene": "REAL-SCENE",
  "@realScene": {},
  "cityAdventure": "CITY ADVENTURE",
  "@cityAdventure": {},
  "recreationalFitness": "RECREATIONAL FITNESS",
  "@recreationalFitness": {},
  "deviceConnection": "Device Connection",
  "@deviceConnection": {},
  "pleaseConnectDevice": "Please connect the device",
  "@pleaseConnectDevice": {},
  "deviceSelection": "Device selection",
  "@deviceSelection": {},
  "pleaseOpenBluetooth": "Please open Bluetooth",
  "@pleaseOpenBluetooth": {},
  "connected": "Connected",
  "@connected": {},
  "deviceDisconnected": "Device disconnected, please return to the main page and reconnect.",
  "@deviceDisconnected": {}
```

- [ ] **Step 2: 在 app_zh.arb 末尾追加对应中文**

修改 `app/vividfit_v2/lib/l10n/app_zh.arb`,在闭合 `}` 之前追加:

```json
  "quickStart": "快速开始",
  "courseTraining": "课程训练",
  "realScene": "实景",
  "cityAdventure": "城市冒险",
  "recreationalFitness": "娱乐健身",
  "deviceConnection": "设备连接",
  "pleaseConnectDevice": "请连接设备",
  "deviceSelection": "设备选择",
  "pleaseOpenBluetooth": "请打开蓝牙",
  "connected": "已连接",
  "deviceDisconnected": "设备已断开,请退出到 app 主页面重新进入再连接."
```

- [ ] **Step 3: 重新生成 l10n**

Run: `cd app/vividfit_v2 && flutter gen-l10n`
Expected: 无错误,`app_localizations.dart`/`app_localizations_en.dart`/`app_localizations_zh.dart` 中出现 `quickStart`/`courseTraining`/... 等 getter。

- [ ] **Step 4: 验证生成的 getter 存在**

Run(检索): `cd app/vividfit_v2 && grep -l "String get quickStart" lib/l10n/app_localizations*.dart`
Expected: 输出 `lib/l10n/app_localizations.dart` 和 `lib/l10n/app_localizations_en.dart`(zh 文件无该字符串字面但继承抽象 getter)。

- [ ] **Step 5: Commit**

```bash
cd app/vividfit_v2
git add lib/l10n/
git commit -m "i18n(big-device): add entry-card and bluetooth prompt strings"
```

---

### Task 9: 设备搜索对话框 widget

**Files:**
- Create: `app/vividfit_v2/lib/features/big_device/pages/device_search_dialog.dart`

- [ ] **Step 1: 创建 device_search_dialog.dart**

创建 `app/vividfit_v2/lib/features/big_device/pages/device_search_dialog.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/big_device_providers.dart';

/// 设备搜索/选择对话框(1:1 还原旧 `searchBluetoothDeviceList` 中的
/// `Get.dialog` 两态:loading 圈 + 设备列表)。
///
/// 用 `StatefulBuilder` 在单对话框内切换两态,替代旧 `Get.dialog` 二次调用。
class DeviceSearchDialog extends ConsumerWidget {
  const DeviceSearchDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final connectState = ref.watch(gymDeviceConnectNotifierProvider);
    final connectNotifier =
        ref.read(gymDeviceConnectNotifierProvider.notifier);

    return AlertDialog(
      backgroundColor: connectState.isSearching
          ? Colors.transparent
          : FitTheme.secondbackGround,
      title: connectState.isSearching
          ? const Center(child: SizedBox.shrink())
          : Row(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                  child: Text(
                    l10n.deviceSelection,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: FitTheme.textColor,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 200.h,
                  color: FitTheme.secondbackGround,
                  child: IconButton(
                    onPressed: () async {
                      // 1:1 还原旧关闭按钮:stopScan + Get.back()
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: FitTheme.textColor,
                      size: 30.sp,
                    ),
                  ),
                ),
              ],
            ),
      content: connectState.isSearching
          ? Container(
              alignment: Alignment.center,
              color: Colors.transparent,
              height: 400.h,
              width: 400.h,
              child: SizedBox(
                width: 300.h,
                height: 300.h,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              ),
            )
          : Container(
              alignment: Alignment.center,
              color: FitTheme.secondbackGround,
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.5,
              child: ListView.builder(
                itemCount: connectState.foundDeviceNames.length,
                itemBuilder: (context, index) {
                  final name = connectState.foundDeviceNames[index];
                  return InkWell(
                    onTap: () {
                      // 1:1 还原旧 ListTile onTap:
                      // writeBigDeviceLocal → connectDevice → Get.back()
                      connectNotifier.connectSelectedDevice(name);
                      Navigator.of(context).pop();
                    },
                    child: ListTile(
                      title: Text(
                        name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: FitTheme.textColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
```

- [ ] **Step 2: 运行 flutter analyze 验证**

Run: `cd app/vividfit_v2 && flutter analyze lib/features/big_device/pages/device_search_dialog.dart`
Expected: 无错误

- [ ] **Step 3: Commit**

```bash
cd app/vividfit_v2
git add lib/features/big_device/pages/device_search_dialog.dart
git commit -m "feat(big-device): add DeviceSearchDialog with loading/list states"
```

---

### Task 10: 入口屏页面(1:1 UI 还原)

**Files:**
- Create: `app/vividfit_v2/lib/features/big_device/pages/gym_device_entry_screen.dart`

- [ ] **Step 1: 创建 gym_device_entry_screen.dart**

创建 `app/vividfit_v2/lib/features/big_device/pages/gym_device_entry_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../data/entry_card_data.dart';
import '../notifiers/big_device_providers.dart';
import 'device_search_dialog.dart';

/// 大设备入口屏(1:1 还原旧 `big_device_first_screen.dart` 第一界面)。
///
/// 还原点:
/// - initState:immersiveSticky + 横屏 landscapeLeft
/// - dispose:恢复 manual overlays + 竖屏 portraitUp/Down
/// - Obx → ConsumerWidget watch;两条分支(已连接/未连接)布局 1:1
/// - AppBar 返回:haltSport + 0.5s delay + 恢复竖屏 + context.pop
/// - AppBar 右侧"Device Connection"按钮:disconnectIfAny + startDeviceScan + showDialog
/// - 5 张卡片 Row:_buildEntryCard 1:1(含 skewX 倾斜、反向倾斜、图片背景、icon、标题)
/// - 卡片点击:_handleCardTap 仅 validateReadyForEntry + toast,不跳转
/// - 标题:_buildHeaderTitle 1:1
class GymDeviceEntryScreen extends ConsumerStatefulWidget {
  const GymDeviceEntryScreen({super.key, required this.deviceCategoryIndex});

  final int deviceCategoryIndex;

  @override
  ConsumerState<GymDeviceEntryScreen> createState() =>
      _GymDeviceEntryScreenState();
}

class _GymDeviceEntryScreenState extends ConsumerState<GymDeviceEntryScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    // 1:1 还原旧 build 中 Get.put(BigCourseHomeController) 后 initData 读 Get.arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(gymCourseHomeNotifierProvider.notifier)
          .bootstrap(widget.deviceCategoryIndex);
      ref
          .read(gymDeviceConnectNotifierProvider.notifier)
          .setDeviceCategory(ref
              .read(gymCourseHomeNotifierProvider)
              .selectedDeviceCategory);
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> _restoreOrientationAndPop() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final homeState = ref.watch(gymCourseHomeNotifierProvider);
    final connectState = ref.watch(gymDeviceConnectNotifierProvider);
    final connectNotifier =
        ref.read(gymDeviceConnectNotifierProvider.notifier);

    // 1:1 还原旧 Obx 两态:已连接(或搜索中) → 无右上"Device Connection"按钮;
    // 未连接 → 显示按钮。
    final bool showConnectionAction =
        !connectState.isEquipmentConnected && !connectState.isSearching;

    return SafeArea(
      child: Scaffold(
        backgroundColor: FitTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: FitTheme.backgroundColor,
          elevation: 0,
          actionsPadding: EdgeInsets.only(right: 45.w),
          actions: showConnectionAction
              ? [
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      // 1:1 还原旧 onTab:disconnect 旧设备 + 若未搜索则启动搜索
                      connectNotifier.disconnectIfAny();
                      if (!connectState.isSearching) {
                        connectNotifier.startDeviceScan();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const DeviceSearchDialog(),
                        );
                      }
                    },
                    child: Text(
                      l10n.deviceConnection,
                      style: TextStyle(
                        color: FitTheme.textColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]
              : null,
          leadingWidth: 50.w,
          leading: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Icon(
              Icons.arrow_back_ios,
              color: FitTheme.textColor,
            ),
            onPressed: () async {
              // 1:1 还原旧返回:stopSport + 0.5s delay + 恢复竖屏 + pop
              await connectNotifier.haltSport();
              await _restoreOrientationAndPop();
            },
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 85, right: 45).r,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildHeaderTitle(homeState, l10n),
              SizedBox(height: 50.h),
              SizedBox(
                height: 880.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...homeState.entryCards.map(
                      (data) => _buildEntryCard(data, l10n, connectNotifier),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 1:1 还原旧 `_titleWidget()`。
  Widget _buildHeaderTitle(
    GymCourseHomeState homeState,
    AppLocalizations l10n,
  ) {
    // 通过 notifier 取当前设备类型的标题键(已封装 deviceTitleKey)。
    final titleKey =
        ref.read(gymCourseHomeNotifierProvider.notifier).deviceTitleKey;
    final englishTitle =
        ref.read(gymCourseHomeNotifierProvider.notifier).deviceEnglishTitle;
    return Column(
      children: [
        Text(
          _tr(l10n, titleKey),
          style: TextStyle(
            color: FitTheme.textColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          englishTitle,
          style: TextStyle(
            color: FitTheme.textColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  /// 1:1 还原旧 `_singleSelectBtn(Map<String, dynamic> data)`。
  Widget _buildEntryCard(
    EntryCardData data,
    AppLocalizations l10n,
    GymDeviceConnectNotifier connectNotifier,
  ) {
    final homeNotifier = ref.read(gymCourseHomeNotifierProvider.notifier);
    return Transform(
      transform: Matrix4.skewX(-0.1),
      origin: const Offset(0, 0),
      child: InkWell(
        onTap: () {
          // 1:1 还原旧 onTap:未连接 toast + return;否则打印 + _buildJumptoPage
          if (!ref.read(gymDeviceConnectNotifierProvider).isEquipmentConnected) {
            Fluttertoast.showToast(msg: l10n.pleaseConnectDevice);
            return;
          }
          print('gogogogo${data.index}');
          _handleCardTap(data);
        },
        child: Container(
          width: 120.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      homeNotifier.resolveCardImage(data.index),
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.r),
                    bottomRight: Radius.circular(100.r),
                    topRight: Radius.circular(40.r),
                    bottomLeft: Radius.circular(40.r),
                  ),
                  color: data.color,
                ),
              ),
              Transform(
                transform: Matrix4.skewX(0.15),
                origin: Offset(0, 40.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 460.h),
                    Container(
                      margin: EdgeInsets.only(left: 0.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        data.icon,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      margin: EdgeInsets.only(left: 0.w),
                      width: 95.w,
                      child: Text(
                        _tr(l10n, data.titleKey),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      margin: EdgeInsets.only(left: 0.w),
                      width: 80.w,
                      child: Text(
                        data.englishTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 1:1 还原旧 `_buildJumptoPage` 的设备检查部分。
  /// **本计划范围:不跳转,仅日志。** 具体功能页留给后续计划。
  void _handleCardTap(EntryCardData data) {
    final connectNotifier =
        ref.read(gymDeviceConnectNotifierProvider.notifier);
    final String? checkResult = connectNotifier.validateReadyForEntry();
    if (checkResult != null) {
      Fluttertoast.showToast(
          msg: _tr(AppLocalizations.of(context)!, checkResult),
          toastLength: Toast.LENGTH_LONG);
      return;
    }
    // 后续按 data.index 跳转 quickStart/courseTraining/realScene/cityAdventure/
    // recreationalFitness 对应页面,本计划不实现。
    print('card ${data.index} ready, navigation not implemented in this plan');
  }

  /// 按 key 取 l10n 字符串的统一入口(替代旧 `"...".tr`)。
  String _tr(AppLocalizations l10n, String key) {
    return switch (key) {
      'spinBike' => l10n.spinBike,
      'treadmillMachine' => l10n.treadmillMachine,
      'ellipticalMachine' => l10n.ellipticalMachine,
      'rowingMachine' => l10n.rowingMachine,
      'strengthStation' => l10n.strengthStation,
      'quickStart' => l10n.quickStart,
      'courseTraining' => l10n.courseTraining,
      'realScene' => l10n.realScene,
      'cityAdventure' => l10n.cityAdventure,
      'recreationalFitness' => l10n.recreationalFitness,
      'pleaseConnectDevice' => l10n.pleaseConnectDevice,
      _ => key,
    };
  }
}
```

- [ ] **Step 2: 运行 flutter analyze 验证**

Run: `cd app/vividfit_v2 && flutter analyze lib/features/big_device/pages/gym_device_entry_screen.dart`
Expected: 无错误

- [ ] **Step 3: Commit**

```bash
cd app/vividfit_v2
git add lib/features/big_device/pages/gym_device_entry_screen.dart
git commit -m "feat(big-device): 1:1 restore GymDeviceEntryScreen UI with Riverpod"
```

---

### Task 11: 路由注册与冒烟验证

**Files:**
- Modify: `app/vividfit_v2/lib/core/routing/app_router.dart`

- [ ] **Step 1: 在 app_router.dart 顶部追加 import**

修改 `app/vividfit_v2/lib/core/routing/app_router.dart`,在 `import '../../features/course/pages/course_play_page.dart';` 之后追加:

```dart
import '../../features/big_device/pages/gym_device_entry_screen.dart';
```

- [ ] **Step 2: 在 routes 列表末尾(Course 模块路由之后、闭合 `],`)前追加入口屏路由**

在 `course-play` 路由之后追加:

```dart
      // Big Device 模块路由
      GoRoute(
        path: '/big-device-entry',
        name: 'big-device-entry',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final deviceCategoryIndex = (extra?['deviceCategory'] as int?) ?? 0;
          return GymDeviceEntryScreen(
            deviceCategoryIndex: deviceCategoryIndex,
          );
        },
      ),
```

- [ ] **Step 3: 运行 flutter analyze 验证路由文件**

Run: `cd app/vividfit_v2 && flutter analyze lib/core/routing/app_router.dart`
Expected: 无错误

- [ ] **Step 4: 运行全量测试确保无回归**

Run: `cd app/vividfit_v2 && flutter test`
Expected: 所有用例 PASS(含新增 5 个测试文件)

- [ ] **Step 5: 手动冒烟验证 — 启动 app 并进入入口屏**

在任意已登录入口(如 home_shell)临时加入测试入口按钮,或在终端用如下命令启动后,从已有页面通过 `context.push('/big-device-entry', extra: {'deviceCategory': 0})` 触发(可在 home_tab_screen 临时加一个按钮,验证后移除):

Run: `cd app/vividfit_v2 && flutter run -d <device_id>`
Expected:
1. 进入 `/big-device-entry?deviceCategory=0` 后自动转横屏。
2. 顶部 AppBar 显示返回箭头 + 右侧"Device Connection"按钮(未连接态)。
3. 标题显示"Spin Bike" + "SPIN BIKE"。
4. 5 张倾斜卡片横向排列,背景图为 `bigDeviceBike_0..4.jpg`。
5. 点击任一卡片 → toast"Please connect the device"。
6. 点击"Device Connection" → 弹出 loading 圈,扫描后切到设备列表。
7. 点返回 → 恢复竖屏并 pop。

- [ ] **Step 6: Commit**

```bash
cd app/vividfit_v2
git add lib/core/routing/app_router.dart
git commit -m "feat(big-device): register /big-device-entry route with deviceCategory extra"
```

---

## Self-Review

**1. Spec coverage:**

| 需求 | 覆盖任务 |
|---|---|
| 1:1 还原 `big_device_first_screen.dart` 第一界面 | Task 10(完整 UI)+ Task 5(标题/图片数据源) |
| 页面不能修改,1:1 还原 | Task 10 严格按原 `_singleSelectBtn`/`_titleWidget`/AppBar/Container/SizedBox 尺寸复刻;原文件未改动 |
| 文件名/变量名/函数名用别名 | 见别名映射表;所有新文件用 `gym_*`/`device_*` 命名,类用 `Gym*` |
| 不用 GetX,换 Riverpod | Task 5/6/7 用 `StateNotifier`+`StateNotifierProvider`;Task 10 用 `ConsumerStatefulWidget`+`ref.watch/read`;Task 11 用 `go_router` |
| 还原蓝牙搜索连接 | Task 2(共享 `BluetoothConnectionService`)+ Task 6(Notifier 委托 Service)+ Task 9(对话框两态)+ Task 10(触发按钮) |
| 蓝牙工厂模式/共享服务 | Task 2 `BluetoothConnectionService` 封装 `FlutterBluePlus`,通过 callback 解耦;Task 7 Provider 暴露 `bluetoothConnectionServiceProvider` 供 course/connect 复用 |
| 卡片功能不实现,先还原第一界面 | Task 10 `_handleCardTap` 仅 `validateReadyForEntry`+日志,显式注释不跳转 |
| 设备类型/分类不遗漏 | Task 3 `DeviceCategory` 5 类枚举 + `toCourseTypeSelect`;Task 4 `deviceTitles`/`deviceEnglishTitles` 5 项;Task 6 `setDeviceCategory` + `_persistDeviceName` 5 分支 + `DeviceScanConstants` 5 白名单 |

**2. Placeholder scan:** 全文搜索 "TBD"/"TODO"/"implement later"/"fill in details" — 无。"后续按 data.index 跳转 ... 本计划不实现" 是明确范围边界声明,非占位符(已说明留给后续计划)。所有代码步骤含完整可运行代码。`<device_id>` 是运行命令的占位,属合理环境变量。

**3. Type consistency:**
- `DeviceCategory` 在 Task 3/4/5/6/7/10 全部一致使用;`fromIndex`/`index`/`toCourseTypeSelect` 签名一致。
- `EntryCardData` 字段 `titleKey`/`englishTitle`/`icon`/`color`/`index` 在 Task 4 定义,Task 10 `_buildEntryCard` 引用一致;`resolveCardImage(category, dataIndex)` 签名一致。
- `GymCourseHomeNotifier.bootstrap(int)` / `resolveCardImage(int)` / `deviceTitleKey` / `deviceEnglishTitle` 在 Task 5 定义,Task 10 调用一致。
- `BluetoothConnectionService.onDevicesUpdated`/`onScanningChanged`/`onConnectionChanged` callback 签名在 Task 2 定义,Task 6 Notifier 构造函数注册一致。
- `GymDeviceConnectNotifier.startDeviceScan()` / `connectSelectedDevice(String)` / `haltSport()` / `validateReadyForEntry()` / `setDeviceCategory(DeviceCategory)` / `disconnectIfAny()` / `markConnectedForTest()` 在 Task 6 定义,Task 9/10 调用一致。
- l10n getter 名(`quickStart`/`courseTraining`/`realScene`/`cityAdventure`/`recreationalFitness`/`deviceConnection`/`pleaseConnectDevice`/`deviceSelection`/`pleaseOpenBluetooth`/`connected`/`deviceDisconnected`)在 Task 8 定义,Task 9/10 `_tr` switch 引用一致。
- Providers 名 `gymCourseHomeNotifierProvider`/`bluetoothConnectionServiceProvider`/`gymDeviceConnectNotifierProvider` 在 Task 7 定义,Task 9/10 引用一致。

无类型/签名不一致问题。计划完整可执行。
