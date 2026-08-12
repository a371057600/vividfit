// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_stats_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecordStatsItem {

 int get sportCount; double get calorie; int get duringTime; double get sportStrength; String? get startTime; String? get endTime;
/// Create a copy of RecordStatsItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordStatsItemCopyWith<RecordStatsItem> get copyWith => _$RecordStatsItemCopyWithImpl<RecordStatsItem>(this as RecordStatsItem, _$identity);

  /// Serializes this RecordStatsItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordStatsItem&&(identical(other.sportCount, sportCount) || other.sportCount == sportCount)&&(identical(other.calorie, calorie) || other.calorie == calorie)&&(identical(other.duringTime, duringTime) || other.duringTime == duringTime)&&(identical(other.sportStrength, sportStrength) || other.sportStrength == sportStrength)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sportCount,calorie,duringTime,sportStrength,startTime,endTime);

@override
String toString() {
  return 'RecordStatsItem(sportCount: $sportCount, calorie: $calorie, duringTime: $duringTime, sportStrength: $sportStrength, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $RecordStatsItemCopyWith<$Res>  {
  factory $RecordStatsItemCopyWith(RecordStatsItem value, $Res Function(RecordStatsItem) _then) = _$RecordStatsItemCopyWithImpl;
@useResult
$Res call({
 int sportCount, double calorie, int duringTime, double sportStrength, String? startTime, String? endTime
});




}
/// @nodoc
class _$RecordStatsItemCopyWithImpl<$Res>
    implements $RecordStatsItemCopyWith<$Res> {
  _$RecordStatsItemCopyWithImpl(this._self, this._then);

  final RecordStatsItem _self;
  final $Res Function(RecordStatsItem) _then;

/// Create a copy of RecordStatsItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sportCount = null,Object? calorie = null,Object? duringTime = null,Object? sportStrength = null,Object? startTime = freezed,Object? endTime = freezed,}) {
  return _then(RecordStatsItem(
sportCount: null == sportCount ? _self.sportCount : sportCount // ignore: cast_nullable_to_non_nullable
as int,calorie: null == calorie ? _self.calorie : calorie // ignore: cast_nullable_to_non_nullable
as double,duringTime: null == duringTime ? _self.duringTime : duringTime // ignore: cast_nullable_to_non_nullable
as int,sportStrength: null == sportStrength ? _self.sportStrength : sportStrength // ignore: cast_nullable_to_non_nullable
as double,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecordStatsItem].
extension RecordStatsItemPatterns on RecordStatsItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordStatsItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordStatsItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordStatsItem value)  $default,){
final _that = this;
switch (_that) {
case _RecordStatsItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordStatsItem value)?  $default,){
final _that = this;
switch (_that) {
case _RecordStatsItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sportCount,  double calorie,  int duringTime,  double sportStrength,  String? startTime,  String? endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordStatsItem() when $default != null:
return $default(_that.sportCount,_that.calorie,_that.duringTime,_that.sportStrength,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sportCount,  double calorie,  int duringTime,  double sportStrength,  String? startTime,  String? endTime)  $default,) {final _that = this;
switch (_that) {
case _RecordStatsItem():
return $default(_that.sportCount,_that.calorie,_that.duringTime,_that.sportStrength,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sportCount,  double calorie,  int duringTime,  double sportStrength,  String? startTime,  String? endTime)?  $default,) {final _that = this;
switch (_that) {
case _RecordStatsItem() when $default != null:
return $default(_that.sportCount,_that.calorie,_that.duringTime,_that.sportStrength,_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecordStatsItem implements RecordStatsItem {
  const _RecordStatsItem({required this.sportCount, required this.calorie, required this.duringTime, required this.sportStrength, this.startTime, this.endTime});
  factory _RecordStatsItem.fromJson(Map<String, dynamic> json) => _$RecordStatsItemFromJson(json);

@override final  int sportCount;
@override final  double calorie;
@override final  int duringTime;
@override final  double sportStrength;
@override final  String? startTime;
@override final  String? endTime;

/// Create a copy of RecordStatsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordStatsItemCopyWith<_RecordStatsItem> get copyWith => __$RecordStatsItemCopyWithImpl<_RecordStatsItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecordStatsItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordStatsItem&&(identical(other.sportCount, sportCount) || other.sportCount == sportCount)&&(identical(other.calorie, calorie) || other.calorie == calorie)&&(identical(other.duringTime, duringTime) || other.duringTime == duringTime)&&(identical(other.sportStrength, sportStrength) || other.sportStrength == sportStrength)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sportCount,calorie,duringTime,sportStrength,startTime,endTime);

@override
String toString() {
  return 'RecordStatsItem(sportCount: $sportCount, calorie: $calorie, duringTime: $duringTime, sportStrength: $sportStrength, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$RecordStatsItemCopyWith<$Res> implements $RecordStatsItemCopyWith<$Res> {
  factory _$RecordStatsItemCopyWith(_RecordStatsItem value, $Res Function(_RecordStatsItem) _then) = __$RecordStatsItemCopyWithImpl;
@override @useResult
$Res call({
 int sportCount, double calorie, int duringTime, double sportStrength, String? startTime, String? endTime
});




}
/// @nodoc
class __$RecordStatsItemCopyWithImpl<$Res>
    implements _$RecordStatsItemCopyWith<$Res> {
  __$RecordStatsItemCopyWithImpl(this._self, this._then);

  final _RecordStatsItem _self;
  final $Res Function(_RecordStatsItem) _then;

/// Create a copy of RecordStatsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sportCount = null,Object? calorie = null,Object? duringTime = null,Object? sportStrength = null,Object? startTime = freezed,Object? endTime = freezed,}) {
  return _then(_RecordStatsItem(
sportCount: null == sportCount ? _self.sportCount : sportCount // ignore: cast_nullable_to_non_nullable
as int,calorie: null == calorie ? _self.calorie : calorie // ignore: cast_nullable_to_non_nullable
as double,duringTime: null == duringTime ? _self.duringTime : duringTime // ignore: cast_nullable_to_non_nullable
as int,sportStrength: null == sportStrength ? _self.sportStrength : sportStrength // ignore: cast_nullable_to_non_nullable
as double,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RecordStatsResponse {

 String get code; List<RecordStatsItem> get data;
/// Create a copy of RecordStatsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordStatsResponseCopyWith<RecordStatsResponse> get copyWith => _$RecordStatsResponseCopyWithImpl<RecordStatsResponse>(this as RecordStatsResponse, _$identity);

  /// Serializes this RecordStatsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordStatsResponse&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'RecordStatsResponse(code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class $RecordStatsResponseCopyWith<$Res>  {
  factory $RecordStatsResponseCopyWith(RecordStatsResponse value, $Res Function(RecordStatsResponse) _then) = _$RecordStatsResponseCopyWithImpl;
@useResult
$Res call({
 String code, List<RecordStatsItem> data
});




}
/// @nodoc
class _$RecordStatsResponseCopyWithImpl<$Res>
    implements $RecordStatsResponseCopyWith<$Res> {
  _$RecordStatsResponseCopyWithImpl(this._self, this._then);

  final RecordStatsResponse _self;
  final $Res Function(RecordStatsResponse) _then;

/// Create a copy of RecordStatsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? data = null,}) {
  return _then(RecordStatsResponse(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<RecordStatsItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [RecordStatsResponse].
extension RecordStatsResponsePatterns on RecordStatsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordStatsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordStatsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordStatsResponse value)  $default,){
final _that = this;
switch (_that) {
case _RecordStatsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordStatsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RecordStatsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  List<RecordStatsItem> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordStatsResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  List<RecordStatsItem> data)  $default,) {final _that = this;
switch (_that) {
case _RecordStatsResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  List<RecordStatsItem> data)?  $default,) {final _that = this;
switch (_that) {
case _RecordStatsResponse() when $default != null:
return $default(_that.code,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecordStatsResponse implements RecordStatsResponse {
  const _RecordStatsResponse({required this.code, required  List<RecordStatsItem> data}): _data = data;
  factory _RecordStatsResponse.fromJson(Map<String, dynamic> json) => _$RecordStatsResponseFromJson(json);

@override final  String code;
 final  List<RecordStatsItem> _data;
@override List<RecordStatsItem> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of RecordStatsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordStatsResponseCopyWith<_RecordStatsResponse> get copyWith => __$RecordStatsResponseCopyWithImpl<_RecordStatsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecordStatsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordStatsResponse&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'RecordStatsResponse(code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class _$RecordStatsResponseCopyWith<$Res> implements $RecordStatsResponseCopyWith<$Res> {
  factory _$RecordStatsResponseCopyWith(_RecordStatsResponse value, $Res Function(_RecordStatsResponse) _then) = __$RecordStatsResponseCopyWithImpl;
@override @useResult
$Res call({
 String code, List<RecordStatsItem> data
});




}
/// @nodoc
class __$RecordStatsResponseCopyWithImpl<$Res>
    implements _$RecordStatsResponseCopyWith<$Res> {
  __$RecordStatsResponseCopyWithImpl(this._self, this._then);

  final _RecordStatsResponse _self;
  final $Res Function(_RecordStatsResponse) _then;

/// Create a copy of RecordStatsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? data = null,}) {
  return _then(_RecordStatsResponse(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<RecordStatsItem>,
  ));
}


}

// dart format on
