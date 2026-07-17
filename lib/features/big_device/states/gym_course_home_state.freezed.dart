// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gym_course_home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GymCourseHomeState {
  /// 当前选中的设备类型(对应旧 `newMainSelectType`)。
  DeviceCategory get selectedDeviceCategory =>
      throw _privateConstructorUsedError;

  /// 5 张入口卡片数据(对应旧 `cardData`)。
  List<EntryCardData> get entryCards => throw _privateConstructorUsedError;

  /// Create a copy of GymCourseHomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GymCourseHomeStateCopyWith<GymCourseHomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GymCourseHomeStateCopyWith<$Res> {
  factory $GymCourseHomeStateCopyWith(
    GymCourseHomeState value,
    $Res Function(GymCourseHomeState) then,
  ) = _$GymCourseHomeStateCopyWithImpl<$Res, GymCourseHomeState>;
  @useResult
  $Res call({
    DeviceCategory selectedDeviceCategory,
    List<EntryCardData> entryCards,
  });
}

/// @nodoc
class _$GymCourseHomeStateCopyWithImpl<$Res, $Val extends GymCourseHomeState>
    implements $GymCourseHomeStateCopyWith<$Res> {
  _$GymCourseHomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GymCourseHomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedDeviceCategory = null,
    Object? entryCards = null,
  }) {
    return _then(
      _value.copyWith(
            selectedDeviceCategory:
                null == selectedDeviceCategory
                    ? _value.selectedDeviceCategory
                    : selectedDeviceCategory // ignore: cast_nullable_to_non_nullable
                        as DeviceCategory,
            entryCards:
                null == entryCards
                    ? _value.entryCards
                    : entryCards // ignore: cast_nullable_to_non_nullable
                        as List<EntryCardData>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GymCourseHomeStateImplCopyWith<$Res>
    implements $GymCourseHomeStateCopyWith<$Res> {
  factory _$$GymCourseHomeStateImplCopyWith(
    _$GymCourseHomeStateImpl value,
    $Res Function(_$GymCourseHomeStateImpl) then,
  ) = __$$GymCourseHomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DeviceCategory selectedDeviceCategory,
    List<EntryCardData> entryCards,
  });
}

/// @nodoc
class __$$GymCourseHomeStateImplCopyWithImpl<$Res>
    extends _$GymCourseHomeStateCopyWithImpl<$Res, _$GymCourseHomeStateImpl>
    implements _$$GymCourseHomeStateImplCopyWith<$Res> {
  __$$GymCourseHomeStateImplCopyWithImpl(
    _$GymCourseHomeStateImpl _value,
    $Res Function(_$GymCourseHomeStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GymCourseHomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedDeviceCategory = null,
    Object? entryCards = null,
  }) {
    return _then(
      _$GymCourseHomeStateImpl(
        selectedDeviceCategory:
            null == selectedDeviceCategory
                ? _value.selectedDeviceCategory
                : selectedDeviceCategory // ignore: cast_nullable_to_non_nullable
                    as DeviceCategory,
        entryCards:
            null == entryCards
                ? _value._entryCards
                : entryCards // ignore: cast_nullable_to_non_nullable
                    as List<EntryCardData>,
      ),
    );
  }
}

/// @nodoc

class _$GymCourseHomeStateImpl implements _GymCourseHomeState {
  const _$GymCourseHomeStateImpl({
    this.selectedDeviceCategory = DeviceCategory.bike,
    final List<EntryCardData> entryCards = const <EntryCardData>[],
  }) : _entryCards = entryCards;

  /// 当前选中的设备类型(对应旧 `newMainSelectType`)。
  @override
  @JsonKey()
  final DeviceCategory selectedDeviceCategory;

  /// 5 张入口卡片数据(对应旧 `cardData`)。
  final List<EntryCardData> _entryCards;

  /// 5 张入口卡片数据(对应旧 `cardData`)。
  @override
  @JsonKey()
  List<EntryCardData> get entryCards {
    if (_entryCards is EqualUnmodifiableListView) return _entryCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entryCards);
  }

  @override
  String toString() {
    return 'GymCourseHomeState(selectedDeviceCategory: $selectedDeviceCategory, entryCards: $entryCards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GymCourseHomeStateImpl &&
            (identical(other.selectedDeviceCategory, selectedDeviceCategory) ||
                other.selectedDeviceCategory == selectedDeviceCategory) &&
            const DeepCollectionEquality().equals(
              other._entryCards,
              _entryCards,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    selectedDeviceCategory,
    const DeepCollectionEquality().hash(_entryCards),
  );

  /// Create a copy of GymCourseHomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GymCourseHomeStateImplCopyWith<_$GymCourseHomeStateImpl> get copyWith =>
      __$$GymCourseHomeStateImplCopyWithImpl<_$GymCourseHomeStateImpl>(
        this,
        _$identity,
      );
}

abstract class _GymCourseHomeState implements GymCourseHomeState {
  const factory _GymCourseHomeState({
    final DeviceCategory selectedDeviceCategory,
    final List<EntryCardData> entryCards,
  }) = _$GymCourseHomeStateImpl;

  /// 当前选中的设备类型(对应旧 `newMainSelectType`)。
  @override
  DeviceCategory get selectedDeviceCategory;

  /// 5 张入口卡片数据(对应旧 `cardData`)。
  @override
  List<EntryCardData> get entryCards;

  /// Create a copy of GymCourseHomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GymCourseHomeStateImplCopyWith<_$GymCourseHomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
