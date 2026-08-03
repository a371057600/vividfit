import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../data/sport_metric_icons.dart';
import '../states/gym_course_play_state.dart';

part 'gym_course_play_notifier.g.dart';

/// 课程播放页 Notifier（对应旧 ControllerBigDeviceCoursePlay + ControllerNewFourBigDeviceSprot）
///
/// 职责：
/// 1. 维护页面三态（loading / playing / finished）
/// 2. 提供所有 UI 组件的 mock 数据
/// 3. 设备控制按钮的交互（速度/坡度/阻力 +/−）
@Riverpod(keepAlive: true)
class GymCoursePlayNotifier extends _$GymCoursePlayNotifier {
  @override
  GymCoursePlayState build() => _buildMockData(FtmsDeviceType.indoorBike);

  /// 基于设备类型构建 mock 数据
  GymCoursePlayState _buildMockData(FtmsDeviceType deviceType) {
    // 课程动作列表（6 段：热身→冲刺→爬坡→恢复→耐力→放松）
    const actions = [
      ActionItemState(
        name: 'Warm Up',
        imageName: 'warm_up',
        duration: 60,
        resistance: 2,
        cadence: 20,
        posture: 0,
        isRestStage: true,
        imageFps: 30,
        imageLength: 60,
        orderId: 0,
      ),
      ActionItemState(
        name: 'Sprint',
        imageName: 'sprint',
        duration: 120,
        resistance: 5,
        cadence: 45,
        posture: 2,
        isRestStage: false,
        imageFps: 30,
        imageLength: 90,
        orderId: 1,
      ),
      ActionItemState(
        name: 'Climb',
        imageName: 'climb',
        duration: 90,
        resistance: 8,
        cadence: 30,
        posture: 3,
        isRestStage: false,
        imageFps: 30,
        imageLength: 90,
        orderId: 2,
      ),
      ActionItemState(
        name: 'Recovery',
        imageName: 'recovery',
        duration: 45,
        resistance: 2,
        cadence: 15,
        posture: 0,
        isRestStage: true,
        imageFps: 30,
        imageLength: 60,
        orderId: 3,
      ),
      ActionItemState(
        name: 'Endurance',
        imageName: 'endurance',
        duration: 150,
        resistance: 6,
        cadence: 35,
        posture: 1,
        isRestStage: false,
        imageFps: 30,
        imageLength: 120,
        orderId: 4,
      ),
      ActionItemState(
        name: 'Cool Down',
        imageName: 'cool_down',
        duration: 60,
        resistance: 1,
        cadence: 10,
        posture: 0,
        isRestStage: true,
        imageFps: 30,
        imageLength: 60,
        orderId: 5,
      ),
    ];

    final actionNames = actions.map((e) => e.name).toList();
    final progressSegments = _buildProgressSegments(actions, deviceType);

    // 按设备类型生成结束页数据
    final finishData = _buildFinishData(deviceType);

    // 按设备类型生成评分
    final ratingData = _buildRatingData(deviceType);

    // 速度条形图数据（10 条）
    const speedChart = [12.0, 15.0, 18.0, 20.0, 22.0, 25.0, 23.0, 20.0, 18.0, 15.0];

    // 实时数据（当前运动中）
    const sportTime = '05:30';
    const sportDistance = '1.25';
    const sportCalories = '45.5';
    const sportSpeed = '25.0';
    const sportHeartRate = '128';
    const sportCadence = '85';
    const sportStrokeRate = '28';
    const sportStrokeCount = '156';
    const sportInclination = '5.0';
    const sportResistance = '3';

    return GymCoursePlayState(
      deviceType: deviceType,
      screenStatus: GymPlayScreenStatus.playing,
      allowTouch: true,
      showPlayButton: false,
      isPlaying: true,
      isPause: false,
      isStopScreen: false,
      courseTitle: 'Power Cycle Pro',
      difficulty: 'Intermediate',
      level: 3,
      targetResistanceLevel: 3,
      // 实时数据
      sportTime: sportTime,
      sportDistance: sportDistance,
      sportCalories: sportCalories,
      sportSpeed: sportSpeed,
      sportDeviceSpeed: 25.0,
      sportHeartRate: sportHeartRate,
      sportCadence: sportCadence,
      sportStrokeRate: sportStrokeRate,
      sportStrokeCount: sportStrokeCount,
      sportInclination: sportInclination,
      sportResistance: sportResistance,
      // 按钮值
      sportSpeedButton: 25.0,
      sportInclinationButton: 5.0,
      sportResistanceButton: 3.0,
      hasInclinationSupport: deviceType == FtmsDeviceType.treadmill,
      // 进度
      playIndex: 1,
      currentDuration: 120,
      playIndexDuration: 45,
      playTotalDuration: 105,
      totalPlayProgressDuration: 525,
      imagePlayIndex: 45,
      playProgressPercent: 0.20,
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
      speedChartData: speedChart,
    );
  }

