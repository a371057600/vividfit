import 'package:flutter/material.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../models/device_control_callbacks.dart';
import '../models/device_control_data.dart';
import 'level_control_button.dart';
import 'pill_control_button.dart';

/// 运动控制面板布局风格。
enum ControlPanelStyle {
  /// 完整布局（快速开始页：5 档按钮样式，使用 [LevelControlButton]）。
  full,

  /// 紧凑布局（课程播放页：药丸形加减按钮，使用 [PillControlButton]）。
  compact,
}

/// 运动控制面板。
///
/// 根据 [style] 选择底层渲染组件：
///   - [ControlPanelStyle.full]: 使用 [LevelControlButton] 渲染 5 档控制按钮
///   - [ControlPanelStyle.compact]: 使用 [PillControlButton] 渲染药丸形加减按钮
///
/// 根据 [deviceType] 自动决定显示哪些按钮组：
///   - [FtmsDeviceType.indoorBike]: 阻力
///   - [FtmsDeviceType.treadmill]: 坡度 + 速度
///   - [FtmsDeviceType.crossTrainer]: 阻力 + 坡度
///   - [FtmsDeviceType.rower]: 阻力
class SportControlPanel extends StatelessWidget {
  const SportControlPanel({
    super.key,
    required this.style,
    required this.deviceType,
    this.data,
    this.callbacks,
  });

  /// 布局风格。
  final ControlPanelStyle style;

  /// 设备类型，决定按钮组组合。
  final FtmsDeviceType deviceType;

  /// 按钮数据。
  final DeviceControlData? data;

  /// 按钮回调。
  final DeviceControlCallbacks? callbacks;

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox.shrink();

    switch (style) {
      case ControlPanelStyle.full:
        return LevelControlButton(
          callbacks: _filterCallbacks(callbacks),
          data: data,
        );
      case ControlPanelStyle.compact:
        return _buildCompactPanel(context);
    }
  }

  /// 根据 [deviceType] 过滤回调，避免渲染设备不支持的按钮组。
  DeviceControlCallbacks? _filterCallbacks(DeviceControlCallbacks? cb) {
    if (cb == null) return null;
    final supportsSpeed = deviceType.supportsSpeedControl;
    final supportsIncline = deviceType.supportsInclinationControl;
    final supportsResistance = deviceType.supportsResistanceControl;

    return DeviceControlCallbacks(
      onSpeedAdd: supportsSpeed ? cb.onSpeedAdd : null,
      onSpeedDown: supportsSpeed ? cb.onSpeedDown : null,
      onSpeedLongPressAdd: supportsSpeed ? cb.onSpeedLongPressAdd : null,
      onSpeedLongPressDown: supportsSpeed ? cb.onSpeedLongPressDown : null,
      onSpeedPreset: supportsSpeed ? cb.onSpeedPreset : null,
      onInclineAdd: supportsIncline ? cb.onInclineAdd : null,
      onInclineDown: supportsIncline ? cb.onInclineDown : null,
      onInclineLongPressAdd: supportsIncline ? cb.onInclineLongPressAdd : null,
      onInclineLongPressDown: supportsIncline
          ? cb.onInclineLongPressDown
          : null,
      onInclinePreset: supportsIncline ? cb.onInclinePreset : null,
      onResistanceAdd: supportsResistance ? cb.onResistanceAdd : null,
      onResistanceDown: supportsResistance ? cb.onResistanceDown : null,
      onResistanceLongPressAdd: supportsResistance
          ? cb.onResistanceLongPressAdd
          : null,
      onResistanceLongPressDown: supportsResistance
          ? cb.onResistanceLongPressDown
          : null,
      onResistancePreset: supportsResistance ? cb.onResistancePreset : null,
      onLongPressEnd: cb.onLongPressEnd,
    );
  }

  /// 构建紧凑布局面板（竖排药丸形按钮）。
  ///
  /// 使用 [PillControlButton] 按 阻力 → 坡度 → 速度 顺序 Column 竖排，
  /// 通过 LayoutBuilder 获取父容器宽度，按钮撑满可用宽度，高度固定 48。
  /// 彻底解决旧版 Row 横排导致的 RenderFlex 溢出崩溃。
  Widget _buildCompactPanel(BuildContext context) {
    final d = data!;
    final cb = callbacks;

    return LayoutBuilder(
      builder: (context, constraints) {
        final btnWidth = constraints.maxWidth;
        const btnHeight = 48.0;
        final children = <Widget>[];

        void addBtn({
          required String title,
          required String value,
          VoidCallback? onAdd,
          VoidCallback? onDown,
          VoidCallback? onLongPressAdd,
          VoidCallback? onLongPressDown,
          VoidCallback? onLongPressEnd,
        }) {
          if (children.isNotEmpty) children.add(const SizedBox(height: 12));
          children.add(
            PillControlButton(
              title: title,
              value: value,
              onAdd: onAdd,
              onDown: onDown,
              onLongPressAdd: onLongPressAdd,
              onLongPressDown: onLongPressDown,
              onLongPressEnd: onLongPressEnd,
              width: btnWidth,
              height: btnHeight,
            ),
          );
        }

        if (deviceType.supportsResistanceControl) {
          addBtn(
            title: '阻力',
            value: d.resistanceValue.toStringAsFixed(1),
            onAdd: cb?.onResistanceAdd,
            onDown: cb?.onResistanceDown,
            onLongPressAdd: cb?.onResistanceLongPressAdd,
            onLongPressDown: cb?.onResistanceLongPressDown,
            onLongPressEnd: cb?.onLongPressEnd,
          );
        }
        if (deviceType.supportsInclinationControl) {
          addBtn(
            title: '坡度',
            value: d.inclineValue.toStringAsFixed(1),
            onAdd: cb?.onInclineAdd,
            onDown: cb?.onInclineDown,
            onLongPressAdd: cb?.onInclineLongPressAdd,
            onLongPressDown: cb?.onInclineLongPressDown,
            onLongPressEnd: cb?.onLongPressEnd,
          );
        }
        if (deviceType.supportsSpeedControl) {
          addBtn(
            title: '速度',
            value: d.speedValue.toStringAsFixed(1),
            onAdd: cb?.onSpeedAdd,
            onDown: cb?.onSpeedDown,
            onLongPressAdd: cb?.onSpeedLongPressAdd,
            onLongPressDown: cb?.onSpeedLongPressDown,
            onLongPressEnd: cb?.onLongPressEnd,
          );
        }

        if (children.isEmpty) return const SizedBox.shrink();

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        );
      },
    );
  }
}
