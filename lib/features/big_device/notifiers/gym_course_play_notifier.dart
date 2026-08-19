import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ftms/device_time_normalizer.dart';
import '../../../core/ftms/ftms_command_dispatcher.dart';
import '../../../core/ftms/ftms_data_sync_guard.dart';
import '../../../core/ftms/ftms_device_data.dart';
import '../../../core/ftms/ftms_device_type.dart';
import '../../../core/ftms/ftms_service_base.dart';
import '../../../core/ftms/ftms_service_provider.dart';
import '../../../core/ftms/ftms_status_parser.dart';
import '../../../core/ftms/sport_timer.dart';
import '../states/gym_course_detail_state.dart';
import '../states/gym_course_play_state.dart';
import 'gym_course_detail_notifier.dart';

part 'gym_course_play_notifier.g.dart';

/// 课程播放页 Notifier（对应旧 ControllerBigDeviceCoursePlay + ControllerNewFourBigDeviceSprot）
///
/// 职责：
/// 1. 维护页面三态（loading / playing / finished）
/// 2. 纯本地模拟播放流程（无蓝牙）：定时器驱动 playIndex/imagePlayIndex/运动数据
/// 3. 设备控制按钮的交互（速度/坡度/阻力 +/−）
@Riverpod(keepAlive: true)
class GymCoursePlayNotifier extends _$GymCoursePlayNotifier {
  /// 每秒 tick（驱动 playIndex/播放进度/运动数据累加）
  Timer? _playTickTimer;

  /// 帧动画 tick（驱动 imagePlayIndex 切换，约33ms/帧 → 30fps）
  Timer? _imageFrameTimer;

  /// BGM 播放器（循环模式）
  final AudioPlayer _bgmPlayer = AudioPlayer();

  /// Voice 播放器（单次模式）
  final AudioPlayer _voicePlayer = AudioPlayer();

  /// 🔴 同步"音频终止"布尔（100%防御 await 穿透
  /// 语义：true= 已经触发了 manualFinish/_finishPlay → 音频必须立刻停止，任何后续异步启动/切换都不准再执行。
  /// 不放入 state（state 是 Riverpod 异步的，而 audioPlayer 的 await 穿透在 setState 之后无法同步检查
  bool _audioTerminated = false;

  /// 🔴 音频守卫快捷 check helper：同步布尔守卫，true=允许继续执行；false=已终止，打印日志并 return。
  bool _checkAudioGuard(String tag) {
    if (_audioTerminated) {
      debugPrint('🛑 [AudioGuard] $tag 被 _audioTerminated 布尔拦截（禁止再启动/切换音频');
      return false;
    }
    return true;
  }

  // ══════════════════════════════════════════════════════════
  // FTMS 核心组件（Task 11）
  // ══════════════════════════════════════════════════════════

  /// 当前设备类型（默认单车，由 initCourseContext 设置）
  FtmsDeviceType _deviceType = FtmsDeviceType.indoorBike;

  /// 运动计时器（本地计时 + 设备时间校准）
  SportTimer? _sportTimer;

  /// 设备时间归一化器（补偿 60 秒循环归零）
  DeviceTimeNormalizer? _timeNormalizer;

  /// 数据同步保护器（长按松手后屏蔽设备回调）
  FtmsDataSyncGuard? _syncGuard;

  /// FTMS 指令调度器（debounce / immediate 双模式）
  FtmsCommandDispatcher? _dispatcher;

  /// 实时数据流订阅
  StreamSubscription<FtmsDeviceData>? _dataSubscription;

  /// 设备状态流订阅
  StreamSubscription<FtmsStatusEvent>? _statusSubscription;

  // ─── 结束页统计采样列表（Task 13） ───

  /// 阻力采样列表（每 60 秒采样一次）
  final List<int> _resistanceSamples = [];

  /// 坡度采样列表（每 60 秒采样一次）
  final List<double> _inclinationSamples = [];

  /// 最大踏频（实时跟踪）
  int _maxCadence = 0;

  /// 最大心率（实时跟踪）
  int _maxHeartRate = 0;

  /// 最大配速（实时跟踪，min/km）
  double _maxPace = 0.0;

  @override
  GymCoursePlayState build() {
    // Notifier 销毁时清理定时器，避免泄漏
    ref.onDispose(() {
      _playTickTimer?.cancel();
      _imageFrameTimer?.cancel();
      _bgmPlayer.dispose();
      _voicePlayer.dispose();
      // Task 11: 清理 FTMS 资源
      _dataSubscription?.cancel();
      _statusSubscription?.cancel();
      _sportTimer?.dispose();
      _dispatcher?.dispose();
      debugPrint('🧹 [PlayNotifier] onDispose 定时器已清理');
      debugPrint('🧹 [Audio] 播放器已释放');
      debugPrint('🧹 [CoursePlay] onDispose FTMS 资源已清理');
    });

    return GymCoursePlayState(
      deviceType: FtmsDeviceType.indoorBike,
      screenStatus: GymPlayScreenStatus.loading,
    );
  }

  // ══════════════════════════════════════════════════════════
  // Mock 数据构建
  // ══════════════════════════════════════════════════════════

  /// 基于设备类型构建 mock 数据
  Future<GymCoursePlayState> _buildMockData(FtmsDeviceType deviceType) async {
    // 课程动作列表（6 段：热身→冲刺→爬坡→恢复→耐力→放松）
    const actions = [
      ActionItemState(
        name: '热身',
        imageName: 'warm_up',
        bgmName: 'bgm_warm',
        voiceName: 'voice_warm',
        duration: 11,
        resistance: 2,
        cadence: 20,
        posture: 0,
        isRestStage: true,
        imageFps: 10,
        imageLength: 110,
        orderId: 0,
      ),
      ActionItemState(
        name: '快跑',
        imageName: 'sprint',
        bgmName: 'bgm_run',
        voiceName: 'voice_run',
        duration: 75,
        resistance: 5,
        cadence: 45,
        posture: 2,
        isRestStage: false,
        imageFps: 10,
        imageLength: 750,
        orderId: 1,
      ),
      ActionItemState(
        name: '快跑',
        imageName: 'climb',
        bgmName: 'bgm_climb',
        voiceName: 'voice_climb',
        duration: 45,
        resistance: 8,
        cadence: 30,
        posture: 3,
        isRestStage: false,
        imageFps: 10,
        imageLength: 450,
        orderId: 2,
      ),
      ActionItemState(
        name: '快跑',
        imageName: 'recovery',
        bgmName: 'bgm_recov',
        voiceName: 'voice_recov',
        duration: 30,
        resistance: 2,
        cadence: 15,
        posture: 0,
        isRestStage: true,
        imageFps: 10,
        imageLength: 300,
        orderId: 3,
      ),
      ActionItemState(
        name: '慢跑',
        imageName: 'endurance',
        bgmName: 'bgm_endur',
        voiceName: 'voice_endur',
        duration: 60,
        resistance: 6,
        cadence: 35,
        posture: 1,
        isRestStage: false,
        imageFps: 10,
        imageLength: 600,
        orderId: 4,
      ),
      ActionItemState(
        name: '放松',
        imageName: 'cool_down',
        bgmName: 'bgm_cool',
        voiceName: 'voice_cool',
        duration: 44,
        resistance: 1,
        cadence: 10,
        posture: 0,
        isRestStage: true,
        imageFps: 10,
        imageLength: 440,
        orderId: 5,
      ),
    ];

    return _buildPlayState(
      actions: actions,
      deviceType: deviceType,
      courseTitle: '金字塔变速跑',
      difficulty: '进阶',
      level: 3,
    );
  }

  /// 右侧动作列表：把 "开始 + 顺序阶段名" 组合出来（对应旧版 currentActionNameList）
  List<String> _buildRightActionNameList(List<ActionItemState> actions) {
    final result = <String>['开始'];
    for (final a in actions) {
      if (!result.contains(a.name)) result.add(a.name);
    }
    return result;
  }

