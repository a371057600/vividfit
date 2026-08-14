import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../models/sport_data_model.dart';
import '../notifiers/distance_unit_notifier.dart';
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
///   - 距离：所有设备原始值（米）→ km/mile（[DeviceFieldVisibility.convertDistance]，
///     单位由 [distanceUnitProvider] 用户偏好决定）
///   - 时间：秒数格式化为 MM:SS
class SportDataDisplay extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final visibility = DeviceFieldVisibility(deviceType);
    // 读取距离单位偏好（km / mile），驱动距离数值与单位文案
    final distanceUnit = ref.watch(distanceUnitProvider);
    final items = _buildItems(visibility, distanceUnit);

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
  List<Widget> _buildItems(
    DeviceFieldVisibility visibility,
    DistanceUnit distanceUnit,
  ) {
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
    // 距离（所有设备原始值=米，按用户偏好转 km/mile）
    if (visibility.shouldShowDistance && data.distance != null) {
      items.add(
        _buildItem(
          icon: Icons.place,
          value: visibility
              .convertDistance(data.distance!, unit: distanceUnit)
              .toStringAsFixed(2),
          unit: distanceUnit.label,
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
            Text(
              value,
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
