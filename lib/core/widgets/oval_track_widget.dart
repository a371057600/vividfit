import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 跑道形组件（左右半圆+上下直线，支持每个小球独立设置大小+轨迹线）。
///
/// 1:1 迁移自旧 `ellipse_track_Widget.dart` 的 `TrackWidget`，仅重命名，绘制逻辑不变。
class OvalTrackWidget extends StatelessWidget {
  /// 左右转弯半圆的半径（决定跑道高度：高度=2*radius）
  final double radius;

  /// 上下直线段的长度（跑道中间水平部分的长度）
  final double lineLength;

  /// 跑道边框宽度
  final double trackWidth;

  /// 小球默认半径（单个小球未设置大小时使用）
  final double defaultBallRadius;

  /// 跑道颜色
  final Color trackColor;

  /// 小球列表（颜色 + 位置百分比 + 独立半径 + 轨迹线控制）
  final List<TrackBallData> balls;

  // 起点标记和文字的配置参数
  final Color startMarkColor;
  final double startMarkWidth;
  final double startMarkLength;
  final TextStyle startTextStyle;

  const OvalTrackWidget({
    super.key,
    required this.radius,
    required this.lineLength,
    this.trackWidth = 8.0,
    this.defaultBallRadius = 6.0,
    this.trackColor = const Color(0xFF333333),
    required this.balls,
    this.startMarkColor = Colors.white,
    this.startMarkWidth = 2.0,
    this.startMarkLength = 30.0,
    this.startTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  });

  @override
  Widget build(BuildContext context) {
    // stroke 线宽居中于路径，两侧各扩展 trackWidth/2，因此画布需留出余量避免裁剪
    final pad = trackWidth;
    final totalWidth = lineLength + 2 * radius + pad;
    final totalHeight = 2 * radius + pad;

    return CustomPaint(
      size: Size(totalWidth, totalHeight),
      painter: _OvalTrackPainter(
        radius: radius,
        lineLength: lineLength,
        trackWidth: trackWidth,
        defaultBallRadius: defaultBallRadius,
        trackColor: trackColor,
        balls: balls,
        startMarkColor: startMarkColor,
        startMarkWidth: startMarkWidth,
        startMarkLength: startMarkLength,
        startTextStyle: startTextStyle,
        offset: pad / 2,
      ),
    );
  }
}

/// 小球信息模型（包含轨迹线控制属性）。
class TrackBallData {
  final Color color;
  final double percentage; // 0-100，0=精准对齐起始线
  final double? radius; // 单个小球的独立半径，null则使用全局默认值
  final bool showTrackLine; // 轨迹线是否显示（默认false=透明/不显示）
  final double trackLineWidthRatio; // 轨迹线宽度 = 小球半径 * 该比例（默认0.6）

  TrackBallData({
    required this.color,
    required this.percentage,
    this.radius,
    this.showTrackLine = false,
    this.trackLineWidthRatio = 0.6,
  });
}

/// 跑道绘制器（包含小球+轨迹线绘制逻辑）。
class _OvalTrackPainter extends CustomPainter {
  final double radius;
  final double lineLength;
  final double trackWidth;
  final double defaultBallRadius;
  final Color trackColor;
  final List<TrackBallData> balls;
  final Color startMarkColor;
  final double startMarkWidth;
  final double startMarkLength;
  final TextStyle startTextStyle;
  final double offset; // 坐标系偏移，避免 stroke 被裁剪

