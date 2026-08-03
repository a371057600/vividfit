// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'downloaded_course_asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImageAsset {

 String get imageName; int get frameCount; int get imageFps; int get imageLength;
/// Create a copy of ImageAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageAssetCopyWith<ImageAsset> get copyWith => _$ImageAssetCopyWithImpl<ImageAsset>(this as ImageAsset, _$identity);

  /// Serializes this ImageAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageAsset&&(identical(other.imageName, imageName) || other.imageName == imageName)&&(identical(other.frameCount, frameCount) || other.frameCount == frameCount)&&(identical(other.imageFps, imageFps) || other.imageFps == imageFps)&&(identical(other.imageLength, imageLength) || other.imageLength == imageLength));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageName,frameCount,imageFps,imageLength);

@override
String toString() {
  return 'ImageAsset(imageName: $imageName, frameCount: $frameCount, imageFps: $imageFps, imageLength: $imageLength)';
}


}

/// @nodoc
abstract mixin class $ImageAssetCopyWith<$Res>  {
  factory $ImageAssetCopyWith(ImageAsset value, $Res Function(ImageAsset) _then) = _$ImageAssetCopyWithImpl;
@useResult
$Res call({
 String imageName, int frameCount, int imageFps, int imageLength
});




}
/// @nodoc
class _$ImageAssetCopyWithImpl<$Res>
    implements $ImageAssetCopyWith<$Res> {
  _$ImageAssetCopyWithImpl(this._self, this._then);

  final ImageAsset _self;
  final $Res Function(ImageAsset) _then;

/// Create a copy of ImageAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageName = null,Object? frameCount = null,Object? imageFps = null,Object? imageLength = null,}) {
  return _then(ImageAsset(
imageName: null == imageName ? _self.imageName : imageName // ignore: cast_nullable_to_non_nullable
as String,frameCount: null == frameCount ? _self.frameCount : frameCount // ignore: cast_nullable_to_non_nullable
as int,imageFps: null == imageFps ? _self.imageFps : imageFps // ignore: cast_nullable_to_non_nullable
as int,imageLength: null == imageLength ? _self.imageLength : imageLength // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ImageAsset].
extension ImageAssetPatterns on ImageAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImageAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImageAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImageAsset value)  $default,){
final _that = this;
switch (_that) {
case _ImageAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImageAsset value)?  $default,){
final _that = this;
switch (_that) {
case _ImageAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String imageName,  int frameCount,  int imageFps,  int imageLength)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImageAsset() when $default != null:
return $default(_that.imageName,_that.frameCount,_that.imageFps,_that.imageLength);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String imageName,  int frameCount,  int imageFps,  int imageLength)  $default,) {final _that = this;
switch (_that) {
case _ImageAsset():
return $default(_that.imageName,_that.frameCount,_that.imageFps,_that.imageLength);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String imageName,  int frameCount,  int imageFps,  int imageLength)?  $default,) {final _that = this;
switch (_that) {
case _ImageAsset() when $default != null:
return $default(_that.imageName,_that.frameCount,_that.imageFps,_that.imageLength);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImageAsset implements ImageAsset {
  const _ImageAsset({required this.imageName, this.frameCount = 0, this.imageFps = 0, this.imageLength = 0});
  factory _ImageAsset.fromJson(Map<String, dynamic> json) => _$ImageAssetFromJson(json);

@override final  String imageName;
@override@JsonKey() final  int frameCount;
@override@JsonKey() final  int imageFps;
@override@JsonKey() final  int imageLength;

/// Create a copy of ImageAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageAssetCopyWith<_ImageAsset> get copyWith => __$ImageAssetCopyWithImpl<_ImageAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageAssetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageAsset&&(identical(other.imageName, imageName) || other.imageName == imageName)&&(identical(other.frameCount, frameCount) || other.frameCount == frameCount)&&(identical(other.imageFps, imageFps) || other.imageFps == imageFps)&&(identical(other.imageLength, imageLength) || other.imageLength == imageLength));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageName,frameCount,imageFps,imageLength);

@override
String toString() {
  return 'ImageAsset(imageName: $imageName, frameCount: $frameCount, imageFps: $imageFps, imageLength: $imageLength)';
}


}

/// @nodoc
abstract mixin class _$ImageAssetCopyWith<$Res> implements $ImageAssetCopyWith<$Res> {
  factory _$ImageAssetCopyWith(_ImageAsset value, $Res Function(_ImageAsset) _then) = __$ImageAssetCopyWithImpl;
@override @useResult
$Res call({
 String imageName, int frameCount, int imageFps, int imageLength
});




}
/// @nodoc
class __$ImageAssetCopyWithImpl<$Res>
    implements _$ImageAssetCopyWith<$Res> {
  __$ImageAssetCopyWithImpl(this._self, this._then);

  final _ImageAsset _self;
  final $Res Function(_ImageAsset) _then;

/// Create a copy of ImageAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageName = null,Object? frameCount = null,Object? imageFps = null,Object? imageLength = null,}) {
  return _then(_ImageAsset(
imageName: null == imageName ? _self.imageName : imageName // ignore: cast_nullable_to_non_nullable
as String,frameCount: null == frameCount ? _self.frameCount : frameCount // ignore: cast_nullable_to_non_nullable
as int,imageFps: null == imageFps ? _self.imageFps : imageFps // ignore: cast_nullable_to_non_nullable
as int,imageLength: null == imageLength ? _self.imageLength : imageLength // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$VoiceAsset {

 String get voiceName; String? get dialect;
/// Create a copy of VoiceAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceAssetCopyWith<VoiceAsset> get copyWith => _$VoiceAssetCopyWithImpl<VoiceAsset>(this as VoiceAsset, _$identity);

  /// Serializes this VoiceAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoiceAsset&&(identical(other.voiceName, voiceName) || other.voiceName == voiceName)&&(identical(other.dialect, dialect) || other.dialect == dialect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,voiceName,dialect);

@override
String toString() {
  return 'VoiceAsset(voiceName: $voiceName, dialect: $dialect)';
}


}

/// @nodoc
abstract mixin class $VoiceAssetCopyWith<$Res>  {
  factory $VoiceAssetCopyWith(VoiceAsset value, $Res Function(VoiceAsset) _then) = _$VoiceAssetCopyWithImpl;
@useResult
$Res call({
 String voiceName, String? dialect
});




}
/// @nodoc
class _$VoiceAssetCopyWithImpl<$Res>
    implements $VoiceAssetCopyWith<$Res> {
  _$VoiceAssetCopyWithImpl(this._self, this._then);

  final VoiceAsset _self;
  final $Res Function(VoiceAsset) _then;

/// Create a copy of VoiceAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? voiceName = null,Object? dialect = freezed,}) {
  return _then(VoiceAsset(
voiceName: null == voiceName ? _self.voiceName : voiceName // ignore: cast_nullable_to_non_nullable
as String,dialect: freezed == dialect ? _self.dialect : dialect // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VoiceAsset].
extension VoiceAssetPatterns on VoiceAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceAsset value)  $default,){
final _that = this;
switch (_that) {
case _VoiceAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceAsset value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String voiceName,  String? dialect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceAsset() when $default != null:
return $default(_that.voiceName,_that.dialect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String voiceName,  String? dialect)  $default,) {final _that = this;
switch (_that) {
case _VoiceAsset():
return $default(_that.voiceName,_that.dialect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String voiceName,  String? dialect)?  $default,) {final _that = this;
switch (_that) {
case _VoiceAsset() when $default != null:
return $default(_that.voiceName,_that.dialect);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VoiceAsset implements VoiceAsset {
  const _VoiceAsset({required this.voiceName, this.dialect});
  factory _VoiceAsset.fromJson(Map<String, dynamic> json) => _$VoiceAssetFromJson(json);

@override final  String voiceName;
@override final  String? dialect;

/// Create a copy of VoiceAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceAssetCopyWith<_VoiceAsset> get copyWith => __$VoiceAssetCopyWithImpl<_VoiceAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VoiceAssetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoiceAsset&&(identical(other.voiceName, voiceName) || other.voiceName == voiceName)&&(identical(other.dialect, dialect) || other.dialect == dialect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,voiceName,dialect);

@override
String toString() {
  return 'VoiceAsset(voiceName: $voiceName, dialect: $dialect)';
}


}

/// @nodoc
abstract mixin class _$VoiceAssetCopyWith<$Res> implements $VoiceAssetCopyWith<$Res> {
  factory _$VoiceAssetCopyWith(_VoiceAsset value, $Res Function(_VoiceAsset) _then) = __$VoiceAssetCopyWithImpl;
@override @useResult
$Res call({
 String voiceName, String? dialect
});




}
/// @nodoc
class __$VoiceAssetCopyWithImpl<$Res>
    implements _$VoiceAssetCopyWith<$Res> {
  __$VoiceAssetCopyWithImpl(this._self, this._then);

  final _VoiceAsset _self;
  final $Res Function(_VoiceAsset) _then;

/// Create a copy of VoiceAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? voiceName = null,Object? dialect = freezed,}) {
  return _then(_VoiceAsset(
voiceName: null == voiceName ? _self.voiceName : voiceName // ignore: cast_nullable_to_non_nullable
as String,dialect: freezed == dialect ? _self.dialect : dialect // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BgmAsset {

 String get bgmName;
/// Create a copy of BgmAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BgmAssetCopyWith<BgmAsset> get copyWith => _$BgmAssetCopyWithImpl<BgmAsset>(this as BgmAsset, _$identity);

  /// Serializes this BgmAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BgmAsset&&(identical(other.bgmName, bgmName) || other.bgmName == bgmName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bgmName);

@override
String toString() {
  return 'BgmAsset(bgmName: $bgmName)';
}


}

/// @nodoc
abstract mixin class $BgmAssetCopyWith<$Res>  {
  factory $BgmAssetCopyWith(BgmAsset value, $Res Function(BgmAsset) _then) = _$BgmAssetCopyWithImpl;
@useResult
$Res call({
 String bgmName
});




}
/// @nodoc
class _$BgmAssetCopyWithImpl<$Res>
    implements $BgmAssetCopyWith<$Res> {
  _$BgmAssetCopyWithImpl(this._self, this._then);

  final BgmAsset _self;
  final $Res Function(BgmAsset) _then;

/// Create a copy of BgmAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bgmName = null,}) {
  return _then(BgmAsset(
bgmName: null == bgmName ? _self.bgmName : bgmName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BgmAsset].
extension BgmAssetPatterns on BgmAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BgmAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BgmAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BgmAsset value)  $default,){
final _that = this;
switch (_that) {
case _BgmAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BgmAsset value)?  $default,){
final _that = this;
switch (_that) {
case _BgmAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bgmName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BgmAsset() when $default != null:
return $default(_that.bgmName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bgmName)  $default,) {final _that = this;
switch (_that) {
case _BgmAsset():
return $default(_that.bgmName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bgmName)?  $default,) {final _that = this;
switch (_that) {
case _BgmAsset() when $default != null:
return $default(_that.bgmName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BgmAsset implements BgmAsset {
  const _BgmAsset({required this.bgmName});
  factory _BgmAsset.fromJson(Map<String, dynamic> json) => _$BgmAssetFromJson(json);

@override final  String bgmName;

/// Create a copy of BgmAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BgmAssetCopyWith<_BgmAsset> get copyWith => __$BgmAssetCopyWithImpl<_BgmAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BgmAssetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BgmAsset&&(identical(other.bgmName, bgmName) || other.bgmName == bgmName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bgmName);

@override
String toString() {
  return 'BgmAsset(bgmName: $bgmName)';
}


}

/// @nodoc
abstract mixin class _$BgmAssetCopyWith<$Res> implements $BgmAssetCopyWith<$Res> {
  factory _$BgmAssetCopyWith(_BgmAsset value, $Res Function(_BgmAsset) _then) = __$BgmAssetCopyWithImpl;
@override @useResult
$Res call({
 String bgmName
});




}
/// @nodoc
class __$BgmAssetCopyWithImpl<$Res>
    implements _$BgmAssetCopyWith<$Res> {
  __$BgmAssetCopyWithImpl(this._self, this._then);

  final _BgmAsset _self;
  final $Res Function(_BgmAsset) _then;

/// Create a copy of BgmAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bgmName = null,}) {
  return _then(_BgmAsset(
bgmName: null == bgmName ? _self.bgmName : bgmName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DownloadedCourseAsset {

 int get courseId; FtmsDeviceType get deviceType; AssetStatus get status; int get totalFiles; int get completedFiles; List<ImageAsset> get imageAssets; List<VoiceAsset> get voiceAssets; List<BgmAsset> get bgmAssets; String? get downloadDate; int get schemaVersion;
/// Create a copy of DownloadedCourseAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadedCourseAssetCopyWith<DownloadedCourseAsset> get copyWith => _$DownloadedCourseAssetCopyWithImpl<DownloadedCourseAsset>(this as DownloadedCourseAsset, _$identity);

  /// Serializes this DownloadedCourseAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadedCourseAsset&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalFiles, totalFiles) || other.totalFiles == totalFiles)&&(identical(other.completedFiles, completedFiles) || other.completedFiles == completedFiles)&&const DeepCollectionEquality().equals(other.imageAssets, imageAssets)&&const DeepCollectionEquality().equals(other.voiceAssets, voiceAssets)&&const DeepCollectionEquality().equals(other.bgmAssets, bgmAssets)&&(identical(other.downloadDate, downloadDate) || other.downloadDate == downloadDate)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,courseId,deviceType,status,totalFiles,completedFiles,const DeepCollectionEquality().hash(imageAssets),const DeepCollectionEquality().hash(voiceAssets),const DeepCollectionEquality().hash(bgmAssets),downloadDate,schemaVersion);

@override
String toString() {
  return 'DownloadedCourseAsset(courseId: $courseId, deviceType: $deviceType, status: $status, totalFiles: $totalFiles, completedFiles: $completedFiles, imageAssets: $imageAssets, voiceAssets: $voiceAssets, bgmAssets: $bgmAssets, downloadDate: $downloadDate, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $DownloadedCourseAssetCopyWith<$Res>  {
  factory $DownloadedCourseAssetCopyWith(DownloadedCourseAsset value, $Res Function(DownloadedCourseAsset) _then) = _$DownloadedCourseAssetCopyWithImpl;
@useResult
$Res call({
 int courseId, FtmsDeviceType deviceType, AssetStatus status, int totalFiles, int completedFiles, List<ImageAsset> imageAssets, List<VoiceAsset> voiceAssets, List<BgmAsset> bgmAssets, String? downloadDate, int schemaVersion
});




}
/// @nodoc
class _$DownloadedCourseAssetCopyWithImpl<$Res>
    implements $DownloadedCourseAssetCopyWith<$Res> {
  _$DownloadedCourseAssetCopyWithImpl(this._self, this._then);

  final DownloadedCourseAsset _self;
  final $Res Function(DownloadedCourseAsset) _then;

/// Create a copy of DownloadedCourseAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courseId = null,Object? deviceType = null,Object? status = null,Object? totalFiles = null,Object? completedFiles = null,Object? imageAssets = null,Object? voiceAssets = null,Object? bgmAssets = null,Object? downloadDate = freezed,Object? schemaVersion = null,}) {
  return _then(DownloadedCourseAsset(
courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as FtmsDeviceType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AssetStatus,totalFiles: null == totalFiles ? _self.totalFiles : totalFiles // ignore: cast_nullable_to_non_nullable
as int,completedFiles: null == completedFiles ? _self.completedFiles : completedFiles // ignore: cast_nullable_to_non_nullable
as int,imageAssets: null == imageAssets ? _self.imageAssets : imageAssets // ignore: cast_nullable_to_non_nullable
as List<ImageAsset>,voiceAssets: null == voiceAssets ? _self.voiceAssets : voiceAssets // ignore: cast_nullable_to_non_nullable
as List<VoiceAsset>,bgmAssets: null == bgmAssets ? _self.bgmAssets : bgmAssets // ignore: cast_nullable_to_non_nullable
as List<BgmAsset>,downloadDate: freezed == downloadDate ? _self.downloadDate : downloadDate // ignore: cast_nullable_to_non_nullable
as String?,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DownloadedCourseAsset].
extension DownloadedCourseAssetPatterns on DownloadedCourseAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadedCourseAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadedCourseAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadedCourseAsset value)  $default,){
final _that = this;
switch (_that) {
case _DownloadedCourseAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadedCourseAsset value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadedCourseAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int courseId,  FtmsDeviceType deviceType,  AssetStatus status,  int totalFiles,  int completedFiles,  List<ImageAsset> imageAssets,  List<VoiceAsset> voiceAssets,  List<BgmAsset> bgmAssets,  String? downloadDate,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadedCourseAsset() when $default != null:
return $default(_that.courseId,_that.deviceType,_that.status,_that.totalFiles,_that.completedFiles,_that.imageAssets,_that.voiceAssets,_that.bgmAssets,_that.downloadDate,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int courseId,  FtmsDeviceType deviceType,  AssetStatus status,  int totalFiles,  int completedFiles,  List<ImageAsset> imageAssets,  List<VoiceAsset> voiceAssets,  List<BgmAsset> bgmAssets,  String? downloadDate,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _DownloadedCourseAsset():
return $default(_that.courseId,_that.deviceType,_that.status,_that.totalFiles,_that.completedFiles,_that.imageAssets,_that.voiceAssets,_that.bgmAssets,_that.downloadDate,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int courseId,  FtmsDeviceType deviceType,  AssetStatus status,  int totalFiles,  int completedFiles,  List<ImageAsset> imageAssets,  List<VoiceAsset> voiceAssets,  List<BgmAsset> bgmAssets,  String? downloadDate,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _DownloadedCourseAsset() when $default != null:
return $default(_that.courseId,_that.deviceType,_that.status,_that.totalFiles,_that.completedFiles,_that.imageAssets,_that.voiceAssets,_that.bgmAssets,_that.downloadDate,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DownloadedCourseAsset extends DownloadedCourseAsset {
  const _DownloadedCourseAsset({required this.courseId, required this.deviceType, this.status = AssetStatus.downloading, this.totalFiles = 0, this.completedFiles = 0,  List<ImageAsset> imageAssets = const [],  List<VoiceAsset> voiceAssets = const [],  List<BgmAsset> bgmAssets = const [], this.downloadDate, this.schemaVersion = 1}): _imageAssets = imageAssets,_voiceAssets = voiceAssets,_bgmAssets = bgmAssets,super._();
  factory _DownloadedCourseAsset.fromJson(Map<String, dynamic> json) => _$DownloadedCourseAssetFromJson(json);

@override final  int courseId;
@override final  FtmsDeviceType deviceType;
@override@JsonKey() final  AssetStatus status;
@override@JsonKey() final  int totalFiles;
@override@JsonKey() final  int completedFiles;
 final  List<ImageAsset> _imageAssets;
@override@JsonKey() List<ImageAsset> get imageAssets {
  if (_imageAssets is EqualUnmodifiableListView) return _imageAssets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageAssets);
}

 final  List<VoiceAsset> _voiceAssets;
@override@JsonKey() List<VoiceAsset> get voiceAssets {
  if (_voiceAssets is EqualUnmodifiableListView) return _voiceAssets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_voiceAssets);
}

 final  List<BgmAsset> _bgmAssets;
@override@JsonKey() List<BgmAsset> get bgmAssets {
  if (_bgmAssets is EqualUnmodifiableListView) return _bgmAssets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bgmAssets);
}

@override final  String? downloadDate;
@override@JsonKey() final  int schemaVersion;

/// Create a copy of DownloadedCourseAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadedCourseAssetCopyWith<_DownloadedCourseAsset> get copyWith => __$DownloadedCourseAssetCopyWithImpl<_DownloadedCourseAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DownloadedCourseAssetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadedCourseAsset&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalFiles, totalFiles) || other.totalFiles == totalFiles)&&(identical(other.completedFiles, completedFiles) || other.completedFiles == completedFiles)&&const DeepCollectionEquality().equals(other._imageAssets, _imageAssets)&&const DeepCollectionEquality().equals(other._voiceAssets, _voiceAssets)&&const DeepCollectionEquality().equals(other._bgmAssets, _bgmAssets)&&(identical(other.downloadDate, downloadDate) || other.downloadDate == downloadDate)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,courseId,deviceType,status,totalFiles,completedFiles,const DeepCollectionEquality().hash(_imageAssets),const DeepCollectionEquality().hash(_voiceAssets),const DeepCollectionEquality().hash(_bgmAssets),downloadDate,schemaVersion);

@override
String toString() {
  return 'DownloadedCourseAsset(courseId: $courseId, deviceType: $deviceType, status: $status, totalFiles: $totalFiles, completedFiles: $completedFiles, imageAssets: $imageAssets, voiceAssets: $voiceAssets, bgmAssets: $bgmAssets, downloadDate: $downloadDate, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$DownloadedCourseAssetCopyWith<$Res> implements $DownloadedCourseAssetCopyWith<$Res> {
  factory _$DownloadedCourseAssetCopyWith(_DownloadedCourseAsset value, $Res Function(_DownloadedCourseAsset) _then) = __$DownloadedCourseAssetCopyWithImpl;
@override @useResult
$Res call({
 int courseId, FtmsDeviceType deviceType, AssetStatus status, int totalFiles, int completedFiles, List<ImageAsset> imageAssets, List<VoiceAsset> voiceAssets, List<BgmAsset> bgmAssets, String? downloadDate, int schemaVersion
});




}
/// @nodoc
class __$DownloadedCourseAssetCopyWithImpl<$Res>
    implements _$DownloadedCourseAssetCopyWith<$Res> {
  __$DownloadedCourseAssetCopyWithImpl(this._self, this._then);

  final _DownloadedCourseAsset _self;
  final $Res Function(_DownloadedCourseAsset) _then;

/// Create a copy of DownloadedCourseAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courseId = null,Object? deviceType = null,Object? status = null,Object? totalFiles = null,Object? completedFiles = null,Object? imageAssets = null,Object? voiceAssets = null,Object? bgmAssets = null,Object? downloadDate = freezed,Object? schemaVersion = null,}) {
  return _then(_DownloadedCourseAsset(
courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as FtmsDeviceType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AssetStatus,totalFiles: null == totalFiles ? _self.totalFiles : totalFiles // ignore: cast_nullable_to_non_nullable
as int,completedFiles: null == completedFiles ? _self.completedFiles : completedFiles // ignore: cast_nullable_to_non_nullable
as int,imageAssets: null == imageAssets ? _self._imageAssets : imageAssets // ignore: cast_nullable_to_non_nullable
as List<ImageAsset>,voiceAssets: null == voiceAssets ? _self._voiceAssets : voiceAssets // ignore: cast_nullable_to_non_nullable
as List<VoiceAsset>,bgmAssets: null == bgmAssets ? _self._bgmAssets : bgmAssets // ignore: cast_nullable_to_non_nullable
as List<BgmAsset>,downloadDate: freezed == downloadDate ? _self.downloadDate : downloadDate // ignore: cast_nullable_to_non_nullable
as String?,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
