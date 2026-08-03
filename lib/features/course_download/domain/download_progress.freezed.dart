// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DownloadProgress {

 int get totalFiles; int get completedFiles; double get currentFileProgress; String? get currentFileName; DownloadStatus get status; String? get errorReason;
/// Create a copy of DownloadProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadProgressCopyWith<DownloadProgress> get copyWith => _$DownloadProgressCopyWithImpl<DownloadProgress>(this as DownloadProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadProgress&&(identical(other.totalFiles, totalFiles) || other.totalFiles == totalFiles)&&(identical(other.completedFiles, completedFiles) || other.completedFiles == completedFiles)&&(identical(other.currentFileProgress, currentFileProgress) || other.currentFileProgress == currentFileProgress)&&(identical(other.currentFileName, currentFileName) || other.currentFileName == currentFileName)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorReason, errorReason) || other.errorReason == errorReason));
}


@override
int get hashCode => Object.hash(runtimeType,totalFiles,completedFiles,currentFileProgress,currentFileName,status,errorReason);

@override
String toString() {
  return 'DownloadProgress(totalFiles: $totalFiles, completedFiles: $completedFiles, currentFileProgress: $currentFileProgress, currentFileName: $currentFileName, status: $status, errorReason: $errorReason)';
}


}

/// @nodoc
abstract mixin class $DownloadProgressCopyWith<$Res>  {
  factory $DownloadProgressCopyWith(DownloadProgress value, $Res Function(DownloadProgress) _then) = _$DownloadProgressCopyWithImpl;
@useResult
$Res call({
 int totalFiles, int completedFiles, double currentFileProgress, String? currentFileName, DownloadStatus status, String? errorReason
});




}
/// @nodoc
class _$DownloadProgressCopyWithImpl<$Res>
    implements $DownloadProgressCopyWith<$Res> {
  _$DownloadProgressCopyWithImpl(this._self, this._then);

  final DownloadProgress _self;
  final $Res Function(DownloadProgress) _then;

/// Create a copy of DownloadProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalFiles = null,Object? completedFiles = null,Object? currentFileProgress = null,Object? currentFileName = freezed,Object? status = null,Object? errorReason = freezed,}) {
  return _then(DownloadProgress(
totalFiles: null == totalFiles ? _self.totalFiles : totalFiles // ignore: cast_nullable_to_non_nullable
as int,completedFiles: null == completedFiles ? _self.completedFiles : completedFiles // ignore: cast_nullable_to_non_nullable
as int,currentFileProgress: null == currentFileProgress ? _self.currentFileProgress : currentFileProgress // ignore: cast_nullable_to_non_nullable
as double,currentFileName: freezed == currentFileName ? _self.currentFileName : currentFileName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DownloadStatus,errorReason: freezed == errorReason ? _self.errorReason : errorReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DownloadProgress].
extension DownloadProgressPatterns on DownloadProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadProgress value)  $default,){
final _that = this;
switch (_that) {
case _DownloadProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadProgress value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalFiles,  int completedFiles,  double currentFileProgress,  String? currentFileName,  DownloadStatus status,  String? errorReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadProgress() when $default != null:
return $default(_that.totalFiles,_that.completedFiles,_that.currentFileProgress,_that.currentFileName,_that.status,_that.errorReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalFiles,  int completedFiles,  double currentFileProgress,  String? currentFileName,  DownloadStatus status,  String? errorReason)  $default,) {final _that = this;
switch (_that) {
case _DownloadProgress():
return $default(_that.totalFiles,_that.completedFiles,_that.currentFileProgress,_that.currentFileName,_that.status,_that.errorReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalFiles,  int completedFiles,  double currentFileProgress,  String? currentFileName,  DownloadStatus status,  String? errorReason)?  $default,) {final _that = this;
switch (_that) {
case _DownloadProgress() when $default != null:
return $default(_that.totalFiles,_that.completedFiles,_that.currentFileProgress,_that.currentFileName,_that.status,_that.errorReason);case _:
  return null;

}
}

}

/// @nodoc


class _DownloadProgress extends DownloadProgress {
  const _DownloadProgress({required this.totalFiles, required this.completedFiles, this.currentFileProgress = 0.0, this.currentFileName, required this.status, this.errorReason}): super._();
  

@override final  int totalFiles;
@override final  int completedFiles;
@override@JsonKey() final  double currentFileProgress;
@override final  String? currentFileName;
@override final  DownloadStatus status;
@override final  String? errorReason;

/// Create a copy of DownloadProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadProgressCopyWith<_DownloadProgress> get copyWith => __$DownloadProgressCopyWithImpl<_DownloadProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadProgress&&(identical(other.totalFiles, totalFiles) || other.totalFiles == totalFiles)&&(identical(other.completedFiles, completedFiles) || other.completedFiles == completedFiles)&&(identical(other.currentFileProgress, currentFileProgress) || other.currentFileProgress == currentFileProgress)&&(identical(other.currentFileName, currentFileName) || other.currentFileName == currentFileName)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorReason, errorReason) || other.errorReason == errorReason));
}


@override
int get hashCode => Object.hash(runtimeType,totalFiles,completedFiles,currentFileProgress,currentFileName,status,errorReason);

@override
String toString() {
  return 'DownloadProgress(totalFiles: $totalFiles, completedFiles: $completedFiles, currentFileProgress: $currentFileProgress, currentFileName: $currentFileName, status: $status, errorReason: $errorReason)';
}


}

/// @nodoc
abstract mixin class _$DownloadProgressCopyWith<$Res> implements $DownloadProgressCopyWith<$Res> {
  factory _$DownloadProgressCopyWith(_DownloadProgress value, $Res Function(_DownloadProgress) _then) = __$DownloadProgressCopyWithImpl;
@override @useResult
$Res call({
 int totalFiles, int completedFiles, double currentFileProgress, String? currentFileName, DownloadStatus status, String? errorReason
});




}
/// @nodoc
class __$DownloadProgressCopyWithImpl<$Res>
    implements _$DownloadProgressCopyWith<$Res> {
  __$DownloadProgressCopyWithImpl(this._self, this._then);

  final _DownloadProgress _self;
  final $Res Function(_DownloadProgress) _then;

/// Create a copy of DownloadProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalFiles = null,Object? completedFiles = null,Object? currentFileProgress = null,Object? currentFileName = freezed,Object? status = null,Object? errorReason = freezed,}) {
  return _then(_DownloadProgress(
totalFiles: null == totalFiles ? _self.totalFiles : totalFiles // ignore: cast_nullable_to_non_nullable
as int,completedFiles: null == completedFiles ? _self.completedFiles : completedFiles // ignore: cast_nullable_to_non_nullable
as int,currentFileProgress: null == currentFileProgress ? _self.currentFileProgress : currentFileProgress // ignore: cast_nullable_to_non_nullable
as double,currentFileName: freezed == currentFileName ? _self.currentFileName : currentFileName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DownloadStatus,errorReason: freezed == errorReason ? _self.errorReason : errorReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
