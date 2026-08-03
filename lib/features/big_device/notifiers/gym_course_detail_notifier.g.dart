// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_course_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 课程详情页 Notifier(Riverpod 3.0 代码生成,auto-dispose)。
///
/// 1:1 迁移自旧 `ControllerCourseDetail` 的数据加载逻辑。
/// auto-dispose:每次进详情页 state 全新,对齐旧 `Get.put(ControllerCourseDetail())`
/// 每次创建新实例的语义;push 到播放页时详情页 widget 仍挂载,provider 不销毁,
/// pop 详情页才销毁。
///
/// 语音方言匹配:旧项目 `hc.languageIndex` 全工程无赋值(恒 0),
/// `enLanguageList[0]` = "Chinese"。本 Notifier 内置常量复刻该逻辑。
///
/// 本阶段仅实现 `loadDetail`(数据加载);下载/解压方法留待后续下载任务测试后补充。

@ProviderFor(GymCourseDetailNotifier)
final gymCourseDetailProvider = GymCourseDetailNotifierProvider._();

/// 课程详情页 Notifier(Riverpod 3.0 代码生成,auto-dispose)。
///
/// 1:1 迁移自旧 `ControllerCourseDetail` 的数据加载逻辑。
/// auto-dispose:每次进详情页 state 全新,对齐旧 `Get.put(ControllerCourseDetail())`
/// 每次创建新实例的语义;push 到播放页时详情页 widget 仍挂载,provider 不销毁,
/// pop 详情页才销毁。
///
/// 语音方言匹配:旧项目 `hc.languageIndex` 全工程无赋值(恒 0),
/// `enLanguageList[0]` = "Chinese"。本 Notifier 内置常量复刻该逻辑。
///
/// 本阶段仅实现 `loadDetail`(数据加载);下载/解压方法留待后续下载任务测试后补充。
final class GymCourseDetailNotifierProvider
    extends $NotifierProvider<GymCourseDetailNotifier, GymCourseDetailState> {
  /// 课程详情页 Notifier(Riverpod 3.0 代码生成,auto-dispose)。
  ///
  /// 1:1 迁移自旧 `ControllerCourseDetail` 的数据加载逻辑。
  /// auto-dispose:每次进详情页 state 全新,对齐旧 `Get.put(ControllerCourseDetail())`
  /// 每次创建新实例的语义;push 到播放页时详情页 widget 仍挂载,provider 不销毁,
  /// pop 详情页才销毁。
  ///
  /// 语音方言匹配:旧项目 `hc.languageIndex` 全工程无赋值(恒 0),
  /// `enLanguageList[0]` = "Chinese"。本 Notifier 内置常量复刻该逻辑。
  ///
  /// 本阶段仅实现 `loadDetail`(数据加载);下载/解压方法留待后续下载任务测试后补充。
  GymCourseDetailNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gymCourseDetailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gymCourseDetailNotifierHash();

  @$internal
  @override
  GymCourseDetailNotifier create() => GymCourseDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GymCourseDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GymCourseDetailState>(value),
    );
  }
}

String _$gymCourseDetailNotifierHash() =>
    r'96696143b8f4b6896f04174c7c52a4f564b1f987';

/// 课程详情页 Notifier(Riverpod 3.0 代码生成,auto-dispose)。
///
/// 1:1 迁移自旧 `ControllerCourseDetail` 的数据加载逻辑。
/// auto-dispose:每次进详情页 state 全新,对齐旧 `Get.put(ControllerCourseDetail())`
/// 每次创建新实例的语义;push 到播放页时详情页 widget 仍挂载,provider 不销毁,
/// pop 详情页才销毁。
///
/// 语音方言匹配:旧项目 `hc.languageIndex` 全工程无赋值(恒 0),
/// `enLanguageList[0]` = "Chinese"。本 Notifier 内置常量复刻该逻辑。
///
/// 本阶段仅实现 `loadDetail`(数据加载);下载/解压方法留待后续下载任务测试后补充。

abstract class _$GymCourseDetailNotifier
    extends $Notifier<GymCourseDetailState> {
  GymCourseDetailState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<GymCourseDetailState, GymCourseDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GymCourseDetailState, GymCourseDetailState>,
              GymCourseDetailState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
