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
import '../models/device_control_callbacks.dart';
import '../models/device_control_data.dart';
import '../models/sport_data_model.dart';
import '../notifiers/quick_start_notifier.dart';
import '../states/goal_banner_display_state.dart';
import '../states/quick_start_state.dart';
import '../widgets/goal_banner_animator.dart';
import '../widgets/sport_control_panel.dart';
import '../widgets/sport_data_display.dart';

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

  /// 提前缓存 Notifier 引用，避免在 dispose 时再通过 ref.read(...) 访问。
  ///
  /// 背景：退出 quick_start_select_screen 时，本 State 会先被标记为 unmounting/deactivated，
  /// 此时如果再用 ref（ConsumerState.ref）会抛：
  ///   Bad state: Using "ref" when a widget is about to or has been unmounted is unsafe.
  /// 在 dispose 里用已经保存的 Notifier 字段引用，就不需要依赖 BuildContext。
  late final QuickStartNotifier _quickStartNotifier;

  @override
  void initState() {
    super.initState();

    // —— 只在 initState 内读一次 ref 并保存为字段，后续（含 dispose/回调）全都用字段。
    _quickStartNotifier = ref.read(quickStartProvider.notifier);

    // 强制横屏(与入口页保持一致,避免竖屏导致布局崩溃)
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    // 进入快速开始界面后，设置设备类型 + 发送指令让设备参数复位（业务留白）
    //
    // 🔧 移除原 500ms 延迟：就绪等待已内置到 Notifier 的 GATT 串行链
    // （_waitForServiceReady → 能力读取 → 0x00 写入），首帧后立即初始化，
    // 消除「首帧使用上一会话残留 state」的 500ms 窗口。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final notifier = _quickStartNotifier;
        notifier.setDeviceType(widget.deviceType);
        // fire-and-forget：内部等待服务就绪 + 范围读取完成后才真正下发 0x00
        notifier.sendResetToDevice();
        // 任务5：进入界面后检测设备是否正在运行
        notifier.checkDeviceRunningOnEntry();
      }
    });

    // 任务8.2：首帧后执行四级启动验证（避免在 build 周期内修改 provider state）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final result = _quickStartNotifier.validateDeviceReady();
      print(
        '[DeviceCheck] 训练页启动验证: ready=${result.isReady}, '
        'failedStep=${result.failedStep}, reason=${result.reason}',
      );
      if (!result.isReady) {
        // 未就绪：提示用户先完成设备同步（复用 Toast，不新造 UI）
        Fluttertoast.showToast(
          msg: '设备未就绪：${result.reason}，请先完成设备同步',
          toastLength: Toast.LENGTH_LONG,
        );
      }
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
    // ✅ 仅调用 dispose()（内部会停止播放）；不再先 stop()，
    // 避免 stop() 未 await 的 Future 与 dispose() 内部 Future 链相互 complete，
    // 触发 "Cannot complete a future with itself" 异常。
    // try-catch 防御性兜底：卸载阶段任何音频异常都不应影响页面退出。
    try {
      _audioPlayer.dispose();
    } catch (e) {
      print('[Music] dispose error: $e');
    }
    // ✅ dispose 阶段 widget tree 处于重建周期，仅清理 Timer 资源，
    // 不修改 provider state，避免触发「Tried to modify a provider while
    // the widget tree was building」异常。
    _quickStartNotifier.cancelAllGoalTimers();
    super.dispose();
  }

  int _generateRandomNumber() => Random().nextInt(8);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quickStartProvider);
    final tr = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 任务9.2：断连自动退出——设备断开后提示并返回上一级
    ref.listen(quickStartProvider.select((s) => s.isDeviceConnectionLost), (
      prev,
      next,
    ) {
      if (next && prev != true) {
        print('[DeviceCheck] 检测到断连标志，自动退出训练页');
        Fluttertoast.showToast(msg: '设备已断开', toastLength: Toast.LENGTH_LONG);
        Navigator.of(context).pop();
      }
    });
    // 任务9.2：指令重发耗尽——消费失败标志并复位（Toast 已由 Notifier 弹出）
    ref.listen(quickStartProvider.select((s) => s.lastParamSyncFailed), (
      prev,
      next,
    ) {
      if (next && prev != true) {
        ref.read(quickStartProvider.notifier).markParamSyncFailedConsumed();
      }
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F0F),
        body: Stack(
          children:
              <Widget>[_buildMainWidget(state, screenWidth, screenHeight)] +
              _buildTopDataBarByDevice(state, screenWidth) +
              [
                _buildRealtimeChartByDevice(state, screenWidth, screenHeight),
                if (!state.isPaused) _buildPlayButton(state, tr),
                if (state.isPaused)
                  _buildPauseWidget(tr, screenHeight, screenWidth),
                _buildControllerButtonByDevice(state),
                _buildBackButton(state),
                Positioned(
                  left: 40.w,
                  top: 80.h,
                  child: _buildMusicButton(state),
                ),
                // ==================== 3 个目标达成弹窗（下方胶囊 Banner 三等分布局） ====================
                Builder(
                  builder: (ctx) {
                    // deactivated/unmounting 阶段（退出 quick_start_select_screen 时）
                    // Provider 可能仍然发了最后一次 state 更新，导致 Builder 再进一次。
                    // 此时 ConsumerState.ref 已经不安全，先检查 mounted 再做任何操作。
                    if (!mounted) return const SizedBox.shrink();
                    debugPrint(
                      '🔲 [DialogLayer] rebuild → '
                      'distState=${state.distanceDialogDisplayState} '
                      '(${state.currentDistanceGoalKm.toStringAsFixed(2)} km) · '
                      'timeState=${state.timeDialogDisplayState} '
                      '(${state.currentTimeGoalSec ~/ 60} min) · '
                      'energyState=${state.energyDialogDisplayState} '
                      '(${state.currentEnergyGoalKcal.toStringAsFixed(0)} kcal)',
                    );
                    return Positioned(
                      left: 120.w,
                      right: 100.w,
                      bottom: 70.h,
                      child: Row(
                        children: [
                          // 左 1/3 槽位 → 距离目标（从左侧滑入）
                          Expanded(
                            child: Center(
                              child:
                                  (mounted &&
                                      state.distanceDialogDisplayState !=
                                          GoalBannerDisplayState.hidden)
                                  ? GoalBannerAnimator(
                                      displayState:
                                          state.distanceDialogDisplayState,
                                      direction: EntryDirection.fromLeft,
                                      child: Builder(
                                        builder: (ctx2) {
                                          debugPrint(
                                            '🔲 [DialogLayer] 距离Banner: visible，开始构建',
                                          );
                                          return _buildDistanceGoalBanner(
                                            state,
                                          );
                                        },
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                          // 中 1/3 槽位 → 时长目标（从中心淡入）
                          Expanded(
                            child: Center(
                              child:
                                  (mounted &&
                                      state.timeDialogDisplayState !=
                                          GoalBannerDisplayState.hidden)
                                  ? GoalBannerAnimator(
                                      displayState:
                                          state.timeDialogDisplayState,
                                      direction: EntryDirection.fromCenter,
                                      child: Builder(
                                        builder: (ctx2) {
                                          debugPrint(
                                            '🔲 [DialogLayer] 时长Banner: visible，开始构建',
                                          );
                                          return _buildDurationGoalBanner(
                                            state,
                                          );
                                        },
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                          // 右 1/3 槽位 → 卡路里目标（从右侧滑入）
                          Expanded(
                            child: Center(
                              child:
                                  (mounted &&
                                      state.energyDialogDisplayState !=
                                          GoalBannerDisplayState.hidden)
                                  ? GoalBannerAnimator(
                                      displayState:
                                          state.energyDialogDisplayState,
                                      direction: EntryDirection.fromRight,
                                      child: Builder(
                                        builder: (ctx2) {
                                          debugPrint(
                                            '🔲 [DialogLayer] 卡路里Banner: visible，开始构建',
                                          );
                                          return _buildBurnGoalBanner(state);
                                        },
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // 任务5：设备运行中阻塞层（覆盖全屏，引导用户先停止设备）
                if (state.isDeviceRunningDetected)
                  _buildDeviceRunningBlocker(tr, state),
              ],
        ),
      ),
    );
  }

  // ==================== 设备运行阻塞层（任务5） ====================

  /// 设备运行中阻塞层：进入界面时若检测到设备正在运行，覆盖全屏引导用户先停止。
  ///
  /// - 半透明黑色遮罩 + 居中提示卡片
  /// - 「发送停止指令」按钮：调用 stopSportImmediate 立即下发停止指令
  /// - 「已停止，重新检测」按钮：重新调用 checkDeviceRunningOnEntry
  /// - 数据流回落（isDeviceRunningDetected=false）时本层自动消失
  Widget _buildDeviceRunningBlocker(
    AppLocalizations tr,
    QuickStartState state,
  ) {
    final notifier = ref.read(quickStartProvider.notifier);
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.75),
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 300, vertical: 30),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 48,
                color: const Color(0xFFE03B3B),
              ),
              const SizedBox(height: 12),
              Text(
                tr.deviceInMotionPleaseStop,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // 发送停止指令按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE03B3B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    notifier.stopAndClear();
                    print('🔍 [DeviceCheck] 用户点击发送停止指令');
                  },
                  child: const Text(
                    '发送停止指令',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // 重新检测按钮
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF000000),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Color(0xFFBBBBBB)),
                  ),
                  onPressed: () {
                    notifier.checkDeviceRunningOnEntry();
                    print('🔍 [DeviceCheck] 用户点击重新检测');
                  },
                  child: const Text('已停止，重新检测'),
                ),
              ),
            ],
          ),
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
    late EdgeInsets padding;
    late double containerWidth;

    // 按设备类型精确构建数据模型（只传旧版对应字段，其余置 null 由组件自动过滤）
    SportDataModel buildDataModel() {
      switch (widget.deviceType) {
        case FtmsDeviceType.indoorBike:
          // 单车: 时间 / 距离 / 卡路里 / 速度 / 踏频
          return SportDataModel(
            elapsedSeconds: state.realSportTime,
            distance: state.sportDistance,
            energy: state.sportEnergy.toInt(),
            speed: state.sportSpeed,
            cadence: state.sportCadence.toInt(),
          );
        case FtmsDeviceType.treadmill:
          // 跑步机: 时间 / 距离 / 卡路里 / 速度 / 心率
          return SportDataModel(
            elapsedSeconds: state.realSportTime,
            distance: state.sportDistance,
            energy: state.sportEnergy.toInt(),
            speed: state.sportSpeed,
            heartRate: state.sportHeartRate,
          );
        case FtmsDeviceType.crossTrainer:
          // 椭圆机: 时间 / 距离 / 卡路里 / 速度 / 踏频
          return SportDataModel(
            elapsedSeconds: state.realSportTime,
            distance: state.sportDistance,
            energy: state.sportEnergy.toInt(),
            speed: state.sportSpeed,
            cadence: state.sportCadence.toInt(),
          );
        case FtmsDeviceType.rower:
          // 划船机: 时间 / 距离 / 卡路里 / 桨数 / 桨频（不显示速度、心率）
          return SportDataModel(
            elapsedSeconds: state.realSportTime,
            distance: state.sportDistance,
            energy: state.sportEnergy.toInt(),
            strokeCount: state.sportStrokeCount.toInt(),
            strokeRate: state.sportStrokeRate.toInt(),
          );
        case FtmsDeviceType.strengthStation:
          return const SportDataModel();
      }
    }

    switch (widget.deviceType) {
      case FtmsDeviceType.indoorBike:
      case FtmsDeviceType.rower:
        padding = EdgeInsets.only(top: 30.h, right: 70.w, left: 60.w);
        containerWidth = screenWidth;
        break;
      case FtmsDeviceType.treadmill:
        padding = EdgeInsets.only(top: 30.h, right: 70.w, left: 60.w);
        containerWidth = screenWidth;
        break;
      case FtmsDeviceType.crossTrainer:
        padding = EdgeInsets.only(top: 30.h, right: 70.w, left: 60.w);
        containerWidth = screenWidth;
        break;

      case FtmsDeviceType.strengthStation:
        return [Container()];
    }

    return [
      Padding(
        padding: padding,
        child: Container(
          // width: containerWidth - 100,
          height: 200.h + kTopDataBarBottomPadding.h,
          padding: EdgeInsets.only(bottom: kTopDataBarBottomPadding.h),
          child: SportDataDisplay(
            layout: DataDisplayLayout.horizontal,
            deviceType: widget.deviceType,
            data: buildDataModel(),
          ),
        ),
      ),
    ];
  }

  // ==================== 控制按钮层 ====================

  Widget _buildControllerButtonByDevice(QuickStartState state) {
    // 力量站无控制按钮（与原版一致）
    if (widget.deviceType == FtmsDeviceType.strengthStation) {
      return Container();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final notifier = ref.read(quickStartProvider.notifier);

    // 按设备类型选择顶部间距常量（保留原版间距以维持终端观感一致）
    final double topPadding = (widget.deviceType == FtmsDeviceType.treadmill)
        ? kControllerTopPaddingTreadmill
        : kControllerTopPaddingBike;

    return Container(
      margin: EdgeInsets.only(
        top: 300.h,
        left: 40.w,
        right: 40.w,
        bottom: kControllerBottomPadding.h,
      ),
      width: screenWidth,
      // 复用 SportControlPanel（full 模式内部使用 LevelControlButton 渲染 5 档按钮）：
      // - 根据 deviceType 自动裁剪不支持的按钮组（速度 / 坡度 / 阻力）
      // - hasInclinationSupport 控制坡度按钮组是否展示
      child: SportControlPanel(
        style: ControlPanelStyle.full,
        deviceType: widget.deviceType,
        data: DeviceControlData(
          speedValue: state.sportSpeedButton,
          inclineValue: state.sportInclinationButton,
          resistanceValue: state.sportResistanceButton,
          speedPresets: state.buttonSpeedList,
          inclinePresets: state.buttonInclinationList,
          resistancePresets: state.buttonResistanceList,
          hasInclinationSupport: state.hasInclinationSupport,
          // 三维度设备能力判定（0x2AD4/0x2AD5/0x2AD6，max<=min 时隐藏按钮组）
          hasSpeedSupport: state.hasSpeedSupport,
          hasResistanceSupport: state.hasResistanceSupport,
        ),
        callbacks: DeviceControlCallbacks(
          // ===== 速度回调（跑步机） =====
          onSpeedAdd: notifier.speedAdd,
          onSpeedDown: notifier.speedDown,
          // 速度长按连续加减：Timer.periodic 500ms，步长 1.0（实现于 Notifier）
          // 长按功能规则：仅速度支持长按（步进 0.1 需快速调整）
          onSpeedLongPressAdd: notifier.speedLongPressAdd,
          onSpeedLongPressDown: notifier.speedLongPressDown,
          onSpeedPreset: (v) => notifier.numberButton(v, 0),

          // ===== 坡度回调（仅跑步机；无长按） =====
          // 注意：Notifier 方法名为 inclinationAdd/inclinationDown（与 mixin 的 inclineAdd/inclineDown 不同），
          // 这里通过方法引用直接绑定到 Notifier 的实际实现上。
          onInclineAdd: notifier.inclinationAdd,
          onInclineDown: notifier.inclinationDown,
          onInclinePreset: (v) => notifier.numberButton(v, 1),

          // ===== 阻力回调（单车 / 椭圆机 / 划船机；无长按） =====
          onResistanceAdd: notifier.resistanceAdd,
          onResistanceDown: notifier.resistanceDown,
          onResistancePreset: (v) => notifier.numberButton(v, 2),

          // ===== 长按结束（仅速度长按使用） =====
          onLongPressEnd: notifier.longPressEnd,
        ),
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
                  print('👆 [Button] 点击: 播放按钮');
                  // 检查设备是否已在运动中
                  if (state.isPlaying || state.sportSpeed > 0) {
                    print(
                      '👆 [Button] 播放被拦截: 设备运动中(isPlaying=${state.isPlaying}, speed=${state.sportSpeed})',
                    );
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
      right: 40.w,
      top: 80.h,
      child: InkWell(
        onTap: () {
          print(
            '👆 [Button] 点击: 返回按钮(isPlaying=${state.isPlaying}, speed=${state.sportSpeed})',
          );
          final notifier = ref.read(quickStartProvider.notifier);
          // 先停后退：若设备正在运行，立即下发停止指令并清零本地数据
          // （dispatchImmediate 不走 debounce，确保 pop 前停止指令必达设备）
          if (state.isPlaying || state.sportSpeed > 0) {
            notifier.stopAndClear();
          } else {
            notifier.clearData();
          }
          // 退出页面（停止指令已即时下发，无需延迟）
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
              // ✅ 先切状态（乐观更新），等价旧项目"先 setState 再 stop"，
              // 让按钮立即切回播放图标。
              // 使用已缓存的 _quickStartNotifier 字段，避免异步/卸载场景下 ref 失效。
              _quickStartNotifier.updateMusicPlaying(false);
              print('[Music] stop');
              // stop 不 await（与旧项目一致），避免阻塞 UI。
              _audioPlayer.stop();
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
              // ✅ 先切状态（乐观更新），等价旧项目"play() 后立即 setState"，
              // 让按钮立即变成暂停图标；避免 await play() 在 Android 首次播放
              // 因 MediaCodec 初始化耗时导致按钮迟迟不切换。
              _quickStartNotifier.updateMusicPlaying(true);
              print('[Music] play start');
              try {
                final index = _generateRandomNumber();
                final songs = ExerciseSongLibrary.forType(widget.deviceType);
                await _audioPlayer.setUrl(songs[index]);
                // 页面可能在 setUrl 期间被退出（用户点返回），unmount 后不再操作 player。
                if (!mounted) return;
                // play 不 await（fire-and-forget），与旧项目一致，避免阻塞状态切换。
                _audioPlayer.play();
              } catch (e) {
                print('[Music] play error: $e');
                // 加载/播放失败，回退按钮状态。
                if (mounted) {
                  _quickStartNotifier.updateMusicPlaying(false);
                }
              }
            },
            child: Container(
              height: 25.sp,
              child: Image.asset(
                "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/music_play.png",
              ),
            ),
          );
  }

  // ==================== 目标达成弹窗 UI（下方胶囊 Banner 并排） ====================

  /// 通用胶囊 Banner 封装（3 个目标弹窗共用）。
  ///
  /// - [backgroundAsset]  : 胶囊背景图资源路径（quick_distance/during/burn.png）
  /// - [title]            : 小字标题（你的运动距离 / 你的运动时长 / 你已消耗热量）
  /// - [valueText]        : 大字号数值（数据异常时传"——"，交给外层 fallback）
  /// - [unitText]         : 单位（KM / MIN / KCAL）
  /// - [status]           : 当前数据状态，决定 UI 文案/颜色
  /// - [bannerTag]        : 调试日志分类标签（"DIST"/"TIME"/"ENERGY"）
  Widget _buildGoalBanner({
    required String backgroundAsset,
    required String title,
    required String valueText,
    required String unitText,
    required _BannerDataStatus status,
    required String bannerTag,
  }) {
    // —— 尺寸严格按你要求写死：宽 300.w × 高 200.h，不再响应式缩放
    final bannerWidth = 160.w;
    final bannerHeight = 250.h;
    // 内部 padding/字号：按 300×200 适配后写死
    final textLeftPadding = 60.w; // 左侧插画占位后文字起点
    final rightPadding = 20.w;
    final vertPadding = 8.h;
    final titleFontSize = 16.sp;
    final valueFontSize = 13.sp;
    final unitFontSize = 14.sp;
    final tipFontSize = 10.sp;
    final titleGap = 4.h;
    final valueGap = 6.w;
    final tipGap = 6.h;

    // 给每个 tag 分配一个「纯色调试背景」，资源图加载失败或透明时能直接看到胶囊形状
    const Map<String, Color> kTagDebugColor = {
      'DIST': Color(0xFF7A3CB8), // 紫 → 距离
      'TIME': Color(0xFF2E6EFF), // 蓝 → 时长
      'ENERGY': Color(0xFFE03B3B), // 红 → 卡路里
    };
    final tagDebugColor =
        kTagDebugColor[bannerTag] ?? Colors.teal.withValues(alpha: 0.6);

    debugPrint(
      '🧱 [Banner-$bannerTag] build → size=${bannerWidth.toInt()}×${bannerHeight.toInt()}, '
      'status=$status, title="$title", value="$valueText", unit="$unitText"',
    );

    // 根据状态决定最终呈现的标题 / 数值（用默认值声明，避开 Dart 穷举分析的「非空赋值」告警）
    var finalTitle = title;
    var finalValue = valueText;
    var finalUnit = unitText;
    var titleColor = Colors.white.withValues(alpha: 0.92);
    var valueColor = Colors.white;
    var bgFallbackColor = Colors.white.withValues(alpha: 0.1);

    switch (status) {
      case _BannerDataStatus.ready:
        finalTitle = title;
        finalValue = valueText;
        finalUnit = unitText;
        titleColor = Colors.white.withValues(alpha: 0.92);
        valueColor = Colors.white;
        // 兜底色 alpha 降低，不会覆盖设计图
        bgFallbackColor = tagDebugColor.withValues(alpha: 0.18);
        break;
      case _BannerDataStatus.loading:
        // 数据尚未就绪（常见：首次点击后 Riverpod 还在同步 rebuild，或者赋值 ≤ 0）
        finalTitle = '数据准备中…';
        finalValue = '—';
        finalUnit = '';
        titleColor = Colors.white.withValues(alpha: 0.86);
        valueColor = Colors.white.withValues(alpha: 0.92);
        bgFallbackColor = Colors.yellow.withValues(alpha: 0.30);
        break;
      case _BannerDataStatus.error:
        finalTitle = '数据异常，请重试';
        finalValue = 'ERR';
        finalUnit = '';
        titleColor = Colors.white.withValues(alpha: 0.92);
        valueColor = const Color.fromARGB(255, 255, 128, 128);
        bgFallbackColor = Colors.red.withValues(alpha: 0.30);
        break;
    }

    // 动画效果由外层 GoalBannerAnimator 负责，此处直接返回内容
    return ClipRRect(
      // 胶囊圆角：两端半圆，等于 bannerHeight / 2
      // borderRadius: BorderRadius.circular(bannerHeight / 2),
      child: Container(
        width: bannerWidth,
        height: bannerHeight,
        // 背景图 + 纯色兜底层 + 细边框：三层叠加
        decoration: BoxDecoration(
          color: bgFallbackColor, // 最底层：兜底色
          // border: Border.all(
          //   // 边框缩小为 1，alpha 降低避免抢图片视觉
          //   color: tagDebugColor.withValues(alpha: 0.22),
          //   width: 1,
          // ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withValues(alpha: 0.30),
          //     blurRadius: 16.r,
          //     spreadRadius: 2.r,
          //     offset: Offset(0, 6.r),
          //   ),
          // ],
          image: DecorationImage(
            image: AssetImage(backgroundAsset),
            fit: BoxFit.fill,
            onError: (e, s) {
              debugPrint(
                '🖼️ [Banner-$bannerTag] 资源加载失败：$backgroundAsset, error=$e',
              );
            },
            // 叠一层极淡的 tag 色，统一观感，不影响原图
            colorFilter: ColorFilter.mode(
              tagDebugColor.withValues(alpha: 0.08),
              BlendMode.srcATop,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: textLeftPadding,
            right: rightPadding,
            top: vertPadding,
            bottom: vertPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 第 1 行：标题小字
              Text(
                finalTitle,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
              SizedBox(height: titleGap),
              // 第 2 行：大字号数值 + 单位（自适应紧贴数值，不做 Expanded 撑满）
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Flexible(
                    child: Text(
                      finalValue,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: valueFontSize,
                        fontWeight: FontWeight.bold,
                        color: valueColor,
                        fontFamily: AppFonts.bebas,
                        height: 1.05,
                      ),
                    ),
                  ),
                  if (finalUnit.isNotEmpty) ...[
                    SizedBox(width: valueGap),
                    Text(
                      finalUnit,
                      style: TextStyle(
                        fontSize: unitFontSize,
                        fontWeight: FontWeight.w700,
                        color: valueColor.withValues(alpha: 0.9),
                        fontFamily: AppFonts.bebas,
                      ),
                    ),
                  ],
                ],
              ),
              // 第 3 行：非就绪状态提示（只在 loading/error 时展示）
              if (status != _BannerDataStatus.ready) ...[
                SizedBox(height: tipGap),
                Text(
                  status == _BannerDataStatus.loading
                      ? '请稍候，数据即将就绪…'
                      : '点击按钮重新触发即可',
                  style: TextStyle(
                    fontSize: tipFontSize,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 距离目标 Banner（左位置，紫胶囊 + 跑鞋）。
  ///
  /// 距离单位固定为 KM（与顶部数据栏保持一致）。
  Widget _buildDistanceGoalBanner(QuickStartState state) {
    const tag = 'DIST';
    _BannerDataStatus status = _BannerDataStatus.ready;
    String formatted = '';

    try {
      // ① 合法性判断：距离必须 > 0，否则判定为 Notifier 赋值尚未落到 Widget
      final num km = state.currentDistanceGoalKm;
      if (!(km > 0)) {
        status = _BannerDataStatus.loading;
        debugPrint(
          '⚠️ [Banner-$tag] 数据未就绪：currentDistanceGoalKm=$km '
          '(displayState=${state.distanceDialogDisplayState})',
        );
      } else {
        // ② 固定 KM 单位展示（不做英里换算）
        final num displayValue = km;
        // ③ 距离去零格式化：0.5→"0.5"，1→"1"，30→"30"，与 XML 表现一致
        formatted = (displayValue == displayValue.roundToDouble())
            ? displayValue.toInt().toString()
            : displayValue.toStringAsFixed(1);
      }
    } catch (e, s) {
      // ④ 格式化发生任何异常（类型转换/toString 异常），统一进入 error 状态，防止崩溃+空白
      status = _BannerDataStatus.error;
      debugPrint('❌ [Banner-$tag] 格式化异常：$e\n$s');
    }

    return _buildGoalBanner(
      backgroundAsset: 'images/newUIScreen/device_icons/quick_distance.png',
      title: '运动距离',
      valueText: formatted,
      // 单位固定 KM
      unitText: 'KM',
      status: status,
      bannerTag: tag,
    );
  }

  /// 时长目标 Banner（中位置，蓝胶囊 + 跑步女生）
  Widget _buildDurationGoalBanner(QuickStartState state) {
    const tag = 'TIME';
    _BannerDataStatus status = _BannerDataStatus.ready;
    String formatted = '';

    try {
      final seconds = state.currentTimeGoalSec;
      final minutes = seconds ~/ 60;
      // 必须分钟 > 0，否则 loading（避免 Notifier 还没赋值就显示 0 MIN）
      if (minutes <= 0) {
        status = _BannerDataStatus.loading;
        debugPrint(
          '⚠️ [Banner-$tag] 数据未就绪：seconds=$seconds, minutes=$minutes '
          '(displayState=${state.timeDialogDisplayState})',
        );
      } else {
        formatted = '$minutes';
      }
    } catch (e, s) {
      status = _BannerDataStatus.error;
      debugPrint('❌ [Banner-$tag] 格式化异常：$e\n$s');
    }

    return _buildGoalBanner(
      backgroundAsset: 'images/newUIScreen/device_icons/quick_during.png',
      title: '运动时长',
      valueText: formatted,
      unitText: 'MIN',
      status: status,
      bannerTag: tag,
    );
  }

  /// 卡路里目标 Banner（右位置，红胶囊 + 体重秤）
  Widget _buildBurnGoalBanner(QuickStartState state) {
    const tag = 'ENERGY';
    _BannerDataStatus status = _BannerDataStatus.ready;
    String formatted = '';

    try {
      final kcal = state.currentEnergyGoalKcal;
      if (!(kcal > 0)) {
        status = _BannerDataStatus.loading;
        debugPrint(
          '⚠️ [Banner-$tag] 数据未就绪：currentEnergyGoalKcal=$kcal '
          '(displayState=${state.energyDialogDisplayState})',
        );
      } else {
        formatted = kcal.toStringAsFixed(0);
      }
    } catch (e, s) {
      status = _BannerDataStatus.error;
      debugPrint('❌ [Banner-$tag] 格式化异常：$e\n$s');
    }

    return _buildGoalBanner(
      backgroundAsset: 'images/newUIScreen/device_icons/quick_burn.png',
      title: '运动消耗',
      valueText: formatted,
      unitText: 'KCAL',
      status: status,
      bannerTag: tag,
    );
  }
}

/// Banner 数据展示状态（区分「加载中 / 就绪 / 异常」，避免空白背景无任何提示）。
enum _BannerDataStatus { loading, ready, error }

/// ==================== 控制按钮间距常量（集中调节入口） ====================
/// 注：宽度/高度缩放系数与可用高度比例已迁移至 LevelControlButton 内部私有常量，
/// 此处仅保留页面外层布局所需的间距常量。

/// 控制按钮距顶部的额外间距（避免遮挡顶部数据栏）。
const double kControllerTopPaddingBike = 200.0;
const double kControllerTopPaddingTreadmill = 200.0;

/// 控制按钮距底部的额外间距（避免遮挡实时图表）。
const double kControllerBottomPadding = 70.0;

/// 顶部数据栏底部额外安全间隙。
const double kTopDataBarBottomPadding = 25.0;
