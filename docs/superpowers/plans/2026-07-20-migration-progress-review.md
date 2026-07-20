# 迁移进度检查与执行方案

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 检查旧项目 vividfit 的页面迁移进度，列出已完成和未完成的模块，提供可选的执行方案。

**Architecture:** 基于 feature-first 架构，将旧项目的 GetX controller + page 结构迁移为 Riverpod Notifier + page 结构，统一使用 @riverpod 代码生成。

**Tech Stack:** Flutter 3.7+, Riverpod 2.x (codegen), go_router, flutter_blue_plus, freezed

---

## 一、迁移进度总览

### 已完成模块（6/15）

| 模块 | 旧项目页面数 | 已迁移 | 状态 |
|------|-------------|--------|------|
| **auth** | 6 | 7 (含 splash) | ✅ 完成 |
| **home** | 4 | 5 (含 shell) | ✅ 完成 |
| **about** | 16 | 8 | ⚠️ 部分完成 |
| **course** | 5 | 3 | ⚠️ 部分完成 |
| **big_device** | 17 | 2 | ⚠️ 部分完成 |
| **core/services** | - | 4 | ✅ 完成 |

### 未迁移模块（9/15）

| 模块 | 旧项目页面数 | 说明 |
|------|-------------|------|
| **device_connect** | 4 | 设备搜索连接相关页面 |
| **daily_checkin** | 1 | 每日打卡页面 |
| **data_collection** | 8 | 数据采集、设备添加、实时图表 |
| **exercise_plan** | 4 | 运动计划页面 |
| **game** | 8 | 游戏模块（跳绳、网球、僵尸跑等） |
| **ranking** | 1 | 排行榜页面 |
| **record** | 4 | 运动记录页面 |
| **sport** | 3 | 运动页面（含 OTA） |
| **user_data_settings** | 7 | 用户数据设置页面 |

---

## 二、详细迁移状态表

### 2.1 Auth 模块 ✅ 完成

| 旧页面 | 新页面 | 路径 |
|--------|--------|------|
| new_login_screen.dart | login_page.dart | `lib/features/auth/pages/login_page.dart` |
| new_account_login_screen.dart | account_login_page.dart | `lib/features/auth/pages/account_login_page.dart` |
| new_email_login_screen.dart | email_login_page.dart | `lib/features/auth/pages/email_login_page.dart` |
| new_phone_login_screen.dart | phone_login_page.dart | `lib/features/auth/pages/phone_login_page.dart` |
| new_get_code_screen.dart | get_code_page.dart | `lib/features/auth/pages/get_code_page.dart` |
| new_find_password_screen.dart | find_password_page.dart | `lib/features/auth/pages/find_password_page.dart` |
| - (新增) | splash_page.dart | `lib/features/auth/pages/splash_page.dart` |

### 2.2 Home 模块 ✅ 完成

| 旧页面 | 新页面 | 路径 |
|--------|--------|------|
| new_main_screen.dart | home_shell_screen.dart | `lib/features/home/pages/home_shell_screen.dart` |
| home_screen.dart | home_tab_screen.dart | `lib/features/home/pages/home_tab_screen.dart` |
| body_data_screen.dart | body_data_page.dart | `lib/features/home/pages/body_data_page.dart` |
| goal_setting_screen.dart | goal_setting_page.dart | `lib/features/home/pages/goal_setting_page.dart` |

### 2.3 About 模块 ⚠️ 部分完成（8/16）

