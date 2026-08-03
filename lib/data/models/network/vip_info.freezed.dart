// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vip_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VipInfo {

 int? get userId; String? get upgradeTime; String? get expireTime; bool? get withinTheTerm;
/// Create a copy of VipInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VipInfoCopyWith<VipInfo> get copyWith => _$VipInfoCopyWithImpl<VipInfo>(this as VipInfo, _$identity);

  /// Serializes this VipInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VipInfo&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.upgradeTime, upgradeTime) || other.upgradeTime == upgradeTime)&&(identical(other.expireTime, expireTime) || other.expireTime == expireTime)&&(identical(other.withinTheTerm, withinTheTerm) || other.withinTheTerm == withinTheTerm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,upgradeTime,expireTime,withinTheTerm);

@override
String toString() {
  return 'VipInfo(userId: $userId, upgradeTime: $upgradeTime, expireTime: $expireTime, withinTheTerm: $withinTheTerm)';
}


}

/// @nodoc
abstract mixin class $VipInfoCopyWith<$Res>  {
  factory $VipInfoCopyWith(VipInfo value, $Res Function(VipInfo) _then) = _$VipInfoCopyWithImpl;
@useResult
$Res call({
 int? userId, String? upgradeTime, String? expireTime, bool? withinTheTerm
});




}
/// @nodoc
class _$VipInfoCopyWithImpl<$Res>
    implements $VipInfoCopyWith<$Res> {
  _$VipInfoCopyWithImpl(this._self, this._then);

  final VipInfo _self;
  final $Res Function(VipInfo) _then;

/// Create a copy of VipInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = freezed,Object? upgradeTime = freezed,Object? expireTime = freezed,Object? withinTheTerm = freezed,}) {
  return _then(VipInfo(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,upgradeTime: freezed == upgradeTime ? _self.upgradeTime : upgradeTime // ignore: cast_nullable_to_non_nullable
as String?,expireTime: freezed == expireTime ? _self.expireTime : expireTime // ignore: cast_nullable_to_non_nullable
as String?,withinTheTerm: freezed == withinTheTerm ? _self.withinTheTerm : withinTheTerm // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [VipInfo].
extension VipInfoPatterns on VipInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VipInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VipInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VipInfo value)  $default,){
final _that = this;
switch (_that) {
case _VipInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VipInfo value)?  $default,){
final _that = this;
switch (_that) {
case _VipInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? userId,  String? upgradeTime,  String? expireTime,  bool? withinTheTerm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VipInfo() when $default != null:
return $default(_that.userId,_that.upgradeTime,_that.expireTime,_that.withinTheTerm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? userId,  String? upgradeTime,  String? expireTime,  bool? withinTheTerm)  $default,) {final _that = this;
switch (_that) {
case _VipInfo():
return $default(_that.userId,_that.upgradeTime,_that.expireTime,_that.withinTheTerm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? userId,  String? upgradeTime,  String? expireTime,  bool? withinTheTerm)?  $default,) {final _that = this;
switch (_that) {
case _VipInfo() when $default != null:
return $default(_that.userId,_that.upgradeTime,_that.expireTime,_that.withinTheTerm);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VipInfo implements VipInfo {
  const _VipInfo({this.userId, this.upgradeTime, this.expireTime, this.withinTheTerm});
  factory _VipInfo.fromJson(Map<String, dynamic> json) => _$VipInfoFromJson(json);

@override final  int? userId;
@override final  String? upgradeTime;
@override final  String? expireTime;
@override final  bool? withinTheTerm;

/// Create a copy of VipInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VipInfoCopyWith<_VipInfo> get copyWith => __$VipInfoCopyWithImpl<_VipInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VipInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VipInfo&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.upgradeTime, upgradeTime) || other.upgradeTime == upgradeTime)&&(identical(other.expireTime, expireTime) || other.expireTime == expireTime)&&(identical(other.withinTheTerm, withinTheTerm) || other.withinTheTerm == withinTheTerm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,upgradeTime,expireTime,withinTheTerm);

@override
String toString() {
  return 'VipInfo(userId: $userId, upgradeTime: $upgradeTime, expireTime: $expireTime, withinTheTerm: $withinTheTerm)';
}


}

/// @nodoc
abstract mixin class _$VipInfoCopyWith<$Res> implements $VipInfoCopyWith<$Res> {
  factory _$VipInfoCopyWith(_VipInfo value, $Res Function(_VipInfo) _then) = __$VipInfoCopyWithImpl;
@override @useResult
$Res call({
 int? userId, String? upgradeTime, String? expireTime, bool? withinTheTerm
});




}
/// @nodoc
class __$VipInfoCopyWithImpl<$Res>
    implements _$VipInfoCopyWith<$Res> {
  __$VipInfoCopyWithImpl(this._self, this._then);

  final _VipInfo _self;
  final $Res Function(_VipInfo) _then;

/// Create a copy of VipInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = freezed,Object? upgradeTime = freezed,Object? expireTime = freezed,Object? withinTheTerm = freezed,}) {
  return _then(_VipInfo(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,upgradeTime: freezed == upgradeTime ? _self.upgradeTime : upgradeTime // ignore: cast_nullable_to_non_nullable
as String?,expireTime: freezed == expireTime ? _self.expireTime : expireTime // ignore: cast_nullable_to_non_nullable
as String?,withinTheTerm: freezed == withinTheTerm ? _self.withinTheTerm : withinTheTerm // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
