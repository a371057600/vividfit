// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_start_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuickStartState {

/// 是否显示开始按钮（对应旧 hc.showPlayButton）。
 bool get showPlayButton;/// 是否正在暂停（对应旧 hc.isPause）。
 bool get isPaused;/// 是否在快速开始播放中（对应旧 hc.isInQuickPlay）。
 bool get isInQuickPlay;/// 是否正在播放（对应旧 hc.isPlaying）。
 bool get isPlaying;/// 音乐是否正在播放。
 bool get isMusicPlaying;/// 当前运动时间（秒）。
 int get realSportTime;/// 运动距离（米）。
 double get sportDistance;/// 卡路里。
 double get sportEnergy;/// 当前速度。
 double get sportSpeed;/// 踏频。
 double get sportCadence;/// 心率。
 int get sportHeartRate;/// 桨频。
 double get sportStrokeRate;/// 桨次数。
 double get sportStrokeCount;/// NPC 时间（跑道动画用）。
 double get npcTime;/// 最大速度。
 int get maxSpeed;/// 阻力按钮当前值。
 double get sportResistanceButton;/// 速度按钮当前值。
 double get sportSpeedButton;/// 坡度按钮当前值。
 double get sportInclinationButton;/// 阻力档位列表。
 List<double> get buttonResistanceList;/// 速度档位列表。
 List<double> get buttonSpeedList;/// 坡度档位列表。
 List<double> get buttonInclinationList;/// 是否支持坡度。
 bool get hasInclinationSupport;/// 已达成的时间目标档位索引（避免重复弹窗）。
 List<int> get achievedTimeLevels;/// 已达成的距离目标档位索引。
 List<int> get achievedDistanceLevels;/// 已达成的卡路里目标档位索引。
 List<int> get achievedEnergyLevels;/// 是否显示【时间目标达成】弹窗。
 bool get showTimeGoalDialog;/// 是否显示【距离目标达成】弹窗。
 bool get showDistanceGoalDialog;/// 是否显示【卡路里目标达成】弹窗。
 bool get showEnergyGoalDialog;/// 当前触发的时间目标值（秒），供 UI 展示。
 int get currentTimeGoalSec;/// 当前触发的距离目标值（公里），供 UI 展示。
 double get currentDistanceGoalKm;/// 当前触发的卡路里目标值（千卡），供 UI 展示。
 double get currentEnergyGoalKcal;
/// Create a copy of QuickStartState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickStartStateCopyWith<QuickStartState> get copyWith => _$QuickStartStateCopyWithImpl<QuickStartState>(this as QuickStartState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickStartState&&(identical(other.showPlayButton, showPlayButton) || other.showPlayButton == showPlayButton)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.isInQuickPlay, isInQuickPlay) || other.isInQuickPlay == isInQuickPlay)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isMusicPlaying, isMusicPlaying) || other.isMusicPlaying == isMusicPlaying)&&(identical(other.realSportTime, realSportTime) || other.realSportTime == realSportTime)&&(identical(other.sportDistance, sportDistance) || other.sportDistance == sportDistance)&&(identical(other.sportEnergy, sportEnergy) || other.sportEnergy == sportEnergy)&&(identical(other.sportSpeed, sportSpeed) || other.sportSpeed == sportSpeed)&&(identical(other.sportCadence, sportCadence) || other.sportCadence == sportCadence)&&(identical(other.sportHeartRate, sportHeartRate) || other.sportHeartRate == sportHeartRate)&&(identical(other.sportStrokeRate, sportStrokeRate) || other.sportStrokeRate == sportStrokeRate)&&(identical(other.sportStrokeCount, sportStrokeCount) || other.sportStrokeCount == sportStrokeCount)&&(identical(other.npcTime, npcTime) || other.npcTime == npcTime)&&(identical(other.maxSpeed, maxSpeed) || other.maxSpeed == maxSpeed)&&(identical(other.sportResistanceButton, sportResistanceButton) || other.sportResistanceButton == sportResistanceButton)&&(identical(other.sportSpeedButton, sportSpeedButton) || other.sportSpeedButton == sportSpeedButton)&&(identical(other.sportInclinationButton, sportInclinationButton) || other.sportInclinationButton == sportInclinationButton)&&const DeepCollectionEquality().equals(other.buttonResistanceList, buttonResistanceList)&&const DeepCollectionEquality().equals(other.buttonSpeedList, buttonSpeedList)&&const DeepCollectionEquality().equals(other.buttonInclinationList, buttonInclinationList)&&(identical(other.hasInclinationSupport, hasInclinationSupport) || other.hasInclinationSupport == hasInclinationSupport)&&const DeepCollectionEquality().equals(other.achievedTimeLevels, achievedTimeLevels)&&const DeepCollectionEquality().equals(other.achievedDistanceLevels, achievedDistanceLevels)&&const DeepCollectionEquality().equals(other.achievedEnergyLevels, achievedEnergyLevels)&&(identical(other.showTimeGoalDialog, showTimeGoalDialog) || other.showTimeGoalDialog == showTimeGoalDialog)&&(identical(other.showDistanceGoalDialog, showDistanceGoalDialog) || other.showDistanceGoalDialog == showDistanceGoalDialog)&&(identical(other.showEnergyGoalDialog, showEnergyGoalDialog) || other.showEnergyGoalDialog == showEnergyGoalDialog)&&(identical(other.currentTimeGoalSec, currentTimeGoalSec) || other.currentTimeGoalSec == currentTimeGoalSec)&&(identical(other.currentDistanceGoalKm, currentDistanceGoalKm) || other.currentDistanceGoalKm == currentDistanceGoalKm)&&(identical(other.currentEnergyGoalKcal, currentEnergyGoalKcal) || other.currentEnergyGoalKcal == currentEnergyGoalKcal));
}


