// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_resource_manifest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResourceFile {

 String get name; String get url; ResourceType get type;
/// Create a copy of ResourceFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResourceFileCopyWith<ResourceFile> get copyWith => _$ResourceFileCopyWithImpl<ResourceFile>(this as ResourceFile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResourceFile&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,name,url,type);

@override
String toString() {
  return 'ResourceFile(name: $name, url: $url, type: $type)';
}


}

/// @nodoc
abstract mixin class $ResourceFileCopyWith<$Res>  {
  factory $ResourceFileCopyWith(ResourceFile value, $Res Function(ResourceFile) _then) = _$ResourceFileCopyWithImpl;
@useResult
$Res call({
 String name, String url, ResourceType type
});




}
/// @nodoc
class _$ResourceFileCopyWithImpl<$Res>
    implements $ResourceFileCopyWith<$Res> {
  _$ResourceFileCopyWithImpl(this._self, this._then);

  final ResourceFile _self;
  final $Res Function(ResourceFile) _then;

/// Create a copy of ResourceFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? url = null,Object? type = null,}) {
  return _then(ResourceFile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ResourceType,
  ));
}

}


/// Adds pattern-matching-related methods to [ResourceFile].
extension ResourceFilePatterns on ResourceFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResourceFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResourceFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResourceFile value)  $default,){
final _that = this;
switch (_that) {
case _ResourceFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResourceFile value)?  $default,){
final _that = this;
switch (_that) {
case _ResourceFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String url,  ResourceType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResourceFile() when $default != null:
return $default(_that.name,_that.url,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String url,  ResourceType type)  $default,) {final _that = this;
switch (_that) {
case _ResourceFile():
return $default(_that.name,_that.url,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String url,  ResourceType type)?  $default,) {final _that = this;
switch (_that) {
case _ResourceFile() when $default != null:
return $default(_that.name,_that.url,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _ResourceFile implements ResourceFile {
  const _ResourceFile({required this.name, required this.url, required this.type});
  

@override final  String name;
@override final  String url;
@override final  ResourceType type;

/// Create a copy of ResourceFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResourceFileCopyWith<_ResourceFile> get copyWith => __$ResourceFileCopyWithImpl<_ResourceFile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResourceFile&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,name,url,type);

@override
String toString() {
  return 'ResourceFile(name: $name, url: $url, type: $type)';
}


}

/// @nodoc
abstract mixin class _$ResourceFileCopyWith<$Res> implements $ResourceFileCopyWith<$Res> {
  factory _$ResourceFileCopyWith(_ResourceFile value, $Res Function(_ResourceFile) _then) = __$ResourceFileCopyWithImpl;
@override @useResult
$Res call({
 String name, String url, ResourceType type
});




}
/// @nodoc
class __$ResourceFileCopyWithImpl<$Res>
    implements _$ResourceFileCopyWith<$Res> {
  __$ResourceFileCopyWithImpl(this._self, this._then);

  final _ResourceFile _self;
  final $Res Function(_ResourceFile) _then;

/// Create a copy of ResourceFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? url = null,Object? type = null,}) {
  return _then(_ResourceFile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ResourceType,
  ));
}


}

/// @nodoc
mixin _$CourseResourceManifest {

 List<ResourceFile> get imageZips; List<ResourceFile> get voiceMp3s; List<ResourceFile> get bgmMp3s;
/// Create a copy of CourseResourceManifest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseResourceManifestCopyWith<CourseResourceManifest> get copyWith => _$CourseResourceManifestCopyWithImpl<CourseResourceManifest>(this as CourseResourceManifest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseResourceManifest&&const DeepCollectionEquality().equals(other.imageZips, imageZips)&&const DeepCollectionEquality().equals(other.voiceMp3s, voiceMp3s)&&const DeepCollectionEquality().equals(other.bgmMp3s, bgmMp3s));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(imageZips),const DeepCollectionEquality().hash(voiceMp3s),const DeepCollectionEquality().hash(bgmMp3s));

@override
String toString() {
  return 'CourseResourceManifest(imageZips: $imageZips, voiceMp3s: $voiceMp3s, bgmMp3s: $bgmMp3s)';
}


}

/// @nodoc
abstract mixin class $CourseResourceManifestCopyWith<$Res>  {
  factory $CourseResourceManifestCopyWith(CourseResourceManifest value, $Res Function(CourseResourceManifest) _then) = _$CourseResourceManifestCopyWithImpl;
@useResult
$Res call({
 List<ResourceFile> imageZips, List<ResourceFile> voiceMp3s, List<ResourceFile> bgmMp3s
});




}
/// @nodoc
class _$CourseResourceManifestCopyWithImpl<$Res>
    implements $CourseResourceManifestCopyWith<$Res> {
  _$CourseResourceManifestCopyWithImpl(this._self, this._then);

  final CourseResourceManifest _self;
  final $Res Function(CourseResourceManifest) _then;

/// Create a copy of CourseResourceManifest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageZips = null,Object? voiceMp3s = null,Object? bgmMp3s = null,}) {
  return _then(CourseResourceManifest(
imageZips: null == imageZips ? _self.imageZips : imageZips // ignore: cast_nullable_to_non_nullable
as List<ResourceFile>,voiceMp3s: null == voiceMp3s ? _self.voiceMp3s : voiceMp3s // ignore: cast_nullable_to_non_nullable
as List<ResourceFile>,bgmMp3s: null == bgmMp3s ? _self.bgmMp3s : bgmMp3s // ignore: cast_nullable_to_non_nullable
as List<ResourceFile>,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseResourceManifest].
extension CourseResourceManifestPatterns on CourseResourceManifest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseResourceManifest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseResourceManifest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseResourceManifest value)  $default,){
final _that = this;
switch (_that) {
case _CourseResourceManifest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseResourceManifest value)?  $default,){
final _that = this;
switch (_that) {
case _CourseResourceManifest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ResourceFile> imageZips,  List<ResourceFile> voiceMp3s,  List<ResourceFile> bgmMp3s)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseResourceManifest() when $default != null:
return $default(_that.imageZips,_that.voiceMp3s,_that.bgmMp3s);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ResourceFile> imageZips,  List<ResourceFile> voiceMp3s,  List<ResourceFile> bgmMp3s)  $default,) {final _that = this;
switch (_that) {
case _CourseResourceManifest():
return $default(_that.imageZips,_that.voiceMp3s,_that.bgmMp3s);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ResourceFile> imageZips,  List<ResourceFile> voiceMp3s,  List<ResourceFile> bgmMp3s)?  $default,) {final _that = this;
switch (_that) {
case _CourseResourceManifest() when $default != null:
return $default(_that.imageZips,_that.voiceMp3s,_that.bgmMp3s);case _:
  return null;

}
}

}

/// @nodoc


class _CourseResourceManifest extends CourseResourceManifest {
  const _CourseResourceManifest({ List<ResourceFile> imageZips = const [],  List<ResourceFile> voiceMp3s = const [],  List<ResourceFile> bgmMp3s = const []}): _imageZips = imageZips,_voiceMp3s = voiceMp3s,_bgmMp3s = bgmMp3s,super._();
  

 final  List<ResourceFile> _imageZips;
@override@JsonKey() List<ResourceFile> get imageZips {
  if (_imageZips is EqualUnmodifiableListView) return _imageZips;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageZips);
}

 final  List<ResourceFile> _voiceMp3s;
@override@JsonKey() List<ResourceFile> get voiceMp3s {
  if (_voiceMp3s is EqualUnmodifiableListView) return _voiceMp3s;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_voiceMp3s);
}

 final  List<ResourceFile> _bgmMp3s;
