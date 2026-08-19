import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ftms/device_time_normalizer.dart';
import '../../../core/ftms/ftms_command_dispatcher.dart';
import '../../../core/ftms/ftms_control_config.dart';
import '../../../core/ftms/ftms_control_response.dart';
import '../../../core/ftms/ftms_data_sync_guard.dart';
import '../../../core/ftms/ftms_device_capability_reader.dart';
import '../../../core/ftms/ftms_device_data.dart';
import '../../../core/ftms/ftms_device_type.dart';
import '../../../core/ftms/ftms_param_sync_engine.dart';
import '../../../core/ftms/ftms_service_base.dart';
import '../../../core/ftms/ftms_service_provider.dart';
import '../../../core/ftms/ftms_status_parser.dart';
import '../../../core/ftms/sport_timer.dart';
import '../../record/models/sport_record.dart';
import '../../record/repositories/sport_record_local_repository.dart';
import '../states/gym_course_detail_state.dart';
import '../states/gym_course_play_state.dart';
import 'gym_course_detail_notifier.dart';
import 'quick_start_notifier.dart';

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

  /// 🔴 资源清理标志（防止清理后定时器回调继续执行）
  /// 语义：true= 已经触发了 cleanupOnExit → 定时器回调必须立刻停止
  bool _isCleanedUp = false;

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

  /// 设备坡度支持判定缓存（0x2AD5 读取结果，仅跑步机有效）。
  /// null = 尚未读到设备能力（按设备类型默认显示坡度按钮）。
  /// 作用：initCourseContext 异步重建 state 时保留判定结果，
  /// 避免 _buildPlayState 的硬编码覆盖已读取的能力值（竞态）。
  bool? _deviceInclinationSupported;

  /// 设备速度支持判定缓存（0x2AD4 读取结果，仅跑步机有效）。
  /// null = 尚未读到设备能力（按设备类型默认显示速度按钮）。
  bool? _deviceSpeedSupported;

  /// 设备阻力支持判定缓存（0x2AD6 读取结果，仅非跑步机有效）。
  /// null = 尚未读到设备能力（按设备类型默认显示阻力按钮）。
  bool? _deviceResistanceSupported;

  /// 运动计时器（本地计时 + 设备时间校准）
  SportTimer? _sportTimer;

  /// 设备时间归一化器（补偿 60 秒循环归零）
  DeviceTimeNormalizer? _timeNormalizer;

  /// 数据同步保护器（长按松手后屏蔽设备回调）
  FtmsDataSyncGuard? _syncGuard;

  /// 参数同步引擎（防弹跳核心：命令锁 + 匹配式同步 + 防超调）
  final FtmsParamSyncEngine _paramSyncEngine = FtmsParamSyncEngine();

  /// FTMS 指令调度器（debounce / immediate 双模式）
  FtmsCommandDispatcher? _dispatcher;

  /// 实时数据流订阅
  StreamSubscription<FtmsDeviceData>? _dataSubscription;

  /// 设备状态流订阅
  StreamSubscription<FtmsStatusEvent>? _statusSubscription;

  /// 控制点回执流订阅（0x2AD9 Indicate，用于 dispatchTracked 确认）
  StreamSubscription<FtmsControlResponse>? _responseSubscription;

  /// 蓝牙连接状态流订阅（R5：断链即退出课程到主界面）
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;

  /// 数据流订阅重试计数（Task 4：service 未就绪时每 2 秒重试，上限 15 次）
  int _streamRetryCount = 0;

  /// 数据流订阅重试定时器（仅用于初始绑定场景；断链后立即取消，禁止重绑）
  Timer? _streamRetryTimer;

  // ══════════════════════════════════════════════════════════
  // 按钮控制配置（动态化：最大值/最小值/步进值全部设备上报优先）══════════
  // ══════════════════════════════════════════════════════════

  // —— 回退默认常量（设备未上报范围时使用，数值与原硬编码一致） ——
  static const double _speedStepFallback = 0.5;
  static const double _speedMinFallback = 0.0;
  static const double _speedMaxFallback = 50.0;
  static const double _inclinationStepFallback = 1.0;
  static const double _inclinationMinFallback = -5.0;
  static const double _inclinationMaxFallback = 15.0;
  static const double _resistanceStepFallback = 1.0;
  static const double _resistanceMinFallback = 1.0;
  static const double _resistanceMaxFallback = 20.0;

  // —— 动态取值 getter（设备上报优先，未读到回退常量） ——

  /// 速度上限（km/h）
  double get _speedMaxEff =>
      state.speedRangeMax > 0 ? state.speedRangeMax : _speedMaxFallback;

  /// 速度下限（km/h）
  double get _speedMinEff =>
      state.speedRangeMin > 0 ? state.speedRangeMin : _speedMinFallback;

  /// 速度单次点击步进（km/h）
  double get _speedStepEff =>
      state.speedRangeStep > 0 ? state.speedRangeStep : _speedStepFallback;

  /// 速度长按步进（km/h，动态时为单次步进一半）
  double get _speedLongPressStepEff => state.speedRangeStep > 0
      ? (state.speedRangeStep / 2 * 10).round() / 10
      : 0.2;

  /// 坡度上限（%）
  double get _inclinationMaxEff => state.inclinationRangeMax > 0
      ? state.inclinationRangeMax
      : _inclinationMaxFallback;

  /// 坡度下限（%）
  double get _inclinationMinEff => state.inclinationRangeMin != 0
      ? state.inclinationRangeMin
      : _inclinationMinFallback;

  /// 坡度单次点击步进（%）
  double get _inclinationStepEff => state.inclinationRangeStep > 0
      ? state.inclinationRangeStep
      : _inclinationStepFallback;

  /// 坡度长按步进（%）
  double get _inclinationLongPressStepEff => state.inclinationRangeStep > 0
      ? (state.inclinationRangeStep / 2 * 10).round() / 10
      : 0.5;

  /// 阻力上限
  double get _resistanceMaxEff => state.resistanceRangeMax > 0
      ? state.resistanceRangeMax
      : _resistanceMaxFallback;

  /// 阻力下限
  double get _resistanceMinEff => state.resistanceRangeMin > 0
      ? state.resistanceRangeMin
      : _resistanceMinFallback;

  /// 阻力单次点击步进
  double get _resistanceStepEff => state.resistanceRangeStep > 0
      ? state.resistanceRangeStep
      : _resistanceStepFallback;

  /// 阻力长按步进
  double get _resistanceLongPressStepEff => state.resistanceRangeStep > 0
      ? (state.resistanceRangeStep / 2 * 10).round() / 10
      : 0.5;

  // ─── 结束页统计采样列表（Task 13） ───

  /// 阻力采样列表（每 60 秒采样一次）
  final List<int> _resistanceSamples = [];

  /// 坡度采样列表（每 60 秒采样一次）
  final List<double> _inclinationSamples = [];

  /// 速度采样列表（每 3 秒采样一次，供结束页速度图表）
  final List<double> _speedSamples = [];

  /// 上次速度采样的累计秒数（用于 3 秒间隔控制）
  int _lastSpeedSampleSec = 0;

  /// 最大踏频（实时跟踪）
  int _maxCadence = 0;

  /// 最大心率（实时跟踪）
  int _maxHeartRate = 0;

  /// 最大配速（实时跟踪，min/km）
  double _maxPace = 0.0;

  /// ─── 结算页统计新增字段（2026-08-18 差异修正） ───

  /// 最大桨频（划船机专用通道，实时跟踪，对应旧 saveMaxStorkeRate）
  int _maxStrokeRate = 0;

  /// 休息时间累积秒数（对应旧 saveRestTime：播放中且划船机桨频=0 /
  /// 其他设备速度=0 时每秒 +1）
  int _restSeconds = 0;

  /// 当前配速（对应旧 savePace：60/速度，roundToDouble，速度为 0 保持旧值）
  double _lastPace = 0.0;

  /// 设备运动秒数（对应旧 saveSportTime = realSportTime，蓝牙数据流更新）
  int _deviceSportSeconds = 0;

  /// 课程总里程（米，动作 distance 求和，对应旧 totalDistance；完成度分母）
  int _courseTotalDistance = 0;

  /// 课程总踏频（动作 cadence 求和，对应旧 totalCadence；踏频效率分母）
  int _courseTotalCadence = 0;

  /// 跑步机目标坡度（动作 resistance 均值 ~/ 10，对应旧 device10averageInclination）
  int _device10AvgInclination = 0;

  /// 速度图表数据点（动作切换时记录，对应旧 speedChartList：
  /// 划船机记「平均桨频+当前速度」两点，其他设备记当前速度一点）
  final List<double> _speedCurvePoints = [];

  /// 结算统计秒数来源：优先设备运动秒数（蓝牙），无设备数据时回退播放秒数
  int get _elapsedSportSeconds =>
      _deviceSportSeconds > 0 ? _deviceSportSeconds : state.playTotalDuration;

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
      _responseSubscription?.cancel();
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
            '1.3',
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
            '1.3',
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
            '1.3',
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
            '1.3',
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
    // 🔴 重置清理标志，允许定时器重新启动
    _isCleanedUp = false;
    _audioTerminated = false;
    _playTickTimer?.cancel();
    _imageFrameTimer?.cancel();
    _stopAudio();
    // 🔧 复位音频进度到 0，保证下次播放从头开始（播放器不 dispose，可复用）
    unawaited(_bgmPlayer.seek(Duration.zero));
    unawaited(_voicePlayer.seek(Duration.zero));
    // 取消订阅重试定时器并重置计数（新会话重新绑定）
    _streamRetryTimer?.cancel();
    _streamRetryTimer = null;
    _streamRetryCount = 0;
    // 取消数据流订阅
    _dataSubscription?.cancel();
    _statusSubscription?.cancel();
    _responseSubscription?.cancel();
    _connectionStateSubscription?.cancel();
    // 解锁参数同步引擎所有维度
    _paramSyncEngine.unlockAll();
    // Task 13: 重置统计采样列表
    _resistanceSamples.clear();
    _inclinationSamples.clear();
    _speedSamples.clear();
    _maxCadence = 0;
    _maxHeartRate = 0;
    _maxPace = 0.0;
    // 结算统计新增字段重置（2026-08-18 差异修正）
    _maxStrokeRate = 0;
    _restSeconds = 0;
    _lastPace = 0.0;
    _deviceSportSeconds = 0;
    _lastSpeedSampleSec = 0;
    _speedCurvePoints.clear();
    // 🔧 运动计时器停止并归零（SportTimer 无 reset()，stop() = 停止+归零）
    _sportTimer?.stop();
    // 🔧 重置设备时间归一化器（🔴 修复时间跨会话叠加的根因）：
    // normalizer 实例跨会话复用，若不重置，_cycleCount（60s 循环补偿圈数）
    // 与 _lastRawElapsed 残留——新会话首帧 raw=0 < 旧值 会被误判为
    // "设备循环归零"导致 cycleCount++，显示时间逐次叠加（1min→2min→...）
    _timeNormalizer?.reset();
    state = state.copyWith(
      screenStatus: GymPlayScreenStatus.loading,
      isPause: false,
      isPauseScreen: false,
      isStopScreen: false,
      // 重置断链标记（新会话）
      isDeviceConnectionLost: false,
      showPlayButton: false,
      isPlaying: false,
      // 清零所有运动数据
      sportTime: '00:00',
      deviceSportSeconds: 0,
      sportDistance: '0.00',
      sportCalories: '0.0',
      sportSpeed: '0.0',
      sportDeviceSpeed: 0.0,
      sportHeartRate: '0',
      sportCadence: '0',
      sportStrokeRate: '0',
      sportStrokeCount: '0',
      sportInclination: '0.0',
      sportResistance: '0',
      // 重置进度
      playIndex: 0,
      playIndexDuration: 0,
      playTotalDuration: 0,
      playProgressPercent: 0.0,
      imagePlayIndex: 0,
      speedChartData: [],
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
      // 🔴 防御：新会话进入必经此处，重置归一化器避免 _cycleCount 跨会话叠加
      // （resetToLoading 已重置；此处兜底防其他入口直接调 initCourseContext）
      _timeNormalizer?.reset();
      _syncGuard ??= FtmsDataSyncGuard();
      _setupDispatcher();
      _setupStreams();
      debugPrint(
        '📡 [CoursePlay] FTMS 初始化完成: deviceType=$_deviceType, '
        'dispatcher=${_dispatcher != null ? "ready" : "null(mock模式)"}, '
        'dataStream=${_dataSubscription != null ? "subscribed" : "无订阅"}',
      );

      // 🔴 模块分离：课程页接管设备 → 暂停快速开始的设备流监听。
      // QuickStart Notifier 是 keepAlive，页面退出后订阅仍存活，
      // 不暂停会双重响应同一设备事件（双重 confirmReceipt / 双重状态更新）。
      // try-catch 隔离：快速开始 Provider 异常不影响课程页初始化（两模块独立）。
      try {
        ref.read(quickStartProvider.notifier).pauseListening();
      } catch (e) {
        debugPrint('ℹ️ [CoursePlay] 快速开始 Provider 不可用，跳过分离（$e）');
      }

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

    // G12 修正：Training Intensity 等级从课程详情 courseTitle.level 读取
    // （旧代码 titleProperties().level，1~5；解析失败回退 3）
    final detailState = ref.read(gymCourseDetailProvider);
    final level = int.tryParse(detailState.courseTitle?.level ?? '') ?? 3;

    return _buildPlayState(
      actions: playActions,
      deviceType: deviceType,
      courseTitle: '训练课程',
      difficulty: '进阶',
      level: level.clamp(1, 5),
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

    // ─── 课程级统计预计算（对应旧 L1049-1073：完成度/踏频效率/坡度评分的分子分母） ───
    if (actions.isNotEmpty) {
      // 课程总里程（米，动作 distance 求和）→ 完成度分母
      _courseTotalDistance = actions.fold<int>(0, (a, b) => a + b.distance);
      // 课程总踏频（动作 cadence 求和）→ 踏频效率分母
      _courseTotalCadence = actions.fold<int>(0, (a, b) => a + b.cadence);
      // 跑步机目标坡度 = 动作 resistance 均值 ~/ 10（旧 device10averageInclination）
      final resistanceSum = actions.fold<int>(0, (a, b) => a + b.resistance);
      _device10AvgInclination = (resistanceSum ~/ actions.length) ~/ 10;
    } else {
      _courseTotalDistance = 0;
      _courseTotalCadence = 0;
      _device10AvgInclination = 0;
    }

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
      // 坡度支持判定：跑步机优先复用 0x2AD5 读取缓存（防 state 重建时
      // 硬编码覆盖已读取结果）；未读取到设备能力前按设备类型默认显示。
      // 非跑步机固定不支持坡度按钮。
      hasInclinationSupport: deviceType == FtmsDeviceType.treadmill
          ? (_deviceInclinationSupported ?? true)
          : false,
      // 速度支持判定：同坡度机制，复用 0x2AD4 读取缓存（仅跑步机显示速度按钮）。
      hasSpeedSupport: deviceType == FtmsDeviceType.treadmill
          ? (_deviceSpeedSupported ?? true)
          : false,
      // 阻力支持判定：同坡度机制，复用 0x2AD6 读取缓存（非跑步机显示阻力按钮）。
      hasResistanceSupport: deviceType != FtmsDeviceType.treadmill
          ? (_deviceResistanceSupported ?? true)
          : false,
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

  /// 初始化 FTMS 指令调度器（Task 3：无条件创建，getter 模式动态取 service）。
  void _setupDispatcher() {
    // 🔧 Task 3：无条件创建（getter 模式）——不再依赖创建时刻 service 是否就绪。
    // 每次指令执行时动态获取最新 service 实例，兼容用户重新进入课程页等新会话的 provider 重建。
    // mock 降级模式下 serviceGetter 返回 null，dispatcher 内部自动跳过写入，行为安全。
    _dispatcher = FtmsCommandDispatcher(
      serviceGetter: _getFtmsService,
      syncGuard: _syncGuard,
      // 指令下发失败回调（按类型分类）：打印观测日志，
      // 便于真机排查设备无响应问题（通信链路断开、特征未发现等）
      onCommandFailed: (type, error) {
        debugPrint('❌ [CoursePlay] 指令下发失败(type=$type): $error');
      },
      // 跟踪重发耗尽回调（4s 超时 × 3 次仍未确认）：设备可能离线/不回执
      onRetryExhausted: (opCode) {
        debugPrint(
          '❌ [CoursePlay] 指令重发耗尽(未确认): opCode=0x'
          '${opCode.toRadixString(16)}，设备可能未响应',
        );
      },
    );
    debugPrint(
      '📡 [CoursePlay] _setupDispatcher: dispatcher 已创建（getter 模式，无条件创建）',
    );
  }

  /// 绑定 FTMS 数据流与状态流监听。
  /// 在 initCourseContext 时调用，会先取消旧订阅再创建新订阅。
  /// 若 ftmsService 为 null（无设备连接），启动重试定时器（Task 4）。
  void _setupStreams() {
    final ftmsService = _getFtmsService();
    if (ftmsService == null) {
      // 🔧 Task 4：service 未就绪（connect() 异步中）→ 2 秒后重试，上限 15 次（30 秒窗口）
      // 仅用于初始绑定场景；断链事件（Task 5）会立即取消重试定时器，禁止断线重绑
      debugPrint(
        '📡 [CoursePlay] _setupStreams: ftmsService 为 null（重试第 $_streamRetryCount 次），启动重试定时器',
      );
      _scheduleStreamRetry();
      return;
    }

    // 绑定成功：取消重试定时器并清零计数
    _streamRetryTimer?.cancel();
    _streamRetryTimer = null;
    _streamRetryCount = 0;

    // 取消旧订阅
    _dataSubscription?.cancel();
    _statusSubscription?.cancel();
    _responseSubscription?.cancel();
    _connectionStateSubscription?.cancel();

    // 监听实时数据流（0x2AD1）
    _dataSubscription = ftmsService.dataStream.listen(_onDataReceived);
    // 监听设备状态流（0x2ADA）
    _statusSubscription = ftmsService.statusStream.listen(_onStatusReceived);
    // 监听控制点回执流（0x2AD9 Indicate，确认用户指令已被设备接受）
    _responseSubscription = ftmsService.responseStream.listen(
      _onControlResponseReceived,
    );
    // 🔴 R5：监听蓝牙连接状态流——断链即停止所有交互并退出课程到主界面（禁止重连）
    _connectionStateSubscription = ftmsService.connectionStateStream.listen(
      _onConnectionStateChanged,
    );

    debugPrint(
      '📡 [CoursePlay] _setupStreams: dataStream / statusStream / '
      'responseStream / connectionStateStream 已订阅',
    );

    // 🔴 R1 前置：发送 Request Control（0x00）获得设备控制权。
    // FTMS 规范：客户端必须先取得控制权，设备才接受 0x07 开始 / 0x08 停止等控制指令。
    // 对齐 QuickStart 进入页面时 sendResetToDevice() 的行为——
    // 用户未经过快速开始页直接进入课程页时，0x00 从未被发送，设备将忽略一切指令。
    _sendDeviceCommand('requestControl(0x00)', FtmsCommand(0x00, []));

    // 读取设备能力范围（0x2AD4/0x2AD5/0x2AD6），按钮动态上下限/步进的数据源
    unawaited(_loadDeviceCapabilities(ftmsService));
  }

  /// Task 4：订阅重试定时器（每 2 秒重试一次 _setupStreams，上限 15 次）。
  void _scheduleStreamRetry() {
    _streamRetryTimer?.cancel();
    if (_streamRetryCount >= 15) {
      debugPrint(
        '📡 [CoursePlay] _setupStreams 重试达上限(15次/30秒)，放弃绑定（mock 降级模式）',
      );
      return;
    }
    _streamRetryTimer = Timer(const Duration(seconds: 2), () {
      if (_isCleanedUp) return;
      _streamRetryCount++;
      debugPrint('📡 [CoursePlay] _setupStreams retry $_streamRetryCount/15');
      _setupStreams();
    });
  }

  /// R5：蓝牙连接状态变化回调——断链即停止所有交互并退出课程到主界面。
  void _onConnectionStateChanged(BluetoothConnectionState connState) {
    debugPrint('📡 [CoursePlay] 蓝牙连接状态: $connState');
    if (connState == BluetoothConnectionState.disconnected) {
      _onDeviceDisconnected();
    }
  }

  /// R5：蓝牙断链处理——停止所有交互（定时器/音频/指令/订阅），
  /// 标记 isDeviceConnectionLost 供页面层导航退出到主界面。
  /// 不做任何重连、不进结算页、不保存数据（按"未完成"处理）。
  void _onDeviceDisconnected() {
    debugPrint('❌ [CoursePlay] 蓝牙断链 → 停止所有交互，退出课程到主界面');
    // 取消订阅重试定时器（禁止断线重绑）
    _streamRetryTimer?.cancel();
    _streamRetryTimer = null;
    // 同步锁：拦截所有定时器回调
    _isCleanedUp = true;
    _audioTerminated = true;
    // 停止所有定时器
    _playTickTimer?.cancel();
    _playTickTimer = null;
    _imageFrameTimer?.cancel();
    _imageFrameTimer = null;
    // 停止音频 + 运动计时器
    _stopAudio();
    _sportTimer?.stop();
    // 取消全部数据流订阅
    _dataSubscription?.cancel();
    _statusSubscription?.cancel();
    _responseSubscription?.cancel();
    _connectionStateSubscription?.cancel();
    // 解锁参数同步引擎
    _paramSyncEngine.unlockAll();
    // 标记断链：页面层 watch 此字段 → context.go('/home-shell') 退出到主界面
    state = state.copyWith(isDeviceConnectionLost: true, isPlaying: false);
  }

  /// 读取设备能力范围并写入 state（按钮动态上下限/步进）。
  ///
  /// 通过 [FtmsDeviceCapabilityReader] 读取，单维度失败自动回退默认配置；
  /// 成功后写入 state 中的动态范围字段（按钮方法经 xxxEff getter 读取）。
  Future<void> _loadDeviceCapabilities(FtmsServiceBase ftmsService) async {
    final reader = FtmsDeviceCapabilityReader(ftmsService);
    final config = await reader.readCapabilities(_deviceType);

    // 仅在设备上报成功时写入动态范围（否则保持 0 → getter 自动回退默认常量）
    if (config.source == ConfigSource.fromDevice) {
      // 三维度能力判定：按 0x2AD4/0x2AD5/0x2AD6 实际上报（max<=min 视为不支持）
      // 先写缓存再写 state：缓存供 _buildPlayState 重建 state 时复用（防竞态覆盖）
      // 维度与页面按钮映射：跑步机=坡度+速度，非跑步机=阻力
      final bool isTreadmill = _deviceType == FtmsDeviceType.treadmill;
      if (isTreadmill) {
        _deviceInclinationSupported = config.inclination.supported;
        _deviceSpeedSupported = config.speed.supported;
      } else {
        _deviceResistanceSupported = config.resistance.supported;
      }
      // 未涉及维度传回当前值保持不变（初始已按设备类型固定）
      final bool inclinationSupportUpdate = isTreadmill
          ? config.inclination.supported
          : state.hasInclinationSupport;
      final bool speedSupportUpdate = isTreadmill
          ? config.speed.supported
          : state.hasSpeedSupport;
      final bool resistanceSupportUpdate = isTreadmill
          ? state.hasResistanceSupport
          : config.resistance.supported;
      state = state.copyWith(
        speedRangeMin: config.speed.min,
        speedRangeMax: config.speed.max,
        speedRangeStep: config.speed.singleStep,
        inclinationRangeMin: config.inclination.supported
            ? config.inclination.min
            : 0.0,
        inclinationRangeMax: config.inclination.supported
            ? config.inclination.max
            : 0.0,
        inclinationRangeStep: config.inclination.supported
            ? config.inclination.singleStep
            : 0.0,
        resistanceRangeMin: config.resistance.supported
            ? config.resistance.min
            : 0.0,
        resistanceRangeMax: config.resistance.supported
            ? config.resistance.max
            : 0.0,
        resistanceRangeStep: config.resistance.supported
            ? config.resistance.singleStep
            : 0.0,
        hasInclinationSupport: inclinationSupportUpdate,
        hasSpeedSupport: speedSupportUpdate,
        hasResistanceSupport: resistanceSupportUpdate,
        isConfigFromDevice: true,
      );
      // 三维度不支持时的观测日志（真机排查用）
      if (isTreadmill && !config.inclination.supported) {
        debugPrint(
          '⚠️ [Capability] 跑步机 0x2AD5 上报范围无效（max<=min）→ 设备不支持坡度，已隐藏坡度按钮组',
        );
      }
      if (isTreadmill && !config.speed.supported) {
        debugPrint(
          '⚠️ [Capability] 跑步机 0x2AD4 上报范围无效（max<=min）→ 设备不支持速度调节，已隐藏速度按钮组',
        );
      }
      if (!isTreadmill && !config.resistance.supported) {
        debugPrint(
          '⚠️ [Capability] $_deviceType 0x2AD6 上报范围无效（max<=min）→ 设备不支持阻力调节，已隐藏阻力按钮组',
        );
      }
      debugPrint(
        '✅ [Capability] 设备能力已加载（动态参数生效）: '
        'speed=[$_speedMinEff, $_speedMaxEff] step=$_speedStepEff, '
        'incl=[$_inclinationMinEff, $_inclinationMaxEff] '
        'step=$_inclinationStepEff, '
        'res=[$_resistanceMinEff, $_resistanceMaxEff] '
        'step=$_resistanceStepEff',
      );
    } else {
      debugPrint(
        '⚠️ [Capability] 设备能力未上报，按钮使用默认参数: '
        'speed=[$_speedMinFallback, $_speedMaxFallback] '
        'step=$_speedStepFallback 等',
      );
    }
  }

  /// 收到控制点回执（0x2AD9 Indicate）时的处理。
  ///
  /// 成功回执 → 确认跟踪指令（停止 4s 超时重发计时器）；
  /// 失败回执 → 打印结果码供真机排查（如 Control Not Permitted）。
  void _onControlResponseReceived(FtmsControlResponse resp) {
    if (resp.resultCode == FtmsControlResultCode.success) {
      _dispatcher?.confirmReceipt(resp.requestOpCode);
      debugPrint(
        '✅ [CoursePlay] 回执成功: request=0x'
        '${resp.requestOpCode.toRadixString(16)}',
      );
    } else {
      debugPrint(
        '⚠️ [CoursePlay] 回执失败: request=0x'
        '${resp.requestOpCode.toRadixString(16)}, '
        'result=${resp.resultCode.name}',
      );
    }
  }

  /// 收到 FTMS 实时数据时的处理逻辑。
  /// 1. 归一化设备时间
  /// 2. 校准 SportTimer
  /// 3. 更新 state 实时运动数据字段
  ///
  /// 注意：_playTickTimer 继续负责课程进度（playIndex/playTotalDuration），
  /// 本方法仅负责更新运动数据（速度/距离/卡路里/心率等），两者职责分离。
  void _onDataReceived(FtmsDeviceData data) {
    // 🔴 资源清理守卫：已清理则不处理
    if (_isCleanedUp) return;
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
    // G5 修正：划船机 Max Stroke Rate 走桨频专用通道（旧 saveMaxStorkeRate）
    if (strokeRate.round() > _maxStrokeRate) {
      _maxStrokeRate = strokeRate.round();
    }
    // 当前配速（旧 savePace：60/速度 roundToDouble，速度为 0 保持旧值）
    if (speed > 0) _lastPace = (60.0 / speed).roundToDouble();
    final pace = _calculatePace(speed);
    if (pace > _maxPace) _maxPace = pace;
    // 设备运动秒数（旧 saveSportTime = realSportTime，结算统计的时间基准）
    _deviceSportSeconds = normalizedTime;

    // 更新 state 实时运动数据字段
    state = state.copyWith(
      sportTime: formatDuration(normalizedTime),
      deviceSportSeconds: normalizedTime,
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

    // 🔴 按钮值实时同步（与快速开始模块功能一致，使用参数同步引擎防弹跳）
    // 仅在播放态时进行同步决策
    if (state.isPlaying) {
      // 速度按钮同步（跑步机）
      if (_deviceType == FtmsDeviceType.treadmill && data.instSpeed != null) {
        _syncParam(ParamDimension.speed, speed, (value) {
          state = state.copyWith(sportSpeedButton: value);
        });
      }
      // 坡度按钮同步（跑步机）
      if (_deviceType == FtmsDeviceType.treadmill &&
          data.inclineAngle != null) {
        _syncParam(ParamDimension.inclination, inclination, (value) {
          state = state.copyWith(sportInclinationButton: value);
        });
      }
      // 阻力按钮同步（单车/椭圆机/划船机）
      if (data.resistanceLvl != null) {
        _syncParam(ParamDimension.resistance, resistance, (value) {
          state = state.copyWith(sportResistanceButton: value);
        });
      }
    }

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
        // 0x04：设备开始/恢复运动（回执观测走 0x2AD9，指令不跟踪无需确认）
        debugPrint('📡 [CoursePlay] 设备状态: opCode=0x04, action=start/resume');
        if (!state.isPlaying) {
          _sportTimer?.start();
        }
        break;

      case FtmsStatusStoppedPaused(:final isPause):
        // 0x02：设备暂停/停止（Stop 指令无跟踪，无需回执确认）
        if (isPause) {
          // 0x02 + 0x02：设备暂停
          debugPrint('📡 [CoursePlay] 设备状态: opCode=0x02, action=pause');
          _sportTimer?.pause();
        } else {
          // 0x02 + 0x01：设备停止
          debugPrint('📡 [CoursePlay] 设备状态: opCode=0x02, action=stop');
          _sportTimer?.stop();
        }
        // 🔴 R2：设备侧暂停/停止一律视为训练结束 → 自动进入结算页
        // 复用 manualFinish 结算流程（内部含 R6 停止指令 + 数据截取保存 + 展示）
        // 防重复守卫：仅播放中且未结算时触发（防设备 idle 期误报 / 连发多条通知重复结算）
        if (state.isPlaying && !state.isStopScreen && !_isCleanedUp) {
          debugPrint('🏁 [CoursePlay] 设备侧停止/暂停 → 自动进入结算页');
          manualFinish();
        } else {
          debugPrint(
            'ℹ️ [CoursePlay] 设备侧停止/暂停通知，但当前非播放态或已结算，跳过自动结算 '
            '(isPlaying=${state.isPlaying}, isStopScreen=${state.isStopScreen})',
          );
        }
        break;

      case FtmsStatusTargetSpeedChanged(:final speedKmPerH):
        // 0x05：速度回调
        debugPrint(
          '📡 [CoursePlay] 设备状态: opCode=0x05, action=speed, value=$speedKmPerH',
        );
        // 通知引擎设备目标值变更，对齐 target 防止误判重发
        _paramSyncEngine.notifyDeviceTargetChanged(
          ParamDimension.speed,
          speedKmPerH,
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
        _paramSyncEngine.notifyDeviceTargetChanged(
          ParamDimension.inclination,
          inclinePercent,
        );
        if (_syncGuard?.isInGuardWindow() ?? false) {
          debugPrint('📡 [CoursePlay] 在保护窗口内，跳过坡度更新');
        } else {
          state = state.copyWith(sportInclinationButton: inclinePercent);
        }
        break;

      case FtmsStatusTargetResistanceChanged(:final resistanceLevel):
        // 0x07：阻力回调（取整保持按钮值为整数）
        final intLevel = resistanceLevel.round().toDouble();
        debugPrint(
          '📡 [CoursePlay] 设备状态: opCode=0x07, action=resistance, value=$intLevel',
        );
        _paramSyncEngine.notifyDeviceTargetChanged(
          ParamDimension.resistance,
          intLevel,
        );
        if (_syncGuard?.isInGuardWindow() ?? false) {
          debugPrint('📡 [CoursePlay] 在保护窗口内，跳过阻力更新');
        } else {
          state = state.copyWith(sportResistanceButton: intLevel);
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
  /// - 跑步机：下发速度 (0x02 Set Target Speed，值×100)
  /// - 单车/椭圆机/划船机/力量站：下发阻力 (0x04 Set Target Resistance)
  ///
  /// 🔴 指令格式修正（2026-08-18）：原实现误用 0x07（Start or Reset）+ 子参数
  /// 的自定义格式，设备不识别导致无响应。现改为 FTMS 标准 OpCode，与
  /// QuickStartNotifier 的下发格式完全对齐。
  /// 课程指令经 [dispatchWithPriority] 以 course 来源下发（debounce，可被用户覆盖）。
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
        // 跑步机：下发速度（0x02 Set Target Speed，单位 0.01 km/h → ×100）
        final speed = action.cadence.toDouble();
        command = FtmsCommand(0x02, _buildValueBytes(0x02, speed));
        state = state.copyWith(sportSpeedButton: speed);
        break;
      case FtmsDeviceType.indoorBike:
      case FtmsDeviceType.crossTrainer:
      case FtmsDeviceType.rower:
      case FtmsDeviceType.strengthStation:
        // 单车/椭圆机/划船机/力量站：下发阻力（0x04 Set Target Resistance）
        final resistance = action.resistance.round().toDouble();
        command = FtmsCommand(0x04, _buildValueBytes(0x04, resistance));
        state = state.copyWith(sportResistanceButton: resistance);
        break;
    }

    // 课程指令：debounce 模式，可被用户指令覆盖（优先级仲裁）
    _dispatcher!.dispatchWithPriority(command, source: CommandSource.course);
    debugPrint(
      '🎯 [Action] _applyActionParameters: name=${action.name}, '
      'deviceType=$_deviceType, resistance=${action.resistance}, '
      'cadence=${action.cadence}, command已下发(course来源)',
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
        // 阻力按钮值必须为整数(如 8)，发送时 ×10 → 字节 80
        final intValue = value.round();
        final raw = (intValue * 10).clamp(0, 255);
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

  /// 向设备发送运动控制指令（R1/R3/R6 统一入口）
  ///
  /// [tag] 日志标识；[command] FTMS 指令（0x00 控制权 / 0x07 开始 / 0x08+0x01 停止）。
  /// 全部单发（不跟踪不重发）：指令是否被设备接受由 0x2AD9 控制点回执
  /// （_onControlResponseReceived）监听并在日志中观测。
  /// try-catch 隔离：发送失败仅记日志，不阻塞本地清理/结算流程。
  void _sendDeviceCommand(String tag, FtmsCommand command) {
    try {
      final dispatcher = _dispatcher;
      if (dispatcher == null) {
        debugPrint('📡 [DeviceCmd] $tag: 跳过（无 dispatcher / mock 降级模式）');
        return;
      }
      dispatcher.dispatchImmediate(command);
      debugPrint(
        '📡 [DeviceCmd] $tag: 已发送 '
        '(opCode=0x${command.opCode.toRadixString(16)}, '
        'data=${command.data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')})',
      );
    } catch (e) {
      debugPrint('❌ [DeviceCmd] $tag: 发送失败: $e');
    }
  }

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
      // 🔴 R1：向设备发送开始指令（0x07 Start/Resume，单发，不跟踪不重发）。
      // 指令是否被接受由 0x2AD9 控制点回执监听（_onControlResponseReceived）日志观测。
      _sendDeviceCommand('start(0x07)', FtmsCommand(0x07, []));
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
    // 🔴 同步布尔守卫：课程结束/退出后立即拦截 tick（防止结束后进度条持续刷新）
    if (_isCleanedUp || _audioTerminated) {
      debugPrint(
        '🛑 [Tick] _tickPlaySecond 被同步布尔守卫拦截（isCleanedUp=$_isCleanedUp, audioTerminated=$_audioTerminated）',
      );
      return;
    }
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

    // ─── G2 修正：休息时间真实累积（旧 L1494-1503：播放中且
    // 划船机桨频=0 / 其他设备速度=0 时每秒 +1） ───
    if (_deviceType == FtmsDeviceType.rower) {
      if ((int.tryParse(state.sportStrokeRate) ?? 0) == 0) _restSeconds++;
    } else {
      if (state.sportDeviceSpeed == 0) _restSeconds++;
    }

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
      // ─── G10/G15 修正：速度图表改为动作切换时记录（旧 _calculateSportSpeedCurve：
      // 划船机记「平均桨频+当前速度」两点，其他设备记当前速度一点） ───
      _recordSpeedCurvePoint();
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
    // G11 修正：采样源改为设备真实阻力/坡度（旧 saveSportResistance /
    // saveSportInclination），非 0 才采样（旧 _calculateAverageResistance 逻辑）
    if (playTotalDuration > 0 && playTotalDuration % 60 == 0) {
      final deviceResistance = int.tryParse(state.sportResistance) ?? 0;
      if (deviceResistance != 0) _resistanceSamples.add(deviceResistance);
      final deviceInclination = double.tryParse(state.sportInclination) ?? 0.0;
      if (deviceInclination != 0) _inclinationSamples.add(deviceInclination);
      debugPrint(
        '📊 [CourseStats] 采样: resistance=$deviceResistance, '
        'inclination=$deviceInclination, sampleCount=${_resistanceSamples.length}',
      );
    }

    // ─── 速度采样（每 3 秒一次，供本地运动记录 speedSamples） ───
    if (playTotalDuration > 0 && playTotalDuration - _lastSpeedSampleSec >= 3) {
      _lastSpeedSampleSec = playTotalDuration;
      final speed = state.sportDeviceSpeed;
      if (speed > 0) {
        _speedSamples.add(speed);
        if (_speedSamples.length > 60) {
          _speedSamples.removeAt(0);
        }
      }
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

    // 按钮速度同步到显示速度
    final displaySpeed = state.deviceType == FtmsDeviceType.rower
        ? state.sportStrokeRate
        : deviceSpeed.toStringAsFixed(1);

    // mock 模式下也跟踪最大值（用于结束页统计）
    if ((deviceSpeed * 3.0).round() > _maxCadence) {
      _maxCadence = (deviceSpeed * 3.0).round();
    }
    if (curHr > _maxHeartRate) _maxHeartRate = curHr;
    // mock 模式同样跟踪当前配速/最大配速/设备运动秒数（与蓝牙模式口径一致）
    if (deviceSpeed > 0) _lastPace = (60.0 / deviceSpeed).roundToDouble();
    final mockPace = _calculatePace(deviceSpeed);
    if (mockPace > _maxPace) _maxPace = mockPace;
    _deviceSportSeconds = playTotalDuration;

    state = state.copyWith(
      playIndex: playIndex,
      playIndexDuration: playIndexDuration,
      playTotalDuration: playTotalDuration,
      currentDuration: currentDuration,
      playProgressPercent: percent,
      sportTime: sportTimeStr,
      deviceSportSeconds: playTotalDuration,
      sportDistance: newDist,
      sportCalories: newKcal,
      sportSpeed: displaySpeed,
      sportDeviceSpeed: deviceSpeed,
      sportHeartRate: curHr.toString(),
      sportCadence: (deviceSpeed * 3.0).round().toString(),
      // 速度图表：动作切换时记录（_recordSpeedCurvePoint 已维护）
      speedChartData: List.unmodifiable(_speedCurvePoints),
    );
  }

  /// 每 100ms tick：推进 imagePlayIndex 帧
  void _tickImageFrame() {
    // 🔴 资源清理守卫：已清理则不执行
    if (_isCleanedUp) return;
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

  /// 完成度计算（G6 修正）：设备距离(米) ÷ 课程总里程 × 100（旧 L1539-1544）。
  /// 课程 distance 全 0 时完成度为 0（与旧版一致）；不做 100 封顶（旧版无 clamp）。
  double _finishPercentByDistance(double distanceMeters) {
    if (_courseTotalDistance == 0) return 0.0;
    return distanceMeters / _courseTotalDistance * 100;
  }

  /// 总踏频计算（G3 修正，旧 _calculateTotalCadence L1848-1867）：
  /// 单车：距离(km) ÷ 0.942 取整；跑步机/椭圆机/其他：距离(km) ÷ 0.45 取整。
  /// 基于距离换算（经验系数），与旧版保持一致。
  int _calculateTotalCadence(double distanceKm) {
    if (_deviceType == FtmsDeviceType.indoorBike) {
      return (distanceKm / 0.942).round();
    }
    return (distanceKm / 0.45).round();
  }

  /// 平均踏频计算（G4 修正，旧 _caluateAverageCandence L1879-1885）：
  /// 总踏频 ÷ (运动秒数/60)，四舍五入。
  int _calculateAvgCadence(int totalCadence, int elapsedSeconds) {
    if (elapsedSeconds <= 0) return 0;
    return (totalCadence / (elapsedSeconds / 60.0)).round();
  }

  /// 速度图表记录点（G10/G15 修正，旧 _calculateSportSpeedCurve L247-252）：
  /// 划船机连续记录「平均桨频 + 当前速度」两点；其他设备记录「当前速度」一点。
  /// 调用时机：课程动作切换（playIndex++ 后）。
  void _recordSpeedCurvePoint() {
    if (_deviceType == FtmsDeviceType.rower) {
      final totalStrokes = int.tryParse(state.sportStrokeCount) ?? 0;
      final avgStrokeRate = _calculateAvgStrokeRate(
        totalStrokes,
        _elapsedSportSeconds,
      );
      _speedCurvePoints.add(avgStrokeRate);
    }
    _speedCurvePoints.add(state.sportDeviceSpeed);
    debugPrint(
      '📈 [SpeedCurve] 动作切换记录图表点: index=${_speedCurvePoints.length}, '
      'deviceType=$_deviceType, points=$_speedCurvePoints',
    );
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

  // ══════════════════════════════════════════════════════════
  // 评分引擎（G7/G8 修正，复刻旧 _calculateActionRating L1551-1817 八项公式）
  // ══════════════════════════════════════════════════════════

  /// 完成度评分（旧 _sportRatingCourseCompletionFunc）：
  /// ≥90→5、≥80→4、≥60→3、≥40→2、≥20→1、否则 0
  int _ratingCompletion(double finishPercent) {
    if (finishPercent >= 90) return 5;
    if (finishPercent >= 80) return 4;
    if (finishPercent >= 60) return 3;
    if (finishPercent >= 40) return 2;
    if (finishPercent >= 20) return 1;
    return 0;
  }

  /// 速度稳定评分（跑步机，旧 _sportRatingSpeedStabilityFunc）：
  /// |MaxPace − savePace| / savePace；savePace/MaxPace 为 0 → 0 分
  /// ≤10%→5、≤20%→4、≤30%→3、≤40%→2、≥41%→1
  int _ratingSpeedStability() {
    if (_lastPace == 0 || _maxPace == 0) return 0;
    final diff = (_maxPace.round() - _lastPace.round()).abs();
    final percent = diff / _lastPace;
    if (percent <= 0.10) return 5;
    if (percent <= 0.20) return 4;
    if (percent <= 0.30) return 3;
    if (percent <= 0.40) return 2;
    return 1;
  }

  /// 坡度控制评分（跑步机，旧 _sportRatingSlopeStabilityFunc）：
  /// |平均坡度 − 目标坡度| / 目标坡度 × 100（%）；目标为 0 → 0 分
  /// ≤0.5%→5、≤2.0%→4、≤3.5%→3、≤4.0%→2、≥4.1%→1
  /// 注：平均坡度按旧代码本意（60 秒采样均值）实现，修复旧版恒 0 导致恒 1 分的 bug。
  int _ratingSlopeStability() {
    if (_device10AvgInclination == 0) return 0;
    final avgInclination = _calculateAvgInclination();
    final deviation =
        (avgInclination - _device10AvgInclination).abs() /
        _device10AvgInclination *
        100;
    if (deviation >= 4.1) return 1;
    if (deviation >= 3.6) return 2;
    if (deviation >= 2.1) return 3;
    if (deviation >= 0.6) return 4;
    return 5;
  }

  /// 踏频稳定评分（单车/椭圆机，旧 _sportRatingCadenceStabilityFunc）：
  /// |MaxCadence − AvgCadence| / AvgCadence；AvgCadence 为 0 → 0 分
  /// ≤8%→5、≤15%→4、≤22%→3、≤30%→2、≥31%→1
  int _ratingCadenceStability(double avgCadence) {
    if (avgCadence == 0) return 0;
    final percent = (_maxCadence - avgCadence).abs() / avgCadence;
    if (percent <= 0.08) return 5;
    if (percent <= 0.15) return 4;
    if (percent <= 0.22) return 3;
    if (percent <= 0.30) return 2;
    return 1;
  }

  /// 踏频效率评分（单车/椭圆机，旧 _sportRatingCadenceEfficiencyFunc）：
  /// (AvgCadence × 运动秒数) / 课程总踏频；课程总踏频为 0 → 0 分
  /// ≥98%→5、≥92%→4、≥85%→3、≥78%→2、<78%→1
  int _ratingCadenceEfficiency(double avgCadence, int elapsedSeconds) {
    if (_courseTotalCadence == 0) return 0;
    final percent = (avgCadence * elapsedSeconds) / _courseTotalCadence;
    if (percent >= 0.98) return 5;
    if (percent >= 0.92) return 4;
    if (percent >= 0.85) return 3;
    if (percent >= 0.78) return 2;
    return 1;
  }

  /// 运动效率评分（划船机，旧 _sportRatingExerciseEfficiencyFunc）：
  /// 平均速度 = 距离(km) / 运动秒数（km/s）；时间为 0 → 0 分
  /// <1→1、<2→2、<4→3、<7→4、≥7→5
  int _ratingExerciseEfficiency(double distanceKm, int elapsedSeconds) {
    if (elapsedSeconds == 0) return 0;
    final avgSpeed = distanceKm / elapsedSeconds;
    if (avgSpeed >= 7.0) return 5;
    if (avgSpeed >= 4.0) return 4;
    if (avgSpeed >= 2.0) return 3;
    if (avgSpeed >= 1.0) return 2;
    return 1;
  }

  /// 连贯性评分（旧 _sportRatingExerciseCoherenceFunc）：
  /// 有效运动占比 = T / (T + R)；T 为 0 → 0 分
  /// ≥0.93→5、≥0.85→4、≥0.78→3、≥0.71→2、<0.71→1
  int _ratingCoherence(int elapsedSeconds) {
    if (elapsedSeconds == 0) return 0;
    final ratio = elapsedSeconds / (elapsedSeconds + _restSeconds);
    if (ratio >= 0.93) return 5;
    if (ratio >= 0.85) return 4;
    if (ratio >= 0.78) return 3;
    if (ratio >= 0.71) return 2;
    return 1;
  }

  /// 桨频稳定评分（划船机，旧 _sportRatingStrokeRateStabilityFunc）：
  /// |平均桨频 − 当前桨频| / 平均桨频 × 100（%）；平均桨频为 0 → 0 分
  /// ≥20→1、≥15→2、≥10→3、≥5→4、<5→5
  int _ratingStrokeRateStability(double avgStrokeRate) {
    if (avgStrokeRate == 0) return 0;
    final currentStrokeRate = double.tryParse(state.sportStrokeRate) ?? 0.0;
    final percent =
        (avgStrokeRate - currentStrokeRate).abs() / avgStrokeRate * 100;
    if (percent >= 20) return 1;
    if (percent >= 15) return 2;
    if (percent >= 10) return 3;
    if (percent >= 5) return 4;
    return 5;
  }

  /// 综合等级（旧 _pauseScreenScore L1799-1817）：
  /// 四项求和：≥18→Level AAA、≥15→Level AA、≥12→Level A+、≥8→Level A、否则 Level B
  String _scoreLevelFromSum(int sum) {
    if (sum >= 18) return 'Level AAA';
    if (sum >= 15) return 'Level AA';
    if (sum >= 12) return 'Level A+';
    if (sum >= 8) return 'Level A';
    return 'Level B';
  }

  /// 结算时计算四项评分（旧 _switchOverScreenShowData 按设备取 4 项）：
  /// 单车/椭圆机：完成度/踏频稳定/踏频效率/连贯性
  /// 跑步机：完成度/速度稳定/坡度控制/连贯性
  /// 划船机：完成度/连贯性(Endurance)/运动效率/桨频稳定
  /// 返回 (分数列表, 综合等级)。
  (List<int>, String) _calculateRatingScores() {
    final elapsedSeconds = _elapsedSportSeconds;
    final distanceKm = double.tryParse(state.sportDistance) ?? 0.0;
    final totalCadence = _calculateTotalCadence(distanceKm);
    final avgCadence = _calculateAvgCadence(totalCadence, elapsedSeconds);
    final totalStrokes = int.tryParse(state.sportStrokeCount) ?? 0;
    final avgStrokeRate = _calculateAvgStrokeRate(totalStrokes, elapsedSeconds);
    final finishPercent = _finishPercentByDistance(distanceKm * 1000);

    final List<int> scores;
    switch (_deviceType) {
      case FtmsDeviceType.treadmill:
        scores = [
          _ratingCompletion(finishPercent),
          _ratingSpeedStability(),
          _ratingSlopeStability(),
          _ratingCoherence(elapsedSeconds),
        ];
      case FtmsDeviceType.rower:
        scores = [
          _ratingCompletion(finishPercent),
          _ratingCoherence(elapsedSeconds), // Endurance
          _ratingExerciseEfficiency(distanceKm, elapsedSeconds),
          _ratingStrokeRateStability(avgStrokeRate),
        ];
      case FtmsDeviceType.indoorBike:
      case FtmsDeviceType.crossTrainer:
      case FtmsDeviceType.strengthStation:
        scores = [
          _ratingCompletion(finishPercent),
          _ratingCadenceStability(avgCadence.toDouble()),
          _ratingCadenceEfficiency(avgCadence.toDouble(), elapsedSeconds),
          _ratingCoherence(elapsedSeconds),
        ];
    }

    final sum = scores.fold<int>(0, (a, b) => a + b);
    final level = _scoreLevelFromSum(sum);
    debugPrint(
      '📊 [CourseStats] 评分计算: scores=$scores, sum=$sum, level=$level '
      '(elapsed=${elapsedSeconds}s, rest=$_restSeconds, '
      'finish%=${finishPercent.toStringAsFixed(1)}, avgCadence=$avgCadence, '
      'totalCadence=$totalCadence, avgStrokeRate=${avgStrokeRate.toStringAsFixed(1)})',
    );
    return (scores, level);
  }

  /// 将当前运动数据保存为本地记录（供 Record 模块查询）。
  ///
  /// 在 `_finishPlay()` / `manualFinish()` 中调用，异常捕获不影响 UI 展示。
  Future<void> _saveSportRecord() async {
    try {
      final now = DateTime.now();
      // 时间基准对齐旧 saveSportTime：蓝牙模式优先设备运动秒数
      final duration = _elapsedSportSeconds;
      if (duration <= 0) {
        debugPrint('⚠️ [SportRecord] 运动时长为 0，跳过保存');
        return;
      }
      final distanceKm = double.tryParse(state.sportDistance) ?? 0.0;
      final totalCadence = _calculateTotalCadence(distanceKm);
      final record = SportRecord(
        id: '${now.millisecondsSinceEpoch}_${_deviceType.value}',
        userId: 1,
        deviceType: _deviceType.value,
        mode: state.playIndex,
        trainMode: 1, // 课程模式
        startTime: now.subtract(Duration(seconds: duration)),
        endTime: now,
        duration: duration,
        distance: distanceKm,
        calories: double.tryParse(state.sportCalories) ?? 0.0,
        avgSpeed: state.sportDeviceSpeed,
        maxSpeed: _maxPace > 0 ? 60.0 / _maxPace : null,
        // 平均踏频对齐旧公式：总踏频 ÷ 分钟数
        avgCadence: _calculateAvgCadence(totalCadence, duration),
        maxCadence: _maxCadence,
        avgHeartRate: int.tryParse(state.sportHeartRate) ?? 0,
        maxHeartRate: _maxHeartRate,
        avgResistance: _calculateAvgResistance(),
        avgInclination: _calculateAvgInclination(),
        totalStrokes: int.tryParse(state.sportStrokeCount) ?? 0,
        avgStrokeRate: _calculateAvgStrokeRate(
          int.tryParse(state.sportStrokeCount) ?? 0,
          duration,
        ),
        // G6 修正：完成度对齐旧公式（设备距离 ÷ 课程总里程）
        finishPercent: _finishPercentByDistance(distanceKm * 1000),
        speedSamples: List.of(_speedSamples),
      );
      await ref.read(sportRecordLocalRepositoryProvider).saveRecord(record);
      // R6：结算数据截取保存成功日志（三条结算路径统一走此方法：自然结束/返回键/设备侧停止）
      debugPrint(
        '💾 [CoursePlay] 结算数据已截取并保存 (duration=${record.duration}s, '
        'distance=${record.distance.toStringAsFixed(2)}km, '
        'kcal=${record.calories.toStringAsFixed(0)}, finish=${record.finishPercent?.toStringAsFixed(1) ?? '0'}%)',
      );
    } catch (e) {
      debugPrint('❌ [SportRecord] 保存运动记录失败: $e');
    }
  }

  /// 构建结束页统计数据值列表（根据设备类型选择对应数据项）。
  /// 2026-08-18 差异修正：全部公式对齐旧 _switchOverScreenShowData：
  /// - 距离 1 位小数（G1）
  /// - Rest Time 真实累积（G2）
  /// - Total/Avg Cadence 距离换算公式（G3/G4）
  /// - 完成度按设备距离 ÷ 课程总里程（G6）
  /// - 划船机 Avg Strokes 修复为真实平均桨频、Max Stroke Rate 走桨频通道（G5/G13）
  List<String> _buildFinishDataValues() {
    final deviceType = state.deviceType;
    // 时间基准对齐旧 saveSportTime（设备运动秒数优先）
    final elapsedSeconds = _elapsedSportSeconds;
    final sportTimeStr = formatDuration(elapsedSeconds);
    final distance = double.tryParse(state.sportDistance) ?? 0.0;
    final calories = double.tryParse(state.sportCalories) ?? 0.0;

    // 配速显示（旧格式：savePace != 0 ? formatSeconds(pace.round()*60) : "00:00:00"）
    final paceStr = _lastPace != 0
        ? formatDuration(_lastPace.round() * 60)
        : '00:00:00';
    final maxPaceStr = _maxPace != 0
        ? formatDuration(_maxPace.round() * 60)
        : '00:00:00';

    final avgResistance = _calculateAvgResistance();
    final totalStrokes = int.tryParse(state.sportStrokeCount) ?? 0;
    final avgStrokeRate = _calculateAvgStrokeRate(totalStrokes, elapsedSeconds);
    // 完成度：设备距离(米) ÷ 课程总里程 × 100（G6）
    final finishPercent = _finishPercentByDistance(distance * 1000);
    // 总踏频/平均踏频（G3/G4）
    final totalCadence = _calculateTotalCadence(distance);
    final avgCadence = _calculateAvgCadence(totalCadence, elapsedSeconds);
    // 休息时间（G2）
    final restTimeStr = formatDuration(_restSeconds);

    debugPrint(
      '📊 [CourseStats] 统计计算: time=$sportTimeStr, dist=${distance.toStringAsFixed(1)}km, '
      'kcal=${calories.toStringAsFixed(0)}, pace=$paceStr, maxPace=$maxPaceStr, '
      'maxCadence=$_maxCadence, maxStrokeRate=$_maxStrokeRate, maxHr=$_maxHeartRate, '
      'avgResistance=${avgResistance.toStringAsFixed(1)}, rest=$restTimeStr, '
      'avgStrokeRate=${avgStrokeRate.toStringAsFixed(1)}, totalStrokes=$totalStrokes, '
      'totalCadence=$totalCadence, avgCadence=$avgCadence, '
      'finish%=${finishPercent.toStringAsFixed(1)}',
    );

    switch (deviceType) {
      case FtmsDeviceType.indoorBike:
        return [
          sportTimeStr, // Sport Time
          distance.toStringAsFixed(1), // Total Distance (km) G1：1 位小数
          calories.toStringAsFixed(0), // Total Calories (kcal)
          paceStr, // Pace (min/km)
          avgCadence.toString(), // Avg Cadence (rpm) G4
          _maxCadence.toString(), // Max Cadence (rpm)
          _maxHeartRate.toString(), // Max Heart Rate (bpm)
          totalCadence.toString(), // Total Cadence (rpm) G3
          restTimeStr, // Rest Time G2
          finishPercent.toStringAsFixed(1), // Completion (%)
        ];
      case FtmsDeviceType.treadmill:
        return [
          sportTimeStr, // Sport Time
          distance.toStringAsFixed(1), // Total Distance (km) G1
          calories.toStringAsFixed(0), // Total Calories (kcal)
          paceStr, // Pace (min/km)
          maxPaceStr, // Max Pace (min/km)
          _maxCadence.toString(), // Max Cadence (rpm)
          _maxHeartRate.toString(), // Max Heart Rate (bpm)
          avgCadence.toString(), // Avg Cadence (reps/min) G4
          totalCadence.toString(), // Total Cadence (reps) G3
          finishPercent.toStringAsFixed(1), // Completion (%)
        ];
      case FtmsDeviceType.crossTrainer:
        return [
          sportTimeStr, // Sport Time
          distance.toStringAsFixed(1), // Total Distance (km) G1
          calories.toStringAsFixed(0), // Total Calories (kcal)
          paceStr, // Pace (min/km)
          avgCadence.toString(), // Avg Cadence (rpm) G4
          totalCadence.toString(), // Total Cadence G3
          _maxCadence.toString(), // Max Cadence (rpm)
          _maxHeartRate.toString(), // Max Heart Rate (bpm)
          restTimeStr, // Rest Time G2
          finishPercent.toStringAsFixed(1), // Completion (%)
        ];
      case FtmsDeviceType.rower:
        return [
          sportTimeStr, // Sport Time
          distance.toStringAsFixed(1), // Total Distance (km) G1
          calories.toStringAsFixed(0), // Total Calories (kcal)
          avgStrokeRate.toStringAsFixed(0), // Avg Strokes (spm) G13：修复为真实平均桨频
          avgResistance.toStringAsFixed(0), // Avg Resistance
          totalStrokes.toString(), // Total Strokes
          _maxStrokeRate.toString(), // Max Stroke Rate (spm) G5：桨频通道
          _maxHeartRate.toString(), // Avg Heart Rate (bpm，实际最大心率，与旧一致)
          restTimeStr, // Rest Time G2
          finishPercent.toStringAsFixed(1), // Completion (%)
        ];
      case FtmsDeviceType.strengthStation:
        // 力量站预留：暂与单车使用相同的结束页结构
        return [
          sportTimeStr,
          distance.toStringAsFixed(1),
          calories.toStringAsFixed(0),
          paceStr,
          avgCadence.toString(),
          _maxCadence.toString(),
          _maxHeartRate.toString(),
          totalCadence.toString(),
          restTimeStr,
          finishPercent.toStringAsFixed(1),
        ];
    }
  }

  /// 播放完成 → 进入结束页
  /// 🔴 顺序：先 setState + _audioTerminated=true（同步锁，防 await 穿透
  void _finishPlay() {
    // 🔴 R6：进结算页前保证设备停止（0x08+0x01 Stop，单发即视为停止）。
    // 设备对 Stop 指令无回执，不跟踪不重发（跟踪重发只会上报虚假"未确认"错误）。
    _sendDeviceCommand('stop(finishPlay 0x08 01)', FtmsCommand(0x08, [0x01]));
    // 🔴 第 0 步：同步锁布尔（优先级最高，比 setState 还先）
    _isCleanedUp = true;
    _audioTerminated = true;
    // 🔧 停止运动计时器（stop = 停止并归零），防止结束后计时器继续跑
    _sportTimer?.stop();
    debugPrint(
      '🛑 [AudioGuard] _finishPlay() → _audioTerminated = true（禁止再启音）',
    );
    // 解锁参数同步引擎所有维度
    _paramSyncEngine.unlockAll();
    // Task 13 + G6/G7/G8 修正：计算结束页统计数据与真实评分
    final finishDataValues = _buildFinishDataValues();
    final avgResistance = _calculateAvgResistance();
    final avgInclination = _calculateAvgInclination();
    final totalStrokes = int.tryParse(state.sportStrokeCount) ?? 0;
    final avgStrokeRate = _calculateAvgStrokeRate(
      totalStrokes,
      _elapsedSportSeconds,
    );
    final distanceKm = double.tryParse(state.sportDistance) ?? 0.0;
    final finishPercent = _finishPercentByDistance(distanceKm * 1000);
    final (ratingScores, scoreLevel) = _calculateRatingScores();
    debugPrint('📊 [CourseStats] _finishPlay: 结束页统计数据已计算完成');
    // 🔴 第一步：先写 state（锁 isStopScreen=true + 填充统计字段 + 速度图表数据）
    state = state.copyWith(
      isPlaying: false,
      isStopScreen: true,
      screenStatus: GymPlayScreenStatus.finished,
      showPlayButton: false,
      sportTime: formatDuration(_elapsedSportSeconds),
      finishDataValues: finishDataValues,
      maxCadence: _maxCadence,
      maxHeartRate: _maxHeartRate,
      maxPace: _maxPace,
      avgResistance: avgResistance,
      avgInclination: avgInclination,
      avgStrokeRate: avgStrokeRate,
      finishPercent: finishPercent,
      // G7/G8 修正：真实评分（分数同时作为评级图片索引）
      ratingScores: ratingScores,
      ratingImageIndices: ratingScores,
      scoreLevel: scoreLevel,
      // G10 修正：速度图表 = 动作切换记录点（旧 speedChartList）
      speedChartData: List.unmodifiable(_speedCurvePoints),
    );
    // 🔴 第二步：保存运动记录到本地（异步，不阻塞 UI）
    unawaited(_saveSportRecord());
    // 🔴 第三步：cancel + stop + seek zero + 取消数据流订阅
    _playTickTimer?.cancel();
    _playTickTimer = null;
    _imageFrameTimer?.cancel();
    _imageFrameTimer = null;
    _stopAudio();
    // 取消数据流订阅（防止设备数据继续推送导致 UI 重建）
    _dataSubscription?.cancel();
    _statusSubscription?.cancel();
    _responseSubscription?.cancel();
    unawaited(_bgmPlayer.seek(Duration.zero));
    unawaited(_voicePlayer.seek(Duration.zero));
    debugPrint('🏁 [Play] 课程播放完成，已进入结束页（先锁屏再stop）');
  }

  /// 用户主动结束课程 → 进入结束页（复刻原版返回按钮逻辑）
  /// 🔴 顺序：先 _audioTerminated=true（同步锁
  void manualFinish() {
    // 🔴 R6：进结算页前保证设备停止（0x08+0x01 Stop，单发即视为停止）。
    // 设备对 Stop 指令无回执，不跟踪不重发（跟踪重发只会上报虚假"未确认"错误）。
    _sendDeviceCommand('stop(manualFinish 0x08 01)', FtmsCommand(0x08, [0x01]));
    // 🔴 第 0 步：同步锁布尔（优先级最高，在任何 setState/await 之前）
    _isCleanedUp = true;
    _audioTerminated = true;
    // 🔧 停止运动计时器（stop = 停止并归零），防止结束后计时器继续跑
    _sportTimer?.stop();
    debugPrint(
      '🛑 [AudioGuard] manualFinish() → _audioTerminated = true（禁止再启音）',
    );
    // 解锁参数同步引擎所有维度
    _paramSyncEngine.unlockAll();
    // Task 13 + G6/G7/G8 修正：计算结束页统计数据与真实评分（用户主动结束也填充）
    final finishDataValues = _buildFinishDataValues();
    final avgResistance = _calculateAvgResistance();
    final avgInclination = _calculateAvgInclination();
    final totalStrokes = int.tryParse(state.sportStrokeCount) ?? 0;
    final avgStrokeRate = _calculateAvgStrokeRate(
      totalStrokes,
      _elapsedSportSeconds,
    );
    final distanceKm = double.tryParse(state.sportDistance) ?? 0.0;
    final finishPercent = _finishPercentByDistance(distanceKm * 1000);
    final (ratingScores, scoreLevel) = _calculateRatingScores();
    debugPrint('📊 [CourseStats] manualFinish: 结束页统计数据已计算完成');
    // 🔴 第一步：锁屏态（先写 state，拦截 _switchVoice/_tickPlaySecond）
    state = state.copyWith(
      isPlaying: false,
      isPause: false,
      isPauseScreen: false,
      isStopScreen: true,
      screenStatus: GymPlayScreenStatus.finished,
      showPlayButton: false,
      sportTime: formatDuration(_elapsedSportSeconds),
      finishDataValues: finishDataValues,
      maxCadence: _maxCadence,
      maxHeartRate: _maxHeartRate,
      maxPace: _maxPace,
      avgResistance: avgResistance,
      avgInclination: avgInclination,
      avgStrokeRate: avgStrokeRate,
      finishPercent: finishPercent,
      // G7/G8 修正：真实评分（分数同时作为评级图片索引）
      ratingScores: ratingScores,
      ratingImageIndices: ratingScores,
      scoreLevel: scoreLevel,
      // G10 修正：速度图表 = 动作切换记录点（旧 speedChartList）
      speedChartData: List.unmodifiable(_speedCurvePoints),
    );
    // 🔴 第二步：保存运动记录到本地（异步，不阻塞 UI）
    unawaited(_saveSportRecord());
    // 🔴 第三步：cancel + stop + seek zero + 取消数据流订阅
    _playTickTimer?.cancel();
    _playTickTimer = null;
    _imageFrameTimer?.cancel();
    _imageFrameTimer = null;
    _stopAudio();
    // 取消数据流订阅（防止设备数据继续推送导致 UI 重建）
    _dataSubscription?.cancel();
    _statusSubscription?.cancel();
    _responseSubscription?.cancel();
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
    // 🔴 R3：退出前保证设备停止（单发即视为停止，无回执不重发）
    _sendDeviceCommand('stop(exitToDetail 0x08 01)', FtmsCommand(0x08, [0x01]));
    // 取消订阅重试定时器（退出课程后不再绑定）
    _streamRetryTimer?.cancel();
    _streamRetryTimer = null;
    // 🔴 先设置清理标志，防止后续定时器回调继续执行
    _isCleanedUp = true;
    _audioTerminated = true;
    _playTickTimer?.cancel();
    _playTickTimer = null;
    _imageFrameTimer?.cancel();
    _imageFrameTimer = null;
    _stopAudio();
    // 🔧 复位音频进度到 0，保证下次播放从头开始（播放器不 dispose，可复用）
    unawaited(_bgmPlayer.seek(Duration.zero));
    unawaited(_voicePlayer.seek(Duration.zero));
    // 取消数据流订阅
    _dataSubscription?.cancel();
    _statusSubscription?.cancel();
    _responseSubscription?.cancel();
    _connectionStateSubscription?.cancel();
    // 解锁参数同步引擎所有维度
    _paramSyncEngine.unlockAll();
    // 重置统计采样
    _resistanceSamples.clear();
    _inclinationSamples.clear();
    _maxCadence = 0;
    _maxHeartRate = 0;
    _maxPace = 0.0;
    // 结算统计新增字段重置（2026-08-18 差异修正）
    _maxStrokeRate = 0;
    _restSeconds = 0;
    _lastPace = 0.0;
    _deviceSportSeconds = 0;
    _lastSpeedSampleSec = 0;
    _speedCurvePoints.clear();
    state = state.copyWith(
      screenStatus: GymPlayScreenStatus.loading,
      isPause: false,
      isPauseScreen: false,
      isPlaying: false,
      showPlayButton: false,
      isStopScreen: false,
      // 清零所有运动数据
      sportTime: '00:00',
      deviceSportSeconds: 0,
      sportDistance: '0.00',
      sportCalories: '0.0',
      sportSpeed: '0.0',
      sportDeviceSpeed: 0.0,
      sportHeartRate: '0',
      sportCadence: '0',
      sportStrokeRate: '0',
      sportStrokeCount: '0',
      sportInclination: '0.0',
      sportResistance: '0',
      // 重置进度
      playIndex: 0,
      playIndexDuration: 0,
      playTotalDuration: 0,
      playProgressPercent: 0.0,
      imagePlayIndex: 0,
      speedChartData: [],
    );
  }

  /// 页面退出时调用：清理所有定时器、音频、数据流订阅、重置运动数据
  void cleanupOnExit() {
    debugPrint('🧹 [PlayNotifier] cleanupOnExit: 开始清理所有资源');
    // 🔴 R3 兜底：页面销毁前保证设备停止（单发即视为停止，无回执不重发）
    _sendDeviceCommand(
      'stop(cleanupOnExit 0x08 01)',
      FtmsCommand(0x08, [0x01]),
    );
    // 取消订阅重试定时器
    _streamRetryTimer?.cancel();
    _streamRetryTimer = null;
    // 🔴 先设置清理标志，防止后续定时器回调继续执行
    _isCleanedUp = true;
    _audioTerminated = true;
    _playTickTimer?.cancel();
    _playTickTimer = null;
    _imageFrameTimer?.cancel();
    _imageFrameTimer = null;
    _stopAudio();
    // 🔧 播放器是 final 变量，dispose 后无法重建（音频无法重启的根因），
    // 此处仅复位进度到 0，保证下次进入课程可复用播放器从头播放
    unawaited(_bgmPlayer.seek(Duration.zero));
    unawaited(_voicePlayer.seek(Duration.zero));
    debugPrint('🧹 [Audio] cleanupOnExit: 播放器仅 stop+seek，未 dispose（保证可复用）');
    // 取消数据流订阅
    _dataSubscription?.cancel();
    _statusSubscription?.cancel();
    _responseSubscription?.cancel();
    _connectionStateSubscription?.cancel();
    // 解锁参数同步引擎所有维度
    _paramSyncEngine.unlockAll();
    // 重置统计采样
    _resistanceSamples.clear();
    _inclinationSamples.clear();
    _maxCadence = 0;
    _maxHeartRate = 0;
    _maxPace = 0.0;
    // 🔴 修复 Riverpod 断言：本方法在 Widget dispose() 中被调用，
    // Widget 生命周期内禁止修改 provider state（"Tried to modify a provider
    // while the widget tree was building"）。
    // state 重置延迟到微任务执行（资源清理同步完成不受影响）；
    // 页面下次进入时 resetToLoading() 也会做同款清零，双保险。
    Future.microtask(() {
      if (!ref.mounted) return;
      state = state.copyWith(
        isPlaying: false,
        isPause: false,
        isPauseScreen: false,
        isStopScreen: false,
        showPlayButton: false,
        screenStatus: GymPlayScreenStatus.loading,
        // 清零所有运动数据
        sportTime: '00:00',
        sportDistance: '0.00',
        sportCalories: '0.0',
        sportSpeed: '0.0',
        sportDeviceSpeed: 0.0,
        sportHeartRate: '0',
        sportCadence: '0',
        sportStrokeRate: '0',
        sportStrokeCount: '0',
        sportInclination: '0.0',
        sportResistance: '0',
        // 重置进度
        playIndex: 0,
        playIndexDuration: 0,
        playTotalDuration: 0,
        playProgressPercent: 0.0,
        imagePlayIndex: 0,
        speedChartData: [],
      );
      debugPrint('🧹 [PlayNotifier] cleanupOnExit: 所有资源已清理（state 已在微任务中重置）');
    });
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

  // ─── 单次点击版本（用户指令：立即执行 + 跟踪重发，覆盖课程指令） ───

  /// 速度 +（步进/边界全部动态化：设备上报优先）。
  void speedAdd() {
    final current = state.sportSpeedButton;
    final v = (current + _speedStepEff).clamp(_speedMinEff, _speedMaxEff);
    final newValue = double.parse(v.toStringAsFixed(1));
    // 锁定引擎，防止按钮弹跳
    _paramSyncEngine.lock(ParamDimension.speed, newValue, current);
    // 用户指令：0x02 Set Target Speed（×100），立即跟踪下发，覆盖 pending 课程指令
    _dispatcher?.dispatchWithPriority(
      FtmsCommand(0x02, _buildValueBytes(0x02, newValue)),
      source: CommandSource.user,
    );
    state = state.copyWith(sportSpeedButton: newValue);
    debugPrint(
      '📤 [CourseControl] speedAdd: $current → $newValue '
      '(step=$_speedStepEff, range=[$_speedMinEff, $_speedMaxEff])',
    );
  }

  void speedDown() {
    final current = state.sportSpeedButton;
    final v = (current - _speedStepEff).clamp(_speedMinEff, _speedMaxEff);
    final newValue = double.parse(v.toStringAsFixed(1));
    _paramSyncEngine.lock(ParamDimension.speed, newValue, current);
    _dispatcher?.dispatchWithPriority(
      FtmsCommand(0x02, _buildValueBytes(0x02, newValue)),
      source: CommandSource.user,
    );
    state = state.copyWith(sportSpeedButton: newValue);
    debugPrint(
      '📤 [CourseControl] speedDown: $current → $newValue '
      '(step=$_speedStepEff, range=[$_speedMinEff, $_speedMaxEff])',
    );
  }

  void inclinationAdd() {
    final current = state.sportInclinationButton;
    final v = (current + _inclinationStepEff).clamp(
      _inclinationMinEff,
      _inclinationMaxEff,
    );
    final newValue = double.parse(v.toStringAsFixed(1));
    _paramSyncEngine.lock(ParamDimension.inclination, newValue, current);
    // 用户指令：0x03 Set Target Inclination（×10）
    _dispatcher?.dispatchWithPriority(
      FtmsCommand(0x03, _buildValueBytes(0x03, newValue)),
      source: CommandSource.user,
    );
    state = state.copyWith(sportInclinationButton: newValue);
    debugPrint(
      '📤 [CourseControl] inclinationAdd: $current → $newValue '
      '(step=$_inclinationStepEff, '
      'range=[$_inclinationMinEff, $_inclinationMaxEff])',
    );
  }

  void inclinationDown() {
    final current = state.sportInclinationButton;
    final v = (current - _inclinationStepEff).clamp(
      _inclinationMinEff,
      _inclinationMaxEff,
    );
    final newValue = double.parse(v.toStringAsFixed(1));
    _paramSyncEngine.lock(ParamDimension.inclination, newValue, current);
    _dispatcher?.dispatchWithPriority(
      FtmsCommand(0x03, _buildValueBytes(0x03, newValue)),
      source: CommandSource.user,
    );
    state = state.copyWith(sportInclinationButton: newValue);
    debugPrint(
      '📤 [CourseControl] inclinationDown: $current → $newValue '
      '(step=$_inclinationStepEff, '
      'range=[$_inclinationMinEff, $_inclinationMaxEff])',
    );
  }

  void resistanceAdd() {
    final current = state.sportResistanceButton;
    final v = (current + _resistanceStepEff).clamp(
      _resistanceMinEff,
      _resistanceMaxEff,
    );
    final newValue = v.round().toDouble();
    _paramSyncEngine.lock(ParamDimension.resistance, newValue, current);
    // 用户指令：0x04 Set Target Resistance（原值）
    _dispatcher?.dispatchWithPriority(
      FtmsCommand(0x04, _buildValueBytes(0x04, newValue)),
      source: CommandSource.user,
    );
    state = state.copyWith(sportResistanceButton: newValue);
    debugPrint(
      '📤 [CourseControl] resistanceAdd: $current → $newValue '
      '(step=$_resistanceStepEff, '
      'range=[$_resistanceMinEff, $_resistanceMaxEff])',
    );
  }

  void resistanceDown() {
    final current = state.sportResistanceButton;
    final v = (current - _resistanceStepEff).clamp(
      _resistanceMinEff,
      _resistanceMaxEff,
    );
    final newValue = v.round().toDouble();
    _paramSyncEngine.lock(ParamDimension.resistance, newValue, current);
    _dispatcher?.dispatchWithPriority(
      FtmsCommand(0x04, _buildValueBytes(0x04, newValue)),
      source: CommandSource.user,
    );
    state = state.copyWith(sportResistanceButton: newValue);
    debugPrint(
      '📤 [CourseControl] resistanceDown: $current → $newValue '
      '(step=$_resistanceStepEff, '
      'range=[$_resistanceMinEff, $_resistanceMaxEff])',
    );
  }

  // ─── 长按版本（步进更小，连续触发，使用 debounce 模式） ───

  void speedAddLongPress() {
    final current = state.sportSpeedButton;
    final v = (current + _speedLongPressStepEff).clamp(
      _speedMinEff,
      _speedMaxEff,
    );
    final newValue = double.parse(v.toStringAsFixed(1));
    _paramSyncEngine.lock(ParamDimension.speed, newValue, current);
    // 长按中间步进：即时下发（快速连续触发，避免 debounce 丢步）
    _dispatcher?.dispatchImmediate(
      FtmsCommand(0x02, _buildValueBytes(0x02, newValue)),
    );
    state = state.copyWith(sportSpeedButton: newValue);
  }

  void speedDownLongPress() {
    final current = state.sportSpeedButton;
    final v = (current - _speedLongPressStepEff).clamp(
      _speedMinEff,
      _speedMaxEff,
    );
    final newValue = double.parse(v.toStringAsFixed(1));
    _paramSyncEngine.lock(ParamDimension.speed, newValue, current);
    _dispatcher?.dispatchImmediate(
      FtmsCommand(0x02, _buildValueBytes(0x02, newValue)),
    );
    state = state.copyWith(sportSpeedButton: newValue);
  }

  void inclinationAddLongPress() {
    final current = state.sportInclinationButton;
    final v = (current + _inclinationLongPressStepEff).clamp(
      _inclinationMinEff,
      _inclinationMaxEff,
    );
    final newValue = double.parse(v.toStringAsFixed(1));
    _paramSyncEngine.lock(ParamDimension.inclination, newValue, current);
    _dispatcher?.dispatchImmediate(
      FtmsCommand(0x03, _buildValueBytes(0x03, newValue)),
    );
    state = state.copyWith(sportInclinationButton: newValue);
  }

  void inclinationDownLongPress() {
    final current = state.sportInclinationButton;
    final v = (current - _inclinationLongPressStepEff).clamp(
      _inclinationMinEff,
      _inclinationMaxEff,
    );
    final newValue = double.parse(v.toStringAsFixed(1));
    _paramSyncEngine.lock(ParamDimension.inclination, newValue, current);
    _dispatcher?.dispatchImmediate(
      FtmsCommand(0x03, _buildValueBytes(0x03, newValue)),
    );
    state = state.copyWith(sportInclinationButton: newValue);
  }

  void resistanceAddLongPress() {
    final current = state.sportResistanceButton;
    final v = (current + _resistanceLongPressStepEff).clamp(
      _resistanceMinEff,
      _resistanceMaxEff,
    );
    final newValue = v.round().toDouble();
    _paramSyncEngine.lock(ParamDimension.resistance, newValue, current);
    _dispatcher?.dispatchImmediate(
      FtmsCommand(0x04, _buildValueBytes(0x04, newValue)),
    );
    state = state.copyWith(sportResistanceButton: newValue);
  }

  void resistanceDownLongPress() {
    final current = state.sportResistanceButton;
    final v = (current - _resistanceLongPressStepEff).clamp(
      _resistanceMinEff,
      _resistanceMaxEff,
    );
    final newValue = v.round().toDouble();
    _paramSyncEngine.lock(ParamDimension.resistance, newValue, current);
    _dispatcher?.dispatchImmediate(
      FtmsCommand(0x04, _buildValueBytes(0x04, newValue)),
    );
    state = state.copyWith(sportResistanceButton: newValue);
  }

  // ─── 长按结束保护窗口（对接 SportControlPanel.onLongPressEnd） ───

  /// 长按结束时调用，开启保护窗口，防止设备回调覆盖本地按钮值。
  void longPressEnd() {
    _syncGuard?.beginGuardWindow(const Duration(milliseconds: 1500));
    debugPrint('🛡️ [CourseControl] longPressEnd: 保护窗口已开启 (1500ms)');
  }

  /// 参数同步辅助方法（防弹跳核心）。
  ///
  /// 根据引擎决策结果决定是否更新按钮值：
  /// - ParamSyncMatched: 匹配成功，更新按钮值
  /// - ParamSyncStableIdle: 设备端稳定，更新按钮值
  /// - ParamSyncWaiting: 中间值，不更新
  /// - ParamSyncLockTimeout: 锁超时，不更新
  void _syncParam(
    ParamDimension dim,
    double actual,
    void Function(double value) onUpdate,
  ) {
    final decision = _paramSyncEngine.onActualUpdate(dim, actual);
    switch (decision) {
      case ParamSyncMatched():
        onUpdate(actual);
        if (kDebugMode) {
          debugPrint('[CoursePlay] ✅ 参数同步成功: dim=${dim.name}, value=$actual');
        }
      case ParamSyncStableIdle(:final value):
        onUpdate(value);
        if (kDebugMode) {
          debugPrint('[CoursePlay] 📡 设备端稳定值同步: dim=${dim.name}, value=$value');
        }
      case ParamSyncWaiting():
        // 中间值/渐变中：不改按钮
        break;
      case ParamSyncLockTimeout():
        // 锁超时：不改按钮，等待指令重发
        if (kDebugMode) {
          debugPrint('[CoursePlay] ⏰ 锁超时: dim=${dim.name}，等待指令重发');
        }
    }
  }

  // ══════════════════════════════════════════════════════════
  // 工具方法
  // ══════════════════════════════════════════════════════════

  /// 动态重建帧动画定时器（根据当前动作的imageFps调整帧率）
  void _restartImageFrameTimer(int imageFps) {
    // 🔴 资源清理守卫：已清理则不重建定时器
    if (_isCleanedUp) return;
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
