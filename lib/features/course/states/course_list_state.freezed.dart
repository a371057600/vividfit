// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CourseListState {

/// 当前选中的设备类型索引(0-6)
 int get deviceType;/// 课程数据缓存（按 deviceType 索引）
 Map<int, CourseList> get courseDataMap;/// 是否正在加载
 bool get isLoading;/// 是否首次进入
 bool get isFirstIn;/// 设备名称列表（用于左侧分类展示）
 List<String> get showDeviceNameList;/// 是否允许跳转到游戏页面（防重复点击）
 bool get allowToGamePage;
/// Create a copy of CourseListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseListStateCopyWith<CourseListState> get copyWith => _$CourseListStateCopyWithImpl<CourseListState>(this as CourseListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseListState&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&const DeepCollectionEquality().equals(other.courseDataMap, courseDataMap)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isFirstIn, isFirstIn) || other.isFirstIn == isFirstIn)&&const DeepCollectionEquality().equals(other.showDeviceNameList, showDeviceNameList)&&(identical(other.allowToGamePage, allowToGamePage) || other.allowToGamePage == allowToGamePage));
}


@override
int get hashCode => Object.hash(runtimeType,deviceType,const DeepCollectionEquality().hash(courseDataMap),isLoading,isFirstIn,const DeepCollectionEquality().hash(showDeviceNameList),allowToGamePage);

@override
String toString() {
  return 'CourseListState(deviceType: $deviceType, courseDataMap: $courseDataMap, isLoading: $isLoading, isFirstIn: $isFirstIn, showDeviceNameList: $showDeviceNameList, allowToGamePage: $allowToGamePage)';
}


}

/// @nodoc
abstract mixin class $CourseListStateCopyWith<$Res>  {
  factory $CourseListStateCopyWith(CourseListState value, $Res Function(CourseListState) _then) = _$CourseListStateCopyWithImpl;
@useResult
$Res call({
 int deviceType, Map<int, CourseList> courseDataMap, bool isLoading, bool isFirstIn, List<String> showDeviceNameList, bool allowToGamePage
});




}
/// @nodoc
class _$CourseListStateCopyWithImpl<$Res>
    implements $CourseListStateCopyWith<$Res> {
  _$CourseListStateCopyWithImpl(this._self, this._then);

  final CourseListState _self;
  final $Res Function(CourseListState) _then;

/// Create a copy of CourseListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceType = null,Object? courseDataMap = null,Object? isLoading = null,Object? isFirstIn = null,Object? showDeviceNameList = null,Object? allowToGamePage = null,}) {
  return _then(_self.copyWith(
deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as int,courseDataMap: null == courseDataMap ? _self.courseDataMap : courseDataMap // ignore: cast_nullable_to_non_nullable
as Map<int, CourseList>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isFirstIn: null == isFirstIn ? _self.isFirstIn : isFirstIn // ignore: cast_nullable_to_non_nullable
as bool,showDeviceNameList: null == showDeviceNameList ? _self.showDeviceNameList : showDeviceNameList // ignore: cast_nullable_to_non_nullable
as List<String>,allowToGamePage: null == allowToGamePage ? _self.allowToGamePage : allowToGamePage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseListState].
extension CourseListStatePatterns on CourseListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseListState value)  $default,){
final _that = this;
switch (_that) {
case _CourseListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseListState value)?  $default,){
final _that = this;
switch (_that) {
case _CourseListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int deviceType,  Map<int, CourseList> courseDataMap,  bool isLoading,  bool isFirstIn,  List<String> showDeviceNameList,  bool allowToGamePage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseListState() when $default != null:
return $default(_that.deviceType,_that.courseDataMap,_that.isLoading,_that.isFirstIn,_that.showDeviceNameList,_that.allowToGamePage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int deviceType,  Map<int, CourseList> courseDataMap,  bool isLoading,  bool isFirstIn,  List<String> showDeviceNameList,  bool allowToGamePage)  $default,) {final _that = this;
switch (_that) {
case _CourseListState():
return $default(_that.deviceType,_that.courseDataMap,_that.isLoading,_that.isFirstIn,_that.showDeviceNameList,_that.allowToGamePage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int deviceType,  Map<int, CourseList> courseDataMap,  bool isLoading,  bool isFirstIn,  List<String> showDeviceNameList,  bool allowToGamePage)?  $default,) {final _that = this;
switch (_that) {
case _CourseListState() when $default != null:
return $default(_that.deviceType,_that.courseDataMap,_that.isLoading,_that.isFirstIn,_that.showDeviceNameList,_that.allowToGamePage);case _:
  return null;

}
}

}

/// @nodoc


class _CourseListState implements CourseListState {
  const _CourseListState({this.deviceType = 0, final  Map<int, CourseList> courseDataMap = const {}, this.isLoading = true, this.isFirstIn = true, final  List<String> showDeviceNameList = const ['Skipping', 'Grip', 'Dumbbell', 'Adj-Dumbbell', 'Push-up', 'Kettlebell', 'Game'], this.allowToGamePage = true}): _courseDataMap = courseDataMap,_showDeviceNameList = showDeviceNameList;
  

/// 当前选中的设备类型索引(0-6)
@override@JsonKey() final  int deviceType;
/// 课程数据缓存（按 deviceType 索引）
 final  Map<int, CourseList> _courseDataMap;
/// 课程数据缓存（按 deviceType 索引）
@override@JsonKey() Map<int, CourseList> get courseDataMap {
  if (_courseDataMap is EqualUnmodifiableMapView) return _courseDataMap;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_courseDataMap);
}

/// 是否正在加载
@override@JsonKey() final  bool isLoading;
/// 是否首次进入
@override@JsonKey() final  bool isFirstIn;
/// 设备名称列表（用于左侧分类展示）
 final  List<String> _showDeviceNameList;
/// 设备名称列表（用于左侧分类展示）
@override@JsonKey() List<String> get showDeviceNameList {
  if (_showDeviceNameList is EqualUnmodifiableListView) return _showDeviceNameList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_showDeviceNameList);
}

