# Riverpod Code-Gen 架构迁移报告与实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将 vividfit_v2 项目全部 16 个 Provider 从传统手写语法迁移到 `@riverpod` 代码生成架构,统一风格、减少样板代码、提升可维护性。

**Architecture:** 引入 `riverpod_annotation` + `riverpod_generator` + `riverpod_lint`,将所有 `StateNotifierProvider<T, S>((ref) => ...)` 和 `Provider<T>((ref) => ...)` 改写为 `@riverpod` 注解形式。Notifier 类从 `extends StateNotifier<S>` + 构造函数注入改为 `extends _$Xxx` + `build()` 方法内通过 `ref` 注入。Provider 声明由 build_runner 自动生成,不再手写。

**Tech Stack:** Flutter 3.7+, flutter_riverpod ^2.6.1, riverpod_annotation, riverpod_generator, riverpod_lint, build_runner, freezed

---

## 第一部分:用户问题回答报告

### 问题 1:当前 providers 写法是否是新的架构写法?

**结论:不是。当前全部 16 个 Provider 使用传统手写语法,未使用 `@riverpod` 代码生成。**

#### 当前写法(传统手写)

```dart
// ❌ 当前写法 — 需要手写 Provider 声明 + 构造函数注入
class GymDeviceConnectNotifier extends StateNotifier<GymDeviceConnectState> {
  GymDeviceConnectNotifier(this._service) : super(const GymDeviceConnectState());
  final BluetoothConnectionService _service;
  StorageService? _storage;
  void setStorage(StorageService storage) => _storage = storage;
}

final gymDeviceConnectNotifierProvider =
    StateNotifierProvider<GymDeviceConnectNotifier, GymDeviceConnectState>((ref) {
  final service = ref.read(bluetoothConnectionServiceProvider);
  final notifier = GymDeviceConnectNotifier(service);
  notifier.setStorage(ref.read(storageServiceProvider));
  return notifier;
});
```

#### 新架构写法(@riverpod 代码生成)

```dart
// ✅ 新写法 — 注解自动生成 Provider,ref 直接可用,无需构造函数注入
@riverpod
class GymDeviceConnectNotifier extends _$GymDeviceConnectNotifier {
  @override
  GymDeviceConnectState build() {
    final service = ref.watch(bluetoothConnectionServiceProvider);
    _storage = ref.watch(storageServiceProvider);
    service.onDevicesUpdated = (names) => state = state.copyWith(foundDeviceNames: names);
    service.onScanningChanged = (s) => state = state.copyWith(isSearching: s);
    service.onConnectionChanged = (c, h) {
      state = state.copyWith(isEquipmentConnected: c, hasConnectedOnce: state.hasConnectedOnce || h);
    };
    return const GymDeviceConnectState();
  }

  late final BluetoothConnectionService _service; // 在 build 中赋值
  late StorageService _storage;
  // ... 方法用 state 而非 super.state
}
```

#### 传统 vs 代码生成的核心差异

| 维度 | 传统手写 | @riverpod 代码生成 |
|---|---|---|
| Provider 声明 | 手写 `final xxxProvider = StateNotifierProvider<...>((ref) => ...)` | 注解 `@riverpod` 自动生成 |
| 依赖注入 | 构造函数参数 + Provider 中 `ref.watch` 后传入 | `build()` 方法内直接 `ref.watch` |
| Notifier 基类 | `extends StateNotifier<S>` | `extends _$Xxx`(生成) |
| 初始化 | 构造函数 `super(initialState)` | `build()` 方法 `return initialState` |
| 文件数量 | Notifier 文件 + Provider 文件(2 个) | Notifier 文件含注解(1 个) |
| 样板代码 | 多(每个 Provider 5-8 行声明) | 少(1 行注解) |
| Lint 支持 | 无 riverpod 专用 lint | riverpod_lint 提供自动补全/重构/规则检查 |
| ref 访问 | 构造函数注入后存为私有字段 | `this.ref` 直接可用(继承自生成基类) |

#### `riverpod_generator` 和 `riverpod_lint` 是否有用上?

**结论:均未在 `pubspec.yaml` 中声明,整个项目 0 处使用 `@riverpod` 注解。**

- `pubspec.yaml` 的 `dev_dependencies` 中无 `riverpod_generator`、无 `riverpod_lint`、无 `riverpod_annotation`
- `build_runner` 已声明(^2.4.13),目前仅用于 freezed 代码生成
- 全项目搜索 `@riverpod` 注解:**0 处匹配**

---

### 问题 2:现有模块的 notifiers 能否都改成新的架构写法?

**结论:可以,全部 9 个 StateNotifier + 7 个普通 Provider 均可迁移,无技术障碍。**

