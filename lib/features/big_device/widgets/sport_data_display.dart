import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../models/sport_data_model.dart';
import '../utils/device_field_visibility.dart';

/// 运动数据展示布局。
enum DataDisplayLayout {
  /// 水平布局（快速开始页：数据项横向排列）。
  horizontal,

  /// 紧凑布局（课程播放页：数据项紧凑排列）。
  compact,
}

/// 运动数据展示组件。
///
/// 根据 [deviceType] 通过 [DeviceFieldVisibility] 决定显示哪些字段，
/// 每个数据项以"图标 + 数值 + 单位"形式呈现。
/// 通过 [layout] 控制数据项的间距与字体大小。
///
/// 单位转换规则：
///   - 速度：划船机 m/s → km/h（[DeviceFieldVisibility.convertSpeed]）
///   - 距离：划船机 m → km（[DeviceFieldVisibility.convertDistance]）
///   - 时间：秒数格式化为 MM:SS
class SportDataDisplay extends StatelessWidget {
  const SportDataDisplay({
    super.key,
    required this.layout,
    required this.deviceType,
    required this.data,
  });

  /// 布局风格。
  final DataDisplayLayout layout;

  /// 设备类型，决定字段可见性。
  final FtmsDeviceType deviceType;

  /// 运动数据。
  final SportDataModel data;

