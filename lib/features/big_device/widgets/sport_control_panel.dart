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
  ///
  /// 长按功能规则：**仅速度按钮支持长按**（速度步进 0.1，需长按快速调整），
  /// 坡度 / 阻力的长按回调强制置 null，对应按钮不绑定长按手势。
  DeviceControlCallbacks? _filterCallbacks(DeviceControlCallbacks? cb) {
    if (cb == null) return null;
    final supportsSpeed = deviceType.supportsSpeedControl;
    final supportsIncline = deviceType.supportsInclinationControl;
    final supportsResistance = deviceType.supportsResistanceControl;

    return DeviceControlCallbacks(
      onSpeedAdd: supportsSpeed ? cb.onSpeedAdd : null,
      onSpeedDown: supportsSpeed ? cb.onSpeedDown : null,
      // 速度：保留长按（唯一支持长按的维度）
      onSpeedLongPressAdd: supportsSpeed ? cb.onSpeedLongPressAdd : null,
      onSpeedLongPressDown: supportsSpeed ? cb.onSpeedLongPressDown : null,
      onSpeedPreset: supportsSpeed ? cb.onSpeedPreset : null,
      onInclineAdd: supportsIncline ? cb.onInclineAdd : null,
      onInclineDown: supportsIncline ? cb.onInclineDown : null,
      // 坡度：不支持长按
      onInclineLongPressAdd: null,
      onInclineLongPressDown: null,
      onInclinePreset: supportsIncline ? cb.onInclinePreset : null,
      onResistanceAdd: supportsResistance ? cb.onResistanceAdd : null,
      onResistanceDown: supportsResistance ? cb.onResistanceDown : null,
      // 阻力：不支持长按
      onResistanceLongPressAdd: null,
      onResistanceLongPressDown: null,
      onResistancePreset: supportsResistance ? cb.onResistancePreset : null,
      // 长按结束仅对速度维度有意义（坡度/阻力无长按）
      onLongPressEnd: supportsSpeed ? cb.onLongPressEnd : null,
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
            value: d.resistanceValue.toStringAsFixed(0),
            onAdd: cb?.onResistanceAdd,
            onDown: cb?.onResistanceDown,
            // 阻力：不支持长按
            onLongPressAdd: null,
            onLongPressDown: null,
            onLongPressEnd: null,
          );
        }
        if (deviceType.supportsInclinationControl) {
          addBtn(
            title: '坡度',
            value: d.inclineValue.toStringAsFixed(1),
            onAdd: cb?.onInclineAdd,
            onDown: cb?.onInclineDown,
            // 坡度：不支持长按
            onLongPressAdd: null,
            onLongPressDown: null,
            onLongPressEnd: null,
          );
        }
        if (deviceType.supportsSpeedControl) {
          addBtn(
            title: '速度',
            value: d.speedValue.toStringAsFixed(1),
            onAdd: cb?.onSpeedAdd,
            onDown: cb?.onSpeedDown,
            // 速度：保留长按（唯一支持长按的维度）
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