#### 迁移可行性矩阵

| # | 模块 | Notifier/Provider | 当前注入方式 | 迁移难度 | 备注 |
|---|---|---|---|---|---|
| 1 | core/services | `storageServiceProvider` | `overrideWithValue` | 低 | 改为 `@Riverpod(keepAlive: true)` |
| 2 | core/services | `apiServiceProvider` | `ref.watch(storageService)` | 低 | 函数式 `@riverpod` |
| 3 | core/services | `homeRepositoryProvider` | `ref.read(api, storage)` | 低 | 函数式 `@riverpod` |
| 4 | auth | `authRepositoryProvider` | `ref.watch(apiService)` | 低 | 函数式 `@riverpod` |
| 5 | auth | `AuthNotifier` | 构造函数(repo, storage) | 中 | 有 StreamSubscription 生命周期 |
| 6 | home | `HomeNotifier` | 构造函数(repo, storage) | 中 | 有异步 `_restore` |
| 7 | home | `BodyDataNotifier` | 构造函数(storage) | 低 | 同步 `_restore` |
| 8 | home | `GoalSettingNotifier` | 构造函数(storage) | 低 | 异步 `_restore` |
| 9 | course | `courseRepositoryProvider` | `ref.read(api, storage)` | 低 | 函数式 `@riverpod` |
| 10 | course | `CourseListNotifier` | 构造函数(repo, storage, homeRepo) | 中 | 3 个依赖 |
| 11 | course | `CourseDetailNotifier` | 构造函数(repo, storage, homeRepo) | 中 | 3 个依赖 |
| 12 | about | `UserSettingsNotifier` | 无依赖 | 低 | 最简单 |
| 13 | big_device | `bluetoothConnectionServiceProvider` | 无依赖 | 低 | 函数式 `@riverpod` |
| 14 | big_device | `GymCourseHomeNotifier` | 无依赖 | 低 | 最简单 |
| 15 | big_device | `GymDeviceConnectNotifier` | 构造函数(service) + setStorage(storage) | 中 | 有 callback 注册 + dispose |
| 16 | routing | `appRouterProvider` | 内部用 `ref.listen(authNotifier)` | 中 | GoRouter + ChangeNotifier 桥接 |

#### 迁移收益

1. **消除 Provider 聚合文件**:各模块的 `xxx_providers.dart` 不再需要手写 Provider 声明,由注解生成
2. **消除构造函数注入样板**:Notifier 不再需要 `XxxNotifier(this._a, this._b) : super(...)` + Provider 中 `ref.watch` 拼装
3. **统一 ref 访问**:所有 Notifier 通过继承的 `ref` 直接访问依赖,不再需要 `setStorage()` 之类的 setter
4. **riverpod_lint 辅助**:IDE 自动补全 Provider 名称、重构提示、未使用 Provider 警告
5. **向后兼容**:迁移后的 Provider 与传统 Provider 可共存(渐进式迁移),已迁移模块可独立工作

#### 迁移风险

1. **freezed + riverpod_generator 同时使用 build_runner**:两者都用 `part` 指令,需确认 `part` 声明不冲突(freezed 用 `part 'xxx.freezed.dart'`,riverpod 用 `part 'xxx.g.dart'`,不冲突)
2. **`storageServiceProvider` 的 override 模式**:当前在 `main()` 中 `overrideWithValue`,改用 `@Riverpod(keepAlive: true)` 后需确认 override 语法兼容
3. **`appRouterProvider` 的 ChangeNotifier 桥接**:GoRouter 的 `refreshListenable` 需要 `ChangeNotifier`,迁移后 `ref.listen` 位置需调整
4. **测试中 Provider override**:当前测试用 `ProviderScope(overrides: [...])`,迁移后 override 目标从 `xxxProvider` 变为生成的 `xxxProvider`,语法变化不大但需逐一验证

---

## 第二部分:文件结构

### 迁移前(当前)

```
lib/
  core/services/
    providers.dart              # 3 个手写 Provider
    storage_service.dart
    api_service.dart
  core/routing/
    app_router.dart             # 1 个手写 Provider + _AuthRefreshListenable
  features/auth/notifiers/
    auth_providers.dart         # 2 个手写 Provider(authRepository + authNotifier)
    auth_notifier.dart          # extends StateNotifier<AuthState>
  features/home/notifiers/
    home_providers.dart         # 1 个手写 Provider
    home_notifier.dart          # extends StateNotifier<HomeState>
    body_data_notifier.dart     # extends StateNotifier<BodyDataState> + 1 个手写 Provider
    goal_setting_notifier.dart  # extends StateNotifier<GoalSettingState> + 1 个手写 Provider
  features/course/notifiers/
    course_providers.dart       # 3 个手写 Provider + export
    course_list_notifier.dart   # extends StateNotifier<CourseListState>
    course_detail_notifier.dart # extends StateNotifier<CourseDetailState>
  features/about/notifiers/
    about_providers.dart        # 1 个手写 Provider
    user_settings_notifier.dart # extends StateNotifier<UserSettingsState>
  features/big_device/notifiers/
    big_device_providers.dart   # 3 个手写 Provider + export
    gym_course_home_notifier.dart
    gym_device_connect_notifier.dart
```

