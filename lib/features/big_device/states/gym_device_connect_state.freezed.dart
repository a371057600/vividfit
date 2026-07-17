// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gym_device_connect_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GymDeviceConnectState {
  /// 是否正在搜索(对应旧 searchStatus)。
  bool get isSearching => throw _privateConstructorUsedError;

  /// 设备是否已连接(对应旧 isDeviceConnect)。
  bool get isEquipmentConnected => throw _privateConstructorUsedError;

  /// 已发现设备的广播名列表(对应旧 showDeviceName.map(advName))。
  List<String> get foundDeviceNames => throw _privateConstructorUsedError;

  /// 是否曾经连接过(对应旧 _hasConnected,用于断连 toast 抑制)。
  bool get hasConnectedOnce => throw _privateConstructorUsedError;

  /// Create a copy of GymDeviceConnectState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GymDeviceConnectStateCopyWith<GymDeviceConnectState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GymDeviceConnectStateCopyWith<$Res> {
  factory $GymDeviceConnectStateCopyWith(
    GymDeviceConnectState value,
    $Res Function(GymDeviceConnectState) then,
  ) = _$GymDeviceConnectStateCopyWithImpl<$Res, GymDeviceConnectState>;
  @useResult
  $Res call({
    bool isSearching,
    bool isEquipmentConnected,
    List<String> foundDeviceNames,
    bool hasConnectedOnce,
  });
}

/// @nodoc
class _$GymDeviceConnectStateCopyWithImpl<
  $Res,
  $Val extends GymDeviceConnectState
>
    implements $GymDeviceConnectStateCopyWith<$Res> {
  _$GymDeviceConnectStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GymDeviceConnectState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSearching = null,
    Object? isEquipmentConnected = null,
    Object? foundDeviceNames = null,
    Object? hasConnectedOnce = null,
  }) {
    return _then(
      _value.copyWith(
            isSearching:
                null == isSearching
                    ? _value.isSearching
                    : isSearching // ignore: cast_nullable_to_non_nullable
                        as bool,
            isEquipmentConnected:
                null == isEquipmentConnected
                    ? _value.isEquipmentConnected
                    : isEquipmentConnected // ignore: cast_nullable_to_non_nullable
                        as bool,
            foundDeviceNames:
                null == foundDeviceNames
                    ? _value.foundDeviceNames
                    : foundDeviceNames // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            hasConnectedOnce:
                null == hasConnectedOnce
                    ? _value.hasConnectedOnce
                    : hasConnectedOnce // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GymDeviceConnectStateImplCopyWith<$Res>
    implements $GymDeviceConnectStateCopyWith<$Res> {
  factory _$$GymDeviceConnectStateImplCopyWith(
    _$GymDeviceConnectStateImpl value,
    $Res Function(_$GymDeviceConnectStateImpl) then,
  ) = __$$GymDeviceConnectStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isSearching,
    bool isEquipmentConnected,
    List<String> foundDeviceNames,
    bool hasConnectedOnce,
  });
}

/// @nodoc
class __$$GymDeviceConnectStateImplCopyWithImpl<$Res>
    extends
        _$GymDeviceConnectStateCopyWithImpl<$Res, _$GymDeviceConnectStateImpl>
    implements _$$GymDeviceConnectStateImplCopyWith<$Res> {
  __$$GymDeviceConnectStateImplCopyWithImpl(
    _$GymDeviceConnectStateImpl _value,
    $Res Function(_$GymDeviceConnectStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GymDeviceConnectState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSearching = null,
    Object? isEquipmentConnected = null,
    Object? foundDeviceNames = null,
    Object? hasConnectedOnce = null,
  }) {
    return _then(
      _$GymDeviceConnectStateImpl(
        isSearching:
            null == isSearching
                ? _value.isSearching
                : isSearching // ignore: cast_nullable_to_non_nullable
                    as bool,
        isEquipmentConnected:
            null == isEquipmentConnected
                ? _value.isEquipmentConnected
                : isEquipmentConnected // ignore: cast_nullable_to_non_nullable
                    as bool,
        foundDeviceNames:
            null == foundDeviceNames
                ? _value._foundDeviceNames
                : foundDeviceNames // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        hasConnectedOnce:
            null == hasConnectedOnce
                ? _value.hasConnectedOnce
                : hasConnectedOnce // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$GymDeviceConnectStateImpl implements _GymDeviceConnectState {
  const _$GymDeviceConnectStateImpl({
    this.isSearching = false,
    this.isEquipmentConnected = false,
    final List<String> foundDeviceNames = const <String>[],
    this.hasConnectedOnce = false,
  }) : _foundDeviceNames = foundDeviceNames;

  /// 是否正在搜索(对应旧 searchStatus)。
  @override
  @JsonKey()
  final bool isSearching;

  /// 设备是否已连接(对应旧 isDeviceConnect)。
  @override
  @JsonKey()
  final bool isEquipmentConnected;

  /// 已发现设备的广播名列表(对应旧 showDeviceName.map(advName))。
  final List<String> _foundDeviceNames;

  /// 已发现设备的广播名列表(对应旧 showDeviceName.map(advName))。
  @override
  @JsonKey()
  List<String> get foundDeviceNames {
    if (_foundDeviceNames is EqualUnmodifiableListView)
      return _foundDeviceNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foundDeviceNames);
  }

  /// 是否曾经连接过(对应旧 _hasConnected,用于断连 toast 抑制)。
  @override
  @JsonKey()
  final bool hasConnectedOnce;

  @override
  String toString() {
    return 'GymDeviceConnectState(isSearching: $isSearching, isEquipmentConnected: $isEquipmentConnected, foundDeviceNames: $foundDeviceNames, hasConnectedOnce: $hasConnectedOnce)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GymDeviceConnectStateImpl &&
            (identical(other.isSearching, isSearching) ||
                other.isSearching == isSearching) &&
            (identical(other.isEquipmentConnected, isEquipmentConnected) ||
                other.isEquipmentConnected == isEquipmentConnected) &&
            const DeepCollectionEquality().equals(
              other._foundDeviceNames,
              _foundDeviceNames,
            ) &&
            (identical(other.hasConnectedOnce, hasConnectedOnce) ||
                other.hasConnectedOnce == hasConnectedOnce));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isSearching,
    isEquipmentConnected,
    const DeepCollectionEquality().hash(_foundDeviceNames),
    hasConnectedOnce,
  );

  /// Create a copy of GymDeviceConnectState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GymDeviceConnectStateImplCopyWith<_$GymDeviceConnectStateImpl>
  get copyWith =>
      __$$GymDeviceConnectStateImplCopyWithImpl<_$GymDeviceConnectStateImpl>(
        this,
        _$identity,
      );
}

abstract class _GymDeviceConnectState implements GymDeviceConnectState {
  const factory _GymDeviceConnectState({
    final bool isSearching,
    final bool isEquipmentConnected,
    final List<String> foundDeviceNames,
    final bool hasConnectedOnce,
  }) = _$GymDeviceConnectStateImpl;

  /// 是否正在搜索(对应旧 searchStatus)。
  @override
  bool get isSearching;

  /// 设备是否已连接(对应旧 isDeviceConnect)。
  @override
  bool get isEquipmentConnected;

  /// 已发现设备的广播名列表(对应旧 showDeviceName.map(advName))。
  @override
  List<String> get foundDeviceNames;

  /// 是否曾经连接过(对应旧 _hasConnected,用于断连 toast 抑制)。
  @override
  bool get hasConnectedOnce;

  /// Create a copy of GymDeviceConnectState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GymDeviceConnectStateImplCopyWith<_$GymDeviceConnectStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
