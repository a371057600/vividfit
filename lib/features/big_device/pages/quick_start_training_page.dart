import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/ftms/ftms_device_type.dart';
import '../../../core/widgets/oval_track_widget.dart';
import '../../../core/widgets/realtime_chart_widget.dart';
import '../../../l10n/app_localizations.dart';
import '../data/exercise_song_library.dart';
import '../data/sport_metric_icons.dart';
import '../notifiers/quick_start_notifier.dart';
import '../states/quick_start_state.dart';

/// 快速开始页（对应旧 `big_device_quick_start_screen.dart`）。
///
/// UI 1:1 还原旧页面，业务逻辑全部留白（Notifier 方法为 TODO）。
/// 用 `ConsumerStatefulWidget` + `ref.watch` 替代 GetX `Obx`/`Get.find`。
class QuickStartTrainingPage extends ConsumerStatefulWidget {
  final FtmsDeviceType deviceType;

  const QuickStartTrainingPage({super.key, required this.deviceType});

  @override
  ConsumerState<QuickStartTrainingPage> createState() =>
      _QuickStartTrainingPageState();
}

class _QuickStartTrainingPageState extends ConsumerState<QuickStartTrainingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // 强制横屏(与入口页保持一致,避免竖屏导致布局崩溃)
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    // 进入快速开始界面后，发送指令让设备阻力设置为初始值（业务留白）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          final notifier = ref.read(quickStartProvider.notifier);
          notifier.setDeviceType(widget.deviceType);
          notifier.sendResetToDevice();
        }
      });
    });

    _audioPlayer.setLoopMode(LoopMode.one);
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    // 页面销毁时清理所有目标弹窗 Timer，避免回调时页面已卸载抛异常
    ref.read(quickStartProvider.notifier).disposeGoalTimers();
    super.dispose();
  }

  int _generateRandomNumber() => Random().nextInt(8);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quickStartProvider);
    final tr = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F0F),
        body: Stack(
          children:
              <Widget>[_buildMainWidget(state, screenWidth, screenHeight)] +
              _buildTopDataBarByDevice(state, screenWidth) +
              [
                _buildControllerButtonByDevice(state),
                _buildRealtimeChartByDevice(state, screenWidth, screenHeight),
                if (!state.isPaused) _buildPlayButton(state, tr),
                if (state.isPaused)
                  _buildPauseWidget(tr, screenHeight, screenWidth),
                _buildBackButton(state),
                Positioned(
                  left: 40.w,
                  top: 40.h,
                  child: _buildMusicButton(state),
                ),
                // ==================== 3 个目标达成弹窗（最顶层） ====================
                if (state.showTimeGoalDialog)
                  _buildGoalDialog(
                    iconPath: SportMetricIcons.byIndex(0),
                    title: '恭喜达成运动时长目标',
                    valueText: ref
                        .read(quickStartProvider.notifier)
                        .convertSecondsToTime(state.currentTimeGoalSec),
                    unitText: '',
                    onDismiss: ref
                        .read(quickStartProvider.notifier)
                        .dismissTimeGoalDialog,
                  ),
                if (state.showDistanceGoalDialog)
                  _buildGoalDialog(
                    iconPath: SportMetricIcons.byIndex(1),
                    title: '恭喜达成运动距离目标',
                    valueText: state.currentDistanceGoalKm.toStringAsFixed(1),
                    unitText: 'km',
                    onDismiss: ref
                        .read(quickStartProvider.notifier)
                        .dismissDistanceGoalDialog,
                  ),
                if (state.showEnergyGoalDialog)
                  _buildGoalDialog(
                    iconPath: SportMetricIcons.byIndex(2),
                    title: '恭喜达成消耗目标',
                    valueText: state.currentEnergyGoalKcal.toStringAsFixed(0),
                    unitText: 'kcal',
                    onDismiss: ref
                        .read(quickStartProvider.notifier)
                        .dismissEnergyGoalDialog,
                  ),
              ],
        ),
      ),
    );
  }

  // ==================== 跑道动画层 ====================

  Widget _buildMainWidget(
    QuickStartState state,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      height: screenHeight,
      width: screenWidth,
      child: Column(
        children: [
          // 顶部数据栏预留空间
          Container(
            margin: EdgeInsets.only(left: 20.w, top: 10.h, right: 30.w),
            alignment: Alignment.centerLeft,
            height: 150.h,
            width: screenWidth,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 0, bottom: 100).r,
              alignment: Alignment.center,
              child: OvalTrackWidget(
                radius: screenHeight * 0.25,
                lineLength: screenHeight * 0.7,
                trackWidth: 45.r,
                trackColor: const Color.fromARGB(255, 54, 54, 54),
                balls: [
                  TrackBallData(
                    radius: 20.r,
                    color: const Color.fromARGB(255, 255, 0, 0),
                    percentage: (state.sportDistance * 0.1) % 100,
                    showTrackLine: true,
                  ),
                  TrackBallData(
                    radius: 13.r,
                    color: Colors.white,
                    percentage: (state.npcTime * 1.2) % 100,
                  ),
                  TrackBallData(
                    radius: 13.r,
                    color: Colors.white,
                    percentage: (state.npcTime * 0.06) % 100,
                  ),
                  TrackBallData(
                    radius: 13.r,
                    color: Colors.white,
                    percentage: (state.npcTime * 0.5) % 100,
                  ),
                  TrackBallData(
                    radius: 13.r,
                    color: Colors.white,
                    percentage: (state.npcTime * 0.8) % 100,
                  ),
                  TrackBallData(
                    radius: 13.r,
                    color: Colors.white,
                    percentage: (state.npcTime * 0.6) % 100,
                  ),
                  TrackBallData(
                    radius: 13.r,
                    color: Colors.white,
                    percentage: (state.npcTime * 0.3) % 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== 顶部数据栏层 ====================

  List<Widget> _buildTopDataBarByDevice(
    QuickStartState state,
    double screenWidth,
  ) {
    final notifier = ref.read(quickStartProvider.notifier);
    late List<_MetricConfig> metrics;
    late EdgeInsets padding;
    late MainAxisAlignment mainAxisAlignment;
    late double containerWidth;

    switch (widget.deviceType) {
      case FtmsDeviceType.indoorBike:
        padding = EdgeInsets.only(top: 30.h, right: 40.w, left: 80.w);
        mainAxisAlignment = MainAxisAlignment.spaceBetween;
        containerWidth = screenWidth;
        metrics = [
          _MetricConfig(
            SportMetricIcons.byIndex(0),
            notifier.convertSecondsToTime(state.realSportTime),
          ),
          _MetricConfig(
            SportMetricIcons.byIndex(1),
            (state.sportDistance / 1000).toStringAsFixed(2),
          ),
          _MetricConfig(SportMetricIcons.byIndex(2), '${state.sportEnergy} '),
          _MetricConfig(
            SportMetricIcons.byIndex(3),
            state.sportSpeed.toStringAsFixed(1),
          ),
          _MetricConfig(
            SportMetricIcons.byIndex(7),
            state.sportCadence.toStringAsFixed(0),
          ),
          _MetricConfig(SportMetricIcons.byIndex(5), '${state.sportHeartRate}'),
        ];
        break;
      case FtmsDeviceType.treadmill:
        padding = EdgeInsets.only(top: 30.h, right: 50.w, left: 50.w);
        mainAxisAlignment = MainAxisAlignment.spaceBetween;
        containerWidth = screenWidth;
        metrics = [
          _MetricConfig(
            SportMetricIcons.byIndex(0),
            notifier.convertSecondsToTime(state.realSportTime),
          ),
          _MetricConfig(
            SportMetricIcons.byIndex(1),
            (state.sportDistance / 1000).toStringAsFixed(2),
          ),
          _MetricConfig(SportMetricIcons.byIndex(2), '${state.sportEnergy} '),
          _MetricConfig(
            SportMetricIcons.byIndex(3),
            state.sportSpeed.toStringAsFixed(1),
          ),
          _MetricConfig(SportMetricIcons.byIndex(5), '${state.sportHeartRate}'),
        ];
        break;
      case FtmsDeviceType.crossTrainer:
        padding = EdgeInsets.only(top: 30.h, right: 80.w, left: 60.w);
        mainAxisAlignment = MainAxisAlignment.spaceAround;
        containerWidth = screenWidth;
        metrics = [
          _MetricConfig(
            SportMetricIcons.byIndex(0),
            notifier.convertSecondsToTime(state.realSportTime),
          ),
          _MetricConfig(
            SportMetricIcons.byIndex(1),
            (state.sportDistance / 1000).toStringAsFixed(2),
          ),
          _MetricConfig(SportMetricIcons.byIndex(2), '${state.sportEnergy} '),
          _MetricConfig(
            SportMetricIcons.byIndex(3),
            state.sportSpeed.toStringAsFixed(1),
          ),
          _MetricConfig(
            SportMetricIcons.byIndex(7),
            state.sportCadence.toStringAsFixed(0),
          ),
          _MetricConfig(SportMetricIcons.byIndex(5), '${state.sportHeartRate}'),
        ];
        break;
      case FtmsDeviceType.rower:
        padding = EdgeInsets.only(left: 120.w, top: 30.h, right: 50.w);
        mainAxisAlignment = MainAxisAlignment.spaceBetween;
        containerWidth = screenWidth - 170.w;
        metrics = [
          _MetricConfig(
            SportMetricIcons.byIndex(0),
            notifier.convertSecondsToTime(state.realSportTime),
          ),
          _MetricConfig(SportMetricIcons.byIndex(1), '${state.sportDistance} '),
          _MetricConfig(SportMetricIcons.byIndex(2), '${state.sportEnergy} '),
          _MetricConfig(
            SportMetricIcons.byIndex(4),
            state.sportStrokeCount.toStringAsFixed(0),
          ),
          _MetricConfig(
            SportMetricIcons.byIndex(6),
            state.sportStrokeRate.toStringAsFixed(0),
          ),
          _MetricConfig(SportMetricIcons.byIndex(5), '${state.sportHeartRate}'),
        ];
        break;
      case FtmsDeviceType.strengthStation:
        return [Container()];
    }

    return [
      Padding(
        padding: padding,
        child: Container(
          width: containerWidth,
          height: 150.h + kTopDataBarBottomPadding.h,
          padding: EdgeInsets.only(bottom: kTopDataBarBottomPadding.h),
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: metrics
                .map((m) => _buildMetricItem(m.iconPath, m.value))
                .toList(),
          ),
        ),
      ),
    ];
  }

  Widget _buildMetricItem(String imagePath, String dataString) {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 24.sp,
              child: Image.asset(imagePath, fit: BoxFit.fill),
            ),
            Container(width: 3.w),
            Container(
              width: 50.w,
              child: Text(
                dataString,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.bebas,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== 控制按钮层 ====================

  Widget _buildControllerButtonByDevice(QuickStartState state) {
    switch (widget.deviceType) {
      case FtmsDeviceType.indoorBike:
      case FtmsDeviceType.crossTrainer:
      case FtmsDeviceType.rower:
        return _buildBikeController(state);
      case FtmsDeviceType.treadmill:
        return _buildTreadmillController(state);
      case FtmsDeviceType.strengthStation:
        return Container();
    }
  }

  Widget _buildBikeController(
    QuickStartState state, {
    // ===== 用户可调节的控制按钮容器参数（均有默认值） =====
    double? controllerWidthFactor,
    double? controllerHeightFactor,
    EdgeInsetsGeometry? controllerMargin,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final margin =
        controllerMargin ??
        EdgeInsets.only(
          top: kControllerTopPaddingBike.h,
          left: 40.w,
          right: 40.w,
          bottom: kControllerBottomPadding.h,
        );
    return Container(
      margin: margin,
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLevelControlButton(
            first: (state.buttonResistanceList[3]).toStringAsFixed(1),
            second: (state.buttonResistanceList[2]).toStringAsFixed(1),
            third: state.sportResistanceButton.toStringAsFixed(1),
            fourth: (state.buttonResistanceList[1]).toStringAsFixed(1),
            fifth: (state.buttonResistanceList[0]).toStringAsFixed(1),
            type: "Resistance",
            widthFactor: controllerWidthFactor,
            heightFactor: controllerHeightFactor,
            onTap: () {
              final n = ref.read(quickStartProvider.notifier);
              n.numberButton(state.buttonResistanceList[3], 2);
            },
            onTap1: () {
              final n = ref.read(quickStartProvider.notifier);
              n.numberButton(state.buttonResistanceList[2], 2);
            },
            onTap2: () {
              ref.read(quickStartProvider.notifier).resistanceAdd();
            },
            onTap3: () {
              ref.read(quickStartProvider.notifier).resistanceDown();
            },
            onTap4: () {
              final n = ref.read(quickStartProvider.notifier);
              n.numberButton(state.buttonResistanceList[1], 2);
            },
            onTap5: () {
              final n = ref.read(quickStartProvider.notifier);
              n.numberButton(state.buttonResistanceList[0], 2);
            },
            onLongPress2: () {
              // TODO: 蓝牙模块迁移后对接 longPressResistanceAdd
            },
            onLongPressEnd2: (d) {
              ref.read(quickStartProvider.notifier).longPressEnd();
            },
            onLongPress3: () {
              // TODO: 蓝牙模块迁移后对接 longPressResistanceDown
            },
            onLongPressEnd3: (d) {
              ref.read(quickStartProvider.notifier).longPressEnd();
            },
          ),
          const Spacer(),
          if (state.hasInclinationSupport)
            _buildLevelControlButton(
              first: (state.buttonInclinationList[3]).toStringAsFixed(1),
              second: (state.buttonInclinationList[2]).toStringAsFixed(1),
              third: state.sportInclinationButton.toStringAsFixed(1),
              fourth: (state.buttonInclinationList[1]).toStringAsFixed(1),
              fifth: (state.buttonInclinationList[0]).toStringAsFixed(1),
              type: "Inclination",
              widthFactor: controllerWidthFactor,
              heightFactor: controllerHeightFactor,
              onTap: () {
                final n = ref.read(quickStartProvider.notifier);
                n.numberButton(state.buttonInclinationList[3], 1);
              },
              onTap1: () {
                final n = ref.read(quickStartProvider.notifier);
                n.numberButton(state.buttonInclinationList[2], 1);
              },
              onTap2: () {
                ref.read(quickStartProvider.notifier).inclinationAdd();
              },
              onTap3: () {
                ref.read(quickStartProvider.notifier).inclinationDown();
              },
              onTap4: () {
                final n = ref.read(quickStartProvider.notifier);
                n.numberButton(state.buttonInclinationList[1], 1);
              },
              onTap5: () {
                final n = ref.read(quickStartProvider.notifier);
                n.numberButton(state.buttonInclinationList[0], 1);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTreadmillController(
    QuickStartState state, {
    // ===== 用户可调节的控制按钮容器参数（均有默认值） =====
    double? controllerWidthFactor,
    double? controllerHeightFactor,
    EdgeInsetsGeometry? controllerMargin,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final margin =
        controllerMargin ??
        EdgeInsets.only(
          top: kControllerTopPaddingTreadmill.h,
          left: 40.w,
          right: 40.w,
          bottom: kControllerBottomPadding.h,
        );
    return Container(
      margin: margin,
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (state.hasInclinationSupport)
            _buildLevelControlButton(
              first: (state.buttonInclinationList[3]).toStringAsFixed(1),
              second: (state.buttonInclinationList[2]).toStringAsFixed(1),
              third: state.sportInclinationButton.toStringAsFixed(1),
              fourth: (state.buttonInclinationList[1]).toStringAsFixed(1),
              fifth: (state.buttonInclinationList[0]).toStringAsFixed(1),
              type: "Inclination",
              widthFactor: controllerWidthFactor,
              heightFactor: controllerHeightFactor,
              onTap: () {
                final n = ref.read(quickStartProvider.notifier);
                n.numberButton(state.buttonInclinationList[3], 1);
              },
              onTap1: () {
                final n = ref.read(quickStartProvider.notifier);
                n.numberButton(state.buttonInclinationList[2], 1);
              },
              onTap2: () {
                ref.read(quickStartProvider.notifier).inclinationAdd();
              },
              onTap3: () {
                ref.read(quickStartProvider.notifier).inclinationDown();
              },
              onTap4: () {
                final n = ref.read(quickStartProvider.notifier);
                n.numberButton(state.buttonInclinationList[1], 1);
              },
              onTap5: () {
                final n = ref.read(quickStartProvider.notifier);
                n.numberButton(state.buttonInclinationList[0], 1);
              },
            ),
          const Spacer(),
          _buildLevelControlButton(
            first: (state.buttonSpeedList[3]).toStringAsFixed(1),
            second: (state.buttonSpeedList[2]).toStringAsFixed(1),
            third: state.sportSpeedButton.toStringAsFixed(1),
            fourth: (state.buttonSpeedList[1]).toStringAsFixed(1),
            fifth: (state.buttonSpeedList[0]).toStringAsFixed(1),
            type: "Speed",
            widthFactor: controllerWidthFactor,
            heightFactor: controllerHeightFactor,
            onTap: () {
              final n = ref.read(quickStartProvider.notifier);
              n.numberButton(state.buttonSpeedList[3], 0);
            },
            onTap1: () {
              final n = ref.read(quickStartProvider.notifier);
              n.numberButton(state.buttonSpeedList[2], 0);
            },
            onTap2: () {
              ref.read(quickStartProvider.notifier).speedAdd();
            },
            onTap3: () {
              ref.read(quickStartProvider.notifier).speedDown();
            },
            onTap4: () {
              final n = ref.read(quickStartProvider.notifier);
              n.numberButton(state.buttonSpeedList[1], 0);
            },
            onTap5: () {
              final n = ref.read(quickStartProvider.notifier);
              n.numberButton(state.buttonSpeedList[0], 0);
            },
            onLongPress2: () {
              // TODO: 蓝牙模块迁移后对接 longPressSpeedAdd
            },
            onLongPressEnd2: (d) {
              ref.read(quickStartProvider.notifier).longPressEnd();
            },
            onLongPress3: () {
              // TODO: 蓝牙模块迁移后对接 longPressSpeedDown
            },
            onLongPressEnd3: (d) {
              ref.read(quickStartProvider.notifier).longPressEnd();
            },
          ),
        ],
      ),
    );
  }

  /// 5 档控制按钮组件。
  ///
  /// 暴露 [widthFactor] / [heightFactor] 供用户按比例缩放整体尺寸。
  /// 样式（色值、圆角、边框、布局）保持不变。
  Widget _buildLevelControlButton({
    required String first,
    required String second,
    required String third,
    required String fourth,
    required String fifth,
    required String type,
    Function()? onTap,
    Function()? onTap1,
    Function()? onTap2,
    Function()? onTap3,
    Function()? onTap4,
    Function()? onTap5,
    Function()? onLongPress2,
    Function(LongPressEndDetails)? onLongPressEnd2,
    Function()? onLongPress3,
    Function(LongPressEndDetails)? onLongPressEnd3,
    // ===== 用户可调节的尺寸参数（均有默认值） =====
    double? widthFactor,
    double? heightFactor,
  }) {
    final wf = widthFactor ?? kControllerWidthFactor;
    final hf = heightFactor ?? kControllerHeightFactor;
    final scaleFactor = wf < hf ? wf : hf; // 文字/图标取较小系数，保证不溢出

    final screenHeight = MediaQuery.of(context).size.height;
    final buttonWidth = 70.w * wf;
    final buttonHeight = screenHeight * kControllerUsableHeightRatio * hf;

    final buttonDecoration = BoxDecoration(
      color: const Color.fromARGB(255, 25, 25, 25),
      borderRadius: BorderRadius.circular(3),
      border: Border.all(
        color: const Color.fromARGB(255, 106, 95, 95),
        width: 1,
      ),
    );

    final textStyle = TextStyle(
      fontSize: 18.sp * scaleFactor,
      height: 0.8,
      fontWeight: FontWeight.w500,
      fontFamily: AppFonts.bebas,
      color: Colors.white,
    );

    final innerMargin =
        EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5).r * scaleFactor;
    final innerBottomPadding = 4 * scaleFactor;

    Widget buildButton(String value, Function()? onTapCallback) {
      return Expanded(
        flex: 1,
        child: InkWell(
          onTap: onTapCallback,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: innerBottomPadding),
            margin: innerMargin,
            decoration: buttonDecoration,
            child: Text(value, style: textStyle),
          ),
        ),
      );
    }

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildButton(first, onTap),
          buildButton(second, onTap1),
          Expanded(
            flex: 3,
            child: Container(
              margin: innerMargin,
              decoration: buttonDecoration,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onLongPress: onLongPress2,
                      onLongPressEnd: onLongPressEnd2,
                      onTap: onTap2,
                      child: Container(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.add,
                          size: 30.sp * scaleFactor,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(third, style: textStyle),
                          SizedBox(height: 8.sp * scaleFactor),
                          Text(
                            type,
                            style: TextStyle(
                              fontSize: 8.sp * scaleFactor,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onLongPress: onLongPress3,
                      onLongPressEnd: onLongPressEnd3,
                      onTap: onTap3,
                      child: Container(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.remove,
                          size: 30.sp * scaleFactor,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          buildButton(fourth, onTap4),
          buildButton(fifth, onTap5),
        ],
      ),
    );
  }

  // ==================== 实时图表层 ====================

  Widget _buildRealtimeChartByDevice(
    QuickStartState state,
    double screenWidth,
    double screenHeight,
  ) {
    late final int maxValue;
    late final double currentValue;

    switch (widget.deviceType) {
      case FtmsDeviceType.indoorBike:
      case FtmsDeviceType.crossTrainer:
        maxValue = 150;
        currentValue = state.sportCadence + 0.0;
        break;
      case FtmsDeviceType.treadmill:
        // 跑步机：当maxSpeed未初始化（默认0）时使用默认值20；有值时FTMS原始值需除以100
        final rawMax = state.maxSpeed;
        maxValue = rawMax <= 0 ? 20 : (rawMax / 100).round().clamp(10, 30);
        currentValue = state.sportSpeed;
        break;
      case FtmsDeviceType.rower:
        maxValue = 150;
        currentValue = state.sportStrokeRate + 0.0;
        break;
      case FtmsDeviceType.strengthStation:
        return Container();
    }

    return Positioned(
      left: screenWidth * 0.5 - screenWidth * 0.2,
      top: screenHeight * 0.42,
      child: Container(
        height: screenHeight / 4,
        width: screenWidth * 0.4,
        child: RealtimeChartWidget(
          maxValue: maxValue,
          currentValue: currentValue,
          width: screenWidth * 0.4,
        ),
      ),
    );
  }

  // ==================== 播放/暂停/返回/音乐层 ====================

  Widget _buildPlayButton(QuickStartState state, AppLocalizations tr) {
    return Container(
      margin: EdgeInsets.only(top: 230.h),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: state.showPlayButton
          ? Center(
              child: GestureDetector(
                onTap: () {
                  // 检查设备是否已在运动中
                  if (state.isPlaying || state.sportSpeed > 0) {
                    Fluttertoast.showToast(
                      msg: tr.deviceInMotionPleaseStop,
                      toastLength: Toast.LENGTH_LONG,
                    );
                    return;
                  }
                  // 启动快速开始
                  ref.read(quickStartProvider.notifier).startSport();
                },
                child: Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(125),
                    border: Border.all(
                      color: Colors.white.withAlpha(125),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withAlpha(77),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    size: 60.w,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildPauseWidget(
    AppLocalizations tr,
    double screenHeight,
    double screenWidth,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 230.h),
      height: screenHeight,
      width: screenWidth,
      child: Center(
        child: Text(
          tr.pleaseResumeTheMachine,
          style: TextStyle(
            fontSize: 30.w,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(QuickStartState state) {
    return Positioned(
      right: 30.w,
      top: 30.h,
      child: InkWell(
        onTap: () {
          final notifier = ref.read(quickStartProvider.notifier);
          notifier.clearData();
          if (state.isPlaying) {
            notifier.stopSport();
          }
          Navigator.of(context).pop();
        },
        child: SizedBox(
          height: 25.sp,
          child: Image.asset(
            "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/icon_get_back.png",
          ),
        ),
      ),
    );
  }

  Widget _buildMusicButton(QuickStartState state) {
    return state.isMusicPlaying
        ? InkWell(
            splashColor: Colors.transparent,
            onTap: () async {
              await _audioPlayer.stop();
              ref.read(quickStartProvider.notifier).updateMusicPlaying(false);
            },
            child: Container(
              height: 30.sp,
              child: Image.asset(
                "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/music_pause.png",
              ),
            ),
          )
        : InkWell(
            splashColor: Colors.transparent,
            onTap: () async {
              final index = _generateRandomNumber();
              final songs = ExerciseSongLibrary.forType(widget.deviceType);
              await _audioPlayer.setUrl(songs[index]);
              // 音乐加载中过渡 Dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
              await _audioPlayer.play();
              ref.read(quickStartProvider.notifier).updateMusicPlaying(true);
              // 音乐开始播放后关闭对话框
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) Navigator.of(context).pop();
              });
            },
            child: Container(
              height: 25.sp,
              child: Image.asset(
                "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/music_play.png",
              ),
            ),
          );
  }

  // ==================== 目标达成弹窗 UI ====================

  /// 通用目标达成弹窗。
  ///
  /// - 蒙层不拦截点击（IgnorePointer 包裹蒙层），弹窗内部按钮可正常响应；
  /// - 30 秒自动消失逻辑在 Notifier 层的 Timer 中实现；
  /// - 点击弹窗内「关闭」按钮立刻关闭并取消 30 秒倒计时。
  Widget _buildGoalDialog({
    required String iconPath,
    required String title,
    required String valueText,
    required String unitText,
    required VoidCallback onDismiss,
  }) {
    return Positioned.fill(
      // 弹窗外层不吸收点击：用户仍可操作下方控制按钮/返回按钮等
      child: IgnorePointer(
        child: Container(
          color: Colors.black.withValues(alpha: 0.2),
          // 弹窗内部吸收点击
          child: IgnorePointer(
            ignoring: false,
            child: Center(
              child: Container(
                width: 480.w,
                padding: EdgeInsets.symmetric(horizontal: 28.r, vertical: 30.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF161618),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 22.r,
                      spreadRadius: 2.r,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 顶部祝贺图标
                    Container(
                      width: 72.r,
                      height: 72.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(
                          255,
                          255,
                          193,
                          7,
                        ).withValues(alpha: 0.15),
                      ),
                      alignment: Alignment.center,
                      child: Text('🎉', style: TextStyle(fontSize: 40.sp)),
                    ),
                    SizedBox(height: 20.r),
                    // 目标类型小图标 + 标题
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 22.sp,
                          child: Image.asset(iconPath, fit: BoxFit.fill),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: AppFonts.bebas,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.r),
                    // 数值大字展示
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          valueText,
                          style: TextStyle(
                            fontSize: 54.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 255, 193, 7),
                            fontFamily: AppFonts.bebas,
                            height: 0.9,
                          ),
                        ),
                        if (unitText.isNotEmpty) ...[
                          SizedBox(width: 8.w),
                          Padding(
                            padding: EdgeInsets.only(bottom: 6.r),
                            child: Text(
                              unitText,
                              style: TextStyle(
                                fontSize: 22.sp,
                                color: Colors.white.withValues(alpha: 0.7),
                                fontFamily: AppFonts.bebas,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 24.r),
                    // 关闭按钮
                    InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: onDismiss,
                      child: Container(
                        width: 220.w,
                        padding: EdgeInsets.symmetric(vertical: 14.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 80, 140, 255),
                              Color.fromARGB(255, 40, 100, 240),
                            ],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '关闭',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.r),
                    Text(
                      '30 秒后自动关闭',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ==================== 控制按钮缩放与间距常量（集中调节入口） ====================
/// 控制按钮整体宽度缩放系数，用户可直接调此值控制整体大小。
const double kControllerWidthFactor = 1;

/// 控制按钮整体高度缩放系数。
const double kControllerHeightFactor = 0.98;

/// 控制按钮可用高度占屏幕高度的比例（0.82 × 0.86 ≈ 70% 屏占比）。
const double kControllerUsableHeightRatio = 0.82;

/// 控制按钮距顶部的额外间距（避免遮挡顶部数据栏）。
const double kControllerTopPaddingBike = 200.0;
const double kControllerTopPaddingTreadmill = 200.0;

/// 控制按钮距底部的额外间距（避免遮挡实时图表）。
const double kControllerBottomPadding = 70.0;

/// 顶部数据栏底部额外安全间隙。
const double kTopDataBarBottomPadding = 25.0;

/// 顶部数据栏单项配置。
class _MetricConfig {
  final String iconPath;
  final String value;
  const _MetricConfig(this.iconPath, this.value);
}
