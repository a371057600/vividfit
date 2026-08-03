// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserInfoDto {

 int? get id; String? get nickName; String? get birthday; bool? get sex; int? get height; int? get weight;
/// Create a copy of UserInfoDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserInfoDtoCopyWith<UserInfoDto> get copyWith => _$UserInfoDtoCopyWithImpl<UserInfoDto>(this as UserInfoDto, _$identity);

  /// Serializes this UserInfoDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserInfoDto&&(identical(other.id, id) || other.id == id)&&(identical(other.nickName, nickName) || other.nickName == nickName)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.height, height) || other.height == height)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nickName,birthday,sex,height,weight);

@override
String toString() {
  return 'UserInfoDto(id: $id, nickName: $nickName, birthday: $birthday, sex: $sex, height: $height, weight: $weight)';
}


}

/// @nodoc
abstract mixin class $UserInfoDtoCopyWith<$Res>  {
  factory $UserInfoDtoCopyWith(UserInfoDto value, $Res Function(UserInfoDto) _then) = _$UserInfoDtoCopyWithImpl;
@useResult
$Res call({
 int? id, String? nickName, String? birthday, bool? sex, int? height, int? weight
});




}
/// @nodoc
class _$UserInfoDtoCopyWithImpl<$Res>
    implements $UserInfoDtoCopyWith<$Res> {
  _$UserInfoDtoCopyWithImpl(this._self, this._then);

  final UserInfoDto _self;
  final $Res Function(UserInfoDto) _then;

/// Create a copy of UserInfoDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? nickName = freezed,Object? birthday = freezed,Object? sex = freezed,Object? height = freezed,Object? weight = freezed,}) {
  return _then(UserInfoDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,nickName: freezed == nickName ? _self.nickName : nickName // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as bool?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserInfoDto].
extension UserInfoDtoPatterns on UserInfoDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserInfoDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserInfoDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserInfoDto value)  $default,){
final _that = this;
switch (_that) {
case _UserInfoDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserInfoDto value)?  $default,){
final _that = this;
switch (_that) {
case _UserInfoDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? nickName,  String? birthday,  bool? sex,  int? height,  int? weight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserInfoDto() when $default != null:
return $default(_that.id,_that.nickName,_that.birthday,_that.sex,_that.height,_that.weight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? nickName,  String? birthday,  bool? sex,  int? height,  int? weight)  $default,) {final _that = this;
switch (_that) {
case _UserInfoDto():
return $default(_that.id,_that.nickName,_that.birthday,_that.sex,_that.height,_that.weight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? nickName,  String? birthday,  bool? sex,  int? height,  int? weight)?  $default,) {final _that = this;
switch (_that) {
case _UserInfoDto() when $default != null:
return $default(_that.id,_that.nickName,_that.birthday,_that.sex,_that.height,_that.weight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserInfoDto implements UserInfoDto {
  const _UserInfoDto({this.id, this.nickName, this.birthday, this.sex, this.height, this.weight});
  factory _UserInfoDto.fromJson(Map<String, dynamic> json) => _$UserInfoDtoFromJson(json);

@override final  int? id;
@override final  String? nickName;
@override final  String? birthday;
@override final  bool? sex;
@override final  int? height;
@override final  int? weight;

/// Create a copy of UserInfoDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserInfoDtoCopyWith<_UserInfoDto> get copyWith => __$UserInfoDtoCopyWithImpl<_UserInfoDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserInfoDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserInfoDto&&(identical(other.id, id) || other.id == id)&&(identical(other.nickName, nickName) || other.nickName == nickName)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.height, height) || other.height == height)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nickName,birthday,sex,height,weight);

@override
String toString() {
  return 'UserInfoDto(id: $id, nickName: $nickName, birthday: $birthday, sex: $sex, height: $height, weight: $weight)';
}


}

/// @nodoc
abstract mixin class _$UserInfoDtoCopyWith<$Res> implements $UserInfoDtoCopyWith<$Res> {
  factory _$UserInfoDtoCopyWith(_UserInfoDto value, $Res Function(_UserInfoDto) _then) = __$UserInfoDtoCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? nickName, String? birthday, bool? sex, int? height, int? weight
});




}
/// @nodoc
class __$UserInfoDtoCopyWithImpl<$Res>
    implements _$UserInfoDtoCopyWith<$Res> {
  __$UserInfoDtoCopyWithImpl(this._self, this._then);

  final _UserInfoDto _self;
  final $Res Function(_UserInfoDto) _then;

/// Create a copy of UserInfoDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? nickName = freezed,Object? birthday = freezed,Object? sex = freezed,Object? height = freezed,Object? weight = freezed,}) {
  return _then(_UserInfoDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,nickName: freezed == nickName ? _self.nickName : nickName // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as bool?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$UserInfoResultDto {

 FitUserInfo? get userInfo; List<ThirdPartyUser>? get thirdPartInfos;
/// Create a copy of UserInfoResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserInfoResultDtoCopyWith<UserInfoResultDto> get copyWith => _$UserInfoResultDtoCopyWithImpl<UserInfoResultDto>(this as UserInfoResultDto, _$identity);

  /// Serializes this UserInfoResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserInfoResultDto&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&const DeepCollectionEquality().equals(other.thirdPartInfos, thirdPartInfos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userInfo,const DeepCollectionEquality().hash(thirdPartInfos));

@override
String toString() {
  return 'UserInfoResultDto(userInfo: $userInfo, thirdPartInfos: $thirdPartInfos)';
}


}

/// @nodoc
abstract mixin class $UserInfoResultDtoCopyWith<$Res>  {
  factory $UserInfoResultDtoCopyWith(UserInfoResultDto value, $Res Function(UserInfoResultDto) _then) = _$UserInfoResultDtoCopyWithImpl;
@useResult
$Res call({
 FitUserInfo? userInfo, List<ThirdPartyUser>? thirdPartInfos
});


$FitUserInfoCopyWith<$Res>? get userInfo;

}
/// @nodoc
class _$UserInfoResultDtoCopyWithImpl<$Res>
    implements $UserInfoResultDtoCopyWith<$Res> {
  _$UserInfoResultDtoCopyWithImpl(this._self, this._then);

  final UserInfoResultDto _self;
  final $Res Function(UserInfoResultDto) _then;

/// Create a copy of UserInfoResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userInfo = freezed,Object? thirdPartInfos = freezed,}) {
  return _then(UserInfoResultDto(
userInfo: freezed == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as FitUserInfo?,thirdPartInfos: freezed == thirdPartInfos ? _self.thirdPartInfos : thirdPartInfos // ignore: cast_nullable_to_non_nullable
as List<ThirdPartyUser>?,
  ));
}
/// Create a copy of UserInfoResultDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FitUserInfoCopyWith<$Res>? get userInfo {
    if (_self.userInfo == null) {
    return null;
  }

  return $FitUserInfoCopyWith<$Res>(_self.userInfo!, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserInfoResultDto].
extension UserInfoResultDtoPatterns on UserInfoResultDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserInfoResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserInfoResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserInfoResultDto value)  $default,){
final _that = this;
switch (_that) {
case _UserInfoResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserInfoResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _UserInfoResultDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FitUserInfo? userInfo,  List<ThirdPartyUser>? thirdPartInfos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserInfoResultDto() when $default != null:
return $default(_that.userInfo,_that.thirdPartInfos);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FitUserInfo? userInfo,  List<ThirdPartyUser>? thirdPartInfos)  $default,) {final _that = this;
switch (_that) {
case _UserInfoResultDto():
return $default(_that.userInfo,_that.thirdPartInfos);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FitUserInfo? userInfo,  List<ThirdPartyUser>? thirdPartInfos)?  $default,) {final _that = this;
switch (_that) {
case _UserInfoResultDto() when $default != null:
return $default(_that.userInfo,_that.thirdPartInfos);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserInfoResultDto implements UserInfoResultDto {
  const _UserInfoResultDto({this.userInfo,  List<ThirdPartyUser>? thirdPartInfos}): _thirdPartInfos = thirdPartInfos;
  factory _UserInfoResultDto.fromJson(Map<String, dynamic> json) => _$UserInfoResultDtoFromJson(json);

@override final  FitUserInfo? userInfo;
 final  List<ThirdPartyUser>? _thirdPartInfos;
@override List<ThirdPartyUser>? get thirdPartInfos {
  final value = _thirdPartInfos;
  if (value == null) return null;
  if (_thirdPartInfos is EqualUnmodifiableListView) return _thirdPartInfos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of UserInfoResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserInfoResultDtoCopyWith<_UserInfoResultDto> get copyWith => __$UserInfoResultDtoCopyWithImpl<_UserInfoResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserInfoResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserInfoResultDto&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&const DeepCollectionEquality().equals(other._thirdPartInfos, _thirdPartInfos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userInfo,const DeepCollectionEquality().hash(_thirdPartInfos));

@override
String toString() {
  return 'UserInfoResultDto(userInfo: $userInfo, thirdPartInfos: $thirdPartInfos)';
}


}

/// @nodoc
abstract mixin class _$UserInfoResultDtoCopyWith<$Res> implements $UserInfoResultDtoCopyWith<$Res> {
  factory _$UserInfoResultDtoCopyWith(_UserInfoResultDto value, $Res Function(_UserInfoResultDto) _then) = __$UserInfoResultDtoCopyWithImpl;
@override @useResult
$Res call({
 FitUserInfo? userInfo, List<ThirdPartyUser>? thirdPartInfos
});


@override $FitUserInfoCopyWith<$Res>? get userInfo;

}
/// @nodoc
class __$UserInfoResultDtoCopyWithImpl<$Res>
    implements _$UserInfoResultDtoCopyWith<$Res> {
  __$UserInfoResultDtoCopyWithImpl(this._self, this._then);

  final _UserInfoResultDto _self;
  final $Res Function(_UserInfoResultDto) _then;

/// Create a copy of UserInfoResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userInfo = freezed,Object? thirdPartInfos = freezed,}) {
  return _then(_UserInfoResultDto(
userInfo: freezed == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as FitUserInfo?,thirdPartInfos: freezed == thirdPartInfos ? _self._thirdPartInfos : thirdPartInfos // ignore: cast_nullable_to_non_nullable
as List<ThirdPartyUser>?,
  ));
}

/// Create a copy of UserInfoResultDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FitUserInfoCopyWith<$Res>? get userInfo {
    if (_self.userInfo == null) {
    return null;
  }

  return $FitUserInfoCopyWith<$Res>(_self.userInfo!, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}
}

// dart format on
