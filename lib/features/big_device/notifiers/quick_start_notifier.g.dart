// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_start_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 快速开始 Notifier（Riverpod 3.0 代码生成）。
///
/// 接入 FTMS 蓝牙数据监听与运动控制，负责：
/// - 实时数据流（0x2AD1）解析与状态同步
/// - 设备状态流（0x2ADA）回调处理
/// - 运动控制指令（0x2AD9）下发
/// - 目标达成弹窗三态管理

@ProviderFor(QuickStartNotifier)
final quickStartProvider = QuickStartNotifierProvider._();

/// 快速开始 Notifier（Riverpod 3.0 代码生成）。
///
/// 接入 FTMS 蓝牙数据监听与运动控制，负责：
/// - 实时数据流（0x2AD1）解析与状态同步
/// - 设备状态流（0x2ADA）回调处理
/// - 运动控制指令（0x2AD9）下发
/// - 目标达成弹窗三态管理
final class QuickStartNotifierProvider
    extends $NotifierProvider<QuickStartNotifier, QuickStartState> {
  /// 快速开始 Notifier（Riverpod 3.0 代码生成）。
  ///
  /// 接入 FTMS 蓝牙数据监听与运动控制，负责：
  /// - 实时数据流（0x2AD1）解析与状态同步
  /// - 设备状态流（0x2ADA）回调处理
  /// - 运动控制指令（0x2AD9）下发
  /// - 目标达成弹窗三态管理
  QuickStartNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quickStartProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quickStartNotifierHash();

  @$internal
  @override
  QuickStartNotifier create() => QuickStartNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuickStartState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuickStartState>(value),
    );
  }
}

String _$quickStartNotifierHash() =>
    r'2151e973fa34863fe50cb4db07e84420ea3e58fb';

/// 快速开始 Notifier（Riverpod 3.0 代码生成）。
///
/// 接入 FTMS 蓝牙数据监听与运动控制，负责：
/// - 实时数据流（0x2AD1）解析与状态同步
/// - 设备状态流（0x2ADA）回调处理
/// - 运动控制指令（0x2AD9）下发
/// - 目标达成弹窗三态管理

abstract class _$QuickStartNotifier extends $Notifier<QuickStartState> {
  QuickStartState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<QuickStartState, QuickStartState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<QuickStartState, QuickStartState>,
              QuickStartState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
