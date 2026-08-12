// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_game_select_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 游戏选择页 Notifier（1:1 迁移旧 ControllerBigCourseSelect）。
///
/// 负责：音乐播放控制、专辑封面轮播、游戏列表/路由/图片按设备类型初始化。
/// 运动数据控制复用 QuickStartNotifier，不在此处理。

@ProviderFor(GymGameSelectNotifier)
final gymGameSelectProvider = GymGameSelectNotifierProvider._();

/// 游戏选择页 Notifier（1:1 迁移旧 ControllerBigCourseSelect）。
///
/// 负责：音乐播放控制、专辑封面轮播、游戏列表/路由/图片按设备类型初始化。
/// 运动数据控制复用 QuickStartNotifier，不在此处理。
final class GymGameSelectNotifierProvider
    extends $NotifierProvider<GymGameSelectNotifier, GymGameSelectState> {
  /// 游戏选择页 Notifier（1:1 迁移旧 ControllerBigCourseSelect）。
  ///
  /// 负责：音乐播放控制、专辑封面轮播、游戏列表/路由/图片按设备类型初始化。
  /// 运动数据控制复用 QuickStartNotifier，不在此处理。
  GymGameSelectNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gymGameSelectProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gymGameSelectNotifierHash();

  @$internal
  @override
  GymGameSelectNotifier create() => GymGameSelectNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GymGameSelectState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GymGameSelectState>(value),
    );
  }
}

String _$gymGameSelectNotifierHash() =>
    r'7613fc302c31fa741b33f8c0a68a1cb7e405276d';

/// 游戏选择页 Notifier（1:1 迁移旧 ControllerBigCourseSelect）。
///
/// 负责：音乐播放控制、专辑封面轮播、游戏列表/路由/图片按设备类型初始化。
/// 运动数据控制复用 QuickStartNotifier，不在此处理。

abstract class _$GymGameSelectNotifier extends $Notifier<GymGameSelectState> {
  GymGameSelectState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<GymGameSelectState, GymGameSelectState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GymGameSelectState, GymGameSelectState>,
              GymGameSelectState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
