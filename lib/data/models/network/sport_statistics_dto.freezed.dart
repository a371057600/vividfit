// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sport_statistics_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SportStatisticsDataResultDto {

 double? get calorie; int? get duringTime; String? get endTime; int? get sportCount; double? get sportDistance; String? get startTime;
/// Create a copy of SportStatisticsDataResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SportStatisticsDataResultDtoCopyWith<SportStatisticsDataResultDto> get copyWith => _$SportStatisticsDataResultDtoCopyWithImpl<SportStatisticsDataResultDto>(this as SportStatisticsDataResultDto, _$identity);

  /// Serializes this SportStatisticsDataResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SportStatisticsDataResultDto&&(identical(other.calorie, calorie) || other.calorie == calorie)&&(identical(other.duringTime, duringTime) || other.duringTime == duringTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.sportCount, sportCount) || other.sportCount == sportCount)&&(identical(other.sportDistance, sportDistance) || other.sportDistance == sportDistance)&&(identical(other.startTime, startTime) || other.startTime == startTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,calorie,duringTime,endTime,sportCount,sportDistance,startTime);

@override
String toString() {
  return 'SportStatisticsDataResultDto(calorie: $calorie, duringTime: $duringTime, endTime: $endTime, sportCount: $sportCount, sportDistance: $sportDistance, startTime: $startTime)';
}


}

/// @nodoc
abstract mixin class $SportStatisticsDataResultDtoCopyWith<$Res>  {
  factory $SportStatisticsDataResultDtoCopyWith(SportStatisticsDataResultDto value, $Res Function(SportStatisticsDataResultDto) _then) = _$SportStatisticsDataResultDtoCopyWithImpl;
@useResult
$Res call({
 double? calorie, int? duringTime, String? endTime, int? sportCount, double? sportDistance, String? startTime
});




}
/// @nodoc
class _$SportStatisticsDataResultDtoCopyWithImpl<$Res>
    implements $SportStatisticsDataResultDtoCopyWith<$Res> {
  _$SportStatisticsDataResultDtoCopyWithImpl(this._self, this._then);

  final SportStatisticsDataResultDto _self;
  final $Res Function(SportStatisticsDataResultDto) _then;

/// Create a copy of SportStatisticsDataResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? calorie = freezed,Object? duringTime = freezed,Object? endTime = freezed,Object? sportCount = freezed,Object? sportDistance = freezed,Object? startTime = freezed,}) {
  return _then(SportStatisticsDataResultDto(
calorie: freezed == calorie ? _self.calorie : calorie // ignore: cast_nullable_to_non_nullable
as double?,duringTime: freezed == duringTime ? _self.duringTime : duringTime // ignore: cast_nullable_to_non_nullable
as int?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,sportCount: freezed == sportCount ? _self.sportCount : sportCount // ignore: cast_nullable_to_non_nullable
as int?,sportDistance: freezed == sportDistance ? _self.sportDistance : sportDistance // ignore: cast_nullable_to_non_nullable
as double?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SportStatisticsDataResultDto].
extension SportStatisticsDataResultDtoPatterns on SportStatisticsDataResultDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SportStatisticsDataResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SportStatisticsDataResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SportStatisticsDataResultDto value)  $default,){
final _that = this;
switch (_that) {
case _SportStatisticsDataResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SportStatisticsDataResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _SportStatisticsDataResultDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? calorie,  int? duringTime,  String? endTime,  int? sportCount,  double? sportDistance,  String? startTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SportStatisticsDataResultDto() when $default != null:
return $default(_that.calorie,_that.duringTime,_that.endTime,_that.sportCount,_that.sportDistance,_that.startTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? calorie,  int? duringTime,  String? endTime,  int? sportCount,  double? sportDistance,  String? startTime)  $default,) {final _that = this;
switch (_that) {
case _SportStatisticsDataResultDto():
return $default(_that.calorie,_that.duringTime,_that.endTime,_that.sportCount,_that.sportDistance,_that.startTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? calorie,  int? duringTime,  String? endTime,  int? sportCount,  double? sportDistance,  String? startTime)?  $default,) {final _that = this;
switch (_that) {
case _SportStatisticsDataResultDto() when $default != null:
return $default(_that.calorie,_that.duringTime,_that.endTime,_that.sportCount,_that.sportDistance,_that.startTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SportStatisticsDataResultDto implements SportStatisticsDataResultDto {
  const _SportStatisticsDataResultDto({this.calorie, this.duringTime, this.endTime, this.sportCount, this.sportDistance, this.startTime});
  factory _SportStatisticsDataResultDto.fromJson(Map<String, dynamic> json) => _$SportStatisticsDataResultDtoFromJson(json);

@override final  double? calorie;
@override final  int? duringTime;
@override final  String? endTime;
@override final  int? sportCount;
@override final  double? sportDistance;
@override final  String? startTime;

/// Create a copy of SportStatisticsDataResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SportStatisticsDataResultDtoCopyWith<_SportStatisticsDataResultDto> get copyWith => __$SportStatisticsDataResultDtoCopyWithImpl<_SportStatisticsDataResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SportStatisticsDataResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SportStatisticsDataResultDto&&(identical(other.calorie, calorie) || other.calorie == calorie)&&(identical(other.duringTime, duringTime) || other.duringTime == duringTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.sportCount, sportCount) || other.sportCount == sportCount)&&(identical(other.sportDistance, sportDistance) || other.sportDistance == sportDistance)&&(identical(other.startTime, startTime) || other.startTime == startTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,calorie,duringTime,endTime,sportCount,sportDistance,startTime);

@override
String toString() {
  return 'SportStatisticsDataResultDto(calorie: $calorie, duringTime: $duringTime, endTime: $endTime, sportCount: $sportCount, sportDistance: $sportDistance, startTime: $startTime)';
}


}

/// @nodoc
abstract mixin class _$SportStatisticsDataResultDtoCopyWith<$Res> implements $SportStatisticsDataResultDtoCopyWith<$Res> {
  factory _$SportStatisticsDataResultDtoCopyWith(_SportStatisticsDataResultDto value, $Res Function(_SportStatisticsDataResultDto) _then) = __$SportStatisticsDataResultDtoCopyWithImpl;
@override @useResult
$Res call({
 double? calorie, int? duringTime, String? endTime, int? sportCount, double? sportDistance, String? startTime
});




}
/// @nodoc
class __$SportStatisticsDataResultDtoCopyWithImpl<$Res>
    implements _$SportStatisticsDataResultDtoCopyWith<$Res> {
  __$SportStatisticsDataResultDtoCopyWithImpl(this._self, this._then);

  final _SportStatisticsDataResultDto _self;
  final $Res Function(_SportStatisticsDataResultDto) _then;

/// Create a copy of SportStatisticsDataResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? calorie = freezed,Object? duringTime = freezed,Object? endTime = freezed,Object? sportCount = freezed,Object? sportDistance = freezed,Object? startTime = freezed,}) {
  return _then(_SportStatisticsDataResultDto(
calorie: freezed == calorie ? _self.calorie : calorie // ignore: cast_nullable_to_non_nullable
as double?,duringTime: freezed == duringTime ? _self.duringTime : duringTime // ignore: cast_nullable_to_non_nullable
as int?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,sportCount: freezed == sportCount ? _self.sportCount : sportCount // ignore: cast_nullable_to_non_nullable
as int?,sportDistance: freezed == sportDistance ? _self.sportDistance : sportDistance // ignore: cast_nullable_to_non_nullable
as double?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
