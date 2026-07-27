// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ftms_device_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FtmsDeviceData {

// ---- 通用速度/距离 ----
 double? get instSpeed;// 瞬时速度(km/h)
 double? get avgSpeed;// 平均速度(km/h)
 int? get distTotal;// 总距离(米)
// ---- 踏频/步频/桨频 ----
 double? get instCadence;// 瞬时踏频(rpm,单车/椭圆机)
 double? get avgCadence;// 平均踏频(rpm)
 int? get stepsPerMin;// 步频(椭圆机)
 int? get avgStepRate;// 平均步频(椭圆机)
 int? get strideCountTotal;// 总步数(椭圆机)
 double? get strokesPerMin;// 桨频(spm,划船机)
 int? get strokeCountTotal;// 总桨次(划船机)
 double? get avgStrokeRate;// 平均桨频(spm)
// ---- 阻力/坡度/功率 ----
 double? get resistanceLvl;// 阻力等级
 double? get inclineAngle;// 坡度(百分比)
 double? get rampAngle;// 坡度角度(度)
 int? get elevationGainPos;// 正海拔增益(米)
 int? get elevationGainNeg;// 负海拔增益(米)
 int? get instPower;// 瞬时功率(瓦)
 int? get avgPower;// 平均功率(瓦)
 int? get forceOnBelt;// 皮带受力(牛,跑步机)
// ---- 能耗/心率/代谢 ----
 int? get energyTotal;// 总能耗(千卡)
 int? get energyPerHr;// 每小时能耗(千卡)
 int? get energyPerMin;// 每分钟能耗(千卡)
 int? get hr;// 心率(bpm)
 double? get met;// 代谢当量
// ---- 时间 ----
 int? get timeElapsed;// 已运动时长(秒)
 int? get timeRemaining;// 剩余时间(秒)
// ---- 配速 ----
 double? get instPace;// 瞬时配速
 double? get avgPace;// 平均配速
// ---- 椭圆机特有 ----
 int? get movementDirection;// 运动方向(0=向前/1=向后)
// ---- 设备状态 ----
 int get machineState;
/// Create a copy of FtmsDeviceData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FtmsDeviceDataCopyWith<FtmsDeviceData> get copyWith => _$FtmsDeviceDataCopyWithImpl<FtmsDeviceData>(this as FtmsDeviceData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FtmsDeviceData&&(identical(other.instSpeed, instSpeed) || other.instSpeed == instSpeed)&&(identical(other.avgSpeed, avgSpeed) || other.avgSpeed == avgSpeed)&&(identical(other.distTotal, distTotal) || other.distTotal == distTotal)&&(identical(other.instCadence, instCadence) || other.instCadence == instCadence)&&(identical(other.avgCadence, avgCadence) || other.avgCadence == avgCadence)&&(identical(other.stepsPerMin, stepsPerMin) || other.stepsPerMin == stepsPerMin)&&(identical(other.avgStepRate, avgStepRate) || other.avgStepRate == avgStepRate)&&(identical(other.strideCountTotal, strideCountTotal) || other.strideCountTotal == strideCountTotal)&&(identical(other.strokesPerMin, strokesPerMin) || other.strokesPerMin == strokesPerMin)&&(identical(other.strokeCountTotal, strokeCountTotal) || other.strokeCountTotal == strokeCountTotal)&&(identical(other.avgStrokeRate, avgStrokeRate) || other.avgStrokeRate == avgStrokeRate)&&(identical(other.resistanceLvl, resistanceLvl) || other.resistanceLvl == resistanceLvl)&&(identical(other.inclineAngle, inclineAngle) || other.inclineAngle == inclineAngle)&&(identical(other.rampAngle, rampAngle) || other.rampAngle == rampAngle)&&(identical(other.elevationGainPos, elevationGainPos) || other.elevationGainPos == elevationGainPos)&&(identical(other.elevationGainNeg, elevationGainNeg) || other.elevationGainNeg == elevationGainNeg)&&(identical(other.instPower, instPower) || other.instPower == instPower)&&(identical(other.avgPower, avgPower) || other.avgPower == avgPower)&&(identical(other.forceOnBelt, forceOnBelt) || other.forceOnBelt == forceOnBelt)&&(identical(other.energyTotal, energyTotal) || other.energyTotal == energyTotal)&&(identical(other.energyPerHr, energyPerHr) || other.energyPerHr == energyPerHr)&&(identical(other.energyPerMin, energyPerMin) || other.energyPerMin == energyPerMin)&&(identical(other.hr, hr) || other.hr == hr)&&(identical(other.met, met) || other.met == met)&&(identical(other.timeElapsed, timeElapsed) || other.timeElapsed == timeElapsed)&&(identical(other.timeRemaining, timeRemaining) || other.timeRemaining == timeRemaining)&&(identical(other.instPace, instPace) || other.instPace == instPace)&&(identical(other.avgPace, avgPace) || other.avgPace == avgPace)&&(identical(other.movementDirection, movementDirection) || other.movementDirection == movementDirection)&&(identical(other.machineState, machineState) || other.machineState == machineState));
}


