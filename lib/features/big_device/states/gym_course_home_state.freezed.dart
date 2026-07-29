// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gym_course_home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GymCourseHomeState {

/// 当前选中的设备类型(对应旧 `newMainSelectType`)。
 FtmsDeviceType get selectedDeviceCategory;/// 5 张入口卡片数据(对应旧 `cardData`)。
/// null 表示未初始化,build() 时填充默认卡片。
 List<EntryCardData>? get entryCards;/// 是否处于快速播放模式(对应旧 `isInQuickPlay`)。
 bool get isInQuickPlay;/// 数据允许标志(对应旧 `dataAllowFlag`)。
 bool get dataAllowFlag;
/// Create a copy of GymCourseHomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GymCourseHomeStateCopyWith<GymCourseHomeState> get copyWith => _$GymCourseHomeStateCopyWithImpl<GymCourseHomeState>(this as GymCourseHomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GymCourseHomeState&&(identical(other.selectedDeviceCategory, selectedDeviceCategory) || other.selectedDeviceCategory == selectedDeviceCategory)&&const DeepCollectionEquality().equals(other.entryCards, entryCards)&&(identical(other.isInQuickPlay, isInQuickPlay) || other.isInQuickPlay == isInQuickPlay)&&(identical(other.dataAllowFlag, dataAllowFlag) || other.dataAllowFlag == dataAllowFlag));
}


@override
int get hashCode => Object.hash(runtimeType,selectedDeviceCategory,const DeepCollectionEquality().hash(entryCards),isInQuickPlay,dataAllowFlag);

@override
String toString() {
  return 'GymCourseHomeState(selectedDeviceCategory: $selectedDeviceCategory, entryCards: $entryCards, isInQuickPlay: $isInQuickPlay, dataAllowFlag: $dataAllowFlag)';
}


}

/// @nodoc
abstract mixin class $GymCourseHomeStateCopyWith<$Res>  {
  factory $GymCourseHomeStateCopyWith(GymCourseHomeState value, $Res Function(GymCourseHomeState) _then) = _$GymCourseHomeStateCopyWithImpl;
@useResult
$Res call({
 FtmsDeviceType selectedDeviceCategory, List<EntryCardData>? entryCards, bool isInQuickPlay, bool dataAllowFlag
});




}
/// @nodoc
class _$GymCourseHomeStateCopyWithImpl<$Res>
    implements $GymCourseHomeStateCopyWith<$Res> {
  _$GymCourseHomeStateCopyWithImpl(this._self, this._then);

  final GymCourseHomeState _self;
  final $Res Function(GymCourseHomeState) _then;

/// Create a copy of GymCourseHomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedDeviceCategory = null,Object? entryCards = freezed,Object? isInQuickPlay = null,Object? dataAllowFlag = null,}) {
  return _then(GymCourseHomeState(
selectedDeviceCategory: null == selectedDeviceCategory ? _self.selectedDeviceCategory : selectedDeviceCategory // ignore: cast_nullable_to_non_nullable
as FtmsDeviceType,entryCards: freezed == entryCards ? _self.entryCards : entryCards // ignore: cast_nullable_to_non_nullable
as List<EntryCardData>?,isInQuickPlay: null == isInQuickPlay ? _self.isInQuickPlay : isInQuickPlay // ignore: cast_nullable_to_non_nullable
as bool,dataAllowFlag: null == dataAllowFlag ? _self.dataAllowFlag : dataAllowFlag // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GymCourseHomeState].
extension GymCourseHomeStatePatterns on GymCourseHomeState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GymCourseHomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GymCourseHomeState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GymCourseHomeState value)  $default,){
final _that = this;
switch (_that) {
case _GymCourseHomeState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GymCourseHomeState value)?  $default,){
final _that = this;
switch (_that) {
case _GymCourseHomeState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FtmsDeviceType selectedDeviceCategory,  List<EntryCardData>? entryCards,  bool isInQuickPlay,  bool dataAllowFlag)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GymCourseHomeState() when $default != null:
return $default(_that.selectedDeviceCategory,_that.entryCards,_that.isInQuickPlay,_that.dataAllowFlag);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FtmsDeviceType selectedDeviceCategory,  List<EntryCardData>? entryCards,  bool isInQuickPlay,  bool dataAllowFlag)  $default,) {final _that = this;
switch (_that) {
case _GymCourseHomeState():
return $default(_that.selectedDeviceCategory,_that.entryCards,_that.isInQuickPlay,_that.dataAllowFlag);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FtmsDeviceType selectedDeviceCategory,  List<EntryCardData>? entryCards,  bool isInQuickPlay,  bool dataAllowFlag)?  $default,) {final _that = this;
switch (_that) {
case _GymCourseHomeState() when $default != null:
return $default(_that.selectedDeviceCategory,_that.entryCards,_that.isInQuickPlay,_that.dataAllowFlag);case _:
  return null;

}
}

}

