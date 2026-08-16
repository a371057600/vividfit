// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distance_unit_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 大设备距离单位偏好 Notifier（Riverpod 3.0 代码生成）。
///
/// 职责：
/// - 从 SharedPreferences 读取用户上次的单位偏好（默认公制 km）
/// - 提供 [toggle] / [setUnit] 修改并持久化
/// - 供 [SportDataDisplay] 等展示组件 watch，实现距离单位动态切换
///
/// 保持 keepAlive：单位偏好在 app 生命周期内常驻，跨页面共享。

@ProviderFor(DistanceUnitNotifier)
final distanceUnitProvider = DistanceUnitNotifierProvider._();

/// 大设备距离单位偏好 Notifier（Riverpod 3.0 代码生成）。
///
/// 职责：
/// - 从 SharedPreferences 读取用户上次的单位偏好（默认公制 km）
/// - 提供 [toggle] / [setUnit] 修改并持久化
/// - 供 [SportDataDisplay] 等展示组件 watch，实现距离单位动态切换
///
/// 保持 keepAlive：单位偏好在 app 生命周期内常驻，跨页面共享。
final class DistanceUnitNotifierProvider
    extends $NotifierProvider<DistanceUnitNotifier, DistanceUnit> {
  /// 大设备距离单位偏好 Notifier（Riverpod 3.0 代码生成）。
  ///
  /// 职责：
  /// - 从 SharedPreferences 读取用户上次的单位偏好（默认公制 km）
  /// - 提供 [toggle] / [setUnit] 修改并持久化
  /// - 供 [SportDataDisplay] 等展示组件 watch，实现距离单位动态切换
  ///
  /// 保持 keepAlive：单位偏好在 app 生命周期内常驻，跨页面共享。
  DistanceUnitNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'distanceUnitProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$distanceUnitNotifierHash();

  @$internal
  @override
  DistanceUnitNotifier create() => DistanceUnitNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DistanceUnit value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DistanceUnit>(value),
    );
  }
}

String _$distanceUnitNotifierHash() =>
    r'f730dfdaa71ea154c510082b516c3a57038cd351';

/// 大设备距离单位偏好 Notifier（Riverpod 3.0 代码生成）。
///
/// 职责：
/// - 从 SharedPreferences 读取用户上次的单位偏好（默认公制 km）
/// - 提供 [toggle] / [setUnit] 修改并持久化
/// - 供 [SportDataDisplay] 等展示组件 watch，实现距离单位动态切换
///
/// 保持 keepAlive：单位偏好在 app 生命周期内常驻，跨页面共享。

abstract class _$DistanceUnitNotifier extends $Notifier<DistanceUnit> {
  DistanceUnit build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DistanceUnit, DistanceUnit>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DistanceUnit, DistanceUnit>,
              DistanceUnit,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