  _OvalTrackPainter({
    required this.radius,
    required this.lineLength,
    required this.trackWidth,
    required this.defaultBallRadius,
    required this.trackColor,
    required this.balls,
    required this.startMarkColor,
    required this.startMarkWidth,
    required this.startMarkLength,
    required this.startTextStyle,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 平移坐标系，让路径居中于增大后的画布，避免 stroke 被裁剪
    canvas.translate(offset, offset);

    final centerY = size.height / 2 - offset;
    final leftSemicircleCenter = Offset(radius, centerY);
    final rightSemicircleCenter = Offset(radius + lineLength, centerY);
    final startPoint = Offset(
      leftSemicircleCenter.dx + lineLength / 2,
      centerY - radius,
    );

    // 1. 绘制跑道
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackWidth
      ..strokeCap = StrokeCap.round;

    // 上直线段
    canvas.drawLine(
      Offset(leftSemicircleCenter.dx, centerY - radius),
      Offset(rightSemicircleCenter.dx, centerY - radius),
      trackPaint,
    );
    // 下直线段
    canvas.drawLine(
      Offset(leftSemicircleCenter.dx, centerY + radius),
      Offset(rightSemicircleCenter.dx, centerY + radius),
      trackPaint,
    );
    // 右半圆
    canvas.drawArc(
      Rect.fromCircle(center: rightSemicircleCenter, radius: radius),
      -math.pi / 2,
      math.pi,
      false,
      trackPaint,
    );
    // 左半圆
    canvas.drawArc(
      Rect.fromCircle(center: leftSemicircleCenter, radius: radius),
      math.pi / 2,
      math.pi,
      false,
      trackPaint,
    );

    // 2. 绘制起点标记
    final startMarkPaint = Paint()
      ..color = startMarkColor
      ..strokeWidth = startMarkWidth
      ..strokeCap = StrokeCap.round;
    // 起点竖线
    canvas.drawLine(
      startPoint.translate(0, -startMarkLength / 2),
      startPoint.translate(0, startMarkLength / 2),
      startMarkPaint,
    );
    // 起点文字
    final textPainter = TextPainter(
      text: TextSpan(text: 'START', style: startTextStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      startPoint.translate(
        -textPainter.width / 2,
        -textPainter.height - startMarkLength / 2 - 8,
      ),
    );

    // 3. 计算跑道总周长
    final semicircleCircumference = math.pi * radius;
    final halfLine = lineLength / 2;
    final totalCircumference = 2 * semicircleCircumference + 2 * lineLength;

    // 4. 遍历绘制小球 + 轨迹线
    for (final ball in balls) {
      final currentBallRadius = ball.radius ?? defaultBallRadius;
      final distance = (ball.percentage / 100) * totalCircumference;

      // ========== 绘制小球轨迹线（核心逻辑） ==========
      if (ball.showTrackLine) {
        final trackLinePaint = Paint()
          ..color = ball.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = currentBallRadius * ball.trackLineWidthRatio
          ..strokeCap = StrokeCap.round;

        final path = Path();
        path.moveTo(startPoint.dx, startPoint.dy); // 轨迹线起点=跑道起点

        // 分段绘制轨迹线（与小球路径完全一致）
        if (distance <= halfLine) {
          // 阶段1：上直线段（起点 → 右半圆顶部）
          path.lineTo(startPoint.dx + distance, startPoint.dy);
        } else if (distance <= halfLine + semicircleCircumference) {
          // 阶段2：上直线全段 + 右半圆部分
          path.lineTo(rightSemicircleCenter.dx, centerY - radius); // 上直线全段
          final arcDistance = distance - halfLine;
          final radiansEnd =
              (-math.pi / 2) +
              (arcDistance / semicircleCircumference) * math.pi;
          // 右半圆弧线段
          path.arcTo(
            Rect.fromCircle(center: rightSemicircleCenter, radius: radius),
            -math.pi / 2,
            radiansEnd - (-math.pi / 2),
            false,
          );
        } else if (distance <=
            halfLine + semicircleCircumference + lineLength) {
          // 阶段3：上直线+右半圆全段 + 下直线部分
          path.lineTo(rightSemicircleCenter.dx, centerY - radius); // 上直线
          path.arcTo(
            Rect.fromCircle(center: rightSemicircleCenter, radius: radius),
            -math.pi / 2,
            math.pi,
            false,
          ); // 右半圆全段
          final lineDistance = distance - (halfLine + semicircleCircumference);
          path.lineTo(
            rightSemicircleCenter.dx - lineDistance,
            centerY + radius,
          ); // 下直线部分
        } else if (distance <=
            halfLine +
                semicircleCircumference +
                lineLength +
                semicircleCircumference) {
          // 阶段4：上直线+右半圆+下直线全段 + 左半圆部分
          path.lineTo(rightSemicircleCenter.dx, centerY - radius); // 上直线
          path.arcTo(
            Rect.fromCircle(center: rightSemicircleCenter, radius: radius),
            -math.pi / 2,
            math.pi,
            false,
          ); // 右半圆
          path.lineTo(leftSemicircleCenter.dx, centerY + radius); // 下直线全段
          final arcDistance =
              distance - (halfLine + semicircleCircumference + lineLength);
          final radiansEnd =
              (math.pi / 2) + (arcDistance / semicircleCircumference) * math.pi;
          // 左半圆弧线段
          path.arcTo(
            Rect.fromCircle(center: leftSemicircleCenter, radius: radius),
            math.pi / 2,
            radiansEnd - (math.pi / 2),
            false,
          );
        } else {
          // 阶段5：完整绕一圈后，上直线剩余部分
          path.lineTo(rightSemicircleCenter.dx, centerY - radius); // 上直线
          path.arcTo(
            Rect.fromCircle(center: rightSemicircleCenter, radius: radius),
            -math.pi / 2,
            math.pi,
            false,
          ); // 右半圆
          path.lineTo(leftSemicircleCenter.dx, centerY + radius); // 下直线
          path.arcTo(
            Rect.fromCircle(center: leftSemicircleCenter, radius: radius),
            math.pi / 2,
            math.pi,
            false,
          ); // 左半圆
          final lineDistance = distance - (totalCircumference - halfLine);
          path.lineTo(
            leftSemicircleCenter.dx + lineDistance,
            centerY - radius,
          ); // 上直线剩余部分
        }

        canvas.drawPath(path, trackLinePaint); // 绘制轨迹线
      }

      // ========== 绘制小球 ==========
      Offset ballOffset;
      if (distance <= halfLine) {
        // 上直线段
        ballOffset = Offset(startPoint.dx + distance, startPoint.dy);
      } else if (distance <= halfLine + semicircleCircumference) {
        // 右半圆
        final arcDistance = distance - halfLine;
        final radians =
            (-math.pi / 2) + (arcDistance / semicircleCircumference) * math.pi;
        ballOffset = Offset(
          rightSemicircleCenter.dx + radius * math.cos(radians),
          rightSemicircleCenter.dy + radius * math.sin(radians),
        );
      } else if (distance <= halfLine + semicircleCircumference + lineLength) {
        // 下直线段
        final lineDistance = distance - (halfLine + semicircleCircumference);
        ballOffset = Offset(
          rightSemicircleCenter.dx - lineDistance,
          centerY + radius,
        );
      } else if (distance <=
          halfLine +
              semicircleCircumference +
              lineLength +
              semicircleCircumference) {
        // 左半圆
        final arcDistance =
            distance - (halfLine + semicircleCircumference + lineLength);
        final radians =
            (math.pi / 2) + (arcDistance / semicircleCircumference) * math.pi;
        ballOffset = Offset(
          leftSemicircleCenter.dx + radius * math.cos(radians),
          leftSemicircleCenter.dy + radius * math.sin(radians),
        );
      } else {
        // 绕圈后回到上直线段
        final lineDistance =
            distance -
            (halfLine +
                semicircleCircumference +
                lineLength +
                semicircleCircumference);
        ballOffset = Offset(
          leftSemicircleCenter.dx + lineDistance,
          startPoint.dy,
        );
      }

      // 绘制小球
      final ballPaint = Paint()..color = ball.color;
      canvas.drawCircle(ballOffset, currentBallRadius, ballPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _OvalTrackPainter oldDelegate) {
    return oldDelegate.balls != balls ||
        oldDelegate.radius != radius ||
        oldDelegate.lineLength != lineLength ||
        oldDelegate.startMarkColor != startMarkColor;
  }
}
