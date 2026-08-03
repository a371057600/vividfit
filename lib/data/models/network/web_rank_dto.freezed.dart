// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'web_rank_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebRankDto {

 Map<String, dynamic>? get userRank; List<dynamic>? get webRank;
/// Create a copy of WebRankDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebRankDtoCopyWith<WebRankDto> get copyWith => _$WebRankDtoCopyWithImpl<WebRankDto>(this as WebRankDto, _$identity);

  /// Serializes this WebRankDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebRankDto&&const DeepCollectionEquality().equals(other.userRank, userRank)&&const DeepCollectionEquality().equals(other.webRank, webRank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(userRank),const DeepCollectionEquality().hash(webRank));

@override
String toString() {
  return 'WebRankDto(userRank: $userRank, webRank: $webRank)';
}


}

/// @nodoc
abstract mixin class $WebRankDtoCopyWith<$Res>  {
  factory $WebRankDtoCopyWith(WebRankDto value, $Res Function(WebRankDto) _then) = _$WebRankDtoCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic>? userRank, List<dynamic>? webRank
});




}
/// @nodoc
class _$WebRankDtoCopyWithImpl<$Res>
    implements $WebRankDtoCopyWith<$Res> {
  _$WebRankDtoCopyWithImpl(this._self, this._then);

  final WebRankDto _self;
  final $Res Function(WebRankDto) _then;

/// Create a copy of WebRankDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userRank = freezed,Object? webRank = freezed,}) {
  return _then(WebRankDto(
userRank: freezed == userRank ? _self.userRank : userRank // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,webRank: freezed == webRank ? _self.webRank : webRank // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [WebRankDto].
extension WebRankDtoPatterns on WebRankDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WebRankDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WebRankDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WebRankDto value)  $default,){
final _that = this;
switch (_that) {
case _WebRankDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WebRankDto value)?  $default,){
final _that = this;
switch (_that) {
case _WebRankDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, dynamic>? userRank,  List<dynamic>? webRank)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WebRankDto() when $default != null:
return $default(_that.userRank,_that.webRank);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, dynamic>? userRank,  List<dynamic>? webRank)  $default,) {final _that = this;
switch (_that) {
case _WebRankDto():
return $default(_that.userRank,_that.webRank);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, dynamic>? userRank,  List<dynamic>? webRank)?  $default,) {final _that = this;
switch (_that) {
case _WebRankDto() when $default != null:
return $default(_that.userRank,_that.webRank);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WebRankDto implements WebRankDto {
  const _WebRankDto({ Map<String, dynamic>? userRank,  List<dynamic>? webRank}): _userRank = userRank,_webRank = webRank;
  factory _WebRankDto.fromJson(Map<String, dynamic> json) => _$WebRankDtoFromJson(json);

 final  Map<String, dynamic>? _userRank;
@override Map<String, dynamic>? get userRank {
  final value = _userRank;
  if (value == null) return null;
  if (_userRank is EqualUnmodifiableMapView) return _userRank;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<dynamic>? _webRank;
@override List<dynamic>? get webRank {
  final value = _webRank;
  if (value == null) return null;
  if (_webRank is EqualUnmodifiableListView) return _webRank;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of WebRankDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebRankDtoCopyWith<_WebRankDto> get copyWith => __$WebRankDtoCopyWithImpl<_WebRankDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebRankDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebRankDto&&const DeepCollectionEquality().equals(other._userRank, _userRank)&&const DeepCollectionEquality().equals(other._webRank, _webRank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_userRank),const DeepCollectionEquality().hash(_webRank));

@override
String toString() {
  return 'WebRankDto(userRank: $userRank, webRank: $webRank)';
}


}

/// @nodoc
abstract mixin class _$WebRankDtoCopyWith<$Res> implements $WebRankDtoCopyWith<$Res> {
  factory _$WebRankDtoCopyWith(_WebRankDto value, $Res Function(_WebRankDto) _then) = __$WebRankDtoCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic>? userRank, List<dynamic>? webRank
});




}
/// @nodoc
class __$WebRankDtoCopyWithImpl<$Res>
    implements _$WebRankDtoCopyWith<$Res> {
  __$WebRankDtoCopyWithImpl(this._self, this._then);

  final _WebRankDto _self;
  final $Res Function(_WebRankDto) _then;

/// Create a copy of WebRankDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userRank = freezed,Object? webRank = freezed,}) {
  return _then(_WebRankDto(
userRank: freezed == userRank ? _self._userRank : userRank // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,webRank: freezed == webRank ? _self._webRank : webRank // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,
  ));
}


}

// dart format on
