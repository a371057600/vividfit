// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecordListState {

 List<SportHistory> get historyList; Map<int, List<SportHistory>> get groupedData; RecordEquipmentType get equipmentType; int get year; int get totalCount; int get totalDuration; double get totalCalorie; bool get isLoading;
/// Create a copy of RecordListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordListStateCopyWith<RecordListState> get copyWith => _$RecordListStateCopyWithImpl<RecordListState>(this as RecordListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordListState&&const DeepCollectionEquality().equals(other.historyList, historyList)&&const DeepCollectionEquality().equals(other.groupedData, groupedData)&&(identical(other.equipmentType, equipmentType) || other.equipmentType == equipmentType)&&(identical(other.year, year) || other.year == year)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&(identical(other.totalCalorie, totalCalorie) || other.totalCalorie == totalCalorie)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(historyList),const DeepCollectionEquality().hash(groupedData),equipmentType,year,totalCount,totalDuration,totalCalorie,isLoading);

@override
String toString() {
  return 'RecordListState(historyList: $historyList, groupedData: $groupedData, equipmentType: $equipmentType, year: $year, totalCount: $totalCount, totalDuration: $totalDuration, totalCalorie: $totalCalorie, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $RecordListStateCopyWith<$Res>  {
  factory $RecordListStateCopyWith(RecordListState value, $Res Function(RecordListState) _then) = _$RecordListStateCopyWithImpl;
@useResult
$Res call({
 List<SportHistory> historyList, Map<int, List<SportHistory>> groupedData, RecordEquipmentType equipmentType, int year, int totalCount, int totalDuration, double totalCalorie, bool isLoading
});




}
/// @nodoc
class _$RecordListStateCopyWithImpl<$Res>
    implements $RecordListStateCopyWith<$Res> {
  _$RecordListStateCopyWithImpl(this._self, this._then);

  final RecordListState _self;
  final $Res Function(RecordListState) _then;

/// Create a copy of RecordListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? historyList = null,Object? groupedData = null,Object? equipmentType = null,Object? year = null,Object? totalCount = null,Object? totalDuration = null,Object? totalCalorie = null,Object? isLoading = null,}) {
  return _then(RecordListState(
historyList: null == historyList ? _self.historyList : historyList // ignore: cast_nullable_to_non_nullable
as List<SportHistory>,groupedData: null == groupedData ? _self.groupedData : groupedData // ignore: cast_nullable_to_non_nullable
as Map<int, List<SportHistory>>,equipmentType: null == equipmentType ? _self.equipmentType : equipmentType // ignore: cast_nullable_to_non_nullable
as RecordEquipmentType,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,totalDuration: null == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as int,totalCalorie: null == totalCalorie ? _self.totalCalorie : totalCalorie // ignore: cast_nullable_to_non_nullable
as double,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RecordListState].
extension RecordListStatePatterns on RecordListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordListState value)  $default,){
final _that = this;
switch (_that) {
case _RecordListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordListState value)?  $default,){
final _that = this;
switch (_that) {
case _RecordListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SportHistory> historyList,  Map<int, List<SportHistory>> groupedData,  RecordEquipmentType equipmentType,  int year,  int totalCount,  int totalDuration,  double totalCalorie,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordListState() when $default != null:
return $default(_that.historyList,_that.groupedData,_that.equipmentType,_that.year,_that.totalCount,_that.totalDuration,_that.totalCalorie,_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SportHistory> historyList,  Map<int, List<SportHistory>> groupedData,  RecordEquipmentType equipmentType,  int year,  int totalCount,  int totalDuration,  double totalCalorie,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _RecordListState():
return $default(_that.historyList,_that.groupedData,_that.equipmentType,_that.year,_that.totalCount,_that.totalDuration,_that.totalCalorie,_that.isLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SportHistory> historyList,  Map<int, List<SportHistory>> groupedData,  RecordEquipmentType equipmentType,  int year,  int totalCount,  int totalDuration,  double totalCalorie,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _RecordListState() when $default != null:
return $default(_that.historyList,_that.groupedData,_that.equipmentType,_that.year,_that.totalCount,_that.totalDuration,_that.totalCalorie,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _RecordListState implements RecordListState {
  const _RecordListState({ List<SportHistory> historyList = const [],  Map<int, List<SportHistory>> groupedData = const {}, this.equipmentType = RecordEquipmentType.all, this.year = 2026, this.totalCount = 0, this.totalDuration = 0, this.totalCalorie = 0.0, this.isLoading = true}): _historyList = historyList,_groupedData = groupedData;
  

 final  List<SportHistory> _historyList;
@override@JsonKey() List<SportHistory> get historyList {
  if (_historyList is EqualUnmodifiableListView) return _historyList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_historyList);
}

 final  Map<int, List<SportHistory>> _groupedData;
@override@JsonKey() Map<int, List<SportHistory>> get groupedData {
  if (_groupedData is EqualUnmodifiableMapView) return _groupedData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_groupedData);
}

@override@JsonKey() final  RecordEquipmentType equipmentType;
@override@JsonKey() final  int year;
@override@JsonKey() final  int totalCount;
@override@JsonKey() final  int totalDuration;
@override@JsonKey() final  double totalCalorie;
@override@JsonKey() final  bool isLoading;

/// Create a copy of RecordListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordListStateCopyWith<_RecordListState> get copyWith => __$RecordListStateCopyWithImpl<_RecordListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordListState&&const DeepCollectionEquality().equals(other._historyList, _historyList)&&const DeepCollectionEquality().equals(other._groupedData, _groupedData)&&(identical(other.equipmentType, equipmentType) || other.equipmentType == equipmentType)&&(identical(other.year, year) || other.year == year)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&(identical(other.totalCalorie, totalCalorie) || other.totalCalorie == totalCalorie)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_historyList),const DeepCollectionEquality().hash(_groupedData),equipmentType,year,totalCount,totalDuration,totalCalorie,isLoading);

@override
String toString() {
  return 'RecordListState(historyList: $historyList, groupedData: $groupedData, equipmentType: $equipmentType, year: $year, totalCount: $totalCount, totalDuration: $totalDuration, totalCalorie: $totalCalorie, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$RecordListStateCopyWith<$Res> implements $RecordListStateCopyWith<$Res> {
  factory _$RecordListStateCopyWith(_RecordListState value, $Res Function(_RecordListState) _then) = __$RecordListStateCopyWithImpl;
@override @useResult
$Res call({
 List<SportHistory> historyList, Map<int, List<SportHistory>> groupedData, RecordEquipmentType equipmentType, int year, int totalCount, int totalDuration, double totalCalorie, bool isLoading
});




}
/// @nodoc
class __$RecordListStateCopyWithImpl<$Res>
    implements _$RecordListStateCopyWith<$Res> {
  __$RecordListStateCopyWithImpl(this._self, this._then);

  final _RecordListState _self;
  final $Res Function(_RecordListState) _then;

/// Create a copy of RecordListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? historyList = null,Object? groupedData = null,Object? equipmentType = null,Object? year = null,Object? totalCount = null,Object? totalDuration = null,Object? totalCalorie = null,Object? isLoading = null,}) {
  return _then(_RecordListState(
historyList: null == historyList ? _self._historyList : historyList // ignore: cast_nullable_to_non_nullable
as List<SportHistory>,groupedData: null == groupedData ? _self._groupedData : groupedData // ignore: cast_nullable_to_non_nullable
as Map<int, List<SportHistory>>,equipmentType: null == equipmentType ? _self.equipmentType : equipmentType // ignore: cast_nullable_to_non_nullable
as RecordEquipmentType,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,totalDuration: null == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as int,totalCalorie: null == totalCalorie ? _self.totalCalorie : totalCalorie // ignore: cast_nullable_to_non_nullable
as double,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
