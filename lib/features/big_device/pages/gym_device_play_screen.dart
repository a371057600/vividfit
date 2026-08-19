import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../core/ftms/ftms_device_type.dart';
import '../../../l10n/app_localizations.dart';
import '../models/sport_data_model.dart';
import '../notifiers/gym_course_play_notifier.dart';
import '../states/gym_course_play_state.dart';
import '../widgets/pill_control_button.dart';
import '../widgets/sport_data_display.dart';
import '../widgets/triple_ring_progress.dart';

/// 大设备运动播放页 (对应原版 big_device_play_screen.dart)
///
/// 支持 4 种设备类型:
/// - [FtmsDeviceType.indoorBike] 动感单车
/// - [FtmsDeviceType.treadmill] 跑步机
/// - [FtmsDeviceType.crossTrainer] 椭圆机
/// - [FtmsDeviceType.rower] 划船机
///
/// 三态: loading / playing / finished
/// 所有尺寸基于屏幕宽高占比计算（不使用ScreenUtil）
class GymDevicePlayScreen extends ConsumerStatefulWidget {
  final int? courseId;
  final FtmsDeviceType deviceType;

  const GymDevicePlayScreen({
    super.key,
    required this.courseId,
    required this.deviceType,
  });

  @override
  ConsumerState<GymDevicePlayScreen> createState() =>
      _GymDevicePlayScreenState();
}

