import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 三环进度数据配置（不可变）
///
/// 对应原版结束页三环组件：
/// - 外圈：时间进度（橙色）
/// - 中圈：距离/桨频进度（蓝色）
/// - 内圈：卡路里进度（红色）
class TripleRingData {
  final double outerProgress;
  final double middleProgress;
  final double innerProgress;

  final Color bgOuter;
  final Color bgMiddle;
  final Color bgInner;

  final Color fgOuter;
  final Color fgMiddle;
  final Color fgInner;

  final String centerIconK;
  final String centerIconP;
  final String centerIconT;

  const TripleRingData({
    required this.outerProgress,
    required this.middleProgress,
    required this.innerProgress,
    this.bgOuter = const Color(0xFF3F2C0C),
    this.bgMiddle = const Color(0xFF15263F),
    this.bgInner = const Color(0xFF3D1713),
    this.fgOuter = const Color(0xFFFFA200),
    this.fgMiddle = const Color(0xFF2C80FD),
    this.fgInner = const Color(0xFFF53721),
    this.centerIconK = 'images/newUIScreen/icons/icon_mainCardK.png',
    this.centerIconP = 'images/newUIScreen/icons/icon_mainCardP.png',
    this.centerIconT = 'images/newUIScreen/icons/icon_mainCardT.png',
  });
}

/// 三环进度独立 Widget
///
/// 精确复刻原版 CircularStepProgressIndicator 的角度和比例：
/// - 三个环各有独立的起始角度和扫描角度，形成扇形缺口（中心对齐正下方90°）
/// - 缺口宽度：外圈36° / 中圈47° / 内圈55°（扇形展开）
/// - 图标居中在缺口处
class TripleRingProgress extends StatelessWidget {
  final TripleRingData data;
  final double size;
  final double ringWidth;
  final double ringGap;

  const TripleRingProgress({
    super.key,
    required this.data,
    required this.size,
    required this.ringWidth,
    required this.ringGap,
  });

