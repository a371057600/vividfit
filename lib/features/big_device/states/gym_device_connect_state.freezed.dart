// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gym_device_connect_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GymDeviceConnectState {

/// 是否正在搜索(对应旧 searchStatus)。
 bool get isSearching;/// 设备是否已连接(对应旧 isDeviceConnect)。
 bool get isEquipmentConnected;/// 已发现设备的广播名列表(对应旧 showDeviceName.map(advName))。
 List<String> get foundDeviceNames;/// 是否曾经连接过(对应旧 _hasConnected,用于断连 toast 抑制)。
 bool get hasConnectedOnce;
/// Create a copy of GymDeviceConnectState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GymDeviceConnectStateCopyWith<GymDeviceConnectState> get copyWith => _$GymDeviceConnectStateCopyWithImpl<GymDeviceConnectState>(this as GymDeviceConnectState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GymDeviceConnectState&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.isEquipmentConnected, isEquipmentConnected) || other.isEquipmentConnected == isEquipmentConnected)&&const DeepCollectionEquality().equals(other.foundDeviceNames, foundDeviceNames)&&(identical(other.hasConnectedOnce, hasConnectedOnce) || other.hasConnectedOnce == hasConnectedOnce));
}


@override
int get hashCode => Object.hash(runtimeType,isSearching,isEquipmentConnected,const DeepCollectionEquality().hash(foundDeviceNames),hasConnectedOnce);

@override
String toString() {
  return 'GymDeviceConnectState(isSearching: $isSearching, isEquipmentConnected: $isEquipmentConnected, foundDeviceNames: $foundDeviceNames, hasConnectedOnce: $hasConnectedOnce)';
}


}

/// @nodoc
abstract mixin class $GymDeviceConnectStateCopyWith<$Res>  {
  factory $GymDeviceConnectStateCopyWith(GymDeviceConnectState value, $Res Function(GymDeviceConnectState) _then) = _$GymDeviceConnectStateCopyWithImpl;
@useResult
$Res call({
 bool isSearching, bool isEquipmentConnected, List<String> foundDeviceNames, bool hasConnectedOnce
});




}
/// @nodoc
class _$GymDeviceConnectStateCopyWithImpl<$Res>
    implements $GymDeviceConnectStateCopyWith<$Res> {
  _$GymDeviceConnectStateCopyWithImpl(this._self, this._then);

  final GymDeviceConnectState _self;
  final $Res Function(GymDeviceConnectState) _then;

/// Create a copy of GymDeviceConnectState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSearching = null,Object? isEquipmentConnected = null,Object? foundDeviceNames = null,Object? hasConnectedOnce = null,}) {
  return _then(GymDeviceConnectState(
isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,isEquipmentConnected: null == isEquipmentConnected ? _self.isEquipmentConnected : isEquipmentConnected // ignore: cast_nullable_to_non_nullable
as bool,foundDeviceNames: null == foundDeviceNames ? _self.foundDeviceNames : foundDeviceNames // ignore: cast_nullable_to_non_nullable
as List<String>,hasConnectedOnce: null == hasConnectedOnce ? _self.hasConnectedOnce : hasConnectedOnce // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GymDeviceConnectState].
extension GymDeviceConnectStatePatterns on GymDeviceConnectState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GymDeviceConnectState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GymDeviceConnectState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GymDeviceConnectState value)  $default,){
final _that = this;
switch (_that) {
case _GymDeviceConnectState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GymDeviceConnectState value)?  $default,){
final _that = this;
switch (_that) {
case _GymDeviceConnectState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSearching,  bool isEquipmentConnected,  List<String> foundDeviceNames,  bool hasConnectedOnce)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GymDeviceConnectState() when $default != null:
return $default(_that.isSearching,_that.isEquipmentConnected,_that.foundDeviceNames,_that.hasConnectedOnce);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSearching,  bool isEquipmentConnected,  List<String> foundDeviceNames,  bool hasConnectedOnce)  $default,) {final _that = this;
switch (_that) {
case _GymDeviceConnectState():
return $default(_that.isSearching,_that.isEquipmentConnected,_that.foundDeviceNames,_that.hasConnectedOnce);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSearching,  bool isEquipmentConnected,  List<String> foundDeviceNames,  bool hasConnectedOnce)?  $default,) {final _that = this;
switch (_that) {
case _GymDeviceConnectState() when $default != null:
return $default(_that.isSearching,_that.isEquipmentConnected,_that.foundDeviceNames,_that.hasConnectedOnce);case _:
  return null;

}
}

}

