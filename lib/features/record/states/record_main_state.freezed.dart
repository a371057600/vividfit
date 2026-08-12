// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_main_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecordMainState {

 List<RecordStatsItem> get weekStats; RecordStatsItem? get selectedDayStats; double get goalCalorie; int get goalDuration; double get goalStrength; double get bodyWeight; bool get isLoading; int get selectedDayIndex;
/// Create a copy of RecordMainState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordMainStateCopyWith<RecordMainState> get copyWith => _$RecordMainStateCopyWithImpl<RecordMainState>(this as RecordMainState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordMainState&&const DeepCollectionEquality().equals(other.weekStats, weekStats)&&(identical(other.selectedDayStats, selectedDayStats) || other.selectedDayStats == selectedDayStats)&&(identical(other.goalCalorie, goalCalorie) || other.goalCalorie == goalCalorie)&&(identical(other.goalDuration, goalDuration) || other.goalDuration == goalDuration)&&(identical(other.goalStrength, goalStrength) || other.goalStrength == goalStrength)&&(identical(other.bodyWeight, bodyWeight) || other.bodyWeight == bodyWeight)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.selectedDayIndex, selectedDayIndex) || other.selectedDayIndex == selectedDayIndex));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(weekStats),selectedDayStats,goalCalorie,goalDuration,goalStrength,bodyWeight,isLoading,selectedDayIndex);

@override
String toString() {
  return 'RecordMainState(weekStats: $weekStats, selectedDayStats: $selectedDayStats, goalCalorie: $goalCalorie, goalDuration: $goalDuration, goalStrength: $goalStrength, bodyWeight: $bodyWeight, isLoading: $isLoading, selectedDayIndex: $selectedDayIndex)';
}


}

