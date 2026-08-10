import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/privacy_service_provider.dart';
import '../../../core/utils/privacy_policy_dialog.dart';
import '../notifiers/auth_notifier.dart';

/// 开屏页 + 隐私协议弹窗门禁(1:1 复刻旧 AnimatedSplashScreen + PrivacyWrapper)。
///
/// 流程:
///  1. 淡入显示启动图,2900ms 等待
///  2. 下一帧检查 PrivacyService.shouldShowPrivacyDialog
///     - true → 弹 PrivacyPolicyDialog(双Tab WebView + 勾选 + 同意/拒绝)
///       - 同意 → 写入 agreed=true,同步 authProvider.agreedToPrivacy
///       - 拒绝 → SystemNavigator.pop 退出 App
///     - false → 跳过弹窗,直接按登录态路由
///  3. 路由分发:新用户→昵称设置,老用户→home-shell,未登录→login
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _controller.forward();
    _goAfterSplash();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _goAfterSplash() async {
    debugPrint('🚀 [Splash] _goAfterSplash start, wait 2900ms');
    await Future.delayed(const Duration(milliseconds: 2900));
    if (!mounted || _navigated) {
      debugPrint(
        '🚀 [Splash] after delay: mounted=$mounted _navigated=$_navigated → abort',
      );
      return;
    }

    final privacy = ref.read(privacyServiceProvider);
    final shouldShow = privacy.shouldShowPrivacyDialog();
    debugPrint('🚀 [Splash] shouldShowPrivacyDialog=$shouldShow');

    if (shouldShow) {
      // 占住 _navigated,避免后续 redirect/rebuild 重复触发
      _navigated = true;
      debugPrint('🚀 [Splash] calling _showPrivacyDialog directly');
      // 直接调用,不依赖 postFrame callback
      final agreed = await _showPrivacyDialog();
      debugPrint('🚀 [Splash] dialog returned agreed=$agreed');
      if (!mounted) {
        debugPrint('🚀 [Splash] not mounted after dialog, abort');
        return;
      }
      if (agreed) {
        _dispatchByAuthState();
      }
      // 不同意时,dialog 内部已 SystemNavigator.pop() 退出 App
    } else {
      _navigated = true;
      _dispatchByAuthState();
    }
  }

  Future<bool> _showPrivacyDialog() async {
    final languageNum = ref.read(authProvider).languageNum;
    final privacy = ref.read(privacyServiceProvider);

    debugPrint('🔒 [Splash] _showPrivacyDialog enter, lang=$languageNum');
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PrivacyPolicyDialog(
        languageNum: languageNum,
        onAgree: () async {
          await privacy.agreePrivacyPolicy();
          ref.read(authProvider.notifier).markPrivacyAgreed();
          HapticFeedback.lightImpact();
        },
        onReject: () async {
          await privacy.rejectPrivacyPolicy();
        },
      ),
    );
    debugPrint('🔒 [Splash] dialog result=$result');
    return result ?? false;
  }

  void _dispatchByAuthState() {
    final authState = ref.read(authProvider);
    final isLoggedIn = authState.isAuthenticated;
    final isNewUser = authState.isNewUser;
    debugPrint(
      '🚀 [Splash] dispatch: isLoggedIn=$isLoggedIn isNewUser=$isNewUser',
    );
    if (!mounted) return;
    if (isLoggedIn && isNewUser) {
      context.go('/nickname-setup');
    } else {
      context.go(isLoggedIn ? '/home-shell' : '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageNum = ref.watch(authProvider.select((s) => s.languageNum));
    final size = MediaQuery.of(context).size;
    return FadeTransition(
      opacity: _controller,
      child: Container(
        color: const Color.fromARGB(255, 229, 104, 104),
        height: size.height,
        width: size.width,
        child: Image.asset(
          languageNum == 0
              ? 'images/start_page.jpg'
              : 'images/start_image_en.jpg',
          height: size.height,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
