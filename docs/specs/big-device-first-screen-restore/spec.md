# Big Device First Screen 还原 Spec

## Why
旧项目 `vividfit` 中的 `big_device_first_screen.dart` 是大型健身设备(Bike/Treadmill/Elliptical/Rower/StrengthStation)的入口界面，包含设备分类选择、蓝牙搜索连接、5 张功能卡片展示。v2 项目需要 1:1 还原此界面，同时将 GetX 架构迁移为 flutter_riverpod + go_router，并将蓝牙连接层提升为共享 Service，供 course/connect 模块复用。

## What Changes
- **新增** `flutter_blue_plus` 依赖
- **新增** 5 个设备名存储键到 `StorageService`
- **新增** `lib/core/services/bluetooth_connection_service.dart` — 共享蓝牙连接服务（扫描/连接/断开/状态监听），所有模块共用
- **新增** `lib/features/big_device/data/device_category.dart` — 5 类设备枚举 + fromIndex/index/toCourseTypeSelect
- **新增** `lib/features/big_device/data/device_scan_constants.dart` — 5 类白名单常量
- **新增** `lib/features/big_device/data/entry_card_data.dart` — 5 张入口卡片数据 + 5 套背景图列表 + resolveCardImage
- **新增** `lib/features/big_device/states/gym_course_home_state.dart` — freezed 状态类
- **新增** `lib/features/big_device/states/gym_device_connect_state.dart` — freezed 连接状态类
- **新增** `lib/features/big_device/notifiers/gym_course_home_notifier.dart` — 课程首页 StateNotifier
- **新增** `lib/features/big_device/notifiers/gym_device_connect_notifier.dart` — 搜索连接 StateNotifier（委托 BluetoothConnectionService）
- **新增** `lib/features/big_device/notifiers/big_device_providers.dart` — 3 个 Provider 装配
- **新增** `lib/features/big_device/pages/device_search_dialog.dart` — 搜索弹窗 widget（loading + list 两态）
- **新增** `lib/features/big_device/pages/gym_device_entry_screen.dart` — 1:1 还原入口屏（横屏/竖屏切换、AppBar、标题、5 卡片 Row、skewX 效果）
- **修改** `lib/l10n/app_en.arb` / `app_zh.arb` — 新增 11 个国际化键
- **修改** `lib/core/routing/app_router.dart` — 注册 `/big-device-entry` 路由
- **新增** 5 个测试文件

## Impact
- Affected specs: 路由系统、国际化系统、状态管理系统、蓝牙服务层
- Affected code: `pubspec.yaml`、`lib/core/routing/app_router.dart`、`lib/l10n/*.arb`、`lib/core/services/storage_service.dart`

## ADDED Requirements

### Requirement: 共享蓝牙连接服务
The system SHALL 提供 `BluetoothConnectionService`，封装 `FlutterBluePlus` 的扫描/连接/断开，通过 callback 向调用方报告事件。Service 由 `bluetoothConnectionServiceProvider` 暴露，course/connect/big_device 模块均可复用。

#### Scenario: 蓝牙扫描
- **WHEN** 调用 `startScan(whitelist)`
- **THEN** Service 启动扫描，通过 `onDevicesUpdated` callback 通知发现设备，通过 `onScanningChanged` callback 通知搜索状态

#### Scenario: 蓝牙连接
- **WHEN** 调用 `connect(deviceName)`
- **THEN** Service 连接设备，通过 `onConnectionChanged` callback 通知连接状态

### Requirement: 1:1 还原 big_device_first_screen.dart 第一界面
The system SHALL 提供与原 GetX 版本完全一致的入口屏 UI，包括横竖屏切换、倾斜卡片（skewX -0.1 / 0.15）、AppBar 退回按钮、设备标题、5 张功能卡片。

#### Scenario: 横屏展示
- **WHEN** 设备横屏
- **THEN** 页面宽度 880.w，高度 460.h，卡片宽度 120.w

#### Scenario: 竖屏展示
- **WHEN** 设备竖屏
- **THEN** 页面宽度 750.w，高度 1000.h，卡片宽度 200.w

#### Scenario: 卡片点击触发搜索弹窗
- **WHEN** 用户点击"快速开始"卡片
- **THEN** 若未连接设备，弹出搜索对话框；若已连接，打印日志（具体跳转不实现）

### Requirement: 5 类设备完整保留
The system SHALL 保留 Bike(0)/Treadmill(1)/Elliptical(2)/Rower(3)/StrengthStation(4) 全部设备类型，不遗漏任何分类。

#### Scenario: 设备类型切换
- **WHEN** 路由参数 `deviceCategory` 为 0-4
- **THEN** 页面标题、背景图、搜索白名单、本地存储键均正确对应

### Requirement: 蓝牙搜索连接状态机
The system SHALL 1:1 还原旧 Controller 的搜索连接状态机：搜索中/已连接/发现设备列表/断连提示。

#### Scenario: 搜索未开蓝牙
- **WHEN** 用户触发搜索且蓝牙未开启
- **THEN** Toast 提示"请打开蓝牙"，搜索状态自动结束

#### Scenario: 设备连接成功
- **WHEN** 用户选择设备并连接成功
- **THEN** Toast 提示"connected"，保存设备名到本地存储

#### Scenario: 设备断开连接
- **WHEN** 已连接设备断开
- **THEN** Toast 提示"deviceDisconnected"

### Requirement: 别名命名防重
The system SHALL 使用与旧版本不同的类名、文件名、变量名、函数名。

#### Scenario: 命名映射
- **旧 `BigDeviceFirstScreen`** → **新 `GymDeviceEntryScreen`**
- **旧 `ControllerBigCourseHome`** → **新 `GymCourseHomeNotifier`**
- **旧 `ControllerNewFourBigDeviceSprot`** → **新 `GymDeviceConnectNotifier`**
- **旧 `newMainSelectType`** → **新 `selectedDeviceCategory`**
- **旧 `deviceTypeIndex`** → **新 `deviceCategory`**

## MODIFIED Requirements

### Requirement: 状态管理从 GetX 迁移到 Riverpod
- **旧**: `Obx` + `Get.put()` + `Get.find()` + `Get.to()`
- **新**: `StateNotifier` + `StateNotifierProvider` + `ConsumerStatefulWidget` + `context.go()`

### Requirement: 路由参数传递
- **旧**: `Get.arguments` 传递 `List<dynamic>` 参数
- **新**: `go_router` 的 `state.extra` 传递 `Map<String, dynamic>` 参数，键为 `deviceCategory`

## REMOVED Requirements

### Requirement: GetX 依赖
**Reason**: 项目架构已统一为 flutter_riverpod + go_router
**Migration**: 所有 GetX 的 `Obx`、`Get.put()`、`Get.to()`、`Get.arguments` 替换为 Riverpod/go_router 对应方案

### Requirement: 设备专属数据解析
**Reason**: 当前阶段仅还原第一界面，运动数据解析（discoverS、速度/坡度/阻力调节、指令队列）在后续 play screen 中实现
**Migration**: discoverS 和 data_model 暂不迁移，仅保留连接状态机
