// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecordDetailState {

 SportHistory? get currentRecord; SportHistory? get previousRecord; bool get isLoading;
/// Create a copy of RecordDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordDetailStateCopyWith<RecordDetailState> get copyWith => _$RecordDetailStateCopyWithImpl<RecordDetailState>(this as RecordDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordDetailState&&(identical(other.currentRecord, currentRecord) || other.currentRecord == currentRecord)&&(identical(other.previousRecord, previousRecord) || other.previousRecord == previousRecord)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,currentRecord,previousRecord,isLoading);

@override
String toString() {
  return 'RecordDetailState(currentRecord: $currentRecord, previousRecord: $previousRecord, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $RecordDetailStateCopyWith<$Res>  {
  factory $RecordDetailStateCopyWith(RecordDetailState value, $Res Function(RecordDetailState) _then) = _$RecordDetailStateCopyWithImpl;
@useResult
$Res call({
 SportHistory? currentRecord, SportHistory? previousRecord, bool isLoading
});


$SportHistoryCopyWith<$Res>? get currentRecord;$SportHistoryCopyWith<$Res>? get previousRecord;

}
/// @nodoc
class _$RecordDetailStateCopyWithImpl<$Res>
    implements $RecordDetailStateCopyWith<$Res> {
  _$RecordDetailStateCopyWithImpl(this._self, this._then);

  final RecordDetailState _self;
  final $Res Function(RecordDetailState) _then;

/// Create a copy of RecordDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentRecord = freezed,Object? previousRecord = freezed,Object? isLoading = null,}) {
  return _then(RecordDetailState(
currentRecord: freezed == currentRecord ? _self.currentRecord : currentRecord // ignore: cast_nullable_to_non_nullable
as SportHistory?,previousRecord: freezed == previousRecord ? _self.previousRecord : previousRecord // ignore: cast_nullable_to_non_nullable
as SportHistory?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of RecordDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SportHistoryCopyWith<$Res>? get currentRecord {
    if (_self.currentRecord == null) {
    return null;
  }

  return $SportHistoryCopyWith<$Res>(_self.currentRecord!, (value) {
    return _then(_self.copyWith(currentRecord: value));
  });
}/// Create a copy of RecordDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SportHistoryCopyWith<$Res>? get previousRecord {
    if (_self.previousRecord == null) {
    return null;
  }

  return $SportHistoryCopyWith<$Res>(_self.previousRecord!, (value) {
    return _then(_self.copyWith(previousRecord: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecordDetailState].
extension RecordDetailStatePatterns on RecordDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordDetailState value)  $default,){
final _that = this;
switch (_that) {
case _RecordDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _RecordDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SportHistory? currentRecord,  SportHistory? previousRecord,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordDetailState() when $default != null:
return $default(_that.currentRecord,_that.previousRecord,_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SportHistory? currentRecord,  SportHistory? previousRecord,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _RecordDetailState():
return $default(_that.currentRecord,_that.previousRecord,_that.isLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SportHistory? currentRecord,  SportHistory? previousRecord,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _RecordDetailState() when $default != null:
return $default(_that.currentRecord,_that.previousRecord,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _RecordDetailState implements RecordDetailState {
  const _RecordDetailState({this.currentRecord, this.previousRecord, this.isLoading = true});
  

@override final  SportHistory? currentRecord;
@override final  SportHistory? previousRecord;
@override@JsonKey() final  bool isLoading;

/// Create a copy of RecordDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordDetailStateCopyWith<_RecordDetailState> get copyWith => __$RecordDetailStateCopyWithImpl<_RecordDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordDetailState&&(identical(other.currentRecord, currentRecord) || other.currentRecord == currentRecord)&&(identical(other.previousRecord, previousRecord) || other.previousRecord == previousRecord)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,currentRecord,previousRecord,isLoading);

@override
String toString() {
  return 'RecordDetailState(currentRecord: $currentRecord, previousRecord: $previousRecord, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$RecordDetailStateCopyWith<$Res> implements $RecordDetailStateCopyWith<$Res> {
  factory _$RecordDetailStateCopyWith(_RecordDetailState value, $Res Function(_RecordDetailState) _then) = __$RecordDetailStateCopyWithImpl;
@override @useResult
$Res call({
 SportHistory? currentRecord, SportHistory? previousRecord, bool isLoading
});


@override $SportHistoryCopyWith<$Res>? get currentRecord;@override $SportHistoryCopyWith<$Res>? get previousRecord;

}
/// @nodoc
class __$RecordDetailStateCopyWithImpl<$Res>
    implements _$RecordDetailStateCopyWith<$Res> {
  __$RecordDetailStateCopyWithImpl(this._self, this._then);

  final _RecordDetailState _self;
  final $Res Function(_RecordDetailState) _then;

/// Create a copy of RecordDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentRecord = freezed,Object? previousRecord = freezed,Object? isLoading = null,}) {
  return _then(_RecordDetailState(
currentRecord: freezed == currentRecord ? _self.currentRecord : currentRecord // ignore: cast_nullable_to_non_nullable
as SportHistory?,previousRecord: freezed == previousRecord ? _self.previousRecord : previousRecord // ignore: cast_nullable_to_non_nullable
as SportHistory?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of RecordDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SportHistoryCopyWith<$Res>? get currentRecord {
    if (_self.currentRecord == null) {
    return null;
  }

  return $SportHistoryCopyWith<$Res>(_self.currentRecord!, (value) {
    return _then(_self.copyWith(currentRecord: value));
  });
}/// Create a copy of RecordDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SportHistoryCopyWith<$Res>? get previousRecord {
    if (_self.previousRecord == null) {
    return null;
  }

  return $SportHistoryCopyWith<$Res>(_self.previousRecord!, (value) {
    return _then(_self.copyWith(previousRecord: value));
  });
}
}

// dart format on
