// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'body_data_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BodyDataState {

 bool get sexValue; int get bodyHeight; int get bodyWeight; String get birthday; String get bodyAgeDay; String get bodyAgeMonth; String get bodyAgeYear; String get nickName; int get heightPosition; int get weightPosition;
/// Create a copy of BodyDataState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BodyDataStateCopyWith<BodyDataState> get copyWith => _$BodyDataStateCopyWithImpl<BodyDataState>(this as BodyDataState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BodyDataState&&(identical(other.sexValue, sexValue) || other.sexValue == sexValue)&&(identical(other.bodyHeight, bodyHeight) || other.bodyHeight == bodyHeight)&&(identical(other.bodyWeight, bodyWeight) || other.bodyWeight == bodyWeight)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.bodyAgeDay, bodyAgeDay) || other.bodyAgeDay == bodyAgeDay)&&(identical(other.bodyAgeMonth, bodyAgeMonth) || other.bodyAgeMonth == bodyAgeMonth)&&(identical(other.bodyAgeYear, bodyAgeYear) || other.bodyAgeYear == bodyAgeYear)&&(identical(other.nickName, nickName) || other.nickName == nickName)&&(identical(other.heightPosition, heightPosition) || other.heightPosition == heightPosition)&&(identical(other.weightPosition, weightPosition) || other.weightPosition == weightPosition));
}


@override
int get hashCode => Object.hash(runtimeType,sexValue,bodyHeight,bodyWeight,birthday,bodyAgeDay,bodyAgeMonth,bodyAgeYear,nickName,heightPosition,weightPosition);

@override
String toString() {
  return 'BodyDataState(sexValue: $sexValue, bodyHeight: $bodyHeight, bodyWeight: $bodyWeight, birthday: $birthday, bodyAgeDay: $bodyAgeDay, bodyAgeMonth: $bodyAgeMonth, bodyAgeYear: $bodyAgeYear, nickName: $nickName, heightPosition: $heightPosition, weightPosition: $weightPosition)';
}


}

