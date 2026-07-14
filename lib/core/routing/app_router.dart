import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/notifiers/auth_providers.dart';
import '../../features/auth/pages/account_login_page.dart';
import '../../features/auth/pages/email_login_page.dart';
import '../../features/auth/pages/find_password_page.dart';
import '../../features/auth/pages/get_code_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/phone_login_page.dart';
import '../../features/auth/pages/splash_page.dart';
import '../../features/home/pages/body_data_page.dart';
import '../../features/home/pages/goal_setting_page.dart';
import '../../features/home/pages/home_shell_screen.dart';
import '../../features/home/pages/placeholder_page.dart';
import '../../features/about/pages/about_info_page.dart';
import '../../features/about/pages/about_shell_page.dart';
import '../../features/about/pages/account_security_page.dart';
import '../../features/about/pages/avatar_select_page.dart';
import '../../features/about/pages/medal_display_page.dart';
import '../../features/about/pages/sport_setting_page.dart';
import '../../features/about/pages/user_settings_page.dart';

/// 登录流程所有路由(未登录态允许停留的页面)。
const _loginFlowRoutes = {
  '/splash',
  '/login',
  '/account-login',
  '/email-login',
  '/phone-login',
  '/get-code',
  '/find-password',
};

/// 把 Riverpod 的状态变化转成 GoRouter 能监听的 ChangeNotifier。
class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(Ref ref) {
    ref.listen(authNotifierProvider, (_, __) => notifyListeners());
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _AuthRefreshListenable(ref),
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isLoggedIn = authState.isAuthenticated;
      final location = state.matchedLocation;
      final inLoginFlow = _loginFlowRoutes.contains(location);
      // 已登录且仍在登录流程(含 splash)→ 去首页。
      if (isLoggedIn && inLoginFlow) return '/home-shell';
      // 未登录且不在登录流程 → 去登录入口。
      if (!isLoggedIn && !inLoginFlow) return '/login';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/account-login',
        name: 'account-login',
        builder: (context, state) => const AccountLoginPage(),
      ),
      GoRoute(
        path: '/email-login',
        name: 'email-login',
        builder: (context, state) => const EmailLoginPage(),
      ),
      GoRoute(
        path: '/phone-login',
        name: 'phone-login',
        builder: (context, state) => const PhoneLoginPage(),
      ),
      GoRoute(
        path: '/get-code',
        name: 'get-code',
        builder: (context, state) => const GetCodePage(),
      ),
      GoRoute(
        path: '/find-password',
        name: 'find-password',
        builder: (context, state) => const FindPasswordPage(),
      ),
      GoRoute(
        path: '/home-shell',
        name: 'home-shell',
        builder: (context, state) => const HomeShellScreen(),
      ),
      GoRoute(
        path: '/goal-setting',
        name: 'goal-setting',
        builder: (context, state) => const GoalSettingPage(),
      ),
      GoRoute(
        path: '/body-data',
        name: 'body-data',
        builder: (context, state) => const BodyDataPage(),
      ),
      GoRoute(
        path: '/placeholder',
        name: 'placeholder',
        builder: (context, state) =>
            const PlaceholderPage(targetName: 'Placeholder'),
      ),
      // About 模块路由
      GoRoute(
        path: '/about-shell',
        name: 'about-shell',
        builder: (context, state) => const AboutShellPage(),
      ),
      GoRoute(
        path: '/user-settings',
        name: 'user-settings',
        builder: (context, state) => const UserSettingsPage(),
      ),
      GoRoute(
        path: '/avatar-select',
        name: 'avatar-select',
        builder: (context, state) => const AvatarSelectPage(),
      ),
      GoRoute(
        path: '/about-info',
        name: 'about-info',
        builder: (context, state) => const AboutInfoPage(),
      ),
      GoRoute(
        path: '/sport-setting',
        name: 'sport-setting',
        builder: (context, state) => const SportSettingPage(),
      ),
      GoRoute(
        path: '/account-security',
        name: 'account-security',
        builder: (context, state) => const AccountSecurityPage(),
      ),
      GoRoute(
        path: '/medal-display',
        name: 'medal-display',
        builder: (context, state) => const MedalDisplayPage(),
      ),
    ],
  );
});
