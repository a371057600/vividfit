// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sport_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SportHistory {

 int? get id; int? get userId; int? get equipmentType; int? get mode; int? get trainMode; double? get calories; int? get duringTime; double? get distance; int? get count; bool? get isOffline; String? get startTime; String? get createTime;
/// Create a copy of SportHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SportHistoryCopyWith<SportHistory> get copyWith => _$SportHistoryCopyWithImpl<SportHistory>(this as SportHistory, _$identity);

  /// Serializes this SportHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SportHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.equipmentType, equipmentType) || other.equipmentType == equipmentType)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.trainMode, trainMode) || other.trainMode == trainMode)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.duringTime, duringTime) || other.duringTime == duringTime)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.count, count) || other.count == count)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.createTime, createTime) || other.createTime == createTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,equipmentType,mode,trainMode,calories,duringTime,distance,count,isOffline,startTime,createTime);

@override
String toString() {
  return 'SportHistory(id: $id, userId: $userId, equipmentType: $equipmentType, mode: $mode, trainMode: $trainMode, calories: $calories, duringTime: $duringTime, distance: $distance, count: $count, isOffline: $isOffline, startTime: $startTime, createTime: $createTime)';
}


}

/// @nodoc
abstract mixin class $SportHistoryCopyWith<$Res>  {
  factory $SportHistoryCopyWith(SportHistory value, $Res Function(SportHistory) _then) = _$SportHistoryCopyWithImpl;
@useResult
$Res call({
 int? id, int? userId, int? equipmentType, int? mode, int? trainMode, double? calories, int? duringTime, double? distance, int? count, bool? isOffline, String? startTime, String? createTime
});




}
/// @nodoc
class _$SportHistoryCopyWithImpl<$Res>
    implements $SportHistoryCopyWith<$Res> {
  _$SportHistoryCopyWithImpl(this._self, this._then);

  final SportHistory _self;
  final $Res Function(SportHistory) _then;

/// Create a copy of SportHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? equipmentType = freezed,Object? mode = freezed,Object? trainMode = freezed,Object? calories = freezed,Object? duringTime = freezed,Object? distance = freezed,Object? count = freezed,Object? isOffline = freezed,Object? startTime = freezed,Object? createTime = freezed,}) {
  return _then(SportHistory(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,equipmentType: freezed == equipmentType ? _self.equipmentType : equipmentType // ignore: cast_nullable_to_non_nullable
as int?,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as int?,trainMode: freezed == trainMode ? _self.trainMode : trainMode // ignore: cast_nullable_to_non_nullable
as int?,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double?,duringTime: freezed == duringTime ? _self.duringTime : duringTime // ignore: cast_nullable_to_non_nullable
as int?,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,isOffline: freezed == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SportHistory].
extension SportHistoryPatterns on SportHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SportHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SportHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SportHistory value)  $default,){
final _that = this;
switch (_that) {
case _SportHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SportHistory value)?  $default,){
final _that = this;
switch (_that) {
case _SportHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? userId,  int? equipmentType,  int? mode,  int? trainMode,  double? calories,  int? duringTime,  double? distance,  int? count,  bool? isOffline,  String? startTime,  String? createTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SportHistory() when $default != null:
return $default(_that.id,_that.userId,_that.equipmentType,_that.mode,_that.trainMode,_that.calories,_that.duringTime,_that.distance,_that.count,_that.isOffline,_that.startTime,_that.createTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? userId,  int? equipmentType,  int? mode,  int? trainMode,  double? calories,  int? duringTime,  double? distance,  int? count,  bool? isOffline,  String? startTime,  String? createTime)  $default,) {final _that = this;
switch (_that) {
case _SportHistory():
return $default(_that.id,_that.userId,_that.equipmentType,_that.mode,_that.trainMode,_that.calories,_that.duringTime,_that.distance,_that.count,_that.isOffline,_that.startTime,_that.createTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? userId,  int? equipmentType,  int? mode,  int? trainMode,  double? calories,  int? duringTime,  double? distance,  int? count,  bool? isOffline,  String? startTime,  String? createTime)?  $default,) {final _that = this;
switch (_that) {
case _SportHistory() when $default != null:
return $default(_that.id,_that.userId,_that.equipmentType,_that.mode,_that.trainMode,_that.calories,_that.duringTime,_that.distance,_that.count,_that.isOffline,_that.startTime,_that.createTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SportHistory implements SportHistory {
  const _SportHistory({this.id, this.userId, this.equipmentType, this.mode, this.trainMode, this.calories, this.duringTime, this.distance, this.count, this.isOffline, this.startTime, this.createTime});
  factory _SportHistory.fromJson(Map<String, dynamic> json) => _$SportHistoryFromJson(json);

@override final  int? id;
@override final  int? userId;
@override final  int? equipmentType;
@override final  int? mode;
@override final  int? trainMode;
@override final  double? calories;
@override final  int? duringTime;
@override final  double? distance;
@override final  int? count;
@override final  bool? isOffline;
@override final  String? startTime;
@override final  String? createTime;

/// Create a copy of SportHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SportHistoryCopyWith<_SportHistory> get copyWith => __$SportHistoryCopyWithImpl<_SportHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SportHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SportHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.equipmentType, equipmentType) || other.equipmentType == equipmentType)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.trainMode, trainMode) || other.trainMode == trainMode)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.duringTime, duringTime) || other.duringTime == duringTime)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.count, count) || other.count == count)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.createTime, createTime) || other.createTime == createTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,equipmentType,mode,trainMode,calories,duringTime,distance,count,isOffline,startTime,createTime);

@override
String toString() {
  return 'SportHistory(id: $id, userId: $userId, equipmentType: $equipmentType, mode: $mode, trainMode: $trainMode, calories: $calories, duringTime: $duringTime, distance: $distance, count: $count, isOffline: $isOffline, startTime: $startTime, createTime: $createTime)';
}


}

/// @nodoc
abstract mixin class _$SportHistoryCopyWith<$Res> implements $SportHistoryCopyWith<$Res> {
  factory _$SportHistoryCopyWith(_SportHistory value, $Res Function(_SportHistory) _then) = __$SportHistoryCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? userId, int? equipmentType, int? mode, int? trainMode, double? calories, int? duringTime, double? distance, int? count, bool? isOffline, String? startTime, String? createTime
});




}
/// @nodoc
class __$SportHistoryCopyWithImpl<$Res>
    implements _$SportHistoryCopyWith<$Res> {
  __$SportHistoryCopyWithImpl(this._self, this._then);

  final _SportHistory _self;
  final $Res Function(_SportHistory) _then;

/// Create a copy of SportHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? equipmentType = freezed,Object? mode = freezed,Object? trainMode = freezed,Object? calories = freezed,Object? duringTime = freezed,Object? distance = freezed,Object? count = freezed,Object? isOffline = freezed,Object? startTime = freezed,Object? createTime = freezed,}) {
  return _then(_SportHistory(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,equipmentType: freezed == equipmentType ? _self.equipmentType : equipmentType // ignore: cast_nullable_to_non_nullable
as int?,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as int?,trainMode: freezed == trainMode ? _self.trainMode : trainMode // ignore: cast_nullable_to_non_nullable
as int?,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double?,duringTime: freezed == duringTime ? _self.duringTime : duringTime // ignore: cast_nullable_to_non_nullable
as int?,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,isOffline: freezed == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SportHistoryDto {

 int? get userId; int? get equipmentType; int? get mode; int? get trainMode; double? get calories; int? get duringTime; double? get distance; int? get count; bool? get offline; String? get startTime; int? get timeZone;
/// Create a copy of SportHistoryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SportHistoryDtoCopyWith<SportHistoryDto> get copyWith => _$SportHistoryDtoCopyWithImpl<SportHistoryDto>(this as SportHistoryDto, _$identity);

  /// Serializes this SportHistoryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SportHistoryDto&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.equipmentType, equipmentType) || other.equipmentType == equipmentType)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.trainMode, trainMode) || other.trainMode == trainMode)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.duringTime, duringTime) || other.duringTime == duringTime)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.count, count) || other.count == count)&&(identical(other.offline, offline) || other.offline == offline)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.timeZone, timeZone) || other.timeZone == timeZone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,equipmentType,mode,trainMode,calories,duringTime,distance,count,offline,startTime,timeZone);

@override
String toString() {
  return 'SportHistoryDto(userId: $userId, equipmentType: $equipmentType, mode: $mode, trainMode: $trainMode, calories: $calories, duringTime: $duringTime, distance: $distance, count: $count, offline: $offline, startTime: $startTime, timeZone: $timeZone)';
}


}

/// @nodoc
abstract mixin class $SportHistoryDtoCopyWith<$Res>  {
  factory $SportHistoryDtoCopyWith(SportHistoryDto value, $Res Function(SportHistoryDto) _then) = _$SportHistoryDtoCopyWithImpl;
@useResult
$Res call({
 int? userId, int? equipmentType, int? mode, int? trainMode, double? calories, int? duringTime, double? distance, int? count, bool? offline, String? startTime, int? timeZone
});




}
/// @nodoc
class _$SportHistoryDtoCopyWithImpl<$Res>
    implements $SportHistoryDtoCopyWith<$Res> {
  _$SportHistoryDtoCopyWithImpl(this._self, this._then);

  final SportHistoryDto _self;
  final $Res Function(SportHistoryDto) _then;

/// Create a copy of SportHistoryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = freezed,Object? equipmentType = freezed,Object? mode = freezed,Object? trainMode = freezed,Object? calories = freezed,Object? duringTime = freezed,Object? distance = freezed,Object? count = freezed,Object? offline = freezed,Object? startTime = freezed,Object? timeZone = freezed,}) {
  return _then(SportHistoryDto(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,equipmentType: freezed == equipmentType ? _self.equipmentType : equipmentType // ignore: cast_nullable_to_non_nullable
as int?,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as int?,trainMode: freezed == trainMode ? _self.trainMode : trainMode // ignore: cast_nullable_to_non_nullable
as int?,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double?,duringTime: freezed == duringTime ? _self.duringTime : duringTime // ignore: cast_nullable_to_non_nullable
as int?,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,offline: freezed == offline ? _self.offline : offline // ignore: cast_nullable_to_non_nullable
as bool?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,timeZone: freezed == timeZone ? _self.timeZone : timeZone // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SportHistoryDto].
extension SportHistoryDtoPatterns on SportHistoryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SportHistoryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SportHistoryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SportHistoryDto value)  $default,){
final _that = this;
switch (_that) {
case _SportHistoryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SportHistoryDto value)?  $default,){
final _that = this;
switch (_that) {
case _SportHistoryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? userId,  int? equipmentType,  int? mode,  int? trainMode,  double? calories,  int? duringTime,  double? distance,  int? count,  bool? offline,  String? startTime,  int? timeZone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SportHistoryDto() when $default != null:
return $default(_that.userId,_that.equipmentType,_that.mode,_that.trainMode,_that.calories,_that.duringTime,_that.distance,_that.count,_that.offline,_that.startTime,_that.timeZone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? userId,  int? equipmentType,  int? mode,  int? trainMode,  double? calories,  int? duringTime,  double? distance,  int? count,  bool? offline,  String? startTime,  int? timeZone)  $default,) {final _that = this;
switch (_that) {
case _SportHistoryDto():
return $default(_that.userId,_that.equipmentType,_that.mode,_that.trainMode,_that.calories,_that.duringTime,_that.distance,_that.count,_that.offline,_that.startTime,_that.timeZone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? userId,  int? equipmentType,  int? mode,  int? trainMode,  double? calories,  int? duringTime,  double? distance,  int? count,  bool? offline,  String? startTime,  int? timeZone)?  $default,) {final _that = this;
switch (_that) {
case _SportHistoryDto() when $default != null:
return $default(_that.userId,_that.equipmentType,_that.mode,_that.trainMode,_that.calories,_that.duringTime,_that.distance,_that.count,_that.offline,_that.startTime,_that.timeZone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SportHistoryDto implements SportHistoryDto {
  const _SportHistoryDto({this.userId, this.equipmentType, this.mode, this.trainMode, this.calories, this.duringTime, this.distance, this.count, this.offline, this.startTime, this.timeZone});
  factory _SportHistoryDto.fromJson(Map<String, dynamic> json) => _$SportHistoryDtoFromJson(json);

@override final  int? userId;
@override final  int? equipmentType;
@override final  int? mode;
@override final  int? trainMode;
@override final  double? calories;
@override final  int? duringTime;
@override final  double? distance;
@override final  int? count;
@override final  bool? offline;
@override final  String? startTime;
@override final  int? timeZone;

/// Create a copy of SportHistoryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SportHistoryDtoCopyWith<_SportHistoryDto> get copyWith => __$SportHistoryDtoCopyWithImpl<_SportHistoryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SportHistoryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SportHistoryDto&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.equipmentType, equipmentType) || other.equipmentType == equipmentType)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.trainMode, trainMode) || other.trainMode == trainMode)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.duringTime, duringTime) || other.duringTime == duringTime)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.count, count) || other.count == count)&&(identical(other.offline, offline) || other.offline == offline)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.timeZone, timeZone) || other.timeZone == timeZone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,equipmentType,mode,trainMode,calories,duringTime,distance,count,offline,startTime,timeZone);

@override
String toString() {
  return 'SportHistoryDto(userId: $userId, equipmentType: $equipmentType, mode: $mode, trainMode: $trainMode, calories: $calories, duringTime: $duringTime, distance: $distance, count: $count, offline: $offline, startTime: $startTime, timeZone: $timeZone)';
}


}

/// @nodoc
abstract mixin class _$SportHistoryDtoCopyWith<$Res> implements $SportHistoryDtoCopyWith<$Res> {
  factory _$SportHistoryDtoCopyWith(_SportHistoryDto value, $Res Function(_SportHistoryDto) _then) = __$SportHistoryDtoCopyWithImpl;
@override @useResult
$Res call({
 int? userId, int? equipmentType, int? mode, int? trainMode, double? calories, int? duringTime, double? distance, int? count, bool? offline, String? startTime, int? timeZone
});




}
/// @nodoc
class __$SportHistoryDtoCopyWithImpl<$Res>
    implements _$SportHistoryDtoCopyWith<$Res> {
  __$SportHistoryDtoCopyWithImpl(this._self, this._then);

  final _SportHistoryDto _self;
  final $Res Function(_SportHistoryDto) _then;

/// Create a copy of SportHistoryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = freezed,Object? equipmentType = freezed,Object? mode = freezed,Object? trainMode = freezed,Object? calories = freezed,Object? duringTime = freezed,Object? distance = freezed,Object? count = freezed,Object? offline = freezed,Object? startTime = freezed,Object? timeZone = freezed,}) {
  return _then(_SportHistoryDto(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,equipmentType: freezed == equipmentType ? _self.equipmentType : equipmentType // ignore: cast_nullable_to_non_nullable
as int?,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as int?,trainMode: freezed == trainMode ? _self.trainMode : trainMode // ignore: cast_nullable_to_non_nullable
as int?,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double?,duringTime: freezed == duringTime ? _self.duringTime : duringTime // ignore: cast_nullable_to_non_nullable
as int?,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,offline: freezed == offline ? _self.offline : offline // ignore: cast_nullable_to_non_nullable
as bool?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,timeZone: freezed == timeZone ? _self.timeZone : timeZone // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