  @override
  Widget build(BuildContext context) {
    final visibility = DeviceFieldVisibility(deviceType);
    final items = _buildItems(visibility);

    if (items.isEmpty) return const SizedBox.shrink();

    final spacing = 0.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _interleave(items, SizedBox(width: spacing)),
    );
  }

  /// 在 items 列表中每隔一项插入分隔 Widget。
  List<Widget> _interleave(List<Widget> items, Widget separator) {
    if (items.length <= 1) return items;
    final result = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      if (i > 0) result.add(separator);
      result.add(items[i]);
    }
    return result;
  }

  /// 根据可见性构建数据项列表（按常用展示顺序：时间 → 速度 → 距离 → 卡路里 → 心率 → 踏频 → 阻力 → 坡度 → 功率 → 桨频 → 桨数 → 剩余时间）。
  List<Widget> _buildItems(DeviceFieldVisibility visibility) {
    final isHorizontal = layout == DataDisplayLayout.horizontal;
    final items = <Widget>[];

    // 已运动时间
    if (data.elapsedSeconds != null) {
      items.add(
        _buildItem(
          icon: Icons.timer,
          value: _formatTime(data.elapsedSeconds!),
          unit: '',
          isHorizontal: isHorizontal,
        ),
      );
    }
    // 速度（划船机自动 m/s → km/h）
    if (visibility.shouldShowSpeed && data.speed != null) {
      items.add(
        _buildItem(
          icon: Icons.speed,
          value: visibility.convertSpeed(data.speed!).toStringAsFixed(1),
          unit: 'km/h',
          isHorizontal: isHorizontal,
        ),
      );
    }
    // 距离（所有设备统一 m → km，保留 2 位小数）
    if (visibility.shouldShowDistance && data.distance != null) {
      // 观测日志：仅在 debug 模式下打印，避免 release 下日志刷屏

      items.add(
        _buildItem(
          icon: Icons.place,
          value: visibility.convertDistance(data.distance!).toStringAsFixed(2),
          unit: 'km',
          isHorizontal: isHorizontal,
        ),
      );
    }
    // 卡路里
    if (visibility.shouldShowEnergy && data.energy != null) {
      items.add(
        _buildItem(
          icon: Icons.local_fire_department,
          value: data.energy.toString(),
          unit: 'kcal',
          isHorizontal: isHorizontal,
        ),
      );
    }
    // 心率
    if (visibility.shouldShowHeartRate && data.heartRate != null) {
      items.add(
        _buildItem(
          icon: Icons.favorite,
          value: data.heartRate.toString(),
          unit: 'bpm',
          isHorizontal: isHorizontal,
        ),
      );
    }
    // 踏频
    if (visibility.shouldShowCadence && data.cadence != null) {
      items.add(
        _buildItem(
          icon: Icons.autorenew,
          value: data.cadence.toString(),
          unit: 'rpm',
          isHorizontal: isHorizontal,
        ),
      );
    }
    // 阻力
    if (visibility.shouldShowResistance && data.resistanceLevel != null) {
      items.add(
        _buildItem(
          icon: Icons.tune,
          value: data.resistanceLevel.toString(),
          unit: '',
          isHorizontal: isHorizontal,
        ),
      );
    }
    // 坡度
    if (visibility.shouldShowInclination && data.inclination != null) {
      items.add(
        _buildItem(
          icon: Icons.terrain,
          value: data.inclination!.toStringAsFixed(1),
          unit: '%',
          isHorizontal: isHorizontal,
        ),
      );
    }
    // 功率
    if (visibility.shouldShowPower && data.power != null) {
      items.add(
        _buildItem(
          icon: Icons.flash_on,
          value: data.power.toString(),
          unit: 'W',
          isHorizontal: isHorizontal,
        ),
      );
    }
    // 桨频
    if (visibility.shouldShowStrokeRate && data.strokeRate != null) {
      items.add(
        _buildItem(
          icon: Icons.rowing,
          value: data.strokeRate.toString(),
          unit: 'spm',
          isHorizontal: isHorizontal,
        ),
      );
    }
    // 桨数
    if (visibility.shouldShowStrokeCount && data.strokeCount != null) {
      items.add(
        _buildItem(
          icon: Icons.format_list_numbered,
          value: data.strokeCount.toString(),
          unit: '',
          isHorizontal: isHorizontal,
        ),
      );
    }
    // 剩余时间
    if (data.remainingSeconds != null) {
      items.add(
        _buildItem(
          icon: Icons.hourglass_empty,
          value: _formatTime(data.remainingSeconds!),
          unit: '',
          isHorizontal: isHorizontal,
        ),
      );
    }

    return items;
  }

  /// 构建单个数据项（图标 + 数值 + 单位）。
  Widget _buildItem({
    required IconData icon,
    required String value,
    required String unit,
    required bool isHorizontal,
  }) {
    final valueFontSize = isHorizontal ? 18.0 : 14.0;
    final labelFontSize = isHorizontal ? 12.0 : 10.0;
    final iconSize = 20.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize, color: Colors.white70),
        const SizedBox(width: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            // 数值变化时 3D 翻转过渡（平顺观感，字号/颜色不变）
            _FlipValueText(
              text: value,
              style: TextStyle(
                color: Colors.white,
                fontSize: valueFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: 2),
              Text(
                unit,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: labelFontSize,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// 将秒数格式化为 MM:SS。
  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

/// 数值翻转文本：数值变化时以 3D 翻转（透视 rotateY）过渡。
///
/// - 新值从侧向翻入、旧值翻出并淡出，观感平顺
/// - 静态样式（字号/颜色/字重）完全沿用原 Text，仅变化时有过渡
/// - 300ms 时长兼容每秒刷新的时间字段（不会出现动画堆叠）
class _FlipValueText extends StatelessWidget {
  const _FlipValueText({required this.text, required this.style});

  /// 当前数值文本。
  final String text;

  /// 数值文字样式（与原 Text 保持一致）。
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      // 翻转过渡：进入时从 ~69° 翻到 0°，退出时反向翻出
      transitionBuilder: (child, animation) {
        final flip = Tween<double>(begin: 1.0, end: 0.0).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: AnimatedBuilder(
            animation: flip,
            child: child,
            builder: (context, c) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0015) // 透视，增强 3D 翻转感
                  ..rotateY(flip.value * 1.2),
                child: c,
              );
            },
          ),
        );
      },
      child: Text(text, key: ValueKey(text), style: style),
    );
  }
}
