import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_provider.dart';

part 'distance_unit_notifier.g.dart';

/// 大设备距离单位枚举。
///
/// - [km]  : 公制（公里），默认值，与旧版显示一致。
/// - [mile]: 英制（英里），km × 0.621371。
enum DistanceUnit {
  /// 公制：公里。
  km(0),

  /// 英制：英里。
  mile(1);

  const DistanceUnit(this.code);

  /// 持久化编码（与 SharedPreferences 存储值一致）。
  final int code;

  /// 从持久化编码还原枚举，非法值回退为 [km]。
  static DistanceUnit fromCode(int code) =>
      DistanceUnit.values.firstWhere((e) => e.code == code,
          orElse: () => DistanceUnit.km);

  /// 对应的单位文案（供 UI 直接展示）。
  String get label => this == DistanceUnit.km ? 'km' : 'mile';
}

/// 大设备距离单位偏好 Notifier（Riverpod 3.0 代码生成）。
///
/// 职责：
/// - 从 SharedPreferences 读取用户上次的单位偏好（默认公制 km）
/// - 提供 [toggle] / [setUnit] 修改并持久化
/// - 供 [SportDataDisplay] 等展示组件 watch，实现距离单位动态切换
///
/// 保持 keepAlive：单位偏好在 app 生命周期内常驻，跨页面共享。
@Riverpod(keepAlive: true)
class DistanceUnitNotifier extends _$DistanceUnitNotifier {
  late StorageService _storage;

  @override
  DistanceUnit build() {
    _storage = ref.watch(storageServiceProvider);
    // 读取持久化偏好，默认公制（与旧版一致）
    final saved = _storage.bigDeviceDistanceUnit;
    final unit = DistanceUnit.fromCode(saved);
    print('📏 [DistanceUnit] init: unit=$unit (savedCode=$saved)');
    return unit;
  }

  /// 切换单位（km ↔ mile）并持久化。
  Future<void> toggle() async {
    final next =
        state == DistanceUnit.km ? DistanceUnit.mile : DistanceUnit.km;
    await setUnit(next);
  }

  /// 设置指定单位并持久化。
  Future<void> setUnit(DistanceUnit unit) async {
    state = unit;
    await _storage.setBigDeviceDistanceUnit(unit.code);
    print('📏 [DistanceUnit] setUnit: $unit (code=${unit.code})');
  }

  /// 将原始米数按当前单位转换为展示数值。
  ///
  /// - km  : meters / 1000
  /// - mile: meters / 1000 × 0.621371
  double convertMeters(double meters) {
    final kmValue = meters / 1000.0;
    if (state == DistanceUnit.mile) return kmValue * 0.621371;
    return kmValue;
  }
}
