import 'package:flutter/material.dart';

/// 药丸形加减控制按钮组件。
///
/// 纵向布局：上方标题文字 + 下方药丸形胶囊按钮（+ / 数值 / -）。
/// 用于大件设备课程播放页的速度/阻力/坡度调节。
///
/// 视觉特征：
///   - 按钮：横向药丸形（两端完全圆角），深炭灰色背景
///   - 内部：三等分结构，细竖线分隔 +/数值/-
///   - 按压反馈：点击时轻微透明度变化
class PillControlButton extends StatefulWidget {
  const PillControlButton({
    super.key,
    required this.title,
    required this.value,
    this.onAdd,
    this.onDown,
    this.onLongPressAdd,
    this.onLongPressDown,
    this.onLongPressEnd,
    this.width,
    this.height,
    this.buttonColor,
    this.foregroundColor,
    this.titleColor,
    this.dividerColor,
  });

  /// 标题文字（如"速度"、"阻力"、"坡度"）。
  final String title;

  /// 当前数值显示文本。
  final String value;

  /// 单击"+"回调。
  final VoidCallback? onAdd;

  /// 单击"-"回调。
  final VoidCallback? onDown;

  /// 长按"+"开始回调。
  final VoidCallback? onLongPressAdd;

  /// 长按"-"开始回调。
  final VoidCallback? onLongPressDown;

  /// 长按结束回调（加减共用）。
  final VoidCallback? onLongPressEnd;

  /// 按钮宽度（默认基于屏幕宽度比例）。
  final double? width;

  /// 按钮高度（默认基于屏幕高度比例）。
  final double? height;

  /// 按钮背景色（默认深炭灰色 #2A2A2E）。
  final Color? buttonColor;

  /// 图标和数值文字颜色（默认白色）。
  final Color? foregroundColor;

  /// 标题文字颜色（默认白色70%透明度）。
  final Color? titleColor;

  /// 分隔线颜色（默认白色20%透明度）。
  final Color? dividerColor;

  @override
  State<PillControlButton> createState() => _PillControlButtonState();
}

class _PillControlButtonState extends State<PillControlButton> {
  bool _addPressed = false;
  bool _downPressed = false;

  void _handleTapDown(VoidCallback? callback, bool isAdd) {
    if (callback == null) return;
    setState(() {
      if (isAdd) {
        _addPressed = true;
      } else {
        _downPressed = true;
      }
    });
  }

  void _handleTapUp(bool isAdd) {
    if (mounted) {
      setState(() {
        if (isAdd) {
          _addPressed = false;
        } else {
          _downPressed = false;
        }
      });
    }
  }

  void _handleTapCancel(bool isAdd) {
    if (mounted) {
      setState(() {
        if (isAdd) {
          _addPressed = false;
        } else {
          _downPressed = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    final btnW = widget.width ?? sw * 0.11;
    final btnH = widget.height ?? sh * 0.06;
    final btnColor = widget.buttonColor ?? const Color(0xFF2A2A2E);
    final fgColor = widget.foregroundColor ?? Colors.white;
    final titleColor = widget.titleColor ?? Colors.white70;
    final divColor = widget.dividerColor ?? Colors.white.withValues(alpha: 0.2);

    final titleFs = sh * 0.018;
    final valueFs = sh * 0.028;
    final iconSize = sh * 0.028;
    final dividerH = btnH * 0.5;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 标题
        Text(
          widget.title,
          style: TextStyle(
            color: titleColor,
            fontSize: titleFs,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: sh * 0.008),
        // 药丸形按钮主体
        Container(
          width: btnW,
          height: btnH,
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(btnH / 2),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // "+" 区域
              _buildTapArea(
                isAdd: true,
                pressed: _addPressed,
                child: Icon(
                  Icons.add,
                  color: fgColor,
                  size: iconSize,
                  weight: 700,
                ),
                onTap: widget.onAdd,
                onLongPressStart: widget.onLongPressAdd,
                onLongPressEnd: widget.onLongPressEnd,
              ),
              // 左侧分隔线
              Container(
                width: 1,
                height: dividerH,
                color: divColor,
              ),
              // 中间数值
              Expanded(
                child: Center(
                  child: Text(
                    widget.value,
                    style: TextStyle(
                      color: fgColor,
                      fontSize: valueFs,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              // 右侧分隔线
              Container(
                width: 1,
                height: dividerH,
                color: divColor,
              ),
              // "-" 区域
              _buildTapArea(
                isAdd: false,
                pressed: _downPressed,
                child: Icon(
                  Icons.remove,
                  color: fgColor,
                  size: iconSize,
                  weight: 700,
                ),
                onTap: widget.onDown,
                onLongPressStart: widget.onLongPressDown,
                onLongPressEnd: widget.onLongPressEnd,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建点击区域（+ 或 -），带按压反馈。
  Widget _buildTapArea({
    required bool isAdd,
    required bool pressed,
    required Widget child,
    VoidCallback? onTap,
    VoidCallback? onLongPressStart,
    VoidCallback? onLongPressEnd,
  }) {
    final enabled = onTap != null || onLongPressStart != null;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => _handleTapDown(onTap, isAdd) : null,
        onTapUp: enabled ? (_) => _handleTapUp(isAdd) : null,
        onTapCancel: enabled ? () => _handleTapCancel(isAdd) : null,
        onTap: enabled
            ? () {
                onTap?.call();
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) _handleTapUp(isAdd);
                });
              }
            : null,
        onLongPressStart: onLongPressStart != null
            ? (_) {
                _handleTapDown(onLongPressStart, isAdd);
                onLongPressStart();
              }
            : null,
        onLongPressEnd: onLongPressEnd != null
            ? (_) {
                _handleTapUp(isAdd);
                onLongPressEnd();
              }
            : null,
        child: Opacity(
          opacity: !enabled
              ? 0.3
              : pressed
                  ? 0.5
                  : 1.0,
          child: Center(child: child),
        ),
      ),
    );
  }
}
