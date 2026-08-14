import 'package:flutter/material.dart';

import '../states/goal_banner_display_state.dart';

/// 弹窗入场方向
enum EntryDirection {
  /// 从中间弹出（时间目标弹窗）
  fromCenter,
  /// 从左侧滑入（距离目标弹窗）
  fromLeft,
  /// 从右侧滑入（卡路里目标弹窗）
  fromRight,
}

/// 目标达成弹窗动画器。
///
/// 通过 [AnimationController] 的 `forward`/`reverse` 驱动入场与退场动画，
/// 入场与退场共用同一组 Tween，由控制器方向决定动画走向：
/// - `forward()` = 入场（0→1）
/// - `reverse()` = 退场（1→0）
///
/// 入场曲线：缩放 `easeOutBack`、淡入/位移 `easeOut`；
/// 退场曲线统一 `easeIn`。
///
/// 配合 [GoalBannerDisplayState] 状态机响应显示状态变化。
class GoalBannerAnimator extends StatefulWidget {
  const GoalBannerAnimator({
    super.key,
    required this.displayState,
    required this.direction,
    required this.child,
  });

  /// 当前显示状态
  final GoalBannerDisplayState displayState;

  /// 入场方向
  final EntryDirection direction;

  /// 要动画的子 Widget
  final Widget child;

  @override
  State<GoalBannerAnimator> createState() => _GoalBannerAnimatorState();
}

class _GoalBannerAnimatorState extends State<GoalBannerAnimator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  /// 入场缩放：0.8 → 1.0，reverse 时 1.0 → 0.8
  late final Animation<double> _scale;

  /// 入场淡入：0.0 → 1.0，reverse 时 1.0 → 0.0
  late final Animation<double> _opacity;

  /// 入场位移：方向偏移 → 零，reverse 时零 → 方向偏移
  late final Animation<Offset> _offset;

  /// 根据入场方向计算起始位移偏移（屏幕宽高比例）
  Offset _offsetForDirection(EntryDirection direction) {
    switch (direction) {
      case EntryDirection.fromCenter:
        return const Offset(0, 0.05);
      case EntryDirection.fromLeft:
        return const Offset(-0.1, 0);
      case EntryDirection.fromRight:
        return const Offset(0.1, 0);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 250),
    );

    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      ),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    _offset = Tween<Offset>(
      begin: _offsetForDirection(widget.direction),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    // 监听动画完成状态，输出日志便于真机调试
    _controller.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.completed:
          debugPrint('[Animator] ✅ enter completed');
          break;
        case AnimationStatus.dismissed:
          debugPrint('[Animator] ✅ exit completed');
          break;
        case AnimationStatus.forward:
        case AnimationStatus.reverse:
          break;
      }
    });

    // 初始状态响应
    switch (widget.displayState) {
      case GoalBannerDisplayState.entering:
        debugPrint(
            '[Animator] entering: direction=${widget.direction}, forward()');
        _controller.forward();
        break;
      case GoalBannerDisplayState.visible:
        debugPrint('[Animator] visible: controller set to 1');
        _controller.value = 1;
        break;
      case GoalBannerDisplayState.hidden:
      case GoalBannerDisplayState.exiting:
        break;
    }
  }

  @override
  void didUpdateWidget(covariant GoalBannerAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.displayState != widget.displayState) {
      _respondToDisplayState();
    }
  }

  /// 根据当前 [GoalBannerDisplayState] 驱动控制器
  void _respondToDisplayState() {
    switch (widget.displayState) {
      case GoalBannerDisplayState.entering:
        debugPrint(
            '[Animator] entering: direction=${widget.direction}, forward()');
        _controller.forward();
        break;
      case GoalBannerDisplayState.exiting:
        debugPrint('[Animator] exiting: reverse()');
        _controller.reverse();
        break;
      case GoalBannerDisplayState.hidden:
        debugPrint('[Animator] hidden: controller reset to 0');
        _controller.value = 0;
        break;
      case GoalBannerDisplayState.visible:
        debugPrint('[Animator] visible: controller set to 1');
        _controller.value = 1;
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = _offset.value;
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            child: Transform.translate(
              offset: Offset(
                offset.dx * screenWidth,
                offset.dy * screenHeight,
              ),
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
