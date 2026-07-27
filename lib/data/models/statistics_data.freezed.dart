// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StatisticsItem {

 int get calorie; int get duringTime; int get sportCount;
/// Create a copy of StatisticsItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatisticsItemCopyWith<StatisticsItem> get copyWith => _$StatisticsItemCopyWithImpl<StatisticsItem>(this as StatisticsItem, _$identity);

  /// Serializes this StatisticsItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatisticsItem&&(identical(other.calorie, calorie) || other.calorie == calorie)&&(identical(other.duringTime, duringTime) || other.duringTime == duringTime)&&(identical(other.sportCount, sportCount) || other.sportCount == sportCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,calorie,duringTime,sportCount);

@override
String toString() {
  return 'StatisticsItem(calorie: $calorie, duringTime: $duringTime, sportCount: $sportCount)';
}


}

/// @nodoc
abstract mixin class $StatisticsItemCopyWith<$Res>  {
  factory $StatisticsItemCopyWith(StatisticsItem value, $Res Function(StatisticsItem) _then) = _$StatisticsItemCopyWithImpl;
@useResult
$Res call({
 int calorie, int duringTime, int sportCount
});




}
/// @nodoc
class _$StatisticsItemCopyWithImpl<$Res>
    implements $StatisticsItemCopyWith<$Res> {
  _$StatisticsItemCopyWithImpl(this._self, this._then);

  final StatisticsItem _self;
  final $Res Function(StatisticsItem) _then;

/// Create a copy of StatisticsItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? calorie = null,Object? duringTime = null,Object? sportCount = null,}) {
  return _then(_self.copyWith(
calorie: null == calorie ? _self.calorie : calorie // ignore: cast_nullable_to_non_nullable
as int,duringTime: null == duringTime ? _self.duringTime : duringTime // ignore: cast_nullable_to_non_nullable
as int,sportCount: null == sportCount ? _self.sportCount : sportCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StatisticsItem].
extension StatisticsItemPatterns on StatisticsItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatisticsItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatisticsItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatisticsItem value)  $default,){
final _that = this;
switch (_that) {
case _StatisticsItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatisticsItem value)?  $default,){
final _that = this;
switch (_that) {
case _StatisticsItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int calorie,  int duringTime,  int sportCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatisticsItem() when $default != null:
return $default(_that.calorie,_that.duringTime,_that.sportCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int calorie,  int duringTime,  int sportCount)  $default,) {final _that = this;
switch (_that) {
case _StatisticsItem():
return $default(_that.calorie,_that.duringTime,_that.sportCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int calorie,  int duringTime,  int sportCount)?  $default,) {final _that = this;
switch (_that) {
case _StatisticsItem() when $default != null:
return $default(_that.calorie,_that.duringTime,_that.sportCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatisticsItem implements StatisticsItem {
  const _StatisticsItem({this.calorie = 0, this.duringTime = 0, this.sportCount = 0});
  factory _StatisticsItem.fromJson(Map<String, dynamic> json) => _$StatisticsItemFromJson(json);

@override@JsonKey() final  int calorie;
@override@JsonKey() final  int duringTime;
@override@JsonKey() final  int sportCount;

/// Create a copy of StatisticsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatisticsItemCopyWith<_StatisticsItem> get copyWith => __$StatisticsItemCopyWithImpl<_StatisticsItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatisticsItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatisticsItem&&(identical(other.calorie, calorie) || other.calorie == calorie)&&(identical(other.duringTime, duringTime) || other.duringTime == duringTime)&&(identical(other.sportCount, sportCount) || other.sportCount == sportCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,calorie,duringTime,sportCount);

@override
String toString() {
  return 'StatisticsItem(calorie: $calorie, duringTime: $duringTime, sportCount: $sportCount)';
}


}

/// @nodoc
abstract mixin class _$StatisticsItemCopyWith<$Res> implements $StatisticsItemCopyWith<$Res> {
  factory _$StatisticsItemCopyWith(_StatisticsItem value, $Res Function(_StatisticsItem) _then) = __$StatisticsItemCopyWithImpl;
@override @useResult
$Res call({
 int calorie, int duringTime, int sportCount
});




}
/// @nodoc
class __$StatisticsItemCopyWithImpl<$Res>
    implements _$StatisticsItemCopyWith<$Res> {
  __$StatisticsItemCopyWithImpl(this._self, this._then);

  final _StatisticsItem _self;
  final $Res Function(_StatisticsItem) _then;

/// Create a copy of StatisticsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? calorie = null,Object? duringTime = null,Object? sportCount = null,}) {
  return _then(_StatisticsItem(
calorie: null == calorie ? _self.calorie : calorie // ignore: cast_nullable_to_non_nullable
as int,duringTime: null == duringTime ? _self.duringTime : duringTime // ignore: cast_nullable_to_non_nullable
as int,sportCount: null == sportCount ? _self.sportCount : sportCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FitStatsData {

 String get code; List<StatisticsItem> get data;
/// Create a copy of FitStatsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FitStatsDataCopyWith<FitStatsData> get copyWith => _$FitStatsDataCopyWithImpl<FitStatsData>(this as FitStatsData, _$identity);

  /// Serializes this FitStatsData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FitStatsData&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'FitStatsData(code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class $FitStatsDataCopyWith<$Res>  {
  factory $FitStatsDataCopyWith(FitStatsData value, $Res Function(FitStatsData) _then) = _$FitStatsDataCopyWithImpl;
@useResult
$Res call({
 String code, List<StatisticsItem> data
});




}
/// @nodoc
class _$FitStatsDataCopyWithImpl<$Res>
    implements $FitStatsDataCopyWith<$Res> {
  _$FitStatsDataCopyWithImpl(this._self, this._then);

  final FitStatsData _self;
  final $Res Function(FitStatsData) _then;

/// Create a copy of FitStatsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? data = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<StatisticsItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [FitStatsData].
extension FitStatsDataPatterns on FitStatsData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FitStatsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FitStatsData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FitStatsData value)  $default,){
final _that = this;
switch (_that) {
case _FitStatsData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FitStatsData value)?  $default,){
final _that = this;
switch (_that) {
case _FitStatsData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  List<StatisticsItem> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FitStatsData() when $default != null:
return $default(_that.code,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  List<StatisticsItem> data)  $default,) {final _that = this;
switch (_that) {
case _FitStatsData():
return $default(_that.code,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  List<StatisticsItem> data)?  $default,) {final _that = this;
switch (_that) {
case _FitStatsData() when $default != null:
return $default(_that.code,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FitStatsData implements FitStatsData {
  const _FitStatsData({this.code = '', final  List<StatisticsItem> data = const []}): _data = data;
  factory _FitStatsData.fromJson(Map<String, dynamic> json) => _$FitStatsDataFromJson(json);

@override@JsonKey() final  String code;
 final  List<StatisticsItem> _data;
@override@JsonKey() List<StatisticsItem> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of FitStatsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FitStatsDataCopyWith<_FitStatsData> get copyWith => __$FitStatsDataCopyWithImpl<_FitStatsData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FitStatsDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FitStatsData&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'FitStatsData(code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class _$FitStatsDataCopyWith<$Res> implements $FitStatsDataCopyWith<$Res> {
  factory _$FitStatsDataCopyWith(_FitStatsData value, $Res Function(_FitStatsData) _then) = __$FitStatsDataCopyWithImpl;
@override @useResult
$Res call({
 String code, List<StatisticsItem> data
});




}
/// @nodoc
class __$FitStatsDataCopyWithImpl<$Res>
    implements _$FitStatsDataCopyWith<$Res> {
  __$FitStatsDataCopyWithImpl(this._self, this._then);

  final _FitStatsData _self;
  final $Res Function(_FitStatsData) _then;

/// Create a copy of FitStatsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? data = null,}) {
  return _then(_FitStatsData(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<StatisticsItem>,
  ));
}


}

// dart format on