@override
int get hashCode => Object.hashAll([runtimeType,showPlayButton,isPaused,isInQuickPlay,isPlaying,isMusicPlaying,realSportTime,sportDistance,sportEnergy,sportSpeed,sportCadence,sportHeartRate,sportStrokeRate,sportStrokeCount,npcTime,maxSpeed,sportResistanceButton,sportSpeedButton,sportInclinationButton,const DeepCollectionEquality().hash(buttonResistanceList),const DeepCollectionEquality().hash(buttonSpeedList),const DeepCollectionEquality().hash(buttonInclinationList),hasInclinationSupport,const DeepCollectionEquality().hash(achievedTimeLevels),const DeepCollectionEquality().hash(achievedDistanceLevels),const DeepCollectionEquality().hash(achievedEnergyLevels),showTimeGoalDialog,showDistanceGoalDialog,showEnergyGoalDialog,currentTimeGoalSec,currentDistanceGoalKm,currentEnergyGoalKcal]);

@override
String toString() {
  return 'QuickStartState(showPlayButton: $showPlayButton, isPaused: $isPaused, isInQuickPlay: $isInQuickPlay, isPlaying: $isPlaying, isMusicPlaying: $isMusicPlaying, realSportTime: $realSportTime, sportDistance: $sportDistance, sportEnergy: $sportEnergy, sportSpeed: $sportSpeed, sportCadence: $sportCadence, sportHeartRate: $sportHeartRate, sportStrokeRate: $sportStrokeRate, sportStrokeCount: $sportStrokeCount, npcTime: $npcTime, maxSpeed: $maxSpeed, sportResistanceButton: $sportResistanceButton, sportSpeedButton: $sportSpeedButton, sportInclinationButton: $sportInclinationButton, buttonResistanceList: $buttonResistanceList, buttonSpeedList: $buttonSpeedList, buttonInclinationList: $buttonInclinationList, hasInclinationSupport: $hasInclinationSupport, achievedTimeLevels: $achievedTimeLevels, achievedDistanceLevels: $achievedDistanceLevels, achievedEnergyLevels: $achievedEnergyLevels, showTimeGoalDialog: $showTimeGoalDialog, showDistanceGoalDialog: $showDistanceGoalDialog, showEnergyGoalDialog: $showEnergyGoalDialog, currentTimeGoalSec: $currentTimeGoalSec, currentDistanceGoalKm: $currentDistanceGoalKm, currentEnergyGoalKcal: $currentEnergyGoalKcal)';
}


}

