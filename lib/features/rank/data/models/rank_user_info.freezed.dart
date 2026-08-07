// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rank_user_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RankUserInfo {

@JsonKey(name: 'code') String? get code;@JsonKey(name: 'msg') String? get msg;@JsonKey(name: 'data') RankUserData? get data;
/// Create a copy of RankUserInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankUserInfoCopyWith<RankUserInfo> get copyWith => _$RankUserInfoCopyWithImpl<RankUserInfo>(this as RankUserInfo, _$identity);

  /// Serializes this RankUserInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankUserInfo&&(identical(other.code, code) || other.code == code)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,msg,data);

@override
String toString() {
  return 'RankUserInfo(code: $code, msg: $msg, data: $data)';
}


}

/// @nodoc
abstract mixin class $RankUserInfoCopyWith<$Res>  {
  factory $RankUserInfoCopyWith(RankUserInfo value, $Res Function(RankUserInfo) _then) = _$RankUserInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String? code,@JsonKey(name: 'msg') String? msg,@JsonKey(name: 'data') RankUserData? data
});


$RankUserDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$RankUserInfoCopyWithImpl<$Res>
    implements $RankUserInfoCopyWith<$Res> {
  _$RankUserInfoCopyWithImpl(this._self, this._then);

  final RankUserInfo _self;
  final $Res Function(RankUserInfo) _then;

/// Create a copy of RankUserInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = freezed,Object? msg = freezed,Object? data = freezed,}) {
  return _then(RankUserInfo(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,msg: freezed == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as RankUserData?,
  ));
}
/// Create a copy of RankUserInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RankUserDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $RankUserDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [RankUserInfo].
extension RankUserInfoPatterns on RankUserInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankUserInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankUserInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankUserInfo value)  $default,){
final _that = this;
switch (_that) {
case _RankUserInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankUserInfo value)?  $default,){
final _that = this;
switch (_that) {
case _RankUserInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'code')  String? code, @JsonKey(name: 'msg')  String? msg, @JsonKey(name: 'data')  RankUserData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankUserInfo() when $default != null:
return $default(_that.code,_that.msg,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'code')  String? code, @JsonKey(name: 'msg')  String? msg, @JsonKey(name: 'data')  RankUserData? data)  $default,) {final _that = this;
switch (_that) {
case _RankUserInfo():
return $default(_that.code,_that.msg,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'code')  String? code, @JsonKey(name: 'msg')  String? msg, @JsonKey(name: 'data')  RankUserData? data)?  $default,) {final _that = this;
switch (_that) {
case _RankUserInfo() when $default != null:
return $default(_that.code,_that.msg,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankUserInfo implements RankUserInfo {
  const _RankUserInfo({@JsonKey(name: 'code') this.code, @JsonKey(name: 'msg') this.msg, @JsonKey(name: 'data') this.data});
  factory _RankUserInfo.fromJson(Map<String, dynamic> json) => _$RankUserInfoFromJson(json);

@override@JsonKey(name: 'code') final  String? code;
@override@JsonKey(name: 'msg') final  String? msg;
@override@JsonKey(name: 'data') final  RankUserData? data;

/// Create a copy of RankUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankUserInfoCopyWith<_RankUserInfo> get copyWith => __$RankUserInfoCopyWithImpl<_RankUserInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankUserInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankUserInfo&&(identical(other.code, code) || other.code == code)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,msg,data);

@override
String toString() {
  return 'RankUserInfo(code: $code, msg: $msg, data: $data)';
}


}

/// @nodoc
abstract mixin class _$RankUserInfoCopyWith<$Res> implements $RankUserInfoCopyWith<$Res> {
  factory _$RankUserInfoCopyWith(_RankUserInfo value, $Res Function(_RankUserInfo) _then) = __$RankUserInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String? code,@JsonKey(name: 'msg') String? msg,@JsonKey(name: 'data') RankUserData? data
});


@override $RankUserDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$RankUserInfoCopyWithImpl<$Res>
    implements _$RankUserInfoCopyWith<$Res> {
  __$RankUserInfoCopyWithImpl(this._self, this._then);

  final _RankUserInfo _self;
  final $Res Function(_RankUserInfo) _then;

/// Create a copy of RankUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? msg = freezed,Object? data = freezed,}) {
  return _then(_RankUserInfo(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,msg: freezed == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as RankUserData?,
  ));
}

/// Create a copy of RankUserInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RankUserDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $RankUserDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$RankUserData {

@JsonKey(name: 'myRank') int? get myRank;@JsonKey(name: 'calories') double? get calories;@JsonKey(name: 'count') int? get count;
/// Create a copy of RankUserData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankUserDataCopyWith<RankUserData> get copyWith => _$RankUserDataCopyWithImpl<RankUserData>(this as RankUserData, _$identity);

  /// Serializes this RankUserData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankUserData&&(identical(other.myRank, myRank) || other.myRank == myRank)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,myRank,calories,count);

@override
String toString() {
  return 'RankUserData(myRank: $myRank, calories: $calories, count: $count)';
}


}

/// @nodoc
abstract mixin class $RankUserDataCopyWith<$Res>  {
  factory $RankUserDataCopyWith(RankUserData value, $Res Function(RankUserData) _then) = _$RankUserDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'myRank') int? myRank,@JsonKey(name: 'calories') double? calories,@JsonKey(name: 'count') int? count
});




}
/// @nodoc
class _$RankUserDataCopyWithImpl<$Res>
    implements $RankUserDataCopyWith<$Res> {
  _$RankUserDataCopyWithImpl(this._self, this._then);

  final RankUserData _self;
  final $Res Function(RankUserData) _then;

/// Create a copy of RankUserData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? myRank = freezed,Object? calories = freezed,Object? count = freezed,}) {
  return _then(RankUserData(
myRank: freezed == myRank ? _self.myRank : myRank // ignore: cast_nullable_to_non_nullable
as int?,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [RankUserData].
extension RankUserDataPatterns on RankUserData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankUserData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankUserData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankUserData value)  $default,){
final _that = this;
switch (_that) {
case _RankUserData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankUserData value)?  $default,){
final _that = this;
switch (_that) {
case _RankUserData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'myRank')  int? myRank, @JsonKey(name: 'calories')  double? calories, @JsonKey(name: 'count')  int? count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankUserData() when $default != null:
return $default(_that.myRank,_that.calories,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'myRank')  int? myRank, @JsonKey(name: 'calories')  double? calories, @JsonKey(name: 'count')  int? count)  $default,) {final _that = this;
switch (_that) {
case _RankUserData():
return $default(_that.myRank,_that.calories,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'myRank')  int? myRank, @JsonKey(name: 'calories')  double? calories, @JsonKey(name: 'count')  int? count)?  $default,) {final _that = this;
switch (_that) {
case _RankUserData() when $default != null:
return $default(_that.myRank,_that.calories,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankUserData implements RankUserData {
  const _RankUserData({@JsonKey(name: 'myRank') this.myRank, @JsonKey(name: 'calories') this.calories, @JsonKey(name: 'count') this.count});
  factory _RankUserData.fromJson(Map<String, dynamic> json) => _$RankUserDataFromJson(json);

@override@JsonKey(name: 'myRank') final  int? myRank;
@override@JsonKey(name: 'calories') final  double? calories;
@override@JsonKey(name: 'count') final  int? count;

/// Create a copy of RankUserData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankUserDataCopyWith<_RankUserData> get copyWith => __$RankUserDataCopyWithImpl<_RankUserData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankUserDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankUserData&&(identical(other.myRank, myRank) || other.myRank == myRank)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,myRank,calories,count);

@override
String toString() {
  return 'RankUserData(myRank: $myRank, calories: $calories, count: $count)';
}


}

/// @nodoc
abstract mixin class _$RankUserDataCopyWith<$Res> implements $RankUserDataCopyWith<$Res> {
  factory _$RankUserDataCopyWith(_RankUserData value, $Res Function(_RankUserData) _then) = __$RankUserDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'myRank') int? myRank,@JsonKey(name: 'calories') double? calories,@JsonKey(name: 'count') int? count
});




}
/// @nodoc
class __$RankUserDataCopyWithImpl<$Res>
    implements _$RankUserDataCopyWith<$Res> {
  __$RankUserDataCopyWithImpl(this._self, this._then);

  final _RankUserData _self;
  final $Res Function(_RankUserData) _then;

/// Create a copy of RankUserData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? myRank = freezed,Object? calories = freezed,Object? count = freezed,}) {
  return _then(_RankUserData(
myRank: freezed == myRank ? _self.myRank : myRank // ignore: cast_nullable_to_non_nullable
as int?,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