class _GymDevicePlayScreenState extends ConsumerState<GymDevicePlayScreen> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  String _tr(String en) {
    const map = {
      'Sport Time': 'finishedSportTime',
      'Total Distance': 'finishedTotalDistance',
      'Total Calories': 'finishedTotalCalories',
      'Pace': 'finishedPace',
      'Avg Cadence': 'finishedAvgCadence',
      'Max Cadence': 'finishedMaxCadence',
      'Max Heart Rate': 'finishedMaxHeartRate',
      'Total Cadence': 'finishedTotalCadence',
      'Rest Time': 'finishedRestTime',
      'Completion': 'completion',
      'Stability': 'stability',
      'Pedaling Eff.': 'pedalingEff',
      'Coherence': 'cadence',
      'Slope Control': 'pedalingEff',
      'Exercise Coherence': 'cadence',
      'Endurance': 'cadence',
      'Exercise Eff.': 'pedalingEff',
      'Course Over': 'courseOver',
    };
    final key = map[en];
    if (key == null) return en;
    switch (key) {
      case 'finishedSportTime':
        return l10n.finishedSportTime;
      case 'finishedTotalDistance':
        return l10n.finishedTotalDistance;
      case 'finishedTotalCalories':
        return l10n.finishedTotalCalories;
      case 'finishedPace':
        return l10n.finishedPace;
      case 'finishedAvgCadence':
        return l10n.finishedAvgCadence;
      case 'finishedMaxCadence':
        return l10n.finishedMaxCadence;
      case 'finishedMaxHeartRate':
        return l10n.finishedMaxHeartRate;
      case 'finishedTotalCadence':
        return l10n.finishedTotalCadence;
      case 'finishedRestTime':
        return l10n.finishedRestTime;
      case 'completion':
        return l10n.completion;
      case 'stability':
        return l10n.stability;
      case 'pedalingEff':
        return l10n.pedalingEff;
      case 'cadence':
        return l10n.cadence;
      case 'courseOver':
        return l10n.courseOver;
      default:
        return en;
    }
  }

  String _stageTitle(int index) {
    switch (index) {
      case 0:
        return l10n.easyAdaptation;
      case 1:
        return l10n.moderateImprovement;
      case 2:
        return l10n.moderateChallenge;
      case 3:
        return l10n.intenseLoad;
      case 4:
        return l10n.extremeBreakthrough;
      default:
        return '';
    }
  }

  /// 提前缓存 Notifier 引用，避免 dispose 阶段 ref 失效
  late final GymCoursePlayNotifier _coursePlayNotifier;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    // 缓存 Notifier 引用
    _coursePlayNotifier = ref.read(gymCoursePlayProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _coursePlayNotifier.resetToLoading();
      _coursePlayNotifier.initCourseContext(
        courseId: widget.courseId,
        deviceType: widget.deviceType,
      );
    });
  }

  @override
  void dispose() {
    _coursePlayNotifier.cleanupOnExit();
    super.dispose();
  }

  final List<String> _stageIcons = const [
    'images/newUIScreen/bigScreenAnimation/icons/stage0.png',
    'images/newUIScreen/bigScreenAnimation/icons/stage1.png',
    'images/newUIScreen/bigScreenAnimation/icons/stage2.png',
    'images/newUIScreen/bigScreenAnimation/icons/stage3.png',
    'images/newUIScreen/bigScreenAnimation/icons/stage4.png',
  ];

  final List<String> _ratingLevelIcons = const [
    'images/newUIScreen/bigScreenAnimation/icons/leveContainer0.png',
    'images/newUIScreen/bigScreenAnimation/icons/leveContainer1.png',
    'images/newUIScreen/bigScreenAnimation/icons/leveContainer2.png',
    'images/newUIScreen/bigScreenAnimation/icons/leveContainer3.png',
    'images/newUIScreen/bigScreenAnimation/icons/leveContainer4.png',
    'images/newUIScreen/bigScreenAnimation/icons/leveContainer5.png',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(gymCoursePlayProvider);
    final size = MediaQuery.of(context).size;
    final sw = size.width;
    final sh = size.height;

    // 🔴 R5：蓝牙断链 → 立即退出课程流程，回到主界面（不做任何重连/结算）
    ref.listen<bool>(
      gymCoursePlayProvider.select((s) => s.isDeviceConnectionLost),
      (previous, next) {
        if (next && previous != next) {
          debugPrint('❌ [PlayScreen] 检测到蓝牙断链标记 → 导航退出到主界面 /home-shell');
          context.go('/home-shell');
        }
      },
    );

    return PopScope(
      canPop: state.screenStatus != GymPlayScreenStatus.playing,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          debugPrint('📤 [PlayScreen] PopScope popped');
          ref.read(gymCoursePlayProvider.notifier).exitToDetail();
        } else {
          // 🔴 playing 拦截：立刻 manualFinish（停音频+直接结算，不弹确认）
          debugPrint(
            '📤 [PlayScreen] System back (playing拦截) → manualFinish（立刻停音频+直接结算）',
          );
          ref.read(gymCoursePlayProvider.notifier).manualFinish();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _buildBody(state, l10n, sw, sh),
      ),
    );
  }

  Widget _buildBody(
    GymCoursePlayState state,
    AppLocalizations l10n,
    double sw,
    double sh,
  ) {
    if (state.screenStatus == GymPlayScreenStatus.loading) {
      return _buildLoadingState(l10n, sw, sh);
    }
    if (state.isStopScreen) {
      return _buildFinishedState(state, sw, sh);
    }
    return Stack(children: [_buildPlayingState(state, sw, sh)]);
  }

  // ══════════════════════════════════════════════════════════
  // Loading 态
  // ══════════════════════════════════════════════════════════
  Widget _buildLoadingState(AppLocalizations l10n, double sw, double sh) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: sh * 0.025),
          GestureDetector(
            onTap: () {
              if (context.canPop()) context.pop();
            },
            child: Container(
              decoration: BoxDecoration(
                color: FitTheme.buttonColor,
                borderRadius: BorderRadius.circular(sh * 0.04),
              ),
              padding: EdgeInsets.all(sh * 0.02),
              child: Text(
                l10n.back,
                style: TextStyle(color: Colors.white, fontSize: sh * 0.02),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // Playing 态 - 去除ScreenUtil，全比例尺寸
  // Stack 子节点顺序（Z轴从底到顶）：
  //   1. 背景层（双层Image：0.png底层fill + 动画帧上层contain）
  //   2. 顶部蒙版
  //   3. 底部蒙版
  //   4. 顶部数据条
  //   5. 左侧课程信息
  //   6. 进度条
  //   7. 红色箭头
  //   8. 返回按钮（右上）
  //   9. 控制按钮（阻力/速度/坡度，右侧，BPM下方）
  //  10. 右侧动作列表
  //  11. 中央Play按钮覆盖层
  // ══════════════════════════════════════════════════════════
  Widget _buildPlayingState(GymCoursePlayState state, double sw, double sh) {
    return SizedBox.expand(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildBackgroundLayer(state, sw, sh),
          _buildTopMask(sh, sw),
          _buildBottomMask(sh, sw),
          _buildTopDataBar(state, sw, sh),
          _buildLeftCourseInfo(state, sw, sh),
          _buildProgressBar(state, sw, sh),
          _buildProgressArrow(state, sw, sh),

          ..._buildControlButtons(state, sw, sh),
          _buildRightActionList(state, sw, sh),
          if (state.showPlayButton) _buildCenterPlayButton(sw, sh),
          _buildBackButton(sw, sh),
        ],
      ),
    );
  }

  // ── 1. 背景层（双层结构） ──
  Widget _buildBackgroundLayer(GymCoursePlayState state, double sw, double sh) {
    final actions = state.courseActions;
    if (actions.isEmpty) {
      return SizedBox.expand(child: Container(color: const Color(0xFF121212)));
    }
    final idx = state.playIndex.clamp(0, actions.length - 1);
    final cur = actions[idx];
    final isRest = cur.isRestStage;
    final frameIdx = state.imagePlayIndex;

    final bgMargin = sh * 0.12;

    // 观测日志：仅在 debug 模式下打印

    if (isRest) {
      return Positioned(
        top: bgMargin,
        bottom: bgMargin,
        left: 0,
        right: 0,
        child: Image.file(
          File('${state.rootImagePath}${cur.imageName}/$frameIdx.png'),
          fit: BoxFit.contain,
          gaplessPlayback: true,
          errorBuilder: (_, _, _) => _buildImageFallback(cur, isRest, sw, sh),
        ),
      );
    }

    return Positioned(
      top: bgMargin,
      bottom: bgMargin,
      left: 0,
      right: 0,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              File('${state.rootImagePath}${cur.imageName}/0.png'),
              fit: BoxFit.fill,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) =>
                  Container(color: const Color(0xFF121212)),
            ),
          ),
          Positioned.fill(
            child: Image.file(
              File('${state.rootImagePath}${cur.imageName}/$frameIdx.png'),
              fit: BoxFit.contain,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageFallback(
    ActionItemState cur,
    bool isRest,
    double sw,
    double sh,
  ) {
    final titleEn = isRest ? 'REST' : cur.name.toUpperCase();
    final titleZh = isRest ? '休息调整' : _actionNameToZh(cur.name);
    return Container(
      color: const Color(0xFF121212),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              color: Colors.white24,
              size: sh * 0.05,
            ),
            SizedBox(height: sh * 0.015),
            Text(
              titleEn,
              style: TextStyle(
                color: Colors.white,
                fontSize: sh * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: sh * 0.008),
            Text(
              titleZh,
              style: TextStyle(color: Colors.white70, fontSize: sh * 0.02),
            ),
          ],
        ),
      ),
    );
  }

  String _actionNameToZh(String name) {
    final map = {
      'warmup': '热身动作准备',
      'warm up': '热身动作准备',
      'jog': '慢跑',
      'run': '快跑',
      'sprint': '冲刺',
      'fast run': '快跑',
      'slow run': '慢跑',
      'relax': '放松',
      'cooldown': '放松调整',
      'cool down': '放松调整',
      'rest': '休息调整',
    };
    return map[name.toLowerCase()] ?? name;
  }

  // ── 2. 顶部蒙版 ──
  Widget _buildTopMask(double sh, double sw) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: sh * 0.20,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xB1000000), Color(0xB1000000), Colors.transparent],
          ),
        ),
      ),
    );
  }

  // ── 3. 底部蒙版 ──
  Widget _buildBottomMask(double sh, double sw) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        child: Container(
          height: sh * 0.25,
          width: sw,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Color(0xB1000000),
                Color(0xB1000000),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── 4. 顶部数据条 ──
  Widget _buildTopDataBar(GymCoursePlayState state, double sw, double sh) {
    final deviceType = state.deviceType;

    // 🔴 距离单位修正：state.sportDistance 已是 km（Notifier _onDataReceived
    // 已做 m→km 换算），但 SportDataDisplay 组件契约是"接收原始米"，
    // 内部会再 ÷1000 换算 km——直接传 km 会被双重换算缩小 1000 倍。
    // 此处 ×1000 还原成米，由组件统一换算展示。
    final distanceMeters =
        (double.tryParse(state.sportDistance) ?? 0.0) * 1000.0;

    // 按设备类型精确构建数据模型（只传对应5个字段，其余置 null）
    SportDataModel buildDataModel() {
      switch (deviceType) {
        case FtmsDeviceType.indoorBike:
          // 单车: 时间 / 距离 / 卡路里 / 速度 / 踏频
          return SportDataModel(
            elapsedSeconds: _parseTimeToSeconds(state.sportTime),
            distance: distanceMeters,
            energy: double.tryParse(state.sportCalories)?.round(),
            speed: state.sportDeviceSpeed,
            cadence: int.tryParse(state.sportCadence),
          );
        case FtmsDeviceType.treadmill:
          // 跑步机: 时间 / 距离 / 卡路里 / 速度 / 心率
          return SportDataModel(
            elapsedSeconds: _parseTimeToSeconds(state.sportTime),
            distance: distanceMeters,
            energy: double.tryParse(state.sportCalories)?.round(),
            speed: state.sportDeviceSpeed,
            heartRate: int.tryParse(state.sportHeartRate),
          );
        case FtmsDeviceType.crossTrainer:
          // 椭圆机: 时间 / 距离 / 卡路里 / 速度 / 踏频
          return SportDataModel(
            elapsedSeconds: _parseTimeToSeconds(state.sportTime),
            distance: distanceMeters,
            energy: double.tryParse(state.sportCalories)?.round(),
            speed: state.sportDeviceSpeed,
            cadence: int.tryParse(state.sportCadence),
          );
        case FtmsDeviceType.rower:
          // 划船机: 时间 / 距离 / 卡路里 / 桨数 / 桨频
          return SportDataModel(
            elapsedSeconds: _parseTimeToSeconds(state.sportTime),
            distance: distanceMeters,
            energy: double.tryParse(state.sportCalories)?.round(),
            strokeCount: int.tryParse(state.sportStrokeCount),
            strokeRate: int.tryParse(state.sportStrokeRate),
          );
        case FtmsDeviceType.strengthStation:
          return const SportDataModel();
      }
    }

    return Container(
      margin: EdgeInsets.only(left: 100, top: sh * 0.03, right: 100),
      height: sh * 0.12,
      child: SportDataDisplay(
        layout: DataDisplayLayout.compact,
        deviceType: deviceType,
        data: buildDataModel(),
      ),
    );
  }

  /// 将 "MM:SS" 格式的时间字符串解析为秒数。
  /// 用于把 state.sportTime 转换为 SportDataModel.elapsedSeconds。
  int? _parseTimeToSeconds(String? time) {
    if (time == null || time.isEmpty) return null;
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final m = int.tryParse(parts[0]);
    final s = int.tryParse(parts[1]);
    if (m == null || s == null) return null;
    return m * 60 + s;
  }

  // ── 5. 左侧课程信息 ──
  Widget _buildLeftCourseInfo(GymCoursePlayState state, double sw, double sh) {
    final actions = state.courseActions;
    final currentAction = actions.isNotEmpty
        ? actions[state.playIndex.clamp(0, actions.length - 1)]
        : null;
    final panelW = sw * 0.20;
    final subFs = sh * 0.026;

    return Positioned(
      top: 25,
      left: sw * 0.02,
      child: SizedBox(
        width: panelW,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: panelW,
              child: _AutoScrollText(
                text: state.courseTitle,
                style: TextStyle(
                  fontSize: sh * 0.048,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.1,
                ),
                parentWidth: panelW,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  state.difficulty,
                  style: TextStyle(
                    fontSize: subFs,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                SizedBox(width: 20),
                _buildStarRating(state.level, subFs),
              ],
            ),
            SizedBox(height: 20),
            // 当前动作 + 时间
            SizedBox(
              width: panelW,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  SizedBox(
                    width: panelW * 0.58,
                    child: Text(
                      currentAction?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: subFs,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ),
                  Text(
                    _formatCurrentDuration(state),
                    style: TextStyle(
                      fontSize: subFs,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // 当前组数
            SizedBox(
              width: panelW,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  SizedBox(
                    width: panelW * 0.58,
                    child: Text(
                      '当前组数',
                      style: TextStyle(
                        fontSize: subFs,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ),
                  Text(
                    '${state.playIndex + 1}/${actions.length}',
                    style: TextStyle(
                      fontSize: subFs,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(int level, double starSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < level ? Icons.star : Icons.star_border,
          color: Colors.yellow,
          size: starSize,
        );
      }),
    );
  }

  String _formatCurrentDuration(GymCoursePlayState state) {
    final seconds = state.currentDuration - state.playIndexDuration;
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // ── 6. 进度条（静态波浪，色块高度一致+位置落差，生成后永恒不变） ──
  Widget _buildProgressBar(GymCoursePlayState state, double sw, double sh) {
    final barBottom = sh * 0.07;
    final barH = sh * 0.055;
    return Positioned(
      bottom: barBottom,
      left: sw * 0.02,
      child: _WavePositionProgressBar(
        segments: state.progressSegments,
        actions: state.courseActions,
        barWidth: sw * 0.96,
        barHeight: barH,
        blockH: sh * 0.012,
        radius: sh * 0.005,
      ),
    );
  }

  // ── 7. 红色三角箭头（跟随进度百分比连续移动，紧贴进度条下方） ──
  Widget _buildProgressArrow(GymCoursePlayState state, double sw, double sh) {
    final barWidth = sw * 0.96;
    final barLeft = sw * 0.02;
    final barBottom = sh * 0.07;
    final arrowW = sw * 0.014;
    final arrowH = sh * 0.030;
    final clampedP = state.playProgressPercent.clamp(0.0, 1.0);
    final x = barWidth * clampedP - arrowW / 2;

    return Positioned(
      bottom: barBottom - arrowH + sh * 0.002,
      left: barLeft + x,
      child: CustomPaint(
        size: Size(arrowW, arrowH),
        painter: _UpTrianglePainter(),
      ),
    );
  }

  // ── 8. 返回按钮（图片资源） ──
  Widget _buildBackButton(double sw, double sh) {
    final iconH = sh * 0.055;
    return Positioned(
      right: sw * 0.05,
      top: sh * 0.055,
      child: GestureDetector(
        onTap: () {
          debugPrint('👆 [PlayScreen] Back button tapped');
          final state = ref.read(gymCoursePlayProvider);
          if (state.screenStatus == GymPlayScreenStatus.finished ||
              state.isStopScreen) {
            // 已在结算页：直接退出
            ref.read(gymCoursePlayProvider.notifier).exitToDetail();
            if (context.canPop()) context.pop();
          } else {
            // 🔴 播放中 / 任何未结算状态：立刻 manualFinish（先锁isStopScreen+停音频cancel timer，
            // 然后进结算页）。不弹中间确认层。
            debugPrint(
              '👆 [PlayScreen] Back button → manualFinish（立刻停音频+直接结算，不弹确认）',
            );
            ref.read(gymCoursePlayProvider.notifier).manualFinish();
          }
        },
        child: Image.asset(
          'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/icon_get_back.png',
          height: iconH,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) =>
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: iconH),
        ),
      ),
    );
  }

  // ── 9. 控制按钮（左侧竖排：跑步机=坡度+速度，其他设备=阻力） ──
  // 使用药丸形胶囊按钮（PillControlButton），按设备类型显示对应按钮组
  List<Widget> _buildControlButtons(
    GymCoursePlayState state,
    double sw,
    double sh,
  ) {
    final notifier = ref.read(gymCoursePlayProvider.notifier);
    final deviceType = state.deviceType;
    final firstTop = sh * 0.18;
    final gap = sh * 0.16; // 按钮组之间的竖排间距

    final result = <Widget>[];

    switch (deviceType) {
      case FtmsDeviceType.treadmill:
        // 跑步机：坡度（若支持）+ 速度（若支持），竖排叠加
        // 支持判定来自 0x2AD4/0x2AD5 设备能力上报（max<=min 视为不支持）
        var top = firstTop;
        if (state.hasInclinationSupport) {
          result.add(
            Positioned(
              right: sw * 0.02,
              top: top,
              child: PillControlButton(
                title: '坡度',
                value: state.sportInclinationButton.toStringAsFixed(1),
                onAdd: notifier.inclinationAdd,
                onDown: notifier.inclinationDown,
              ),
            ),
          );
          top += gap;
        }
        if (state.hasSpeedSupport) {
          result.add(
            Positioned(
              right: sw * 0.02,
              top: top,
              child: PillControlButton(
                title: '速度',
                value: state.sportSpeedButton.toStringAsFixed(1),
                onAdd: notifier.speedAdd,
                onDown: notifier.speedDown,
                onLongPressAdd: notifier.speedAddLongPress,
                onLongPressDown: notifier.speedDownLongPress,
                onLongPressEnd: notifier.longPressEnd,
              ),
            ),
          );
        }
        break;

      case FtmsDeviceType.indoorBike:
      case FtmsDeviceType.crossTrainer:
      case FtmsDeviceType.rower:
      case FtmsDeviceType.strengthStation:
        // 单车/椭圆机/划船机/力量站：仅阻力按钮（0x2AD6 max<=min 时隐藏）
        if (state.hasResistanceSupport) {
          result.add(
            Positioned(
              right: sw * 0.02,
              top: firstTop,
              child: PillControlButton(
                title: '阻力',
                value: state.sportResistanceButton.toStringAsFixed(0),
                onAdd: notifier.resistanceAdd,
                onDown: notifier.resistanceDown,
              ),
            ),
          );
        }
        break;
    }

    return result;
  }

  // ── 10. 右侧动作列表 ──
  Widget _buildRightActionList(GymCoursePlayState state, double sw, double sh) {
    final names = state.currentActionNameList;
    final listW = sw * 0.14;
    final listTop = sh * 0.45;
    final itemH = sh * 0.055;
    final radius = sh * 0.025;
    final fs = sh * 0.022;

    return Positioned(
      right: sw * 0.02,
      top: listTop + 40,
      child: Container(
        // constraints: BoxConstraints(maxHeight: sh * 0.35),
        height: sh * 0.25,
        width: listW,
        decoration: BoxDecoration(
          color: const Color(0xFF383838),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: sh * 0.008),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: names.length,
          itemBuilder: (context, index) {
            final isCurrent = index == 0;
            return Container(
              margin: EdgeInsets.only(
                left: listW * 0.15,
                right: listW * 0.06,
                top: itemH * 0.10,
                bottom: index == names.length - 1 ? itemH * 0.10 : 0,
              ),
              height: itemH,
              alignment: Alignment.centerLeft,
              child: Text(
                names[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isCurrent ? Colors.white : const Color(0xFF555555),
                  fontSize: fs,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── 11. 中央Play按钮 ──
  Widget _buildCenterPlayButton(double sw, double sh) {
    final btnSize = sh * 0.22;
    final iconSize = sh * 0.10;
    return SizedBox.expand(
      child: GestureDetector(
        onTap: () {
          debugPrint('👆 [PlayScreen] 中央Play按钮点击');
          ref.read(gymCoursePlayProvider.notifier).togglePlay();
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: btnSize,
              height: btnSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.49),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.49),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.30),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.play_arrow,
                size: iconSize,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // Finished 态 (结束页)
  // ══════════════════════════════════════════════════════════
  Widget _buildFinishedState(GymCoursePlayState state, double sw, double sh) {
    return Container(
      margin: EdgeInsets.all(sh * 0.025),
      color: Colors.black,
      child: Column(
        children: [
          _buildFinishedFirstRow(state, sw, sh),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                top: sh * 0.035,
                bottom: sh * 0.02,
                left: 30,
              ),
              child: _buildFinishedDataGrid(state, sw, sh),
            ),
          ),
          _buildCourseOverButton(sw, sh),
        ],
      ),
    );
  }

  Widget _buildFinishedFirstRow(
    GymCoursePlayState state,
    double sw,
    double sh,
  ) {
    return SizedBox(
      height: sh * 0.35,
      child: Row(
        children: [
          _buildFinishedCircularData(state, sw, sh),
          _buildTrainingLevel(state.level, sw, sh),

          _buildRatingPanel(state, sw, sh),
          _buildSpeedChartPanel(state, sw, sh),
        ],
      ),
    );
  }

  Widget _buildFinishedCircularData(
    GymCoursePlayState state,
    double sw,
    double sh,
  ) {
    final panelPad = sh * 0.025;
    final ringSize = sh * 0.32;
    final ringStep = sh * 0.026;
    return Expanded(
      child: Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(right: sw * 0.015),
        padding: EdgeInsets.all(panelPad),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(sh * 0.02),
        ),
        child: Row(
          children: [
            // SizedBox(width: panelPad),
            _buildTripleRing(state, ringSize, ringStep),
            // SizedBox(width: panelPad),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _finishedDataText(
                    l10n.finishedTime,
                    state.sportTime,
                    sh,
                    l10n,
                  ),
                  state.deviceType == FtmsDeviceType.rower
                      ? _finishedDataText(
                          l10n.finishedCounts,
                          state.sportStrokeCount,
                          sh,
                          l10n,
                        )
                      : _finishedDataText(
                          l10n.finishedDistance,
                          state.sportDistance,
                          sh,
                          l10n,
                        ),
                  _finishedDataText(
                    l10n.finishedCalories,
                    state.sportCalories,
                    sh,
                    l10n,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripleRing(GymCoursePlayState state, double size, double step) {
    final ringWidth = step * 0.7;
    final ringGap = step * 0.35;

    // ─── G9 修正：三环公式还原旧版（big_device_play_screen.dart L495-533） ───
    // 旧版 CircularStepProgressIndicator：currentStep ∈ [0,100]（%101），
    // 满进度比例 = 100/totalSteps；本组件 progress = currentStep / 100 等价还原。
    // 外圈（时间）：(saveSportTime × 0.1).round() % 101，约 1010 秒转满一圈
    final outerStep = (state.deviceSportSeconds * 0.1).round() % 101;
    final outerProgress = outerStep / 100;

    // 中圈（距离/桨数）：划船机用总桨数，其他用距离(km 取整)
    final middleSource = state.deviceType == FtmsDeviceType.rower
        ? (double.tryParse(state.sportStrokeCount) ?? 0).round()
        : (double.tryParse(state.sportDistance) ?? 0).round();
    final middleProgress = (middleSource % 101) / 100;

    // 内圈（卡路里）：卡路里取整 % 101
    final innerProgress =
        ((double.tryParse(state.sportCalories) ?? 0).round() % 101) / 100;

    debugPrint(
      '🎯 [TripleRing] outer=$outerStep middle=$middleSource '
      'calories=${(double.tryParse(state.sportCalories) ?? 0).round()} '
      'outer%=${outerProgress.toStringAsFixed(2)} '
      'middle%=${middleProgress.toStringAsFixed(2)} '
      'inner%=${innerProgress.toStringAsFixed(2)}',
    );

    return TripleRingProgress(
      data: TripleRingData(
        outerProgress: outerProgress,
        middleProgress: middleProgress,
        innerProgress: innerProgress,
      ),
      size: size,
      ringWidth: ringWidth,
      ringGap: ringGap,
    );
  }

  Widget _finishedDataText(
    String titleKey,
    String data,
    double sh,
    AppLocalizations l10n,
  ) {
    return Expanded(
      child: Container(
        color: const Color(0xFF121212),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(sh * 0.008),
              child: Text(
                titleKey,
                style: TextStyle(fontSize: sh * 0.024, color: Colors.white70),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: sh * 0.008),
              child: Text(
                data,
                style: TextStyle(fontSize: sh * 0.026, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingLevel(int level, double sw, double sh) {
    final index = level.clamp(1, 5) - 1;
    final pad = sh * 0.025;
    return Container(
      width: sw * 0.23,
      margin: EdgeInsets.only(left: sw * 0.008, right: sw * 0.008),
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(sh * 0.02),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.trainingIntensity,
            style: TextStyle(
              fontSize: sh * 0.022,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: sh * 0.012),
          Expanded(
            child: Image.asset(
              _stageIcons[index],
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Container(
                color: Colors.grey.shade800,
                child: Center(
                  child: Text(
                    'L${level + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          // SizedBox(height: sh * 0.010),
          Text(
            _stageTitle(index),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: sh * 0.020, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingPanel(GymCoursePlayState state, double sw, double sh) {
    final titles = state.ratingTitles;
    final indices = state.ratingImageIndices;
    final pad = sh * 0.025;
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: sw * 0.008, right: sw * 0.008),
        padding: EdgeInsets.all(pad),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(sh * 0.02),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.courseRating,
              style: TextStyle(
                color: Colors.white,
                fontSize: sh * 0.022,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(titles.length, (i) {
                  return _buildRatingRow(
                    titles[i],
                    indices.isNotEmpty && i < indices.length ? indices[i] : 0,
                    sw,
                    sh,
                  );
                }),
              ),
            ),
            Text(
              state.scoreLevel,
              style: TextStyle(fontSize: sh * 0.021, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow(String title, int levelIdx, double sw, double sh) {
    return SizedBox(
      height: sh * 0.05,
      child: Row(
        children: [
          SizedBox(
            width: sw * 0.05,
            child: Text(
              _tr(title),
              style: TextStyle(fontSize: sh * 0.020, color: Colors.white),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: sw * 0.005),
              height: sh * 0.022,
              child: Image.asset(
                _ratingLevelIcons[levelIdx.clamp(
                  0,
                  _ratingLevelIcons.length - 1,
                )],
                fit: BoxFit.fitWidth,
                errorBuilder: (_, _, _) => Container(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedChartPanel(GymCoursePlayState state, double sw, double sh) {
    final data = state.speedChartData;
    final isRower = state.deviceType == FtmsDeviceType.rower;
    final pad = sh * 0.025;
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(pad),
        margin: EdgeInsets.only(left: sw * 0.008),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(sh * 0.02),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: sh * 0.008, bottom: sh * 0.015),
              child: Text(
                l10n.speedBarChart,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: sh * 0.022,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: data.isEmpty
                  ? Center(
                      child: Text(
                        '—',
                        style: TextStyle(
                          color: Colors.white24,
                          fontSize: sh * 0.04,
                        ),
                      ),
                    )
                  : BarChart(
                      BarChartData(
                        titlesData: const FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        minY: 0,
                        maxY: 40,
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(data.length, (i) {
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: data[i],
                                width: 2,
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ],
                          );
                        }),
                      ),
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.linear,
                    ),
            ),
            Text(
              isRower ? 'spm/group' : 'km/h',
              style: TextStyle(fontSize: sh * 0.016, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishedDataGrid(
    GymCoursePlayState state,
    double sw,
    double sh,
  ) {
    final icons = state.finishDataIcons;
    final titles = state.finishDataTitles;
    final values = state.finishDataValues;
    final units = state.finishDataUnits;
    if (icons.isEmpty) return const SizedBox.shrink();

    final iconWidth = sw * 0.032;
    final iconGap = sw * 0.008;
    final valueIndent = iconWidth + iconGap;
    final labelFontSize = sh * 0.028;
    final valueFontSize = sh * 0.042;
    final labelRowHeight = sh * 0.042;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: sh * 0.060,
        childAspectRatio: 2.4,
        crossAxisSpacing: sw * 0.010,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final cellWidth = constraints.maxWidth;
            final textWidth = cellWidth - valueIndent - sw * 0.008;
            final titleText = '${_tr(titles[index])}${units[index]}';

            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: sw * 0.006, right: sw * 0.004),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: labelRowHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          icons[index],
                          height: labelFontSize * 1.2,
                          width: iconWidth,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => Container(
                            color: Colors.grey,
                            height: labelFontSize * 1.2,
                            width: iconWidth,
                          ),
                        ),
                        SizedBox(width: iconGap),
                        Expanded(
                          child: _AutoScrollText(
                            text: titleText,
                            style: TextStyle(
                              fontSize: labelFontSize,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            parentWidth: textWidth,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.only(left: valueIndent),
                    child: Text(
                      values[index],
                      style: TextStyle(
                        fontSize: valueFontSize,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCourseOverButton(double sw, double sh) {
    return SizedBox(
      height: sh * 0.10,
      width: sw,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35),
              borderRadius: BorderRadius.circular(sh * 0.03),
            ),
            width: sw / 4,
            child: InkWell(
              onTap: () {
                debugPrint('👆 [PlayScreen] Course Over button tapped');
                ref.read(gymCoursePlayProvider.notifier).exitToDetail();
                context.pop();
              },
              child: Text(
                l10n.courseOver,
                style: TextStyle(
                  fontSize: sh * 0.032,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// 可手动滑动的文本组件（替换自动走马灯）
// ══════════════════════════════════════════════════════════
class _AutoScrollText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double parentWidth;

  const _AutoScrollText({
    required this.text,
    required this.style,
    required this.parentWidth,
  });

  @override
  State<_AutoScrollText> createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<_AutoScrollText> {
  final _controller = ScrollController();
  bool _needsScroll = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOverflow();
    });
  }

  @override
  void didUpdateWidget(covariant _AutoScrollText oldWidget) {
    if (oldWidget.text != widget.text ||
        oldWidget.parentWidth != widget.parentWidth ||
        oldWidget.style != widget.style) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkOverflow();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _checkOverflow() {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final textWidth = textPainter.width;
    final shouldScroll = textWidth > widget.parentWidth;
    if (mounted && shouldScroll != _needsScroll) {
      setState(() => _needsScroll = shouldScroll);
    }
    debugPrint(
      '📜 [AutoScroll] text="${widget.text}", '
      'textWidth=${textWidth.toStringAsFixed(1)}, '
      'parentWidth=${widget.parentWidth.toStringAsFixed(1)}, '
      'needsScroll=$_needsScroll',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.parentWidth,
      height: widget.style.fontSize != null
          ? widget.style.fontSize! * 1.4
          : null,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        // 始终允许用户手动横向滑动
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [Text(widget.text, maxLines: 1, style: widget.style)],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// 静态波浪进度条（色块高度一致，通过垂直位置落差形成波浪）
// 复刻原版逻辑：生成后永恒不变，仅箭头在上方滑动
// ══════════════════════════════════════════════════════════
class _WavePositionProgressBar extends StatelessWidget {
  final List<GymProgressSegment> segments;
  final List<ActionItemState> actions;
  final double barWidth;
  final double barHeight;
  final double blockH;
  final double radius;

  const _WavePositionProgressBar({
    required this.segments,
    required this.actions,
    required this.barWidth,
    required this.barHeight,
    required this.blockH,
    required this.radius,
  });

  // 颜色映射顺序严格对齐旧版 uniqueColors:
  // 0=青绿, 1=蓝紫, 2=浅黄, 3=粉红, 4=天蓝, 5=棕褐, 6=灰
  static const List<Color> _colors = [
    Color(0xFF80FFCC), // 0: 青绿
    Color(0xFF7B93FF), // 1: 蓝紫
    Color(0xFFFFDD66), // 2: 浅黄
    Color(0xFFFF9999), // 3: 粉红
    Color(0xFF66CCFF), // 4: 天蓝
    Color(0xFFCCAA88), // 5: 棕褐
    Color(0xFFAAAAAA), // 6: 灰色
  ];

  @override
  Widget build(BuildContext context) {
    if (segments.isEmpty || actions.isEmpty) {
      return SizedBox(width: barWidth, height: barHeight);
    }
    final count = segments.length.clamp(0, actions.length);
    final waveRange = barHeight - blockH;
    // 复刻旧版 20.h 单位比例（相对于总高 200.h 约 10%）
    // 当前 barH ≈ sh*0.055，unitHeight 约为 barH * 0.1
    final unitHeight = barHeight * 0.1;

    // 观测日志：仅在 debug 模式下打印

    return SizedBox(
      width: barWidth,
      height: barHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(count, (i) {
          final seg = segments[i];
          final color = _colors[seg.posture % _colors.length];
          final w = seg.percentage * barWidth;

          // 使用 segments 中预计算的 heightFactor，不再双重计算
          final positionHeight = seg.heightFactor;
          // 复刻旧版公式：top = barHeight - blockH - positionHeight * unitHeight
          // 允许负值（由 Stack 自动裁剪，高踏频时条块钉在顶部）
          final rawTop = waveRange - positionHeight * unitHeight;
          final top = rawTop;

          return SizedBox(
            width: w,
            height: barHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: top,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: blockH,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(radius),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// 红色正三角 painter
// ══════════════════════════════════════════════════════════
class _UpTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