/// @nodoc
abstract mixin class $BodyDataStateCopyWith<$Res>  {
  factory $BodyDataStateCopyWith(BodyDataState value, $Res Function(BodyDataState) _then) = _$BodyDataStateCopyWithImpl;
@useResult
$Res call({
 bool sexValue, int bodyHeight, int bodyWeight, String birthday, String bodyAgeDay, String bodyAgeMonth, String bodyAgeYear, String nickName, int heightPosition, int weightPosition
});




}
/// @nodoc
class _$BodyDataStateCopyWithImpl<$Res>
    implements $BodyDataStateCopyWith<$Res> {
  _$BodyDataStateCopyWithImpl(this._self, this._then);

  final BodyDataState _self;
  final $Res Function(BodyDataState) _then;

/// Create a copy of BodyDataState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sexValue = null,Object? bodyHeight = null,Object? bodyWeight = null,Object? birthday = null,Object? bodyAgeDay = null,Object? bodyAgeMonth = null,Object? bodyAgeYear = null,Object? nickName = null,Object? heightPosition = null,Object? weightPosition = null,}) {
  return _then(BodyDataState(
sexValue: null == sexValue ? _self.sexValue : sexValue // ignore: cast_nullable_to_non_nullable
as bool,bodyHeight: null == bodyHeight ? _self.bodyHeight : bodyHeight // ignore: cast_nullable_to_non_nullable
as int,bodyWeight: null == bodyWeight ? _self.bodyWeight : bodyWeight // ignore: cast_nullable_to_non_nullable
as int,birthday: null == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String,bodyAgeDay: null == bodyAgeDay ? _self.bodyAgeDay : bodyAgeDay // ignore: cast_nullable_to_non_nullable
as String,bodyAgeMonth: null == bodyAgeMonth ? _self.bodyAgeMonth : bodyAgeMonth // ignore: cast_nullable_to_non_nullable
as String,bodyAgeYear: null == bodyAgeYear ? _self.bodyAgeYear : bodyAgeYear // ignore: cast_nullable_to_non_nullable
as String,nickName: null == nickName ? _self.nickName : nickName // ignore: cast_nullable_to_non_nullable
as String,heightPosition: null == heightPosition ? _self.heightPosition : heightPosition // ignore: cast_nullable_to_non_nullable
as int,weightPosition: null == weightPosition ? _self.weightPosition : weightPosition // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BodyDataState].
extension BodyDataStatePatterns on BodyDataState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BodyDataState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BodyDataState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BodyDataState value)  $default,){
final _that = this;
switch (_that) {
case _BodyDataState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BodyDataState value)?  $default,){
final _that = this;
switch (_that) {
case _BodyDataState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool sexValue,  int bodyHeight,  int bodyWeight,  String birthday,  String bodyAgeDay,  String bodyAgeMonth,  String bodyAgeYear,  String nickName,  int heightPosition,  int weightPosition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BodyDataState() when $default != null:
return $default(_that.sexValue,_that.bodyHeight,_that.bodyWeight,_that.birthday,_that.bodyAgeDay,_that.bodyAgeMonth,_that.bodyAgeYear,_that.nickName,_that.heightPosition,_that.weightPosition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool sexValue,  int bodyHeight,  int bodyWeight,  String birthday,  String bodyAgeDay,  String bodyAgeMonth,  String bodyAgeYear,  String nickName,  int heightPosition,  int weightPosition)  $default,) {final _that = this;
switch (_that) {
case _BodyDataState():
return $default(_that.sexValue,_that.bodyHeight,_that.bodyWeight,_that.birthday,_that.bodyAgeDay,_that.bodyAgeMonth,_that.bodyAgeYear,_that.nickName,_that.heightPosition,_that.weightPosition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool sexValue,  int bodyHeight,  int bodyWeight,  String birthday,  String bodyAgeDay,  String bodyAgeMonth,  String bodyAgeYear,  String nickName,  int heightPosition,  int weightPosition)?  $default,) {final _that = this;
switch (_that) {
case _BodyDataState() when $default != null:
return $default(_that.sexValue,_that.bodyHeight,_that.bodyWeight,_that.birthday,_that.bodyAgeDay,_that.bodyAgeMonth,_that.bodyAgeYear,_that.nickName,_that.heightPosition,_that.weightPosition);case _:
  return null;

}
}

}

/// @nodoc


class _BodyDataState implements BodyDataState {
  const _BodyDataState({this.sexValue = false, this.bodyHeight = 150, this.bodyWeight = 50, this.birthday = '2000-01-01', this.bodyAgeDay = '01', this.bodyAgeMonth = '01', this.bodyAgeYear = '1991', this.nickName = 'UserName', this.heightPosition = 70, this.weightPosition = 50});
  

@override@JsonKey() final  bool sexValue;
@override@JsonKey() final  int bodyHeight;
@override@JsonKey() final  int bodyWeight;
@override@JsonKey() final  String birthday;
@override@JsonKey() final  String bodyAgeDay;
@override@JsonKey() final  String bodyAgeMonth;
@override@JsonKey() final  String bodyAgeYear;
@override@JsonKey() final  String nickName;
@override@JsonKey() final  int heightPosition;
@override@JsonKey() final  int weightPosition;

/// Create a copy of BodyDataState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BodyDataStateCopyWith<_BodyDataState> get copyWith => __$BodyDataStateCopyWithImpl<_BodyDataState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BodyDataState&&(identical(other.sexValue, sexValue) || other.sexValue == sexValue)&&(identical(other.bodyHeight, bodyHeight) || other.bodyHeight == bodyHeight)&&(identical(other.bodyWeight, bodyWeight) || other.bodyWeight == bodyWeight)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.bodyAgeDay, bodyAgeDay) || other.bodyAgeDay == bodyAgeDay)&&(identical(other.bodyAgeMonth, bodyAgeMonth) || other.bodyAgeMonth == bodyAgeMonth)&&(identical(other.bodyAgeYear, bodyAgeYear) || other.bodyAgeYear == bodyAgeYear)&&(identical(other.nickName, nickName) || other.nickName == nickName)&&(identical(other.heightPosition, heightPosition) || other.heightPosition == heightPosition)&&(identical(other.weightPosition, weightPosition) || other.weightPosition == weightPosition));
}


@override
int get hashCode => Object.hash(runtimeType,sexValue,bodyHeight,bodyWeight,birthday,bodyAgeDay,bodyAgeMonth,bodyAgeYear,nickName,heightPosition,weightPosition);

@override
String toString() {
  return 'BodyDataState(sexValue: $sexValue, bodyHeight: $bodyHeight, bodyWeight: $bodyWeight, birthday: $birthday, bodyAgeDay: $bodyAgeDay, bodyAgeMonth: $bodyAgeMonth, bodyAgeYear: $bodyAgeYear, nickName: $nickName, heightPosition: $heightPosition, weightPosition: $weightPosition)';
}


}

/// @nodoc
abstract mixin class _$BodyDataStateCopyWith<$Res> implements $BodyDataStateCopyWith<$Res> {
  factory _$BodyDataStateCopyWith(_BodyDataState value, $Res Function(_BodyDataState) _then) = __$BodyDataStateCopyWithImpl;
@override @useResult
$Res call({
 bool sexValue, int bodyHeight, int bodyWeight, String birthday, String bodyAgeDay, String bodyAgeMonth, String bodyAgeYear, String nickName, int heightPosition, int weightPosition
});




}
/// @nodoc
class __$BodyDataStateCopyWithImpl<$Res>
    implements _$BodyDataStateCopyWith<$Res> {
  __$BodyDataStateCopyWithImpl(this._self, this._then);

  final _BodyDataState _self;
  final $Res Function(_BodyDataState) _then;

/// Create a copy of BodyDataState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sexValue = null,Object? bodyHeight = null,Object? bodyWeight = null,Object? birthday = null,Object? bodyAgeDay = null,Object? bodyAgeMonth = null,Object? bodyAgeYear = null,Object? nickName = null,Object? heightPosition = null,Object? weightPosition = null,}) {
  return _then(_BodyDataState(
sexValue: null == sexValue ? _self.sexValue : sexValue // ignore: cast_nullable_to_non_nullable
as bool,bodyHeight: null == bodyHeight ? _self.bodyHeight : bodyHeight // ignore: cast_nullable_to_non_nullable
as int,bodyWeight: null == bodyWeight ? _self.bodyWeight : bodyWeight // ignore: cast_nullable_to_non_nullable
as int,birthday: null == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String,bodyAgeDay: null == bodyAgeDay ? _self.bodyAgeDay : bodyAgeDay // ignore: cast_nullable_to_non_nullable
as String,bodyAgeMonth: null == bodyAgeMonth ? _self.bodyAgeMonth : bodyAgeMonth // ignore: cast_nullable_to_non_nullable
as String,bodyAgeYear: null == bodyAgeYear ? _self.bodyAgeYear : bodyAgeYear // ignore: cast_nullable_to_non_nullable
as String,nickName: null == nickName ? _self.nickName : nickName // ignore: cast_nullable_to_non_nullable
as String,heightPosition: null == heightPosition ? _self.heightPosition : heightPosition // ignore: cast_nullable_to_non_nullable
as int,weightPosition: null == weightPosition ? _self.weightPosition : weightPosition // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
