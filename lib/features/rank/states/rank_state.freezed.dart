// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rank_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RankState {

 RankDeviceType get deviceType; RankTimeRange get timeRange; bool get isLoading; List<RankLeaderboardEntity> get leaderboardList; String? get userNickName; String? get userHeadImage; String? get userRank; String? get userScore; String get errorMessage;
/// Create a copy of RankState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankStateCopyWith<RankState> get copyWith => _$RankStateCopyWithImpl<RankState>(this as RankState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankState&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.leaderboardList, leaderboardList)&&(identical(other.userNickName, userNickName) || other.userNickName == userNickName)&&(identical(other.userHeadImage, userHeadImage) || other.userHeadImage == userHeadImage)&&(identical(other.userRank, userRank) || other.userRank == userRank)&&(identical(other.userScore, userScore) || other.userScore == userScore)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,deviceType,timeRange,isLoading,const DeepCollectionEquality().hash(leaderboardList),userNickName,userHeadImage,userRank,userScore,errorMessage);

@override
String toString() {
  return 'RankState(deviceType: $deviceType, timeRange: $timeRange, isLoading: $isLoading, leaderboardList: $leaderboardList, userNickName: $userNickName, userHeadImage: $userHeadImage, userRank: $userRank, userScore: $userScore, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $RankStateCopyWith<$Res>  {
  factory $RankStateCopyWith(RankState value, $Res Function(RankState) _then) = _$RankStateCopyWithImpl;
@useResult
$Res call({
 RankDeviceType deviceType, RankTimeRange timeRange, bool isLoading, List<RankLeaderboardEntity> leaderboardList, String? userNickName, String? userHeadImage, String? userRank, String? userScore, String errorMessage
});




}
/// @nodoc
class _$RankStateCopyWithImpl<$Res>
    implements $RankStateCopyWith<$Res> {
  _$RankStateCopyWithImpl(this._self, this._then);

  final RankState _self;
  final $Res Function(RankState) _then;

/// Create a copy of RankState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceType = null,Object? timeRange = null,Object? isLoading = null,Object? leaderboardList = null,Object? userNickName = freezed,Object? userHeadImage = freezed,Object? userRank = freezed,Object? userScore = freezed,Object? errorMessage = null,}) {
  return _then(RankState(
deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as RankDeviceType,timeRange: null == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as RankTimeRange,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,leaderboardList: null == leaderboardList ? _self.leaderboardList : leaderboardList // ignore: cast_nullable_to_non_nullable
as List<RankLeaderboardEntity>,userNickName: freezed == userNickName ? _self.userNickName : userNickName // ignore: cast_nullable_to_non_nullable
as String?,userHeadImage: freezed == userHeadImage ? _self.userHeadImage : userHeadImage // ignore: cast_nullable_to_non_nullable
as String?,userRank: freezed == userRank ? _self.userRank : userRank // ignore: cast_nullable_to_non_nullable
as String?,userScore: freezed == userScore ? _self.userScore : userScore // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RankState].
extension RankStatePatterns on RankState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankState value)  $default,){
final _that = this;
switch (_that) {
case _RankState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankState value)?  $default,){
final _that = this;
switch (_that) {
case _RankState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RankDeviceType deviceType,  RankTimeRange timeRange,  bool isLoading,  List<RankLeaderboardEntity> leaderboardList,  String? userNickName,  String? userHeadImage,  String? userRank,  String? userScore,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankState() when $default != null:
return $default(_that.deviceType,_that.timeRange,_that.isLoading,_that.leaderboardList,_that.userNickName,_that.userHeadImage,_that.userRank,_that.userScore,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RankDeviceType deviceType,  RankTimeRange timeRange,  bool isLoading,  List<RankLeaderboardEntity> leaderboardList,  String? userNickName,  String? userHeadImage,  String? userRank,  String? userScore,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _RankState():
return $default(_that.deviceType,_that.timeRange,_that.isLoading,_that.leaderboardList,_that.userNickName,_that.userHeadImage,_that.userRank,_that.userScore,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RankDeviceType deviceType,  RankTimeRange timeRange,  bool isLoading,  List<RankLeaderboardEntity> leaderboardList,  String? userNickName,  String? userHeadImage,  String? userRank,  String? userScore,  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _RankState() when $default != null:
return $default(_that.deviceType,_that.timeRange,_that.isLoading,_that.leaderboardList,_that.userNickName,_that.userHeadImage,_that.userRank,_that.userScore,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _RankState implements RankState {
  const _RankState({this.deviceType = RankDeviceType.all, this.timeRange = RankTimeRange.total, this.isLoading = false,  List<RankLeaderboardEntity> leaderboardList = const [], this.userNickName, this.userHeadImage, this.userRank, this.userScore, this.errorMessage = ''}): _leaderboardList = leaderboardList;
  

@override@JsonKey() final  RankDeviceType deviceType;
@override@JsonKey() final  RankTimeRange timeRange;
@override@JsonKey() final  bool isLoading;
 final  List<RankLeaderboardEntity> _leaderboardList;
@override@JsonKey() List<RankLeaderboardEntity> get leaderboardList {
  if (_leaderboardList is EqualUnmodifiableListView) return _leaderboardList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_leaderboardList);
}

@override final  String? userNickName;
@override final  String? userHeadImage;
@override final  String? userRank;
@override final  String? userScore;
@override@JsonKey() final  String errorMessage;

/// Create a copy of RankState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankStateCopyWith<_RankState> get copyWith => __$RankStateCopyWithImpl<_RankState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankState&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._leaderboardList, _leaderboardList)&&(identical(other.userNickName, userNickName) || other.userNickName == userNickName)&&(identical(other.userHeadImage, userHeadImage) || other.userHeadImage == userHeadImage)&&(identical(other.userRank, userRank) || other.userRank == userRank)&&(identical(other.userScore, userScore) || other.userScore == userScore)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,deviceType,timeRange,isLoading,const DeepCollectionEquality().hash(_leaderboardList),userNickName,userHeadImage,userRank,userScore,errorMessage);

@override
String toString() {
  return 'RankState(deviceType: $deviceType, timeRange: $timeRange, isLoading: $isLoading, leaderboardList: $leaderboardList, userNickName: $userNickName, userHeadImage: $userHeadImage, userRank: $userRank, userScore: $userScore, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$RankStateCopyWith<$Res> implements $RankStateCopyWith<$Res> {
  factory _$RankStateCopyWith(_RankState value, $Res Function(_RankState) _then) = __$RankStateCopyWithImpl;
@override @useResult
$Res call({
 RankDeviceType deviceType, RankTimeRange timeRange, bool isLoading, List<RankLeaderboardEntity> leaderboardList, String? userNickName, String? userHeadImage, String? userRank, String? userScore, String errorMessage
});




}
/// @nodoc
class __$RankStateCopyWithImpl<$Res>
    implements _$RankStateCopyWith<$Res> {
  __$RankStateCopyWithImpl(this._self, this._then);

  final _RankState _self;
  final $Res Function(_RankState) _then;

/// Create a copy of RankState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceType = null,Object? timeRange = null,Object? isLoading = null,Object? leaderboardList = null,Object? userNickName = freezed,Object? userHeadImage = freezed,Object? userRank = freezed,Object? userScore = freezed,Object? errorMessage = null,}) {
  return _then(_RankState(
deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as RankDeviceType,timeRange: null == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as RankTimeRange,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,leaderboardList: null == leaderboardList ? _self._leaderboardList : leaderboardList // ignore: cast_nullable_to_non_nullable
as List<RankLeaderboardEntity>,userNickName: freezed == userNickName ? _self.userNickName : userNickName // ignore: cast_nullable_to_non_nullable
as String?,userHeadImage: freezed == userHeadImage ? _self.userHeadImage : userHeadImage // ignore: cast_nullable_to_non_nullable
as String?,userRank: freezed == userRank ? _self.userRank : userRank // ignore: cast_nullable_to_non_nullable
as String?,userScore: freezed == userScore ? _self.userScore : userScore // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
