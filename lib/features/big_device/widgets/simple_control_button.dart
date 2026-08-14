import 'package:flutter/material.dart';

/// 简易 +/- 控制按钮组件。
///
/// 从 `gym_device_play_screen.dart` 的 `_buildControlButton` 提取按钮样式，
/// 简化为单一按钮单元（标签 + 点击 + 长按），便于在课程播放页等场景复用。
///
/// 视觉风格与原版控制按钮保持一致：
///   - 深色背景 `Color(0xFF242424)`
///   - 圆角容器
///   - 白色文字标签
///
/// 新增 [GestureDetector] 长按手势支持（[onLongPressStart] / [onLongPressEnd]），
/// 尺寸通过 [widthFactor] / [heightFactor] 按比例缩放。
///
/// 当 [isEnabled] 为 false 时，按钮置灰且不响应任何手势。
class SimpleControlButton extends StatelessWidget {
  const SimpleControlButton({
    super.key,
    required this.label,
    this.onTap,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.widthFactor,
    this.heightFactor,
    this.isEnabled = true,
  });

  /// 按钮标签文字（如 "+"、"-"、或档位数字）。
  final String label;

  /// 单击回调。
  final VoidCallback? onTap;

  /// 长按开始回调。
  final VoidCallback? onLongPressStart;

  /// 长按结束回调。
  final VoidCallback? onLongPressEnd;

  /// 宽度缩放系数（默认 1.0）。
  final double? widthFactor;

  /// 高度缩放系数（默认 1.0）。
  final double? heightFactor;

  /// 是否启用。false 时按钮置灰且不响应手势。
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final wf = widthFactor ?? 1.0;
    final hf = heightFactor ?? 1.0;
    // 文字取较小系数，保证不溢出
    final scaleFactor = wf < hf ? wf : hf;

    // 尺寸基于屏幕比例（与原版 gym_device_play_screen 一致，不使用 ScreenUtil）
    final btnW = sw * 0.14 * wf;
    final btnH = sh * 0.08 * hf;
    final radius = sh * 0.022 * hf;
    final fontSize = sh * 0.034 * scaleFactor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isEnabled ? onTap : null,
      onLongPressStart: isEnabled && onLongPressStart != null
          ? (_) => onLongPressStart!()
          : null,
      onLongPressEnd: isEnabled && onLongPressEnd != null
          ? (_) => onLongPressEnd!()
          : null,
      child: Container(
        width: btnW,
        height: btnH,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isEnabled
              ? const Color(0xFF242424)
              : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isEnabled ? Colors.white : Colors.white38,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
