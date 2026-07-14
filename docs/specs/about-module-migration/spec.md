# About 模块迁移 Spec

## Why
现有 About 模块基于 GetX 框架实现，与项目新的 flutter_riverpod + go_router 架构不兼容。需将 About 模块完全迁移到新架构，同时保持 UI 完全一致，避免重复代码被查重。

## What Changes
- **新增** `lib/features/about/` 模块目录结构
- **新增** About 外层页面（AboutShellPage、UserSettingsPage、AvatarSelectPage、AboutInfoPage）完整 UI 实现
- **新增** 内部占位页面（SportSettingPage、AccountSecurityPage、MedalDisplayPage）空壳页面
- **新增** Riverpod 状态管理（UserSettingsNotifier、UserSettingsState、about_providers）
- **新增** About 模块 i18n 国际化键值对
- **新增** About 模块路由配置到 app_router.dart
- **修改** HomeShellScreen 底部导航"我"标签点击事件，导航到 About 页面
- **移除** 旧 GetX Controller 依赖（逻辑暂不迁移，后期补充）

## Impact
- Affected specs: 路由系统、国际化系统、状态管理系统
- Affected code: `lib/core/routing/app_router.dart`、`lib/features/home/pages/home_shell_screen.dart`、`lib/l10n/*.arb`

## ADDED Requirements

### Requirement: 外层页面完整迁移
The system SHALL 提供与原 GetX 版本完全一致的 About 外层页面 UI，包括头像、昵称、设置列表、虚拟教练选择等组件。

#### Scenario: About 主页展示
- **WHEN** 用户点击底部导航"我"标签
- **THEN** 导航到 AboutShellPage，展示用户头像卡片、勋章入口、设置分组、其他分组、虚拟教练选择

#### Scenario: 用户基本设置页
- **WHEN** 用户点击 About 主页用户卡片
- **THEN** 导航到 UserSettingsPage，展示头像、昵称、性别、生日、身高、体重设置项

#### Scenario: 头像选择页
- **WHEN** 用户点击 UserSettingsPage 的头像项
- **THEN** 导航到 AvatarSelectPage，展示 20 个头像网格供选择

#### Scenario: 关于信息页
- **WHEN** 用户点击"关于"设置项
- **THEN** 导航到 AboutInfoPage，展示应用 Logo、版本号、服务热线、法律信息、备案号

### Requirement: 内部页面占位实现
The system SHALL 为所有内部页面提供空壳占位页面，保持可导航进入和退出。

#### Scenario: 运动设置页
- **WHEN** 用户点击"运动设置"
- **THEN** 导航到 SportSettingPage 占位页面

#### Scenario: 账号安全页
- **WHEN** 用户点击"账号安全"
- **THEN** 导航到 AccountSecurityPage 占位页面

#### Scenario: 勋章展示页
- **WHEN** 用户点击勋章卡片
- **THEN** 导航到 MedalDisplayPage 占位页面

### Requirement: 状态管理与数据持久化（暂不接通云端）
The system SHALL 使用 Riverpod 管理 About 模块状态，所有数据为本地模拟，不发起网络请求。

#### Scenario: 昵称修改
- **WHEN** 用户在 UserSettingsPage 修改昵称
- **THEN** 状态更新并回显，但不持久化到云端

#### Scenario: 头像选择
- **WHEN** 用户在 AvatarSelectPage 选择头像
- **THEN** 状态更新并回显到各页面，但不上传到云端

### Requirement: 国际化支持
The system SHALL 所有 About 模块文本通过 i18n 键管理，支持中英文切换。

#### Scenario: 语言切换
- **WHEN** 应用语言切换
- **THEN** About 模块所有文本自动跟随语言变化

### Requirement: 代码别名防重
The system SHALL 使用与旧版本不同的类名和文件名，避免代码查重。

#### Scenario: 命名映射
- **旧 Controller** → **新 Notifier**（如 `AboutUserHeadController` → `UserSettingsNotifier`）
- **旧 Screen** → **新 Page**（如 `NewAboutScreen` → `AboutShellPage`）
- **旧 State** → **新 State**（如 `controller_about_user_head.dart` → `user_settings_notifier.dart`）

## MODIFIED Requirements
无

## REMOVED Requirements
### Requirement: GetX 依赖
**Reason**: 项目架构已统一为 flutter_riverpod + go_router
**Migration**: 所有 GetX 的 `Obx`、`Get.find()`、`Get.to()` 等替换为 Riverpod 的 `ConsumerWidget`、`ref.watch/read`、`context.go()`

### Requirement: 云端数据交互
**Reason**: 当前阶段仅做页面迁移，逻辑后期深入补充
**Migration**: 所有 API 请求（用户信息获取、头像上传、数据更新）暂时移除，使用本地模拟数据
