import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../states/gym_course_play_state.dart';

/// 大设备播放页底部课程进度条（17 段固定 + 精确箭头定位）
///
/// 视觉：
/// - 17 格等宽分段 + 均匀间距
/// - 底部背景槽（track）
/// - 高度按 heightFactor 映射形成山峰轮廓
/// - 红色自绘倒三角进度指示器
///
/// 精度保障：
/// - 进度条 + 箭头共用 LayoutBuilder 约束宽度 → 单一坐标系
/// - 箭头位置按「段累积边界 + 段内插值」计算，段切换瞬间精准对齐边界
///
/// 注意：所有 flutter_screenutil 的 .h / .w / .r 必须在外层 build 阶段求值，
///      LayoutBuilder.builder 回调处于布局阶段，不允许触发 MediaQuery.of(context)
///      （否则抛出 !_debugDoingThisLayout 断言错误）
class CourseProgressRail extends StatelessWidget {
  const CourseProgressRail({
    super.key,
    required this.segments,
    required this.progress,
    List<Color>? segmentColors,
  }) : segmentColors = segmentColors ?? _defaultColors;

  final List<GymProgressSegment> segments;

  /// 0.0 ~ 1.0 总播放进度
  final double progress;

  /// posture → color 映射表
  final List<Color> segmentColors;

  static const int _kSegmentCount = 17;
  static const List<Color> _defaultColors = [
    Color(0xFF80FFCC),
    Color(0xFF7B93FF),
    Color(0xFFFFDD66),
    Color(0xFFFF9999),
    Color(0xFF66CCFF),
    Color(0xFFCCAA88),
    Color(0xFFAAAAAA),
  ];

  /// 占位段颜色（N<17 时补齐用）
  static const Color _kPlaceholderColor = Color(0xFF2A2A2A);

