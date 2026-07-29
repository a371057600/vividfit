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
    // 多重防护：避免除零死循环导致 OOM
    // 1. 确保 maxValue 在安全范围 [10, 200]
    int safeMax = widget.maxValue;
    if (safeMax <= 0) safeMax = 150;
    if (safeMax < 10) safeMax = 10;
    if (safeMax > 200) safeMax = 200;

    double baseInterval = safeMax / 6;
    _yAxisInterval = baseInterval <= 0 ? 25 : baseInterval.ceilToDouble();
    // 2. 确保 interval 至少为 1，防止步长为 0 死循环
    if (_yAxisInterval < 1) _yAxisInterval = 1;

    _yAxisTitles = [];
    final step = _yAxisInterval.toInt();
    // 3. 最终防护：步长 <= 0 直接返回默认刻度
    if (step <= 0) {
      _yAxisTitles = [0, safeMax];
      return;
    }
    // 4. 限制最大循环次数，防止异常值导致无限循环
    int maxIterations = (safeMax / step).ceil() + 2;
    if (maxIterations > 100) maxIterations = 100;
    int count = 0;
    for (int i = 0; i <= safeMax && count < maxIterations; i += step) {
      _yAxisTitles.add(i);
      count++;
    }
    if (_yAxisTitles.isEmpty) {
      _yAxisTitles = [0, safeMax];
    } else if (_yAxisTitles.last != safeMax) {
      _yAxisTitles.add(safeMax);
    }
  }

  String _formatToInt(double value) {
    return value.round().toString();
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
            print("currentValue: ${widget.currentValue}");
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
    // 与 _updateYAxisConfig 保持一致的安全范围
    double safeMax = widget.maxValue.toDouble();
    if (safeMax <= 0) safeMax = 150;
    if (safeMax < 10) safeMax = 10;
    if (safeMax > 200) safeMax = 200;

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