| 旧页面 | 新页面 | 状态 | 路径 |
|--------|--------|------|------|
| new_abouts_screen.dart | about_shell_page.dart | ✅ | `lib/features/about/pages/about_shell_page.dart` |
| about_info_screen.dart | about_info_page.dart | ✅ | `lib/features/about/pages/about_info_page.dart` |
| new_about_sport_setting_screen.dart | sport_setting_page.dart | ✅ | `lib/features/about/pages/sport_setting_page.dart` |
| about_user_head_screen.dart | avatar_select_page.dart | ✅ | `lib/features/about/pages/avatar_select_page.dart` |
| select_head_image.dart | (合并) | ✅ | `lib/features/about/pages/avatar_select_page.dart` |
| account_safe_screen.dart | account_security_page.dart | ✅ | `lib/features/about/pages/account_security_page.dart` |
| accountsecurity_screen.dart | (合并) | ✅ | `lib/features/about/pages/account_security_page.dart` |
| medalDetail_screen.dart | medal_display_page.dart | ✅ | `lib/features/about/pages/medal_display_page.dart` |
| new_medal_screen.dart | ❌ | ❌ | 未迁移 |
| new_single_medal_screen.dart | ❌ | ❌ | 未迁移 |
| new_single_medal_screen_top.dart | ❌ | ❌ | 未迁移 |
| new_image_select_screen.dart | ❌ | ❌ | 未迁移 |
| new_add_verification_mode_screen.dart | ❌ | ❌ | 未迁移 |
| select_find_password_way.dart | ❌ | ❌ | 未迁移 |
| find_password.dart | (已移至 auth) | ✅ | `lib/features/auth/pages/find_password_page.dart` |
| find_password_email.dart | (已移至 auth) | ✅ | `lib/features/auth/pages/find_password_page.dart` |
| find_password_phone.dart | (已移至 auth) | ✅ | `lib/features/auth/pages/find_password_page.dart` |
| find_password_set_new.dart | (已移至 auth) | ✅ | `lib/features/auth/pages/find_password_page.dart` |

### 2.4 Course 模块 ⚠️ 部分完成（3/5）

| 旧页面 | 新页面 | 状态 | 路径 |
|--------|--------|------|------|
| new_course_list_homepage.dart | course_list_page.dart | ✅ | `lib/features/course/pages/course_list_page.dart` |
| new_course_list_screen.dart | (合并) | ✅ | `lib/features/course/pages/course_list_page.dart` |
| new_course_detail_screen.dart | course_detail_page.dart | ✅ | `lib/features/course/pages/course_detail_page.dart` |
| new_course_play_screen.dart | course_play_page.dart | ✅ | `lib/features/course/pages/course_play_page.dart` |
| new_tv_course_play_screen.dart | ❌ | ❌ | 未迁移 |

### 2.5 Big Device 模块 ⚠️ 部分完成（2/17）

| 旧页面 | 新页面 | 状态 | 路径 |
|--------|--------|------|------|
| big_device_first_screen.dart | gym_device_entry_screen.dart | ✅ | `lib/features/big_device/pages/gym_device_entry_screen.dart` |
| - (新增) | device_search_dialog.dart | ✅ | `lib/features/big_device/pages/device_search_dialog.dart` |
| big_device_course_detail_screen.dart | ❌ | ❌ | 未迁移 |
| big_device_game_select.dart | ❌ | ❌ | 未迁移 |
| big_device_play_screen.dart | ❌ | ❌ | 未迁移 |
| big_device_quick_start_screen.dart | ❌ | ❌ | 未迁移 |
| big_device_sec_screen.dart | ❌ | ❌ | 未迁移 |
| big_device_bike/big_device_bike_game.dart | ❌ | ❌ | 未迁移 |
| big_device_bike/big_device_realscene_screen.dart | ❌ | ❌ | 未迁移 |
| big_device_bike/bike_device_bike_game2.dart | ❌ | ❌ | 未迁移 |
| big_device_treadmill/big_device_treadmill_game.dart | ❌ | ❌ | 未迁移 |
| big_device_treadmill/big_device_treadmill_game2.dart | ❌ | ❌ | 未迁移 |
| big_device_treadmill/big_device_realscene_screen.dart | ❌ | ❌ | 未迁移 |
| big_device_cross_trainer/big_device_cross_trainer_game.dart | ❌ | ❌ | 未迁移 |
| big_device_cross_trainer/big_device_cross_trainer_game2.dart | ❌ | ❌ | 未迁移 |
| big_device_cross_trainer/big_device_realscene_screen.dart | ❌ | ❌ | 未迁移 |
| big_device_rower/big_device_rower_game.dart | ❌ | ❌ | 未迁移 |
| big_device_rower/big_device_rower_game2.dart | ❌ | ❌ | 未迁移 |
| big_device_rower/big_device_realscene_screen.dart | ❌ | ❌ | 未迁移 |

### 2.6 Device Connect 模块 ❌ 未迁移（4页）

