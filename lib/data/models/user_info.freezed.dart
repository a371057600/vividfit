// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FitUserInfo {

 int? get id; String? get nickName; bool? get sex;// true = 男
 String? get birthday; int? get height; int? get weight; String? get headImage; String? get mailAddress; String? get phoneNumber; String? get phoneArea; String? get createTime; bool? get disabled; bool? get hasPsw;
/// Create a copy of FitUserInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FitUserInfoCopyWith<FitUserInfo> get copyWith => _$FitUserInfoCopyWithImpl<FitUserInfo>(this as FitUserInfo, _$identity);

  /// Serializes this FitUserInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FitUserInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.nickName, nickName) || other.nickName == nickName)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.height, height) || other.height == height)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.headImage, headImage) || other.headImage == headImage)&&(identical(other.mailAddress, mailAddress) || other.mailAddress == mailAddress)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.phoneArea, phoneArea) || other.phoneArea == phoneArea)&&(identical(other.createTime, createTime) || other.createTime == createTime)&&(identical(other.disabled, disabled) || other.disabled == disabled)&&(identical(other.hasPsw, hasPsw) || other.hasPsw == hasPsw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nickName,sex,birthday,height,weight,headImage,mailAddress,phoneNumber,phoneArea,createTime,disabled,hasPsw);

@override
String toString() {
  return 'FitUserInfo(id: $id, nickName: $nickName, sex: $sex, birthday: $birthday, height: $height, weight: $weight, headImage: $headImage, mailAddress: $mailAddress, phoneNumber: $phoneNumber, phoneArea: $phoneArea, createTime: $createTime, disabled: $disabled, hasPsw: $hasPsw)';
}


}

