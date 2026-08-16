// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_course_play_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 课程播放页 Notifier（对应旧 ControllerBigDeviceCoursePlay + ControllerNewFourBigDeviceSprot）
///
/// 职责：
/// 1. 维护页面三态（loading / playing / finished）
/// 2. 纯本地模拟播放流程（无蓝牙）：定时器驱动 playIndex/imagePlayIndex/运动数据
/// 3. 设备控制按钮的交互（速度/坡度/阻力 +/−）

@ProviderFor(GymCoursePlayNotifier)
final gymCoursePlayProvider = GymCoursePlayNotifierProvider._();

/// 课程播放页 Notifier（对应旧 ControllerBigDeviceCoursePlay + ControllerNewFourBigDeviceSprot）
///
/// 职责：
/// 1. 维护页面三态（loading / playing / finished）
/// 2. 纯本地模拟播放流程（无蓝牙）：定时器驱动 playIndex/imagePlayIndex/运动数据
/// 3. 设备控制按钮的交互（速度/坡度/阻力 +/−）
final class GymCoursePlayNotifierProvider
    extends $NotifierProvider<GymCoursePlayNotifier, GymCoursePlayState> {
  /// 课程播放页 Notifier（对应旧 ControllerBigDeviceCoursePlay + ControllerNewFourBigDeviceSprot）
  ///
  /// 职责：
  /// 1. 维护页面三态（loading / playing / finished）
  /// 2. 纯本地模拟播放流程（无蓝牙）：定时器驱动 playIndex/imagePlayIndex/运动数据
  /// 3. 设备控制按钮的交互（速度/坡度/阻力 +/−）
  GymCoursePlayNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gymCoursePlayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gymCoursePlayNotifierHash();

  @$internal
  @override
  GymCoursePlayNotifier create() => GymCoursePlayNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GymCoursePlayState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GymCoursePlayState>(value),
    );
  }
}

String _$gymCoursePlayNotifierHash() =>
    r'26ca43f3b2d9f8d420a413eff053d641ffeef090';

/// 课程播放页 Notifier（对应旧 ControllerBigDeviceCoursePlay + ControllerNewFourBigDeviceSprot）
///
/// 职责：
/// 1. 维护页面三态（loading / playing / finished）
/// 2. 纯本地模拟播放流程（无蓝牙）：定时器驱动 playIndex/imagePlayIndex/运动数据
/// 3. 设备控制按钮的交互（速度/坡度/阻力 +/−）

abstract class _$GymCoursePlayNotifier extends $Notifier<GymCoursePlayState> {
  GymCoursePlayState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<GymCoursePlayState, GymCoursePlayState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GymCoursePlayState, GymCoursePlayState>,
              GymCoursePlayState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
