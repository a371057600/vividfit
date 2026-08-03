// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'third_party_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThirdPartyUser {

 int? get id; int? get userId; String? get nickName; String? get headImgUrl; int? get type; String? get openId; String? get unionId; String? get province; String? get city; String? get country; bool? get sex;
/// Create a copy of ThirdPartyUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThirdPartyUserCopyWith<ThirdPartyUser> get copyWith => _$ThirdPartyUserCopyWithImpl<ThirdPartyUser>(this as ThirdPartyUser, _$identity);

  /// Serializes this ThirdPartyUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThirdPartyUser&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickName, nickName) || other.nickName == nickName)&&(identical(other.headImgUrl, headImgUrl) || other.headImgUrl == headImgUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.openId, openId) || other.openId == openId)&&(identical(other.unionId, unionId) || other.unionId == unionId)&&(identical(other.province, province) || other.province == province)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country)&&(identical(other.sex, sex) || other.sex == sex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,nickName,headImgUrl,type,openId,unionId,province,city,country,sex);

@override
String toString() {
  return 'ThirdPartyUser(id: $id, userId: $userId, nickName: $nickName, headImgUrl: $headImgUrl, type: $type, openId: $openId, unionId: $unionId, province: $province, city: $city, country: $country, sex: $sex)';
}


}

/// @nodoc
abstract mixin class $ThirdPartyUserCopyWith<$Res>  {
  factory $ThirdPartyUserCopyWith(ThirdPartyUser value, $Res Function(ThirdPartyUser) _then) = _$ThirdPartyUserCopyWithImpl;
@useResult
$Res call({
 int? id, int? userId, String? nickName, String? headImgUrl, int? type, String? openId, String? unionId, String? province, String? city, String? country, bool? sex
});




}
/// @nodoc
class _$ThirdPartyUserCopyWithImpl<$Res>
    implements $ThirdPartyUserCopyWith<$Res> {
  _$ThirdPartyUserCopyWithImpl(this._self, this._then);

  final ThirdPartyUser _self;
  final $Res Function(ThirdPartyUser) _then;

/// Create a copy of ThirdPartyUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? nickName = freezed,Object? headImgUrl = freezed,Object? type = freezed,Object? openId = freezed,Object? unionId = freezed,Object? province = freezed,Object? city = freezed,Object? country = freezed,Object? sex = freezed,}) {
  return _then(ThirdPartyUser(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,nickName: freezed == nickName ? _self.nickName : nickName // ignore: cast_nullable_to_non_nullable
as String?,headImgUrl: freezed == headImgUrl ? _self.headImgUrl : headImgUrl // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int?,openId: freezed == openId ? _self.openId : openId // ignore: cast_nullable_to_non_nullable
as String?,unionId: freezed == unionId ? _self.unionId : unionId // ignore: cast_nullable_to_non_nullable
as String?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [ThirdPartyUser].
extension ThirdPartyUserPatterns on ThirdPartyUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ThirdPartyUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ThirdPartyUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ThirdPartyUser value)  $default,){
final _that = this;
switch (_that) {
case _ThirdPartyUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ThirdPartyUser value)?  $default,){
final _that = this;
switch (_that) {
case _ThirdPartyUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? userId,  String? nickName,  String? headImgUrl,  int? type,  String? openId,  String? unionId,  String? province,  String? city,  String? country,  bool? sex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ThirdPartyUser() when $default != null:
return $default(_that.id,_that.userId,_that.nickName,_that.headImgUrl,_that.type,_that.openId,_that.unionId,_that.province,_that.city,_that.country,_that.sex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? userId,  String? nickName,  String? headImgUrl,  int? type,  String? openId,  String? unionId,  String? province,  String? city,  String? country,  bool? sex)  $default,) {final _that = this;
switch (_that) {
case _ThirdPartyUser():
return $default(_that.id,_that.userId,_that.nickName,_that.headImgUrl,_that.type,_that.openId,_that.unionId,_that.province,_that.city,_that.country,_that.sex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? userId,  String? nickName,  String? headImgUrl,  int? type,  String? openId,  String? unionId,  String? province,  String? city,  String? country,  bool? sex)?  $default,) {final _that = this;
switch (_that) {
case _ThirdPartyUser() when $default != null:
return $default(_that.id,_that.userId,_that.nickName,_that.headImgUrl,_that.type,_that.openId,_that.unionId,_that.province,_that.city,_that.country,_that.sex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ThirdPartyUser implements ThirdPartyUser {
  const _ThirdPartyUser({this.id, this.userId, this.nickName, this.headImgUrl, this.type, this.openId, this.unionId, this.province, this.city, this.country, this.sex});
  factory _ThirdPartyUser.fromJson(Map<String, dynamic> json) => _$ThirdPartyUserFromJson(json);

@override final  int? id;
@override final  int? userId;
@override final  String? nickName;
@override final  String? headImgUrl;
@override final  int? type;
@override final  String? openId;
@override final  String? unionId;
@override final  String? province;
@override final  String? city;
@override final  String? country;
@override final  bool? sex;

/// Create a copy of ThirdPartyUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThirdPartyUserCopyWith<_ThirdPartyUser> get copyWith => __$ThirdPartyUserCopyWithImpl<_ThirdPartyUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ThirdPartyUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ThirdPartyUser&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickName, nickName) || other.nickName == nickName)&&(identical(other.headImgUrl, headImgUrl) || other.headImgUrl == headImgUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.openId, openId) || other.openId == openId)&&(identical(other.unionId, unionId) || other.unionId == unionId)&&(identical(other.province, province) || other.province == province)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country)&&(identical(other.sex, sex) || other.sex == sex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,nickName,headImgUrl,type,openId,unionId,province,city,country,sex);

@override
String toString() {
  return 'ThirdPartyUser(id: $id, userId: $userId, nickName: $nickName, headImgUrl: $headImgUrl, type: $type, openId: $openId, unionId: $unionId, province: $province, city: $city, country: $country, sex: $sex)';
}


}

/// @nodoc
abstract mixin class _$ThirdPartyUserCopyWith<$Res> implements $ThirdPartyUserCopyWith<$Res> {
  factory _$ThirdPartyUserCopyWith(_ThirdPartyUser value, $Res Function(_ThirdPartyUser) _then) = __$ThirdPartyUserCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? userId, String? nickName, String? headImgUrl, int? type, String? openId, String? unionId, String? province, String? city, String? country, bool? sex
});




}
/// @nodoc
class __$ThirdPartyUserCopyWithImpl<$Res>
    implements _$ThirdPartyUserCopyWith<$Res> {
  __$ThirdPartyUserCopyWithImpl(this._self, this._then);

  final _ThirdPartyUser _self;
  final $Res Function(_ThirdPartyUser) _then;

/// Create a copy of ThirdPartyUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? nickName = freezed,Object? headImgUrl = freezed,Object? type = freezed,Object? openId = freezed,Object? unionId = freezed,Object? province = freezed,Object? city = freezed,Object? country = freezed,Object? sex = freezed,}) {
  return _then(_ThirdPartyUser(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,nickName: freezed == nickName ? _self.nickName : nickName // ignore: cast_nullable_to_non_nullable
as String?,headImgUrl: freezed == headImgUrl ? _self.headImgUrl : headImgUrl // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int?,openId: freezed == openId ? _self.openId : openId // ignore: cast_nullable_to_non_nullable
as String?,unionId: freezed == unionId ? _self.unionId : unionId // ignore: cast_nullable_to_non_nullable
as String?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
