import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../notifiers/auth_notifier_provider.dart';

/// 开屏页(用 go_router 的 splash 路由实现,1:1 复刻旧 AnimatedSplashScreen 视觉)。
///
/// 保留原效果:红色底 + 全屏启动图(简中 start_page.jpg / 其它 start_image_en.jpg)
/// + 1000ms 淡入淡出,结束后按登录态跳 /home-shell 或 /login。
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
    _goNext();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted || _navigated) return;
    _navigated = true;
    final isLoggedIn = ref.read(authNotifierProvider).isAuthenticated;
    if (mounted) {
      context.go(isLoggedIn ? '/home-shell' : '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageNum = ref.watch(
      authNotifierProvider.select((s) => s.languageNum),
    );
    final size = MediaQuery.of(context).size;
    return FadeTransition(
      opacity: _controller,
      child: Container(
        color: const Color.fromARGB(255, 229, 104, 104),
        height: size.height,
        width: size.width,
        child: Image.asset(
          languageNum == 0 ? 'images/start_page.jpg' : 'images/start_image_en.jpg',
          height: size.height,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