### 迁移后(目标)

```
lib/
  core/services/
    storage_service_provider.dart    # @Riverpod(keepAlive: true) — 需要 override
    api_service.dart                 # 无 Provider(由 home_repository_provider 引用)
    api_service_provider.dart        # @riverpod 函数式
    home_repository.dart
    home_repository_provider.dart    # @riverpod 函数式
  core/routing/
    app_router_provider.dart         # @riverpod — GoRouter + ref.listen
  features/auth/notifiers/
    auth_repository_provider.dart    # @riverpod 函数式
    auth_notifier.dart               # @riverpod class AuthNotifier extends _$AuthNotifier
  features/home/notifiers/
    home_notifier.dart               # @riverpod class
    body_data_notifier.dart          # @riverpod class
    goal_setting_notifier.dart       # @riverpod class
  features/course/notifiers/
    course_repository_provider.dart  # @riverpod 函数式
    course_list_notifier.dart        # @riverpod class
    course_detail_notifier.dart      # @riverpod class
  features/about/notifiers/
    user_settings_notifier.dart      # @riverpod class
  features/big_device/notifiers/
    bluetooth_connection_provider.dart  # @riverpod 函数式
    gym_course_home_notifier.dart       # @riverpod class
    gym_device_connect_notifier.dart    # @riverpod class
```

**文件数变化**:删除 7 个 `xxx_providers.dart` 聚合文件,新增 4 个独立 provider 文件(函数式),Notifier 文件数不变但内容变更(加注解 + 改基类)。

---

## 第三部分:迁移任务

### Task 1: 添加 riverpod 代码生成依赖

**Files:**
- Modify: `app/vividfit_v2/pubspec.yaml`

- [ ] **Step 1: 在 pubspec.yaml 的 dependencies 中添加 riverpod_annotation**

在 `flutter_riverpod: ^2.6.1` 下方添加:

```yaml
  # 状态管理
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
```

- [ ] **Step 2: 在 pubspec.yaml 的 dev_dependencies 中添加 riverpod_generator 和 riverpod_lint**

在 `json_serializable: ^6.8.0` 下方添加:

```yaml
  # 代码生成
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  riverpod_generator: ^2.6.1
  riverpod_lint: ^2.6.1
```

- [ ] **Step 3: 运行 flutter pub get**

Run: `cd app/vividfit_v2 && flutter pub get`
Expected: 成功,无依赖冲突

- [ ] **Step 4: 添加 analysis_options.yaml 的 riverpod lint 规则**

检查 `app/vividfit_v2/analysis_options.yaml`,在 `analyzer.plugins` 或 `include` 中添加 riverpod_lint。如果文件不存在或无 plugins 配置,添加:

```yaml
analyzer:
  plugins:
    - custom_lint
```

- [ ] **Step 5: Commit**

```bash
cd app/vividfit_v2
git add pubspec.yaml analysis_options.yaml
git commit -m "chore: add riverpod_generator, riverpod_lint, riverpod_annotation for code-gen"
```

---

### Task 2: 迁移 core/services 模块(3 个 Provider)

**Files:**
- Create: `app/vividfit_v2/lib/core/services/storage_service_provider.dart`
- Create: `app/vividfit_v2/lib/core/services/api_service_provider.dart`
- Create: `app/vividfit_v2/lib/core/services/home_repository_provider.dart`
- Delete: `app/vividfit_v2/lib/core/services/providers.dart`(迁移完成后删除)
- Modify: 所有 import 了 `providers.dart` 的文件(改 import 路径)

- [ ] **Step 1: 创建 storage_service_provider.dart**

创建 `app/vividfit_v2/lib/core/services/storage_service_provider.dart`:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'storage_service.dart';

part 'storage_service_provider.g.dart';

/// StorageService provider。
///
/// **必须在 `main()` 中用 `overrideWithValue` 覆盖**,
/// 因为 StorageService 需要异步初始化,在 ProviderScope 创建前完成。
@Riverpod(keepAlive: true)
StorageService storageService(Ref ref) {
  throw UnimplementedError(
    'storageServiceProvider 必须在 main() 中用 overrideWithValue 覆盖',
  );
}
```

- [ ] **Step 2: 创建 api_service_provider.dart**

创建 `app/vividfit_v2/lib/core/services/api_service_provider.dart`:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'api_service.dart';
import 'storage_service_provider.dart';

part 'api_service_provider.g.dart';

@riverpod
ApiService apiService(Ref ref) {
  final storage = ref.watch(storageServiceProvider);
  return ApiService(storage);
}
```