/// @nodoc
abstract mixin class $RecordMainStateCopyWith<$Res>  {
  factory $RecordMainStateCopyWith(RecordMainState value, $Res Function(RecordMainState) _then) = _$RecordMainStateCopyWithImpl;
@useResult
$Res call({
 List<RecordStatsItem> weekStats, RecordStatsItem? selectedDayStats, double goalCalorie, int goalDuration, double goalStrength, double bodyWeight, bool isLoading, int selectedDayIndex
});


$RecordStatsItemCopyWith<$Res>? get selectedDayStats;

}
/// @nodoc
class _$RecordMainStateCopyWithImpl<$Res>
    implements $RecordMainStateCopyWith<$Res> {
  _$RecordMainStateCopyWithImpl(this._self, this._then);

  final RecordMainState _self;
  final $Res Function(RecordMainState) _then;

/// Create a copy of RecordMainState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekStats = null,Object? selectedDayStats = freezed,Object? goalCalorie = null,Object? goalDuration = null,Object? goalStrength = null,Object? bodyWeight = null,Object? isLoading = null,Object? selectedDayIndex = null,}) {
  return _then(RecordMainState(
weekStats: null == weekStats ? _self.weekStats : weekStats // ignore: cast_nullable_to_non_nullable
as List<RecordStatsItem>,selectedDayStats: freezed == selectedDayStats ? _self.selectedDayStats : selectedDayStats // ignore: cast_nullable_to_non_nullable
as RecordStatsItem?,goalCalorie: null == goalCalorie ? _self.goalCalorie : goalCalorie // ignore: cast_nullable_to_non_nullable
as double,goalDuration: null == goalDuration ? _self.goalDuration : goalDuration // ignore: cast_nullable_to_non_nullable
as int,goalStrength: null == goalStrength ? _self.goalStrength : goalStrength // ignore: cast_nullable_to_non_nullable
as double,bodyWeight: null == bodyWeight ? _self.bodyWeight : bodyWeight // ignore: cast_nullable_to_non_nullable
as double,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,selectedDayIndex: null == selectedDayIndex ? _self.selectedDayIndex : selectedDayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of RecordMainState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecordStatsItemCopyWith<$Res>? get selectedDayStats {
    if (_self.selectedDayStats == null) {
    return null;
  }

  return $RecordStatsItemCopyWith<$Res>(_self.selectedDayStats!, (value) {
    return _then(_self.copyWith(selectedDayStats: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecordMainState].
extension RecordMainStatePatterns on RecordMainState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordMainState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordMainState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordMainState value)  $default,){
final _that = this;
switch (_that) {
case _RecordMainState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordMainState value)?  $default,){
final _that = this;
switch (_that) {
case _RecordMainState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RecordStatsItem> weekStats,  RecordStatsItem? selectedDayStats,  double goalCalorie,  int goalDuration,  double goalStrength,  double bodyWeight,  bool isLoading,  int selectedDayIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordMainState() when $default != null:
return $default(_that.weekStats,_that.selectedDayStats,_that.goalCalorie,_that.goalDuration,_that.goalStrength,_that.bodyWeight,_that.isLoading,_that.selectedDayIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RecordStatsItem> weekStats,  RecordStatsItem? selectedDayStats,  double goalCalorie,  int goalDuration,  double goalStrength,  double bodyWeight,  bool isLoading,  int selectedDayIndex)  $default,) {final _that = this;
switch (_that) {
case _RecordMainState():
return $default(_that.weekStats,_that.selectedDayStats,_that.goalCalorie,_that.goalDuration,_that.goalStrength,_that.bodyWeight,_that.isLoading,_that.selectedDayIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RecordStatsItem> weekStats,  RecordStatsItem? selectedDayStats,  double goalCalorie,  int goalDuration,  double goalStrength,  double bodyWeight,  bool isLoading,  int selectedDayIndex)?  $default,) {final _that = this;
switch (_that) {
case _RecordMainState() when $default != null:
return $default(_that.weekStats,_that.selectedDayStats,_that.goalCalorie,_that.goalDuration,_that.goalStrength,_that.bodyWeight,_that.isLoading,_that.selectedDayIndex);case _:
  return null;

}
}

}

/// @nodoc


class _RecordMainState implements RecordMainState {
  const _RecordMainState({ List<RecordStatsItem> weekStats = const [], this.selectedDayStats, this.goalCalorie = 0.0, this.goalDuration = 50, this.goalStrength = 3.0, this.bodyWeight = 70.0, this.isLoading = true, this.selectedDayIndex = 0}): _weekStats = weekStats;
  

 final  List<RecordStatsItem> _weekStats;
@override@JsonKey() List<RecordStatsItem> get weekStats {
  if (_weekStats is EqualUnmodifiableListView) return _weekStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekStats);
}

@override final  RecordStatsItem? selectedDayStats;
@override@JsonKey() final  double goalCalorie;
@override@JsonKey() final  int goalDuration;
@override@JsonKey() final  double goalStrength;
@override@JsonKey() final  double bodyWeight;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  int selectedDayIndex;

/// Create a copy of RecordMainState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordMainStateCopyWith<_RecordMainState> get copyWith => __$RecordMainStateCopyWithImpl<_RecordMainState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordMainState&&const DeepCollectionEquality().equals(other._weekStats, _weekStats)&&(identical(other.selectedDayStats, selectedDayStats) || other.selectedDayStats == selectedDayStats)&&(identical(other.goalCalorie, goalCalorie) || other.goalCalorie == goalCalorie)&&(identical(other.goalDuration, goalDuration) || other.goalDuration == goalDuration)&&(identical(other.goalStrength, goalStrength) || other.goalStrength == goalStrength)&&(identical(other.bodyWeight, bodyWeight) || other.bodyWeight == bodyWeight)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.selectedDayIndex, selectedDayIndex) || other.selectedDayIndex == selectedDayIndex));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_weekStats),selectedDayStats,goalCalorie,goalDuration,goalStrength,bodyWeight,isLoading,selectedDayIndex);

@override
String toString() {
  return 'RecordMainState(weekStats: $weekStats, selectedDayStats: $selectedDayStats, goalCalorie: $goalCalorie, goalDuration: $goalDuration, goalStrength: $goalStrength, bodyWeight: $bodyWeight, isLoading: $isLoading, selectedDayIndex: $selectedDayIndex)';
}


}

/// @nodoc
abstract mixin class _$RecordMainStateCopyWith<$Res> implements $RecordMainStateCopyWith<$Res> {
  factory _$RecordMainStateCopyWith(_RecordMainState value, $Res Function(_RecordMainState) _then) = __$RecordMainStateCopyWithImpl;
@override @useResult
$Res call({
 List<RecordStatsItem> weekStats, RecordStatsItem? selectedDayStats, double goalCalorie, int goalDuration, double goalStrength, double bodyWeight, bool isLoading, int selectedDayIndex
});


@override $RecordStatsItemCopyWith<$Res>? get selectedDayStats;

}
/// @nodoc
class __$RecordMainStateCopyWithImpl<$Res>
    implements _$RecordMainStateCopyWith<$Res> {
  __$RecordMainStateCopyWithImpl(this._self, this._then);

  final _RecordMainState _self;
  final $Res Function(_RecordMainState) _then;

/// Create a copy of RecordMainState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekStats = null,Object? selectedDayStats = freezed,Object? goalCalorie = null,Object? goalDuration = null,Object? goalStrength = null,Object? bodyWeight = null,Object? isLoading = null,Object? selectedDayIndex = null,}) {
  return _then(_RecordMainState(
weekStats: null == weekStats ? _self._weekStats : weekStats // ignore: cast_nullable_to_non_nullable
as List<RecordStatsItem>,selectedDayStats: freezed == selectedDayStats ? _self.selectedDayStats : selectedDayStats // ignore: cast_nullable_to_non_nullable
as RecordStatsItem?,goalCalorie: null == goalCalorie ? _self.goalCalorie : goalCalorie // ignore: cast_nullable_to_non_nullable
as double,goalDuration: null == goalDuration ? _self.goalDuration : goalDuration // ignore: cast_nullable_to_non_nullable
as int,goalStrength: null == goalStrength ? _self.goalStrength : goalStrength // ignore: cast_nullable_to_non_nullable
as double,bodyWeight: null == bodyWeight ? _self.bodyWeight : bodyWeight // ignore: cast_nullable_to_non_nullable
as double,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,selectedDayIndex: null == selectedDayIndex ? _self.selectedDayIndex : selectedDayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of RecordMainState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecordStatsItemCopyWith<$Res>? get selectedDayStats {
    if (_self.selectedDayStats == null) {
    return null;
  }

  return $RecordStatsItemCopyWith<$Res>(_self.selectedDayStats!, (value) {
    return _then(_self.copyWith(selectedDayStats: value));
  });
}
}

// dart format on
