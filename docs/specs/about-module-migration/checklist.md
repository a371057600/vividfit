# Checklist

## 架构合规
- [ ] 所有 About 模块代码不使用任何 GetX 依赖（无 `get` 包导入、无 `Obx`/`Get.find()`/`Get.to()` 等）
- [ ] 所有状态管理使用 flutter_riverpod（`ConsumerWidget`/`ConsumerStatefulWidget` + `ref.watch`/`ref.read`）
- [ ] 所有路由导航使用 go_router（`context.go()`/`context.push()`）
- [ ] 所有文本使用 i18n 键（`AppLocalizations.of(context)!`），无硬编码字符串

## 文件结构
- [ ] `lib/features/about/` 目录存在且包含以下子目录：`notifiers/`、`pages/`、`states/`
- [ ] 所有文件使用别名命名（Controller→Notifier，Screen→Page）

## 页面完整性
- [ ] AboutShellPage（主页）UI 与原 `new_abouts_screen.dart` 完全一致
- [ ] UserSettingsPage（基本设置）UI 与原 `about_user_head_screen.dart` 完全一致
- [ ] AvatarSelectPage（头像选择）UI 与原 `new_image_select_screen.dart` 完全一致
- [ ] AboutInfoPage（关于信息）UI 与原 `about_info_screen.dart` 完全一致
- [ ] SportSettingPage、AccountSecurityPage、MedalDisplayPage 为可进入可退出的占位页面

## 功能验证
- [ ] 从 HomeShellScreen 点击"我"标签可进入 AboutShellPage
- [ ] AboutShellPage 中点击用户卡片可进入 UserSettingsPage
- [ ] UserSettingsPage 中点击头像项可进入 AvatarSelectPage
- [ ] UserSettingsPage 中点击昵称可弹出编辑对话框
- [ ] UserSettingsPage 中点击性别可弹出底部选择弹窗
- [ ] UserSettingsPage 中点击生日可弹出日期选择器
- [ ] UserSettingsPage 中点击身高/体重可弹出滚轮选择器
- [ ] AboutShellPage 中点击勋章卡片可进入 MedalDisplayPage
- [ ] AboutShellPage 中点击"运动设置"可进入 SportSettingPage
- [ ] AboutShellPage 中点击"账号安全"可进入 AccountSecurityPage
- [ ] AboutShellPage 中点击"关于"可进入 AboutInfoPage
- [ ] AboutShellPage 中点击"重新登录"弹出确认对话框，确认后导航到登录页
- [ ] 所有子页面可正常返回上级页面

## 数据与逻辑
- [ ] 无网络请求代码（无 Dio、无 API 调用）
- [ ] 所有数据为本地模拟状态
- [ ] 状态变更在各页面间正确同步（如头像选择后回显到 About 主页）

## 构建与测试
- [ ] `flutter analyze` 无错误无警告
- [ ] `flutter build apk --debug` 构建成功
