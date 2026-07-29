import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../states/quick_start_state.dart';

part 'quick_start_notifier.g.dart';

/// 快速开始 Notifier（Riverpod 3.0 代码生成，业务逻辑留白）。
///
/// 所有运动控制方法暂留 TODO，待蓝牙模块完整迁移后实现。
@Riverpod(keepAlive: true)
class QuickStartNotifier extends _$QuickStartNotifier {
  FtmsDeviceType _deviceType = FtmsDeviceType.indoorBike;

  FtmsDeviceType get deviceType => _deviceType;

  void setDeviceType(FtmsDeviceType type) {
    _deviceType = type;
    // 设置mock数据用于UI调试
    state = _getMockStateForDevice(type);
  }

  /// 根据设备类型返回mock数据
  QuickStartState _getMockStateForDevice(FtmsDeviceType type) {
    switch (type) {
      case FtmsDeviceType.indoorBike:
        return state.copyWith(
          realSportTime: 125,
          sportDistance: 1250.0,
          sportEnergy: 45.0,
          sportSpeed: 22.5,
          sportCadence: 85.0,
          sportHeartRate: 128,
          npcTime: 25.0,
          maxSpeed: 0,
          sportResistanceButton: 8.0,
          sportSpeedButton: 0.0,
          sportInclinationButton: 0.0,
          buttonResistanceList: [4.0, 6.0, 10.0, 12.0],
          buttonSpeedList: [0.0, 0.0, 0.0, 0.0],
          buttonInclinationList: [0.0, 0.0, 0.0, 0.0],
          hasInclinationSupport: false,
        );
      case FtmsDeviceType.treadmill:
        return state.copyWith(
          realSportTime: 180,
          sportDistance: 2400.0,
          sportEnergy: 88.0,
          sportSpeed: 8.5,
          sportCadence: 0.0,
          sportHeartRate: 135,
          npcTime: 35.0,
          maxSpeed: 2000, // FTMS原始值，除以100=20km/h
          sportResistanceButton: 0.0,
          sportSpeedButton: 8.0,
          sportInclinationButton: 3.0,
          buttonResistanceList: [0.0, 0.0, 0.0, 0.0],
          buttonSpeedList: [4.0, 6.0, 10.0, 12.0],
          buttonInclinationList: [0.0, 1.0, 5.0, 7.0],
          hasInclinationSupport: true,
        );
      case FtmsDeviceType.crossTrainer:
        return state.copyWith(
          realSportTime: 210,
          sportDistance: 3200.0,
          sportEnergy: 120.0,
          sportSpeed: 18.0,
          sportCadence: 70.0,
          sportHeartRate: 142,
          npcTime: 40.0,
          maxSpeed: 0,
          sportResistanceButton: 12.0,
          sportSpeedButton: 0.0,
          sportInclinationButton: 5.0,
          buttonResistanceList: [6.0, 9.0, 15.0, 18.0],
          buttonSpeedList: [0.0, 0.0, 0.0, 0.0],
          buttonInclinationList: [1.0, 3.0, 7.0, 9.0],
          hasInclinationSupport: true,
        );
      case FtmsDeviceType.rower:
        return state.copyWith(
          realSportTime: 300,
          sportDistance: 1500.0,
          sportEnergy: 210.0,
          sportSpeed: 12.0,
          sportCadence: 0.0,
          sportHeartRate: 155,
          npcTime: 55.0,
          maxSpeed: 0,
          sportStrokeRate: 28.0,
          sportStrokeCount: 850.0,
          sportResistanceButton: 6.0,
          sportSpeedButton: 0.0,
          sportInclinationButton: 0.0,
          buttonResistanceList: [2.0, 4.0, 8.0, 10.0],
          buttonSpeedList: [0.0, 0.0, 0.0, 0.0],
          buttonInclinationList: [0.0, 0.0, 0.0, 0.0],
          hasInclinationSupport: false,
        );
      case FtmsDeviceType.strengthStation:
        return state;
    }
  }

  @override
  QuickStartState build() => const QuickStartState();

  /// 发送重置指令到设备（对应旧 cnfbd.sendResetToDevice）。
  void sendResetToDevice() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 开始运动（对应旧 cnfbd.startSport）。
  void startSport() {
    // TODO: 蓝牙模块迁移后实现
    state = state.copyWith(showPlayButton: false, isInQuickPlay: true);
  }

  /// 停止运动（对应旧 cnfbd.stopSport）。
  void stopSport() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 暂停运动（对应旧 cnfbd.pauseSport）。
  void pauseSport() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 清除数据（对应旧 cnfbd.clearData）。
  void clearData() {
    // TODO: 蓝牙模块迁移后实现
    state = const QuickStartState();
  }

  /// 阻力 +（对应旧 cnfbd.resistanceAdd）。
  void resistanceAdd() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 阻力 -（对应旧 cnfbd.resistanceDown）。
  void resistanceDown() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 速度 +（对应旧 cnfbd.speedAdd）。
  void speedAdd() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 速度 -（对应旧 cnfbd.speedDown）。
  void speedDown() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 坡度 +（对应旧 cnfbd.inclinationAdd）。
  void inclinationAdd() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 坡度 -（对应旧 cnfbd.inclinationDown）。
  void inclinationDown() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 长按结束（对应旧 cnfbd.longPressEnd）。
  void longPressEnd() {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 数字按钮选择（对应旧 cnfbd.numberButton）。
  void numberButton(double value, int type) {
    // TODO: 蓝牙模块迁移后实现
  }

  /// 更新音乐播放状态（对应旧 setState isMusicPlaying）。
  void updateMusicPlaying(bool playing) {
    state = state.copyWith(isMusicPlaying: playing);
  }

  /// 秒转时间字符串（对应旧 cnfbd.convertSecondsToTime）。
  String convertSecondsToTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
