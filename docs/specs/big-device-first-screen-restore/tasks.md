# Tasks

- [x] **Task 1: 添加 flutter_blue_plus 依赖与设备名存储键**
  - [x] 在 `pubspec.yaml` 添加 `flutter_blue_plus: ^1.35.3`
  - [x] 运行 `flutter pub get`
  - [x] 在 `StorageService` 添加 5 个设备名 setter（bikeMachine、treadmill、ellipticalMachine、powerMachine、powerStationMachine）
  - [x] 运行 `flutter test` 确保无回归

- [x] **Task 2: 创建共享蓝牙连接服务 BluetoothConnectionService**
  - [x] 创建 `lib/core/services/bluetooth_connection_service.dart`
  - [x] 实现 `startScan(whitelist)` — 扫描 + 去重 + callback 通知
  - [x] 实现 `connect(deviceName)` — 查找设备 + 停止扫描 + 连接 + 状态订阅
  - [x] 实现 `disconnect()` — 取消订阅 + 断开设备
  - [x] 实现 `disconnectIfAny()` — 若存在连接则断开
  - [x] 实现 `dispose()` — 释放所有 StreamSubscription
  - [x] 实现 `BluetoothNotEnabledException`
  - [x] 创建 `test/core/services/bluetooth_connection_service_test.dart`（callback 路由测试）

- [x] **Task 3: 创建设备类型枚举与搜索白名单常量**
  - [x] 创建 `lib/features/big_device/data/device_category.dart`（DeviceCategory 枚举 5 类 + fromIndex/index/toCourseTypeSelect）
  - [x] 创建 `lib/features/big_device/data/device_scan_constants.dart`（5 套白名单 Set<String>）
  - [x] 创建 `test/features/big_device/data/device_category_test.dart`
  - [x] 创建 `test/features/big_device/data/device_scan_constants_test.dart`

- [x] **Task 4: 创建入口卡片数据与背景图解析器**
  - [x] 创建 `lib/features/big_device/data/entry_card_data.dart`（EntryCardData + defaultCards + resolveCardImage）
  - [x] 确认旧项目 5 套图片目录是否存在/已复制到 v2
  - [x] 创建 `test/features/big_device/data/entry_card_data_test.dart`（resolveCardImage 返回正确）

- [x] **Task 5: 创建 GymCourseHomeState 与 GymCourseHomeNotifier**
  - [x] 创建 `lib/features/big_device/states/gym_course_home_state.dart`（freezed）
  - [x] 运行 `build_runner` 生成 `gym_course_home_state.freezed.dart`
  - [x] 创建 `lib/features/big_device/notifiers/gym_course_home_notifier.dart`（bootstrap/resolveCardImage/deviceTitleKey/deviceEnglishTitle）
  - [x] 创建 `test/features/big_device/notifiers/gym_course_home_notifier_test.dart`

- [x] **Task 6: 创建 GymDeviceConnectState 与 GymDeviceConnectNotifier**
  - [x] 创建 `lib/features/big_device/states/gym_device_connect_state.dart`（freezed）
  - [x] 运行 `build_runner` 生成 `gym_device_connect_state.freezed.dart`
  - [x] 创建 `lib/features/big_device/notifiers/gym_device_connect_notifier.dart`（委托 BluetoothConnectionService，不直接依赖 FlutterBluePlus）
  - [x] 实现 setDeviceCategory / startDeviceScan / connectSelectedDevice / haltSport / validateReadyForEntry / disconnectIfAny / markConnectedForTest
  - [x] 创建 `test/features/big_device/notifiers/gym_device_connect_notifier_test.dart`

- [x] **Task 7: Providers 装配**
  - [x] 创建 `lib/features/big_device/notifiers/big_device_providers.dart`
  - [x] 注册 `gymCourseHomeNotifierProvider`
  - [x] 注册 `bluetoothConnectionServiceProvider`（共享 Service）
  - [x] 注册 `gymDeviceConnectNotifierProvider`（注入 Service + StorageService）

- [x] **Task 8: 添加国际化字符串**
  - [x] 在 `app_en.arb` 添加 11 个键：quickStart、courseTraining、realScene、cityAdventure、recreationalFitness、deviceConnection、pleaseConnectDevice、deviceSelection、pleaseOpenBluetooth、connected、deviceDisconnected
  - [x] 在 `app_zh.arb` 添加对应中文翻译
  - [x] 运行 `flutter gen-l10n`
  - [x] 确认 `app_localizations.dart` 已包含新增 getter

- [x] **Task 9: 创建设备搜索对话框 widget**
  - [x] 创建 `lib/features/big_device/pages/device_search_dialog.dart`
  - [x] 实现搜索中 Loading 态（RotateAnimation 转圈）
  - [x] 实现设备列表 ListView.separated 态（显示广播名 + 取消按钮）
  - [x] 实现"获取设备信息"功能按钮（点击立即断开旧设备 + 启动扫描）
  - [x] 对话框用 StatefulBuilder 驱动，不单独用 StatefulWidget

- [x] **Task 10: 创建入口屏页面（1:1 UI 还原）**
  - [x] 创建 `lib/features/big_device/pages/gym_device_entry_screen.dart`
  - [x] ConsumerStatefulWidget + `OrientationBuilder` 横竖屏切换
  - [x] AppBar 带退回按钮（横屏 bottom 0、竖屏 top 0）
  - [x] 标题 Widget：中文 + 英文副标题（isEnglishTitle 带阴影）
  - [x] 5 张入口卡片 Row：Wrap 居中、skewX 倾斜、宽高比、图片 + 文字叠加
  - [x] 卡片点击 → `_handleCardTap` → 搜索弹窗或日志

- [x] **Task 11: 路由注册与冒烟验证**
  - [x] 在 `app_router.dart` 添加 `/big-device-entry` 路由（state.extra 为 Map<String, dynamic>）
  - [x] 运行 `flutter analyze` 确保无错误
  - [x] 运行 `flutter test` 确保全量通过（5 个新增测试文件）
  - [x] 手动冒烟：临时入口触发 `context.push('/big-device-entry', extra: {'deviceCategory': 0})`

# Task Dependencies

- Task 1（依赖+存储键）→ Task 2（蓝牙 Service）→ Task 6（Notifier 委托 Service）
- Task 1（依赖+存储键）→ Task 3（枚举+白名单）→ Task 4（卡片数据）→ Task 5（HomeState+Notifier）
- Task 3（枚举）→ Task 6（ConnectNotifier 用 DeviceCategory）
- Task 5（HomeNotifier）+ Task 6（ConnectNotifier）→ Task 7（Providers 装配）
- Task 7（Providers）→ Task 9（弹窗用 Provider）+ Task 10（页面用 Provider）
- Task 8（国际化）→ Task 9（弹窗文本）+ Task 10（页面文本）
- Task 9（弹窗）+ Task 10（页面）→ Task 11（路由注册+冒烟）