  /// 构建进度条分段数据
  List<GymProgressSegment> _buildProgressSegments(
    List<ActionItemState> actions,
    FtmsDeviceType deviceType,
  ) {
    final totalDuration = actions.fold<int>(0, (a, b) => a + b.duration);
    if (totalDuration == 0) return [];

    final colors = [
      0xFF80FFCC,
      0xFF7B93FF,
      0xFFFFDD66,
      0xFFFF9999,
      0xFF66CCFF,
      0xFFCCAA88,
      0xFFAAAAAA,
    ];

    return actions.asMap().entries.map((entry) {
      final index = entry.key;
      final action = entry.value;
      final percentage = action.duration / totalDuration;

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

  /// 按设备类型构建结束页数据（10 项）
  /// 返回 (icons, titles, values, units)
  (List<String>, List<String>, List<String>, List<String>) _buildFinishData(
    FtmsDeviceType deviceType,
  ) {
    // 图标路径前缀
    const iconBase = 'images/newUIScreen/bigScreenAnimation/bigDevicePlayCourseIcon';

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

      default:
        return _buildFinishData(FtmsDeviceType.indoorBike);
    }
  }

  /// 按设备类型构建评分数据
  /// 返回 (titles, scores, scoreLevel, imageIndices)
  (List<String>, List<int>, String, List<int>) _buildRatingData(
    FtmsDeviceType deviceType,
  ) {
    switch (deviceType) {
      case FtmsDeviceType.indoorBike:
        return (
          ['Completion', 'Stability', 'Pedaling Eff.', 'Coherence'],
          [4, 3, 4, 3],
          'Level A',
          [0, 0, 0, 2],
        );

      case FtmsDeviceType.treadmill:
        return (
          ['Completion', 'Stability', 'Slope Control', 'Exercise Coherence'],
          [4, 4, 3, 3],
          'Level A',
          [0, 0, 0, 2],
        );

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

      default:
        return _buildRatingData(FtmsDeviceType.indoorBike);
    }
  }

  // ─── 公共方法 ───────────────────────────────────────

  /// 切换设备类型（重建 mock 数据）
  void switchDevice(FtmsDeviceType type) {
    state = _buildMockData(type);
  }

  /// 切换播放状态
  void togglePlay() {
    state = state.copyWith(
      isPlaying: !state.isPlaying,
      showPlayButton: state.isPlaying,
    );
  }

  /// 暂停运动（显示暂停覆盖层）
  void pauseSport() {
    debugPrint('🔴 [PlayScreen] pauseSport() called');
    state = state.copyWith(
      isPause: true,
      isPauseScreen: true,
      showPlayButton: true,
    );
    debugPrint('🔴 [PlayScreen] State after pause: isPause=${state.isPause}, isPauseScreen=${state.isPauseScreen}');
  }

  /// 恢复运动（隐藏暂停覆盖层）
  void resumeSport() {
    debugPrint('🟢 [PlayScreen] resumeSport() called');
    state = state.copyWith(
      isPause: false,
      isPauseScreen: false,
      showPlayButton: false,
    );
    debugPrint('🟢 [PlayScreen] State after resume: isPause=${state.isPause}, isPauseScreen=${state.isPauseScreen}');
  }

  /// 退出课程，清理状态准备返回详情页
  void exitToDetail() {
    debugPrint('🔵 [PlayScreen] exitToDetail() called');
    state = state.copyWith(
      isPause: false,
      isPauseScreen: false,
      isPlaying: false,
      showPlayButton: false,
      isStopScreen: false,
    );
    debugPrint('🔵 [PlayScreen] State after exit: isPlaying=${state.isPlaying}');
  }

  /// 显示/隐藏结束页
  void showStopScreen(bool value) {
    state = state.copyWith(isStopScreen: value);
  }

  /// 速度+
  void speedAdd() {
    final v = (state.sportSpeedButton + 1.0).clamp(0.0, 50.0);
    state = state.copyWith(sportSpeedButton: double.parse(v.toStringAsFixed(1)));
  }

  /// 速度-
  void speedDown() {
    final v = (state.sportSpeedButton - 1.0).clamp(0.0, 50.0);
    state = state.copyWith(sportSpeedButton: double.parse(v.toStringAsFixed(1)));
  }

  /// 坡度+
  void inclinationAdd() {
    final v = (state.sportInclinationButton + 1.0).clamp(0.0, 10.0);
    state = state.copyWith(sportInclinationButton: double.parse(v.toStringAsFixed(1)));
  }

  /// 坡度-
  void inclinationDown() {
    final v = (state.sportInclinationButton - 1.0).clamp(0.0, 10.0);
    state = state.copyWith(sportInclinationButton: double.parse(v.toStringAsFixed(1)));
  }

  /// 阻力+
  void resistanceAdd() {
    final v = (state.sportResistanceButton + 1.0).clamp(1.0, 10.0);
    state = state.copyWith(sportResistanceButton: double.parse(v.toStringAsFixed(1)));
  }

  /// 阻力-
  void resistanceDown() {
    final v = (state.sportResistanceButton - 1.0).clamp(1.0, 10.0);
    state = state.copyWith(sportResistanceButton: double.parse(v.toStringAsFixed(1)));
  }

  /// 格式化秒数为 mm:ss
  String formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  /// 进度条各项占比
  List<double> barLinePercentages() {
    final total = state.courseActions.fold<int>(0, (a, b) => a + b.duration);
    if (total == 0) return List.filled(state.courseActions.length, 0.0);
    final raw = state.courseActions.map((a) => a.duration / total * 1000).toList();
    final rounded = raw.map((e) => e.round()).toList();
    final diff = 1000 - rounded.fold<int>(0, (a, b) => a + b);
    if (diff != 0 && rounded.isNotEmpty) {
      rounded[rounded.length - 1] += diff > 0 ? -diff : diff;
    }
    return rounded.map((e) => e / 1000.0).toList();
  }
}
