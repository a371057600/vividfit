// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_catalog_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CourseCatalogState {

/// 课程目录(对应旧 courseTypeList)。
 CourseCatalog? get catalog;/// 是否正在加载(对应旧 hc.isLoading)。
 bool get isLoading;/// 是否为空数据(对应旧 hc.isEmpty)。
 bool get isEmpty;/// 当前设备类型(对应旧 newMainSelectType,用 FtmsDeviceType 枚举替代 magic number)。
 FtmsDeviceType get deviceType;/// 当前选中的分类索引(对应旧 courseTypeSelect)。
 int get selectedCategoryIndex;/// 选中的课程索引(对应旧 bigDeviceCourseDetailIndex)。
 int get selectedCourseIndex;
/// Create a copy of CourseCatalogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseCatalogStateCopyWith<CourseCatalogState> get copyWith => _$CourseCatalogStateCopyWithImpl<CourseCatalogState>(this as CourseCatalogState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseCatalogState&&(identical(other.catalog, catalog) || other.catalog == catalog)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isEmpty, isEmpty) || other.isEmpty == isEmpty)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.selectedCategoryIndex, selectedCategoryIndex) || other.selectedCategoryIndex == selectedCategoryIndex)&&(identical(other.selectedCourseIndex, selectedCourseIndex) || other.selectedCourseIndex == selectedCourseIndex));
}


@override
int get hashCode => Object.hash(runtimeType,catalog,isLoading,isEmpty,deviceType,selectedCategoryIndex,selectedCourseIndex);

@override
String toString() {
  return 'CourseCatalogState(catalog: $catalog, isLoading: $isLoading, isEmpty: $isEmpty, deviceType: $deviceType, selectedCategoryIndex: $selectedCategoryIndex, selectedCourseIndex: $selectedCourseIndex)';
}


}