@override
int get hashCode => Object.hashAll([runtimeType,instSpeed,avgSpeed,distTotal,instCadence,avgCadence,stepsPerMin,avgStepRate,strideCountTotal,strokesPerMin,strokeCountTotal,avgStrokeRate,resistanceLvl,inclineAngle,rampAngle,elevationGainPos,elevationGainNeg,instPower,avgPower,forceOnBelt,energyTotal,energyPerHr,energyPerMin,hr,met,timeElapsed,timeRemaining,instPace,avgPace,movementDirection,machineState]);

@override
String toString() {
  return 'FtmsDeviceData(instSpeed: $instSpeed, avgSpeed: $avgSpeed, distTotal: $distTotal, instCadence: $instCadence, avgCadence: $avgCadence, stepsPerMin: $stepsPerMin, avgStepRate: $avgStepRate, strideCountTotal: $strideCountTotal, strokesPerMin: $strokesPerMin, strokeCountTotal: $strokeCountTotal, avgStrokeRate: $avgStrokeRate, resistanceLvl: $resistanceLvl, inclineAngle: $inclineAngle, rampAngle: $rampAngle, elevationGainPos: $elevationGainPos, elevationGainNeg: $elevationGainNeg, instPower: $instPower, avgPower: $avgPower, forceOnBelt: $forceOnBelt, energyTotal: $energyTotal, energyPerHr: $energyPerHr, energyPerMin: $energyPerMin, hr: $hr, met: $met, timeElapsed: $timeElapsed, timeRemaining: $timeRemaining, instPace: $instPace, avgPace: $avgPace, movementDirection: $movementDirection, machineState: $machineState)';
}


}

