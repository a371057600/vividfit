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

  /// 基于设备类型构建 mock 数据（兜底空壳，保留函数签名）
  Future<GymCoursePlayState> _buildMockData(FtmsDeviceType deviceType) async {
    final rootImagePath = await _resolveRootImagePath();

    final dir = await getApplicationDocumentsDirectory();
    final rootBgmPath = '${dir.path}/course/bgm/';
    final rootVoicePath = '${dir.path}/course/voice/';
    debugPrint('🎵 [PlayNotifier] BGM根路径: $rootBgmPath');
    debugPrint('🎵 [PlayNotifier] Voice根路径: $rootVoicePath');

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
      currentDuration: 0,
      playIndexDuration: 0,
      playTotalDuration: 0,
      totalPlayProgressDuration: 1,
      imagePlayIndex: 0,
      imageFps: 10,
      rootImagePath: rootImagePath,
      rootBgmPath: rootBgmPath,
      rootVoicePath: rootVoicePath,
      courseActions: const [],
      currentActionNameList: const ['开始'],
      progressSegments: const [],
      playProgressPercent: 0.0,
      finishDataIcons: const <String>[],
      finishDataTitles: const <String>[],
      finishDataValues: const <String>[],
      finishDataUnits: const <String>[],
      ratingTitles: const <String>[],
      ratingScores: const <int>[],
      scoreLevel: '',
      ratingImageIndices: const <int>[],
      speedChartData: const [],
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
    final actions = state.courseActions;
    if (actions.isEmpty) return;

    final firstAction = actions.first;
    final curAction = actions[state.playIndex.clamp(0, actions.length - 1)];

    final bgmPath = '${state.rootBgmPath}${firstAction.bgmName}.mp3';
    final voicePath = '${state.rootVoicePath}${curAction.voiceName}.mp3';

    // 加载并播放 BGM（循环模式）
    try {
      await _bgmPlayer.setFilePath(bgmPath);
      await _bgmPlayer.setLoopMode(LoopMode.one);
      await _bgmPlayer.play();
      debugPrint('🎵 [Audio] BGM 播放启动: $bgmPath');
    } catch (e) {
      debugPrint('❌ [Audio] BGM 加载失败: $e');
    }

    // 加载并播放 Voice（单次模式）
    try {
      await _voicePlayer.setFilePath(voicePath);
      await _voicePlayer.setLoopMode(LoopMode.off);
      await _voicePlayer.play();
      debugPrint('🎵 [Audio] Voice 播放启动: $voicePath');
    } catch (e) {
      debugPrint('❌ [Audio] Voice 加载失败: $e');
    }
  }

  /// 阶段切换：停止旧 Voice，加载并播放新 Voice（BGM 保持不变）
  Future<void> _switchVoice() async {
    final actions = state.courseActions;
    if (actions.isEmpty) return;

    final curAction = actions[state.playIndex.clamp(0, actions.length - 1)];
    final voicePath = '${state.rootVoicePath}${curAction.voiceName}.mp3';

    try {
      await _voicePlayer.stop();
      await _voicePlayer.setFilePath(voicePath);
      await _voicePlayer.setLoopMode(LoopMode.off);
      await _voicePlayer.play();
      debugPrint('🔊 [Audio] Voice 切换: ${curAction.voiceName}');
    } catch (e) {
      debugPrint('❌ [Audio] Voice 切换失败: $e');
    }
  }

  /// 暂停所有音频
  void _pauseAudio() {
    _bgmPlayer.pause();
    _voicePlayer.pause();
    debugPrint('⏸️ [Audio] 音乐暂停');
  }

  /// 恢复所有音频
  void _resumeAudio() {
    _bgmPlayer.play();
    _voicePlayer.play();
    debugPrint('▶️ [Audio] 音乐恢复');
  }

  /// 停止所有音频
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
    // 公共值：从真实 state 取值
    final totalSecs = state.playTotalDuration;
    final totalDuration = state.totalPlayProgressDuration > 0
        ? state.totalPlayProgressDuration
        : 1;
    final sportTime = formatDuration(totalSecs);
    final distance = state.sportDistance.isEmpty ? '0.00' : state.sportDistance;
    final calories = state.sportCalories.isEmpty ? '0.0' : state.sportCalories;
    final distanceNum = double.tryParse(distance) ?? 0.0;
    // 配速 Pace: min/km，distance>0 时 = (totalSecs/60) / distance
    final paceMinPerKm = distanceNum > 0
        ? '${((totalSecs / 60.0) / distanceNum).toStringAsFixed(0).padLeft(2, '0')}:${(((totalSecs / 60.0 / distanceNum) % 1) * 60).round().clamp(0, 59).toString().padLeft(2, '0')}'
        : '00:00';
    final cadence = state.sportCadence.isEmpty ? '0' : state.sportCadence;
    final cadenceNum = int.tryParse(cadence) ?? 0;
    final maxCadence = (cadenceNum * 1.1).round().clamp(0, 300).toString();
    final heartRate = state.sportHeartRate.isEmpty ? '0' : state.sportHeartRate;
    final heartRateNum = int.tryParse(heartRate) ?? 0;
    final maxHeartRate = (heartRateNum * 1.1).round().clamp(0, 220).toString();
    final strokeRate = state.sportStrokeRate.isEmpty
        ? '28'
        : state.sportStrokeRate;
    final strokeRateNum = double.tryParse(strokeRate) ?? 28.0;
    final maxStrokeRate = (strokeRateNum * 1.1).toStringAsFixed(0);
    final strokeCount = state.sportStrokeCount.isEmpty
        ? '0'
        : state.sportStrokeCount;
    final resistance = state.sportResistanceButton.toStringAsFixed(0);
    final avgResistance = resistance; // 近似取当前阻力按钮值
    // Completion 完成率：
    final completionPct = totalDuration > 0
        ? ((totalSecs / totalDuration) * 100).toStringAsFixed(1)
        : '0.0';
    final restTime = '00:00'; // state 暂无独立 restTime 字段，先用 0
    final totalCadence = (cadenceNum * (totalSecs / 60.0))
        .round()
        .clamp(0, 99999)
        .toString();

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
            sportTime,
            distance,
            calories,
            paceMinPerKm,
            cadence,
            maxCadence,
            maxHeartRate,
            totalCadence,
            restTime,
            completionPct,
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
            sportTime,
            distance,
            calories,
            paceMinPerKm,
            paceMinPerKm,
            cadence,
            maxHeartRate,
            cadence,
            totalCadence,
            completionPct,
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
            sportTime,
            distance,
            calories,
            paceMinPerKm,
            cadence,
            totalCadence,
            maxCadence,
            maxHeartRate,
            restTime,
            completionPct,
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
            sportTime,
            distance,
            calories,
            strokeRate,
            avgResistance,
            strokeCount,
            maxStrokeRate,
            maxHeartRate,
            restTime,
            completionPct,
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
    // 公共计算
    final totalSecs = state.playTotalDuration;
    final totalDur = state.totalPlayProgressDuration > 0
        ? state.totalPlayProgressDuration
        : 1;
    final completionRatio = (totalSecs / totalDur).clamp(0.0, 1.0);
    final caloriesNum = double.tryParse(state.sportCalories) ?? 0.0;
    final cadenceNum = int.tryParse(state.sportCadence) ?? 0;
    final hasCadence = cadenceNum > 0;
    // 1. Completion 完成率评分 1~5
    final completionScore = (completionRatio * 5.0).round().clamp(1, 5);
    // 2. Stability 稳定性：默认3；踏频存在且较高(>=70)时+1；完成率高时(>=0.8)再+0
    final stabilityBase = hasCadence ? 3 : 2;
    final stabilityBonus = (hasCadence && cadenceNum >= 70) ? 1 : 0;
    final stabilityScore = (stabilityBase + stabilityBonus).clamp(1, 5);
    // 3. Effort 努力评分：与卡路里正相关，>=500kcal=5，>=250=4，>=100=3，>=30=2，否则1
    final effortScore = caloriesNum >= 500
        ? 5
        : caloriesNum >= 250
        ? 4
        : caloriesNum >= 100
        ? 3
        : caloriesNum >= 30
        ? 2
        : 1;
    // 4. Coherence 连贯性：与完成率正相关，近似 completionScore-1 再 clamp 1~5
    final coherenceScore = (completionScore - 1).clamp(1, 5);
    // Level 映射：平均>=4 A, >=3 B, >=2 C 否则 D
    final allScoresAvg =
        (completionScore + stabilityScore + effortScore + coherenceScore) / 4;
    final scoreLevel = allScoresAvg >= 4.0
        ? 'Level A'
        : allScoresAvg >= 3.0
        ? 'Level B'
        : allScoresAvg >= 2.0
        ? 'Level C'
        : 'Level D';

    switch (deviceType) {
      case FtmsDeviceType.treadmill:
        return (
          ['Completion', 'Stability', 'Slope Control', 'Exercise Coherence'],
          [completionScore, stabilityScore, effortScore, coherenceScore],
          scoreLevel,
          [
            (completionScore - 1).clamp(0, 3),
            (stabilityScore - 1).clamp(0, 3),
            (effortScore - 1).clamp(0, 3),
            (coherenceScore - 1).clamp(0, 3),
          ],
        );
      case FtmsDeviceType.indoorBike:
        return (
          ['Completion', 'Stability', 'Pedaling Eff.', 'Coherence'],
          [completionScore, stabilityScore, effortScore, coherenceScore],
          scoreLevel,
          [
            (completionScore - 1).clamp(0, 3),
            (stabilityScore - 1).clamp(0, 3),
            (effortScore - 1).clamp(0, 3),
            (coherenceScore - 1).clamp(0, 3),
          ],
        );
      case FtmsDeviceType.crossTrainer:
        return (
          ['Completion', 'Stability', 'Pedaling Eff.', 'Coherence'],
          [completionScore, effortScore, stabilityScore, coherenceScore],
          scoreLevel,
          [
            (completionScore - 1).clamp(0, 3),
            (effortScore - 1).clamp(0, 3),
            (stabilityScore - 1).clamp(0, 3),
            (coherenceScore - 1).clamp(0, 3),
          ],
        );
      case FtmsDeviceType.rower:
        return (
          ['Completion', 'Endurance', 'Exercise Eff.', 'Stability'],
          [completionScore, stabilityScore, effortScore, coherenceScore],
          scoreLevel,
          [
            (completionScore - 1).clamp(0, 3),
            (stabilityScore - 1).clamp(0, 3),
            (effortScore - 1).clamp(0, 3),
            (coherenceScore - 1).clamp(0, 3),
          ],
        );
      case FtmsDeviceType.strengthStation:
        // 力量站预留：评分与单车一致
        return (
          ['Completion', 'Stability', 'Pedaling Eff.', 'Coherence'],
          [completionScore, stabilityScore, effortScore, coherenceScore],
          scoreLevel,
          [
            (completionScore - 1).clamp(0, 3),
            (stabilityScore - 1).clamp(0, 3),
            (effortScore - 1).clamp(0, 3),
            (coherenceScore - 1).clamp(0, 3),
          ],
        );
    }
  }

  // ══════════════════════════════════════════════════════════
  // 初始化
  // ══════════════════════════════════════════════════════════

  void resetToLoading() {
    _playTickTimer?.cancel();
    _imageFrameTimer?.cancel();
    _stopAudio();
    unawaited(_bgmPlayer.seek(Duration.zero));
    unawaited(_voicePlayer.seek(Duration.zero));
    debugPrint('🧹 [PlayNotifier] resetToLoading: audio cursor seek(zero)');
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

  /// 用户点击中央 Play → 启动定时器
  void togglePlay() {
    if (state.isPlaying) {
      // 暂停：停止定时器 + 显示覆盖层
      pauseSport();
    } else {
      // 启动：隐藏按钮 + 启动定时器
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

  /// 暂停定时器（不改变 showPlayButton，由调用方控制）
  void _pauseTimers() {
    _playTickTimer?.cancel();
    _imageFrameTimer?.cancel();
  }

  /// 每秒 tick：累加 playIndexDuration / playTotalDuration + 计算进度 + 模拟运动数据
  void _tickPlaySecond() {
    if (state.isPause || state.isStopScreen || !state.isPlaying) return;

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
    if (state.isPause || state.isStopScreen || !state.isPlaying) return;
    final actions = state.courseActions;
    if (actions.isEmpty) return;
    final cur = actions[state.playIndex.clamp(0, actions.length - 1)];
    int nextFrame = state.imagePlayIndex + 1;
    if (nextFrame >= cur.imageLength) nextFrame = 0;
    state = state.copyWith(imagePlayIndex: nextFrame);
  }

  /// 播放完成 → 进入结束页
  void _finishPlay() {
    _playTickTimer?.cancel();
    _imageFrameTimer?.cancel();
    _stopAudio();
    state = state.copyWith(
      isPlaying: false,
      isStopScreen: true,
      screenStatus: GymPlayScreenStatus.finished,
      showPlayButton: false,
      sportTime: formatDuration(state.totalPlayProgressDuration),
    );
    debugPrint('🏁 [Play] 课程播放完成，已进入结束页');
  }

  /// 用户主动结束课程 → 进入结束页（复刻原版返回按钮逻辑）
  void manualFinish() {
    _playTickTimer?.cancel();
    _imageFrameTimer?.cancel();
    _stopAudio();
    state = state.copyWith(
      isPlaying: false,
      isPause: false,
      isPauseScreen: false,
      isStopScreen: true,
      screenStatus: GymPlayScreenStatus.finished,
      showPlayButton: false,
      sportTime: formatDuration(state.playTotalDuration),
    );
    debugPrint('🏁 [Play] 用户主动结束课程，进入结束页');
  }

  // ══════════════════════════════════════════════════════════
  // 暂停/恢复/退出
  // ══════════════════════════════════════════════════════════

  void pauseSport() {
    _pauseTimers();
    _pauseAudio();
    state = state.copyWith(
      isPause: true,
      isPauseScreen: true,
      showPlayButton: true,
    );
    debugPrint('⏸️ [Play] 暂停，定时器已挂起');
  }

  void resumeSport() {
    state = state.copyWith(
      isPause: false,
      isPauseScreen: false,
      showPlayButton: false,
      isPlaying: true,
    );
    _startTimers();
    _resumeAudio();
    debugPrint('▶️ [Play] 恢复，定时器已重启');
  }

  void disposeAll() {
    _playTickTimer?.cancel();
    _imageFrameTimer?.cancel();
    _stopAudio();
    unawaited(_bgmPlayer.seek(Duration.zero));
    unawaited(_voicePlayer.seek(Duration.zero));
    debugPrint(
      '🧹 [PlayNotifier] disposeAll: timers canceled + audio stopped + seek zero',
    );
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