/// @nodoc
abstract mixin class $CourseCatalogStateCopyWith<$Res>  {
  factory $CourseCatalogStateCopyWith(CourseCatalogState value, $Res Function(CourseCatalogState) _then) = _$CourseCatalogStateCopyWithImpl;
@useResult
$Res call({
 CourseCatalog? catalog, bool isLoading, bool isEmpty, FtmsDeviceType deviceType, int selectedCategoryIndex, int selectedCourseIndex
});




}
/// @nodoc
class _$CourseCatalogStateCopyWithImpl<$Res>
    implements $CourseCatalogStateCopyWith<$Res> {
  _$CourseCatalogStateCopyWithImpl(this._self, this._then);

  final CourseCatalogState _self;
  final $Res Function(CourseCatalogState) _then;

/// Create a copy of CourseCatalogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? catalog = freezed,Object? isLoading = null,Object? isEmpty = null,Object? deviceType = null,Object? selectedCategoryIndex = null,Object? selectedCourseIndex = null,}) {
  return _then(CourseCatalogState(
catalog: freezed == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as CourseCatalog?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isEmpty: null == isEmpty ? _self.isEmpty : isEmpty // ignore: cast_nullable_to_non_nullable
as bool,deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as FtmsDeviceType,selectedCategoryIndex: null == selectedCategoryIndex ? _self.selectedCategoryIndex : selectedCategoryIndex // ignore: cast_nullable_to_non_nullable
as int,selectedCourseIndex: null == selectedCourseIndex ? _self.selectedCourseIndex : selectedCourseIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseCatalogState].
extension CourseCatalogStatePatterns on CourseCatalogState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseCatalogState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseCatalogState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseCatalogState value)  $default,){
final _that = this;
switch (_that) {
case _CourseCatalogState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseCatalogState value)?  $default,){
final _that = this;
switch (_that) {
case _CourseCatalogState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CourseCatalog? catalog,  bool isLoading,  bool isEmpty,  FtmsDeviceType deviceType,  int selectedCategoryIndex,  int selectedCourseIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseCatalogState() when $default != null:
return $default(_that.catalog,_that.isLoading,_that.isEmpty,_that.deviceType,_that.selectedCategoryIndex,_that.selectedCourseIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CourseCatalog? catalog,  bool isLoading,  bool isEmpty,  FtmsDeviceType deviceType,  int selectedCategoryIndex,  int selectedCourseIndex)  $default,) {final _that = this;
switch (_that) {
case _CourseCatalogState():
return $default(_that.catalog,_that.isLoading,_that.isEmpty,_that.deviceType,_that.selectedCategoryIndex,_that.selectedCourseIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CourseCatalog? catalog,  bool isLoading,  bool isEmpty,  FtmsDeviceType deviceType,  int selectedCategoryIndex,  int selectedCourseIndex)?  $default,) {final _that = this;
switch (_that) {
case _CourseCatalogState() when $default != null:
return $default(_that.catalog,_that.isLoading,_that.isEmpty,_that.deviceType,_that.selectedCategoryIndex,_that.selectedCourseIndex);case _:
  return null;

}
}

}

/// @nodoc


class _CourseCatalogState implements CourseCatalogState {
  const _CourseCatalogState({this.catalog, this.isLoading = false, this.isEmpty = false, this.deviceType = FtmsDeviceType.indoorBike, this.selectedCategoryIndex = 0, this.selectedCourseIndex = 0});
  

/// 课程目录(对应旧 courseTypeList)。
@override final  CourseCatalog? catalog;
/// 是否正在加载(对应旧 hc.isLoading)。
@override@JsonKey() final  bool isLoading;
/// 是否为空数据(对应旧 hc.isEmpty)。
@override@JsonKey() final  bool isEmpty;
/// 当前设备类型(对应旧 newMainSelectType,用 FtmsDeviceType 枚举替代 magic number)。
@override@JsonKey() final  FtmsDeviceType deviceType;
/// 当前选中的分类索引(对应旧 courseTypeSelect)。
@override@JsonKey() final  int selectedCategoryIndex;
/// 选中的课程索引(对应旧 bigDeviceCourseDetailIndex)。
@override@JsonKey() final  int selectedCourseIndex;

/// Create a copy of CourseCatalogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseCatalogStateCopyWith<_CourseCatalogState> get copyWith => __$CourseCatalogStateCopyWithImpl<_CourseCatalogState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseCatalogState&&(identical(other.catalog, catalog) || other.catalog == catalog)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isEmpty, isEmpty) || other.isEmpty == isEmpty)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.selectedCategoryIndex, selectedCategoryIndex) || other.selectedCategoryIndex == selectedCategoryIndex)&&(identical(other.selectedCourseIndex, selectedCourseIndex) || other.selectedCourseIndex == selectedCourseIndex));
}


@override
int get hashCode => Object.hash(runtimeType,catalog,isLoading,isEmpty,deviceType,selectedCategoryIndex,selectedCourseIndex);

@override
String toString() {
  return 'CourseCatalogState(catalog: $catalog, isLoading: $isLoading, isEmpty: $isEmpty, deviceType: $deviceType, selectedCategoryIndex: $selectedCategoryIndex, selectedCourseIndex: $selectedCourseIndex)';
}


}

/// @nodoc
abstract mixin class _$CourseCatalogStateCopyWith<$Res> implements $CourseCatalogStateCopyWith<$Res> {
  factory _$CourseCatalogStateCopyWith(_CourseCatalogState value, $Res Function(_CourseCatalogState) _then) = __$CourseCatalogStateCopyWithImpl;
@override @useResult
$Res call({
 CourseCatalog? catalog, bool isLoading, bool isEmpty, FtmsDeviceType deviceType, int selectedCategoryIndex, int selectedCourseIndex
});




}
/// @nodoc
class __$CourseCatalogStateCopyWithImpl<$Res>
    implements _$CourseCatalogStateCopyWith<$Res> {
  __$CourseCatalogStateCopyWithImpl(this._self, this._then);

  final _CourseCatalogState _self;
  final $Res Function(_CourseCatalogState) _then;

/// Create a copy of CourseCatalogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? catalog = freezed,Object? isLoading = null,Object? isEmpty = null,Object? deviceType = null,Object? selectedCategoryIndex = null,Object? selectedCourseIndex = null,}) {
  return _then(_CourseCatalogState(
catalog: freezed == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as CourseCatalog?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isEmpty: null == isEmpty ? _self.isEmpty : isEmpty // ignore: cast_nullable_to_non_nullable
as bool,deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as FtmsDeviceType,selectedCategoryIndex: null == selectedCategoryIndex ? _self.selectedCategoryIndex : selectedCategoryIndex // ignore: cast_nullable_to_non_nullable
as int,selectedCourseIndex: null == selectedCourseIndex ? _self.selectedCourseIndex : selectedCourseIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
