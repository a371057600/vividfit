// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sport_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SportRecord {

/// 记录唯一 ID（时间戳+随机数生成）
 String get id;/// 用户 ID
 int get userId;/// 设备类型（对应 FtmsDeviceType.value）
 int get deviceType;/// 运动模式（课程 ID 或自定义模式）
 int? get mode;/// 训练模式（0=自由训练, 1=课程）
 int? get trainMode;/// 开始时间
 DateTime get startTime;/// 结束时间
 DateTime get endTime;/// 运动时长（秒）
 int get duration;/// 累计距离（km）
 double get distance;/// 累计卡路里（kcal）
 double get calories;/// 平均速度（km/h）
 double? get avgSpeed;/// 最大速度（km/h）
 double? get maxSpeed;/// 平均踏频（rpm）
 int? get avgCadence;/// 最大踏频（rpm）
 int? get maxCadence;/// 平均心率（bpm）
 int? get avgHeartRate;/// 最大心率（bpm）
 int? get maxHeartRate;/// 平均功率（W）
 double? get avgPower;/// 最大功率（W）
 double? get maxPower;/// 平均阻力
 double? get avgResistance;/// 平均坡度（%）
 double? get avgInclination;/// 总桨数（划船机）
 int? get totalStrokes;/// 平均桨频（spm）
 double? get avgStrokeRate;/// 课程完成度（%）
 double? get finishPercent;/// 速度采样序列（供图表绘制，每隔 2-3s 采样一次）
 List<double>? get speedSamples;/// 是否为离线记录（预留服务端同步）
 bool get isOffline;/// 是否已同步到服务端（预留）
 bool get isSynced;
/// Create a copy of SportRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SportRecordCopyWith<SportRecord> get copyWith => _$SportRecordCopyWithImpl<SportRecord>(this as SportRecord, _$identity);

  /// Serializes this SportRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SportRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.trainMode, trainMode) || other.trainMode == trainMode)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.avgSpeed, avgSpeed) || other.avgSpeed == avgSpeed)&&(identical(other.maxSpeed, maxSpeed) || other.maxSpeed == maxSpeed)&&(identical(other.avgCadence, avgCadence) || other.avgCadence == avgCadence)&&(identical(other.maxCadence, maxCadence) || other.maxCadence == maxCadence)&&(identical(other.avgHeartRate, avgHeartRate) || other.avgHeartRate == avgHeartRate)&&(identical(other.maxHeartRate, maxHeartRate) || other.maxHeartRate == maxHeartRate)&&(identical(other.avgPower, avgPower) || other.avgPower == avgPower)&&(identical(other.maxPower, maxPower) || other.maxPower == maxPower)&&(identical(other.avgResistance, avgResistance) || other.avgResistance == avgResistance)&&(identical(other.avgInclination, avgInclination) || other.avgInclination == avgInclination)&&(identical(other.totalStrokes, totalStrokes) || other.totalStrokes == totalStrokes)&&(identical(other.avgStrokeRate, avgStrokeRate) || other.avgStrokeRate == avgStrokeRate)&&(identical(other.finishPercent, finishPercent) || other.finishPercent == finishPercent)&&const DeepCollectionEquality().equals(other.speedSamples, speedSamples)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.isSynced, isSynced) || other.isSynced == isSynced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,deviceType,mode,trainMode,startTime,endTime,duration,distance,calories,avgSpeed,maxSpeed,avgCadence,maxCadence,avgHeartRate,maxHeartRate,avgPower,maxPower,avgResistance,avgInclination,totalStrokes,avgStrokeRate,finishPercent,const DeepCollectionEquality().hash(speedSamples),isOffline,isSynced]);

@override
String toString() {
  return 'SportRecord(id: $id, userId: $userId, deviceType: $deviceType, mode: $mode, trainMode: $trainMode, startTime: $startTime, endTime: $endTime, duration: $duration, distance: $distance, calories: $calories, avgSpeed: $avgSpeed, maxSpeed: $maxSpeed, avgCadence: $avgCadence, maxCadence: $maxCadence, avgHeartRate: $avgHeartRate, maxHeartRate: $maxHeartRate, avgPower: $avgPower, maxPower: $maxPower, avgResistance: $avgResistance, avgInclination: $avgInclination, totalStrokes: $totalStrokes, avgStrokeRate: $avgStrokeRate, finishPercent: $finishPercent, speedSamples: $speedSamples, isOffline: $isOffline, isSynced: $isSynced)';
}


}