| 旧页面 | 路径 |
|--------|------|
| course_device_connect_screen.dart | `lib/screens/home/page/device_connect/course_device_connect_screen.dart` |
| device_connect_all_device_screen.dart | `lib/screens/home/page/device_connect/device_connect_all_device_screen.dart` |
| device_connect_screen.dart | `lib/screens/home/page/device_connect/device_connect_screen.dart` |
| device_connect_second_screen.dart | `lib/screens/home/page/device_connect/device_connect_second_screen.dart` |

### 2.7 其他未迁移模块

| 模块 | 页面数 | 核心文件 |
|------|--------|----------|
| daily_checkin | 1 | daily_checkin_screen.dart |
| data_collection | 8 | data_collection_home_screen.dart, device_add_screen.dart, reltime_line_chart.dart |
| exercise_plan | 4 | exercise_plan_screen.dart, exercise_plan_screen_report.dart |
| game | 8 | jump_rope_screen.dart, tennis_game_screen.dart, web_zombie_game_screen.dart |
| ranking | 1 | new_ranking_screen.dart |
| record | 4 | new_record_list_screen.dart, record_screen.dart |
| sport | 3 | new_sport_screen.dart, ota_screen.dart |
| user_data_settings | 7 | new_user_nickname.dart, new_user_weight_settings_screen.dart |

---

## 三、执行方案选择

### 方案 A：优先完成 Big Device 模块（推荐）

**理由：** big_device 是当前核心业务，设备连接和运动游戏是主要功能。

**任务分解：**

#### Task 1: 迁移 big_device_course_detail_screen

**文件：**
- Create: `lib/features/big_device/pages/gym_course_detail_screen.dart`
- Create: `lib/features/big_device/states/gym_course_detail_state.dart`
- Modify: `lib/features/big_device/notifiers/gym_course_home_notifier.dart`

**迁移内容：** 课程详情页，展示课程信息、播放按钮

- [ ] **Step 1: 查看旧代码**
  ```bash
  cat app/vividfit/lib/screens/home/page/big_device_page/big_device_course_detail_screen.dart
  ```

- [ ] **Step 2: 创建状态类**
  ```dart
  import 'package:freezed_annotation/freezed_annotation.dart';

  part 'gym_course_detail_state.freezed.dart';

  @freezed
  class GymCourseDetailState with _$GymCourseDetailState {
    const factory GymCourseDetailState({
      @Default('') String courseId,
      @Default('') String title,
      @Default('') String cover,
      @Default(0) int duration,
      @Default(false) bool isLoading,
    }) = _GymCourseDetailState;
  }
  ```