- [ ] **Step 3: 创建 home_repository_provider.dart**

创建 `app/vividfit_v2/lib/core/services/home_repository_provider.dart`:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/home/repositories/home_repository.dart';
import 'api_service_provider.dart';
import 'storage_service_provider.dart';

part 'home_repository_provider.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository(
    ref.watch(apiServiceProvider),
    ref.watch(storageServiceProvider),
  );
}
```

- [ ] **Step 4: 运行 build_runner 生成 .g.dart**

Run: `cd app/vividfit_v2 && dart run build_runner build --delete-conflicting-outputs`
Expected: 生成 3 个 `.g.dart` 文件,无错误

- [ ] **Step 5: 全局替换 import 路径**

全局搜索 `import.*core/services/providers.dart` 并替换为对应的 import:

```dart
// 旧
import '../../../core/services/providers.dart';
// 新(按需引入)
import '../../../core/services/storage_service_provider.dart';
import '../../../core/services/api_service_provider.dart';
import '../../../core/services/home_repository_provider.dart';
```

受影响文件:
- `lib/features/auth/notifiers/auth_providers.dart`
- `lib/features/home/notifiers/home_providers.dart`
- `lib/features/home/notifiers/body_data_notifier.dart`
- `lib/features/home/notifiers/goal_setting_notifier.dart`
- `lib/features/course/notifiers/course_providers.dart`
- `lib/features/big_device/notifiers/big_device_providers.dart`

- [ ] **Step 6: 运行测试验证**

Run: `cd app/vividfit_v2 && flutter test`
Expected: All tests passed(此阶段尚未删除旧 providers.dart,新旧共存)

- [ ] **Step 7: 删除旧 providers.dart**

确认无文件 import `core/services/providers.dart` 后删除:

```bash
rm app/vividfit_v2/lib/core/services/providers.dart
```

- [ ] **Step 8: 运行 flutter analyze + flutter test**

Run: `cd app/vividfit_v2 && flutter analyze && flutter test`
Expected: 0 issues + All tests passed

- [ ] **Step 9: Commit**

```bash
cd app/vividfit_v2
git add -A
git commit -m "refactor(core): migrate storage/api/homeRepo providers to @riverpod code-gen"
```

---

### Task 3: 迁移 auth 模块(2 个 Provider)

**Files:**
- Create: `app/vividfit_v2/lib/features/auth/notifiers/auth_repository_provider.dart`
- Modify: `app/vividfit_v2/lib/features/auth/notifiers/auth_notifier.dart`
- Delete: `app/vividfit_v2/lib/features/auth/notifiers/auth_providers.dart`

- [ ] **Step 1: 创建 auth_repository_provider.dart**

创建 `app/vividfit_v2/lib/features/auth/notifiers/auth_repository_provider.dart`:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/api_service_provider.dart';
import '../repositories/auth_repository.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final api = ref.watch(apiServiceProvider);
  return AuthRepository(api);
}
```

- [ ] **Step 2: 迁移 auth_notifier.dart 为 @riverpod 类**

读取 `app/vividfit_v2/lib/features/auth/notifiers/auth_notifier.dart` 全文。将文件改写为:

```dart
import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_provider.dart';
import '../../../data/models/login_response.dart';
import '../../../data/models/user_info.dart';
import '../repositories/auth_repository.dart';
import '../states/auth_state.dart';
import 'auth_repository_provider.dart';

part 'auth_notifier.g.dart';

/// 登录状态机(1:1 迁移自旧项目 NewLoginController)。
@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final AuthRepository _repository;
  late final StorageService _storage;
  late StreamSubscription _connectivitySubscription;
  late Connectivity _connectivity;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    _storage = ref.watch(storageServiceProvider);
    _connectivity = Connectivity();
    _restoreFromStorage();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
      onError: (_, __) {},
    );
    ref.onDispose(() {
      _connectivitySubscription.cancel();
    });
    return const AuthState();
  }

  // ... 保留原有所有方法,方法内 state 引用不变,StateNotifier 的 state 在新基类中同样可用
  // ... _restoreFromStorage / _initConnectivity / _updateConnectionStatus / passWordLogin 等
}
```

