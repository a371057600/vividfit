// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gym_course_play_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GymTopDataItem {

 String get iconPath; String get label; String get value;
/// Create a copy of GymTopDataItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GymTopDataItemCopyWith<GymTopDataItem> get copyWith => _$GymTopDataItemCopyWithImpl<GymTopDataItem>(this as GymTopDataItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GymTopDataItem&&(identical(other.iconPath, iconPath) || other.iconPath == iconPath)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,iconPath,label,value);

@override
String toString() {
  return 'GymTopDataItem(iconPath: $iconPath, label: $label, value: $value)';
}


}

/// @nodoc
abstract mixin class $GymTopDataItemCopyWith<$Res>  {
  factory $GymTopDataItemCopyWith(GymTopDataItem value, $Res Function(GymTopDataItem) _then) = _$GymTopDataItemCopyWithImpl;
@useResult
$Res call({
 String iconPath, String label, String value
});




}
/// @nodoc
class _$GymTopDataItemCopyWithImpl<$Res>
    implements $GymTopDataItemCopyWith<$Res> {
  _$GymTopDataItemCopyWithImpl(this._self, this._then);

  final GymTopDataItem _self;
  final $Res Function(GymTopDataItem) _then;

/// Create a copy of GymTopDataItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? iconPath = null,Object? label = null,Object? value = null,}) {
  return _then(GymTopDataItem(
iconPath: null == iconPath ? _self.iconPath : iconPath // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GymTopDataItem].
extension GymTopDataItemPatterns on GymTopDataItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GymTopDataItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GymTopDataItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GymTopDataItem value)  $default,){
final _that = this;
switch (_that) {
case _GymTopDataItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GymTopDataItem value)?  $default,){
final _that = this;
switch (_that) {
case _GymTopDataItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String iconPath,  String label,  String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GymTopDataItem() when $default != null:
return $default(_that.iconPath,_that.label,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String iconPath,  String label,  String value)  $default,) {final _that = this;
switch (_that) {
case _GymTopDataItem():
return $default(_that.iconPath,_that.label,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String iconPath,  String label,  String value)?  $default,) {final _that = this;
switch (_that) {
case _GymTopDataItem() when $default != null:
return $default(_that.iconPath,_that.label,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _GymTopDataItem implements GymTopDataItem {
  const _GymTopDataItem({required this.iconPath, required this.label, required this.value});
  

@override final  String iconPath;
@override final  String label;
@override final  String value;

/// Create a copy of GymTopDataItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GymTopDataItemCopyWith<_GymTopDataItem> get copyWith => __$GymTopDataItemCopyWithImpl<_GymTopDataItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GymTopDataItem&&(identical(other.iconPath, iconPath) || other.iconPath == iconPath)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,iconPath,label,value);

@override
String toString() {
  return 'GymTopDataItem(iconPath: $iconPath, label: $label, value: $value)';
}


}

/// @nodoc
abstract mixin class _$GymTopDataItemCopyWith<$Res> implements $GymTopDataItemCopyWith<$Res> {
  factory _$GymTopDataItemCopyWith(_GymTopDataItem value, $Res Function(_GymTopDataItem) _then) = __$GymTopDataItemCopyWithImpl;
@override @useResult
$Res call({
 String iconPath, String label, String value
});




}
/// @nodoc
class __$GymTopDataItemCopyWithImpl<$Res>
    implements _$GymTopDataItemCopyWith<$Res> {
  __$GymTopDataItemCopyWithImpl(this._self, this._then);

  final _GymTopDataItem _self;
  final $Res Function(_GymTopDataItem) _then;

/// Create a copy of GymTopDataItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? iconPath = null,Object? label = null,Object? value = null,}) {
  return _then(_GymTopDataItem(
iconPath: null == iconPath ? _self.iconPath : iconPath // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$GymFinishDataItem {

 String get iconPath; String get title; String get value; String get unit;
/// Create a copy of GymFinishDataItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GymFinishDataItemCopyWith<GymFinishDataItem> get copyWith => _$GymFinishDataItemCopyWithImpl<GymFinishDataItem>(this as GymFinishDataItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GymFinishDataItem&&(identical(other.iconPath, iconPath) || other.iconPath == iconPath)&&(identical(other.title, title) || other.title == title)&&(identical(other.value, value) || other.value == value)&&(identical(other.unit, unit) || other.unit == unit));
}


@override
int get hashCode => Object.hash(runtimeType,iconPath,title,value,unit);

@override
String toString() {
  return 'GymFinishDataItem(iconPath: $iconPath, title: $title, value: $value, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $GymFinishDataItemCopyWith<$Res>  {
  factory $GymFinishDataItemCopyWith(GymFinishDataItem value, $Res Function(GymFinishDataItem) _then) = _$GymFinishDataItemCopyWithImpl;
@useResult
$Res call({
 String iconPath, String title, String value, String unit
});




}
/// @nodoc
class _$GymFinishDataItemCopyWithImpl<$Res>
    implements $GymFinishDataItemCopyWith<$Res> {
  _$GymFinishDataItemCopyWithImpl(this._self, this._then);

  final GymFinishDataItem _self;
  final $Res Function(GymFinishDataItem) _then;

/// Create a copy of GymFinishDataItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? iconPath = null,Object? title = null,Object? value = null,Object? unit = null,}) {
  return _then(GymFinishDataItem(
iconPath: null == iconPath ? _self.iconPath : iconPath // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GymFinishDataItem].
extension GymFinishDataItemPatterns on GymFinishDataItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GymFinishDataItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GymFinishDataItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GymFinishDataItem value)  $default,){
final _that = this;
switch (_that) {
case _GymFinishDataItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GymFinishDataItem value)?  $default,){
final _that = this;
switch (_that) {
case _GymFinishDataItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String iconPath,  String title,  String value,  String unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GymFinishDataItem() when $default != null:
return $default(_that.iconPath,_that.title,_that.value,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String iconPath,  String title,  String value,  String unit)  $default,) {final _that = this;
switch (_that) {
case _GymFinishDataItem():
return $default(_that.iconPath,_that.title,_that.value,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String iconPath,  String title,  String value,  String unit)?  $default,) {final _that = this;
switch (_that) {
case _GymFinishDataItem() when $default != null:
return $default(_that.iconPath,_that.title,_that.value,_that.unit);case _:
  return null;

}
}

}

/// @nodoc


class _GymFinishDataItem implements GymFinishDataItem {
  const _GymFinishDataItem({required this.iconPath, required this.title, required this.value, required this.unit});
  

@override final  String iconPath;
@override final  String title;
@override final  String value;
@override final  String unit;

/// Create a copy of GymFinishDataItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GymFinishDataItemCopyWith<_GymFinishDataItem> get copyWith => __$GymFinishDataItemCopyWithImpl<_GymFinishDataItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GymFinishDataItem&&(identical(other.iconPath, iconPath) || other.iconPath == iconPath)&&(identical(other.title, title) || other.title == title)&&(identical(other.value, value) || other.value == value)&&(identical(other.unit, unit) || other.unit == unit));
}


@override
int get hashCode => Object.hash(runtimeType,iconPath,title,value,unit);

@override
String toString() {
  return 'GymFinishDataItem(iconPath: $iconPath, title: $title, value: $value, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$GymFinishDataItemCopyWith<$Res> implements $GymFinishDataItemCopyWith<$Res> {
  factory _$GymFinishDataItemCopyWith(_GymFinishDataItem value, $Res Function(_GymFinishDataItem) _then) = __$GymFinishDataItemCopyWithImpl;
@override @useResult
$Res call({
 String iconPath, String title, String value, String unit
});




}
/// @nodoc
class __$GymFinishDataItemCopyWithImpl<$Res>
    implements _$GymFinishDataItemCopyWith<$Res> {
  __$GymFinishDataItemCopyWithImpl(this._self, this._then);

  final _GymFinishDataItem _self;
  final $Res Function(_GymFinishDataItem) _then;

/// Create a copy of GymFinishDataItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? iconPath = null,Object? title = null,Object? value = null,Object? unit = null,}) {
  return _then(_GymFinishDataItem(
iconPath: null == iconPath ? _self.iconPath : iconPath // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$GymRatingItem {

 String get title; int get score;
/// Create a copy of GymRatingItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GymRatingItemCopyWith<GymRatingItem> get copyWith => _$GymRatingItemCopyWithImpl<GymRatingItem>(this as GymRatingItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GymRatingItem&&(identical(other.title, title) || other.title == title)&&(identical(other.score, score) || other.score == score));
}


@override
int get hashCode => Object.hash(runtimeType,title,score);

@override
String toString() {
  return 'GymRatingItem(title: $title, score: $score)';
}


}

/// @nodoc
abstract mixin class $GymRatingItemCopyWith<$Res>  {
  factory $GymRatingItemCopyWith(GymRatingItem value, $Res Function(GymRatingItem) _then) = _$GymRatingItemCopyWithImpl;
@useResult
$Res call({
 String title, int score
});




}
/// @nodoc
class _$GymRatingItemCopyWithImpl<$Res>
    implements $GymRatingItemCopyWith<$Res> {
  _$GymRatingItemCopyWithImpl(this._self, this._then);

  final GymRatingItem _self;
  final $Res Function(GymRatingItem) _then;

/// Create a copy of GymRatingItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? score = null,}) {
  return _then(GymRatingItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GymRatingItem].
extension GymRatingItemPatterns on GymRatingItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GymRatingItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GymRatingItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GymRatingItem value)  $default,){
final _that = this;
switch (_that) {
case _GymRatingItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GymRatingItem value)?  $default,){
final _that = this;
switch (_that) {
case _GymRatingItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  int score)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GymRatingItem() when $default != null:
return $default(_that.title,_that.score);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  int score)  $default,) {final _that = this;
switch (_that) {
case _GymRatingItem():
return $default(_that.title,_that.score);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  int score)?  $default,) {final _that = this;
switch (_that) {
case _GymRatingItem() when $default != null:
return $default(_that.title,_that.score);case _:
  return null;

}
}

}

/// @nodoc


class _GymRatingItem implements GymRatingItem {
  const _GymRatingItem({required this.title, required this.score});
  

@override final  String title;
@override final  int score;

/// Create a copy of GymRatingItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GymRatingItemCopyWith<_GymRatingItem> get copyWith => __$GymRatingItemCopyWithImpl<_GymRatingItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GymRatingItem&&(identical(other.title, title) || other.title == title)&&(identical(other.score, score) || other.score == score));
}


@override
int get hashCode => Object.hash(runtimeType,title,score);

@override
String toString() {
  return 'GymRatingItem(title: $title, score: $score)';
}


}

/// @nodoc
abstract mixin class _$GymRatingItemCopyWith<$Res> implements $GymRatingItemCopyWith<$Res> {
  factory _$GymRatingItemCopyWith(_GymRatingItem value, $Res Function(_GymRatingItem) _then) = __$GymRatingItemCopyWithImpl;
@override @useResult
$Res call({
 String title, int score
});




}
/// @nodoc
class __$GymRatingItemCopyWithImpl<$Res>
    implements _$GymRatingItemCopyWith<$Res> {
  __$GymRatingItemCopyWithImpl(this._self, this._then);

  final _GymRatingItem _self;
  final $Res Function(_GymRatingItem) _then;

/// Create a copy of GymRatingItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? score = null,}) {
  return _then(_GymRatingItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$GymProgressSegment {

 double get percentage; int get heightFactor; int get posture;
/// Create a copy of GymProgressSegment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GymProgressSegmentCopyWith<GymProgressSegment> get copyWith => _$GymProgressSegmentCopyWithImpl<GymProgressSegment>(this as GymProgressSegment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GymProgressSegment&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.heightFactor, heightFactor) || other.heightFactor == heightFactor)&&(identical(other.posture, posture) || other.posture == posture));
}


@override
int get hashCode => Object.hash(runtimeType,percentage,heightFactor,posture);

@override
String toString() {
  return 'GymProgressSegment(percentage: $percentage, heightFactor: $heightFactor, posture: $posture)';
}


}

/// @nodoc
abstract mixin class $GymProgressSegmentCopyWith<$Res>  {
  factory $GymProgressSegmentCopyWith(GymProgressSegment value, $Res Function(GymProgressSegment) _then) = _$GymProgressSegmentCopyWithImpl;
@useResult
$Res call({
 double percentage, int heightFactor, int posture
});




}
/// @nodoc
class _$GymProgressSegmentCopyWithImpl<$Res>
    implements $GymProgressSegmentCopyWith<$Res> {
  _$GymProgressSegmentCopyWithImpl(this._self, this._then);

  final GymProgressSegment _self;
  final $Res Function(GymProgressSegment) _then;

/// Create a copy of GymProgressSegment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? percentage = null,Object? heightFactor = null,Object? posture = null,}) {
  return _then(GymProgressSegment(
percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,heightFactor: null == heightFactor ? _self.heightFactor : heightFactor // ignore: cast_nullable_to_non_nullable
as int,posture: null == posture ? _self.posture : posture // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GymProgressSegment].
extension GymProgressSegmentPatterns on GymProgressSegment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GymProgressSegment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GymProgressSegment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GymProgressSegment value)  $default,){
final _that = this;
switch (_that) {
case _GymProgressSegment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GymProgressSegment value)?  $default,){
final _that = this;
switch (_that) {
case _GymProgressSegment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double percentage,  int heightFactor,  int posture)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GymProgressSegment() when $default != null:
return $default(_that.percentage,_that.heightFactor,_that.posture);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double percentage,  int heightFactor,  int posture)  $default,) {final _that = this;
switch (_that) {
case _GymProgressSegment():
return $default(_that.percentage,_that.heightFactor,_that.posture);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double percentage,  int heightFactor,  int posture)?  $default,) {final _that = this;
switch (_that) {
case _GymProgressSegment() when $default != null:
return $default(_that.percentage,_that.heightFactor,_that.posture);case _:
  return null;

}
}

}

/// @nodoc


class _GymProgressSegment implements GymProgressSegment {
  const _GymProgressSegment({required this.percentage, required this.heightFactor, required this.posture});
  

@override final  double percentage;
@override final  int heightFactor;
@override final  int posture;

/// Create a copy of GymProgressSegment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GymProgressSegmentCopyWith<_GymProgressSegment> get copyWith => __$GymProgressSegmentCopyWithImpl<_GymProgressSegment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GymProgressSegment&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.heightFactor, heightFactor) || other.heightFactor == heightFactor)&&(identical(other.posture, posture) || other.posture == posture));
}


@override
int get hashCode => Object.hash(runtimeType,percentage,heightFactor,posture);

@override
String toString() {
  return 'GymProgressSegment(percentage: $percentage, heightFactor: $heightFactor, posture: $posture)';
}


}

/// @nodoc
abstract mixin class _$GymProgressSegmentCopyWith<$Res> implements $GymProgressSegmentCopyWith<$Res> {
  factory _$GymProgressSegmentCopyWith(_GymProgressSegment value, $Res Function(_GymProgressSegment) _then) = __$GymProgressSegmentCopyWithImpl;
@override @useResult
$Res call({
 double percentage, int heightFactor, int posture
});




}
/// @nodoc
class __$GymProgressSegmentCopyWithImpl<$Res>
    implements _$GymProgressSegmentCopyWith<$Res> {
  __$GymProgressSegmentCopyWithImpl(this._self, this._then);

  final _GymProgressSegment _self;
  final $Res Function(_GymProgressSegment) _then;

/// Create a copy of GymProgressSegment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? percentage = null,Object? heightFactor = null,Object? posture = null,}) {
  return _then(_GymProgressSegment(
percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,heightFactor: null == heightFactor ? _self.heightFactor : heightFactor // ignore: cast_nullable_to_non_nullable
as int,posture: null == posture ? _self.posture : posture // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$GymCoursePlayState {

/// 设备类型
 FtmsDeviceType get deviceType;/// 页面状态: loading / playing / finished
 GymPlayScreenStatus get screenStatus;/// 是否允许触摸返回
 bool get allowTouch;/// 是否显示中央播放按钮
 bool get showPlayButton;/// 是否在播放
 bool get isPlaying;/// 是否暂停（对应旧 isPause）
 bool get isPause;/// 是否在暂停页（用于显示暂停覆盖层）
 bool get isPauseScreen;/// 是否在结束页（对应旧 isStopScreen）
 bool get isStopScreen;/// 课程标题(大标题)，对应旧 titleProperties.bigTitle
 String get courseTitle;/// 难度文字
 String get difficulty;/// 等级 (1-5)
 int get level;/// 目标阻力等级（旧 ControllerNewFourBigDeviceSprot）
 int get targetResistanceLevel;/// 运动时间 (mm:ss 格式)
 String get sportTime;/// 运动距离 (km 字符串)
 String get sportDistance;/// 消耗卡路里
 String get sportCalories;/// 实时设备速度（km/h）
 String get sportSpeed;/// 设备实际速度（double，用于逻辑判断）
 double get sportDeviceSpeed;/// 实时心率
 String get sportHeartRate;/// 实时踏频 (rpm)
 String get sportCadence;/// 实时桨频 (spm, 划船机用)
 String get sportStrokeRate;/// 实时桨次数 (划船机用)
 String get sportStrokeCount;/// 实时坡度（String 显示）
 String get sportInclination;/// 实时阻力（String 显示）
 String get sportResistance;/// 按钮速度值
 double get sportSpeedButton;/// 按钮坡度值
 double get sportInclinationButton;/// 按钮阻力值
 double get sportResistanceButton;/// 是否支持坡度(跑步机)
 bool get hasInclinationSupport;/// 速度范围
 int get minSpeed; int get maxSpeed;/// 坡度范围
 int get minInclination; int get maxInclination;/// 阻力范围
 int get minResistance; int get maxResistance;/// 当前动作索引
 int get playIndex;/// 当前动作总时长(秒)
 int get currentDuration;/// 当前动作已播放时长(秒)
 int get playIndexDuration;/// 课程总已播放时长(秒)
 int get playTotalDuration;/// 课程总进度总时长(秒)
 int get totalPlayProgressDuration;/// 当前动画帧索引
 int get imagePlayIndex;/// 动画帧率
 int get imageFps;/// 本地图片资源根路径（对应旧版 rootImagePath）
/// 格式示例："/var/mobile/.../course/actionImage/"
/// 拼接规则："${rootImagePath}${imageName}/${imagePlayIndex}.png"
 String get rootImagePath;/// 本地 BGM 资源根路径
/// 格式示例："/var/mobile/.../course/bgm/"
 String get rootBgmPath;/// 本地 Voice 资源根路径
/// 格式示例："/var/mobile/.../course/voice/"
 String get rootVoicePath;/// 播放进度百分比 (0.0-1.0)，控制底部箭头位置
 double get playProgressPercent;/// 动作列表（对应旧 courseActionList）
 List<ActionItemState> get courseActions;/// 右侧动作名称列表
 List<String> get currentActionNameList;/// 进度条分段数据（对应旧 _automaticProgressBarFloatingWidget）
 List<GymProgressSegment> get progressSegments;/// 结束页数据图标路径
 List<String> get finishDataIcons;/// 结束页数据标题
 List<String> get finishDataTitles;/// 结束页数据值
 List<String> get finishDataValues;/// 结束页数据单位
 List<String> get finishDataUnits;/// 评分标题
 List<String> get ratingTitles;/// 评分等级（0-5）
 List<int> get ratingScores;/// 评分等级文字（例如 "Level A"）
 String get scoreLevel;/// 等级对应的图片索引（0-5）
 List<int> get ratingImageIndices;/// 速度图表数据（每 5 秒采样）
 List<double> get speedChartData;/// 最大踏频 (rpm)
 int get maxCadence;/// 最大心率 (bpm)
 int get maxHeartRate;/// 最大配速 (min/km)
 double get maxPace;/// 平均阻力
 double get avgResistance;/// 平均坡度
 double get avgInclination;/// 平均桨频 (spm)
 double get avgStrokeRate;/// 完成度百分比 (0-100)
 double get finishPercent;
/// Create a copy of GymCoursePlayState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GymCoursePlayStateCopyWith<GymCoursePlayState> get copyWith => _$GymCoursePlayStateCopyWithImpl<GymCoursePlayState>(this as GymCoursePlayState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GymCoursePlayState&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.screenStatus, screenStatus) || other.screenStatus == screenStatus)&&(identical(other.allowTouch, allowTouch) || other.allowTouch == allowTouch)&&(identical(other.showPlayButton, showPlayButton) || other.showPlayButton == showPlayButton)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isPause, isPause) || other.isPause == isPause)&&(identical(other.isPauseScreen, isPauseScreen) || other.isPauseScreen == isPauseScreen)&&(identical(other.isStopScreen, isStopScreen) || other.isStopScreen == isStopScreen)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.level, level) || other.level == level)&&(identical(other.targetResistanceLevel, targetResistanceLevel) || other.targetResistanceLevel == targetResistanceLevel)&&(identical(other.sportTime, sportTime) || other.sportTime == sportTime)&&(identical(other.sportDistance, sportDistance) || other.sportDistance == sportDistance)&&(identical(other.sportCalories, sportCalories) || other.sportCalories == sportCalories)&&(identical(other.sportSpeed, sportSpeed) || other.sportSpeed == sportSpeed)&&(identical(other.sportDeviceSpeed, sportDeviceSpeed) || other.sportDeviceSpeed == sportDeviceSpeed)&&(identical(other.sportHeartRate, sportHeartRate) || other.sportHeartRate == sportHeartRate)&&(identical(other.sportCadence, sportCadence) || other.sportCadence == sportCadence)&&(identical(other.sportStrokeRate, sportStrokeRate) || other.sportStrokeRate == sportStrokeRate)&&(identical(other.sportStrokeCount, sportStrokeCount) || other.sportStrokeCount == sportStrokeCount)&&(identical(other.sportInclination, sportInclination) || other.sportInclination == sportInclination)&&(identical(other.sportResistance, sportResistance) || other.sportResistance == sportResistance)&&(identical(other.sportSpeedButton, sportSpeedButton) || other.sportSpeedButton == sportSpeedButton)&&(identical(other.sportInclinationButton, sportInclinationButton) || other.sportInclinationButton == sportInclinationButton)&&(identical(other.sportResistanceButton, sportResistanceButton) || other.sportResistanceButton == sportResistanceButton)&&(identical(other.hasInclinationSupport, hasInclinationSupport) || other.hasInclinationSupport == hasInclinationSupport)&&(identical(other.minSpeed, minSpeed) || other.minSpeed == minSpeed)&&(identical(other.maxSpeed, maxSpeed) || other.maxSpeed == maxSpeed)&&(identical(other.minInclination, minInclination) || other.minInclination == minInclination)&&(identical(other.maxInclination, maxInclination) || other.maxInclination == maxInclination)&&(identical(other.minResistance, minResistance) || other.minResistance == minResistance)&&(identical(other.maxResistance, maxResistance) || other.maxResistance == maxResistance)&&(identical(other.playIndex, playIndex) || other.playIndex == playIndex)&&(identical(other.currentDuration, currentDuration) || other.currentDuration == currentDuration)&&(identical(other.playIndexDuration, playIndexDuration) || other.playIndexDuration == playIndexDuration)&&(identical(other.playTotalDuration, playTotalDuration) || other.playTotalDuration == playTotalDuration)&&(identical(other.totalPlayProgressDuration, totalPlayProgressDuration) || other.totalPlayProgressDuration == totalPlayProgressDuration)&&(identical(other.imagePlayIndex, imagePlayIndex) || other.imagePlayIndex == imagePlayIndex)&&(identical(other.imageFps, imageFps) || other.imageFps == imageFps)&&(identical(other.rootImagePath, rootImagePath) || other.rootImagePath == rootImagePath)&&(identical(other.rootBgmPath, rootBgmPath) || other.rootBgmPath == rootBgmPath)&&(identical(other.rootVoicePath, rootVoicePath) || other.rootVoicePath == rootVoicePath)&&(identical(other.playProgressPercent, playProgressPercent) || other.playProgressPercent == playProgressPercent)&&const DeepCollectionEquality().equals(other.courseActions, courseActions)&&const DeepCollectionEquality().equals(other.currentActionNameList, currentActionNameList)&&const DeepCollectionEquality().equals(other.progressSegments, progressSegments)&&const DeepCollectionEquality().equals(other.finishDataIcons, finishDataIcons)&&const DeepCollectionEquality().equals(other.finishDataTitles, finishDataTitles)&&const DeepCollectionEquality().equals(other.finishDataValues, finishDataValues)&&const DeepCollectionEquality().equals(other.finishDataUnits, finishDataUnits)&&const DeepCollectionEquality().equals(other.ratingTitles, ratingTitles)&&const DeepCollectionEquality().equals(other.ratingScores, ratingScores)&&(identical(other.scoreLevel, scoreLevel) || other.scoreLevel == scoreLevel)&&const DeepCollectionEquality().equals(other.ratingImageIndices, ratingImageIndices)&&const DeepCollectionEquality().equals(other.speedChartData, speedChartData)&&(identical(other.maxCadence, maxCadence) || other.maxCadence == maxCadence)&&(identical(other.maxHeartRate, maxHeartRate) || other.maxHeartRate == maxHeartRate)&&(identical(other.maxPace, maxPace) || other.maxPace == maxPace)&&(identical(other.avgResistance, avgResistance) || other.avgResistance == avgResistance)&&(identical(other.avgInclination, avgInclination) || other.avgInclination == avgInclination)&&(identical(other.avgStrokeRate, avgStrokeRate) || other.avgStrokeRate == avgStrokeRate)&&(identical(other.finishPercent, finishPercent) || other.finishPercent == finishPercent));
}


@override
int get hashCode => Object.hashAll([runtimeType,deviceType,screenStatus,allowTouch,showPlayButton,isPlaying,isPause,isPauseScreen,isStopScreen,courseTitle,difficulty,level,targetResistanceLevel,sportTime,sportDistance,sportCalories,sportSpeed,sportDeviceSpeed,sportHeartRate,sportCadence,sportStrokeRate,sportStrokeCount,sportInclination,sportResistance,sportSpeedButton,sportInclinationButton,sportResistanceButton,hasInclinationSupport,minSpeed,maxSpeed,minInclination,maxInclination,minResistance,maxResistance,playIndex,currentDuration,playIndexDuration,playTotalDuration,totalPlayProgressDuration,imagePlayIndex,imageFps,rootImagePath,rootBgmPath,rootVoicePath,playProgressPercent,const DeepCollectionEquality().hash(courseActions),const DeepCollectionEquality().hash(currentActionNameList),const DeepCollectionEquality().hash(progressSegments),const DeepCollectionEquality().hash(finishDataIcons),const DeepCollectionEquality().hash(finishDataTitles),const DeepCollectionEquality().hash(finishDataValues),const DeepCollectionEquality().hash(finishDataUnits),const DeepCollectionEquality().hash(ratingTitles),const DeepCollectionEquality().hash(ratingScores),scoreLevel,const DeepCollectionEquality().hash(ratingImageIndices),const DeepCollectionEquality().hash(speedChartData),maxCadence,maxHeartRate,maxPace,avgResistance,avgInclination,avgStrokeRate,finishPercent]);

@override
String toString() {
  return 'GymCoursePlayState(deviceType: $deviceType, screenStatus: $screenStatus, allowTouch: $allowTouch, showPlayButton: $showPlayButton, isPlaying: $isPlaying, isPause: $isPause, isPauseScreen: $isPauseScreen, isStopScreen: $isStopScreen, courseTitle: $courseTitle, difficulty: $difficulty, level: $level, targetResistanceLevel: $targetResistanceLevel, sportTime: $sportTime, sportDistance: $sportDistance, sportCalories: $sportCalories, sportSpeed: $sportSpeed, sportDeviceSpeed: $sportDeviceSpeed, sportHeartRate: $sportHeartRate, sportCadence: $sportCadence, sportStrokeRate: $sportStrokeRate, sportStrokeCount: $sportStrokeCount, sportInclination: $sportInclination, sportResistance: $sportResistance, sportSpeedButton: $sportSpeedButton, sportInclinationButton: $sportInclinationButton, sportResistanceButton: $sportResistanceButton, hasInclinationSupport: $hasInclinationSupport, minSpeed: $minSpeed, maxSpeed: $maxSpeed, minInclination: $minInclination, maxInclination: $maxInclination, minResistance: $minResistance, maxResistance: $maxResistance, playIndex: $playIndex, currentDuration: $currentDuration, playIndexDuration: $playIndexDuration, playTotalDuration: $playTotalDuration, totalPlayProgressDuration: $totalPlayProgressDuration, imagePlayIndex: $imagePlayIndex, imageFps: $imageFps, rootImagePath: $rootImagePath, rootBgmPath: $rootBgmPath, rootVoicePath: $rootVoicePath, playProgressPercent: $playProgressPercent, courseActions: $courseActions, currentActionNameList: $currentActionNameList, progressSegments: $progressSegments, finishDataIcons: $finishDataIcons, finishDataTitles: $finishDataTitles, finishDataValues: $finishDataValues, finishDataUnits: $finishDataUnits, ratingTitles: $ratingTitles, ratingScores: $ratingScores, scoreLevel: $scoreLevel, ratingImageIndices: $ratingImageIndices, speedChartData: $speedChartData, maxCadence: $maxCadence, maxHeartRate: $maxHeartRate, maxPace: $maxPace, avgResistance: $avgResistance, avgInclination: $avgInclination, avgStrokeRate: $avgStrokeRate, finishPercent: $finishPercent)';
}


}

/// @nodoc
abstract mixin class $GymCoursePlayStateCopyWith<$Res>  {
  factory $GymCoursePlayStateCopyWith(GymCoursePlayState value, $Res Function(GymCoursePlayState) _then) = _$GymCoursePlayStateCopyWithImpl;
@useResult
$Res call({
 FtmsDeviceType deviceType, GymPlayScreenStatus screenStatus, bool allowTouch, bool showPlayButton, bool isPlaying, bool isPause, bool isPauseScreen, bool isStopScreen, String courseTitle, String difficulty, int level, int targetResistanceLevel, String sportTime, String sportDistance, String sportCalories, String sportSpeed, double sportDeviceSpeed, String sportHeartRate, String sportCadence, String sportStrokeRate, String sportStrokeCount, String sportInclination, String sportResistance, double sportSpeedButton, double sportInclinationButton, double sportResistanceButton, bool hasInclinationSupport, int minSpeed, int maxSpeed, int minInclination, int maxInclination, int minResistance, int maxResistance, int playIndex, int currentDuration, int playIndexDuration, int playTotalDuration, int totalPlayProgressDuration, int imagePlayIndex, int imageFps, String rootImagePath, String rootBgmPath, String rootVoicePath, double playProgressPercent, List<ActionItemState> courseActions, List<String> currentActionNameList, List<GymProgressSegment> progressSegments, List<String> finishDataIcons, List<String> finishDataTitles, List<String> finishDataValues, List<String> finishDataUnits, List<String> ratingTitles, List<int> ratingScores, String scoreLevel, List<int> ratingImageIndices, List<double> speedChartData, int maxCadence, int maxHeartRate, double maxPace, double avgResistance, double avgInclination, double avgStrokeRate, double finishPercent
});




}
/// @nodoc
class _$GymCoursePlayStateCopyWithImpl<$Res>
    implements $GymCoursePlayStateCopyWith<$Res> {
  _$GymCoursePlayStateCopyWithImpl(this._self, this._then);

  final GymCoursePlayState _self;
  final $Res Function(GymCoursePlayState) _then;

/// Create a copy of GymCoursePlayState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceType = null,Object? screenStatus = null,Object? allowTouch = null,Object? showPlayButton = null,Object? isPlaying = null,Object? isPause = null,Object? isPauseScreen = null,Object? isStopScreen = null,Object? courseTitle = null,Object? difficulty = null,Object? level = null,Object? targetResistanceLevel = null,Object? sportTime = null,Object? sportDistance = null,Object? sportCalories = null,Object? sportSpeed = null,Object? sportDeviceSpeed = null,Object? sportHeartRate = null,Object? sportCadence = null,Object? sportStrokeRate = null,Object? sportStrokeCount = null,Object? sportInclination = null,Object? sportResistance = null,Object? sportSpeedButton = null,Object? sportInclinationButton = null,Object? sportResistanceButton = null,Object? hasInclinationSupport = null,Object? minSpeed = null,Object? maxSpeed = null,Object? minInclination = null,Object? maxInclination = null,Object? minResistance = null,Object? maxResistance = null,Object? playIndex = null,Object? currentDuration = null,Object? playIndexDuration = null,Object? playTotalDuration = null,Object? totalPlayProgressDuration = null,Object? imagePlayIndex = null,Object? imageFps = null,Object? rootImagePath = null,Object? rootBgmPath = null,Object? rootVoicePath = null,Object? playProgressPercent = null,Object? courseActions = null,Object? currentActionNameList = null,Object? progressSegments = null,Object? finishDataIcons = null,Object? finishDataTitles = null,Object? finishDataValues = null,Object? finishDataUnits = null,Object? ratingTitles = null,Object? ratingScores = null,Object? scoreLevel = null,Object? ratingImageIndices = null,Object? speedChartData = null,Object? maxCadence = null,Object? maxHeartRate = null,Object? maxPace = null,Object? avgResistance = null,Object? avgInclination = null,Object? avgStrokeRate = null,Object? finishPercent = null,}) {
  return _then(GymCoursePlayState(
deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as FtmsDeviceType,screenStatus: null == screenStatus ? _self.screenStatus : screenStatus // ignore: cast_nullable_to_non_nullable
as GymPlayScreenStatus,allowTouch: null == allowTouch ? _self.allowTouch : allowTouch // ignore: cast_nullable_to_non_nullable
as bool,showPlayButton: null == showPlayButton ? _self.showPlayButton : showPlayButton // ignore: cast_nullable_to_non_nullable
as bool,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isPause: null == isPause ? _self.isPause : isPause // ignore: cast_nullable_to_non_nullable
as bool,isPauseScreen: null == isPauseScreen ? _self.isPauseScreen : isPauseScreen // ignore: cast_nullable_to_non_nullable
as bool,isStopScreen: null == isStopScreen ? _self.isStopScreen : isStopScreen // ignore: cast_nullable_to_non_nullable
as bool,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,targetResistanceLevel: null == targetResistanceLevel ? _self.targetResistanceLevel : targetResistanceLevel // ignore: cast_nullable_to_non_nullable
as int,sportTime: null == sportTime ? _self.sportTime : sportTime // ignore: cast_nullable_to_non_nullable
as String,sportDistance: null == sportDistance ? _self.sportDistance : sportDistance // ignore: cast_nullable_to_non_nullable
as String,sportCalories: null == sportCalories ? _self.sportCalories : sportCalories // ignore: cast_nullable_to_non_nullable
as String,sportSpeed: null == sportSpeed ? _self.sportSpeed : sportSpeed // ignore: cast_nullable_to_non_nullable
as String,sportDeviceSpeed: null == sportDeviceSpeed ? _self.sportDeviceSpeed : sportDeviceSpeed // ignore: cast_nullable_to_non_nullable
as double,sportHeartRate: null == sportHeartRate ? _self.sportHeartRate : sportHeartRate // ignore: cast_nullable_to_non_nullable
as String,sportCadence: null == sportCadence ? _self.sportCadence : sportCadence // ignore: cast_nullable_to_non_nullable
as String,sportStrokeRate: null == sportStrokeRate ? _self.sportStrokeRate : sportStrokeRate // ignore: cast_nullable_to_non_nullable
as String,sportStrokeCount: null == sportStrokeCount ? _self.sportStrokeCount : sportStrokeCount // ignore: cast_nullable_to_non_nullable
as String,sportInclination: null == sportInclination ? _self.sportInclination : sportInclination // ignore: cast_nullable_to_non_nullable
as String,sportResistance: null == sportResistance ? _self.sportResistance : sportResistance // ignore: cast_nullable_to_non_nullable
as String,sportSpeedButton: null == sportSpeedButton ? _self.sportSpeedButton : sportSpeedButton // ignore: cast_nullable_to_non_nullable
as double,sportInclinationButton: null == sportInclinationButton ? _self.sportInclinationButton : sportInclinationButton // ignore: cast_nullable_to_non_nullable
as double,sportResistanceButton: null == sportResistanceButton ? _self.sportResistanceButton : sportResistanceButton // ignore: cast_nullable_to_non_nullable
as double,hasInclinationSupport: null == hasInclinationSupport ? _self.hasInclinationSupport : hasInclinationSupport // ignore: cast_nullable_to_non_nullable
as bool,minSpeed: null == minSpeed ? _self.minSpeed : minSpeed // ignore: cast_nullable_to_non_nullable
as int,maxSpeed: null == maxSpeed ? _self.maxSpeed : maxSpeed // ignore: cast_nullable_to_non_nullable
as int,minInclination: null == minInclination ? _self.minInclination : minInclination // ignore: cast_nullable_to_non_nullable
as int,maxInclination: null == maxInclination ? _self.maxInclination : maxInclination // ignore: cast_nullable_to_non_nullable
as int,minResistance: null == minResistance ? _self.minResistance : minResistance // ignore: cast_nullable_to_non_nullable
as int,maxResistance: null == maxResistance ? _self.maxResistance : maxResistance // ignore: cast_nullable_to_non_nullable
as int,playIndex: null == playIndex ? _self.playIndex : playIndex // ignore: cast_nullable_to_non_nullable
as int,currentDuration: null == currentDuration ? _self.currentDuration : currentDuration // ignore: cast_nullable_to_non_nullable
as int,playIndexDuration: null == playIndexDuration ? _self.playIndexDuration : playIndexDuration // ignore: cast_nullable_to_non_nullable
as int,playTotalDuration: null == playTotalDuration ? _self.playTotalDuration : playTotalDuration // ignore: cast_nullable_to_non_nullable
as int,totalPlayProgressDuration: null == totalPlayProgressDuration ? _self.totalPlayProgressDuration : totalPlayProgressDuration // ignore: cast_nullable_to_non_nullable
as int,imagePlayIndex: null == imagePlayIndex ? _self.imagePlayIndex : imagePlayIndex // ignore: cast_nullable_to_non_nullable
as int,imageFps: null == imageFps ? _self.imageFps : imageFps // ignore: cast_nullable_to_non_nullable
as int,rootImagePath: null == rootImagePath ? _self.rootImagePath : rootImagePath // ignore: cast_nullable_to_non_nullable
as String,rootBgmPath: null == rootBgmPath ? _self.rootBgmPath : rootBgmPath // ignore: cast_nullable_to_non_nullable
as String,rootVoicePath: null == rootVoicePath ? _self.rootVoicePath : rootVoicePath // ignore: cast_nullable_to_non_nullable
as String,playProgressPercent: null == playProgressPercent ? _self.playProgressPercent : playProgressPercent // ignore: cast_nullable_to_non_nullable
as double,courseActions: null == courseActions ? _self.courseActions : courseActions // ignore: cast_nullable_to_non_nullable
as List<ActionItemState>,currentActionNameList: null == currentActionNameList ? _self.currentActionNameList : currentActionNameList // ignore: cast_nullable_to_non_nullable
as List<String>,progressSegments: null == progressSegments ? _self.progressSegments : progressSegments // ignore: cast_nullable_to_non_nullable
as List<GymProgressSegment>,finishDataIcons: null == finishDataIcons ? _self.finishDataIcons : finishDataIcons // ignore: cast_nullable_to_non_nullable
as List<String>,finishDataTitles: null == finishDataTitles ? _self.finishDataTitles : finishDataTitles // ignore: cast_nullable_to_non_nullable
as List<String>,finishDataValues: null == finishDataValues ? _self.finishDataValues : finishDataValues // ignore: cast_nullable_to_non_nullable
as List<String>,finishDataUnits: null == finishDataUnits ? _self.finishDataUnits : finishDataUnits // ignore: cast_nullable_to_non_nullable
as List<String>,ratingTitles: null == ratingTitles ? _self.ratingTitles : ratingTitles // ignore: cast_nullable_to_non_nullable
as List<String>,ratingScores: null == ratingScores ? _self.ratingScores : ratingScores // ignore: cast_nullable_to_non_nullable
as List<int>,scoreLevel: null == scoreLevel ? _self.scoreLevel : scoreLevel // ignore: cast_nullable_to_non_nullable
as String,ratingImageIndices: null == ratingImageIndices ? _self.ratingImageIndices : ratingImageIndices // ignore: cast_nullable_to_non_nullable
as List<int>,speedChartData: null == speedChartData ? _self.speedChartData : speedChartData // ignore: cast_nullable_to_non_nullable
as List<double>,maxCadence: null == maxCadence ? _self.maxCadence : maxCadence // ignore: cast_nullable_to_non_nullable
as int,maxHeartRate: null == maxHeartRate ? _self.maxHeartRate : maxHeartRate // ignore: cast_nullable_to_non_nullable
as int,maxPace: null == maxPace ? _self.maxPace : maxPace // ignore: cast_nullable_to_non_nullable
as double,avgResistance: null == avgResistance ? _self.avgResistance : avgResistance // ignore: cast_nullable_to_non_nullable
as double,avgInclination: null == avgInclination ? _self.avgInclination : avgInclination // ignore: cast_nullable_to_non_nullable
as double,avgStrokeRate: null == avgStrokeRate ? _self.avgStrokeRate : avgStrokeRate // ignore: cast_nullable_to_non_nullable
as double,finishPercent: null == finishPercent ? _self.finishPercent : finishPercent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GymCoursePlayState].
extension GymCoursePlayStatePatterns on GymCoursePlayState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GymCoursePlayState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GymCoursePlayState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GymCoursePlayState value)  $default,){
final _that = this;
switch (_that) {
case _GymCoursePlayState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GymCoursePlayState value)?  $default,){
final _that = this;
switch (_that) {
case _GymCoursePlayState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FtmsDeviceType deviceType,  GymPlayScreenStatus screenStatus,  bool allowTouch,  bool showPlayButton,  bool isPlaying,  bool isPause,  bool isPauseScreen,  bool isStopScreen,  String courseTitle,  String difficulty,  int level,  int targetResistanceLevel,  String sportTime,  String sportDistance,  String sportCalories,  String sportSpeed,  double sportDeviceSpeed,  String sportHeartRate,  String sportCadence,  String sportStrokeRate,  String sportStrokeCount,  String sportInclination,  String sportResistance,  double sportSpeedButton,  double sportInclinationButton,  double sportResistanceButton,  bool hasInclinationSupport,  int minSpeed,  int maxSpeed,  int minInclination,  int maxInclination,  int minResistance,  int maxResistance,  int playIndex,  int currentDuration,  int playIndexDuration,  int playTotalDuration,  int totalPlayProgressDuration,  int imagePlayIndex,  int imageFps,  String rootImagePath,  String rootBgmPath,  String rootVoicePath,  double playProgressPercent,  List<ActionItemState> courseActions,  List<String> currentActionNameList,  List<GymProgressSegment> progressSegments,  List<String> finishDataIcons,  List<String> finishDataTitles,  List<String> finishDataValues,  List<String> finishDataUnits,  List<String> ratingTitles,  List<int> ratingScores,  String scoreLevel,  List<int> ratingImageIndices,  List<double> speedChartData,  int maxCadence,  int maxHeartRate,  double maxPace,  double avgResistance,  double avgInclination,  double avgStrokeRate,  double finishPercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GymCoursePlayState() when $default != null:
return $default(_that.deviceType,_that.screenStatus,_that.allowTouch,_that.showPlayButton,_that.isPlaying,_that.isPause,_that.isPauseScreen,_that.isStopScreen,_that.courseTitle,_that.difficulty,_that.level,_that.targetResistanceLevel,_that.sportTime,_that.sportDistance,_that.sportCalories,_that.sportSpeed,_that.sportDeviceSpeed,_that.sportHeartRate,_that.sportCadence,_that.sportStrokeRate,_that.sportStrokeCount,_that.sportInclination,_that.sportResistance,_that.sportSpeedButton,_that.sportInclinationButton,_that.sportResistanceButton,_that.hasInclinationSupport,_that.minSpeed,_that.maxSpeed,_that.minInclination,_that.maxInclination,_that.minResistance,_that.maxResistance,_that.playIndex,_that.currentDuration,_that.playIndexDuration,_that.playTotalDuration,_that.totalPlayProgressDuration,_that.imagePlayIndex,_that.imageFps,_that.rootImagePath,_that.rootBgmPath,_that.rootVoicePath,_that.playProgressPercent,_that.courseActions,_that.currentActionNameList,_that.progressSegments,_that.finishDataIcons,_that.finishDataTitles,_that.finishDataValues,_that.finishDataUnits,_that.ratingTitles,_that.ratingScores,_that.scoreLevel,_that.ratingImageIndices,_that.speedChartData,_that.maxCadence,_that.maxHeartRate,_that.maxPace,_that.avgResistance,_that.avgInclination,_that.avgStrokeRate,_that.finishPercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FtmsDeviceType deviceType,  GymPlayScreenStatus screenStatus,  bool allowTouch,  bool showPlayButton,  bool isPlaying,  bool isPause,  bool isPauseScreen,  bool isStopScreen,  String courseTitle,  String difficulty,  int level,  int targetResistanceLevel,  String sportTime,  String sportDistance,  String sportCalories,  String sportSpeed,  double sportDeviceSpeed,  String sportHeartRate,  String sportCadence,  String sportStrokeRate,  String sportStrokeCount,  String sportInclination,  String sportResistance,  double sportSpeedButton,  double sportInclinationButton,  double sportResistanceButton,  bool hasInclinationSupport,  int minSpeed,  int maxSpeed,  int minInclination,  int maxInclination,  int minResistance,  int maxResistance,  int playIndex,  int currentDuration,  int playIndexDuration,  int playTotalDuration,  int totalPlayProgressDuration,  int imagePlayIndex,  int imageFps,  String rootImagePath,  String rootBgmPath,  String rootVoicePath,  double playProgressPercent,  List<ActionItemState> courseActions,  List<String> currentActionNameList,  List<GymProgressSegment> progressSegments,  List<String> finishDataIcons,  List<String> finishDataTitles,  List<String> finishDataValues,  List<String> finishDataUnits,  List<String> ratingTitles,  List<int> ratingScores,  String scoreLevel,  List<int> ratingImageIndices,  List<double> speedChartData,  int maxCadence,  int maxHeartRate,  double maxPace,  double avgResistance,  double avgInclination,  double avgStrokeRate,  double finishPercent)  $default,) {final _that = this;
switch (_that) {
case _GymCoursePlayState():
return $default(_that.deviceType,_that.screenStatus,_that.allowTouch,_that.showPlayButton,_that.isPlaying,_that.isPause,_that.isPauseScreen,_that.isStopScreen,_that.courseTitle,_that.difficulty,_that.level,_that.targetResistanceLevel,_that.sportTime,_that.sportDistance,_that.sportCalories,_that.sportSpeed,_that.sportDeviceSpeed,_that.sportHeartRate,_that.sportCadence,_that.sportStrokeRate,_that.sportStrokeCount,_that.sportInclination,_that.sportResistance,_that.sportSpeedButton,_that.sportInclinationButton,_that.sportResistanceButton,_that.hasInclinationSupport,_that.minSpeed,_that.maxSpeed,_that.minInclination,_that.maxInclination,_that.minResistance,_that.maxResistance,_that.playIndex,_that.currentDuration,_that.playIndexDuration,_that.playTotalDuration,_that.totalPlayProgressDuration,_that.imagePlayIndex,_that.imageFps,_that.rootImagePath,_that.rootBgmPath,_that.rootVoicePath,_that.playProgressPercent,_that.courseActions,_that.currentActionNameList,_that.progressSegments,_that.finishDataIcons,_that.finishDataTitles,_that.finishDataValues,_that.finishDataUnits,_that.ratingTitles,_that.ratingScores,_that.scoreLevel,_that.ratingImageIndices,_that.speedChartData,_that.maxCadence,_that.maxHeartRate,_that.maxPace,_that.avgResistance,_that.avgInclination,_that.avgStrokeRate,_that.finishPercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FtmsDeviceType deviceType,  GymPlayScreenStatus screenStatus,  bool allowTouch,  bool showPlayButton,  bool isPlaying,  bool isPause,  bool isPauseScreen,  bool isStopScreen,  String courseTitle,  String difficulty,  int level,  int targetResistanceLevel,  String sportTime,  String sportDistance,  String sportCalories,  String sportSpeed,  double sportDeviceSpeed,  String sportHeartRate,  String sportCadence,  String sportStrokeRate,  String sportStrokeCount,  String sportInclination,  String sportResistance,  double sportSpeedButton,  double sportInclinationButton,  double sportResistanceButton,  bool hasInclinationSupport,  int minSpeed,  int maxSpeed,  int minInclination,  int maxInclination,  int minResistance,  int maxResistance,  int playIndex,  int currentDuration,  int playIndexDuration,  int playTotalDuration,  int totalPlayProgressDuration,  int imagePlayIndex,  int imageFps,  String rootImagePath,  String rootBgmPath,  String rootVoicePath,  double playProgressPercent,  List<ActionItemState> courseActions,  List<String> currentActionNameList,  List<GymProgressSegment> progressSegments,  List<String> finishDataIcons,  List<String> finishDataTitles,  List<String> finishDataValues,  List<String> finishDataUnits,  List<String> ratingTitles,  List<int> ratingScores,  String scoreLevel,  List<int> ratingImageIndices,  List<double> speedChartData,  int maxCadence,  int maxHeartRate,  double maxPace,  double avgResistance,  double avgInclination,  double avgStrokeRate,  double finishPercent)?  $default,) {final _that = this;
switch (_that) {
case _GymCoursePlayState() when $default != null:
return $default(_that.deviceType,_that.screenStatus,_that.allowTouch,_that.showPlayButton,_that.isPlaying,_that.isPause,_that.isPauseScreen,_that.isStopScreen,_that.courseTitle,_that.difficulty,_that.level,_that.targetResistanceLevel,_that.sportTime,_that.sportDistance,_that.sportCalories,_that.sportSpeed,_that.sportDeviceSpeed,_that.sportHeartRate,_that.sportCadence,_that.sportStrokeRate,_that.sportStrokeCount,_that.sportInclination,_that.sportResistance,_that.sportSpeedButton,_that.sportInclinationButton,_that.sportResistanceButton,_that.hasInclinationSupport,_that.minSpeed,_that.maxSpeed,_that.minInclination,_that.maxInclination,_that.minResistance,_that.maxResistance,_that.playIndex,_that.currentDuration,_that.playIndexDuration,_that.playTotalDuration,_that.totalPlayProgressDuration,_that.imagePlayIndex,_that.imageFps,_that.rootImagePath,_that.rootBgmPath,_that.rootVoicePath,_that.playProgressPercent,_that.courseActions,_that.currentActionNameList,_that.progressSegments,_that.finishDataIcons,_that.finishDataTitles,_that.finishDataValues,_that.finishDataUnits,_that.ratingTitles,_that.ratingScores,_that.scoreLevel,_that.ratingImageIndices,_that.speedChartData,_that.maxCadence,_that.maxHeartRate,_that.maxPace,_that.avgResistance,_that.avgInclination,_that.avgStrokeRate,_that.finishPercent);case _:
  return null;

}
}

}

/// @nodoc


class _GymCoursePlayState implements GymCoursePlayState {
  const _GymCoursePlayState({this.deviceType = FtmsDeviceType.indoorBike, this.screenStatus = GymPlayScreenStatus.loading, this.allowTouch = true, this.showPlayButton = true, this.isPlaying = false, this.isPause = false, this.isPauseScreen = false, this.isStopScreen = false, this.courseTitle = 'Power Cycle Pro', this.difficulty = 'Intermediate', this.level = 3, this.targetResistanceLevel = 3, this.sportTime = '00:00', this.sportDistance = '0.00', this.sportCalories = '0.0', this.sportSpeed = '0.0', this.sportDeviceSpeed = 0.0, this.sportHeartRate = '0', this.sportCadence = '0', this.sportStrokeRate = '0', this.sportStrokeCount = '0', this.sportInclination = '0.0', this.sportResistance = '0', this.sportSpeedButton = 25.0, this.sportInclinationButton = 5.0, this.sportResistanceButton = 3.0, this.hasInclinationSupport = true, this.minSpeed = 0, this.maxSpeed = 50, this.minInclination = -5, this.maxInclination = 10, this.minResistance = 1, this.maxResistance = 10, this.playIndex = 0, this.currentDuration = 60, this.playIndexDuration = 0, this.playTotalDuration = 0, this.totalPlayProgressDuration = 525, this.imagePlayIndex = 0, this.imageFps = 30, this.rootImagePath = '', this.rootBgmPath = '', this.rootVoicePath = '', this.playProgressPercent = 0.0,  List<ActionItemState> courseActions = const [],  List<String> currentActionNameList = const [],  List<GymProgressSegment> progressSegments = const [],  List<String> finishDataIcons = const [],  List<String> finishDataTitles = const [],  List<String> finishDataValues = const [],  List<String> finishDataUnits = const [],  List<String> ratingTitles = const [],  List<int> ratingScores = const [], this.scoreLevel = 'Level A',  List<int> ratingImageIndices = const [0, 0, 0, 2],  List<double> speedChartData = const [], this.maxCadence = 0, this.maxHeartRate = 0, this.maxPace = 0.0, this.avgResistance = 0.0, this.avgInclination = 0.0, this.avgStrokeRate = 0.0, this.finishPercent = 0.0}): _courseActions = courseActions,_currentActionNameList = currentActionNameList,_progressSegments = progressSegments,_finishDataIcons = finishDataIcons,_finishDataTitles = finishDataTitles,_finishDataValues = finishDataValues,_finishDataUnits = finishDataUnits,_ratingTitles = ratingTitles,_ratingScores = ratingScores,_ratingImageIndices = ratingImageIndices,_speedChartData = speedChartData;
  

/// 设备类型
@override@JsonKey() final  FtmsDeviceType deviceType;
/// 页面状态: loading / playing / finished
@override@JsonKey() final  GymPlayScreenStatus screenStatus;
/// 是否允许触摸返回
@override@JsonKey() final  bool allowTouch;
/// 是否显示中央播放按钮
@override@JsonKey() final  bool showPlayButton;
/// 是否在播放
@override@JsonKey() final  bool isPlaying;
/// 是否暂停（对应旧 isPause）
@override@JsonKey() final  bool isPause;
/// 是否在暂停页（用于显示暂停覆盖层）
@override@JsonKey() final  bool isPauseScreen;
/// 是否在结束页（对应旧 isStopScreen）
@override@JsonKey() final  bool isStopScreen;
/// 课程标题(大标题)，对应旧 titleProperties.bigTitle
@override@JsonKey() final  String courseTitle;
/// 难度文字
@override@JsonKey() final  String difficulty;
/// 等级 (1-5)
@override@JsonKey() final  int level;
/// 目标阻力等级（旧 ControllerNewFourBigDeviceSprot）
@override@JsonKey() final  int targetResistanceLevel;
/// 运动时间 (mm:ss 格式)
@override@JsonKey() final  String sportTime;
/// 运动距离 (km 字符串)
@override@JsonKey() final  String sportDistance;
/// 消耗卡路里
@override@JsonKey() final  String sportCalories;
/// 实时设备速度（km/h）
@override@JsonKey() final  String sportSpeed;
/// 设备实际速度（double，用于逻辑判断）
@override@JsonKey() final  double sportDeviceSpeed;
/// 实时心率
@override@JsonKey() final  String sportHeartRate;
/// 实时踏频 (rpm)
@override@JsonKey() final  String sportCadence;
/// 实时桨频 (spm, 划船机用)
@override@JsonKey() final  String sportStrokeRate;
/// 实时桨次数 (划船机用)
@override@JsonKey() final  String sportStrokeCount;
/// 实时坡度（String 显示）
@override@JsonKey() final  String sportInclination;
/// 实时阻力（String 显示）
@override@JsonKey() final  String sportResistance;
/// 按钮速度值
@override@JsonKey() final  double sportSpeedButton;
/// 按钮坡度值
@override@JsonKey() final  double sportInclinationButton;
/// 按钮阻力值
@override@JsonKey() final  double sportResistanceButton;
/// 是否支持坡度(跑步机)
@override@JsonKey() final  bool hasInclinationSupport;
/// 速度范围
@override@JsonKey() final  int minSpeed;
@override@JsonKey() final  int maxSpeed;
/// 坡度范围
@override@JsonKey() final  int minInclination;
@override@JsonKey() final  int maxInclination;
/// 阻力范围
@override@JsonKey() final  int minResistance;
@override@JsonKey() final  int maxResistance;
/// 当前动作索引
@override@JsonKey() final  int playIndex;
/// 当前动作总时长(秒)
@override@JsonKey() final  int currentDuration;
/// 当前动作已播放时长(秒)
@override@JsonKey() final  int playIndexDuration;
/// 课程总已播放时长(秒)
@override@JsonKey() final  int playTotalDuration;
/// 课程总进度总时长(秒)
@override@JsonKey() final  int totalPlayProgressDuration;
/// 当前动画帧索引
@override@JsonKey() final  int imagePlayIndex;
/// 动画帧率
@override@JsonKey() final  int imageFps;
/// 本地图片资源根路径（对应旧版 rootImagePath）
/// 格式示例："/var/mobile/.../course/actionImage/"
/// 拼接规则："${rootImagePath}${imageName}/${imagePlayIndex}.png"
@override@JsonKey() final  String rootImagePath;
/// 本地 BGM 资源根路径
/// 格式示例："/var/mobile/.../course/bgm/"
@override@JsonKey() final  String rootBgmPath;
/// 本地 Voice 资源根路径
/// 格式示例："/var/mobile/.../course/voice/"
@override@JsonKey() final  String rootVoicePath;
/// 播放进度百分比 (0.0-1.0)，控制底部箭头位置
@override@JsonKey() final  double playProgressPercent;
/// 动作列表（对应旧 courseActionList）
 final  List<ActionItemState> _courseActions;
/// 动作列表（对应旧 courseActionList）
@override@JsonKey() List<ActionItemState> get courseActions {
  if (_courseActions is EqualUnmodifiableListView) return _courseActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_courseActions);
}

/// 右侧动作名称列表
 final  List<String> _currentActionNameList;
/// 右侧动作名称列表
@override@JsonKey() List<String> get currentActionNameList {
  if (_currentActionNameList is EqualUnmodifiableListView) return _currentActionNameList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_currentActionNameList);
}

/// 进度条分段数据（对应旧 _automaticProgressBarFloatingWidget）
 final  List<GymProgressSegment> _progressSegments;
/// 进度条分段数据（对应旧 _automaticProgressBarFloatingWidget）
@override@JsonKey() List<GymProgressSegment> get progressSegments {
  if (_progressSegments is EqualUnmodifiableListView) return _progressSegments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_progressSegments);
}

/// 结束页数据图标路径
 final  List<String> _finishDataIcons;
/// 结束页数据图标路径
@override@JsonKey() List<String> get finishDataIcons {
  if (_finishDataIcons is EqualUnmodifiableListView) return _finishDataIcons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_finishDataIcons);
}

/// 结束页数据标题
 final  List<String> _finishDataTitles;
/// 结束页数据标题
@override@JsonKey() List<String> get finishDataTitles {
  if (_finishDataTitles is EqualUnmodifiableListView) return _finishDataTitles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_finishDataTitles);
}

/// 结束页数据值
 final  List<String> _finishDataValues;
/// 结束页数据值
@override@JsonKey() List<String> get finishDataValues {
  if (_finishDataValues is EqualUnmodifiableListView) return _finishDataValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_finishDataValues);
}

/// 结束页数据单位
 final  List<String> _finishDataUnits;
/// 结束页数据单位
@override@JsonKey() List<String> get finishDataUnits {
  if (_finishDataUnits is EqualUnmodifiableListView) return _finishDataUnits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_finishDataUnits);
}

/// 评分标题
 final  List<String> _ratingTitles;
/// 评分标题
@override@JsonKey() List<String> get ratingTitles {
  if (_ratingTitles is EqualUnmodifiableListView) return _ratingTitles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ratingTitles);
}

/// 评分等级（0-5）
 final  List<int> _ratingScores;
/// 评分等级（0-5）
@override@JsonKey() List<int> get ratingScores {
  if (_ratingScores is EqualUnmodifiableListView) return _ratingScores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ratingScores);
}