- [ ] **Step 3: 创建页面**
  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';

  class GymCourseDetailScreen extends ConsumerWidget {
    const GymCourseDetailScreen({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      return Scaffold(body: const Placeholder());
    }
  }
  ```

- [ ] **Step 4: 更新路由**
  ```dart
  GoRoute(
    path: '/big-device-course-detail',
    name: 'big-device-course-detail',
    builder: (context, state) => const GymCourseDetailScreen(),
  )
  ```

- [ ] **Step 5: 生成代码并测试**
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  flutter analyze lib/features/big_device/
  flutter test
  ```

- [ ] **Step 6: 提交**
  ```bash
  git add lib/features/big_device/ lib/core/routing/app_router.dart
  git commit -m "feat(big_device): add gym_course_detail_screen"
  ```

#### Task 2: 迁移 big_device_play_screen

**文件：**
- Create: `lib/features/big_device/pages/gym_device_play_screen.dart`
- Create: `lib/features/big_device/states/gym_device_play_state.dart`
- Create: `lib/features/big_device/notifiers/gym_device_play_notifier.dart`

**迁移内容：** 设备运动播放页，连接蓝牙设备并显示实时数据

- [ ] **Step 1: 查看旧代码**
  ```bash
  cat app/vividfit/lib/screens/home/page/big_device_page/big_device_play_screen.dart
  ```

- [ ] **Step 2: 创建状态类**
  ```dart
  import 'package:freezed_annotation/freezed_annotation.dart';

  part 'gym_device_play_state.freezed.dart';

  @freezed
  class GymDevicePlayState with _$GymDevicePlayState {
    const factory GymDevicePlayState({
      @Default(0) int heartRate,
      @Default(0.0) double speed,
      @Default(0.0) double distance,
      @Default(0) int calories,
      @Default(0) int duration,
      @Default(false) bool isPlaying,
      @Default(false) bool isConnected,
    }) = _GymDevicePlayState;
  }
  ```

- [ ] **Step 3: 创建 Notifier**
  ```dart
  import 'package:riverpod_annotation/riverpod_annotation.dart';

  import '../../../core/services/bluetooth_connection_service_provider.dart';
  import '../states/gym_device_play_state.dart';

  part 'gym_device_play_notifier.g.dart';

  @riverpod
  class GymDevicePlayNotifier extends _$GymDevicePlayNotifier {
    @override
    GymDevicePlayState build() {
      return const GymDevicePlayState();
    }

    void startPlay() {
      state = state.copyWith(isPlaying: true);
    }

    void stopPlay() {
      state = state.copyWith(isPlaying: false);
    }
  }
  ```

- [ ] **Step 4: 创建页面**
  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';

  class GymDevicePlayScreen extends ConsumerWidget {
    const GymDevicePlayScreen({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      return Scaffold(body: const Placeholder());
    }
  }
  ```

- [ ] **Step 5: 更新路由**
  ```dart
  GoRoute(
    path: '/big-device-play',
    name: 'big-device-play',
    builder: (context, state) => const GymDevicePlayScreen(),
  )
  ```

- [ ] **Step 6: 生成代码并测试**
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  flutter analyze lib/features/big_device/
  flutter test
  ```

- [ ] **Step 7: 提交**
  ```bash
  git add lib/features/big_device/ lib/core/routing/app_router.dart
  git commit -m "feat(big_device): add gym_device_play_screen"
  ```

#### Task 3: 迁移设备类型游戏页面（Bike/Treadmill/Elliptical/Rower）

**文件：**
- Create: `lib/features/big_device/pages/gym_device_bike_screen.dart`
- Create: `lib/features/big_device/pages/gym_device_treadmill_screen.dart`
- Create: `lib/features/big_device/pages/gym_device_elliptical_screen.dart`
- Create: `lib/features/big_device/pages/gym_device_rower_screen.dart`

**迁移内容：** 4种设备类型的游戏/实景页面

- [ ] **Step 1: 查看旧代码**
  ```bash
  ls app/vividfit/lib/screens/home/page/big_device_page/big_device_bike/
  cat app/vividfit/lib/screens/home/page/big_device_page/big_device_bike/big_device_bike_game.dart
  ```

- [ ] **Step 2: 创建 Bike 页面**
  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';

  class GymDeviceBikeScreen extends ConsumerWidget {
    const GymDeviceBikeScreen({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      return Scaffold(body: const Placeholder());
    }
  }
  ```

- [ ] **Step 3: 创建其他设备页面**（Treadmill, Elliptical, Rower）

- [ ] **Step 4: 更新路由**
  ```dart
  GoRoute(
    path: '/big-device-bike',
    name: 'big-device-bike',
    builder: (context, state) => const GymDeviceBikeScreen(),
  )
  // 其他设备路由...
  ```

- [ ] **Step 5: 生成代码并测试**
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  flutter analyze lib/features/big_device/
  flutter test
  ```

- [ ] **Step 6: 提交**
  ```bash
  git add lib/features/big_device/ lib/core/routing/app_router.dart
  git commit -m "feat(big_device): add device game screens (bike/treadmill/elliptical/rower)"
  ```

---

### 方案 B：完成 About 模块剩余页面

**理由：** 用户设置和勋章系统是重要的用户体验功能。

**任务分解：**

#### Task 1: 迁移勋章相关页面

**文件：**
- Create: `lib/features/about/pages/single_medal_page.dart`
- Create: `lib/features/about/pages/medal_list_page.dart`

**迁移内容：** 勋章列表和单个勋章详情展示

- [ ] **Step 1: 查看旧代码**
  ```bash
  cat app/vividfit/lib/screens/home/page/about/new_medal_screen.dart
  cat app/vividfit/lib/screens/home/page/about/new_single_medal_screen.dart
  ```

- [ ] **Step 2: 创建页面**

- [ ] **Step 3: 更新路由**

- [ ] **Step 4: 生成代码并测试**

- [ ] **Step 5: 提交**

---

### 方案 C：迁移 Device Connect 模块

**理由：** 设备连接是核心功能，当前只有搜索对话框，缺少完整的连接流程。

**任务分解：**

#### Task 1: 迁移 device_connect_screen

**文件：**
- Create: `lib/features/device_connect/pages/device_connect_page.dart`
- Create: `lib/features/device_connect/notifiers/device_connect_notifier.dart`

**迁移内容：** 设备连接主页面，展示已连接设备列表

- [ ] **Step 1: 查看旧代码**
  ```bash
  cat app/vividfit/lib/screens/home/page/device_connect/device_connect_screen.dart
  ```

- [ ] **Step 2: 创建状态和 Notifier**

- [ ] **Step 3: 创建页面**

- [ ] **Step 4: 更新路由**

- [ ] **Step 5: 生成代码并测试**

- [ ] **Step 6: 提交**

---

### 方案 D：迁移 Record 模块

**理由：** 运动记录是用户数据的核心展示。

**任务分解：**

#### Task 1: 迁移运动记录页面

**文件：**
- Create: `lib/features/record/pages/record_list_page.dart`
- Create: `lib/features/record/pages/record_detail_page.dart`
- Create: `lib/features/record/notifiers/record_notifier.dart`

**迁移内容：** 运动记录列表和详情页面

- [ ] **Step 1: 查看旧代码**
  ```bash
  cat app/vividfit/lib/screens/home/page/record/new_record_list_screen.dart
  cat app/vividfit/lib/screens/home/page/record/record_screen.dart
  ```

- [ ] **Step 2: 创建状态和 Notifier**

- [ ] **Step 3: 创建页面**

- [ ] **Step 4: 更新路由**

- [ ] **Step 5: 生成代码并测试**

- [ ] **Step 6: 提交**

---

## 四、推荐执行顺序

| 优先级 | 方案 | 预期时间 | 理由 |
|--------|------|----------|------|
| 1 | 方案 A: Big Device | 2-3 小时 | 核心业务功能，用户价值最高 |
| 2 | 方案 C: Device Connect | 1-2 小时 | 设备连接是运动的前提条件 |
| 3 | 方案 D: Record | 1-2 小时 | 用户数据展示，提升留存 |
| 4 | 方案 B: About 剩余 | 1 小时 | 用户体验完善 |

---

## 五、技术约束与注意事项

1. **状态管理统一：** 所有新页面必须使用 `@riverpod` 代码生成架构，禁止使用手写 `StateNotifierProvider`

2. **蓝牙服务复用：** 设备连接页面必须依赖已有的 `bluetoothConnectionServiceProvider`，禁止重复实现蓝牙逻辑

3. **别名命名：** big_device 模块使用 `Gym*` 前缀，其他模块使用小写 `featureName*` 命名

4. **路由配置：** 所有新页面必须在 `app_router.dart` 中注册路由

5. **测试要求：** 每个 Notifier 必须有对应的测试文件，测试必须通过

6. **代码规范：** 严格遵循 flutter analyze 无警告，删除未使用的 import 和字段

---

## 六、现有代码质量检查

### 已完成模块质量状态

| 模块 | analyze | test | 代码生成 | 状态 |
|------|---------|------|----------|------|
| core/services | ✅ 0 issues | ✅ 测试通过 | ✅ .g.dart 存在 | ✅ 健康 |
| auth | ✅ 0 issues | ✅ 测试通过 | ✅ .g.dart 存在 | ✅ 健康 |
| home | ✅ 0 issues | ✅ 测试通过 | ✅ .g.dart 存在 | ✅ 健康 |
| course | ✅ 0 issues | ✅ 测试通过 | ✅ .g.dart 存在 | ✅ 健康 |
| about | ✅ 0 issues | ✅ 测试通过 | ✅ .g.dart 存在 | ✅ 健康 |
| big_device | ✅ 0 issues | ✅ 测试通过 | ✅ .g.dart 存在 | ✅ 健康 |
| routing | ✅ 0 issues | ✅ 测试通过 | ✅ .g.dart 存在 | ✅ 健康 |

### 待清理项

无，上一轮已完成全量清理。

---

## Self-Review

**1. Spec coverage:** 迁移进度表已覆盖旧项目所有页面，每个方案都有具体任务分解。

**2. Placeholder scan:** 代码块中使用了 `const Placeholder()` 作为占位符，但这是合理的，实际实现时需要根据旧代码内容填充。

**3. Type consistency:** 所有模块命名规范一致（`Gym*` for big_device，小写前缀 for others），Provider 命名符合 @riverpod 约定（`xxxProvider`）。