/// @nodoc
abstract mixin class $SportRecordCopyWith<$Res>  {
  factory $SportRecordCopyWith(SportRecord value, $Res Function(SportRecord) _then) = _$SportRecordCopyWithImpl;
@useResult
$Res call({
 String id, int userId, int deviceType, int? mode, int? trainMode, DateTime startTime, DateTime endTime, int duration, double distance, double calories, double? avgSpeed, double? maxSpeed, int? avgCadence, int? maxCadence, int? avgHeartRate, int? maxHeartRate, double? avgPower, double? maxPower, double? avgResistance, double? avgInclination, int? totalStrokes, double? avgStrokeRate, double? finishPercent, List<double>? speedSamples, bool isOffline, bool isSynced
});




}
/// @nodoc
class _$SportRecordCopyWithImpl<$Res>
    implements $SportRecordCopyWith<$Res> {
  _$SportRecordCopyWithImpl(this._self, this._then);

  final SportRecord _self;
  final $Res Function(SportRecord) _then;

/// Create a copy of SportRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? deviceType = null,Object? mode = freezed,Object? trainMode = freezed,Object? startTime = null,Object? endTime = null,Object? duration = null,Object? distance = null,Object? calories = null,Object? avgSpeed = freezed,Object? maxSpeed = freezed,Object? avgCadence = freezed,Object? maxCadence = freezed,Object? avgHeartRate = freezed,Object? maxHeartRate = freezed,Object? avgPower = freezed,Object? maxPower = freezed,Object? avgResistance = freezed,Object? avgInclination = freezed,Object? totalStrokes = freezed,Object? avgStrokeRate = freezed,Object? finishPercent = freezed,Object? speedSamples = freezed,Object? isOffline = null,Object? isSynced = null,}) {
  return _then(SportRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as int,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as int?,trainMode: freezed == trainMode ? _self.trainMode : trainMode // ignore: cast_nullable_to_non_nullable
as int?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double,avgSpeed: freezed == avgSpeed ? _self.avgSpeed : avgSpeed // ignore: cast_nullable_to_non_nullable
as double?,maxSpeed: freezed == maxSpeed ? _self.maxSpeed : maxSpeed // ignore: cast_nullable_to_non_nullable
as double?,avgCadence: freezed == avgCadence ? _self.avgCadence : avgCadence // ignore: cast_nullable_to_non_nullable
as int?,maxCadence: freezed == maxCadence ? _self.maxCadence : maxCadence // ignore: cast_nullable_to_non_nullable
as int?,avgHeartRate: freezed == avgHeartRate ? _self.avgHeartRate : avgHeartRate // ignore: cast_nullable_to_non_nullable
as int?,maxHeartRate: freezed == maxHeartRate ? _self.maxHeartRate : maxHeartRate // ignore: cast_nullable_to_non_nullable
as int?,avgPower: freezed == avgPower ? _self.avgPower : avgPower // ignore: cast_nullable_to_non_nullable
as double?,maxPower: freezed == maxPower ? _self.maxPower : maxPower // ignore: cast_nullable_to_non_nullable
as double?,avgResistance: freezed == avgResistance ? _self.avgResistance : avgResistance // ignore: cast_nullable_to_non_nullable
as double?,avgInclination: freezed == avgInclination ? _self.avgInclination : avgInclination // ignore: cast_nullable_to_non_nullable
as double?,totalStrokes: freezed == totalStrokes ? _self.totalStrokes : totalStrokes // ignore: cast_nullable_to_non_nullable
as int?,avgStrokeRate: freezed == avgStrokeRate ? _self.avgStrokeRate : avgStrokeRate // ignore: cast_nullable_to_non_nullable
as double?,finishPercent: freezed == finishPercent ? _self.finishPercent : finishPercent // ignore: cast_nullable_to_non_nullable
as double?,speedSamples: freezed == speedSamples ? _self.speedSamples : speedSamples // ignore: cast_nullable_to_non_nullable
as List<double>?,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,isSynced: null == isSynced ? _self.isSynced : isSynced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SportRecord].
extension SportRecordPatterns on SportRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SportRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SportRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SportRecord value)  $default,){
final _that = this;
switch (_that) {
case _SportRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SportRecord value)?  $default,){
final _that = this;
switch (_that) {
case _SportRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int userId,  int deviceType,  int? mode,  int? trainMode,  DateTime startTime,  DateTime endTime,  int duration,  double distance,  double calories,  double? avgSpeed,  double? maxSpeed,  int? avgCadence,  int? maxCadence,  int? avgHeartRate,  int? maxHeartRate,  double? avgPower,  double? maxPower,  double? avgResistance,  double? avgInclination,  int? totalStrokes,  double? avgStrokeRate,  double? finishPercent,  List<double>? speedSamples,  bool isOffline,  bool isSynced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SportRecord() when $default != null:
return $default(_that.id,_that.userId,_that.deviceType,_that.mode,_that.trainMode,_that.startTime,_that.endTime,_that.duration,_that.distance,_that.calories,_that.avgSpeed,_that.maxSpeed,_that.avgCadence,_that.maxCadence,_that.avgHeartRate,_that.maxHeartRate,_that.avgPower,_that.maxPower,_that.avgResistance,_that.avgInclination,_that.totalStrokes,_that.avgStrokeRate,_that.finishPercent,_that.speedSamples,_that.isOffline,_that.isSynced);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int userId,  int deviceType,  int? mode,  int? trainMode,  DateTime startTime,  DateTime endTime,  int duration,  double distance,  double calories,  double? avgSpeed,  double? maxSpeed,  int? avgCadence,  int? maxCadence,  int? avgHeartRate,  int? maxHeartRate,  double? avgPower,  double? maxPower,  double? avgResistance,  double? avgInclination,  int? totalStrokes,  double? avgStrokeRate,  double? finishPercent,  List<double>? speedSamples,  bool isOffline,  bool isSynced)  $default,) {final _that = this;
switch (_that) {
case _SportRecord():
return $default(_that.id,_that.userId,_that.deviceType,_that.mode,_that.trainMode,_that.startTime,_that.endTime,_that.duration,_that.distance,_that.calories,_that.avgSpeed,_that.maxSpeed,_that.avgCadence,_that.maxCadence,_that.avgHeartRate,_that.maxHeartRate,_that.avgPower,_that.maxPower,_that.avgResistance,_that.avgInclination,_that.totalStrokes,_that.avgStrokeRate,_that.finishPercent,_that.speedSamples,_that.isOffline,_that.isSynced);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int userId,  int deviceType,  int? mode,  int? trainMode,  DateTime startTime,  DateTime endTime,  int duration,  double distance,  double calories,  double? avgSpeed,  double? maxSpeed,  int? avgCadence,  int? maxCadence,  int? avgHeartRate,  int? maxHeartRate,  double? avgPower,  double? maxPower,  double? avgResistance,  double? avgInclination,  int? totalStrokes,  double? avgStrokeRate,  double? finishPercent,  List<double>? speedSamples,  bool isOffline,  bool isSynced)?  $default,) {final _that = this;
switch (_that) {
case _SportRecord() when $default != null:
return $default(_that.id,_that.userId,_that.deviceType,_that.mode,_that.trainMode,_that.startTime,_that.endTime,_that.duration,_that.distance,_that.calories,_that.avgSpeed,_that.maxSpeed,_that.avgCadence,_that.maxCadence,_that.avgHeartRate,_that.maxHeartRate,_that.avgPower,_that.maxPower,_that.avgResistance,_that.avgInclination,_that.totalStrokes,_that.avgStrokeRate,_that.finishPercent,_that.speedSamples,_that.isOffline,_that.isSynced);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SportRecord implements SportRecord {
  const _SportRecord({required this.id, required this.userId, required this.deviceType, this.mode, this.trainMode, required this.startTime, required this.endTime, required this.duration, required this.distance, required this.calories, this.avgSpeed, this.maxSpeed, this.avgCadence, this.maxCadence, this.avgHeartRate, this.maxHeartRate, this.avgPower, this.maxPower, this.avgResistance, this.avgInclination, this.totalStrokes, this.avgStrokeRate, this.finishPercent,  List<double>? speedSamples, this.isOffline = false, this.isSynced = false}): _speedSamples = speedSamples;
  factory _SportRecord.fromJson(Map<String, dynamic> json) => _$SportRecordFromJson(json);

/// 记录唯一 ID（时间戳+随机数生成）
@override final  String id;
/// 用户 ID
@override final  int userId;
/// 设备类型（对应 FtmsDeviceType.value）
@override final  int deviceType;
/// 运动模式（课程 ID 或自定义模式）
@override final  int? mode;
/// 训练模式（0=自由训练, 1=课程）
@override final  int? trainMode;
/// 开始时间
@override final  DateTime startTime;
/// 结束时间
@override final  DateTime endTime;
/// 运动时长（秒）
@override final  int duration;
/// 累计距离（km）
@override final  double distance;
/// 累计卡路里（kcal）
@override final  double calories;
/// 平均速度（km/h）
@override final  double? avgSpeed;
/// 最大速度（km/h）
@override final  double? maxSpeed;
/// 平均踏频（rpm）
@override final  int? avgCadence;
/// 最大踏频（rpm）
@override final  int? maxCadence;
/// 平均心率（bpm）
@override final  int? avgHeartRate;
/// 最大心率（bpm）
@override final  int? maxHeartRate;
/// 平均功率（W）
@override final  double? avgPower;
/// 最大功率（W）
@override final  double? maxPower;
/// 平均阻力
@override final  double? avgResistance;
/// 平均坡度（%）
@override final  double? avgInclination;
/// 总桨数（划船机）
@override final  int? totalStrokes;
/// 平均桨频（spm）
@override final  double? avgStrokeRate;
/// 课程完成度（%）
@override final  double? finishPercent;
/// 速度采样序列（供图表绘制，每隔 2-3s 采样一次）
 final  List<double>? _speedSamples;
/// 速度采样序列（供图表绘制，每隔 2-3s 采样一次）
@override List<double>? get speedSamples {
  final value = _speedSamples;
  if (value == null) return null;
  if (_speedSamples is EqualUnmodifiableListView) return _speedSamples;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// 是否为离线记录（预留服务端同步）
@override@JsonKey() final  bool isOffline;
/// 是否已同步到服务端（预留）
@override@JsonKey() final  bool isSynced;

/// Create a copy of SportRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SportRecordCopyWith<_SportRecord> get copyWith => __$SportRecordCopyWithImpl<_SportRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SportRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SportRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.trainMode, trainMode) || other.trainMode == trainMode)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.avgSpeed, avgSpeed) || other.avgSpeed == avgSpeed)&&(identical(other.maxSpeed, maxSpeed) || other.maxSpeed == maxSpeed)&&(identical(other.avgCadence, avgCadence) || other.avgCadence == avgCadence)&&(identical(other.maxCadence, maxCadence) || other.maxCadence == maxCadence)&&(identical(other.avgHeartRate, avgHeartRate) || other.avgHeartRate == avgHeartRate)&&(identical(other.maxHeartRate, maxHeartRate) || other.maxHeartRate == maxHeartRate)&&(identical(other.avgPower, avgPower) || other.avgPower == avgPower)&&(identical(other.maxPower, maxPower) || other.maxPower == maxPower)&&(identical(other.avgResistance, avgResistance) || other.avgResistance == avgResistance)&&(identical(other.avgInclination, avgInclination) || other.avgInclination == avgInclination)&&(identical(other.totalStrokes, totalStrokes) || other.totalStrokes == totalStrokes)&&(identical(other.avgStrokeRate, avgStrokeRate) || other.avgStrokeRate == avgStrokeRate)&&(identical(other.finishPercent, finishPercent) || other.finishPercent == finishPercent)&&const DeepCollectionEquality().equals(other._speedSamples, _speedSamples)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.isSynced, isSynced) || other.isSynced == isSynced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,deviceType,mode,trainMode,startTime,endTime,duration,distance,calories,avgSpeed,maxSpeed,avgCadence,maxCadence,avgHeartRate,maxHeartRate,avgPower,maxPower,avgResistance,avgInclination,totalStrokes,avgStrokeRate,finishPercent,const DeepCollectionEquality().hash(_speedSamples),isOffline,isSynced]);

@override
String toString() {
  return 'SportRecord(id: $id, userId: $userId, deviceType: $deviceType, mode: $mode, trainMode: $trainMode, startTime: $startTime, endTime: $endTime, duration: $duration, distance: $distance, calories: $calories, avgSpeed: $avgSpeed, maxSpeed: $maxSpeed, avgCadence: $avgCadence, maxCadence: $maxCadence, avgHeartRate: $avgHeartRate, maxHeartRate: $maxHeartRate, avgPower: $avgPower, maxPower: $maxPower, avgResistance: $avgResistance, avgInclination: $avgInclination, totalStrokes: $totalStrokes, avgStrokeRate: $avgStrokeRate, finishPercent: $finishPercent, speedSamples: $speedSamples, isOffline: $isOffline, isSynced: $isSynced)';
}


}

/// @nodoc
abstract mixin class _$SportRecordCopyWith<$Res> implements $SportRecordCopyWith<$Res> {
  factory _$SportRecordCopyWith(_SportRecord value, $Res Function(_SportRecord) _then) = __$SportRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, int userId, int deviceType, int? mode, int? trainMode, DateTime startTime, DateTime endTime, int duration, double distance, double calories, double? avgSpeed, double? maxSpeed, int? avgCadence, int? maxCadence, int? avgHeartRate, int? maxHeartRate, double? avgPower, double? maxPower, double? avgResistance, double? avgInclination, int? totalStrokes, double? avgStrokeRate, double? finishPercent, List<double>? speedSamples, bool isOffline, bool isSynced
});




}
/// @nodoc
class __$SportRecordCopyWithImpl<$Res>
    implements _$SportRecordCopyWith<$Res> {
  __$SportRecordCopyWithImpl(this._self, this._then);

  final _SportRecord _self;
  final $Res Function(_SportRecord) _then;

/// Create a copy of SportRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? deviceType = null,Object? mode = freezed,Object? trainMode = freezed,Object? startTime = null,Object? endTime = null,Object? duration = null,Object? distance = null,Object? calories = null,Object? avgSpeed = freezed,Object? maxSpeed = freezed,Object? avgCadence = freezed,Object? maxCadence = freezed,Object? avgHeartRate = freezed,Object? maxHeartRate = freezed,Object? avgPower = freezed,Object? maxPower = freezed,Object? avgResistance = freezed,Object? avgInclination = freezed,Object? totalStrokes = freezed,Object? avgStrokeRate = freezed,Object? finishPercent = freezed,Object? speedSamples = freezed,Object? isOffline = null,Object? isSynced = null,}) {
  return _then(_SportRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as int,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as int?,trainMode: freezed == trainMode ? _self.trainMode : trainMode // ignore: cast_nullable_to_non_nullable
as int?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double,avgSpeed: freezed == avgSpeed ? _self.avgSpeed : avgSpeed // ignore: cast_nullable_to_non_nullable
as double?,maxSpeed: freezed == maxSpeed ? _self.maxSpeed : maxSpeed // ignore: cast_nullable_to_non_nullable
as double?,avgCadence: freezed == avgCadence ? _self.avgCadence : avgCadence // ignore: cast_nullable_to_non_nullable
as int?,maxCadence: freezed == maxCadence ? _self.maxCadence : maxCadence // ignore: cast_nullable_to_non_nullable
as int?,avgHeartRate: freezed == avgHeartRate ? _self.avgHeartRate : avgHeartRate // ignore: cast_nullable_to_non_nullable
as int?,maxHeartRate: freezed == maxHeartRate ? _self.maxHeartRate : maxHeartRate // ignore: cast_nullable_to_non_nullable
as int?,avgPower: freezed == avgPower ? _self.avgPower : avgPower // ignore: cast_nullable_to_non_nullable
as double?,maxPower: freezed == maxPower ? _self.maxPower : maxPower // ignore: cast_nullable_to_non_nullable
as double?,avgResistance: freezed == avgResistance ? _self.avgResistance : avgResistance // ignore: cast_nullable_to_non_nullable
as double?,avgInclination: freezed == avgInclination ? _self.avgInclination : avgInclination // ignore: cast_nullable_to_non_nullable
as double?,totalStrokes: freezed == totalStrokes ? _self.totalStrokes : totalStrokes // ignore: cast_nullable_to_non_nullable
as int?,avgStrokeRate: freezed == avgStrokeRate ? _self.avgStrokeRate : avgStrokeRate // ignore: cast_nullable_to_non_nullable
as double?,finishPercent: freezed == finishPercent ? _self.finishPercent : finishPercent // ignore: cast_nullable_to_non_nullable
as double?,speedSamples: freezed == speedSamples ? _self._speedSamples : speedSamples // ignore: cast_nullable_to_non_nullable
as List<double>?,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,isSynced: null == isSynced ? _self.isSynced : isSynced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