/// @nodoc
abstract mixin class $QuickStartStateCopyWith<$Res>  {
  factory $QuickStartStateCopyWith(QuickStartState value, $Res Function(QuickStartState) _then) = _$QuickStartStateCopyWithImpl;
@useResult
$Res call({
 bool showPlayButton, bool isPaused, bool isInQuickPlay, bool isPlaying, bool isMusicPlaying, int realSportTime, double sportDistance, double sportEnergy, double sportSpeed, double sportCadence, int sportHeartRate, double sportStrokeRate, double sportStrokeCount, double npcTime, int maxSpeed, double sportResistanceButton, double sportSpeedButton, double sportInclinationButton, List<double> buttonResistanceList, List<double> buttonSpeedList, List<double> buttonInclinationList, bool hasInclinationSupport, List<int> achievedTimeLevels, List<int> achievedDistanceLevels, List<int> achievedEnergyLevels, bool showTimeGoalDialog, bool showDistanceGoalDialog, bool showEnergyGoalDialog, int currentTimeGoalSec, double currentDistanceGoalKm, double currentEnergyGoalKcal
});




}
/// @nodoc
class _$QuickStartStateCopyWithImpl<$Res>
    implements $QuickStartStateCopyWith<$Res> {
  _$QuickStartStateCopyWithImpl(this._self, this._then);

  final QuickStartState _self;
  final $Res Function(QuickStartState) _then;

/// Create a copy of QuickStartState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showPlayButton = null,Object? isPaused = null,Object? isInQuickPlay = null,Object? isPlaying = null,Object? isMusicPlaying = null,Object? realSportTime = null,Object? sportDistance = null,Object? sportEnergy = null,Object? sportSpeed = null,Object? sportCadence = null,Object? sportHeartRate = null,Object? sportStrokeRate = null,Object? sportStrokeCount = null,Object? npcTime = null,Object? maxSpeed = null,Object? sportResistanceButton = null,Object? sportSpeedButton = null,Object? sportInclinationButton = null,Object? buttonResistanceList = null,Object? buttonSpeedList = null,Object? buttonInclinationList = null,Object? hasInclinationSupport = null,Object? achievedTimeLevels = null,Object? achievedDistanceLevels = null,Object? achievedEnergyLevels = null,Object? showTimeGoalDialog = null,Object? showDistanceGoalDialog = null,Object? showEnergyGoalDialog = null,Object? currentTimeGoalSec = null,Object? currentDistanceGoalKm = null,Object? currentEnergyGoalKcal = null,}) {
  return _then(QuickStartState(
showPlayButton: null == showPlayButton ? _self.showPlayButton : showPlayButton // ignore: cast_nullable_to_non_nullable
as bool,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,isInQuickPlay: null == isInQuickPlay ? _self.isInQuickPlay : isInQuickPlay // ignore: cast_nullable_to_non_nullable
as bool,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isMusicPlaying: null == isMusicPlaying ? _self.isMusicPlaying : isMusicPlaying // ignore: cast_nullable_to_non_nullable
as bool,realSportTime: null == realSportTime ? _self.realSportTime : realSportTime // ignore: cast_nullable_to_non_nullable
as int,sportDistance: null == sportDistance ? _self.sportDistance : sportDistance // ignore: cast_nullable_to_non_nullable
as double,sportEnergy: null == sportEnergy ? _self.sportEnergy : sportEnergy // ignore: cast_nullable_to_non_nullable
as double,sportSpeed: null == sportSpeed ? _self.sportSpeed : sportSpeed // ignore: cast_nullable_to_non_nullable
as double,sportCadence: null == sportCadence ? _self.sportCadence : sportCadence // ignore: cast_nullable_to_non_nullable
as double,sportHeartRate: null == sportHeartRate ? _self.sportHeartRate : sportHeartRate // ignore: cast_nullable_to_non_nullable
as int,sportStrokeRate: null == sportStrokeRate ? _self.sportStrokeRate : sportStrokeRate // ignore: cast_nullable_to_non_nullable
as double,sportStrokeCount: null == sportStrokeCount ? _self.sportStrokeCount : sportStrokeCount // ignore: cast_nullable_to_non_nullable
as double,npcTime: null == npcTime ? _self.npcTime : npcTime // ignore: cast_nullable_to_non_nullable
as double,maxSpeed: null == maxSpeed ? _self.maxSpeed : maxSpeed // ignore: cast_nullable_to_non_nullable
as int,sportResistanceButton: null == sportResistanceButton ? _self.sportResistanceButton : sportResistanceButton // ignore: cast_nullable_to_non_nullable
as double,sportSpeedButton: null == sportSpeedButton ? _self.sportSpeedButton : sportSpeedButton // ignore: cast_nullable_to_non_nullable
as double,sportInclinationButton: null == sportInclinationButton ? _self.sportInclinationButton : sportInclinationButton // ignore: cast_nullable_to_non_nullable
as double,buttonResistanceList: null == buttonResistanceList ? _self.buttonResistanceList : buttonResistanceList // ignore: cast_nullable_to_non_nullable
as List<double>,buttonSpeedList: null == buttonSpeedList ? _self.buttonSpeedList : buttonSpeedList // ignore: cast_nullable_to_non_nullable
as List<double>,buttonInclinationList: null == buttonInclinationList ? _self.buttonInclinationList : buttonInclinationList // ignore: cast_nullable_to_non_nullable
as List<double>,hasInclinationSupport: null == hasInclinationSupport ? _self.hasInclinationSupport : hasInclinationSupport // ignore: cast_nullable_to_non_nullable
as bool,achievedTimeLevels: null == achievedTimeLevels ? _self.achievedTimeLevels : achievedTimeLevels // ignore: cast_nullable_to_non_nullable
as List<int>,achievedDistanceLevels: null == achievedDistanceLevels ? _self.achievedDistanceLevels : achievedDistanceLevels // ignore: cast_nullable_to_non_nullable
as List<int>,achievedEnergyLevels: null == achievedEnergyLevels ? _self.achievedEnergyLevels : achievedEnergyLevels // ignore: cast_nullable_to_non_nullable
as List<int>,showTimeGoalDialog: null == showTimeGoalDialog ? _self.showTimeGoalDialog : showTimeGoalDialog // ignore: cast_nullable_to_non_nullable
as bool,showDistanceGoalDialog: null == showDistanceGoalDialog ? _self.showDistanceGoalDialog : showDistanceGoalDialog // ignore: cast_nullable_to_non_nullable
as bool,showEnergyGoalDialog: null == showEnergyGoalDialog ? _self.showEnergyGoalDialog : showEnergyGoalDialog // ignore: cast_nullable_to_non_nullable
as bool,currentTimeGoalSec: null == currentTimeGoalSec ? _self.currentTimeGoalSec : currentTimeGoalSec // ignore: cast_nullable_to_non_nullable
as int,currentDistanceGoalKm: null == currentDistanceGoalKm ? _self.currentDistanceGoalKm : currentDistanceGoalKm // ignore: cast_nullable_to_non_nullable
as double,currentEnergyGoalKcal: null == currentEnergyGoalKcal ? _self.currentEnergyGoalKcal : currentEnergyGoalKcal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickStartState].
extension QuickStartStatePatterns on QuickStartState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickStartState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickStartState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickStartState value)  $default,){
final _that = this;
switch (_that) {
case _QuickStartState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickStartState value)?  $default,){
final _that = this;
switch (_that) {
case _QuickStartState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool showPlayButton,  bool isPaused,  bool isInQuickPlay,  bool isPlaying,  bool isMusicPlaying,  int realSportTime,  double sportDistance,  double sportEnergy,  double sportSpeed,  double sportCadence,  int sportHeartRate,  double sportStrokeRate,  double sportStrokeCount,  double npcTime,  int maxSpeed,  double sportResistanceButton,  double sportSpeedButton,  double sportInclinationButton,  List<double> buttonResistanceList,  List<double> buttonSpeedList,  List<double> buttonInclinationList,  bool hasInclinationSupport,  List<int> achievedTimeLevels,  List<int> achievedDistanceLevels,  List<int> achievedEnergyLevels,  bool showTimeGoalDialog,  bool showDistanceGoalDialog,  bool showEnergyGoalDialog,  int currentTimeGoalSec,  double currentDistanceGoalKm,  double currentEnergyGoalKcal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickStartState() when $default != null:
return $default(_that.showPlayButton,_that.isPaused,_that.isInQuickPlay,_that.isPlaying,_that.isMusicPlaying,_that.realSportTime,_that.sportDistance,_that.sportEnergy,_that.sportSpeed,_that.sportCadence,_that.sportHeartRate,_that.sportStrokeRate,_that.sportStrokeCount,_that.npcTime,_that.maxSpeed,_that.sportResistanceButton,_that.sportSpeedButton,_that.sportInclinationButton,_that.buttonResistanceList,_that.buttonSpeedList,_that.buttonInclinationList,_that.hasInclinationSupport,_that.achievedTimeLevels,_that.achievedDistanceLevels,_that.achievedEnergyLevels,_that.showTimeGoalDialog,_that.showDistanceGoalDialog,_that.showEnergyGoalDialog,_that.currentTimeGoalSec,_that.currentDistanceGoalKm,_that.currentEnergyGoalKcal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool showPlayButton,  bool isPaused,  bool isInQuickPlay,  bool isPlaying,  bool isMusicPlaying,  int realSportTime,  double sportDistance,  double sportEnergy,  double sportSpeed,  double sportCadence,  int sportHeartRate,  double sportStrokeRate,  double sportStrokeCount,  double npcTime,  int maxSpeed,  double sportResistanceButton,  double sportSpeedButton,  double sportInclinationButton,  List<double> buttonResistanceList,  List<double> buttonSpeedList,  List<double> buttonInclinationList,  bool hasInclinationSupport,  List<int> achievedTimeLevels,  List<int> achievedDistanceLevels,  List<int> achievedEnergyLevels,  bool showTimeGoalDialog,  bool showDistanceGoalDialog,  bool showEnergyGoalDialog,  int currentTimeGoalSec,  double currentDistanceGoalKm,  double currentEnergyGoalKcal)  $default,) {final _that = this;
switch (_that) {
case _QuickStartState():
return $default(_that.showPlayButton,_that.isPaused,_that.isInQuickPlay,_that.isPlaying,_that.isMusicPlaying,_that.realSportTime,_that.sportDistance,_that.sportEnergy,_that.sportSpeed,_that.sportCadence,_that.sportHeartRate,_that.sportStrokeRate,_that.sportStrokeCount,_that.npcTime,_that.maxSpeed,_that.sportResistanceButton,_that.sportSpeedButton,_that.sportInclinationButton,_that.buttonResistanceList,_that.buttonSpeedList,_that.buttonInclinationList,_that.hasInclinationSupport,_that.achievedTimeLevels,_that.achievedDistanceLevels,_that.achievedEnergyLevels,_that.showTimeGoalDialog,_that.showDistanceGoalDialog,_that.showEnergyGoalDialog,_that.currentTimeGoalSec,_that.currentDistanceGoalKm,_that.currentEnergyGoalKcal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool showPlayButton,  bool isPaused,  bool isInQuickPlay,  bool isPlaying,  bool isMusicPlaying,  int realSportTime,  double sportDistance,  double sportEnergy,  double sportSpeed,  double sportCadence,  int sportHeartRate,  double sportStrokeRate,  double sportStrokeCount,  double npcTime,  int maxSpeed,  double sportResistanceButton,  double sportSpeedButton,  double sportInclinationButton,  List<double> buttonResistanceList,  List<double> buttonSpeedList,  List<double> buttonInclinationList,  bool hasInclinationSupport,  List<int> achievedTimeLevels,  List<int> achievedDistanceLevels,  List<int> achievedEnergyLevels,  bool showTimeGoalDialog,  bool showDistanceGoalDialog,  bool showEnergyGoalDialog,  int currentTimeGoalSec,  double currentDistanceGoalKm,  double currentEnergyGoalKcal)?  $default,) {final _that = this;
switch (_that) {
case _QuickStartState() when $default != null:
return $default(_that.showPlayButton,_that.isPaused,_that.isInQuickPlay,_that.isPlaying,_that.isMusicPlaying,_that.realSportTime,_that.sportDistance,_that.sportEnergy,_that.sportSpeed,_that.sportCadence,_that.sportHeartRate,_that.sportStrokeRate,_that.sportStrokeCount,_that.npcTime,_that.maxSpeed,_that.sportResistanceButton,_that.sportSpeedButton,_that.sportInclinationButton,_that.buttonResistanceList,_that.buttonSpeedList,_that.buttonInclinationList,_that.hasInclinationSupport,_that.achievedTimeLevels,_that.achievedDistanceLevels,_that.achievedEnergyLevels,_that.showTimeGoalDialog,_that.showDistanceGoalDialog,_that.showEnergyGoalDialog,_that.currentTimeGoalSec,_that.currentDistanceGoalKm,_that.currentEnergyGoalKcal);case _:
  return null;

}
}

}

/// @nodoc


class _QuickStartState implements QuickStartState {
  const _QuickStartState({this.showPlayButton = true, this.isPaused = false, this.isInQuickPlay = false, this.isPlaying = false, this.isMusicPlaying = false, this.realSportTime = 0, this.sportDistance = 0.0, this.sportEnergy = 0.0, this.sportSpeed = 0.0, this.sportCadence = 0.0, this.sportHeartRate = 0, this.sportStrokeRate = 0.0, this.sportStrokeCount = 0.0, this.npcTime = 0.0, this.maxSpeed = 0, this.sportResistanceButton = 0.0, this.sportSpeedButton = 0.0, this.sportInclinationButton = 0.0,  List<double> buttonResistanceList = const <double>[0, 0, 0, 0],  List<double> buttonSpeedList = const <double>[0, 0, 0, 0],  List<double> buttonInclinationList = const <double>[0, 0, 0, 0], this.hasInclinationSupport = false,  List<int> achievedTimeLevels = const <int>[],  List<int> achievedDistanceLevels = const <int>[],  List<int> achievedEnergyLevels = const <int>[], this.showTimeGoalDialog = false, this.showDistanceGoalDialog = false, this.showEnergyGoalDialog = false, this.currentTimeGoalSec = 0, this.currentDistanceGoalKm = 0.0, this.currentEnergyGoalKcal = 0.0}): _buttonResistanceList = buttonResistanceList,_buttonSpeedList = buttonSpeedList,_buttonInclinationList = buttonInclinationList,_achievedTimeLevels = achievedTimeLevels,_achievedDistanceLevels = achievedDistanceLevels,_achievedEnergyLevels = achievedEnergyLevels;
  

/// 是否显示开始按钮（对应旧 hc.showPlayButton）。
@override@JsonKey() final  bool showPlayButton;
/// 是否正在暂停（对应旧 hc.isPause）。
@override@JsonKey() final  bool isPaused;
/// 是否在快速开始播放中（对应旧 hc.isInQuickPlay）。
@override@JsonKey() final  bool isInQuickPlay;
/// 是否正在播放（对应旧 hc.isPlaying）。
@override@JsonKey() final  bool isPlaying;
/// 音乐是否正在播放。
@override@JsonKey() final  bool isMusicPlaying;
/// 当前运动时间（秒）。
@override@JsonKey() final  int realSportTime;
/// 运动距离（米）。
@override@JsonKey() final  double sportDistance;
/// 卡路里。
@override@JsonKey() final  double sportEnergy;
/// 当前速度。
@override@JsonKey() final  double sportSpeed;
/// 踏频。
@override@JsonKey() final  double sportCadence;
/// 心率。
@override@JsonKey() final  int sportHeartRate;
/// 桨频。
@override@JsonKey() final  double sportStrokeRate;
/// 桨次数。
@override@JsonKey() final  double sportStrokeCount;
/// NPC 时间（跑道动画用）。
@override@JsonKey() final  double npcTime;
/// 最大速度。
@override@JsonKey() final  int maxSpeed;
/// 阻力按钮当前值。
@override@JsonKey() final  double sportResistanceButton;
/// 速度按钮当前值。
@override@JsonKey() final  double sportSpeedButton;
/// 坡度按钮当前值。
@override@JsonKey() final  double sportInclinationButton;
/// 阻力档位列表。
 final  List<double> _buttonResistanceList;
/// 阻力档位列表。
@override@JsonKey() List<double> get buttonResistanceList {
  if (_buttonResistanceList is EqualUnmodifiableListView) return _buttonResistanceList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_buttonResistanceList);
}

/// 速度档位列表。
 final  List<double> _buttonSpeedList;
/// 速度档位列表。
@override@JsonKey() List<double> get buttonSpeedList {
  if (_buttonSpeedList is EqualUnmodifiableListView) return _buttonSpeedList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_buttonSpeedList);
}