/// 评分等级文字（例如 "Level A"）
@override@JsonKey() final  String scoreLevel;
/// 等级对应的图片索引（0-5）
 final  List<int> _ratingImageIndices;
/// 等级对应的图片索引（0-5）
@override@JsonKey() List<int> get ratingImageIndices {
  if (_ratingImageIndices is EqualUnmodifiableListView) return _ratingImageIndices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ratingImageIndices);
}

/// 速度图表数据（每 5 秒采样）
 final  List<double> _speedChartData;
/// 速度图表数据（每 5 秒采样）
@override@JsonKey() List<double> get speedChartData {
  if (_speedChartData is EqualUnmodifiableListView) return _speedChartData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_speedChartData);
}

/// 最大踏频 (rpm)
@override@JsonKey() final  int maxCadence;
/// 最大心率 (bpm)
@override@JsonKey() final  int maxHeartRate;
/// 最大配速 (min/km)
@override@JsonKey() final  double maxPace;
/// 平均阻力
@override@JsonKey() final  double avgResistance;
/// 平均坡度
@override@JsonKey() final  double avgInclination;
/// 平均桨频 (spm)
@override@JsonKey() final  double avgStrokeRate;
/// 完成度百分比 (0-100)
@override@JsonKey() final  double finishPercent;

