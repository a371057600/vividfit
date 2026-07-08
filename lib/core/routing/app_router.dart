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
import '../../features/home/pages/home_shell_screen.dart';

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
      if (isLoggedIn && inLoginFlow) return '/home';
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
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeShellScreen(),
      ),
    ],
  );
});