/// 坡度档位列表。
 final  List<double> _buttonInclinationList;
/// 坡度档位列表。
@override@JsonKey() List<double> get buttonInclinationList {
  if (_buttonInclinationList is EqualUnmodifiableListView) return _buttonInclinationList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_buttonInclinationList);
}

/// 是否支持坡度。
@override@JsonKey() final  bool hasInclinationSupport;
/// 已达成的时间目标档位索引（避免重复弹窗）。
 final  List<int> _achievedTimeLevels;
/// 已达成的时间目标档位索引（避免重复弹窗）。
@override@JsonKey() List<int> get achievedTimeLevels {
  if (_achievedTimeLevels is EqualUnmodifiableListView) return _achievedTimeLevels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_achievedTimeLevels);
}

/// 已达成的距离目标档位索引。
 final  List<int> _achievedDistanceLevels;
/// 已达成的距离目标档位索引。
@override@JsonKey() List<int> get achievedDistanceLevels {
  if (_achievedDistanceLevels is EqualUnmodifiableListView) return _achievedDistanceLevels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_achievedDistanceLevels);
}

/// 已达成的卡路里目标档位索引。
 final  List<int> _achievedEnergyLevels;
/// 已达成的卡路里目标档位索引。
@override@JsonKey() List<int> get achievedEnergyLevels {
  if (_achievedEnergyLevels is EqualUnmodifiableListView) return _achievedEnergyLevels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_achievedEnergyLevels);
}