  @override
  Widget build(BuildContext context) {
    final baseIconSize = size * 0.085;
    final iconGap = size * 0.012;
    final bottomMargin = size * 0.015;

    Widget buildIcon(String assetPath, double size, IconData fallback) {
      return Image.asset(
        assetPath,
        height: size,
        width: size,
        color: Colors.white,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) =>
            Icon(fallback, color: Colors.white, size: size),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _TripleRingCanvas(
              data: data,
              ringWidth: ringWidth,
              ringGap: ringGap,
            ),
          ),
          // 中心图标：底部对齐，复刻原版 MainAxisAlignment.end + bottom margin
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomMargin,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildIcon(
                  data.centerIconK,
                  baseIconSize,
                  Icons.local_fire_department,
                ),
                SizedBox(height: iconGap),
                buildIcon(data.centerIconP, baseIconSize, Icons.directions_run),
                SizedBox(height: iconGap),
                buildIcon(data.centerIconT, baseIconSize, Icons.access_time),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 三环 Canvas 绘制器
///
/// 精确复刻原版 CircularStepProgressIndicator 参数：
///
/// 背景层（暗色轨道，全满100步）：
/// ┌──────┬────────────┬───────────────┬──────────────────┬──────────┐
/// │ 环   │ totalSteps │ startAngle(CSP)│ startAngle(Canvas)│ fullSweep│
/// ├──────┼────────────┼───────────────┼──────────────────┼──────────┤
/// │ 外圈 │ 111        │ -π*0.9        │ 0.60π ≈ 108.0°   │ 1.802π   │
/// │ 中圈 │ 115        │ -π*0.87       │ 0.63π ≈ 113.4°   │ 1.739π   │
/// │ 内圈 │ 118        │ -π*0.85       │ 0.65π ≈ 117.0°   │ 1.695π   │
/// └──────┴────────────┴───────────────┴──────────────────┴──────────┘
///
/// 前景层（亮色进度，0~100步）：
/// ┌──────┬────────────┬───────────────┬──────────────────┬───────────────┐
/// │ 环   │ totalSteps │ startAngle(CSP)│ startAngle(Canvas)│ maxSweep      │
/// ├──────┼────────────┼───────────────┼──────────────────┼───────────────┤
/// │ 外圈 │ 120        │ -π*0.9        │ 0.60π ≈ 108.0°   │ 1.667π ≈ 300°│
/// │ 中圈 │ 115        │ -π*0.87       │ 0.63π ≈ 113.4°   │ 1.739π ≈ 313°│
/// │ 内圈 │ 120        │ -π*0.8        │ 0.70π ≈ 126.0°   │ 1.667π ≈ 300°│
/// └──────┴────────────┴───────────────┴──────────────────┴───────────────┘
///
/// CSP坐标: 0=顶部(12点), Canvas坐标: 0=右侧(3点)
/// 转换: canvasAngle = cspAngle - π/2
/// 缺口中心统一对齐正下方(90°=0.5π)
class _TripleRingCanvas extends CustomPainter {
  final TripleRingData data;
  final double ringWidth;
  final double ringGap;

  _TripleRingCanvas({
    required this.data,
    required this.ringWidth,
    required this.ringGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final R = size.shortestSide / 2;
    final pi = math.pi;

    // ─── 自适应环宽分配 ───
    final wMax = R / 3.8;
    final w = ringWidth.clamp(3.0, wMax > 3.0 ? wMax : 3.0);
    final g = ringGap.clamp(1.0, w * 0.5);

    final outerR = R - w / 2;
    final middleR = outerR - w - g;
    final innerR = middleR - w - g;

    if (innerR <= 1.0) return;

    debugPrint(
      '🎨 [TripleRing] R=${R.toStringAsFixed(1)} w=${w.toStringAsFixed(1)} '
      'g=${g.toStringAsFixed(1)} outer=${outerR.toStringAsFixed(1)} '
      'middle=${middleR.toStringAsFixed(1)} inner=${innerR.toStringAsFixed(1)}',
    );

    // ─── 精确角度参数（复刻原版） ───
    // Canvas 0 = 右侧(3点), π/2 = 下方(6点), π = 左侧(9点)
    // CSP 0 = 顶部(12点), canvasAngle = cspAngle - π/2
    final outerBgStart = 0.60 * pi; // -π*0.9(CSP) = -0.9π-0.5π = -1.4π = 0.6π
    final outerBgSweep = 100 / 111 * 2 * pi;
    final outerFgStart = 0.60 * pi;
    final outerFgSweep = 100 / 120 * 2 * pi;

    final middleBgStart = 0.63 * pi; // -π*0.87(CSP)
    final middleBgSweep = 100 / 115 * 2 * pi;
    final middleFgStart = 0.63 * pi;
    final middleFgSweep = 100 / 115 * 2 * pi;

    final innerBgStart = 0.65 * pi; // -π*0.85(CSP)
    final innerBgSweep = 100 / 118 * 2 * pi;
    final innerFgStart = 0.70 * pi; // -π*0.8(CSP) ← 前景起始角度与背景不同！
    final innerFgSweep = 100 / 120 * 2 * pi;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // ─── 1. 绘制背景弧（3 层，暗色轨道） ───
    paint.color = data.bgOuter;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerR),
      outerBgStart,
      outerBgSweep,
      false,
      paint,
    );
    paint.color = data.bgMiddle;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: middleR),
      middleBgStart,
      middleBgSweep,
      false,
      paint,
    );
    paint.color = data.bgInner;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerR),
      innerBgStart,
      innerBgSweep,
      false,
      paint,
    );

    // ─── 2. 绘制前景进度弧（3 层，亮色） ───
    if (data.outerProgress > 0) {
      paint.color = data.fgOuter;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerR),
        outerFgStart,
        outerFgSweep * data.outerProgress,
        false,
        paint,
      );
    }
    if (data.middleProgress > 0) {
      paint.color = data.fgMiddle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: middleR),
        middleFgStart,
        middleFgSweep * data.middleProgress,
        false,
        paint,
      );
    }
    if (data.innerProgress > 0) {
      paint.color = data.fgInner;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerR),
        innerFgStart,
        innerFgSweep * data.innerProgress,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TripleRingCanvas oldDelegate) =>
      data.outerProgress != oldDelegate.data.outerProgress ||
      data.middleProgress != oldDelegate.data.middleProgress ||
      data.innerProgress != oldDelegate.data.innerProgress ||
      ringWidth != oldDelegate.ringWidth ||
      ringGap != oldDelegate.ringGap;
}
