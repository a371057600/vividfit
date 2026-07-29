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
    _audioPlayer.dispose(); // 修复旧代码内存泄漏（旧代码此处被注释）
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
        body: Stack(
          children:
              <Widget>[_buildMainWidget(state, screenHeight)] +
              _buildTopDataBarByDevice(state, screenWidth) +
              [
                _buildControllerButtonByDevice(state, screenHeight),
                _buildRealtimeChartByDevice(state, screenWidth, screenHeight),
                if (!state.isPaused) _buildPlayButton(state, tr),
                if (state.isPaused)
                  _buildPauseWidget(tr, screenHeight, screenWidth),
                _buildBackButton(state),
                Positioned(
                  left: 50.w,
                  top: 50.h,
                  child: _buildMusicButton(state),
                ),
              ],
        ),
      ),
    );
  }

  // ==================== 跑道动画层 ====================

  Widget _buildMainWidget(QuickStartState state, double screenHeight) {
    return Container(
      height: screenHeight,
      width: double.maxFinite,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 45, top: 45, right: 45).r,
            alignment: Alignment.centerLeft,
            height: 200.h,
            width: double.maxFinite,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(45).r,
              alignment: Alignment.center,
              child: OvalTrackWidget(
                radius: screenHeight * 0.3,
                lineLength: screenHeight * 0.7,
                trackWidth: 100.r,
                trackColor: const Color.fromARGB(255, 54, 54, 54),
                balls: [
                  TrackBallData(
                    radius: 38.r,
                    color: const Color.fromARGB(255, 255, 0, 0),
                    percentage: (state.sportDistance * 0.1) % 100,
                    showTrackLine: true,
                  ),
                  TrackBallData(
                    radius: 20.r,
                    color: Colors.white,
                    percentage: (state.npcTime * 1.2) % 100,
                  ),
                  TrackBallData(
                    radius: 20.r,
                    color: Colors.white,
                    percentage: (state.npcTime * 0.06) % 100,
                  ),
                  TrackBallData(
                    radius: 20.r,
                    color: Colors.white,
                    percentage: (state.npcTime * 0.5) % 100,
                  ),
                  TrackBallData(
                    radius: 20.r,
                    color: Colors.white,
                    percentage: (state.npcTime * 0.8) % 100,
                  ),
                  TrackBallData(
                    radius: 20.r,
                    color: Colors.white,
                    percentage: (state.npcTime * 0.6) % 100,
                  ),
                  TrackBallData(
                    radius: 20.r,
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
    late EdgeInsets margin;
    late MainAxisAlignment mainAxisAlignment;
    late double containerWidth;

    switch (widget.deviceType) {
      case FtmsDeviceType.indoorBike:
        margin = EdgeInsets.only(top: 25.h, right: 20.w, left: 100.w);
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
      case FtmsDeviceType.treadmill:
        margin = EdgeInsets.only(top: 25.h, right: 20.w, left: 100.w);
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
      case FtmsDeviceType.crossTrainer:
        margin = EdgeInsets.only(top: 25.h, right: 80.w, left: 50.w);
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
      case FtmsDeviceType.rower:
        margin = EdgeInsets.only(left: 150.w, top: 25.h, right: 100.w);
        mainAxisAlignment = MainAxisAlignment.spaceBetween;
        containerWidth = screenWidth - 200.w;
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
      case FtmsDeviceType.strengthStation:
        return [Container()];
    }

    return [
      Container(
        margin: margin,
        width: containerWidth,
        height: 200.h,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: metrics
              .map((m) => _buildMetricItem(m.iconPath, m.value))
              .toList(),
        ),
      ),
    ];
  }

  Widget _buildMetricItem(String imagePath, String dataString) {
    return Expanded(
      child: Container(
        child: Row(
          children: [
            Container(
              height: 30,
              child: Image.asset(imagePath, fit: BoxFit.fill),
            ),
            Container(width: 5.w),
            Container(
              width: 60.w,
              child: Text(
                dataString,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 25,
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

  Widget _buildControllerButtonByDevice(
    QuickStartState state,
    double screenHeight,
  ) {
    switch (widget.deviceType) {
      case FtmsDeviceType.indoorBike:
      case FtmsDeviceType.crossTrainer:
      case FtmsDeviceType.rower:
        return _buildBikeController(state, screenHeight);
      case FtmsDeviceType.treadmill:
        return _buildTreadmillController(state, screenHeight);
      case FtmsDeviceType.strengthStation:
        return Container();
    }
  }

  Widget _buildBikeController(QuickStartState state, double screenHeight) {
    return Container(
      margin: EdgeInsets.only(top: 200.h, left: 40.w, right: 40.w),
      width: MediaQuery.of(context).size.width,
      height: screenHeight,
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
          Spacer(),
          if (state.hasInclinationSupport)
            _buildLevelControlButton(
              first: (state.buttonInclinationList[3]).toStringAsFixed(1),
              second: (state.buttonInclinationList[2]).toStringAsFixed(1),
              third: state.sportInclinationButton.toStringAsFixed(1),
              fourth: (state.buttonInclinationList[1]).toStringAsFixed(1),
              fifth: (state.buttonInclinationList[0]).toStringAsFixed(1),
              type: "Inclination",
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

  Widget _buildTreadmillController(QuickStartState state, double screenHeight) {
    return Container(
      margin: EdgeInsets.only(top: 200.h, left: 40.w, right: 40.w),
      width: MediaQuery.of(context).size.width,
      height: screenHeight,
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
          Spacer(),
          _buildLevelControlButton(
            first: (state.buttonSpeedList[3]).toStringAsFixed(1),
            second: (state.buttonSpeedList[2]).toStringAsFixed(1),
            third: state.sportSpeedButton.toStringAsFixed(1),
            fourth: (state.buttonSpeedList[1]).toStringAsFixed(1),
            fifth: (state.buttonSpeedList[0]).toStringAsFixed(1),
            type: "Speed",
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

  /// 5 档控制按钮组件（1:1 还原旧 `_buildSizedLongButton`）。
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
  }) {
    final buttonDecoration = BoxDecoration(
      color: const Color.fromARGB(255, 25, 25, 25),
      borderRadius: BorderRadius.circular(3),
      border: Border.all(
        color: const Color.fromARGB(255, 106, 95, 95),
        width: 1,
      ),
    );

    final textStyle = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      fontFamily: AppFonts.bebas,
      color: Colors.white,
    );

    Widget buildButton(String value, Function()? onTapCallback) {
      return Expanded(
        flex: 1,
        child: InkWell(
          onTap: onTapCallback,
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 15, bottom: 15, right: 5, left: 5).r,
            decoration: buttonDecoration,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text("$value", style: textStyle),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 70.w,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildButton(first, onTap),
          buildButton(second, onTap1),
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.only(top: 15, bottom: 15, right: 5, left: 5).r,
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
                          size: 30.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$third",
                              style: textStyle,
                            ),
                            SizedBox(height: 6.sp),
                            Text(
                              type,
                              style: TextStyle(
                                fontSize: 8.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
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
                          size: 30.sp,
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
      case FtmsDeviceType.treadmill:
        maxValue = (state.maxSpeed / 100).round();
        currentValue = state.sportSpeed;
      case FtmsDeviceType.rower:
        maxValue = 150;
        currentValue = state.sportStrokeRate + 0.0;
      case FtmsDeviceType.strengthStation:
        return Container();
    }

    return Positioned(
      left: screenWidth * 0.5 - screenWidth * 0.2,
      top: screenHeight * 0.5,
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
      right: 20.w,
      top: 50.h,
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
              height: 30.sp,
              child: Image.asset(
                "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/music_play.png",
              ),
            ),
          );
  }
}

/// 顶部数据栏单项配置。
class _MetricConfig {
  final String iconPath;
  final String value;
  const _MetricConfig(this.iconPath, this.value);
}