/// @nodoc
abstract mixin class $FitUserInfoCopyWith<$Res>  {
  factory $FitUserInfoCopyWith(FitUserInfo value, $Res Function(FitUserInfo) _then) = _$FitUserInfoCopyWithImpl;
@useResult
$Res call({
 int? id, String? nickName, bool? sex, String? birthday, int? height, int? weight, String? headImage, String? mailAddress, String? phoneNumber, String? phoneArea, String? createTime, bool? disabled, bool? hasPsw
});




}
/// @nodoc
class _$FitUserInfoCopyWithImpl<$Res>
    implements $FitUserInfoCopyWith<$Res> {
  _$FitUserInfoCopyWithImpl(this._self, this._then);

  final FitUserInfo _self;
  final $Res Function(FitUserInfo) _then;

/// Create a copy of FitUserInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? nickName = freezed,Object? sex = freezed,Object? birthday = freezed,Object? height = freezed,Object? weight = freezed,Object? headImage = freezed,Object? mailAddress = freezed,Object? phoneNumber = freezed,Object? phoneArea = freezed,Object? createTime = freezed,Object? disabled = freezed,Object? hasPsw = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,nickName: freezed == nickName ? _self.nickName : nickName // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as bool?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as int?,headImage: freezed == headImage ? _self.headImage : headImage // ignore: cast_nullable_to_non_nullable
as String?,mailAddress: freezed == mailAddress ? _self.mailAddress : mailAddress // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,phoneArea: freezed == phoneArea ? _self.phoneArea : phoneArea // ignore: cast_nullable_to_non_nullable
as String?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,hasPsw: freezed == hasPsw ? _self.hasPsw : hasPsw // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [FitUserInfo].
extension FitUserInfoPatterns on FitUserInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FitUserInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FitUserInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FitUserInfo value)  $default,){
final _that = this;
switch (_that) {
case _FitUserInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FitUserInfo value)?  $default,){
final _that = this;
switch (_that) {
case _FitUserInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? nickName,  bool? sex,  String? birthday,  int? height,  int? weight,  String? headImage,  String? mailAddress,  String? phoneNumber,  String? phoneArea,  String? createTime,  bool? disabled,  bool? hasPsw)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FitUserInfo() when $default != null:
return $default(_that.id,_that.nickName,_that.sex,_that.birthday,_that.height,_that.weight,_that.headImage,_that.mailAddress,_that.phoneNumber,_that.phoneArea,_that.createTime,_that.disabled,_that.hasPsw);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? nickName,  bool? sex,  String? birthday,  int? height,  int? weight,  String? headImage,  String? mailAddress,  String? phoneNumber,  String? phoneArea,  String? createTime,  bool? disabled,  bool? hasPsw)  $default,) {final _that = this;
switch (_that) {
case _FitUserInfo():
return $default(_that.id,_that.nickName,_that.sex,_that.birthday,_that.height,_that.weight,_that.headImage,_that.mailAddress,_that.phoneNumber,_that.phoneArea,_that.createTime,_that.disabled,_that.hasPsw);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? nickName,  bool? sex,  String? birthday,  int? height,  int? weight,  String? headImage,  String? mailAddress,  String? phoneNumber,  String? phoneArea,  String? createTime,  bool? disabled,  bool? hasPsw)?  $default,) {final _that = this;
switch (_that) {
case _FitUserInfo() when $default != null:
return $default(_that.id,_that.nickName,_that.sex,_that.birthday,_that.height,_that.weight,_that.headImage,_that.mailAddress,_that.phoneNumber,_that.phoneArea,_that.createTime,_that.disabled,_that.hasPsw);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FitUserInfo implements FitUserInfo {
  const _FitUserInfo({this.id, this.nickName, this.sex, this.birthday, this.height, this.weight, this.headImage, this.mailAddress, this.phoneNumber, this.phoneArea, this.createTime, this.disabled, this.hasPsw});
  factory _FitUserInfo.fromJson(Map<String, dynamic> json) => _$FitUserInfoFromJson(json);

@override final  int? id;
@override final  String? nickName;
@override final  bool? sex;
// true = 男
@override final  String? birthday;
@override final  int? height;
@override final  int? weight;
@override final  String? headImage;
@override final  String? mailAddress;
@override final  String? phoneNumber;
@override final  String? phoneArea;
@override final  String? createTime;
@override final  bool? disabled;
@override final  bool? hasPsw;

/// Create a copy of FitUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FitUserInfoCopyWith<_FitUserInfo> get copyWith => __$FitUserInfoCopyWithImpl<_FitUserInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FitUserInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FitUserInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.nickName, nickName) || other.nickName == nickName)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.height, height) || other.height == height)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.headImage, headImage) || other.headImage == headImage)&&(identical(other.mailAddress, mailAddress) || other.mailAddress == mailAddress)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.phoneArea, phoneArea) || other.phoneArea == phoneArea)&&(identical(other.createTime, createTime) || other.createTime == createTime)&&(identical(other.disabled, disabled) || other.disabled == disabled)&&(identical(other.hasPsw, hasPsw) || other.hasPsw == hasPsw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nickName,sex,birthday,height,weight,headImage,mailAddress,phoneNumber,phoneArea,createTime,disabled,hasPsw);

@override
String toString() {
  return 'FitUserInfo(id: $id, nickName: $nickName, sex: $sex, birthday: $birthday, height: $height, weight: $weight, headImage: $headImage, mailAddress: $mailAddress, phoneNumber: $phoneNumber, phoneArea: $phoneArea, createTime: $createTime, disabled: $disabled, hasPsw: $hasPsw)';
}


}

/// @nodoc
abstract mixin class _$FitUserInfoCopyWith<$Res> implements $FitUserInfoCopyWith<$Res> {
  factory _$FitUserInfoCopyWith(_FitUserInfo value, $Res Function(_FitUserInfo) _then) = __$FitUserInfoCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? nickName, bool? sex, String? birthday, int? height, int? weight, String? headImage, String? mailAddress, String? phoneNumber, String? phoneArea, String? createTime, bool? disabled, bool? hasPsw
});




}
/// @nodoc
class __$FitUserInfoCopyWithImpl<$Res>
    implements _$FitUserInfoCopyWith<$Res> {
  __$FitUserInfoCopyWithImpl(this._self, this._then);

  final _FitUserInfo _self;
  final $Res Function(_FitUserInfo) _then;

/// Create a copy of FitUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? nickName = freezed,Object? sex = freezed,Object? birthday = freezed,Object? height = freezed,Object? weight = freezed,Object? headImage = freezed,Object? mailAddress = freezed,Object? phoneNumber = freezed,Object? phoneArea = freezed,Object? createTime = freezed,Object? disabled = freezed,Object? hasPsw = freezed,}) {
  return _then(_FitUserInfo(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,nickName: freezed == nickName ? _self.nickName : nickName // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as bool?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as int?,headImage: freezed == headImage ? _self.headImage : headImage // ignore: cast_nullable_to_non_nullable
as String?,mailAddress: freezed == mailAddress ? _self.mailAddress : mailAddress // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,phoneArea: freezed == phoneArea ? _self.phoneArea : phoneArea // ignore: cast_nullable_to_non_nullable
as String?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,hasPsw: freezed == hasPsw ? _self.hasPsw : hasPsw // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