  /// 背景槽颜色
  static const Color _kTrackColor = Color(0xFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    if (segments.isEmpty) return const SizedBox.shrink();

    final clampedProgress = progress.clamp(0.0, 1.0);

    // 规整到 17 段
    final normalized = _normalizeTo17(segments);
    assert(
      normalized.length == _kSegmentCount,
      'normalized segments must be exactly $_kSegmentCount',
    );

    debugPrint(
      '🎯 [ProgressRail] inputN=${segments.length} '
      '→ normalized=$_kSegmentCount '
      'progress=${clampedProgress.toStringAsFixed(4)}',
    );

    // ── 所有 .h / .w / .r 在外层 build 求值（布局阶段安全） ──
    final gapBase = 3.0.w;
    final segMinWidth = 4.0.w;
    final trackH = 15.0.h;
    final segMaxH = 130.0.h;
    final segMinH = 20.0.h;
    final segRangeH = segMaxH - segMinH;
    final topPadH = 10.0.h;
    final containerH = segMaxH + trackH + topPadH;
    final trackRadius = 7.5.r;
    final segTopRadius = 6.0.r;
    final arrowHalfW = 8.0.w;
    final arrowW = arrowHalfW * 2;
    final arrowH = 12.0.h;
    final arrowBottomOffset = trackH - 1.0.h;

    // 高度映射闭包（纯 double 运算，布局内安全）
    double mapHeight(int factor) {
      final f = factor.clamp(0, 10) / 10.0;
      return segMinH + f * segRangeH;
    }

    // 预计算 17 段高度（纯 double 运算）
    final segHeights = List<double>.generate(_kSegmentCount, (i) {
      final seg = normalized[i];
      return seg.isPlaceholder ? 0.0 : mapHeight(seg.heightFactor);
    });

    // 预计算 17 段颜色
    final segColors = List<Color>.generate(_kSegmentCount, (i) {
      final seg = normalized[i];
      if (seg.isPlaceholder) return _kPlaceholderColor;
      return segmentColors[seg.posture.clamp(0, segmentColors.length - 1)];
    });

    return LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          var gap = gapBase;
          final totalGapWidth = gap * (_kSegmentCount + 1); // 18 个间隙
          var segmentWidth = (totalWidth - totalGapWidth) / _kSegmentCount;

          // 极小屏兜底：段宽下限，不够就自动缩间隙
          if (segmentWidth < segMinWidth) {
            segmentWidth = segMinWidth;
            gap = (totalWidth - segmentWidth * _kSegmentCount) /
                (_kSegmentCount + 1);
          }

          debugPrint(
            '🎯 [ProgressRail] totalW=${totalWidth.toStringAsFixed(1)} '
            'segW=${segmentWidth.toStringAsFixed(2)} '
            'gap=${gap.toStringAsFixed(2)}',
          );

          // 计算箭头 x 像素坐标（基于规整后 17 段的累积百分比）
          final arrowX = _computeArrowPixelX(
            normalized,
            clampedProgress,
            totalWidth,
            gap,
            segmentWidth,
          );

          debugPrint('🎯 [ProgressRail] arrowX=${arrowX.toStringAsFixed(2)}');

          return SizedBox(
            height: containerH,
            width: totalWidth,
            child: Stack(
              children: [
                // ── 底部背景槽 ──
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: trackH,
                    decoration: BoxDecoration(
                      color: _kTrackColor,
                      borderRadius: BorderRadius.circular(trackRadius),
                    ),
                  ),
                ),

                // ── 17 段彩色分段（底部对齐槽顶） ──
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: trackH,
                  child: SizedBox(
                    height: segMaxH,
                    child: Row(
                      children: List.generate(_kSegmentCount, (i) {
                        final color = segColors[i];
                        final h = segHeights[i];
                        final ml = i == 0 ? gap : gap / 2;
                        final mr = i == _kSegmentCount - 1 ? gap : gap / 2;
                        return Container(
                          width: segmentWidth,
                          margin: EdgeInsets.only(left: ml, right: mr),
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: h,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(segTopRadius),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                // ── 红色倒三角进度指示器 ──
                Positioned(
                  left: (arrowX - arrowHalfW).clamp(0.0, totalWidth - arrowW),
                  bottom: arrowBottomOffset,
                  child: CustomPaint(
                    size: Size(arrowW, arrowH),
                    painter: _TriangleIndicatorPainter(),
                  ),
                ),
              ],
            ),
          );
        },
    );
  }

  // ══════════════════════════════════════════════════════════════
  // 内部：17 段规整
  // ══════════════════════════════════════════════════════════════

  /// 17 段规整后的中间结构（含百分比累积边界信息）
  static List<_NormalizedSegment> _normalizeTo17(
    List<GymProgressSegment> input,
  ) {
    final int n = input.length;

    if (n == _kSegmentCount) {
      return input.asMap().entries.map((e) {
        final i = e.key;
        final s = e.value;
        return _NormalizedSegment(
          percentage: s.percentage,
          heightFactor: s.heightFactor,
          posture: s.posture,
          isPlaceholder: false,
          originalIndex: i,
        );
      }).toList();
    }

    if (n < _kSegmentCount) {
      final result = <_NormalizedSegment>[];
      // 简化策略：真实段按顺序放在前 N 格，后 17-N 格为空占位
      for (int i = 0; i < n; i++) {
        result.add(_NormalizedSegment(
          percentage: input[i].percentage,
          heightFactor: input[i].heightFactor,
          posture: input[i].posture,
          isPlaceholder: false,
          originalIndex: i,
        ));
      }
      for (int i = n; i < _kSegmentCount; i++) {
        result.add(_NormalizedSegment(
          percentage: 0,
          heightFactor: 0,
          posture: 0,
          isPlaceholder: true,
          originalIndex: -1,
        ));
      }
      return result;
    }

    // N > 17：两两合并直到 17 段
    // 策略：重复遍历，找出合并后边界最平滑的相邻对（优先 posture 相同、其次 percentage 最小）
    final working = input.asMap().entries.map((e) {
      return _NormalizedSegment(
        percentage: e.value.percentage,
        heightFactor: e.value.heightFactor,
        posture: e.value.posture,
        isPlaceholder: false,
        originalIndex: e.key,
      );
    }).toList();

    while (working.length > _kSegmentCount) {
      int bestIdx = 0;
      int bestScore = 1 << 30;
      for (int i = 0; i < working.length - 1; i++) {
        final a = working[i];
        final b = working[i + 1];
        // 评分：posture 相同得 0 分 + 百分比越小分越低（越低越优先合并）
        final postureSame = a.posture == b.posture ? 0 : 10000;
        final sizePenalty =
            ((a.percentage + b.percentage) * 100000).round().abs();
        final score = postureSame + sizePenalty;
        if (score < bestScore) {
          bestScore = score;
          bestIdx = i;
        }
      }
      final a = working[bestIdx];
      final b = working[bestIdx + 1];
      final merged = _NormalizedSegment(
        percentage: a.percentage + b.percentage,
        heightFactor:
            a.heightFactor > b.heightFactor ? a.heightFactor : b.heightFactor,
        posture: a.posture,
        isPlaceholder: false,
        originalIndex: a.originalIndex,
      );
      working
        ..removeRange(bestIdx, bestIdx + 2)
        ..insert(bestIdx, merged);
    }

    return working;
  }

  // ══════════════════════════════════════════════════════════════
  // 内部：箭头像素坐标（精准对齐段边界 + 段内插值）
  // ══════════════════════════════════════════════════════════════

  static double _computeArrowPixelX(
    List<_NormalizedSegment> normalized,
    double progress,
    double totalWidth,
    double gap,
    double segmentWidth,
  ) {
    // 用 normalized[i].percentage 作为权重，构建累积百分比 cumulative[i]
    final cumulative = <double>[];
    double sum = 0;
    for (final s in normalized) {
      sum += s.percentage;
      cumulative.add(sum);
    }
    // 兜底归一化
    if (sum == 0) {
      return gap + segmentWidth / 2;
    }
    for (int i = 0; i < cumulative.length; i++) {
      cumulative[i] = cumulative[i] / sum;
    }

    // 找到 progress 落在哪个区间
    int segIndex = 0;
    double segStartPct = 0;
    double segEndPct = cumulative[0];
    for (int i = 0; i < cumulative.length; i++) {
      final prev = i == 0 ? 0.0 : cumulative[i - 1];
      final curr = cumulative[i];
      if (progress <= curr || i == cumulative.length - 1) {
        segIndex = i;
        segStartPct = prev;
        segEndPct = curr;
        break;
      }
    }

    // 段内插值进度 [0,1]
    final segSpan = segEndPct - segStartPct;
    final tInSeg = segSpan <= 0
        ? 0.0
        : ((progress - segStartPct) / segSpan).clamp(0.0, 1.0);

    // 映射到像素：
    //   Row 中：i=0 左 margin gap, 其余左 margin gap/2；
    //           i=N-1 右 margin gap, 其余右 margin gap/2；
    //   所以第 i 段起点像素 = gap + i * (segmentWidth + gap)
    //   第 i 段终点像素 = 起点 + segmentWidth
    final segStartPixel = gap + segIndex * (segmentWidth + gap);
    final segEndPixel = segStartPixel + segmentWidth;
    final arrowX = segStartPixel + (segEndPixel - segStartPixel) * tInSeg;

    return arrowX.clamp(gap / 2, totalWidth - gap / 2);
  }
}

// ══════════════════════════════════════════════════════════════
// 规整段中间结构
// ══════════════════════════════════════════════════════════════

class _NormalizedSegment {
  final double percentage;
  final int heightFactor;
  final int posture;
  final bool isPlaceholder;
  final int originalIndex;

  _NormalizedSegment({
    required this.percentage,
    required this.heightFactor,
    required this.posture,
    required this.isPlaceholder,
    required this.originalIndex,
  });
}

// ══════════════════════════════════════════════════════════════
// 红色倒三角 CustomPainter
// ══════════════════════════════════════════════════════════════

class _TriangleIndicatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF3B30)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width / 2, size.height) // 底部尖点
      ..lineTo(0, 0) // 左上
      ..lineTo(size.width, 0) // 右上
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TriangleIndicatorPainter oldDelegate) => false;
}