/// Create a copy of GymCoursePlayState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GymCoursePlayStateCopyWith<_GymCoursePlayState> get copyWith => __$GymCoursePlayStateCopyWithImpl<_GymCoursePlayState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GymCoursePlayState&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.screenStatus, screenStatus) || other.screenStatus == screenStatus)&&(identical(other.allowTouch, allowTouch) || other.allowTouch == allowTouch)&&(identical(other.showPlayButton, showPlayButton) || other.showPlayButton == showPlayButton)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isPause, isPause) || other.isPause == isPause)&&(identical(other.isPauseScreen, isPauseScreen) || other.isPauseScreen == isPauseScreen)&&(identical(other.isStopScreen, isStopScreen) || other.isStopScreen == isStopScreen)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.level, level) || other.level == level)&&(identical(other.targetResistanceLevel, targetResistanceLevel) || other.targetResistanceLevel == targetResistanceLevel)&&(identical(other.sportTime, sportTime) || other.sportTime == sportTime)&&(identical(other.sportDistance, sportDistance) || other.sportDistance == sportDistance)&&(identical(other.sportCalories, sportCalories) || other.sportCalories == sportCalories)&&(identical(other.sportSpeed, sportSpeed) || other.sportSpeed == sportSpeed)&&(identical(other.sportDeviceSpeed, sportDeviceSpeed) || other.sportDeviceSpeed == sportDeviceSpeed)&&(identical(other.sportHeartRate, sportHeartRate) || other.sportHeartRate == sportHeartRate)&&(identical(other.sportCadence, sportCadence) || other.sportCadence == sportCadence)&&(identical(other.sportStrokeRate, sportStrokeRate) || other.sportStrokeRate == sportStrokeRate)&&(identical(other.sportStrokeCount, sportStrokeCount) || other.sportStrokeCount == sportStrokeCount)&&(identical(other.sportInclination, sportInclination) || other.sportInclination == sportInclination)&&(identical(other.sportResistance, sportResistance) || other.sportResistance == sportResistance)&&(identical(other.sportSpeedButton, sportSpeedButton) || other.sportSpeedButton == sportSpeedButton)&&(identical(other.sportInclinationButton, sportInclinationButton) || other.sportInclinationButton == sportInclinationButton)&&(identical(other.sportResistanceButton, sportResistanceButton) || other.sportResistanceButton == sportResistanceButton)&&(identical(other.hasInclinationSupport, hasInclinationSupport) || other.hasInclinationSupport == hasInclinationSupport)&&(identical(other.minSpeed, minSpeed) || other.minSpeed == minSpeed)&&(identical(other.maxSpeed, maxSpeed) || other.maxSpeed == maxSpeed)&&(identical(other.minInclination, minInclination) || other.minInclination == minInclination)&&(identical(other.maxInclination, maxInclination) || other.maxInclination == maxInclination)&&(identical(other.minResistance, minResistance) || other.minResistance == minResistance)&&(identical(other.maxResistance, maxResistance) || other.maxResistance == maxResistance)&&(identical(other.playIndex, playIndex) || other.playIndex == playIndex)&&(identical(other.currentDuration, currentDuration) || other.currentDuration == currentDuration)&&(identical(other.playIndexDuration, playIndexDuration) || other.playIndexDuration == playIndexDuration)&&(identical(other.playTotalDuration, playTotalDuration) || other.playTotalDuration == playTotalDuration)&&(identical(other.totalPlayProgressDuration, totalPlayProgressDuration) || other.totalPlayProgressDuration == totalPlayProgressDuration)&&(identical(other.imagePlayIndex, imagePlayIndex) || other.imagePlayIndex == imagePlayIndex)&&(identical(other.imageFps, imageFps) || other.imageFps == imageFps)&&(identical(other.rootImagePath, rootImagePath) || other.rootImagePath == rootImagePath)&&(identical(other.rootBgmPath, rootBgmPath) || other.rootBgmPath == rootBgmPath)&&(identical(other.rootVoicePath, rootVoicePath) || other.rootVoicePath == rootVoicePath)&&(identical(other.playProgressPercent, playProgressPercent) || other.playProgressPercent == playProgressPercent)&&const DeepCollectionEquality().equals(other._courseActions, _courseActions)&&const DeepCollectionEquality().equals(other._currentActionNameList, _currentActionNameList)&&const DeepCollectionEquality().equals(other._progressSegments, _progressSegments)&&const DeepCollectionEquality().equals(other._finishDataIcons, _finishDataIcons)&&const DeepCollectionEquality().equals(other._finishDataTitles, _finishDataTitles)&&const DeepCollectionEquality().equals(other._finishDataValues, _finishDataValues)&&const DeepCollectionEquality().equals(other._finishDataUnits, _finishDataUnits)&&const DeepCollectionEquality().equals(other._ratingTitles, _ratingTitles)&&const DeepCollectionEquality().equals(other._ratingScores, _ratingScores)&&(identical(other.scoreLevel, scoreLevel) || other.scoreLevel == scoreLevel)&&const DeepCollectionEquality().equals(other._ratingImageIndices, _ratingImageIndices)&&const DeepCollectionEquality().equals(other._speedChartData, _speedChartData)&&(identical(other.maxCadence, maxCadence) || other.maxCadence == maxCadence)&&(identical(other.maxHeartRate, maxHeartRate) || other.maxHeartRate == maxHeartRate)&&(identical(other.maxPace, maxPace) || other.maxPace == maxPace)&&(identical(other.avgResistance, avgResistance) || other.avgResistance == avgResistance)&&(identical(other.avgInclination, avgInclination) || other.avgInclination == avgInclination)&&(identical(other.avgStrokeRate, avgStrokeRate) || other.avgStrokeRate == avgStrokeRate)&&(identical(other.finishPercent, finishPercent) || other.finishPercent == finishPercent));
}