> 注:原 `AuthNotifier` 的所有方法体保持不变,仅:
> 1. 将 `extends StateNotifier<AuthState>` 改为 `extends _$AuthNotifier`
> 2. 将构造函数改为 `build()` 方法
> 3. 删除构造函数参数,改用 `ref.watch` 注入
> 4. 添加 `ref.onDispose()` 替代 `dispose()` override
> 5. 添加 `part 'auth_notifier.g.dart';`

- [ ] **Step 3: 运行 build_runner**

Run: `cd app/vividfit_v2 && dart run build_runner build --delete-conflicting-outputs`
Expected: 生成 `auth_notifier.g.dart` 和 `auth_repository_provider.g.dart`

- [ ] **Step 4: 更新所有引用 authNotifierProvider 的文件**

全局搜索 `authNotifierProvider` 并确认 import 路径从 `auth_providers.dart` 改为 `auth_notifier.dart`(因为 @riverpod 注解会将 provider 生成在 Notifier 文件内)。

受影响文件:
- `lib/core/routing/app_router.dart`
- `lib/features/auth/pages/*.dart`(所有 auth 页面)
- `lib/features/home/pages/home_shell_screen.dart`

- [ ] **Step 5: 删除旧 auth_providers.dart**

```bash
rm app/vividfit_v2/lib/features/auth/notifiers/auth_providers.dart
```

- [ ] **Step 6: 运行测试**

Run: `cd app/vividfit_v2 && flutter analyze && flutter test`
Expected: 0 issues + All tests passed

- [ ] **Step 7: Commit**

```bash
cd app/vividfit_v2
git add -A
git commit -m "refactor(auth): migrate AuthNotifier and AuthRepository to @riverpod code-gen"
```

---

### Task 4: 迁移 home 模块(3 个 Provider)

**Files:**
- Modify: `app/vividfit_v2/lib/features/home/notifiers/home_notifier.dart`
- Modify: `app/vividfit_v2/lib/features/home/notifiers/body_data_notifier.dart`
- Modify: `app/vividfit_v2/lib/features/home/notifiers/goal_setting_notifier.dart`
- Delete: `app/vividfit_v2/lib/features/home/notifiers/home_providers.dart`

- [ ] **Step 1: 迁移 home_notifier.dart**

读取完整文件,改写为:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/home_repository_provider.dart';
import '../../../core/services/storage_service_provider.dart';
import '../states/home_state.dart';

part 'home_notifier.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    final repo = ref.watch(homeRepositoryProvider);
    final storage = ref.watch(storageServiceProvider);
    // 原 HomeNotifier(repo, storage) 构造函数体迁移到这里
    // ...保留原有逻辑
    return const HomeState();
  }
  // ...保留原有所有方法
}
```

- [ ] **Step 2: 迁移 body_data_notifier.dart**

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_provider.dart';
import '../states/body_data_state.dart';

part 'body_data_notifier.g.dart';

@riverpod
class BodyDataNotifier extends _$BodyDataNotifier {
  @override
  BodyDataState build() {
    final storage = ref.watch(storageServiceProvider);
    _storage = storage;
    _restore();
    return const BodyDataState();
  }

  late final StorageService _storage;
  // ...保留原有所有方法
}
```

- [ ] **Step 3: 迁移 goal_setting_notifier.dart**

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_provider.dart';
import '../states/goal_setting_state.dart';

part 'goal_setting_notifier.g.dart';

@riverpod
class GoalSettingNotifier extends _$GoalSettingNotifier {
  @override
  GoalSettingState build() {
    final storage = ref.watch(storageServiceProvider);
    _storage = storage;
    _restore();
    return const GoalSettingState();
  }

  late final StorageService _storage;
  // ...保留原有所有方法
}
```

- [ ] **Step 4: 运行 build_runner**

Run: `cd app/vividfit_v2 && dart run build_runner build --delete-conflicting-outputs`

- [ ] **Step 5: 更新引用路径并删除 home_providers.dart**

全局搜索 `home_providers.dart` 的 import 并替换为直接 import 各 notifier 文件。然后:

```bash
rm app/vividfit_v2/lib/features/home/notifiers/home_providers.dart
```

- [ ] **Step 6: 运行测试**

Run: `cd app/vividfit_v2 && flutter analyze && flutter test`

- [ ] **Step 7: Commit**

```bash
cd app/vividfit_v2
git add -A
git commit -m "refactor(home): migrate Home/BodyData/GoalSetting notifiers to @riverpod code-gen"
```

---

### Task 5: 迁移 course 模块(3 个 Provider)

**Files:**
- Create: `app/vividfit_v2/lib/features/course/notifiers/course_repository_provider.dart`
- Modify: `app/vividfit_v2/lib/features/course/notifiers/course_list_notifier.dart`
- Modify: `app/vividfit_v2/lib/features/course/notifiers/course_detail_notifier.dart`
- Delete: `app/vividfit_v2/lib/features/course/notifiers/course_providers.dart`

- [ ] **Step 1: 创建 course_repository_provider.dart**

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/api_service_provider.dart';
import '../../../core/services/storage_service_provider.dart';
import '../repositories/course_repository.dart';

part 'course_repository_provider.g.dart';

@riverpod
CourseRepository courseRepository(Ref ref) {
  return CourseRepository(
    ref.watch(apiServiceProvider),
    ref.watch(storageServiceProvider),
  );
}
```

