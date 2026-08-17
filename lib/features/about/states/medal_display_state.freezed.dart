// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medal_display_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MedalDisplayState {

/// 是否正在加载勋章面板
 bool get isLoading;/// 服务器返回的勋章分组（对应旧 newMedalJson.data）
 List<MedalGroup> get groups;/// 已获得的勋章（createTime 非空），按获得时间降序（对应旧 filteredAndSortedList）
 List<MedalMsg> get earnedMedals;/// 顶部轮播当前索引（对应旧 topCarouselSliderIndex）
 int get topCarouselIndex;
/// Create a copy of MedalDisplayState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedalDisplayStateCopyWith<MedalDisplayState> get copyWith => _$MedalDisplayStateCopyWithImpl<MedalDisplayState>(this as MedalDisplayState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedalDisplayState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.groups, groups)&&const DeepCollectionEquality().equals(other.earnedMedals, earnedMedals)&&(identical(other.topCarouselIndex, topCarouselIndex) || other.topCarouselIndex == topCarouselIndex));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(groups),const DeepCollectionEquality().hash(earnedMedals),topCarouselIndex);

@override
String toString() {
  return 'MedalDisplayState(isLoading: $isLoading, groups: $groups, earnedMedals: $earnedMedals, topCarouselIndex: $topCarouselIndex)';
}


}

/// @nodoc
abstract mixin class $MedalDisplayStateCopyWith<$Res>  {
  factory $MedalDisplayStateCopyWith(MedalDisplayState value, $Res Function(MedalDisplayState) _then) = _$MedalDisplayStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<MedalGroup> groups, List<MedalMsg> earnedMedals, int topCarouselIndex
});




}
/// @nodoc
class _$MedalDisplayStateCopyWithImpl<$Res>
    implements $MedalDisplayStateCopyWith<$Res> {
  _$MedalDisplayStateCopyWithImpl(this._self, this._then);

  final MedalDisplayState _self;
  final $Res Function(MedalDisplayState) _then;

/// Create a copy of MedalDisplayState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? groups = null,Object? earnedMedals = null,Object? topCarouselIndex = null,}) {
  return _then(MedalDisplayState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<MedalGroup>,earnedMedals: null == earnedMedals ? _self.earnedMedals : earnedMedals // ignore: cast_nullable_to_non_nullable
as List<MedalMsg>,topCarouselIndex: null == topCarouselIndex ? _self.topCarouselIndex : topCarouselIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MedalDisplayState].
extension MedalDisplayStatePatterns on MedalDisplayState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedalDisplayState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedalDisplayState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedalDisplayState value)  $default,){
final _that = this;
switch (_that) {
case _MedalDisplayState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedalDisplayState value)?  $default,){
final _that = this;
switch (_that) {
case _MedalDisplayState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<MedalGroup> groups,  List<MedalMsg> earnedMedals,  int topCarouselIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedalDisplayState() when $default != null:
return $default(_that.isLoading,_that.groups,_that.earnedMedals,_that.topCarouselIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<MedalGroup> groups,  List<MedalMsg> earnedMedals,  int topCarouselIndex)  $default,) {final _that = this;
switch (_that) {
case _MedalDisplayState():
return $default(_that.isLoading,_that.groups,_that.earnedMedals,_that.topCarouselIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<MedalGroup> groups,  List<MedalMsg> earnedMedals,  int topCarouselIndex)?  $default,) {final _that = this;
switch (_that) {
case _MedalDisplayState() when $default != null:
return $default(_that.isLoading,_that.groups,_that.earnedMedals,_that.topCarouselIndex);case _:
  return null;

}
}

}

/// @nodoc


class _MedalDisplayState implements MedalDisplayState {
  const _MedalDisplayState({this.isLoading = true,  List<MedalGroup> groups = const [],  List<MedalMsg> earnedMedals = const [], this.topCarouselIndex = 0}): _groups = groups,_earnedMedals = earnedMedals;
  

/// 是否正在加载勋章面板
@override@JsonKey() final  bool isLoading;
/// 服务器返回的勋章分组（对应旧 newMedalJson.data）
 final  List<MedalGroup> _groups;
/// 服务器返回的勋章分组（对应旧 newMedalJson.data）
@override@JsonKey() List<MedalGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

/// 已获得的勋章（createTime 非空），按获得时间降序（对应旧 filteredAndSortedList）
 final  List<MedalMsg> _earnedMedals;
/// 已获得的勋章（createTime 非空），按获得时间降序（对应旧 filteredAndSortedList）
@override@JsonKey() List<MedalMsg> get earnedMedals {
  if (_earnedMedals is EqualUnmodifiableListView) return _earnedMedals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_earnedMedals);
}

/// 顶部轮播当前索引（对应旧 topCarouselSliderIndex）
@override@JsonKey() final  int topCarouselIndex;

/// Create a copy of MedalDisplayState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedalDisplayStateCopyWith<_MedalDisplayState> get copyWith => __$MedalDisplayStateCopyWithImpl<_MedalDisplayState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedalDisplayState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._groups, _groups)&&const DeepCollectionEquality().equals(other._earnedMedals, _earnedMedals)&&(identical(other.topCarouselIndex, topCarouselIndex) || other.topCarouselIndex == topCarouselIndex));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_groups),const DeepCollectionEquality().hash(_earnedMedals),topCarouselIndex);

@override
String toString() {
  return 'MedalDisplayState(isLoading: $isLoading, groups: $groups, earnedMedals: $earnedMedals, topCarouselIndex: $topCarouselIndex)';
}


}

/// @nodoc
abstract mixin class _$MedalDisplayStateCopyWith<$Res> implements $MedalDisplayStateCopyWith<$Res> {
  factory _$MedalDisplayStateCopyWith(_MedalDisplayState value, $Res Function(_MedalDisplayState) _then) = __$MedalDisplayStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<MedalGroup> groups, List<MedalMsg> earnedMedals, int topCarouselIndex
});




}
/// @nodoc
class __$MedalDisplayStateCopyWithImpl<$Res>
    implements _$MedalDisplayStateCopyWith<$Res> {
  __$MedalDisplayStateCopyWithImpl(this._self, this._then);

  final _MedalDisplayState _self;
  final $Res Function(_MedalDisplayState) _then;

/// Create a copy of MedalDisplayState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? groups = null,Object? earnedMedals = null,Object? topCarouselIndex = null,}) {
  return _then(_MedalDisplayState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<MedalGroup>,earnedMedals: null == earnedMedals ? _self._earnedMedals : earnedMedals // ignore: cast_nullable_to_non_nullable
as List<MedalMsg>,topCarouselIndex: null == topCarouselIndex ? _self.topCarouselIndex : topCarouselIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
