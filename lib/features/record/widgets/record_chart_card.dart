import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';

/// Record 页面统计图表卡片组件。
///
/// 布局：顶部图标+标题+三列数据 → 中部柱状图（fl_chart，支持触摸显示数值）→ 底部分隔线+Mon-Sun标签。
/// 颜色全部使用 FitTheme 常量。
class RecordChartCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String currentValue;
  final String completionPercent;
  final String goalValue;
  final Color accentColor;
  final List<double> weekValues;
  final double maxY;

  const RecordChartCard({
    super.key,
    required this.icon,
    required this.title,
    required this.currentValue,
    required this.completionPercent,
    required this.goalValue,
    required this.accentColor,
    required this.weekValues,
    required this.maxY,
  });

  @override
  State<RecordChartCard> createState() => _RecordChartCardState();
}

class _RecordChartCardState extends State<RecordChartCard> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8).r,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16).r,
      decoration: BoxDecoration(
        color: FitTheme.secondbackGround,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 12.h),
          _buildChartArea(),
          SizedBox(height: 8.h),
          _buildDivider(),
          SizedBox(height: 8.h),
          _buildWeekLabels(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(widget.icon, color: FitTheme.textColor, size: 30.r),
            SizedBox(width: 10.w),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 26.sp,
                color: FitTheme.textColor,
                fontFamily: AppFonts.hofontmedium,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildDataRow(),
      ],
    );
  }

  Widget _buildDataRow() {
    const labels = ['当前进度', '完成进度', '目标达成'];
    final values = [
      widget.currentValue,
      widget.completionPercent,
      widget.goalValue,
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(3, (i) {
        return Expanded(
          child: Column(
            crossAxisAlignment: i == 0
                ? CrossAxisAlignment.start
                : (i == 2 ? CrossAxisAlignment.end : CrossAxisAlignment.center),
            children: [
              Text(
                labels[i],
                style: TextStyle(
                  fontSize: 20.sp,
                  color: FitTheme.textColor.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                values[i],
                style: TextStyle(
                  fontSize: 32.sp,
                  color: FitTheme.textColor,
                  fontFamily: AppFonts.bebas,
                  height: 1.1,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildChartArea() {
    final chartMaxY = widget.maxY > 0 ? widget.maxY : 1;
    return SizedBox(
      height: 200.h,
      width: double.infinity,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: chartMaxY * 1.25,
          minY: 0,
          barGroups: _buildBarGroups(),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          barTouchData: BarTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) =>
                  widget.accentColor.withValues(alpha: 0.9),
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ).r,
              tooltipMargin: 8,
              tooltipRoundedRadius: 6.r,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final value = rod.toY;
                return BarTooltipItem(
                  value.toStringAsFixed(value >= 10 ? 0 : 1),
                  TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontFamily: AppFonts.bebas,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    barTouchResponse == null ||
                    barTouchResponse.spot == null) {
                  _touchedIndex = -1;
                  return;
                }
                if (event is FlTapUpEvent || event is FlLongPressEnd) {
                  final newIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                  _touchedIndex = _touchedIndex == newIndex ? -1 : newIndex;
                } else {
                  _touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(7, (i) {
      final value = i < widget.weekValues.length
          ? widget.weekValues[i].clamp(0.0, widget.maxY)
          : 0.0;
      final isTouched = i == _touchedIndex;
      final barWidth = isTouched ? 26.w : 22.w;

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: value.toDouble(),
            color: widget.accentColor,
            width: barWidth,
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: widget.maxY > 0 ? widget.maxY : 1,
              color: widget.accentColor.withValues(alpha: 0.15),
            ),
          ),
        ],
        showingTooltipIndicators: isTouched ? [0] : [],
      );
    });
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 1.h,
      color: Colors.grey.withValues(alpha: 0.4),
    );
  }

  Widget _buildWeekLabels() {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: labels.map((label) {
        return Text(
          label,
          style: TextStyle(
            fontSize: 20.sp,
            color: FitTheme.textColor.withValues(alpha: 0.6),
          ),
        );
      }).toList(),
    );
  }
}