@override
int get hashCode => Object.hashAll([runtimeType,deviceType,screenStatus,allowTouch,showPlayButton,isPlaying,isPause,isPauseScreen,isStopScreen,courseTitle,difficulty,level,targetResistanceLevel,sportTime,sportDistance,sportCalories,sportSpeed,sportDeviceSpeed,sportHeartRate,sportCadence,sportStrokeRate,sportStrokeCount,sportInclination,sportResistance,sportSpeedButton,sportInclinationButton,sportResistanceButton,hasInclinationSupport,minSpeed,maxSpeed,minInclination,maxInclination,minResistance,maxResistance,playIndex,currentDuration,playIndexDuration,playTotalDuration,totalPlayProgressDuration,imagePlayIndex,imageFps,rootImagePath,rootBgmPath,rootVoicePath,playProgressPercent,const DeepCollectionEquality().hash(_courseActions),const DeepCollectionEquality().hash(_currentActionNameList),const DeepCollectionEquality().hash(_progressSegments),const DeepCollectionEquality().hash(_finishDataIcons),const DeepCollectionEquality().hash(_finishDataTitles),const DeepCollectionEquality().hash(_finishDataValues),const DeepCollectionEquality().hash(_finishDataUnits),const DeepCollectionEquality().hash(_ratingTitles),const DeepCollectionEquality().hash(_ratingScores),scoreLevel,const DeepCollectionEquality().hash(_ratingImageIndices),const DeepCollectionEquality().hash(_speedChartData),maxCadence,maxHeartRate,maxPace,avgResistance,avgInclination,avgStrokeRate,finishPercent]);