/// 是否显示【时间目标达成】弹窗。
@override@JsonKey() final  bool showTimeGoalDialog;
/// 是否显示【距离目标达成】弹窗。
@override@JsonKey() final  bool showDistanceGoalDialog;
/// 是否显示【卡路里目标达成】弹窗。
@override@JsonKey() final  bool showEnergyGoalDialog;
/// 当前触发的时间目标值（秒），供 UI 展示。
@override@JsonKey() final  int currentTimeGoalSec;
/// 当前触发的距离目标值（公里），供 UI 展示。
@override@JsonKey() final  double currentDistanceGoalKm;
/// 当前触发的卡路里目标值（千卡），供 UI 展示。
@override@JsonKey() final  double currentEnergyGoalKcal;

/// Create a copy of QuickStartState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickStartStateCopyWith<_QuickStartState> get copyWith => __$QuickStartStateCopyWithImpl<_QuickStartState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickStartState&&(identical(other.showPlayButton, showPlayButton) || other.showPlayButton == showPlayButton)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.isInQuickPlay, isInQuickPlay) || other.isInQuickPlay == isInQuickPlay)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isMusicPlaying, isMusicPlaying) || other.isMusicPlaying == isMusicPlaying)&&(identical(other.realSportTime, realSportTime) || other.realSportTime == realSportTime)&&(identical(other.sportDistance, sportDistance) || other.sportDistance == sportDistance)&&(identical(other.sportEnergy, sportEnergy) || other.sportEnergy == sportEnergy)&&(identical(other.sportSpeed, sportSpeed) || other.sportSpeed == sportSpeed)&&(identical(other.sportCadence, sportCadence) || other.sportCadence == sportCadence)&&(identical(other.sportHeartRate, sportHeartRate) || other.sportHeartRate == sportHeartRate)&&(identical(other.sportStrokeRate, sportStrokeRate) || other.sportStrokeRate == sportStrokeRate)&&(identical(other.sportStrokeCount, sportStrokeCount) || other.sportStrokeCount == sportStrokeCount)&&(identical(other.npcTime, npcTime) || other.npcTime == npcTime)&&(identical(other.maxSpeed, maxSpeed) || other.maxSpeed == maxSpeed)&&(identical(other.sportResistanceButton, sportResistanceButton) || other.sportResistanceButton == sportResistanceButton)&&(identical(other.sportSpeedButton, sportSpeedButton) || other.sportSpeedButton == sportSpeedButton)&&(identical(other.sportInclinationButton, sportInclinationButton) || other.sportInclinationButton == sportInclinationButton)&&const DeepCollectionEquality().equals(other._buttonResistanceList, _buttonResistanceList)&&const DeepCollectionEquality().equals(other._buttonSpeedList, _buttonSpeedList)&&const DeepCollectionEquality().equals(other._buttonInclinationList, _buttonInclinationList)&&(identical(other.hasInclinationSupport, hasInclinationSupport) || other.hasInclinationSupport == hasInclinationSupport)&&const DeepCollectionEquality().equals(other._achievedTimeLevels, _achievedTimeLevels)&&const DeepCollectionEquality().equals(other._achievedDistanceLevels, _achievedDistanceLevels)&&const DeepCollectionEquality().equals(other._achievedEnergyLevels, _achievedEnergyLevels)&&(identical(other.showTimeGoalDialog, showTimeGoalDialog) || other.showTimeGoalDialog == showTimeGoalDialog)&&(identical(other.showDistanceGoalDialog, showDistanceGoalDialog) || other.showDistanceGoalDialog == showDistanceGoalDialog)&&(identical(other.showEnergyGoalDialog, showEnergyGoalDialog) || other.showEnergyGoalDialog == showEnergyGoalDialog)&&(identical(other.currentTimeGoalSec, currentTimeGoalSec) || other.currentTimeGoalSec == currentTimeGoalSec)&&(identical(other.currentDistanceGoalKm, currentDistanceGoalKm) || other.currentDistanceGoalKm == currentDistanceGoalKm)&&(identical(other.currentEnergyGoalKcal, currentEnergyGoalKcal) || other.currentEnergyGoalKcal == currentEnergyGoalKcal));
}