- [ ] **Step 2: 迁移 course_list_notifier.dart**

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/home_repository_provider.dart';
import '../../../core/services/storage_service_provider.dart';
import '../states/course_list_state.dart';
import 'course_repository_provider.dart';

part 'course_list_notifier.g.dart';

@riverpod
class CourseListNotifier extends _$CourseListNotifier {
  @override
  CourseListState build() {
    final repo = ref.watch(courseRepositoryProvider);
    final storage = ref.watch(storageServiceProvider);
    final homeRepo = ref.watch(homeRepositoryProvider);
    // 原构造函数逻辑迁移到这里
    return const CourseListState();
  }
  // ...保留原有方法
}
```

- [ ] **Step 3: 迁移 course_detail_notifier.dart**

同 Step 2 模式,将 `CourseDetailNotifier` 改为 `@riverpod class`。

- [ ] **Step 4: 运行 build_runner**

Run: `cd app/vividfit_v2 && dart run build_runner build --delete-conflicting-outputs`

- [ ] **Step 5: 更新引用路径并删除 course_providers.dart**

```bash
rm app/vividfit_v2/lib/features/course/notifiers/course_providers.dart
```

- [ ] **Step 6: 运行测试**

Run: `cd app/vividfit_v2 && flutter analyze && flutter test`

- [ ] **Step 7: Commit**

```bash
cd app/vividfit_v2
git add -A
git commit -m "refactor(course): migrate CourseList/CourseDetail notifiers to @riverpod code-gen"
```

---

### Task 6: 迁移 about 模块(1 个 Provider)

**Files:**
- Modify: `app/vividfit_v2/lib/features/about/notifiers/user_settings_notifier.dart`
- Delete: `app/vividfit_v2/lib/features/about/notifiers/about_providers.dart`

- [ ] **Step 1: 迁移 user_settings_notifier.dart**

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../states/user_settings_state.dart';

part 'user_settings_notifier.g.dart';

@riverpod
class UserSettingsNotifier extends _$UserSettingsNotifier {
  @override
  UserSettingsState build() {
    // 原无依赖构造函数,直接返回初始状态
    return const UserSettingsState();
  }
  // ...保留原有方法
}
```

- [ ] **Step 2: 运行 build_runner**

Run: `cd app/vividfit_v2 && dart run build_runner build --delete-conflicting-outputs`

- [ ] **Step 3: 更新引用路径并删除 about_providers.dart**

```bash
rm app/vividfit_v2/lib/features/about/notifiers/about_providers.dart
```

- [ ] **Step 4: 运行测试**

Run: `cd app/vividfit_v2 && flutter analyze && flutter test`

- [ ] **Step 5: Commit**

```bash
cd app/vividfit_v2
git add -A
git commit -m "refactor(about): migrate UserSettingsNotifier to @riverpod code-gen"
```

---

### Task 7: 迁移 big_device 模块(3 个 Provider)

**Files:**
- Create: `app/vividfit_v2/lib/features/big_device/notifiers/bluetooth_connection_provider.dart`
- Modify: `app/vividfit_v2/lib/features/big_device/notifiers/gym_course_home_notifier.dart`
- Modify: `app/vividfit_v2/lib/features/big_device/notifiers/gym_device_connect_notifier.dart`
- Delete: `app/vividfit_v2/lib/features/big_device/notifiers/big_device_providers.dart`

- [ ] **Step 1: 创建 bluetooth_connection_provider.dart**

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/bluetooth_connection_service.dart';

part 'bluetooth_connection_provider.g.dart';

@riverpod
BluetoothConnectionService bluetoothConnection(Ref ref) {
  final service = BluetoothConnectionService();
  ref.onDispose(() => service.dispose());
  return service;
}
```

- [ ] **Step 2: 迁移 gym_course_home_notifier.dart**

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/device_category.dart';
import '../data/entry_card_data.dart';
import '../states/gym_course_home_state.dart';

part 'gym_course_home_notifier.g.dart';

@riverpod
class GymCourseHomeNotifier extends _$GymCourseHomeNotifier {
  @override
  GymCourseHomeState build() {
    return const GymCourseHomeState();
  }

  void bootstrap(int deviceCategoryIndex) {
    final category = DeviceCategoryExtension.fromIndex(deviceCategoryIndex);
    state = state.copyWith(
      selectedDeviceCategory: category,
      entryCards: EntryCardData.defaultCards,
    );
  }

  String resolveCardImage(int dataIndex) {
    return EntryCardData.resolveCardImage(state.selectedDeviceCategory, dataIndex);
  }

  String get deviceTitleKey => EntryCardData.deviceTitleKey(state.selectedDeviceCategory);
  String get deviceEnglishTitle => EntryCardData.deviceEnglishTitle(state.selectedDeviceCategory);
}
```