  /// 解析本地图片根目录路径
  Future<String> _resolveRootImagePath() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/course/actionImage/';
      final d = Directory(path);
      if (!await d.exists()) {
        debugPrint('⚠️ [PlayNotifier] 图片根目录不存在: $path，UI将走errorBuilder兜底');
        await d.create(recursive: true);
      } else {
        debugPrint('🌅 [PlayNotifier] 图片根目录已就绪: $path');
        final subDirs = d.listSync().toList();
        debugPrint('🌅 [PlayNotifier] 子目录数量: ${subDirs.length}');
        for (final sub in subDirs.take(5)) {
          debugPrint('🌅 [PlayNotifier] 图片子目录: ${sub.path}');
        }
      }
      return path;
    } catch (e) {
      debugPrint('❌ [PlayNotifier] 获取图片路径失败: $e');
      return '';
    }
  }

  // ══════════════════════════════════════════════════════════
  // 音频控制（BGM + Voice）
  // ══════════════════════════════════════════════════════════

  /// 首次启动：加载 BGM（循环）+ Voice（单次）并播放
  Future<void> _startBgmAndVoice() async {
    // 🔴 守卫 1：同步布尔（第一重拦截
    if (!_checkAudioGuard('_startBgmAndVoice.entry')) return;
    // 🔴 屏态守卫：中间态/结算态 不允许再启动
    if (state.isPauseScreen || state.isStopScreen) {
      debugPrint(
        '🛑 [Audio] _startBgmAndVoice 被屏态守卫拦截 (isPauseScreen=${state.isPauseScreen}, isStopScreen=${state.isStopScreen})',
      );
      return;
    }
    final actions = state.courseActions;
    if (actions.isEmpty) return;

    final firstAction = actions.first;
    final curAction = actions[state.playIndex.clamp(0, actions.length - 1)];

    final bgmPath = '${state.rootBgmPath}${firstAction.bgmName}.mp3';
    final voicePath = '${state.rootVoicePath}${curAction.voiceName}.mp3';

    // 加载并播放 BGM（循环模式）
    try {
      await _bgmPlayer.setFilePath(bgmPath);
      if (!_checkAudioGuard('_startBgmAndVoice.afterBgmSet')) return;
      await _bgmPlayer.setLoopMode(LoopMode.one);
      if (!_checkAudioGuard('_startBgmAndVoice.afterBgmLoop')) return;
      await _bgmPlayer.play();
      debugPrint('🎵 [Audio] BGM 播放启动: $bgmPath');
    } catch (e) {
      debugPrint('❌ [Audio] BGM 加载失败: $e');
    }

    // 加载并播放 Voice（单次模式）
    try {
      if (!_checkAudioGuard('_startBgmAndVoice.beforeVoiceSet')) return;
      await _voicePlayer.setFilePath(voicePath);
      if (!_checkAudioGuard('_startBgmAndVoice.afterVoiceSet')) return;
      await _voicePlayer.setLoopMode(LoopMode.off);
      if (!_checkAudioGuard('_startBgmAndVoice.afterVoiceLoop')) return;
      await _voicePlayer.play();
      debugPrint('🎵 [Audio] Voice 播放启动: $voicePath');
    } catch (e) {
      debugPrint('❌ [Audio] Voice 加载失败: $e');
    }
  }

  /// 阶段切换：停止旧 Voice，加载并播放新 Voice（BGM 保持不变）
  Future<void> _switchVoice() async {
    // 🔴 守卫 1：同步布尔（第一重）
    if (!_checkAudioGuard('_switchVoice.entry')) return;
    // 🔴 屏态守卫：中间态/结算态 不允许再切换 Voice
    if (state.isPauseScreen || state.isStopScreen) {
      debugPrint(
        '🛑 [Audio] _switchVoice 被屏态守卫拦截 (isPauseScreen=${state.isPauseScreen}, isStopScreen=${state.isStopScreen})',
      );
      return;
    }
    final actions = state.courseActions;
    if (actions.isEmpty) return;

    final curAction = actions[state.playIndex.clamp(0, actions.length - 1)];
    final voicePath = '${state.rootVoicePath}${curAction.voiceName}.mp3';

    try {
      await _voicePlayer.stop();
      if (!_checkAudioGuard('_switchVoice.afterStop')) return;
      await _voicePlayer.setFilePath(voicePath);
      if (!_checkAudioGuard('_switchVoice.afterSet')) return;
      await _voicePlayer.setLoopMode(LoopMode.off);
      if (!_checkAudioGuard('_switchVoice.afterLoop')) return;
      await _voicePlayer.play();
      debugPrint('🔊 [Audio] Voice 切换: ${curAction.voiceName}');
    } catch (e) {
      debugPrint('❌ [Audio] Voice 切换失败: $e');
    }
  }

  /// 停止所有音频（同步设置终止布尔）
  void _stopAudio() {
    _bgmPlayer.stop();
    _voicePlayer.stop();
    debugPrint('⏹️ [Audio] 音乐停止');
  }

  // ══════════════════════════════════════════════════════════
  // 进度条分段
  // ══════════════════════════════════════════════════════════

  /// 构建进度条分段数据
  /// 复刻旧版 countBarLineDataItem() 精度算法：×1000 取整 + 末尾修正，
  /// 确保各段宽度总和精确等于 barWidth，避免浮点精度导致的间隙或溢出
  List<GymProgressSegment> _buildProgressSegments(
    List<ActionItemState> actions,
    FtmsDeviceType deviceType,
  ) {
    final totalDuration = actions.fold<int>(0, (a, b) => a + b.duration);
    if (totalDuration == 0) return [];

    // ─── 1. 计算精确百分比（×1000 整数） ───
    final roundedPercentages = <int>[];
    for (final action in actions) {
      final exactPercent = (action.duration / totalDuration) * 1000;
      roundedPercentages.add(exactPercent.round());
    }

    // ─── 2. 计算取整误差并修正到最后一个元素 ───
    final sumRounded = roundedPercentages.reduce((a, b) => a + b);
    final difference = 1000 - sumRounded;
    if (difference != 0) {
      roundedPercentages[roundedPercentages.length - 1] += difference > 0
          ? -difference
          : difference;
    }
    debugPrint(
      '📊 [ProgressBar] 百分比修正: sum=$sumRounded, diff=$difference, '
      '最终比例=${roundedPercentages.map((p) => (p / 1000.0).toStringAsFixed(3)).toList()}',
    );

    // ─── 3. 生成 segments，使用修正后的百分比 ───
    return actions.asMap().entries.map((entry) {
      final index = entry.key;
      final action = entry.value;
      final percentage = roundedPercentages[index] / 1000.0;

      // 高度因子：跑步机用速度(cadence)，其他用阻力/10
      int heightFactor;
      switch (deviceType) {
        case FtmsDeviceType.treadmill:
          heightFactor = action.cadence;
          break;
        default:
          heightFactor = (action.resistance ~/ 10).clamp(0, 10);
          break;
      }

      return GymProgressSegment(
        percentage: percentage,
        heightFactor: heightFactor,
        posture: action.posture,
      );
    }).toList();
  }

  // ══════════════════════════════════════════════════════════
  // 结束页 & 评分
  // ══════════════════════════════════════════════════════════

  (List<String>, List<String>, List<String>, List<String>) _buildFinishData(
    FtmsDeviceType deviceType,
  ) {
    const iconBase =
        'images/newUIScreen/bigScreenAnimation/bigDevicePlayCourseIcon';

    switch (deviceType) {
      case FtmsDeviceType.indoorBike:
        return (
          [
            '$iconBase/over_time.png',
            '$iconBase/over_distance.png',
            '$iconBase/over_kcal.png',
            '$iconBase/over_avg_speed.png',
            '$iconBase/over_average_cadence.png',
            '$iconBase/over_max_cadence.png',
            '$iconBase/over_avg_heart_rate.png',
            '$iconBase/over_total_step.png',
            '$iconBase/over_rest.png',
            '$iconBase/over_finish.png',
          ],
          [
            'Sport Time',
            'Total Distance',
            'Total Calories',
            'Pace',
            'Avg Cadence',
            'Max Cadence',
            'Max Heart Rate',
            'Total Cadence',
            'Rest Time',
            'Completion',
          ],
          [
            '05:30',
            '1.25',
            '46',
            '02:24',
            '85',
            '95',
            '142',
            '560',
            '00:00',
            '85.5',
          ],
          [
            '',
            '(km)',
            '(kcal)',
            '(min/km)',
            '(rpm)',
            '(rpm)',
            '(bpm)',
            '(rpm)',
            '',
            '(%)',
          ],
        );
      case FtmsDeviceType.treadmill:
        return (
          [
            '$iconBase/over_time.png',
            '$iconBase/over_distance.png',
            '$iconBase/over_kcal.png',
            '$iconBase/over_avg_speed.png',
            '$iconBase/over_avg_incline.png',
            '$iconBase/over_max_speed.png',
            '$iconBase/over_avg_heart_rate.png',
            '$iconBase/over_heart_rate_area.png',
            '$iconBase/over_rest.png',
            '$iconBase/over_finish.png',
          ],
          [
            'Sport Time',
            'Total Distance',
            'Total Calories',
            'Pace',
            'Max Pace',
            'Max Cadence',
            'Max Heart Rate',
            'Avg Cadence',
            'Total Cadence',
            'Completion',
          ],
          [
            '05:30',
            '1.25',
            '46',
            '02:24',
            '02:40',
            '95',
            '142',
            '85',
            '560',
            '85.5',
          ],
          [
            '',
            '(km)',
            '(kcal)',
            '(min/km)',
            '(min/km)',
            '(rpm)',
            '(bpm)',
            '(reps/min)',
            '(reps)',
            '(%)',
          ],
        );
      case FtmsDeviceType.crossTrainer:
        return (
          [
            '$iconBase/over_time.png',
            '$iconBase/over_distance.png',
            '$iconBase/over_kcal.png',
            '$iconBase/over_avg_speed.png',
            '$iconBase/over_average_cadence.png',
            '$iconBase/over_total_step.png',
            '$iconBase/over_max_cadence.png',
            '$iconBase/over_avg_heart_rate.png',
            '$iconBase/over_rest.png',
            '$iconBase/over_finish.png',
          ],
          [
            'Sport Time',
            'Total Distance',
            'Total Calories',
            'Pace',
            'Avg Cadence',
            'Total Cadence',
            'Max Cadence',
            'Max Heart Rate',
            'Rest Time',
            'Completion',
          ],
          [
            '05:30',
            '1.25',
            '46',
            '02:24',
            '85',
            '560',
            '95',
            '142',
            '00:00',
            '85.5',
          ],
          [
            '',
            '(km)',
            '(kcal)',
            '(min/km)',
            '(rpm)',
            '',
            '(rpm)',
            '(bpm)',
            '',
            '(%)',
          ],
        );
      case FtmsDeviceType.rower:
        return (
          [
            '$iconBase/over_time.png',
            '$iconBase/over_distance.png',
            '$iconBase/over_kcal.png',
            '$iconBase/over_avg_rowing_cadence.png',
            '$iconBase/over_avg_resistance.png',
            '$iconBase/over_rowing_count.png',
            '$iconBase/over_max_rowing_cadence.png',
            '$iconBase/over_avg_heart_rate.png',
            '$iconBase/over_rest.png',
            '$iconBase/over_finish.png',
          ],
          [
            'Sport Time',
            'Total Distance',
            'Total Calories',
            'Avg Strokes',
            'Avg Resistance',
            'Total Strokes',
            'Max Stroke Rate',
            'Avg Heart Rate',
            'Rest Time',
            'Completion',
          ],
          [
            '05:30',
            '1.25',
            '46',
            '28',
            '3',
            '156',
            '35',
            '128',
            '00:00',
            '85.5',
          ],
          [
            '',
            '(km)',
            '(kcal)',
            '(spm)',
            '',
            '(rpm)',
            '(spm)',
            '(bpm)',
            '',
            '(%)',
          ],
        );
      case FtmsDeviceType.strengthStation:
        // 力量站预留：暂与单车使用相同的结束页结构
        return _buildFinishData(FtmsDeviceType.indoorBike);
    }
  }

  (List<String>, List<int>, String, List<int>) _buildRatingData(
    FtmsDeviceType deviceType,
  ) {
    switch (deviceType) {
      case FtmsDeviceType.treadmill:
        return (
          ['Completion', 'Stability', 'Slope Control', 'Exercise Coherence'],
          [4, 4, 3, 3],
          'Level A',
          [0, 0, 0, 2],
        );
      case FtmsDeviceType.indoorBike:
      case FtmsDeviceType.crossTrainer:
        return (
          ['Completion', 'Stability', 'Pedaling Eff.', 'Coherence'],
          [4, 3, 4, 3],
          'Level A',
          [0, 0, 0, 2],
        );
      case FtmsDeviceType.rower:
        return (
          ['Completion', 'Endurance', 'Exercise Eff.', 'Stability'],
          [4, 3, 4, 3],
          'Level A',
          [0, 0, 0, 2],
        );
      case FtmsDeviceType.strengthStation:
        // 力量站预留：评分与单车一致
        return _buildRatingData(FtmsDeviceType.indoorBike);
    }
  }

  // ══════════════════════════════════════════════════════════
  // 初始化
  // ══════════════════════════════════════════════════════════

  void resetToLoading() {
    _playTickTimer?.cancel();
    _imageFrameTimer?.cancel();
    _stopAudio();
    // Task 13: 重置统计采样列表
    _resistanceSamples.clear();
    _inclinationSamples.clear();
    _maxCadence = 0;
    _maxHeartRate = 0;
    _maxPace = 0.0;
    state = state.copyWith(
      screenStatus: GymPlayScreenStatus.loading,
      isPause: false,
      isPauseScreen: false,
      isStopScreen: false,
      showPlayButton: false,
      isPlaying: false,
    );
  }

  Future<void> initCourseContext({
    int? courseId,
    FtmsDeviceType? deviceType,
  }) async {
    debugPrint(
      '📦 [PlayInit] initCourseContext called, courseId=$courseId, deviceType=$deviceType',
    );
    // 🔴 重置"音频终止"布尔（新一轮课程开始，允许启音）
    _audioTerminated = false;
    debugPrint('🛑 [AudioGuard] _audioTerminated = false（新课程初始化，允许启音）');
    if (deviceType != null) {
      // Task 11: 设置设备类型并初始化 FTMS 核心组件
      _deviceType = deviceType;
      _sportTimer ??= SportTimer();
      _timeNormalizer ??= DeviceTimeNormalizer();
      _syncGuard ??= FtmsDataSyncGuard();
      _setupDispatcher();
      _setupStreams();
      debugPrint(
        '📡 [CoursePlay] FTMS 初始化完成: deviceType=$_deviceType, '
        'dispatcher=${_dispatcher != null ? "ready" : "null(mock模式)"}, '
        'dataStream=${_dataSubscription != null ? "subscribed" : "无订阅"}',
      );

      // 优先从详情页 Provider 读取真实课程数据（已下载完成的课程）
      final detailState = ref.read(gymCourseDetailProvider);
      final realActions = detailState.courseActionList;

      final GymCoursePlayState data;
      if (realActions.isNotEmpty && courseId == detailState.courseId) {
        debugPrint('📦 [PlayInit] 使用真实课程数据（来自详情页 Provider）');
        data = await _buildDataFromRealActions(realActions, deviceType);
      } else {
        debugPrint('📦 [PlayInit] 详情页无匹配数据，回退到 mock 数据');
        data = await _buildMockData(deviceType);
      }

      state = data.copyWith(screenStatus: GymPlayScreenStatus.playing);
      debugPrint(
        '📦 [PlayInit] 初始化完成：title=${state.courseTitle}, '
        'actions=${state.courseActions.length}, root=${state.rootImagePath}, '
        'totalDuration=${state.totalPlayProgressDuration}s',
      );

      // 打印首个动作的音频文件名，便于真机调试
      if (state.courseActions.isNotEmpty) {
        final first = state.courseActions.first;
        debugPrint(
          '🎵 [PlayInit] 首个动作: imageName=${first.imageName}, '
          'bgmName=${first.bgmName}, voiceName=${first.voiceName}',
        );
      }
    }
  }

  /// 从真实课程数据（详情页 Provider 的 CourseActionListItem）构建播放状态
  Future<GymCoursePlayState> _buildDataFromRealActions(
    List<CourseActionListItem> actions,
    FtmsDeviceType deviceType,
  ) async {
    // 映射 CourseActionListItem → ActionItemState
    final playActions = actions.map((a) {
      return ActionItemState(
        name: a.name ?? '未知',
        imageName: a.imageName ?? '',
        bgmName: a.bgmName ?? '',
        voiceName: a.voiceName ?? '',
        duration: a.duration ?? 60,
        resistance: a.resistance ?? 3,
        cadence: a.cadence ?? 25,
        posture: a.posture ?? 0,
        isRestStage: a.isRestStage ?? false,
        imageFps: a.imagefps ?? 10,
        imageLength: a.imageLength ?? 300,
        orderId: a.orderId ?? 0,
        count: a.count ?? 0,
        distance: a.distance ?? 0,
      );
    }).toList();

    return _buildPlayState(
      actions: playActions,
      deviceType: deviceType,
      courseTitle: '训练课程',
      difficulty: '进阶',
      level: 3,
    );
  }

  /// 公共构建方法：将 action list 和 device type 转换为 GymCoursePlayState
  Future<GymCoursePlayState> _buildPlayState({
    required List<ActionItemState> actions,
    required FtmsDeviceType deviceType,
    required String courseTitle,
    required String difficulty,
    required int level,
  }) async {
    final actionNames = _buildRightActionNameList(actions);
    final progressSegments = _buildProgressSegments(actions, deviceType);
    final totalDuration = actions.fold<int>(0, (a, b) => a + b.duration);

    // 路径初始化
    final rootImagePath = await _resolveRootImagePath();
    final dir = await getApplicationDocumentsDirectory();
    final rootBgmPath = '${dir.path}/course/bgm/';
    final rootVoicePath = '${dir.path}/course/voice/';
    debugPrint('🎵 [PlayNotifier] BGM根路径: $rootBgmPath');
    debugPrint('🎵 [PlayNotifier] Voice根路径: $rootVoicePath');

    // 按设备类型生成结束页数据
    final finishData = _buildFinishData(deviceType);
    final ratingData = _buildRatingData(deviceType);

    return GymCoursePlayState(
      deviceType: deviceType,
      screenStatus: GymPlayScreenStatus.playing,
      allowTouch: true,
      showPlayButton: true,
      isPlaying: false,
      isPause: false,
      isStopScreen: false,
      courseTitle: courseTitle,
      difficulty: difficulty,
      level: level,
      targetResistanceLevel: 3,
      // 实时数据（初始值0，由后续定时器累加）
      sportTime: '00:00',
      sportDistance: '0.00',
      sportCalories: '0.0',
      sportSpeed: '0.0',
      sportDeviceSpeed: 0.0,
      sportHeartRate: '0',
      sportCadence: '0',
      sportStrokeRate: '28',
      sportStrokeCount: '0',
      sportInclination: '0.0',
      sportResistance: '3',
      // 按钮值
      sportSpeedButton: 0.0,
      sportInclinationButton: 3.0,
      sportResistanceButton: 3.0,
      hasInclinationSupport: deviceType == FtmsDeviceType.treadmill,
      // 进度
      playIndex: 0,
      currentDuration: actions.isNotEmpty ? actions.first.duration : 60,
      playIndexDuration: 0,
      playTotalDuration: 0,
      totalPlayProgressDuration: totalDuration,
      imagePlayIndex: 0,
      imageFps: actions.isNotEmpty ? actions.first.imageFps : 10,
      rootImagePath: rootImagePath,
      rootBgmPath: rootBgmPath,
      rootVoicePath: rootVoicePath,
      playProgressPercent: 0.0,
      // 动作
      courseActions: actions,
      currentActionNameList: actionNames,
      progressSegments: progressSegments,
      // 结束页
      finishDataIcons: finishData.$1,
      finishDataTitles: finishData.$2,
      finishDataValues: finishData.$3,
      finishDataUnits: finishData.$4,
      // 评分
      ratingTitles: ratingData.$1,
      ratingScores: ratingData.$2,
      scoreLevel: ratingData.$3,
      ratingImageIndices: ratingData.$4,
      // 速度图
      speedChartData: [],
    );
  }

  // ══════════════════════════════════════════════════════════
  // FTMS 蓝牙数据流接入（Task 11）
  // ══════════════════════════════════════════════════════════

  /// 获取当前设备类型对应的 FtmsServiceBase 实例。
  /// 若蓝牙未连接（Provider 返回 null），返回 null，Notifier 走 mock 降级模式。
  FtmsServiceBase? _getFtmsService() {
    try {
      return ref.read(ftmsServiceProvider(_deviceType));
    } catch (e) {
      debugPrint('📡 [CoursePlay] _getFtmsService error: $e');
      return null;
    }
  }

  /// 初始化 FTMS 指令调度器。
  /// 若 ftmsService 为 null（无设备连接），跳过，Notifier 走 mock 降级模式。
  void _setupDispatcher() {
    final ftmsService = _getFtmsService();
    if (ftmsService == null) {
      debugPrint(
        '📡 [CoursePlay] _setupDispatcher: ftmsService 为 null，跳过（mock 降级模式）',
      );
      return;
    }
    _dispatcher = FtmsCommandDispatcher(
      serviceGetter: _getFtmsService,
      syncGuard: _syncGuard,
    );
    debugPrint('📡 [CoursePlay] _setupDispatcher: dispatcher 已创建');
  }

  /// 绑定 FTMS 数据流与状态流监听。
  /// 在 initCourseContext 时调用，会先取消旧订阅再创建新订阅。
  /// 若 ftmsService 为 null（无设备连接），跳过，保留 mock 定时器逻辑。
  void _setupStreams() {
    final ftmsService = _getFtmsService();
    if (ftmsService == null) {
      debugPrint(
        '📡 [CoursePlay] _setupStreams: ftmsService 为 null，跳过（保留 mock 定时器）',
      );
      return;
    }

    // 取消旧订阅
    _dataSubscription?.cancel();
    _statusSubscription?.cancel();

    // 监听实时数据流（0x2AD1）
    _dataSubscription = ftmsService.dataStream.listen(_onDataReceived);
    // 监听设备状态流（0x2ADA）
    _statusSubscription = ftmsService.statusStream.listen(_onStatusReceived);

    debugPrint('📡 [CoursePlay] _setupStreams: dataStream 与 statusStream 已订阅');
  }

  /// 收到 FTMS 实时数据时的处理逻辑。
  /// 1. 归一化设备时间
  /// 2. 校准 SportTimer
  /// 3. 更新 state 实时运动数据字段
  ///
  /// 注意：_playTickTimer 继续负责课程进度（playIndex/playTotalDuration），
  /// 本方法仅负责更新运动数据（速度/距离/卡路里/心率等），两者职责分离。
  void _onDataReceived(FtmsDeviceData data) {
    // 屏态守卫：暂停/结算态不处理设备数据
    if (state.isPause || state.isPauseScreen || state.isStopScreen) return;

    // 归一化设备时间（补偿 60 秒循环归零）
    final rawElapsed = data.timeElapsed ?? 0;
    final normalizedTime = _timeNormalizer?.normalize(rawElapsed) ?? rawElapsed;

    // 用归一化值校准本地计时器
    _sportTimer?.syncFromDevice(normalizedTime);

    // 解析实时数据字段
    final speed = data.instSpeed ?? state.sportDeviceSpeed;
    final cadence = data.instCadence ?? 0.0;
    final hr = data.hr ?? 0;
    final distance = (data.distTotal ?? 0).toDouble();
    final calories = (data.energyTotal ?? 0).toDouble();
    final strokeRate = data.strokesPerMin ?? 0.0;
    final strokeCount = (data.strokeCountTotal ?? 0).toDouble();
    final resistance = data.resistanceLvl ?? state.sportResistanceButton;
    final inclination = data.inclineAngle ?? state.sportInclinationButton;

    // 实时跟踪最大值（用于结束页统计）
    if (cadence.round() > _maxCadence) _maxCadence = cadence.round();
    if (hr > _maxHeartRate) _maxHeartRate = hr;
    final pace = _calculatePace(speed);
    if (pace > _maxPace) _maxPace = pace;

    // 更新 state 实时运动数据字段
    state = state.copyWith(
      sportTime: formatDuration(normalizedTime),
      sportDistance: (distance / 1000.0).toStringAsFixed(2), // m → km
      sportCalories: calories.toStringAsFixed(1),
      sportSpeed: speed.toStringAsFixed(1),
      sportDeviceSpeed: speed,
      sportHeartRate: hr.toString(),
      sportCadence: cadence.round().toString(),
      sportStrokeRate: strokeRate.round().toString(),
      sportStrokeCount: strokeCount.round().toString(),
      sportResistance: resistance.round().toString(),
      sportInclination: inclination.toStringAsFixed(1),
    );

    debugPrint(
      '📡 [CoursePlay] _onDataReceived: time=$normalizedTime, speed=${speed.toStringAsFixed(1)}, '
      'cadence=${cadence.round()}, hr=$hr, dist=${(distance / 1000.0).toStringAsFixed(2)}km, '
      'kcal=${calories.toStringAsFixed(1)}',
    );
  }

  /// 收到 FTMS 设备状态通知（0x2ADA）时的处理逻辑。
  /// 处理设备开始/暂停/停止/速度/坡度/阻力变化回调。
  void _onStatusReceived(FtmsStatusEvent event) {
    switch (event) {
      case FtmsStatusStartedResumed():
        // 0x04：设备开始/恢复运动
        debugPrint('📡 [CoursePlay] 设备状态: opCode=0x04, action=start/resume');
        if (!state.isPlaying) {
          _sportTimer?.start();
        }
        break;

      case FtmsStatusStoppedPaused(:final isPause):
        if (isPause) {
          // 0x02 + 0x02：设备暂停
          debugPrint('📡 [CoursePlay] 设备状态: opCode=0x02, action=pause');
          _sportTimer?.pause();
        } else {
          // 0x02 + 0x01：设备停止
          debugPrint('📡 [CoursePlay] 设备状态: opCode=0x02, action=stop');
          _sportTimer?.stop();
        }
        break;

      case FtmsStatusTargetSpeedChanged(:final speedKmPerH):
        // 0x05：速度回调
        debugPrint(
          '📡 [CoursePlay] 设备状态: opCode=0x05, action=speed, value=$speedKmPerH',
        );
        if (_syncGuard?.isInGuardWindow() ?? false) {
          debugPrint('📡 [CoursePlay] 在保护窗口内，跳过速度更新');
        } else {
          state = state.copyWith(sportSpeedButton: speedKmPerH);
        }
        break;

      case FtmsStatusTargetInclineChanged(:final inclinePercent):
        // 0x06：坡度回调
        debugPrint(
          '📡 [CoursePlay] 设备状态: opCode=0x06, action=incline, value=$inclinePercent',
        );
        if (_syncGuard?.isInGuardWindow() ?? false) {
          debugPrint('📡 [CoursePlay] 在保护窗口内，跳过坡度更新');
        } else {
          state = state.copyWith(sportInclinationButton: inclinePercent);
        }
        break;

      case FtmsStatusTargetResistanceChanged(:final resistanceLevel):
        // 0x07：阻力回调
        debugPrint(
          '📡 [CoursePlay] 设备状态: opCode=0x07, action=resistance, value=$resistanceLevel',
        );
        if (_syncGuard?.isInGuardWindow() ?? false) {
          debugPrint('📡 [CoursePlay] 在保护窗口内，跳过阻力更新');
        } else {
          state = state.copyWith(sportResistanceButton: resistanceLevel);
        }
        break;

      case FtmsStatusReset():
        debugPrint('📡 [CoursePlay] 设备状态: opCode=0x01, action=reset');
        break;

      case FtmsStatusSafetyKey():
        debugPrint('📡 [CoursePlay] 设备状态: opCode=0x03, action=safetyKey');
        break;

      case FtmsStatusTargetPowerChanged(:final powerWatts):
        debugPrint(
          '📡 [CoursePlay] 设备状态: opCode=0x08, action=power, value=${powerWatts}W',
        );
        break;

      case FtmsStatusControlPermissionLost():
        debugPrint('📡 [CoursePlay] 设备状态: opCode=0xFF, action=permissionLost');
        break;

      case FtmsStatusUnknown(:final opCode):
        debugPrint(
          '📡 [CoursePlay] 设备状态: opCode=0x${opCode.toRadixString(16)}, action=unknown',
        );
        break;
    }
  }

  // ══════════════════════════════════════════════════════════
  // 课程动作参数自动下发（Task 12）
  // ══════════════════════════════════════════════════════════

  /// 动作切换时调用，根据设备类型下发参数到设备。
  /// - 单车/椭圆机/划船机：下发阻力 (0x07 + [0x0B, ...value])
  /// - 跑步机：下发速度 (0x07 + [0x02, ...value])
  /// 若 _dispatcher 为 null（无蓝牙连接），仅更新本地 state（降级模式）。
  void _applyActionParameters(ActionItemState action) {
    if (_dispatcher == null) {
      // 降级模式：无蓝牙连接，仅更新本地按钮值
      debugPrint(
        '🎯 [Action] _applyActionParameters (mock模式): name=${action.name}, '
        'resistance=${action.resistance}, cadence=${action.cadence}',
      );
      state = state.copyWith(
        sportResistanceButton: action.resistance.toDouble(),
        sportSpeedButton: action.cadence.toDouble(),
      );
      return;
    }

    final FtmsCommand command;
    switch (_deviceType) {
      case FtmsDeviceType.treadmill:
        // 跑步机：下发速度 (0x02 Set Target Speed, uint16 LE ×100)
        command = FtmsCommand(0x02, _buildValueBytes(0x02, action.cadence.toDouble()));
        state = state.copyWith(sportSpeedButton: action.cadence.toDouble());
        break;
      case FtmsDeviceType.indoorBike:
      case FtmsDeviceType.crossTrainer:
      case FtmsDeviceType.rower:
      case FtmsDeviceType.strengthStation:
        // 单车/椭圆机/划船机/力量站：下发阻力 (0x04 Set Target Resistance Level, uint8 ×10)
        command = FtmsCommand(0x04, _buildValueBytes(0x04, action.resistance.toDouble()));
        state = state.copyWith(
          sportResistanceButton: action.resistance.toDouble(),
        );
        break;
    }

    _dispatcher!.dispatch(command);
    debugPrint(
      '🎯 [Action] _applyActionParameters: name=${action.name}, '
      'deviceType=$_deviceType, resistance=${action.resistance}, cadence=${action.cadence}, '
      'command已下发',
    );
  }

  /// 按 FTMS 协议编码参数字节。
  /// - 0x02 速度：km/h × 100 → uint16 LE (2 字节)
  /// - 0x03 坡度：% × 10 → sint16 LE (2 字节)
  /// - 0x04 阻力：level × 10 → uint8 (1 字节)
  List<int> _buildValueBytes(int opCode, double value) {
    switch (opCode) {
      case 0x02:
        final raw = (value * 100).round();
        final clamped = raw & 0xFFFF;
        return [clamped & 0xFF, (clamped >> 8) & 0xFF];
      case 0x03:
        final raw = (value * 10).round();
        final clamped = raw & 0xFFFF;
        return [clamped & 0xFF, (clamped >> 8) & 0xFF];
      case 0x04:
        // Set Target Resistance Level: uint8, 0.1 unitless
        final raw = (value * 10).round().clamp(0, 255);
        return [raw];
      default:
        final raw = value.round();
        final clamped = raw & 0xFFFF;
        return [clamped & 0xFF, (clamped >> 8) & 0xFF];
    }
  }

  // ══════════════════════════════════════════════════════════
  // 纯本地模拟播放（无蓝牙）
  // ══════════════════════════════════════════════════════════

  /// 用户点击中央 Play → 启动定时器（播放中再点击=直接结束→结算页）
  void togglePlay() {
    // 🔴 屏态守卫：已进入中间态 / 已结算 → 不再响应 Play
    if (state.isPauseScreen || state.isStopScreen) {
      debugPrint(
        '🛑 [Play] togglePlay 被屏态守卫拦截 (isPauseScreen=${state.isPauseScreen}, isStopScreen=${state.isStopScreen})',
      );
      return;
    }
    if (state.isPlaying) {
      // 🔴 播放中再次点中央 Play → 直接结束课程 → 进结算页（不弹中间确认）
      debugPrint('▶️⏹️ [Play] togglePlay(playing) → manualFinish（直接结算）');
      manualFinish();
    } else {
      // 启动：重置音频终止布尔 + 隐藏按钮 + 启动定时器
      _audioTerminated = false;
      debugPrint('🛑 [AudioGuard] _audioTerminated = false（用户点击中央 Play，允许启音）');
      state = state.copyWith(
        isPlaying: true,
        showPlayButton: false,
        isPause: false,
        isPauseScreen: false,
      );
      _startTimers();
      _startBgmAndVoice();
      debugPrint('▶️ [Play] 用户启动播放，定时器已启动');
    }
  }

  /// 启动双定时器（播放 tick + 帧动画 tick）
  void _startTimers() {
    // 🔴 屏态守卫：中间态/结算态 不允许启动定时器
    if (state.isPauseScreen || state.isStopScreen) {
      debugPrint(
        '🛑 [Play] _startTimers 被屏态守卫拦截 (isPauseScreen=${state.isPauseScreen}, isStopScreen=${state.isStopScreen})',
      );
      return;
    }
    _playTickTimer?.cancel();
    _imageFrameTimer?.cancel();

    // 1) 每秒 1 次：驱动进度、运动数据
    _playTickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tickPlaySecond();
    });

    // 2) 每 100ms 1 次（10fps，对齐mock数据 imageFps）：驱动图片帧
    _imageFrameTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _tickImageFrame();
    });
  }

  /// 每秒 tick：累加 playIndexDuration / playTotalDuration + 计算进度 + 模拟运动数据
  void _tickPlaySecond() {
    // 🔴 屏态守卫：isPauseScreen 中间态 / isStopScreen 结算态 → 一律不执行 tick（不触发 _switchVoice / _finishPlay）
    if (state.isPause ||
        state.isPauseScreen ||
        state.isStopScreen ||
        !state.isPlaying) {
      return;
    }

    final actions = state.courseActions;
    if (actions.isEmpty) return;

    int playIndex = state.playIndex;
    int playIndexDuration = state.playIndexDuration + 1; // +1s
    int playTotalDuration = state.playTotalDuration + 1;
    int currentDuration = state.currentDuration;
    List<double> speedChart = List.from(state.speedChartData);

    // 当前段结束 → 进入下一段
    if (playIndexDuration >= currentDuration &&
        playIndex < actions.length - 1) {
      playIndex++;
      playIndexDuration = 0;
      currentDuration = actions[playIndex].duration;
      final newFps = actions[playIndex].imageFps;
      debugPrint(
        '🔁 [PlayTick] 阶段切换 playIndex=$playIndex, '
        'name=${actions[playIndex].name}, duration=${actions[playIndex].duration}s, fps=$newFps',
      );
      _switchVoice();
      // 动态调整帧动画帧率（根据新动作的imageFps）
      _restartImageFrameTimer(newFps);
      // Task 12: 动作切换时下发参数到设备
      _applyActionParameters(actions[playIndex]);
    }

    // 全部结束 → 显示结束页
    final totalDuration = state.totalPlayProgressDuration;
    if (playTotalDuration >= totalDuration) {
      _finishPlay();
      return;
    }

    // ─── Task 13: 每 60 秒采样一次阻力和坡度（用于结束页统计） ───
    if (playTotalDuration > 0 && playTotalDuration % 60 == 0) {
      _resistanceSamples.add(state.sportResistanceButton.round());
      _inclinationSamples.add(state.sportInclinationButton);
      debugPrint(
        '📊 [CourseStats] 采样: resistance=${state.sportResistanceButton.round()}, '
        'inclination=${state.sportInclinationButton}, sampleCount=${_resistanceSamples.length}',
      );
    }

    final percent = playTotalDuration / totalDuration.clamp(1, 1 << 30);

    // ─── 蓝牙模式 vs Mock 模式分支 ───
    // 有蓝牙连接时：_onDataReceived 负责更新运动数据，_tickPlaySecond 仅更新课程进度
    // 无蓝牙连接时：保留 mock 模拟运动数据逻辑
    final hasBluetooth = _dispatcher != null;
    if (hasBluetooth) {
      // 蓝牙模式：仅更新课程进度字段（运动数据由 _onDataReceived 更新）
      state = state.copyWith(
        playIndex: playIndex,
        playIndexDuration: playIndexDuration,
        playTotalDuration: playTotalDuration,
        currentDuration: currentDuration,
        playProgressPercent: percent,
      );
      return;
    }

    // ─── 模拟运动数据（按当前 action.cadence 为速度基准 + 轻微随机波动） ───
    final curAction = actions[playIndex];
    // 跑步机：速度用 action.cadence（20~45 km/h 量级）
    // 其他设备：阻力按钮决定显示强度
    final baseSpeed = curAction.cadence.toDouble(); // 速度基准
    final speedJitter = (playTotalDuration % 5) * 0.2; // ±0.4 抖动
    final deviceSpeed = (baseSpeed + speedJitter - 0.4).clamp(0.0, 50.0);

    final sportTimeStr = formatDuration(playTotalDuration);

    // 距离：速度 km/h * 秒 / 3600  →  km
    final distanceKmh = state.deviceType == FtmsDeviceType.rower
        ? (state.sportResistanceButton * 2.0)
        : deviceSpeed;
    final addDistance = distanceKmh / 3600.0;
    final prevDist = double.tryParse(state.sportDistance) ?? 0.0;
    final newDist = (prevDist + addDistance).toStringAsFixed(2);

    // 卡路里：近似 速度 * 0.02 累加
    final prevKcal = double.tryParse(state.sportCalories) ?? 0.0;
    final newKcal = (prevKcal + (deviceSpeed * 0.02)).toStringAsFixed(1);

    // 心率：(80 + action.resistance*12) ±随机递增，范围 60~180
    int curHr = int.tryParse(state.sportHeartRate) ?? 60;
    final targetHr = (80 + curAction.resistance * 12).clamp(60, 180);
    if (curHr < targetHr) curHr += (curHr < 100 ? 2 : 1);
    if (curHr > targetHr + 5) curHr -= 1;
    curHr = curHr.clamp(60, 180);

    // 速度采样（条形图）：每 5 秒一次
    if (playTotalDuration % 5 == 0) {
      speedChart.add(deviceSpeed.clamp(0.0, 40.0));
      if (speedChart.length > 20) speedChart.removeAt(0);
    }

    // 按钮速度同步到显示速度
    final displaySpeed = state.deviceType == FtmsDeviceType.rower
        ? state.sportStrokeRate
        : deviceSpeed.toStringAsFixed(1);

    // mock 模式下也跟踪最大值（用于结束页统计）
    if ((deviceSpeed * 3.0).round() > _maxCadence) {
      _maxCadence = (deviceSpeed * 3.0).round();
    }
    if (curHr > _maxHeartRate) _maxHeartRate = curHr;
    final mockPace = _calculatePace(deviceSpeed);
    if (mockPace > _maxPace) _maxPace = mockPace;

    state = state.copyWith(
      playIndex: playIndex,
      playIndexDuration: playIndexDuration,
      playTotalDuration: playTotalDuration,
      currentDuration: currentDuration,
      playProgressPercent: percent,
      sportTime: sportTimeStr,
      sportDistance: newDist,
      sportCalories: newKcal,
      sportSpeed: displaySpeed,
      sportDeviceSpeed: deviceSpeed,
      sportHeartRate: curHr.toString(),
      sportCadence: (deviceSpeed * 3.0).round().toString(),
      speedChartData: speedChart,
    );
  }

  /// 每 100ms tick：推进 imagePlayIndex 帧
  void _tickImageFrame() {
    // 🔴 屏态守卫：isPauseScreen 中间态 / isStopScreen 结算态 → 不推进图片帧
    if (state.isPause ||
        state.isPauseScreen ||
        state.isStopScreen ||
        !state.isPlaying) {
      return;
    }
    final actions = state.courseActions;
    if (actions.isEmpty) return;
    final cur = actions[state.playIndex.clamp(0, actions.length - 1)];
    int nextFrame = state.imagePlayIndex + 1;
    if (nextFrame >= cur.imageLength) nextFrame = 0;
    state = state.copyWith(imagePlayIndex: nextFrame);
  }

  // ══════════════════════════════════════════════════════════
  // 结束页数据统计计算（Task 13）
  // ══════════════════════════════════════════════════════════

  /// 配速计算：配速 = 60 / speed（min/km），speed 为 0 时返回 0。
  double _calculatePace(double speedKmh) {
    if (speedKmh <= 0) return 0.0;
    return 60.0 / speedKmh;
  }

  /// 完成度计算：完成度 = actual / total * 100。
  double _calculateFinishPercent(double actualDistance, double totalDistance) {
    if (totalDistance <= 0) return 0.0;
    return (actualDistance / totalDistance * 100).clamp(0.0, 100.0);
  }

  /// 平均阻力计算：采样列表平均值。
  double _calculateAvgResistance() {
    if (_resistanceSamples.isEmpty) return 0.0;
    final sum = _resistanceSamples.reduce((a, b) => a + b);
    return sum / _resistanceSamples.length;
  }

  /// 平均坡度计算：采样列表平均值。
  double _calculateAvgInclination() {
    if (_inclinationSamples.isEmpty) return 0.0;
    final sum = _inclinationSamples.reduce((a, b) => a + b);
    return sum / _inclinationSamples.length;
  }

  /// 平均桨频计算：平均桨频 = totalStrokes / (elapsedSeconds / 60)。
  double _calculateAvgStrokeRate(int totalStrokes, int elapsedSeconds) {
    if (elapsedSeconds <= 0) return 0.0;
    return totalStrokes / (elapsedSeconds / 60.0);
  }

  /// 格式化配速：min/km → mm:ss 字符串。
  String _formatPace(double paceMinPerKm) {
    if (paceMinPerKm <= 0) return '00:00';
    final totalSeconds = (paceMinPerKm * 60).round();
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  /// 构建结束页统计数据值列表（根据设备类型选择对应数据项）。
  /// 用真实统计计算结果替换 mock 值。
  List<String> _buildFinishDataValues() {
    final deviceType = state.deviceType;
    final elapsedSeconds = state.playTotalDuration;
    final sportTimeStr = formatDuration(elapsedSeconds);
    final distance = double.tryParse(state.sportDistance) ?? 0.0;
    final calories = double.tryParse(state.sportCalories) ?? 0.0;
    final speed = state.sportDeviceSpeed;
    final pace = _calculatePace(speed);
    final paceStr = _formatPace(pace);
    final maxPaceStr = _formatPace(_maxPace);
    final avgResistance = _calculateAvgResistance();
    final avgInclination = _calculateAvgInclination();
    final totalStrokes = int.tryParse(state.sportStrokeCount) ?? 0;
    final avgStrokeRate = _calculateAvgStrokeRate(totalStrokes, elapsedSeconds);
    // 完成度：基于已播放时长 / 总时长（复用 _calculateFinishPercent 通用计算）
    final finishPercent = _calculateFinishPercent(
      elapsedSeconds.toDouble(),
      state.totalPlayProgressDuration.toDouble(),
    );
    final cadenceVal = int.tryParse(state.sportCadence) ?? 0;

    debugPrint(
      '📊 [CourseStats] 统计计算: time=$sportTimeStr, dist=${distance.toStringAsFixed(2)}km, '
      'kcal=${calories.toStringAsFixed(0)}, pace=$paceStr, maxPace=$maxPaceStr, '
      'maxCadence=$_maxCadence, maxHr=$_maxHeartRate, avgResistance=${avgResistance.toStringAsFixed(1)}, '
      'avgInclination=${avgInclination.toStringAsFixed(1)}, avgStrokeRate=${avgStrokeRate.toStringAsFixed(1)}, '
      'totalStrokes=$totalStrokes, finish%=${finishPercent.toStringAsFixed(1)}',
    );

    switch (deviceType) {
      case FtmsDeviceType.indoorBike:
        return [
          sportTimeStr, // Sport Time
          distance.toStringAsFixed(2), // Total Distance (km)
          calories.toStringAsFixed(0), // Total Calories (kcal)
          paceStr, // Pace (min/km)
          cadenceVal.toString(), // Avg Cadence (rpm)
          _maxCadence.toString(), // Max Cadence (rpm)
          _maxHeartRate.toString(), // Max Heart Rate (bpm)
          cadenceVal.toString(), // Total Cadence (近似)
          '00:00', // Rest Time
          finishPercent.toStringAsFixed(1), // Completion (%)
        ];
      case FtmsDeviceType.treadmill:
        return [
          sportTimeStr, // Sport Time
          distance.toStringAsFixed(2), // Total Distance (km)
          calories.toStringAsFixed(0), // Total Calories (kcal)
          paceStr, // Pace (min/km)
          maxPaceStr, // Max Pace (min/km)
          _maxCadence.toString(), // Max Cadence (rpm)
          _maxHeartRate.toString(), // Max Heart Rate (bpm)
          cadenceVal.toString(), // Avg Cadence (rpm)
          cadenceVal.toString(), // Total Cadence (近似)
          finishPercent.toStringAsFixed(1), // Completion (%)
        ];
      case FtmsDeviceType.crossTrainer:
        return [
          sportTimeStr, // Sport Time
          distance.toStringAsFixed(2), // Total Distance (km)
          calories.toStringAsFixed(0), // Total Calories (kcal)
          paceStr, // Pace (min/km)
          cadenceVal.toString(), // Avg Cadence (rpm)
          cadenceVal.toString(), // Total Cadence (近似)
          _maxCadence.toString(), // Max Cadence (rpm)
          _maxHeartRate.toString(), // Max Heart Rate (bpm)
          '00:00', // Rest Time
          finishPercent.toStringAsFixed(1), // Completion (%)
        ];
      case FtmsDeviceType.rower:
        return [
          sportTimeStr, // Sport Time
          distance.toStringAsFixed(2), // Total Distance (km)
          calories.toStringAsFixed(0), // Total Calories (kcal)
          avgStrokeRate.toStringAsFixed(0), // Avg Strokes (spm)
          avgResistance.toStringAsFixed(0), // Avg Resistance
          totalStrokes.toString(), // Total Strokes
          _maxCadence.toString(), // Max Stroke Rate (spm)
          _maxHeartRate.toString(), // Avg Heart Rate (bpm)
          '00:00', // Rest Time
          finishPercent.toStringAsFixed(1), // Completion (%)
        ];
      case FtmsDeviceType.strengthStation:
        // 力量站预留：暂与单车使用相同的结束页结构
        return _buildFinishDataValuesForIndoorBike(
          sportTimeStr,
          distance,
          calories,
          paceStr,
          cadenceVal,
          finishPercent,
        );
    }
  }

  /// 力量站复用单车结束页数据构建（内部辅助方法）。
  List<String> _buildFinishDataValuesForIndoorBike(
    String sportTimeStr,
    double distance,
    double calories,
    String paceStr,
    int cadenceVal,
    double finishPercent,
  ) {
    return [
      sportTimeStr,
      distance.toStringAsFixed(2),
      calories.toStringAsFixed(0),
      paceStr,
      cadenceVal.toString(),
      _maxCadence.toString(),
      _maxHeartRate.toString(),
      cadenceVal.toString(),
      '00:00',
      finishPercent.toStringAsFixed(1),
    ];
  }

  /// 播放完成 → 进入结束页
  /// 🔴 顺序：先 setState + _audioTerminated=true（同步锁，防 await 穿透
  void _finishPlay() {
    // 🔴 第 0 步：同步锁布尔（优先级最高，比 setState 还先）
    _audioTerminated = true;
    debugPrint(
      '🛑 [AudioGuard] _finishPlay() → _audioTerminated = true（禁止再启音）',
    );
    // Task 13: 计算结束页统计数据
    final finishDataValues = _buildFinishDataValues();
    final avgResistance = _calculateAvgResistance();
    final avgInclination = _calculateAvgInclination();
    final totalStrokes = int.tryParse(state.sportStrokeCount) ?? 0;
    final avgStrokeRate = _calculateAvgStrokeRate(
      totalStrokes,
      state.playTotalDuration,
    );
    final finishPercent = _calculateFinishPercent(
      state.playTotalDuration.toDouble(),
      state.totalPlayProgressDuration.toDouble(),
    );
    final pace = _calculatePace(state.sportDeviceSpeed);
    debugPrint('📊 [CourseStats] _finishPlay: 结束页统计数据已计算完成');
    // 🔴 第一步：先写 state（锁 isStopScreen=true + 填充统计字段）
    state = state.copyWith(
      isPlaying: false,
      isStopScreen: true,
      screenStatus: GymPlayScreenStatus.finished,
      showPlayButton: false,
      sportTime: formatDuration(state.totalPlayProgressDuration),
      finishDataValues: finishDataValues,
      maxCadence: _maxCadence,
      maxHeartRate: _maxHeartRate,
      maxPace: _maxPace,
      avgResistance: avgResistance,
      avgInclination: avgInclination,
      avgStrokeRate: avgStrokeRate,
      finishPercent: finishPercent,
    );
    // 🔴 第二步：cancel + stop + seek zero
    _playTickTimer?.cancel();
    _imageFrameTimer?.cancel();
    _stopAudio();
    unawaited(_bgmPlayer.seek(Duration.zero));
    unawaited(_voicePlayer.seek(Duration.zero));
    debugPrint('🏁 [Play] 课程播放完成，已进入结束页（先锁屏再stop）');
    // 抑制未使用变量警告（pace 用于日志调试参考）
    debugPrint('📊 [CourseStats] final pace=${_formatPace(pace)}');
  }

  /// 用户主动结束课程 → 进入结束页（复刻原版返回按钮逻辑）
  /// 🔴 顺序：先 _audioTerminated=true（同步锁
  void manualFinish() {
    // 🔴 第 0 步：同步锁布尔（优先级最高，在任何 setState/await 之前）
    _audioTerminated = true;
    debugPrint(
      '🛑 [AudioGuard] manualFinish() → _audioTerminated = true（禁止再启音）',
    );
    // Task 13: 计算结束页统计数据（用户主动结束也填充统计）
    final finishDataValues = _buildFinishDataValues();
    final avgResistance = _calculateAvgResistance();
    final avgInclination = _calculateAvgInclination();
    final totalStrokes = int.tryParse(state.sportStrokeCount) ?? 0;
    final avgStrokeRate = _calculateAvgStrokeRate(
      totalStrokes,
      state.playTotalDuration,
    );
    final finishPercent = _calculateFinishPercent(
      state.playTotalDuration.toDouble(),
      state.totalPlayProgressDuration.toDouble(),
    );
    debugPrint('📊 [CourseStats] manualFinish: 结束页统计数据已计算完成');
    // 🔴 第一步：锁屏态（先写 state，拦截 _switchVoice/_tickPlaySecond）
    state = state.copyWith(
      isPlaying: false,
      isPause: false,
      isPauseScreen: false,
      isStopScreen: true,
      screenStatus: GymPlayScreenStatus.finished,
      showPlayButton: false,
      sportTime: formatDuration(state.playTotalDuration),
      finishDataValues: finishDataValues,
      maxCadence: _maxCadence,
      maxHeartRate: _maxHeartRate,
      maxPace: _maxPace,
      avgResistance: avgResistance,
      avgInclination: avgInclination,
      avgStrokeRate: avgStrokeRate,
      finishPercent: finishPercent,
    );
    // 🔴 第二步：cancel + stop + seek zero
    _playTickTimer?.cancel();
    _imageFrameTimer?.cancel();
    _stopAudio();
    unawaited(_bgmPlayer.seek(Duration.zero));
    unawaited(_voicePlayer.seek(Duration.zero));
    debugPrint('🏁 [Play] 用户主动结束课程，进入结束页（先锁屏再stop）');
  }

  // ══════════════════════════════════════════════════════════
  // 暂停/恢复/退出
  // ══════════════════════════════════════════════════════════

  /// 暂停运动：暂停定时器+音频，进入暂停覆盖层
  void pauseSport() {
    if (!state.isPlaying || state.isPauseScreen) {
      debugPrint(
        '⚠️ [PlayNotifier] pauseSport 被守卫拦截 (isPlaying=${state.isPlaying}, isPauseScreen=${state.isPauseScreen})',
      );
      return;
    }
    debugPrint('⏸️ [PlayNotifier] pauseSport 暂停运动');
    state = state.copyWith(
      isPause: true,
      isPauseScreen: true,
      showPlayButton: true,
    );
    // 暂停音频（保留位置）
    unawaited(_bgmPlayer.pause());
    unawaited(_voicePlayer.pause());
  }

  /// 恢复运动：恢复定时器+音频，关闭暂停覆盖层
  void resumeSport() {
    if (!state.isPauseScreen) {
      debugPrint(
        '⚠️ [PlayNotifier] resumeSport 被守卫拦截 (isPauseScreen=${state.isPauseScreen})',
      );
      return;
    }
    debugPrint('▶️ [PlayNotifier] resumeSport 恢复运动');
    state = state.copyWith(
      isPause: false,
      isPauseScreen: false,
      showPlayButton: false,
      isPlaying: true,
    );
    // 恢复音频（从暂停位置继续播放）
    unawaited(_bgmPlayer.play());
    unawaited(_voicePlayer.play());
  }

  /// 退出课程播放页，重置所有状态为loading
  void exitToDetail() {
    debugPrint('🚪 [PlayNotifier] exitToDetail 退出课程播放');
    _playTickTimer?.cancel();
    _imageFrameTimer?.cancel();
    _stopAudio();
    _audioTerminated = true;
    state = state.copyWith(
      screenStatus: GymPlayScreenStatus.loading,
      isPause: false,
      isPauseScreen: false,
      isPlaying: false,
      showPlayButton: false,
      isStopScreen: false,
      playIndex: 0,
      playIndexDuration: 0,
      playTotalDuration: 0,
      playProgressPercent: 0.0,
      imagePlayIndex: 0,
    );
  }

  void stopSport() {
    // 兼容API：直接触发 finish（真机测试点击返回按钮用）
    _finishPlay();
  }

  void showStopScreen(bool value) {
    state = state.copyWith(isStopScreen: value);
  }

  // ══════════════════════════════════════════════════════════
  // 控制按钮 +/−（纯本地 state 修改，预留蓝牙指令接口）
  // ══════════════════════════════════════════════════════════

  // ─── 单次点击版本 ───

  void speedAdd() {
    final current = state.sportSpeedButton;
    final v = (current + 0.5).clamp(0.0, 50.0);
    final newValue = double.parse(v.toStringAsFixed(1));
    _dispatcher?.dispatch(
      FtmsCommand(0x02, _buildValueBytes(0x02, newValue)),
    );
    state = state.copyWith(sportSpeedButton: newValue);
    debugPrint('📤 [CourseControl] speedAdd: $current → $newValue');
  }

  void speedDown() {
    final current = state.sportSpeedButton;
    final v = (current - 0.5).clamp(0.0, 50.0);
    final newValue = double.parse(v.toStringAsFixed(1));
    _dispatcher?.dispatch(
      FtmsCommand(0x02, _buildValueBytes(0x02, newValue)),
    );
    state = state.copyWith(sportSpeedButton: newValue);
    debugPrint('📤 [CourseControl] speedDown: $current → $newValue');
  }

  void inclinationAdd() {
    final current = state.sportInclinationButton;
    final v = (current + 1.0).clamp(-5.0, 15.0);
    final newValue = double.parse(v.toStringAsFixed(1));
    _dispatcher?.dispatch(
      FtmsCommand(0x03, _buildValueBytes(0x03, newValue)),
    );
    state = state.copyWith(sportInclinationButton: newValue);
    debugPrint('📤 [CourseControl] inclinationAdd: $current → $newValue');
  }

  void inclinationDown() {
    final current = state.sportInclinationButton;
    final v = (current - 1.0).clamp(-5.0, 15.0);
    final newValue = double.parse(v.toStringAsFixed(1));
    _dispatcher?.dispatch(
      FtmsCommand(0x03, _buildValueBytes(0x03, newValue)),
    );
    state = state.copyWith(sportInclinationButton: newValue);
    debugPrint('📤 [CourseControl] inclinationDown: $current → $newValue');
  }

  void resistanceAdd() {
    final current = state.sportResistanceButton;
    final v = (current + 1.0).clamp(1.0, 20.0);
    final newValue = double.parse(v.toStringAsFixed(1));
    _dispatcher?.dispatch(
      FtmsCommand(0x04, _buildValueBytes(0x04, newValue)),
    );
    state = state.copyWith(sportResistanceButton: newValue);
    debugPrint('📤 [CourseControl] resistanceAdd: $current → $newValue');
  }

  void resistanceDown() {
    final current = state.sportResistanceButton;
    final v = (current - 1.0).clamp(1.0, 20.0);
    final newValue = double.parse(v.toStringAsFixed(1));
    _dispatcher?.dispatch(
      FtmsCommand(0x07, [0x0B, ..._buildValueBytes(newValue)]),
    );
    state = state.copyWith(sportResistanceButton: newValue);
    debugPrint('📤 [CourseControl] resistanceDown: $current → $newValue');
  }

  // ─── 长按版本（步进更小，连续触发，使用 debounce 模式） ───

  void speedAddLongPress() {
    final v = (state.sportSpeedButton + 0.2).clamp(0.0, 50.0);
    final newValue = double.parse(v.toStringAsFixed(1));
    _dispatcher?.dispatch(
      FtmsCommand(0x07, [0x02, ..._buildValueBytes(newValue)]),
    );
    state = state.copyWith(sportSpeedButton: newValue);
  }

  void speedDownLongPress() {
    final v = (state.sportSpeedButton - 0.2).clamp(0.0, 50.0);
    final newValue = double.parse(v.toStringAsFixed(1));
    _dispatcher?.dispatch(
      FtmsCommand(0x07, [0x02, ..._buildValueBytes(newValue)]),
    );
    state = state.copyWith(sportSpeedButton: newValue);
  }

  void inclinationAddLongPress() {
    final v = (state.sportInclinationButton + 0.5).clamp(-5.0, 15.0);
    final newValue = double.parse(v.toStringAsFixed(1));
    _dispatcher?.dispatch(
      FtmsCommand(0x07, [0x03, ..._buildValueBytes(newValue)]),
    );
    state = state.copyWith(sportInclinationButton: newValue);
  }

  void inclinationDownLongPress() {
    final v = (state.sportInclinationButton - 0.5).clamp(-5.0, 15.0);
    final newValue = double.parse(v.toStringAsFixed(1));
    _dispatcher?.dispatch(
      FtmsCommand(0x07, [0x03, ..._buildValueBytes(newValue)]),
    );
    state = state.copyWith(sportInclinationButton: newValue);
  }

  void resistanceAddLongPress() {
    final v = (state.sportResistanceButton + 0.5).clamp(1.0, 20.0);
    final newValue = double.parse(v.toStringAsFixed(1));
    _dispatcher?.dispatch(
      FtmsCommand(0x07, [0x0B, ..._buildValueBytes(newValue)]),
    );
    state = state.copyWith(sportResistanceButton: newValue);
  }

  void resistanceDownLongPress() {
    final v = (state.sportResistanceButton - 0.5).clamp(1.0, 20.0);
    final newValue = double.parse(v.toStringAsFixed(1));
    _dispatcher?.dispatch(
      FtmsCommand(0x07, [0x0B, ..._buildValueBytes(newValue)]),
    );
    state = state.copyWith(sportResistanceButton: newValue);
  }

  // ─── 长按结束保护窗口（对接 SportControlPanel.onLongPressEnd） ───

  /// 长按结束时调用，开启 1500ms 保护窗口，防止设备 0x2ADA 回调覆盖本地按钮值。
  void longPressEnd() {
    _syncGuard?.beginGuardWindow(const Duration(milliseconds: 1500));
    debugPrint('🛡️ [CourseControl] longPressEnd: 保护窗口已开启 (1500ms)');
  }

  // ══════════════════════════════════════════════════════════
  // 工具方法
  // ══════════════════════════════════════════════════════════

  /// 动态重建帧动画定时器（根据当前动作的imageFps调整帧率）
  void _restartImageFrameTimer(int imageFps) {
    // 防止帧率为0或负数
    final fps = imageFps < 1 ? 10 : imageFps;
    final intervalMs = (1000 / fps).round();
    debugPrint('🎬 [Frame] 重建帧动画定时器: fps=$fps, interval=${intervalMs}ms');

    _imageFrameTimer?.cancel();
    _imageFrameTimer = Timer.periodic(
      Duration(milliseconds: intervalMs),
      (_) => _tickImageFrame(),
    );
  }

  String formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  /// 进度条分段百分比列表（对齐旧版 countBarLineDataItem）
  List<double> barLinePercentages() {
    final total = state.courseActions.fold<int>(0, (a, b) => a + b.duration);
    if (total == 0) return List.filled(state.courseActions.length, 0.0);
    return state.courseActions.map((a) => a.duration / total).toList();
  }
}
