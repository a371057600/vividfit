import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/notifiers/auth_notifier.dart';
import '../../features/auth/pages/account_login_page.dart';
import '../../features/auth/pages/avatar_setup_page.dart';
import '../../features/auth/pages/email_login_page.dart';
import '../../features/auth/pages/find_password_page.dart';
import '../../features/auth/pages/get_code_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/nickname_setup_page.dart';
import '../../features/auth/pages/phone_login_page.dart';
import '../../features/auth/pages/splash_page.dart';
import '../../features/home/pages/body_data_page.dart';
import '../../features/home/pages/goal_setting_page.dart';
import '../../features/home/pages/home_shell_screen.dart';
import '../../features/home/pages/placeholder_page.dart';
import '../../features/about/pages/about_info_page.dart';
import '../../features/about/pages/account_security_page.dart';
import '../../features/about/pages/add_verification_method_page.dart';
import '../../features/about/pages/avatar_select_page.dart';
import '../../features/about/pages/image_crop_page.dart';
import '../../features/about/pages/medal_display_page.dart';
import '../../features/about/pages/set_new_password_page.dart';
import '../../features/about/pages/sport_setting_page.dart';
import '../../features/about/pages/user_settings_page.dart';
import '../../features/course/pages/course_list_page.dart';
import '../../features/course/pages/course_detail_page.dart';
import '../../features/course/pages/course_play_page.dart';
import '../../features/big_device/pages/gym_device_entry_screen.dart';
import '../../features/big_device/pages/gym_course_detail_screen.dart';
import '../../features/big_device/pages/course_page_list.dart';
import '../../features/big_device/pages/gym_device_play_screen.dart';
import '../../features/big_device/pages/gym_game_select_screen.dart';
import '../../features/big_device/pages/quick_start_training_page.dart';
import '../../l10n/app_localizations.dart';
import '../../features/big_device/pages/gym_device_games.dart';
import '../../features/dev/api_test_page.dart';
import '../../core/ftms/ftms_device_type.dart';
import '../../data/models/network/sport_history.dart';
import '../../features/record/models/record_equipment_type.dart';
import '../../features/record/pages/record_main_page.dart';
import '../../features/record/pages/record_list_page.dart';
import '../../features/record/pages/record_detail_page.dart';
import '../../features/rank/pages/ranking_screen.dart';
import '../../core/widgets/policy_webview_page.dart';

part 'app_router.g.dart';

const _loginFlowRoutes = {
  '/login',
  '/account-login',
  '/email-login',
  '/phone-login',
  '/get-code',
  '/find-password',
};