/// 是否允许跳转到游戏页面（防重复点击）
@override@JsonKey() final  bool allowToGamePage;

/// Create a copy of CourseListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseListStateCopyWith<_CourseListState> get copyWith => __$CourseListStateCopyWithImpl<_CourseListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseListState&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&const DeepCollectionEquality().equals(other._courseDataMap, _courseDataMap)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isFirstIn, isFirstIn) || other.isFirstIn == isFirstIn)&&const DeepCollectionEquality().equals(other._showDeviceNameList, _showDeviceNameList)&&(identical(other.allowToGamePage, allowToGamePage) || other.allowToGamePage == allowToGamePage));
}


@override
int get hashCode => Object.hash(runtimeType,deviceType,const DeepCollectionEquality().hash(_courseDataMap),isLoading,isFirstIn,const DeepCollectionEquality().hash(_showDeviceNameList),allowToGamePage);

@override
String toString() {
  return 'CourseListState(deviceType: $deviceType, courseDataMap: $courseDataMap, isLoading: $isLoading, isFirstIn: $isFirstIn, showDeviceNameList: $showDeviceNameList, allowToGamePage: $allowToGamePage)';
}


}

/// @nodoc
abstract mixin class _$CourseListStateCopyWith<$Res> implements $CourseListStateCopyWith<$Res> {
  factory _$CourseListStateCopyWith(_CourseListState value, $Res Function(_CourseListState) _then) = __$CourseListStateCopyWithImpl;
@override @useResult
$Res call({
 int deviceType, Map<int, CourseList> courseDataMap, bool isLoading, bool isFirstIn, List<String> showDeviceNameList, bool allowToGamePage
});




}
/// @nodoc
class __$CourseListStateCopyWithImpl<$Res>
    implements _$CourseListStateCopyWith<$Res> {
  __$CourseListStateCopyWithImpl(this._self, this._then);

  final _CourseListState _self;
  final $Res Function(_CourseListState) _then;

/// Create a copy of CourseListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceType = null,Object? courseDataMap = null,Object? isLoading = null,Object? isFirstIn = null,Object? showDeviceNameList = null,Object? allowToGamePage = null,}) {
  return _then(_CourseListState(
deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as int,courseDataMap: null == courseDataMap ? _self._courseDataMap : courseDataMap // ignore: cast_nullable_to_non_nullable
as Map<int, CourseList>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isFirstIn: null == isFirstIn ? _self.isFirstIn : isFirstIn // ignore: cast_nullable_to_non_nullable
as bool,showDeviceNameList: null == showDeviceNameList ? _self._showDeviceNameList : showDeviceNameList // ignore: cast_nullable_to_non_nullable
as List<String>,allowToGamePage: null == allowToGamePage ? _self.allowToGamePage : allowToGamePage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