/// @nodoc


class _GymDeviceConnectState implements GymDeviceConnectState {
  const _GymDeviceConnectState({this.isSearching = false, this.isEquipmentConnected = false,  List<String> foundDeviceNames = const <String>[], this.hasConnectedOnce = false}): _foundDeviceNames = foundDeviceNames;
  

/// 是否正在搜索(对应旧 searchStatus)。
@override@JsonKey() final  bool isSearching;
/// 设备是否已连接(对应旧 isDeviceConnect)。
@override@JsonKey() final  bool isEquipmentConnected;
/// 已发现设备的广播名列表(对应旧 showDeviceName.map(advName))。
 final  List<String> _foundDeviceNames;
/// 已发现设备的广播名列表(对应旧 showDeviceName.map(advName))。
@override@JsonKey() List<String> get foundDeviceNames {
  if (_foundDeviceNames is EqualUnmodifiableListView) return _foundDeviceNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_foundDeviceNames);
}

/// 是否曾经连接过(对应旧 _hasConnected,用于断连 toast 抑制)。
@override@JsonKey() final  bool hasConnectedOnce;

/// Create a copy of GymDeviceConnectState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GymDeviceConnectStateCopyWith<_GymDeviceConnectState> get copyWith => __$GymDeviceConnectStateCopyWithImpl<_GymDeviceConnectState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GymDeviceConnectState&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.isEquipmentConnected, isEquipmentConnected) || other.isEquipmentConnected == isEquipmentConnected)&&const DeepCollectionEquality().equals(other._foundDeviceNames, _foundDeviceNames)&&(identical(other.hasConnectedOnce, hasConnectedOnce) || other.hasConnectedOnce == hasConnectedOnce));
}


@override
int get hashCode => Object.hash(runtimeType,isSearching,isEquipmentConnected,const DeepCollectionEquality().hash(_foundDeviceNames),hasConnectedOnce);

@override
String toString() {
  return 'GymDeviceConnectState(isSearching: $isSearching, isEquipmentConnected: $isEquipmentConnected, foundDeviceNames: $foundDeviceNames, hasConnectedOnce: $hasConnectedOnce)';
}


}

/// @nodoc
abstract mixin class _$GymDeviceConnectStateCopyWith<$Res> implements $GymDeviceConnectStateCopyWith<$Res> {
  factory _$GymDeviceConnectStateCopyWith(_GymDeviceConnectState value, $Res Function(_GymDeviceConnectState) _then) = __$GymDeviceConnectStateCopyWithImpl;
@override @useResult
$Res call({
 bool isSearching, bool isEquipmentConnected, List<String> foundDeviceNames, bool hasConnectedOnce
});




}
/// @nodoc
class __$GymDeviceConnectStateCopyWithImpl<$Res>
    implements _$GymDeviceConnectStateCopyWith<$Res> {
  __$GymDeviceConnectStateCopyWithImpl(this._self, this._then);

  final _GymDeviceConnectState _self;
  final $Res Function(_GymDeviceConnectState) _then;

/// Create a copy of GymDeviceConnectState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSearching = null,Object? isEquipmentConnected = null,Object? foundDeviceNames = null,Object? hasConnectedOnce = null,}) {
  return _then(_GymDeviceConnectState(
isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,isEquipmentConnected: null == isEquipmentConnected ? _self.isEquipmentConnected : isEquipmentConnected // ignore: cast_nullable_to_non_nullable
as bool,foundDeviceNames: null == foundDeviceNames ? _self._foundDeviceNames : foundDeviceNames // ignore: cast_nullable_to_non_nullable
as List<String>,hasConnectedOnce: null == hasConnectedOnce ? _self.hasConnectedOnce : hasConnectedOnce // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