/// @nodoc


class _GymCourseHomeState implements GymCourseHomeState {
  const _GymCourseHomeState({this.selectedDeviceCategory = FtmsDeviceType.indoorBike,  List<EntryCardData>? entryCards, this.isInQuickPlay = false, this.dataAllowFlag = false}): _entryCards = entryCards;
  

/// 当前选中的设备类型(对应旧 `newMainSelectType`)。
@override@JsonKey() final  FtmsDeviceType selectedDeviceCategory;
/// 5 张入口卡片数据(对应旧 `cardData`)。
/// null 表示未初始化,build() 时填充默认卡片。
 final  List<EntryCardData>? _entryCards;
/// 5 张入口卡片数据(对应旧 `cardData`)。
/// null 表示未初始化,build() 时填充默认卡片。
@override List<EntryCardData>? get entryCards {
  final value = _entryCards;
  if (value == null) return null;
  if (_entryCards is EqualUnmodifiableListView) return _entryCards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// 是否处于快速播放模式(对应旧 `isInQuickPlay`)。
@override@JsonKey() final  bool isInQuickPlay;
/// 数据允许标志(对应旧 `dataAllowFlag`)。
@override@JsonKey() final  bool dataAllowFlag;

/// Create a copy of GymCourseHomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GymCourseHomeStateCopyWith<_GymCourseHomeState> get copyWith => __$GymCourseHomeStateCopyWithImpl<_GymCourseHomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GymCourseHomeState&&(identical(other.selectedDeviceCategory, selectedDeviceCategory) || other.selectedDeviceCategory == selectedDeviceCategory)&&const DeepCollectionEquality().equals(other._entryCards, _entryCards)&&(identical(other.isInQuickPlay, isInQuickPlay) || other.isInQuickPlay == isInQuickPlay)&&(identical(other.dataAllowFlag, dataAllowFlag) || other.dataAllowFlag == dataAllowFlag));
}


@override
int get hashCode => Object.hash(runtimeType,selectedDeviceCategory,const DeepCollectionEquality().hash(_entryCards),isInQuickPlay,dataAllowFlag);

@override
String toString() {
  return 'GymCourseHomeState(selectedDeviceCategory: $selectedDeviceCategory, entryCards: $entryCards, isInQuickPlay: $isInQuickPlay, dataAllowFlag: $dataAllowFlag)';
}


}

/// @nodoc
abstract mixin class _$GymCourseHomeStateCopyWith<$Res> implements $GymCourseHomeStateCopyWith<$Res> {
  factory _$GymCourseHomeStateCopyWith(_GymCourseHomeState value, $Res Function(_GymCourseHomeState) _then) = __$GymCourseHomeStateCopyWithImpl;
@override @useResult
$Res call({
 FtmsDeviceType selectedDeviceCategory, List<EntryCardData>? entryCards, bool isInQuickPlay, bool dataAllowFlag
});




}
/// @nodoc
class __$GymCourseHomeStateCopyWithImpl<$Res>
    implements _$GymCourseHomeStateCopyWith<$Res> {
  __$GymCourseHomeStateCopyWithImpl(this._self, this._then);

  final _GymCourseHomeState _self;
  final $Res Function(_GymCourseHomeState) _then;

/// Create a copy of GymCourseHomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedDeviceCategory = null,Object? entryCards = freezed,Object? isInQuickPlay = null,Object? dataAllowFlag = null,}) {
  return _then(_GymCourseHomeState(
selectedDeviceCategory: null == selectedDeviceCategory ? _self.selectedDeviceCategory : selectedDeviceCategory // ignore: cast_nullable_to_non_nullable
as FtmsDeviceType,entryCards: freezed == entryCards ? _self._entryCards : entryCards // ignore: cast_nullable_to_non_nullable
as List<EntryCardData>?,isInQuickPlay: null == isInQuickPlay ? _self.isInQuickPlay : isInQuickPlay // ignore: cast_nullable_to_non_nullable
as bool,dataAllowFlag: null == dataAllowFlag ? _self.dataAllowFlag : dataAllowFlag // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
