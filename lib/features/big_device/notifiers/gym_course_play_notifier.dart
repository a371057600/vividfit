import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ftms/ftms_device_type.dart';
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

  @override
  GymCoursePlayState build() {
    // Notifier 销毁时清理定时器，避免泄漏
    ref.onDispose(() {
      _playTickTimer?.cancel();
      _imageFrameTimer?.cancel();
      _bgmPlayer.dispose();
      _voicePlayer.dispose();
      debugPrint('🧹 [PlayNotifier] onDispose 定时器已清理');
      debugPrint('🧹 [Audio] 播放器已释放');
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

    final actionNames = _buildRightActionNameList(actions);
    final progressSegments = _buildProgressSegments(actions, deviceType);
    final totalDuration = actions.fold<int>(0, (a, b) => a + b.duration);

    // 图片根路径（本地 courses/课程ID/pictures 目录）
    final rootImagePath = await _resolveRootImagePath();

    // BGM / Voice 根路径（本地 courses/bgm 和 courses/voice 目录）
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
      showPlayButton: true, // ⚠️ 初始显示中央 Play（需要用户点击启动）
      isPlaying: false,
      isPause: false,
      isStopScreen: false,
      courseTitle: '金字塔变速跑',
      difficulty: '进阶',
      level: 3,
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
      currentDuration: actions.first.duration,
      playIndexDuration: 0,
      playTotalDuration: 0,
      totalPlayProgressDuration: totalDuration,
      imagePlayIndex: 0,
      imageFps: 10,
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
      // 速度图（由定时器逐步填充，初始为空）
      speedChartData: [],
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

    final actionNames = _buildRightActionNameList(playActions);
    final progressSegments = _buildProgressSegments(playActions, deviceType);
    final totalDuration = playActions.fold<int>(0, (a, b) => a + b.duration);

    final rootImagePath = await _resolveRootImagePath();
    final dir = await getApplicationDocumentsDirectory();
    final rootBgmPath = '${dir.path}/course/bgm/';
    final rootVoicePath = '${dir.path}/course/voice/';
    debugPrint('🎵 [PlayNotifier] BGM根路径: $rootBgmPath');
    debugPrint('🎵 [PlayNotifier] Voice根路径: $rootVoicePath');

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
      courseTitle: '训练课程',
      difficulty: '进阶',
      level: 3,
      targetResistanceLevel: 3,
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
      sportSpeedButton: 0.0,
      sportInclinationButton: 3.0,
      sportResistanceButton: 3.0,
      hasInclinationSupport: deviceType == FtmsDeviceType.treadmill,
      playIndex: 0,
      currentDuration: playActions.first.duration,
      playIndexDuration: 0,
      playTotalDuration: 0,
      totalPlayProgressDuration: totalDuration,
      imagePlayIndex: 0,
      imageFps: playActions.first.imageFps,
      rootImagePath: rootImagePath,
      rootBgmPath: rootBgmPath,
      rootVoicePath: rootVoicePath,
      playProgressPercent: 0.0,
      courseActions: playActions,
      currentActionNameList: actionNames,
      progressSegments: progressSegments,
      finishDataIcons: finishData.$1,
      finishDataTitles: finishData.$2,
      finishDataValues: finishData.$3,
      finishDataUnits: finishData.$4,
      ratingTitles: ratingData.$1,
      ratingScores: ratingData.$2,
      scoreLevel: ratingData.$3,
      ratingImageIndices: ratingData.$4,
      speedChartData: [],
    );
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
      debugPrint(
        '🔁 [PlayTick] 阶段切换 playIndex=$playIndex, '
        'name=${actions[playIndex].name}, duration=${actions[playIndex].duration}s',
      );
      _switchVoice();
    }

    // 全部结束 → 显示结束页
    final totalDuration = state.totalPlayProgressDuration;
    if (playTotalDuration >= totalDuration) {
      _finishPlay();
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

    final percent = playTotalDuration / totalDuration.clamp(1, 1 << 30);

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

  /// 播放完成 → 进入结束页
  /// 🔴 顺序：先 setState + _audioTerminated=true（同步锁，防 await 穿透
  void _finishPlay() {
    // 🔴 第 0 步：同步锁布尔（优先级最高，比 setState 还先）
    _audioTerminated = true;
    debugPrint(
      '🛑 [AudioGuard] _finishPlay() → _audioTerminated = true（禁止再启音）',
    );
    // 🔴 第一步：先写 state（锁 isStopScreen=true）
    state = state.copyWith(
      isPlaying: false,
      isStopScreen: true,
      screenStatus: GymPlayScreenStatus.finished,
      showPlayButton: false,
      sportTime: formatDuration(state.totalPlayProgressDuration),
    );
    // 🔴 第二步：cancel + stop + seek zero
    _playTickTimer?.cancel();
    _imageFrameTimer?.cancel();
    _stopAudio();
    unawaited(_bgmPlayer.seek(Duration.zero));
    unawaited(_voicePlayer.seek(Duration.zero));
    debugPrint('🏁 [Play] 课程播放完成，已进入结束页（先锁屏再stop）');
  }

  /// 用户主动结束课程 → 进入结束页（复刻原版返回按钮逻辑）
  /// 🔴 顺序：先 _audioTerminated=true（同步锁
  void manualFinish() {
    // 🔴 第 0 步：同步锁布尔（优先级最高，在任何 setState/await 之前）
    _audioTerminated = true;
    debugPrint(
      '🛑 [AudioGuard] manualFinish() → _audioTerminated = true（禁止再启音）',
    );
    // 🔴 第一步：锁屏态（先写 state，拦截 _switchVoice/_tickPlaySecond）
    state = state.copyWith(
      isPlaying: false,
      isPause: false,
      isPauseScreen: false,
      isStopScreen: true,
      screenStatus: GymPlayScreenStatus.finished,
      showPlayButton: false,
      sportTime: formatDuration(state.playTotalDuration),
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

  void pauseSport() {
    debugPrint(
      '⚠️ [PlayNotifier] pauseSport 已废弃（流程=直接结算→manualFinish，不再弹中间确认）',
    );
    manualFinish();
  }

  void resumeSport() {
    debugPrint('⚠️ [PlayNotifier] resumeSport 已被禁用（流程=结束后不能再返回播放，直接走结算）');
  }

  void exitToDetail() {
    _playTickTimer?.cancel();
    _imageFrameTimer?.cancel();
    _stopAudio();
    state = state.copyWith(
      isPause: false,
      isPauseScreen: false,
      isPlaying: false,
      showPlayButton: false,
      isStopScreen: false,
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
  // 控制按钮 +/−（无蓝牙，纯修改本地 state 值）
  // ══════════════════════════════════════════════════════════

  void speedAdd() {
    final v = (state.sportSpeedButton + 0.5).clamp(0.0, 50.0);
    state = state.copyWith(
      sportSpeedButton: double.parse(v.toStringAsFixed(1)),
    );
  }

  void speedDown() {
    final v = (state.sportSpeedButton - 0.5).clamp(0.0, 50.0);
    state = state.copyWith(
      sportSpeedButton: double.parse(v.toStringAsFixed(1)),
    );
  }

  void inclinationAdd() {
    final v = (state.sportInclinationButton + 1.0).clamp(-5.0, 15.0);
    state = state.copyWith(
      sportInclinationButton: double.parse(v.toStringAsFixed(1)),
    );
  }

  void inclinationDown() {
    final v = (state.sportInclinationButton - 1.0).clamp(-5.0, 15.0);
    state = state.copyWith(
      sportInclinationButton: double.parse(v.toStringAsFixed(1)),
    );
  }

  void resistanceAdd() {
    final v = (state.sportResistanceButton + 1.0).clamp(1.0, 20.0);
    state = state.copyWith(
      sportResistanceButton: double.parse(v.toStringAsFixed(1)),
    );
  }

  void resistanceDown() {
    final v = (state.sportResistanceButton - 1.0).clamp(1.0, 20.0);
    state = state.copyWith(
      sportResistanceButton: double.parse(v.toStringAsFixed(1)),
    );
  }

  // ══════════════════════════════════════════════════════════
  // 工具方法
  // ══════════════════════════════════════════════════════════

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