@override
int get hashCode => Object.hashAll([runtimeType,showPlayButton,isPaused,isInQuickPlay,isPlaying,isMusicPlaying,realSportTime,sportDistance,sportEnergy,sportSpeed,sportCadence,sportHeartRate,sportStrokeRate,sportStrokeCount,npcTime,maxSpeed,sportResistanceButton,sportSpeedButton,sportInclinationButton,const DeepCollectionEquality().hash(_buttonResistanceList),const DeepCollectionEquality().hash(_buttonSpeedList),const DeepCollectionEquality().hash(_buttonInclinationList),hasInclinationSupport,const DeepCollectionEquality().hash(_achievedTimeLevels),const DeepCollectionEquality().hash(_achievedDistanceLevels),const DeepCollectionEquality().hash(_achievedEnergyLevels),showTimeGoalDialog,showDistanceGoalDialog,showEnergyGoalDialog,currentTimeGoalSec,currentDistanceGoalKm,currentEnergyGoalKcal]);

@override
String toString() {
  return 'QuickStartState(showPlayButton: $showPlayButton, isPaused: $isPaused, isInQuickPlay: $isInQuickPlay, isPlaying: $isPlaying, isMusicPlaying: $isMusicPlaying, realSportTime: $realSportTime, sportDistance: $sportDistance, sportEnergy: $sportEnergy, sportSpeed: $sportSpeed, sportCadence: $sportCadence, sportHeartRate: $sportHeartRate, sportStrokeRate: $sportStrokeRate, sportStrokeCount: $sportStrokeCount, npcTime: $npcTime, maxSpeed: $maxSpeed, sportResistanceButton: $sportResistanceButton, sportSpeedButton: $sportSpeedButton, sportInclinationButton: $sportInclinationButton, buttonResistanceList: $buttonResistanceList, buttonSpeedList: $buttonSpeedList, buttonInclinationList: $buttonInclinationList, hasInclinationSupport: $hasInclinationSupport, achievedTimeLevels: $achievedTimeLevels, achievedDistanceLevels: $achievedDistanceLevels, achievedEnergyLevels: $achievedEnergyLevels, showTimeGoalDialog: $showTimeGoalDialog, showDistanceGoalDialog: $showDistanceGoalDialog, showEnergyGoalDialog: $showEnergyGoalDialog, currentTimeGoalSec: $currentTimeGoalSec, currentDistanceGoalKm: $currentDistanceGoalKm, currentEnergyGoalKcal: $currentEnergyGoalKcal)';
}


}