// 测试用免登录路由
const _testRoutes = {'/gym-device-play', '/gym-course-detail'};

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _AuthRefreshListenable(ref),
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoggedIn = authState.isAuthenticated;
      final isNewUser = authState.isNewUser;
      final location = state.matchedLocation;
      // splash 页总是允许显示,由其自行决定跳转
      if (location == '/splash') return null;
      // 测试页面免登录
      if (_testRoutes.contains(location)) return null;
      // 公开页面:未登录也可访问(协议、隐私政策等公开内容)
      const publicRoutes = {'/policy-webview'};
      if (publicRoutes.contains(location)) return null;
      // 注册流程路由集合
      const registerFlowRoutes = {
        '/nickname-setup',
        '/body-data',
        '/avatar-setup',
        '/goal-setting',
      };
      final inLoginFlow = _loginFlowRoutes.contains(location);
      final inRegisterFlow = registerFlowRoutes.contains(location);

      // 已登录 + 新用户:强制走注册流程(但如果在跳首页,允许通过)
      if (isLoggedIn && isNewUser && location != '/home-shell') {
        if (!inRegisterFlow) {
          return '/nickname-setup';
        }
        return null;
      }

      // 已登录 + 老用户:跳主页(但如果在 home-shell,允许通过)
      if (isLoggedIn && !isNewUser) {
        if (inLoginFlow && location != '/home-shell') {
          return '/home-shell';
        }
        return null;
      }

      // 未登录:跳登录(注册流程除外,允许未登录走注册流程)
      if (!isLoggedIn && !inLoginFlow && !inRegisterFlow) {
        return '/login';
      }
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
      // 注册流程路由
      GoRoute(
        path: '/nickname-setup',
        name: 'nickname-setup',
        builder: (context, state) => const NicknameSetupPage(),
      ),
      GoRoute(
        path: '/avatar-setup',
        name: 'avatar-setup',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isRegistration = extra?['isRegistration'] as bool? ?? false;
          return AvatarSetupPage(isRegistration: isRegistration);
        },
      ),
      GoRoute(
        path: '/home-shell',
        name: 'home-shell',
        builder: (context, state) => const HomeShellScreen(),
      ),
      GoRoute(
        path: '/goal-setting',
        name: 'goal-setting',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isRegistration = extra?['isRegistration'] as bool? ?? false;
          return GoalSettingPage(isRegistration: isRegistration);
        },
      ),
      GoRoute(
        path: '/body-data',
        name: 'body-data',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isRegistration = extra?['isRegistration'] as bool? ?? false;
          return BodyDataPage(isRegistration: isRegistration);
        },
      ),
      GoRoute(
        path: '/placeholder',
        name: 'placeholder',
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          return PlaceholderPage(targetName: l10n.placeholderTitle);
        },
      ),
      GoRoute(
        path: '/ranking',
        name: 'ranking',
        builder: (context, state) => const RankingScreen(),
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
        path: '/image-crop',
        name: 'image-crop',
        builder: (context, state) =>
            ImageCropPage(imagePath: state.extra as String),
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
        path: '/set-new-password',
        name: 'set-new-password',
        builder: (context, state) => const SetNewPasswordPage(),
      ),
      GoRoute(
        path: '/add-verification',
        name: 'add-verification',
        builder: (context, state) {
          // accountAddType 0=绑定手机 1=绑定邮箱（对应旧 NewAddVerificationModeScreen 传参）
          final extra = state.extra as Map<String, dynamic>?;
          final accountAddType = extra?['accountAddType'] as int? ?? 0;
          return AddVerificationMethodPage(accountAddType: accountAddType);
        },
      ),
      GoRoute(
        path: '/medal-display',
        name: 'medal-display',
        builder: (context, state) => const MedalDisplayPage(),
      ),
      GoRoute(
        path: '/course-list',
        name: 'course-list',
        builder: (context, state) => const CourseListPage(),
      ),
      GoRoute(
        path: '/course-detail',
        name: 'course-detail',
        builder: (context, state) => const CourseDetailPage(),
      ),
      GoRoute(
        path: '/course-play',
        name: 'course-play',
        builder: (context, state) => const CoursePlayPage(),
      ),
      GoRoute(
        path: '/big-device-entry',
        name: 'big-device-entry',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final deviceCategoryIndex =
              extra?['deviceCategoryIndex'] as int? ?? 0;
          return GymDeviceEntryScreen(deviceCategoryIndex: deviceCategoryIndex);
        },
      ),
      // Big Device - Course
      GoRoute(
        path: '/gym-course-list',
        name: 'gym-course-list',
        builder: (context, state) {
          final deviceType =
              state.extra as FtmsDeviceType? ?? FtmsDeviceType.indoorBike;
          return CoursePageList(deviceType: deviceType);
        },
      ),
      GoRoute(
        path: '/gym-course-detail',
        name: 'gym-course-detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final courseId = extra?['courseId'] as int?;
          final deviceType =
              extra?['deviceType'] as FtmsDeviceType? ??
              FtmsDeviceType.indoorBike;
          return GymCourseDetailScreen(
            courseId: courseId,
            deviceType: deviceType,
          );
        },
      ),
      GoRoute(
        path: '/gym-device-play',
        name: 'gym-device-play',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final courseId = extra?['courseId'] as int?;
          final deviceType =
              extra?['deviceType'] as FtmsDeviceType? ??
              FtmsDeviceType.indoorBike;
          return GymDevicePlayScreen(
            courseId: courseId,
            deviceType: deviceType,
          );
        },
      ),
      GoRoute(
        path: '/gym-game-select',
        name: 'gym-game-select',
        builder: (context, state) {
          final deviceType =
              state.extra as FtmsDeviceType? ?? FtmsDeviceType.indoorBike;
          return GymGameSelectScreen(deviceType: deviceType);
        },
      ),
      GoRoute(
        path: '/gym-quick-start',
        name: 'gym-quick-start',
        builder: (context, state) {
          final deviceType =
              state.extra as FtmsDeviceType? ?? FtmsDeviceType.indoorBike;
          return QuickStartTrainingPage(deviceType: deviceType);
        },
      ),
      // Big Device - Bike Games
      GoRoute(
        path: '/gym-bike-game',
        name: 'gym-bike-game',
        builder: (context, state) {
          final deviceType =
              state.extra as FtmsDeviceType? ?? FtmsDeviceType.indoorBike;
          return GymBikeGameScreen(deviceType: deviceType);
        },
      ),
      GoRoute(
        path: '/gym-bike-game2',
        name: 'gym-bike-game2',
        builder: (context, state) {
          final deviceType =
              state.extra as FtmsDeviceType? ?? FtmsDeviceType.indoorBike;
          return GymBikeGame2Screen(deviceType: deviceType);
        },
      ),
      GoRoute(
        path: '/gym-bike-realscene',
        name: 'gym-bike-realscene',
        builder: (context, state) {
          final deviceType =
              state.extra as FtmsDeviceType? ?? FtmsDeviceType.indoorBike;
          return GymBikeRealsceneScreen(deviceType: deviceType);
        },
      ),
      // Big Device - Treadmill Games
      GoRoute(
        path: '/gym-treadmill-game',
        name: 'gym-treadmill-game',
        builder: (context, state) {
          final deviceType =
              state.extra as FtmsDeviceType? ?? FtmsDeviceType.treadmill;
          return GymTreadmillGameScreen(deviceType: deviceType);
        },
      ),
      GoRoute(
        path: '/gym-treadmill-game2',
        name: 'gym-treadmill-game2',
        builder: (context, state) {
          final deviceType =
              state.extra as FtmsDeviceType? ?? FtmsDeviceType.treadmill;
          return GymTreadmillGame2Screen(deviceType: deviceType);
        },
      ),
      GoRoute(
        path: '/gym-treadmill-realscene',
        name: 'gym-treadmill-realscene',
        builder: (context, state) {
          final deviceType =
              state.extra as FtmsDeviceType? ?? FtmsDeviceType.treadmill;
          return GymTreadmillRealsceneScreen(deviceType: deviceType);
        },
      ),
      // Big Device - Elliptical Games
      GoRoute(
        path: '/gym-elliptical-game',
        name: 'gym-elliptical-game',
        builder: (context, state) {
          final deviceType =
              state.extra as FtmsDeviceType? ?? FtmsDeviceType.crossTrainer;
          return GymEllipticalGameScreen(deviceType: deviceType);
        },
      ),
      GoRoute(
        path: '/gym-elliptical-game2',
        name: 'gym-elliptical-game2',
        builder: (context, state) {
          final deviceType =
              state.extra as FtmsDeviceType? ?? FtmsDeviceType.crossTrainer;
          return GymEllipticalGame2Screen(deviceType: deviceType);
        },
      ),
      GoRoute(
        path: '/gym-elliptical-realscene',
        name: 'gym-elliptical-realscene',
        builder: (context, state) {
          final deviceType =
              state.extra as FtmsDeviceType? ?? FtmsDeviceType.crossTrainer;
          return GymEllipticalRealsceneScreen(deviceType: deviceType);
        },
      ),
      // Big Device - Rower Games
      GoRoute(
        path: '/gym-rower-game',
        name: 'gym-rower-game',
        builder: (context, state) {
          final deviceType =
              state.extra as FtmsDeviceType? ?? FtmsDeviceType.rower;
          return GymRowerGameScreen(deviceType: deviceType);
        },
      ),
      GoRoute(
        path: '/gym-rower-game2',
        name: 'gym-rower-game2',
        builder: (context, state) {
          final deviceType =
              state.extra as FtmsDeviceType? ?? FtmsDeviceType.rower;
          return GymRowerGame2Screen(deviceType: deviceType);
        },
      ),
      GoRoute(
        path: '/gym-rower-realscene',
        name: 'gym-rower-realscene',
        builder: (context, state) {
          final deviceType =
              state.extra as FtmsDeviceType? ?? FtmsDeviceType.rower;
          return GymRowerRealsceneScreen(deviceType: deviceType);
        },
      ),
      GoRoute(
        path: '/api-test',
        name: 'api-test',
        builder: (context, state) => const ApiTestPage(),
      ),
      // 隐私政策 / 用户协议 在线 WebView 页
      // 使用: context.push('/policy-webview', extra: {'url': xxx, 'title': xxx})
      GoRoute(
        path: '/policy-webview',
        name: 'policy-webview',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final url = extra?['url'] as String? ?? '';
          final title = extra?['title'] as String? ?? '';
          return PolicyWebViewPage(url: url, title: title);
        },
      ),
      // 记录模块路由
      GoRoute(
        path: '/record-main',
        name: 'record-main',
        builder: (context, state) => const RecordMainPage(),
      ),
      GoRoute(
        path: '/record-list',
        name: 'record-list',
        builder: (context, state) => const RecordListPage(),
      ),
      GoRoute(
        path: '/record-detail',
        name: 'record-detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final equipmentType =
              extra?['equipmentType'] as RecordEquipmentType? ??
              RecordEquipmentType.all;
          final record = extra?['record'] as SportHistory?;
          return RecordDetailPage(equipmentType: equipmentType, record: record);
        },
      ),
    ],
  );
}

class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(Ref ref) {
    ref.listen(authProvider, (_, _) => notifyListeners());
  }
}