@override@JsonKey() List<ResourceFile> get bgmMp3s {
  if (_bgmMp3s is EqualUnmodifiableListView) return _bgmMp3s;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bgmMp3s);
}


/// Create a copy of CourseResourceManifest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseResourceManifestCopyWith<_CourseResourceManifest> get copyWith => __$CourseResourceManifestCopyWithImpl<_CourseResourceManifest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseResourceManifest&&const DeepCollectionEquality().equals(other._imageZips, _imageZips)&&const DeepCollectionEquality().equals(other._voiceMp3s, _voiceMp3s)&&const DeepCollectionEquality().equals(other._bgmMp3s, _bgmMp3s));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_imageZips),const DeepCollectionEquality().hash(_voiceMp3s),const DeepCollectionEquality().hash(_bgmMp3s));

@override
String toString() {
  return 'CourseResourceManifest(imageZips: $imageZips, voiceMp3s: $voiceMp3s, bgmMp3s: $bgmMp3s)';
}


}

/// @nodoc
abstract mixin class _$CourseResourceManifestCopyWith<$Res> implements $CourseResourceManifestCopyWith<$Res> {
  factory _$CourseResourceManifestCopyWith(_CourseResourceManifest value, $Res Function(_CourseResourceManifest) _then) = __$CourseResourceManifestCopyWithImpl;
@override @useResult
$Res call({
 List<ResourceFile> imageZips, List<ResourceFile> voiceMp3s, List<ResourceFile> bgmMp3s
});




}
/// @nodoc
class __$CourseResourceManifestCopyWithImpl<$Res>
    implements _$CourseResourceManifestCopyWith<$Res> {
  __$CourseResourceManifestCopyWithImpl(this._self, this._then);

  final _CourseResourceManifest _self;
  final $Res Function(_CourseResourceManifest) _then;

/// Create a copy of CourseResourceManifest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageZips = null,Object? voiceMp3s = null,Object? bgmMp3s = null,}) {
  return _then(_CourseResourceManifest(
imageZips: null == imageZips ? _self._imageZips : imageZips // ignore: cast_nullable_to_non_nullable
as List<ResourceFile>,voiceMp3s: null == voiceMp3s ? _self._voiceMp3s : voiceMp3s // ignore: cast_nullable_to_non_nullable
as List<ResourceFile>,bgmMp3s: null == bgmMp3s ? _self._bgmMp3s : bgmMp3s // ignore: cast_nullable_to_non_nullable
as List<ResourceFile>,
  ));
}


}

// dart format on