@override
String toString() {
  return 'GymCoursePlayState(deviceType: $deviceType, screenStatus: $screenStatus, allowTouch: $allowTouch, showPlayButton: $showPlayButton, isPlaying: $isPlaying, isPause: $isPause, isPauseScreen: $isPauseScreen, isStopScreen: $isStopScreen, courseTitle: $courseTitle, difficulty: $difficulty, level: $level, targetResistanceLevel: $targetResistanceLevel, sportTime: $sportTime, sportDistance: $sportDistance, sportCalories: $sportCalories, sportSpeed: $sportSpeed, sportDeviceSpeed: $sportDeviceSpeed, sportHeartRate: $sportHeartRate, sportCadence: $sportCadence, sportStrokeRate: $sportStrokeRate, sportStrokeCount: $sportStrokeCount, sportInclination: $sportInclination, sportResistance: $sportResistance, sportSpeedButton: $sportSpeedButton, sportInclinationButton: $sportInclinationButton, sportResistanceButton: $sportResistanceButton, hasInclinationSupport: $hasInclinationSupport, minSpeed: $minSpeed, maxSpeed: $maxSpeed, minInclination: $minInclination, maxInclination: $maxInclination, minResistance: $minResistance, maxResistance: $maxResistance, playIndex: $playIndex, currentDuration: $currentDuration, playIndexDuration: $playIndexDuration, playTotalDuration: $playTotalDuration, totalPlayProgressDuration: $totalPlayProgressDuration, imagePlayIndex: $imagePlayIndex, imageFps: $imageFps, rootImagePath: $rootImagePath, rootBgmPath: $rootBgmPath, rootVoicePath: $rootVoicePath, playProgressPercent: $playProgressPercent, courseActions: $courseActions, currentActionNameList: $currentActionNameList, progressSegments: $progressSegments, finishDataIcons: $finishDataIcons, finishDataTitles: $finishDataTitles, finishDataValues: $finishDataValues, finishDataUnits: $finishDataUnits, ratingTitles: $ratingTitles, ratingScores: $ratingScores, scoreLevel: $scoreLevel, ratingImageIndices: $ratingImageIndices, speedChartData: $speedChartData, maxCadence: $maxCadence, maxHeartRate: $maxHeartRate, maxPace: $maxPace, avgResistance: $avgResistance, avgInclination: $avgInclination, avgStrokeRate: $avgStrokeRate, finishPercent: $finishPercent)';
}


}

