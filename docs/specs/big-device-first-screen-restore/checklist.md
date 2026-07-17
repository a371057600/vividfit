# Checklist

## Spec 覆盖验证

- [x] `spec.md` 中所有 Requirement 均在 `tasks.md` 中有对应任务
- [x] `tasks.md` 中所有任务均在 `checklist.md` 中有验证检查点
- [x] 5 类设备(Bike/Treadmill/Elliptical/Rower/StrengthStation)均无遗漏
- [x] 蓝牙连接层已提升为共享 Service，不耦合 big_device 模块

## 依赖与基础设施

- [x] `pubspec.yaml` 已添加 `flutter_blue_plus: ^1.35.3`
- [x] `flutter pub get` 成功，无依赖冲突
- [x] `StorageService` 已添加 5 个设备名 setter 方法

## 共享蓝牙服务层

- [x] `bluetooth_connection_service.dart` 存在且可编译
- [x] `BluetoothConnectionService` 持有 `BluetoothDevice?` 和 `StreamSubscription` 生命周期
- [x] `startScan(whitelist)` 实现：去重 + callback 通知 + 6 秒兜底 + 未开蓝牙异常
- [x] `connect(deviceName)` 实现：查找设备 + 停止扫描 + 连接 + 状态订阅
- [x] `disconnect()` 实现：取消订阅 + 断开设备 + 清理 targetDevice
- [x] `disconnectIfAny()` 实现：若 targetDevice 存在则断开
- [x] `dispose()` 实现：释放所有订阅
- [x] `BluetoothNotEnabledException` 定义正确
- [x] 测试文件 `bluetooth_connection_service_test.dart` 存在且通过

## 数据层

- [x] `device_category.dart` 存在：5 类枚举 + fromIndex(0-4) + index getter + toCourseTypeSelect
- [x] `device_scan_constants.dart` 存在：5 套白名单 Set<String> + whitelistFor(category)
- [x] `entry_card_data.dart` 存在：EntryCardData + defaultCards + resolveCardImage
- [x] 测试 `device_category_test.dart` 通过
- [x] 测试 `device_scan_constants_test.dart` 通过
- [x] 测试 `entry_card_data_test.dart` 通过

## 状态层

- [x] `gym_course_home_state.dart` 存在且 freezed 生成成功
- [x] `gym_device_connect_state.dart` 存在且 freezed 生成成功
- [x] `gym_course_home_state.freezed.dart` 已生成，无编译错误
- [x] `gym_device_connect_state.freezed.dart` 已生成，无编译错误

## Notifier 层

- [x] `gym_course_home_notifier.dart` 存在：bootstrap / resolveCardImage / deviceTitleKey / deviceEnglishTitle
- [x] `gym_device_connect_notifier.dart` 存在：委托 BluetoothConnectionService，不直接 import flutter_blue_plus
- [x] `GymDeviceConnectNotifier` 构造函数通过 callback 注册事件转换
- [x] `setDeviceCategory` / `startDeviceScan` / `connectSelectedDevice` / `haltSport` / `validateReadyForEntry` / `disconnectIfAny` / `markConnectedForTest` 均已实现
- [x] 测试 `gym_course_home_notifier_test.dart` 通过
- [x] 测试 `gym_device_connect_notifier_test.dart` 通过

## Providers 层

- [x] `big_device_providers.dart` 存在
- [x] `gymCourseHomeNotifierProvider` 注册正确
- [x] `bluetoothConnectionServiceProvider` 注册正确（共享 Service）
- [x] `gymDeviceConnectNotifierProvider` 注入 Service + StorageService

## 国际化

- [x] `app_en.arb` 已添加 11 个键
- [x] `app_zh.arb` 已添加 11 个中文翻译
- [x] `flutter gen-l10n` 生成成功
- [x] `app_localizations.dart` 包含所有新增 getter

## UI 层

- [x] `device_search_dialog.dart` 存在
- [x] 对话框 Loading 态：RotateAnimation 持续旋转
- [x] 对话框列表态：ListView.separated 显示设备广播名 + 取消按钮
- [x] "获取设备信息"按钮：点击断开旧设备 + 启动扫描
- [x] `gym_device_entry_screen.dart` 存在
- [x] 横屏布局：宽度 880.w，高度 460.h，卡片 120.w
- [x] 竖屏布局：宽度 750.w，高度 1000.h，卡片 200.w
- [x] AppBar 退回按钮：横屏 bottom 0，竖屏 top 0
- [x] 标题 Widget：中文 + 英文副标题（isEnglishTitle 带 TextShadow）
- [x] 5 张卡片 Row：Wrap 居中、skewX -0.1/0.15、宽高比、图片 + 文字叠加
- [x] `_handleCardTap`：未连接 → 弹窗，已连接 → 日志（不跳转）

## 路由

- [x] `app_router.dart` 已添加 `/big-device-entry` 路由
- [x] 路由 handler 从 `state.extra` 读取 `deviceCategory` int 参数
- [x] 路由可正常导航进入和返回

## 质量门禁

- [x] `flutter analyze` 无错误无警告
- [x] `flutter test` 全量通过（5 个新增测试文件 + 既有测试无回归）
- [x] 手动冒烟：从临时入口进入 big-device-entry 页面，UI 与旧项目一致