/// @nodoc
abstract mixin class _$QuickStartStateCopyWith<$Res> implements $QuickStartStateCopyWith<$Res> {
  factory _$QuickStartStateCopyWith(_QuickStartState value, $Res Function(_QuickStartState) _then) = __$QuickStartStateCopyWithImpl;
@override @useResult
$Res call({
 bool showPlayButton, bool isPaused, bool isInQuickPlay, bool isPlaying, bool isMusicPlaying, int realSportTime, double sportDistance, double sportEnergy, double sportSpeed, double sportCadence, int sportHeartRate, double sportStrokeRate, double sportStrokeCount, double npcTime, int maxSpeed, double sportResistanceButton, double sportSpeedButton, double sportInclinationButton, List<double> buttonResistanceList, List<double> buttonSpeedList, List<double> buttonInclinationList, bool hasInclinationSupport, List<int> achievedTimeLevels, List<int> achievedDistanceLevels, List<int> achievedEnergyLevels, bool showTimeGoalDialog, bool showDistanceGoalDialog, bool showEnergyGoalDialog, int currentTimeGoalSec, double currentDistanceGoalKm, double currentEnergyGoalKcal
});




}
/// @nodoc
class __$QuickStartStateCopyWithImpl<$Res>
    implements _$QuickStartStateCopyWith<$Res> {
  __$QuickStartStateCopyWithImpl(this._self, this._then);

  final _QuickStartState _self;
  final $Res Function(_QuickStartState) _then;

/// Create a copy of QuickStartState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showPlayButton = null,Object? isPaused = null,Object? isInQuickPlay = null,Object? isPlaying = null,Object? isMusicPlaying = null,Object? realSportTime = null,Object? sportDistance = null,Object? sportEnergy = null,Object? sportSpeed = null,Object? sportCadence = null,Object? sportHeartRate = null,Object? sportStrokeRate = null,Object? sportStrokeCount = null,Object? npcTime = null,Object? maxSpeed = null,Object? sportResistanceButton = null,Object? sportSpeedButton = null,Object? sportInclinationButton = null,Object? buttonResistanceList = null,Object? buttonSpeedList = null,Object? buttonInclinationList = null,Object? hasInclinationSupport = null,Object? achievedTimeLevels = null,Object? achievedDistanceLevels = null,Object? achievedEnergyLevels = null,Object? showTimeGoalDialog = null,Object? showDistanceGoalDialog = null,Object? showEnergyGoalDialog = null,Object? currentTimeGoalSec = null,Object? currentDistanceGoalKm = null,Object? currentEnergyGoalKcal = null,}) {
  return _then(_QuickStartState(
showPlayButton: null == showPlayButton ? _self.showPlayButton : showPlayButton // ignore: cast_nullable_to_non_nullable
as bool,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,isInQuickPlay: null == isInQuickPlay ? _self.isInQuickPlay : isInQuickPlay // ignore: cast_nullable_to_non_nullable
as bool,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isMusicPlaying: null == isMusicPlaying ? _self.isMusicPlaying : isMusicPlaying // ignore: cast_nullable_to_non_nullable
as bool,realSportTime: null == realSportTime ? _self.realSportTime : realSportTime // ignore: cast_nullable_to_non_nullable
as int,sportDistance: null == sportDistance ? _self.sportDistance : sportDistance // ignore: cast_nullable_to_non_nullable
as double,sportEnergy: null == sportEnergy ? _self.sportEnergy : sportEnergy // ignore: cast_nullable_to_non_nullable
as double,sportSpeed: null == sportSpeed ? _self.sportSpeed : sportSpeed // ignore: cast_nullable_to_non_nullable
as double,sportCadence: null == sportCadence ? _self.sportCadence : sportCadence // ignore: cast_nullable_to_non_nullable
as double,sportHeartRate: null == sportHeartRate ? _self.sportHeartRate : sportHeartRate // ignore: cast_nullable_to_non_nullable
as int,sportStrokeRate: null == sportStrokeRate ? _self.sportStrokeRate : sportStrokeRate // ignore: cast_nullable_to_non_nullable
as double,sportStrokeCount: null == sportStrokeCount ? _self.sportStrokeCount : sportStrokeCount // ignore: cast_nullable_to_non_nullable
as double,npcTime: null == npcTime ? _self.npcTime : npcTime // ignore: cast_nullable_to_non_nullable
as double,maxSpeed: null == maxSpeed ? _self.maxSpeed : maxSpeed // ignore: cast_nullable_to_non_nullable
as int,sportResistanceButton: null == sportResistanceButton ? _self.sportResistanceButton : sportResistanceButton // ignore: cast_nullable_to_non_nullable
as double,sportSpeedButton: null == sportSpeedButton ? _self.sportSpeedButton : sportSpeedButton // ignore: cast_nullable_to_non_nullable
as double,sportInclinationButton: null == sportInclinationButton ? _self.sportInclinationButton : sportInclinationButton // ignore: cast_nullable_to_non_nullable
as double,buttonResistanceList: null == buttonResistanceList ? _self._buttonResistanceList : buttonResistanceList // ignore: cast_nullable_to_non_nullable
as List<double>,buttonSpeedList: null == buttonSpeedList ? _self._buttonSpeedList : buttonSpeedList // ignore: cast_nullable_to_non_nullable
as List<double>,buttonInclinationList: null == buttonInclinationList ? _self._buttonInclinationList : buttonInclinationList // ignore: cast_nullable_to_non_nullable
as List<double>,hasInclinationSupport: null == hasInclinationSupport ? _self.hasInclinationSupport : hasInclinationSupport // ignore: cast_nullable_to_non_nullable
as bool,achievedTimeLevels: null == achievedTimeLevels ? _self._achievedTimeLevels : achievedTimeLevels // ignore: cast_nullable_to_non_nullable
as List<int>,achievedDistanceLevels: null == achievedDistanceLevels ? _self._achievedDistanceLevels : achievedDistanceLevels // ignore: cast_nullable_to_non_nullable
as List<int>,achievedEnergyLevels: null == achievedEnergyLevels ? _self._achievedEnergyLevels : achievedEnergyLevels // ignore: cast_nullable_to_non_nullable
as List<int>,showTimeGoalDialog: null == showTimeGoalDialog ? _self.showTimeGoalDialog : showTimeGoalDialog // ignore: cast_nullable_to_non_nullable
as bool,showDistanceGoalDialog: null == showDistanceGoalDialog ? _self.showDistanceGoalDialog : showDistanceGoalDialog // ignore: cast_nullable_to_non_nullable
as bool,showEnergyGoalDialog: null == showEnergyGoalDialog ? _self.showEnergyGoalDialog : showEnergyGoalDialog // ignore: cast_nullable_to_non_nullable
as bool,currentTimeGoalSec: null == currentTimeGoalSec ? _self.currentTimeGoalSec : currentTimeGoalSec // ignore: cast_nullable_to_non_nullable
as int,currentDistanceGoalKm: null == currentDistanceGoalKm ? _self.currentDistanceGoalKm : currentDistanceGoalKm // ignore: cast_nullable_to_non_nullable
as double,currentEnergyGoalKcal: null == currentEnergyGoalKcal ? _self.currentEnergyGoalKcal : currentEnergyGoalKcal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