/// @nodoc
abstract mixin class _$GymCoursePlayStateCopyWith<$Res> implements $GymCoursePlayStateCopyWith<$Res> {
  factory _$GymCoursePlayStateCopyWith(_GymCoursePlayState value, $Res Function(_GymCoursePlayState) _then) = __$GymCoursePlayStateCopyWithImpl;
@override @useResult
$Res call({
 FtmsDeviceType deviceType, GymPlayScreenStatus screenStatus, bool allowTouch, bool showPlayButton, bool isPlaying, bool isPause, bool isPauseScreen, bool isStopScreen, String courseTitle, String difficulty, int level, int targetResistanceLevel, String sportTime, String sportDistance, String sportCalories, String sportSpeed, double sportDeviceSpeed, String sportHeartRate, String sportCadence, String sportStrokeRate, String sportStrokeCount, String sportInclination, String sportResistance, double sportSpeedButton, double sportInclinationButton, double sportResistanceButton, bool hasInclinationSupport, int minSpeed, int maxSpeed, int minInclination, int maxInclination, int minResistance, int maxResistance, int playIndex, int currentDuration, int playIndexDuration, int playTotalDuration, int totalPlayProgressDuration, int imagePlayIndex, int imageFps, String rootImagePath, String rootBgmPath, String rootVoicePath, double playProgressPercent, List<ActionItemState> courseActions, List<String> currentActionNameList, List<GymProgressSegment> progressSegments, List<String> finishDataIcons, List<String> finishDataTitles, List<String> finishDataValues, List<String> finishDataUnits, List<String> ratingTitles, List<int> ratingScores, String scoreLevel, List<int> ratingImageIndices, List<double> speedChartData, int maxCadence, int maxHeartRate, double maxPace, double avgResistance, double avgInclination, double avgStrokeRate, double finishPercent
});




}
/// @nodoc
class __$GymCoursePlayStateCopyWithImpl<$Res>
    implements _$GymCoursePlayStateCopyWith<$Res> {
  __$GymCoursePlayStateCopyWithImpl(this._self, this._then);

  final _GymCoursePlayState _self;
  final $Res Function(_GymCoursePlayState) _then;

/// Create a copy of GymCoursePlayState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceType = null,Object? screenStatus = null,Object? allowTouch = null,Object? showPlayButton = null,Object? isPlaying = null,Object? isPause = null,Object? isPauseScreen = null,Object? isStopScreen = null,Object? courseTitle = null,Object? difficulty = null,Object? level = null,Object? targetResistanceLevel = null,Object? sportTime = null,Object? sportDistance = null,Object? sportCalories = null,Object? sportSpeed = null,Object? sportDeviceSpeed = null,Object? sportHeartRate = null,Object? sportCadence = null,Object? sportStrokeRate = null,Object? sportStrokeCount = null,Object? sportInclination = null,Object? sportResistance = null,Object? sportSpeedButton = null,Object? sportInclinationButton = null,Object? sportResistanceButton = null,Object? hasInclinationSupport = null,Object? minSpeed = null,Object? maxSpeed = null,Object? minInclination = null,Object? maxInclination = null,Object? minResistance = null,Object? maxResistance = null,Object? playIndex = null,Object? currentDuration = null,Object? playIndexDuration = null,Object? playTotalDuration = null,Object? totalPlayProgressDuration = null,Object? imagePlayIndex = null,Object? imageFps = null,Object? rootImagePath = null,Object? rootBgmPath = null,Object? rootVoicePath = null,Object? playProgressPercent = null,Object? courseActions = null,Object? currentActionNameList = null,Object? progressSegments = null,Object? finishDataIcons = null,Object? finishDataTitles = null,Object? finishDataValues = null,Object? finishDataUnits = null,Object? ratingTitles = null,Object? ratingScores = null,Object? scoreLevel = null,Object? ratingImageIndices = null,Object? speedChartData = null,Object? maxCadence = null,Object? maxHeartRate = null,Object? maxPace = null,Object? avgResistance = null,Object? avgInclination = null,Object? avgStrokeRate = null,Object? finishPercent = null,}) {
  return _then(_GymCoursePlayState(
deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as FtmsDeviceType,screenStatus: null == screenStatus ? _self.screenStatus : screenStatus // ignore: cast_nullable_to_non_nullable
as GymPlayScreenStatus,allowTouch: null == allowTouch ? _self.allowTouch : allowTouch // ignore: cast_nullable_to_non_nullable
as bool,showPlayButton: null == showPlayButton ? _self.showPlayButton : showPlayButton // ignore: cast_nullable_to_non_nullable
as bool,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isPause: null == isPause ? _self.isPause : isPause // ignore: cast_nullable_to_non_nullable
as bool,isPauseScreen: null == isPauseScreen ? _self.isPauseScreen : isPauseScreen // ignore: cast_nullable_to_non_nullable
as bool,isStopScreen: null == isStopScreen ? _self.isStopScreen : isStopScreen // ignore: cast_nullable_to_non_nullable
as bool,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,targetResistanceLevel: null == targetResistanceLevel ? _self.targetResistanceLevel : targetResistanceLevel // ignore: cast_nullable_to_non_nullable
as int,sportTime: null == sportTime ? _self.sportTime : sportTime // ignore: cast_nullable_to_non_nullable
as String,sportDistance: null == sportDistance ? _self.sportDistance : sportDistance // ignore: cast_nullable_to_non_nullable
as String,sportCalories: null == sportCalories ? _self.sportCalories : sportCalories // ignore: cast_nullable_to_non_nullable
as String,sportSpeed: null == sportSpeed ? _self.sportSpeed : sportSpeed // ignore: cast_nullable_to_non_nullable
as String,sportDeviceSpeed: null == sportDeviceSpeed ? _self.sportDeviceSpeed : sportDeviceSpeed // ignore: cast_nullable_to_non_nullable
as double,sportHeartRate: null == sportHeartRate ? _self.sportHeartRate : sportHeartRate // ignore: cast_nullable_to_non_nullable
as String,sportCadence: null == sportCadence ? _self.sportCadence : sportCadence // ignore: cast_nullable_to_non_nullable
as String,sportStrokeRate: null == sportStrokeRate ? _self.sportStrokeRate : sportStrokeRate // ignore: cast_nullable_to_non_nullable
as String,sportStrokeCount: null == sportStrokeCount ? _self.sportStrokeCount : sportStrokeCount // ignore: cast_nullable_to_non_nullable
as String,sportInclination: null == sportInclination ? _self.sportInclination : sportInclination // ignore: cast_nullable_to_non_nullable
as String,sportResistance: null == sportResistance ? _self.sportResistance : sportResistance // ignore: cast_nullable_to_non_nullable
as String,sportSpeedButton: null == sportSpeedButton ? _self.sportSpeedButton : sportSpeedButton // ignore: cast_nullable_to_non_nullable
as double,sportInclinationButton: null == sportInclinationButton ? _self.sportInclinationButton : sportInclinationButton // ignore: cast_nullable_to_non_nullable
as double,sportResistanceButton: null == sportResistanceButton ? _self.sportResistanceButton : sportResistanceButton // ignore: cast_nullable_to_non_nullable
as double,hasInclinationSupport: null == hasInclinationSupport ? _self.hasInclinationSupport : hasInclinationSupport // ignore: cast_nullable_to_non_nullable
as bool,minSpeed: null == minSpeed ? _self.minSpeed : minSpeed // ignore: cast_nullable_to_non_nullable
as int,maxSpeed: null == maxSpeed ? _self.maxSpeed : maxSpeed // ignore: cast_nullable_to_non_nullable
as int,minInclination: null == minInclination ? _self.minInclination : minInclination // ignore: cast_nullable_to_non_nullable
as int,maxInclination: null == maxInclination ? _self.maxInclination : maxInclination // ignore: cast_nullable_to_non_nullable
as int,minResistance: null == minResistance ? _self.minResistance : minResistance // ignore: cast_nullable_to_non_nullable
as int,maxResistance: null == maxResistance ? _self.maxResistance : maxResistance // ignore: cast_nullable_to_non_nullable
as int,playIndex: null == playIndex ? _self.playIndex : playIndex // ignore: cast_nullable_to_non_nullable
as int,currentDuration: null == currentDuration ? _self.currentDuration : currentDuration // ignore: cast_nullable_to_non_nullable
as int,playIndexDuration: null == playIndexDuration ? _self.playIndexDuration : playIndexDuration // ignore: cast_nullable_to_non_nullable
as int,playTotalDuration: null == playTotalDuration ? _self.playTotalDuration : playTotalDuration // ignore: cast_nullable_to_non_nullable
as int,totalPlayProgressDuration: null == totalPlayProgressDuration ? _self.totalPlayProgressDuration : totalPlayProgressDuration // ignore: cast_nullable_to_non_nullable
as int,imagePlayIndex: null == imagePlayIndex ? _self.imagePlayIndex : imagePlayIndex // ignore: cast_nullable_to_non_nullable
as int,imageFps: null == imageFps ? _self.imageFps : imageFps // ignore: cast_nullable_to_non_nullable
as int,rootImagePath: null == rootImagePath ? _self.rootImagePath : rootImagePath // ignore: cast_nullable_to_non_nullable
as String,rootBgmPath: null == rootBgmPath ? _self.rootBgmPath : rootBgmPath // ignore: cast_nullable_to_non_nullable
as String,rootVoicePath: null == rootVoicePath ? _self.rootVoicePath : rootVoicePath // ignore: cast_nullable_to_non_nullable
as String,playProgressPercent: null == playProgressPercent ? _self.playProgressPercent : playProgressPercent // ignore: cast_nullable_to_non_nullable
as double,courseActions: null == courseActions ? _self._courseActions : courseActions // ignore: cast_nullable_to_non_nullable
as List<ActionItemState>,currentActionNameList: null == currentActionNameList ? _self._currentActionNameList : currentActionNameList // ignore: cast_nullable_to_non_nullable
as List<String>,progressSegments: null == progressSegments ? _self._progressSegments : progressSegments // ignore: cast_nullable_to_non_nullable
as List<GymProgressSegment>,finishDataIcons: null == finishDataIcons ? _self._finishDataIcons : finishDataIcons // ignore: cast_nullable_to_non_nullable
as List<String>,finishDataTitles: null == finishDataTitles ? _self._finishDataTitles : finishDataTitles // ignore: cast_nullable_to_non_nullable
as List<String>,finishDataValues: null == finishDataValues ? _self._finishDataValues : finishDataValues // ignore: cast_nullable_to_non_nullable
as List<String>,finishDataUnits: null == finishDataUnits ? _self._finishDataUnits : finishDataUnits // ignore: cast_nullable_to_non_nullable
as List<String>,ratingTitles: null == ratingTitles ? _self._ratingTitles : ratingTitles // ignore: cast_nullable_to_non_nullable
as List<String>,ratingScores: null == ratingScores ? _self._ratingScores : ratingScores // ignore: cast_nullable_to_non_nullable
as List<int>,scoreLevel: null == scoreLevel ? _self.scoreLevel : scoreLevel // ignore: cast_nullable_to_non_nullable
as String,ratingImageIndices: null == ratingImageIndices ? _self._ratingImageIndices : ratingImageIndices // ignore: cast_nullable_to_non_nullable
as List<int>,speedChartData: null == speedChartData ? _self._speedChartData : speedChartData // ignore: cast_nullable_to_non_nullable
as List<double>,maxCadence: null == maxCadence ? _self.maxCadence : maxCadence // ignore: cast_nullable_to_non_nullable
as int,maxHeartRate: null == maxHeartRate ? _self.maxHeartRate : maxHeartRate // ignore: cast_nullable_to_non_nullable
as int,maxPace: null == maxPace ? _self.maxPace : maxPace // ignore: cast_nullable_to_non_nullable
as double,avgResistance: null == avgResistance ? _self.avgResistance : avgResistance // ignore: cast_nullable_to_non_nullable
as double,avgInclination: null == avgInclination ? _self.avgInclination : avgInclination // ignore: cast_nullable_to_non_nullable
as double,avgStrokeRate: null == avgStrokeRate ? _self.avgStrokeRate : avgStrokeRate // ignore: cast_nullable_to_non_nullable
as double,finishPercent: null == finishPercent ? _self.finishPercent : finishPercent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$ActionItemState {

 String get name; String get imageName; String get bgmName; String get voiceName; int get duration; int get resistance; int get cadence; int get posture; bool get isRestStage; int get imageFps; int get imageLength; int get orderId; int get count; int get distance;
/// Create a copy of ActionItemState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionItemStateCopyWith<ActionItemState> get copyWith => _$ActionItemStateCopyWithImpl<ActionItemState>(this as ActionItemState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionItemState&&(identical(other.name, name) || other.name == name)&&(identical(other.imageName, imageName) || other.imageName == imageName)&&(identical(other.bgmName, bgmName) || other.bgmName == bgmName)&&(identical(other.voiceName, voiceName) || other.voiceName == voiceName)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.resistance, resistance) || other.resistance == resistance)&&(identical(other.cadence, cadence) || other.cadence == cadence)&&(identical(other.posture, posture) || other.posture == posture)&&(identical(other.isRestStage, isRestStage) || other.isRestStage == isRestStage)&&(identical(other.imageFps, imageFps) || other.imageFps == imageFps)&&(identical(other.imageLength, imageLength) || other.imageLength == imageLength)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.count, count) || other.count == count)&&(identical(other.distance, distance) || other.distance == distance));
}


@override
int get hashCode => Object.hash(runtimeType,name,imageName,bgmName,voiceName,duration,resistance,cadence,posture,isRestStage,imageFps,imageLength,orderId,count,distance);

@override
String toString() {
  return 'ActionItemState(name: $name, imageName: $imageName, bgmName: $bgmName, voiceName: $voiceName, duration: $duration, resistance: $resistance, cadence: $cadence, posture: $posture, isRestStage: $isRestStage, imageFps: $imageFps, imageLength: $imageLength, orderId: $orderId, count: $count, distance: $distance)';
}


}

/// @nodoc
abstract mixin class $ActionItemStateCopyWith<$Res>  {
  factory $ActionItemStateCopyWith(ActionItemState value, $Res Function(ActionItemState) _then) = _$ActionItemStateCopyWithImpl;
@useResult
$Res call({
 String name, String imageName, String bgmName, String voiceName, int duration, int resistance, int cadence, int posture, bool isRestStage, int imageFps, int imageLength, int orderId, int count, int distance
});




}
/// @nodoc
class _$ActionItemStateCopyWithImpl<$Res>
    implements $ActionItemStateCopyWith<$Res> {
  _$ActionItemStateCopyWithImpl(this._self, this._then);

  final ActionItemState _self;
  final $Res Function(ActionItemState) _then;

/// Create a copy of ActionItemState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? imageName = null,Object? bgmName = null,Object? voiceName = null,Object? duration = null,Object? resistance = null,Object? cadence = null,Object? posture = null,Object? isRestStage = null,Object? imageFps = null,Object? imageLength = null,Object? orderId = null,Object? count = null,Object? distance = null,}) {
  return _then(ActionItemState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageName: null == imageName ? _self.imageName : imageName // ignore: cast_nullable_to_non_nullable
as String,bgmName: null == bgmName ? _self.bgmName : bgmName // ignore: cast_nullable_to_non_nullable
as String,voiceName: null == voiceName ? _self.voiceName : voiceName // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,resistance: null == resistance ? _self.resistance : resistance // ignore: cast_nullable_to_non_nullable
as int,cadence: null == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as int,posture: null == posture ? _self.posture : posture // ignore: cast_nullable_to_non_nullable
as int,isRestStage: null == isRestStage ? _self.isRestStage : isRestStage // ignore: cast_nullable_to_non_nullable
as bool,imageFps: null == imageFps ? _self.imageFps : imageFps // ignore: cast_nullable_to_non_nullable
as int,imageLength: null == imageLength ? _self.imageLength : imageLength // ignore: cast_nullable_to_non_nullable
as int,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionItemState].
extension ActionItemStatePatterns on ActionItemState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionItemState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionItemState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionItemState value)  $default,){
final _that = this;
switch (_that) {
case _ActionItemState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionItemState value)?  $default,){
final _that = this;
switch (_that) {
case _ActionItemState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String imageName,  String bgmName,  String voiceName,  int duration,  int resistance,  int cadence,  int posture,  bool isRestStage,  int imageFps,  int imageLength,  int orderId,  int count,  int distance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionItemState() when $default != null:
return $default(_that.name,_that.imageName,_that.bgmName,_that.voiceName,_that.duration,_that.resistance,_that.cadence,_that.posture,_that.isRestStage,_that.imageFps,_that.imageLength,_that.orderId,_that.count,_that.distance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String imageName,  String bgmName,  String voiceName,  int duration,  int resistance,  int cadence,  int posture,  bool isRestStage,  int imageFps,  int imageLength,  int orderId,  int count,  int distance)  $default,) {final _that = this;
switch (_that) {
case _ActionItemState():
return $default(_that.name,_that.imageName,_that.bgmName,_that.voiceName,_that.duration,_that.resistance,_that.cadence,_that.posture,_that.isRestStage,_that.imageFps,_that.imageLength,_that.orderId,_that.count,_that.distance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String imageName,  String bgmName,  String voiceName,  int duration,  int resistance,  int cadence,  int posture,  bool isRestStage,  int imageFps,  int imageLength,  int orderId,  int count,  int distance)?  $default,) {final _that = this;
switch (_that) {
case _ActionItemState() when $default != null:
return $default(_that.name,_that.imageName,_that.bgmName,_that.voiceName,_that.duration,_that.resistance,_that.cadence,_that.posture,_that.isRestStage,_that.imageFps,_that.imageLength,_that.orderId,_that.count,_that.distance);case _:
  return null;

}
}

}

/// @nodoc


class _ActionItemState implements ActionItemState {
  const _ActionItemState({this.name = 'Warm Up', this.imageName = '', this.bgmName = '', this.voiceName = '', this.duration = 60, this.resistance = 3, this.cadence = 25, this.posture = 0, this.isRestStage = false, this.imageFps = 30, this.imageLength = 300, this.orderId = 0, this.count = 0, this.distance = 0});
  

@override@JsonKey() final  String name;
@override@JsonKey() final  String imageName;
@override@JsonKey() final  String bgmName;
@override@JsonKey() final  String voiceName;
@override@JsonKey() final  int duration;
@override@JsonKey() final  int resistance;
@override@JsonKey() final  int cadence;
@override@JsonKey() final  int posture;
@override@JsonKey() final  bool isRestStage;
@override@JsonKey() final  int imageFps;
@override@JsonKey() final  int imageLength;
@override@JsonKey() final  int orderId;
@override@JsonKey() final  int count;
@override@JsonKey() final  int distance;

/// Create a copy of ActionItemState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionItemStateCopyWith<_ActionItemState> get copyWith => __$ActionItemStateCopyWithImpl<_ActionItemState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionItemState&&(identical(other.name, name) || other.name == name)&&(identical(other.imageName, imageName) || other.imageName == imageName)&&(identical(other.bgmName, bgmName) || other.bgmName == bgmName)&&(identical(other.voiceName, voiceName) || other.voiceName == voiceName)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.resistance, resistance) || other.resistance == resistance)&&(identical(other.cadence, cadence) || other.cadence == cadence)&&(identical(other.posture, posture) || other.posture == posture)&&(identical(other.isRestStage, isRestStage) || other.isRestStage == isRestStage)&&(identical(other.imageFps, imageFps) || other.imageFps == imageFps)&&(identical(other.imageLength, imageLength) || other.imageLength == imageLength)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.count, count) || other.count == count)&&(identical(other.distance, distance) || other.distance == distance));
}


@override
int get hashCode => Object.hash(runtimeType,name,imageName,bgmName,voiceName,duration,resistance,cadence,posture,isRestStage,imageFps,imageLength,orderId,count,distance);

@override
String toString() {
  return 'ActionItemState(name: $name, imageName: $imageName, bgmName: $bgmName, voiceName: $voiceName, duration: $duration, resistance: $resistance, cadence: $cadence, posture: $posture, isRestStage: $isRestStage, imageFps: $imageFps, imageLength: $imageLength, orderId: $orderId, count: $count, distance: $distance)';
}


}

/// @nodoc
abstract mixin class _$ActionItemStateCopyWith<$Res> implements $ActionItemStateCopyWith<$Res> {
  factory _$ActionItemStateCopyWith(_ActionItemState value, $Res Function(_ActionItemState) _then) = __$ActionItemStateCopyWithImpl;
@override @useResult
$Res call({
 String name, String imageName, String bgmName, String voiceName, int duration, int resistance, int cadence, int posture, bool isRestStage, int imageFps, int imageLength, int orderId, int count, int distance
});




}
/// @nodoc
class __$ActionItemStateCopyWithImpl<$Res>
    implements _$ActionItemStateCopyWith<$Res> {
  __$ActionItemStateCopyWithImpl(this._self, this._then);

  final _ActionItemState _self;
  final $Res Function(_ActionItemState) _then;

/// Create a copy of ActionItemState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? imageName = null,Object? bgmName = null,Object? voiceName = null,Object? duration = null,Object? resistance = null,Object? cadence = null,Object? posture = null,Object? isRestStage = null,Object? imageFps = null,Object? imageLength = null,Object? orderId = null,Object? count = null,Object? distance = null,}) {
  return _then(_ActionItemState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageName: null == imageName ? _self.imageName : imageName // ignore: cast_nullable_to_non_nullable
as String,bgmName: null == bgmName ? _self.bgmName : bgmName // ignore: cast_nullable_to_non_nullable
as String,voiceName: null == voiceName ? _self.voiceName : voiceName // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,resistance: null == resistance ? _self.resistance : resistance // ignore: cast_nullable_to_non_nullable
as int,cadence: null == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as int,posture: null == posture ? _self.posture : posture // ignore: cast_nullable_to_non_nullable
as int,isRestStage: null == isRestStage ? _self.isRestStage : isRestStage // ignore: cast_nullable_to_non_nullable
as bool,imageFps: null == imageFps ? _self.imageFps : imageFps // ignore: cast_nullable_to_non_nullable
as int,imageLength: null == imageLength ? _self.imageLength : imageLength // ignore: cast_nullable_to_non_nullable
as int,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
