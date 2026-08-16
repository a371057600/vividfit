// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'avatar_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AvatarState {

 int get selectedImageIndex; String get customImagePath; bool get isCustomImage; String get imagePickFile; bool get isLoading;
/// Create a copy of AvatarState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvatarStateCopyWith<AvatarState> get copyWith => _$AvatarStateCopyWithImpl<AvatarState>(this as AvatarState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvatarState&&(identical(other.selectedImageIndex, selectedImageIndex) || other.selectedImageIndex == selectedImageIndex)&&(identical(other.customImagePath, customImagePath) || other.customImagePath == customImagePath)&&(identical(other.isCustomImage, isCustomImage) || other.isCustomImage == isCustomImage)&&(identical(other.imagePickFile, imagePickFile) || other.imagePickFile == imagePickFile)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,selectedImageIndex,customImagePath,isCustomImage,imagePickFile,isLoading);

@override
String toString() {
  return 'AvatarState(selectedImageIndex: $selectedImageIndex, customImagePath: $customImagePath, isCustomImage: $isCustomImage, imagePickFile: $imagePickFile, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $AvatarStateCopyWith<$Res>  {
  factory $AvatarStateCopyWith(AvatarState value, $Res Function(AvatarState) _then) = _$AvatarStateCopyWithImpl;
@useResult
$Res call({
 int selectedImageIndex, String customImagePath, bool isCustomImage, String imagePickFile, bool isLoading
});




}
/// @nodoc
class _$AvatarStateCopyWithImpl<$Res>
    implements $AvatarStateCopyWith<$Res> {
  _$AvatarStateCopyWithImpl(this._self, this._then);

  final AvatarState _self;
  final $Res Function(AvatarState) _then;

/// Create a copy of AvatarState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedImageIndex = null,Object? customImagePath = null,Object? isCustomImage = null,Object? imagePickFile = null,Object? isLoading = null,}) {
  return _then(AvatarState(
selectedImageIndex: null == selectedImageIndex ? _self.selectedImageIndex : selectedImageIndex // ignore: cast_nullable_to_non_nullable
as int,customImagePath: null == customImagePath ? _self.customImagePath : customImagePath // ignore: cast_nullable_to_non_nullable
as String,isCustomImage: null == isCustomImage ? _self.isCustomImage : isCustomImage // ignore: cast_nullable_to_non_nullable
as bool,imagePickFile: null == imagePickFile ? _self.imagePickFile : imagePickFile // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AvatarState].
extension AvatarStatePatterns on AvatarState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvatarState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvatarState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvatarState value)  $default,){
final _that = this;
switch (_that) {
case _AvatarState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvatarState value)?  $default,){
final _that = this;
switch (_that) {
case _AvatarState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int selectedImageIndex,  String customImagePath,  bool isCustomImage,  String imagePickFile,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvatarState() when $default != null:
return $default(_that.selectedImageIndex,_that.customImagePath,_that.isCustomImage,_that.imagePickFile,_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int selectedImageIndex,  String customImagePath,  bool isCustomImage,  String imagePickFile,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _AvatarState():
return $default(_that.selectedImageIndex,_that.customImagePath,_that.isCustomImage,_that.imagePickFile,_that.isLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int selectedImageIndex,  String customImagePath,  bool isCustomImage,  String imagePickFile,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _AvatarState() when $default != null:
return $default(_that.selectedImageIndex,_that.customImagePath,_that.isCustomImage,_that.imagePickFile,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _AvatarState implements AvatarState {
  const _AvatarState({this.selectedImageIndex = 0, this.customImagePath = '', this.isCustomImage = false, this.imagePickFile = '', this.isLoading = false});
  

@override@JsonKey() final  int selectedImageIndex;
@override@JsonKey() final  String customImagePath;
@override@JsonKey() final  bool isCustomImage;
@override@JsonKey() final  String imagePickFile;
@override@JsonKey() final  bool isLoading;

/// Create a copy of AvatarState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvatarStateCopyWith<_AvatarState> get copyWith => __$AvatarStateCopyWithImpl<_AvatarState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvatarState&&(identical(other.selectedImageIndex, selectedImageIndex) || other.selectedImageIndex == selectedImageIndex)&&(identical(other.customImagePath, customImagePath) || other.customImagePath == customImagePath)&&(identical(other.isCustomImage, isCustomImage) || other.isCustomImage == isCustomImage)&&(identical(other.imagePickFile, imagePickFile) || other.imagePickFile == imagePickFile)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,selectedImageIndex,customImagePath,isCustomImage,imagePickFile,isLoading);

@override
String toString() {
  return 'AvatarState(selectedImageIndex: $selectedImageIndex, customImagePath: $customImagePath, isCustomImage: $isCustomImage, imagePickFile: $imagePickFile, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$AvatarStateCopyWith<$Res> implements $AvatarStateCopyWith<$Res> {
  factory _$AvatarStateCopyWith(_AvatarState value, $Res Function(_AvatarState) _then) = __$AvatarStateCopyWithImpl;
@override @useResult
$Res call({
 int selectedImageIndex, String customImagePath, bool isCustomImage, String imagePickFile, bool isLoading
});




}
/// @nodoc
class __$AvatarStateCopyWithImpl<$Res>
    implements _$AvatarStateCopyWith<$Res> {
  __$AvatarStateCopyWithImpl(this._self, this._then);

  final _AvatarState _self;
  final $Res Function(_AvatarState) _then;

/// Create a copy of AvatarState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedImageIndex = null,Object? customImagePath = null,Object? isCustomImage = null,Object? imagePickFile = null,Object? isLoading = null,}) {
  return _then(_AvatarState(
selectedImageIndex: null == selectedImageIndex ? _self.selectedImageIndex : selectedImageIndex // ignore: cast_nullable_to_non_nullable
as int,customImagePath: null == customImagePath ? _self.customImagePath : customImagePath // ignore: cast_nullable_to_non_nullable
as String,isCustomImage: null == isCustomImage ? _self.isCustomImage : isCustomImage // ignore: cast_nullable_to_non_nullable
as bool,imagePickFile: null == imagePickFile ? _self.imagePickFile : imagePickFile // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