- [ ] **Step 3: 迁移 gym_device_connect_notifier.dart**

```dart
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/storage_service_provider.dart';
import '../data/device_category.dart';
import '../data/device_scan_constants.dart';
import '../states/gym_device_connect_state.dart';
import 'bluetooth_connection_provider.dart';

part 'gym_device_connect_notifier.g.dart';

@riverpod
class GymDeviceConnectNotifier extends _$GymDeviceConnectNotifier {
  @override
  GymDeviceConnectState build() {
    final service = ref.watch(bluetoothConnectionProvider);
    final storage = ref.watch(storageServiceProvider);

    service.onDevicesUpdated = (names) {
      state = state.copyWith(foundDeviceNames: names);
    };
    service.onScanningChanged = (scanning) {
      state = state.copyWith(isSearching: scanning);
    };
    service.onConnectionChanged = (isConnected, hasConnectedOnce) {
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

    _service = service;
    _storage = storage;
    return const GymDeviceConnectState();
  }

  late final BluetoothConnectionService _service;
  late final StorageService _storage;
  DeviceCategory _deviceCategory = DeviceCategory.bike;

  DeviceCategory get deviceCategory => _deviceCategory;

  void setDeviceCategory(DeviceCategory category) {
    _deviceCategory = category;
  }

  Future<void> startDeviceScan() async {
    final whitelist = DeviceScanConstants.whitelistFor(_deviceCategory);
    try {
      await _service.startScan(whitelist);
    } on BluetoothNotEnabledException {
      Fluttertoast.showToast(msg: 'pleaseOpenBluetooth');
    }
  }

  Future<void> connectSelectedDevice(String deviceName) async {
    await _persistDeviceName(deviceName);
    await _service.connect(deviceName);
  }

  Future<void> _persistDeviceName(String name) async {
    switch (_deviceCategory) {
      case DeviceCategory.bike:
        await _storage.setBikeMachineName(name);
      case DeviceCategory.treadmill:
        await _storage.setTreadmillName(name);
      case DeviceCategory.elliptical:
        await _storage.setEllipticalMachineName(name);
      case DeviceCategory.rower:
        await _storage.setRowerMachineName(name);
      case DeviceCategory.strengthStation:
        await _storage.setStrengthStationName(name);
    }
  }

  String? validateReadyForEntry() {
    if (!state.isEquipmentConnected) return 'pleaseConnectDevice';
    return null;
  }

  Future<void> haltSport() async {
    await _service.disconnect();
    state = state.copyWith(isEquipmentConnected: false);
  }

  void disconnectIfAny() => _service.disconnectIfAny();

  void markConnectedForTest() {
    state = state.copyWith(isEquipmentConnected: true, hasConnectedOnce: true);
  }
}
```

- [ ] **Step 4: 运行 build_runner**

Run: `cd app/vividfit_v2 && dart run build_runner build --delete-conflicting-outputs`

- [ ] **Step 5: 更新引用路径并删除 big_device_providers.dart**

全局搜索 `big_device_providers.dart` 的 import,替换为:
- `gym_device_connect_notifier.dart`(含 `gymDeviceConnectNotifierProvider`)
- `gym_course_home_notifier.dart`(含 `gymCourseHomeNotifierProvider`)
- `bluetooth_connection_provider.dart`(含 `bluetoothConnectionProvider`)

```bash
rm app/vividfit_v2/lib/features/big_device/notifiers/big_device_providers.dart
```

- [ ] **Step 6: 运行测试**

Run: `cd app/vividfit_v2 && flutter analyze && flutter test`

- [ ] **Step 7: Commit**

```bash
cd app/vividfit_v2
git add -A
git commit -m "refactor(big-device): migrate Gym notifiers and BluetoothConnection to @riverpod code-gen"
```

---

### Task 8: 迁移 appRouterProvider(1 个 Provider)

**Files:**
- Modify: `app/vividfit_v2/lib/core/routing/app_router.dart`

- [ ] **Step 1: 迁移 app_router.dart**

将文件改写为:

```dart
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/notifiers/auth_notifier.dart';
import '../../features/auth/pages/account_login_page.dart';
// ... 其他 page import 保持不变

part 'app_router.g.dart';

/// 把 Riverpod 的状态变化转成 GoRouter 能监听的 ChangeNotifier。
class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(Ref ref) {
    ref.listen(authNotifierProvider, (_, __) => notifyListeners());
  }
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _AuthRefreshListenable(ref),
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isLoggedIn = authState.isAuthenticated;
      final location = state.matchedLocation;
      final inLoginFlow = _loginFlowRoutes.contains(location);
      if (isLoggedIn && inLoginFlow) return '/home-shell';
      if (!isLoggedIn && !inLoginFlow) return '/login';
      return null;
    },
    routes: [
      // ... 所有路由保持不变
    ],
  );
}
```

> 注:`ref.listen` 在 `@riverpod` 函数中可直接使用,`_AuthRefreshListenable` 构造函数接收 `Ref`。

- [ ] **Step 2: 运行 build_runner**

Run: `cd app/vividfit_v2 && dart run build_runner build --delete-conflicting-outputs`

- [ ] **Step 3: 更新 main.dart 中的 import**

`main.dart` 中 `appRouterProvider` 的 import 从 `core/routing/app_router.dart` 保持不变(因为 provider 现在生成在同一文件内)。

- [ ] **Step 4: 运行测试**

Run: `cd app/vividfit_v2 && flutter analyze && flutter test`

- [ ] **Step 5: Commit**

```bash
cd app/vividfit_v2
git add -A
git commit -m "refactor(routing): migrate appRouterProvider to @riverpod code-gen"
```

---

### Task 9: 全量验证与清理

**Files:**
- 全项目检查

- [ ] **Step 1: 全局搜索残留的手写 Provider 声明**

搜索 `StateNotifierProvider` 和 `Provider<`(排除 `ProviderScope`、`ProviderContainer`):
Run: `cd app/vividfit_v2 && grep -rn "StateNotifierProvider\|final.*Provider<" lib/ --include="*.dart" | grep -v ".g.dart" | grep -v ".freezed.dart"`
Expected: 0 结果(全部已迁移)

- [ ] **Step 2: 确认无 import 残留旧 providers 文件**

Run: `cd app/vividfit_v2 && grep -rn "providers.dart" lib/ --include="*.dart"`
Expected: 0 结果(所有旧的 `xxx_providers.dart` 已删除)

- [ ] **Step 3: 运行 build_runner 全量重建**

Run: `cd app/vividfit_v2 && dart run build_runner build --delete-conflicting-outputs`
Expected: 所有 `.g.dart` 和 `.freezed.dart` 生成成功

- [ ] **Step 4: flutter analyze**

Run: `cd app/vividfit_v2 && flutter analyze`
Expected: 0 issues

- [ ] **Step 5: flutter test 全量**

Run: `cd app/vividfit_v2 && flutter test`
Expected: All tests passed

- [ ] **Step 6: 手动冒烟测试**

启动 app,验证:
- 登录流程正常
- 首页加载正常
- 课程列表正常
- About 页面正常
- big-device-entry 页面正常

- [ ] **Step 7: 最终 Commit**

```bash
cd app/vividfit_v2
git add -A
git commit -m "refactor: complete riverpod code-gen migration for all 16 providers"
```

---

## Self-Review

**1. Spec coverage:**
- 问题 1(providers 写法是否新架构):已在报告部分明确回答"不是",并给出对比示例
- 问题 2(能否都改):已在可行性矩阵中逐一列出 16 个 Provider 的迁移方案
- riverpod_generator / riverpod_lint 是否用上:已明确回答"未用上",Task 1 添加依赖
- 5 类设备、蓝牙共享 Service、别名命名:迁移不影响这些既定设计,Notifier 内部逻辑不变

**2. Placeholder scan:**
- 无 "TBD" / "TODO" / "implement later"
- 每个任务都给出了完整的代码示例
- Notifier 迁移步骤中标注了"...保留原有方法",这是因为方法体不变,仅基类和注入方式变化,无需重复贴出全部方法

**3. Type consistency:**
- `@riverpod` 注解的 Notifier 基类统一为 `_$XxxNotifier`(生成)
- `Ref` 类型在函数式 provider 中使用(如 `storageService(Ref ref)`)
- `@Riverpod(keepAlive: true)` 用于需要在 main() 中 override 的 storageService 和 appRouter
- Provider 命名规则:`@riverpod` 自动将函数/类名转为 camelCase + `Provider` 后缀(如 `authNotifier` → `authNotifierProvider`)
- 所有 Notifier 的 `state` 访问方式不变(新旧基类都支持 `state` getter/setter)

无类型/签名不一致问题。计划完整可执行。
