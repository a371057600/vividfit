# Tasks

- [ ] **Task 1: 创建用户设置状态类**
  - [ ] 创建 `lib/features/about/states/user_settings_state.dart`（带 freezed 注解）
  - [ ] 运行 `build_runner` 生成 `user_settings_state.freezed.dart`
  - [ ] 验证生成文件无编译错误

- [ ] **Task 2: 创建用户设置 Notifier**
  - [ ] 创建 `lib/features/about/notifiers/user_settings_notifier.dart`
  - [ ] 实现 loadData / updateNickName / updateGender / updateBirthday / updateHeight / updateWeight / updateSelectedImageIndex / toggleUpdating 方法
  - [ ] 所有方法仅操作本地状态，不发起网络请求

- [ ] **Task 3: 创建 About 模块 Providers**
  - [ ] 创建 `lib/features/about/notifiers/about_providers.dart`
  - [ ] 注册 `userSettingsNotifierProvider` StateNotifierProvider

- [ ] **Task 4: 添加国际化键**
  - [ ] 在 `lib/l10n/app_en.arb` 添加 About 模块所有英文键值对
  - [ ] 在 `lib/l10n/app_zh.arb` 添加 About 模块所有中文键值对
  - [ ] 运行 `flutter gen-l10n` 重新生成本地化代码
  - [ ] 验证生成的 `app_localizations.dart` 包含新增键

- [ ] **Task 5: 创建 About 模块占位页面**
  - [ ] 创建 `lib/features/about/pages/placeholder_about_page.dart`
  - [ ] 实现可复用的空壳页面组件

- [ ] **Task 6: 创建 AboutInfoPage（关于信息页）**
  - [ ] 创建 `lib/features/about/pages/about_info_page.dart`
  - [ ] 1:1 复刻原 `about_info_screen.dart` UI
  - [ ] 包含：应用 Logo、版本号、服务热线、法律信息、备案号

- [ ] **Task 7: 创建 AvatarSelectPage（头像选择页）**
  - [ ] 创建 `lib/features/about/pages/avatar_select_page.dart`
  - [ ] 1:1 复刻原 `new_image_select_screen.dart` UI
  - [ ] 包含：当前头像展示、20 个头像网格、拍照/图片选择按钮（占位）

- [ ] **Task 8: 创建 UserSettingsPage（基本设置页）**
  - [ ] 创建 `lib/features/about/pages/user_settings_page.dart`
  - [ ] 1:1 复刻原 `about_user_head_screen.dart` UI
  - [ ] 包含：头像项、昵称项（弹窗编辑）、性别项（底部弹窗）、生日项（日期选择器）、身高项（滚轮选择器）、体重项（滚轮选择器）

- [ ] **Task 9: 创建 AboutShellPage（About 主页）**
  - [ ] 创建 `lib/features/about/pages/about_shell_page.dart`
  - [ ] 1:1 复刻原 `new_abouts_screen.dart` UI
  - [ ] 包含：用户头像卡片、勋章入口、设置分组（运动设置、账号安全）、其他分组（软件更新、隐私政策、关于、重新登录）、虚拟教练选择

- [ ] **Task 10: 创建内部占位页面**
  - [ ] 创建 `lib/features/about/pages/sport_setting_page.dart`（运动设置占位页）
  - [ ] 创建 `lib/features/about/pages/account_security_page.dart`（账号安全占位页）
  - [ ] 创建 `lib/features/about/pages/medal_display_page.dart`（勋章展示占位页）

- [ ] **Task 11: 添加路由配置**
  - [ ] 修改 `lib/core/routing/app_router.dart`，导入所有 About 页面
  - [ ] 在 `routes` 列表中添加 7 条 About 模块路由（about-shell、user-settings、avatar-select、about-info、sport-setting、account-security、medal-display）
  - [ ] 验证路由名称与页面导航引用一致

- [ ] **Task 12: 更新 HomeShellScreen 底部导航**
  - [ ] 修改 `lib/features/home/pages/home_shell_screen.dart`
  - [ ] 将底部导航第 4 个标签（"我"）的点击事件改为 `context.go('/about-shell')`
  - [ ] 验证其他标签导航不受影响

- [ ] **Task 13: 运行测试和验证**
  - [ ] 运行 `flutter analyze`，确保无错误无警告
  - [ ] 运行 `flutter build apk --debug`，确保构建成功
  - [ ] 手动测试完整导航流程：首页 → About → 各子页面 → 返回

# Task Dependencies
- Task 1（状态类）→ Task 2（Notifier）→ Task 3（Providers）
- Task 3（Providers）→ Task 6/7/8/9（各页面，因为页面依赖状态）
- Task 4（国际化）→ Task 6/7/8/9/10（各页面依赖 i18n）
- Task 6/7/8/9/10（页面创建完成）→ Task 11（路由配置）
- Task 11（路由配置）→ Task 12（导航更新）
- Task 12（导航更新）→ Task 13（最终验证）