/// @nodoc
abstract mixin class $FtmsDeviceDataCopyWith<$Res>  {
  factory $FtmsDeviceDataCopyWith(FtmsDeviceData value, $Res Function(FtmsDeviceData) _then) = _$FtmsDeviceDataCopyWithImpl;
@useResult
$Res call({
 double? instSpeed, double? avgSpeed, int? distTotal, double? instCadence, double? avgCadence, int? stepsPerMin, int? avgStepRate, int? strideCountTotal, double? strokesPerMin, int? strokeCountTotal, double? avgStrokeRate, double? resistanceLvl, double? inclineAngle, double? rampAngle, int? elevationGainPos, int? elevationGainNeg, int? instPower, int? avgPower, int? forceOnBelt, int? energyTotal, int? energyPerHr, int? energyPerMin, int? hr, double? met, int? timeElapsed, int? timeRemaining, double? instPace, double? avgPace, int? movementDirection, int machineState
});




}
/// @nodoc
class _$FtmsDeviceDataCopyWithImpl<$Res>
    implements $FtmsDeviceDataCopyWith<$Res> {
  _$FtmsDeviceDataCopyWithImpl(this._self, this._then);

  final FtmsDeviceData _self;
  final $Res Function(FtmsDeviceData) _then;

/// Create a copy of FtmsDeviceData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? instSpeed = freezed,Object? avgSpeed = freezed,Object? distTotal = freezed,Object? instCadence = freezed,Object? avgCadence = freezed,Object? stepsPerMin = freezed,Object? avgStepRate = freezed,Object? strideCountTotal = freezed,Object? strokesPerMin = freezed,Object? strokeCountTotal = freezed,Object? avgStrokeRate = freezed,Object? resistanceLvl = freezed,Object? inclineAngle = freezed,Object? rampAngle = freezed,Object? elevationGainPos = freezed,Object? elevationGainNeg = freezed,Object? instPower = freezed,Object? avgPower = freezed,Object? forceOnBelt = freezed,Object? energyTotal = freezed,Object? energyPerHr = freezed,Object? energyPerMin = freezed,Object? hr = freezed,Object? met = freezed,Object? timeElapsed = freezed,Object? timeRemaining = freezed,Object? instPace = freezed,Object? avgPace = freezed,Object? movementDirection = freezed,Object? machineState = null,}) {
  return _then(_self.copyWith(
instSpeed: freezed == instSpeed ? _self.instSpeed : instSpeed // ignore: cast_nullable_to_non_nullable
as double?,avgSpeed: freezed == avgSpeed ? _self.avgSpeed : avgSpeed // ignore: cast_nullable_to_non_nullable
as double?,distTotal: freezed == distTotal ? _self.distTotal : distTotal // ignore: cast_nullable_to_non_nullable
as int?,instCadence: freezed == instCadence ? _self.instCadence : instCadence // ignore: cast_nullable_to_non_nullable
as double?,avgCadence: freezed == avgCadence ? _self.avgCadence : avgCadence // ignore: cast_nullable_to_non_nullable
as double?,stepsPerMin: freezed == stepsPerMin ? _self.stepsPerMin : stepsPerMin // ignore: cast_nullable_to_non_nullable
as int?,avgStepRate: freezed == avgStepRate ? _self.avgStepRate : avgStepRate // ignore: cast_nullable_to_non_nullable
as int?,strideCountTotal: freezed == strideCountTotal ? _self.strideCountTotal : strideCountTotal // ignore: cast_nullable_to_non_nullable
as int?,strokesPerMin: freezed == strokesPerMin ? _self.strokesPerMin : strokesPerMin // ignore: cast_nullable_to_non_nullable
as double?,strokeCountTotal: freezed == strokeCountTotal ? _self.strokeCountTotal : strokeCountTotal // ignore: cast_nullable_to_non_nullable
as int?,avgStrokeRate: freezed == avgStrokeRate ? _self.avgStrokeRate : avgStrokeRate // ignore: cast_nullable_to_non_nullable
as double?,resistanceLvl: freezed == resistanceLvl ? _self.resistanceLvl : resistanceLvl // ignore: cast_nullable_to_non_nullable
as double?,inclineAngle: freezed == inclineAngle ? _self.inclineAngle : inclineAngle // ignore: cast_nullable_to_non_nullable
as double?,rampAngle: freezed == rampAngle ? _self.rampAngle : rampAngle // ignore: cast_nullable_to_non_nullable
as double?,elevationGainPos: freezed == elevationGainPos ? _self.elevationGainPos : elevationGainPos // ignore: cast_nullable_to_non_nullable
as int?,elevationGainNeg: freezed == elevationGainNeg ? _self.elevationGainNeg : elevationGainNeg // ignore: cast_nullable_to_non_nullable
as int?,instPower: freezed == instPower ? _self.instPower : instPower // ignore: cast_nullable_to_non_nullable
as int?,avgPower: freezed == avgPower ? _self.avgPower : avgPower // ignore: cast_nullable_to_non_nullable
as int?,forceOnBelt: freezed == forceOnBelt ? _self.forceOnBelt : forceOnBelt // ignore: cast_nullable_to_non_nullable
as int?,energyTotal: freezed == energyTotal ? _self.energyTotal : energyTotal // ignore: cast_nullable_to_non_nullable
as int?,energyPerHr: freezed == energyPerHr ? _self.energyPerHr : energyPerHr // ignore: cast_nullable_to_non_nullable
as int?,energyPerMin: freezed == energyPerMin ? _self.energyPerMin : energyPerMin // ignore: cast_nullable_to_non_nullable
as int?,hr: freezed == hr ? _self.hr : hr // ignore: cast_nullable_to_non_nullable
as int?,met: freezed == met ? _self.met : met // ignore: cast_nullable_to_non_nullable
as double?,timeElapsed: freezed == timeElapsed ? _self.timeElapsed : timeElapsed // ignore: cast_nullable_to_non_nullable
as int?,timeRemaining: freezed == timeRemaining ? _self.timeRemaining : timeRemaining // ignore: cast_nullable_to_non_nullable
as int?,instPace: freezed == instPace ? _self.instPace : instPace // ignore: cast_nullable_to_non_nullable
as double?,avgPace: freezed == avgPace ? _self.avgPace : avgPace // ignore: cast_nullable_to_non_nullable
as double?,movementDirection: freezed == movementDirection ? _self.movementDirection : movementDirection // ignore: cast_nullable_to_non_nullable
as int?,machineState: null == machineState ? _self.machineState : machineState // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FtmsDeviceData].
extension FtmsDeviceDataPatterns on FtmsDeviceData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FtmsDeviceData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FtmsDeviceData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FtmsDeviceData value)  $default,){
final _that = this;
switch (_that) {
case _FtmsDeviceData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FtmsDeviceData value)?  $default,){
final _that = this;
switch (_that) {
case _FtmsDeviceData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? instSpeed,  double? avgSpeed,  int? distTotal,  double? instCadence,  double? avgCadence,  int? stepsPerMin,  int? avgStepRate,  int? strideCountTotal,  double? strokesPerMin,  int? strokeCountTotal,  double? avgStrokeRate,  double? resistanceLvl,  double? inclineAngle,  double? rampAngle,  int? elevationGainPos,  int? elevationGainNeg,  int? instPower,  int? avgPower,  int? forceOnBelt,  int? energyTotal,  int? energyPerHr,  int? energyPerMin,  int? hr,  double? met,  int? timeElapsed,  int? timeRemaining,  double? instPace,  double? avgPace,  int? movementDirection,  int machineState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FtmsDeviceData() when $default != null:
return $default(_that.instSpeed,_that.avgSpeed,_that.distTotal,_that.instCadence,_that.avgCadence,_that.stepsPerMin,_that.avgStepRate,_that.strideCountTotal,_that.strokesPerMin,_that.strokeCountTotal,_that.avgStrokeRate,_that.resistanceLvl,_that.inclineAngle,_that.rampAngle,_that.elevationGainPos,_that.elevationGainNeg,_that.instPower,_that.avgPower,_that.forceOnBelt,_that.energyTotal,_that.energyPerHr,_that.energyPerMin,_that.hr,_that.met,_that.timeElapsed,_that.timeRemaining,_that.instPace,_that.avgPace,_that.movementDirection,_that.machineState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? instSpeed,  double? avgSpeed,  int? distTotal,  double? instCadence,  double? avgCadence,  int? stepsPerMin,  int? avgStepRate,  int? strideCountTotal,  double? strokesPerMin,  int? strokeCountTotal,  double? avgStrokeRate,  double? resistanceLvl,  double? inclineAngle,  double? rampAngle,  int? elevationGainPos,  int? elevationGainNeg,  int? instPower,  int? avgPower,  int? forceOnBelt,  int? energyTotal,  int? energyPerHr,  int? energyPerMin,  int? hr,  double? met,  int? timeElapsed,  int? timeRemaining,  double? instPace,  double? avgPace,  int? movementDirection,  int machineState)  $default,) {final _that = this;
switch (_that) {
case _FtmsDeviceData():
return $default(_that.instSpeed,_that.avgSpeed,_that.distTotal,_that.instCadence,_that.avgCadence,_that.stepsPerMin,_that.avgStepRate,_that.strideCountTotal,_that.strokesPerMin,_that.strokeCountTotal,_that.avgStrokeRate,_that.resistanceLvl,_that.inclineAngle,_that.rampAngle,_that.elevationGainPos,_that.elevationGainNeg,_that.instPower,_that.avgPower,_that.forceOnBelt,_that.energyTotal,_that.energyPerHr,_that.energyPerMin,_that.hr,_that.met,_that.timeElapsed,_that.timeRemaining,_that.instPace,_that.avgPace,_that.movementDirection,_that.machineState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? instSpeed,  double? avgSpeed,  int? distTotal,  double? instCadence,  double? avgCadence,  int? stepsPerMin,  int? avgStepRate,  int? strideCountTotal,  double? strokesPerMin,  int? strokeCountTotal,  double? avgStrokeRate,  double? resistanceLvl,  double? inclineAngle,  double? rampAngle,  int? elevationGainPos,  int? elevationGainNeg,  int? instPower,  int? avgPower,  int? forceOnBelt,  int? energyTotal,  int? energyPerHr,  int? energyPerMin,  int? hr,  double? met,  int? timeElapsed,  int? timeRemaining,  double? instPace,  double? avgPace,  int? movementDirection,  int machineState)?  $default,) {final _that = this;
switch (_that) {
case _FtmsDeviceData() when $default != null:
return $default(_that.instSpeed,_that.avgSpeed,_that.distTotal,_that.instCadence,_that.avgCadence,_that.stepsPerMin,_that.avgStepRate,_that.strideCountTotal,_that.strokesPerMin,_that.strokeCountTotal,_that.avgStrokeRate,_that.resistanceLvl,_that.inclineAngle,_that.rampAngle,_that.elevationGainPos,_that.elevationGainNeg,_that.instPower,_that.avgPower,_that.forceOnBelt,_that.energyTotal,_that.energyPerHr,_that.energyPerMin,_that.hr,_that.met,_that.timeElapsed,_that.timeRemaining,_that.instPace,_that.avgPace,_that.movementDirection,_that.machineState);case _:
  return null;

}
}

}

/// @nodoc


class _FtmsDeviceData implements FtmsDeviceData {
  const _FtmsDeviceData({this.instSpeed, this.avgSpeed, this.distTotal, this.instCadence, this.avgCadence, this.stepsPerMin, this.avgStepRate, this.strideCountTotal, this.strokesPerMin, this.strokeCountTotal, this.avgStrokeRate, this.resistanceLvl, this.inclineAngle, this.rampAngle, this.elevationGainPos, this.elevationGainNeg, this.instPower, this.avgPower, this.forceOnBelt, this.energyTotal, this.energyPerHr, this.energyPerMin, this.hr, this.met, this.timeElapsed, this.timeRemaining, this.instPace, this.avgPace, this.movementDirection, this.machineState = 0});
  

// ---- 通用速度/距离 ----
@override final  double? instSpeed;
// 瞬时速度(km/h)
@override final  double? avgSpeed;
// 平均速度(km/h)
@override final  int? distTotal;
// 总距离(米)
// ---- 踏频/步频/桨频 ----
@override final  double? instCadence;
// 瞬时踏频(rpm,单车/椭圆机)
@override final  double? avgCadence;
// 平均踏频(rpm)
@override final  int? stepsPerMin;
// 步频(椭圆机)
@override final  int? avgStepRate;
// 平均步频(椭圆机)
@override final  int? strideCountTotal;
// 总步数(椭圆机)
@override final  double? strokesPerMin;
// 桨频(spm,划船机)
@override final  int? strokeCountTotal;
// 总桨次(划船机)
@override final  double? avgStrokeRate;
// 平均桨频(spm)
// ---- 阻力/坡度/功率 ----
@override final  double? resistanceLvl;
// 阻力等级
@override final  double? inclineAngle;
// 坡度(百分比)
@override final  double? rampAngle;
// 坡度角度(度)
@override final  int? elevationGainPos;
// 正海拔增益(米)
@override final  int? elevationGainNeg;
// 负海拔增益(米)
@override final  int? instPower;
// 瞬时功率(瓦)
@override final  int? avgPower;
// 平均功率(瓦)
@override final  int? forceOnBelt;
// 皮带受力(牛,跑步机)
// ---- 能耗/心率/代谢 ----
@override final  int? energyTotal;
// 总能耗(千卡)
@override final  int? energyPerHr;
// 每小时能耗(千卡)
@override final  int? energyPerMin;
// 每分钟能耗(千卡)
@override final  int? hr;
// 心率(bpm)
@override final  double? met;
// 代谢当量
// ---- 时间 ----
@override final  int? timeElapsed;
// 已运动时长(秒)
@override final  int? timeRemaining;
// 剩余时间(秒)
// ---- 配速 ----
@override final  double? instPace;
// 瞬时配速
@override final  double? avgPace;
// 平均配速
// ---- 椭圆机特有 ----
@override final  int? movementDirection;
// 运动方向(0=向前/1=向后)
// ---- 设备状态 ----
@override@JsonKey() final  int machineState;

/// Create a copy of FtmsDeviceData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FtmsDeviceDataCopyWith<_FtmsDeviceData> get copyWith => __$FtmsDeviceDataCopyWithImpl<_FtmsDeviceData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FtmsDeviceData&&(identical(other.instSpeed, instSpeed) || other.instSpeed == instSpeed)&&(identical(other.avgSpeed, avgSpeed) || other.avgSpeed == avgSpeed)&&(identical(other.distTotal, distTotal) || other.distTotal == distTotal)&&(identical(other.instCadence, instCadence) || other.instCadence == instCadence)&&(identical(other.avgCadence, avgCadence) || other.avgCadence == avgCadence)&&(identical(other.stepsPerMin, stepsPerMin) || other.stepsPerMin == stepsPerMin)&&(identical(other.avgStepRate, avgStepRate) || other.avgStepRate == avgStepRate)&&(identical(other.strideCountTotal, strideCountTotal) || other.strideCountTotal == strideCountTotal)&&(identical(other.strokesPerMin, strokesPerMin) || other.strokesPerMin == strokesPerMin)&&(identical(other.strokeCountTotal, strokeCountTotal) || other.strokeCountTotal == strokeCountTotal)&&(identical(other.avgStrokeRate, avgStrokeRate) || other.avgStrokeRate == avgStrokeRate)&&(identical(other.resistanceLvl, resistanceLvl) || other.resistanceLvl == resistanceLvl)&&(identical(other.inclineAngle, inclineAngle) || other.inclineAngle == inclineAngle)&&(identical(other.rampAngle, rampAngle) || other.rampAngle == rampAngle)&&(identical(other.elevationGainPos, elevationGainPos) || other.elevationGainPos == elevationGainPos)&&(identical(other.elevationGainNeg, elevationGainNeg) || other.elevationGainNeg == elevationGainNeg)&&(identical(other.instPower, instPower) || other.instPower == instPower)&&(identical(other.avgPower, avgPower) || other.avgPower == avgPower)&&(identical(other.forceOnBelt, forceOnBelt) || other.forceOnBelt == forceOnBelt)&&(identical(other.energyTotal, energyTotal) || other.energyTotal == energyTotal)&&(identical(other.energyPerHr, energyPerHr) || other.energyPerHr == energyPerHr)&&(identical(other.energyPerMin, energyPerMin) || other.energyPerMin == energyPerMin)&&(identical(other.hr, hr) || other.hr == hr)&&(identical(other.met, met) || other.met == met)&&(identical(other.timeElapsed, timeElapsed) || other.timeElapsed == timeElapsed)&&(identical(other.timeRemaining, timeRemaining) || other.timeRemaining == timeRemaining)&&(identical(other.instPace, instPace) || other.instPace == instPace)&&(identical(other.avgPace, avgPace) || other.avgPace == avgPace)&&(identical(other.movementDirection, movementDirection) || other.movementDirection == movementDirection)&&(identical(other.machineState, machineState) || other.machineState == machineState));
}


@override
int get hashCode => Object.hashAll([runtimeType,instSpeed,avgSpeed,distTotal,instCadence,avgCadence,stepsPerMin,avgStepRate,strideCountTotal,strokesPerMin,strokeCountTotal,avgStrokeRate,resistanceLvl,inclineAngle,rampAngle,elevationGainPos,elevationGainNeg,instPower,avgPower,forceOnBelt,energyTotal,energyPerHr,energyPerMin,hr,met,timeElapsed,timeRemaining,instPace,avgPace,movementDirection,machineState]);

@override
String toString() {
  return 'FtmsDeviceData(instSpeed: $instSpeed, avgSpeed: $avgSpeed, distTotal: $distTotal, instCadence: $instCadence, avgCadence: $avgCadence, stepsPerMin: $stepsPerMin, avgStepRate: $avgStepRate, strideCountTotal: $strideCountTotal, strokesPerMin: $strokesPerMin, strokeCountTotal: $strokeCountTotal, avgStrokeRate: $avgStrokeRate, resistanceLvl: $resistanceLvl, inclineAngle: $inclineAngle, rampAngle: $rampAngle, elevationGainPos: $elevationGainPos, elevationGainNeg: $elevationGainNeg, instPower: $instPower, avgPower: $avgPower, forceOnBelt: $forceOnBelt, energyTotal: $energyTotal, energyPerHr: $energyPerHr, energyPerMin: $energyPerMin, hr: $hr, met: $met, timeElapsed: $timeElapsed, timeRemaining: $timeRemaining, instPace: $instPace, avgPace: $avgPace, movementDirection: $movementDirection, machineState: $machineState)';
}


}

/// @nodoc
abstract mixin class _$FtmsDeviceDataCopyWith<$Res> implements $FtmsDeviceDataCopyWith<$Res> {
  factory _$FtmsDeviceDataCopyWith(_FtmsDeviceData value, $Res Function(_FtmsDeviceData) _then) = __$FtmsDeviceDataCopyWithImpl;
@override @useResult
$Res call({
 double? instSpeed, double? avgSpeed, int? distTotal, double? instCadence, double? avgCadence, int? stepsPerMin, int? avgStepRate, int? strideCountTotal, double? strokesPerMin, int? strokeCountTotal, double? avgStrokeRate, double? resistanceLvl, double? inclineAngle, double? rampAngle, int? elevationGainPos, int? elevationGainNeg, int? instPower, int? avgPower, int? forceOnBelt, int? energyTotal, int? energyPerHr, int? energyPerMin, int? hr, double? met, int? timeElapsed, int? timeRemaining, double? instPace, double? avgPace, int? movementDirection, int machineState
});




}
/// @nodoc
class __$FtmsDeviceDataCopyWithImpl<$Res>
    implements _$FtmsDeviceDataCopyWith<$Res> {
  __$FtmsDeviceDataCopyWithImpl(this._self, this._then);

  final _FtmsDeviceData _self;
  final $Res Function(_FtmsDeviceData) _then;

/// Create a copy of FtmsDeviceData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instSpeed = freezed,Object? avgSpeed = freezed,Object? distTotal = freezed,Object? instCadence = freezed,Object? avgCadence = freezed,Object? stepsPerMin = freezed,Object? avgStepRate = freezed,Object? strideCountTotal = freezed,Object? strokesPerMin = freezed,Object? strokeCountTotal = freezed,Object? avgStrokeRate = freezed,Object? resistanceLvl = freezed,Object? inclineAngle = freezed,Object? rampAngle = freezed,Object? elevationGainPos = freezed,Object? elevationGainNeg = freezed,Object? instPower = freezed,Object? avgPower = freezed,Object? forceOnBelt = freezed,Object? energyTotal = freezed,Object? energyPerHr = freezed,Object? energyPerMin = freezed,Object? hr = freezed,Object? met = freezed,Object? timeElapsed = freezed,Object? timeRemaining = freezed,Object? instPace = freezed,Object? avgPace = freezed,Object? movementDirection = freezed,Object? machineState = null,}) {
  return _then(_FtmsDeviceData(
instSpeed: freezed == instSpeed ? _self.instSpeed : instSpeed // ignore: cast_nullable_to_non_nullable
as double?,avgSpeed: freezed == avgSpeed ? _self.avgSpeed : avgSpeed // ignore: cast_nullable_to_non_nullable
as double?,distTotal: freezed == distTotal ? _self.distTotal : distTotal // ignore: cast_nullable_to_non_nullable
as int?,instCadence: freezed == instCadence ? _self.instCadence : instCadence // ignore: cast_nullable_to_non_nullable
as double?,avgCadence: freezed == avgCadence ? _self.avgCadence : avgCadence // ignore: cast_nullable_to_non_nullable
as double?,stepsPerMin: freezed == stepsPerMin ? _self.stepsPerMin : stepsPerMin // ignore: cast_nullable_to_non_nullable
as int?,avgStepRate: freezed == avgStepRate ? _self.avgStepRate : avgStepRate // ignore: cast_nullable_to_non_nullable
as int?,strideCountTotal: freezed == strideCountTotal ? _self.strideCountTotal : strideCountTotal // ignore: cast_nullable_to_non_nullable
as int?,strokesPerMin: freezed == strokesPerMin ? _self.strokesPerMin : strokesPerMin // ignore: cast_nullable_to_non_nullable
as double?,strokeCountTotal: freezed == strokeCountTotal ? _self.strokeCountTotal : strokeCountTotal // ignore: cast_nullable_to_non_nullable
as int?,avgStrokeRate: freezed == avgStrokeRate ? _self.avgStrokeRate : avgStrokeRate // ignore: cast_nullable_to_non_nullable
as double?,resistanceLvl: freezed == resistanceLvl ? _self.resistanceLvl : resistanceLvl // ignore: cast_nullable_to_non_nullable
as double?,inclineAngle: freezed == inclineAngle ? _self.inclineAngle : inclineAngle // ignore: cast_nullable_to_non_nullable
as double?,rampAngle: freezed == rampAngle ? _self.rampAngle : rampAngle // ignore: cast_nullable_to_non_nullable
as double?,elevationGainPos: freezed == elevationGainPos ? _self.elevationGainPos : elevationGainPos // ignore: cast_nullable_to_non_nullable
as int?,elevationGainNeg: freezed == elevationGainNeg ? _self.elevationGainNeg : elevationGainNeg // ignore: cast_nullable_to_non_nullable
as int?,instPower: freezed == instPower ? _self.instPower : instPower // ignore: cast_nullable_to_non_nullable
as int?,avgPower: freezed == avgPower ? _self.avgPower : avgPower // ignore: cast_nullable_to_non_nullable
as int?,forceOnBelt: freezed == forceOnBelt ? _self.forceOnBelt : forceOnBelt // ignore: cast_nullable_to_non_nullable
as int?,energyTotal: freezed == energyTotal ? _self.energyTotal : energyTotal // ignore: cast_nullable_to_non_nullable
as int?,energyPerHr: freezed == energyPerHr ? _self.energyPerHr : energyPerHr // ignore: cast_nullable_to_non_nullable
as int?,energyPerMin: freezed == energyPerMin ? _self.energyPerMin : energyPerMin // ignore: cast_nullable_to_non_nullable
as int?,hr: freezed == hr ? _self.hr : hr // ignore: cast_nullable_to_non_nullable
as int?,met: freezed == met ? _self.met : met // ignore: cast_nullable_to_non_nullable
as double?,timeElapsed: freezed == timeElapsed ? _self.timeElapsed : timeElapsed // ignore: cast_nullable_to_non_nullable
as int?,timeRemaining: freezed == timeRemaining ? _self.timeRemaining : timeRemaining // ignore: cast_nullable_to_non_nullable
as int?,instPace: freezed == instPace ? _self.instPace : instPace // ignore: cast_nullable_to_non_nullable
as double?,avgPace: freezed == avgPace ? _self.avgPace : avgPace // ignore: cast_nullable_to_non_nullable
as double?,movementDirection: freezed == movementDirection ? _self.movementDirection : movementDirection // ignore: cast_nullable_to_non_nullable
as int?,machineState: null == machineState ? _self.machineState : machineState // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
