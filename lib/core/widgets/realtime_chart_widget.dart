import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// 实时数据折线图组件
/// 核心特性：
/// 1. 传入double类型currentValue，5秒更新一次
/// 2. 根据maxValue自动分割6段Y轴（刻度强制整数）
/// 3. 固定120个数据点，2:1长宽比，无布局冲突
///
/// 1:1 迁移自旧 `real_time_chart_widget.dart` 的 `RealTimeDataChartWidget`，仅重命名。
class RealtimeChartWidget extends StatefulWidget {
  final double currentValue;
  final int maxValue;
  final double? width;

  const RealtimeChartWidget({
    super.key,
    required this.currentValue,
    required this.maxValue,
    this.width,
  });

  @override
  State<RealtimeChartWidget> createState() => _RealtimeChartWidgetState();
}

class _RealtimeChartWidgetState extends State<RealtimeChartWidget> {
  List<double> chartData = List<double>.generate(120, (index) => 0.0);
  late Timer _updateTimer;
  bool _timerInitiated = false;
  late double _yAxisInterval;
  late List<int> _yAxisTitles;

  @override
  void initState() {
    super.initState();
    _updateYAxisConfig();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_timerInitiated) {
        _startUpdateTimer();
        _timerInitiated = true;
      }
    });
  }

  void _updateYAxisConfig() {
    final safeMax = widget.maxValue <= 0 ? 150 : widget.maxValue;
    double baseInterval = safeMax / 6;
    _yAxisInterval = baseInterval <= 0 ? 25 : baseInterval.ceilToDouble();

    _yAxisTitles = [];
    for (int i = 0; i <= safeMax; i += _yAxisInterval.toInt()) {
      _yAxisTitles.add(i);
    }
    if (_yAxisTitles.last != safeMax) {
      _yAxisTitles.add(safeMax);
    }
  }

  @override
  void didUpdateWidget(covariant RealtimeChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.maxValue != widget.maxValue) {
      setState(() {
        _updateYAxisConfig();
      });
    }
  }

  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          if (chartData.length >= 120) {
            double intValue = double.parse(
              widget.currentValue.toStringAsFixed(1),
            );
            chartData.insert(0, intValue);
            chartData.removeLast();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _updateTimer.cancel();
    _timerInitiated = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double chartWidth =
        widget.width ?? (MediaQuery.of(context).size.width * 0.9);
    final double chartHeight = chartWidth / 2;
    final safeMax = widget.maxValue <= 0 ? 150.0 : widget.maxValue.toDouble();

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: chartWidth,
        maxWidth: chartWidth,
        minHeight: chartHeight,
        maxHeight: chartHeight,
      ),
      child: SizedBox(
        width: chartWidth,
        height: chartHeight,
        child: Container(
          color: const Color(0xFF1A1A1A),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: RepaintBoundary(
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: safeMax,
                minX: 0,
                maxX: 119,
                clipData: const FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _yAxisInterval,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xFF444444),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _yAxisInterval,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        int intValue = value.round();
                        if (_yAxisTitles.contains(intValue)) {
                          return Text(
                            '$intValue',
                            style: const TextStyle(
                              color: Color(0xFFCCCCCC),
                              fontSize: 10,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: chartData
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    curveSmoothness: 0.2,
                    color: const Color(0xFF9CCC65),
                    barWidth: 1.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF9CCC65).withOpacity(0.3),
                      cutOffY: 0,
                      applyCutOffY: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
