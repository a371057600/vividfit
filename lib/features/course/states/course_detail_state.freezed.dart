// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CourseDetailState {

/// 课程动作详情
 CourseDetail? get courseDetail;/// 课程封面图 URL
 String get courseCover;/// 课程 ID
 String get courseId;/// 课程标题
 String get courseTitle;/// 课程交互设备类型
 int get interactiveEquipment;/// 版本号（用于判断是否需要更新）
 int get version;/// 课程建议
 String get proposal;/// 课程描述
 String get describe;/// 注意事项
 String get carefulthing;/// 是否需要更新（下载）
 bool get isNeedUpdate;/// 是否正在下载
 bool get isDownloading;/// 下载进度 0-100
 double get downloadProgress;/// 是否有可连接设备
 bool get playWithDevice;/// 是否正在加载动作数据
 bool get isActionDataLoading;/// 课程 index（在列表中的位置）
 int get courseIndex;/// 当前选中的动作索引（底部 sheet 用）
 int get selectedActionIndex;/// 图片播放相关
 bool get isPlaying; int get pictureIndex; int get totalPictureIndex; List<String> get pictureFileNameList; String get pictureNamePath;
/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseDetailStateCopyWith<CourseDetailState> get copyWith => _$CourseDetailStateCopyWithImpl<CourseDetailState>(this as CourseDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailState&&(identical(other.courseDetail, courseDetail) || other.courseDetail == courseDetail)&&(identical(other.courseCover, courseCover) || other.courseCover == courseCover)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.interactiveEquipment, interactiveEquipment) || other.interactiveEquipment == interactiveEquipment)&&(identical(other.version, version) || other.version == version)&&(identical(other.proposal, proposal) || other.proposal == proposal)&&(identical(other.describe, describe) || other.describe == describe)&&(identical(other.carefulthing, carefulthing) || other.carefulthing == carefulthing)&&(identical(other.isNeedUpdate, isNeedUpdate) || other.isNeedUpdate == isNeedUpdate)&&(identical(other.isDownloading, isDownloading) || other.isDownloading == isDownloading)&&(identical(other.downloadProgress, downloadProgress) || other.downloadProgress == downloadProgress)&&(identical(other.playWithDevice, playWithDevice) || other.playWithDevice == playWithDevice)&&(identical(other.isActionDataLoading, isActionDataLoading) || other.isActionDataLoading == isActionDataLoading)&&(identical(other.courseIndex, courseIndex) || other.courseIndex == courseIndex)&&(identical(other.selectedActionIndex, selectedActionIndex) || other.selectedActionIndex == selectedActionIndex)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.pictureIndex, pictureIndex) || other.pictureIndex == pictureIndex)&&(identical(other.totalPictureIndex, totalPictureIndex) || other.totalPictureIndex == totalPictureIndex)&&const DeepCollectionEquality().equals(other.pictureFileNameList, pictureFileNameList)&&(identical(other.pictureNamePath, pictureNamePath) || other.pictureNamePath == pictureNamePath));
}


@override
int get hashCode => Object.hashAll([runtimeType,courseDetail,courseCover,courseId,courseTitle,interactiveEquipment,version,proposal,describe,carefulthing,isNeedUpdate,isDownloading,downloadProgress,playWithDevice,isActionDataLoading,courseIndex,selectedActionIndex,isPlaying,pictureIndex,totalPictureIndex,const DeepCollectionEquality().hash(pictureFileNameList),pictureNamePath]);

@override
String toString() {
  return 'CourseDetailState(courseDetail: $courseDetail, courseCover: $courseCover, courseId: $courseId, courseTitle: $courseTitle, interactiveEquipment: $interactiveEquipment, version: $version, proposal: $proposal, describe: $describe, carefulthing: $carefulthing, isNeedUpdate: $isNeedUpdate, isDownloading: $isDownloading, downloadProgress: $downloadProgress, playWithDevice: $playWithDevice, isActionDataLoading: $isActionDataLoading, courseIndex: $courseIndex, selectedActionIndex: $selectedActionIndex, isPlaying: $isPlaying, pictureIndex: $pictureIndex, totalPictureIndex: $totalPictureIndex, pictureFileNameList: $pictureFileNameList, pictureNamePath: $pictureNamePath)';
}


}

/// @nodoc
abstract mixin class $CourseDetailStateCopyWith<$Res>  {
  factory $CourseDetailStateCopyWith(CourseDetailState value, $Res Function(CourseDetailState) _then) = _$CourseDetailStateCopyWithImpl;
@useResult
$Res call({
 CourseDetail? courseDetail, String courseCover, String courseId, String courseTitle, int interactiveEquipment, int version, String proposal, String describe, String carefulthing, bool isNeedUpdate, bool isDownloading, double downloadProgress, bool playWithDevice, bool isActionDataLoading, int courseIndex, int selectedActionIndex, bool isPlaying, int pictureIndex, int totalPictureIndex, List<String> pictureFileNameList, String pictureNamePath
});


$CourseDetailCopyWith<$Res>? get courseDetail;

}
/// @nodoc
class _$CourseDetailStateCopyWithImpl<$Res>
    implements $CourseDetailStateCopyWith<$Res> {
  _$CourseDetailStateCopyWithImpl(this._self, this._then);

  final CourseDetailState _self;
  final $Res Function(CourseDetailState) _then;

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courseDetail = freezed,Object? courseCover = null,Object? courseId = null,Object? courseTitle = null,Object? interactiveEquipment = null,Object? version = null,Object? proposal = null,Object? describe = null,Object? carefulthing = null,Object? isNeedUpdate = null,Object? isDownloading = null,Object? downloadProgress = null,Object? playWithDevice = null,Object? isActionDataLoading = null,Object? courseIndex = null,Object? selectedActionIndex = null,Object? isPlaying = null,Object? pictureIndex = null,Object? totalPictureIndex = null,Object? pictureFileNameList = null,Object? pictureNamePath = null,}) {
  return _then(CourseDetailState(
courseDetail: freezed == courseDetail ? _self.courseDetail : courseDetail // ignore: cast_nullable_to_non_nullable
as CourseDetail?,courseCover: null == courseCover ? _self.courseCover : courseCover // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,interactiveEquipment: null == interactiveEquipment ? _self.interactiveEquipment : interactiveEquipment // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,proposal: null == proposal ? _self.proposal : proposal // ignore: cast_nullable_to_non_nullable
as String,describe: null == describe ? _self.describe : describe // ignore: cast_nullable_to_non_nullable
as String,carefulthing: null == carefulthing ? _self.carefulthing : carefulthing // ignore: cast_nullable_to_non_nullable
as String,isNeedUpdate: null == isNeedUpdate ? _self.isNeedUpdate : isNeedUpdate // ignore: cast_nullable_to_non_nullable
as bool,isDownloading: null == isDownloading ? _self.isDownloading : isDownloading // ignore: cast_nullable_to_non_nullable
as bool,downloadProgress: null == downloadProgress ? _self.downloadProgress : downloadProgress // ignore: cast_nullable_to_non_nullable
as double,playWithDevice: null == playWithDevice ? _self.playWithDevice : playWithDevice // ignore: cast_nullable_to_non_nullable
as bool,isActionDataLoading: null == isActionDataLoading ? _self.isActionDataLoading : isActionDataLoading // ignore: cast_nullable_to_non_nullable
as bool,courseIndex: null == courseIndex ? _self.courseIndex : courseIndex // ignore: cast_nullable_to_non_nullable
as int,selectedActionIndex: null == selectedActionIndex ? _self.selectedActionIndex : selectedActionIndex // ignore: cast_nullable_to_non_nullable
as int,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,pictureIndex: null == pictureIndex ? _self.pictureIndex : pictureIndex // ignore: cast_nullable_to_non_nullable
as int,totalPictureIndex: null == totalPictureIndex ? _self.totalPictureIndex : totalPictureIndex // ignore: cast_nullable_to_non_nullable
as int,pictureFileNameList: null == pictureFileNameList ? _self.pictureFileNameList : pictureFileNameList // ignore: cast_nullable_to_non_nullable
as List<String>,pictureNamePath: null == pictureNamePath ? _self.pictureNamePath : pictureNamePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseDetailCopyWith<$Res>? get courseDetail {
    if (_self.courseDetail == null) {
    return null;
  }

  return $CourseDetailCopyWith<$Res>(_self.courseDetail!, (value) {
    return _then(_self.copyWith(courseDetail: value));
  });
}
}


/// Adds pattern-matching-related methods to [CourseDetailState].
extension CourseDetailStatePatterns on CourseDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseDetailState value)  $default,){
final _that = this;
switch (_that) {
case _CourseDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _CourseDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CourseDetail? courseDetail,  String courseCover,  String courseId,  String courseTitle,  int interactiveEquipment,  int version,  String proposal,  String describe,  String carefulthing,  bool isNeedUpdate,  bool isDownloading,  double downloadProgress,  bool playWithDevice,  bool isActionDataLoading,  int courseIndex,  int selectedActionIndex,  bool isPlaying,  int pictureIndex,  int totalPictureIndex,  List<String> pictureFileNameList,  String pictureNamePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseDetailState() when $default != null:
return $default(_that.courseDetail,_that.courseCover,_that.courseId,_that.courseTitle,_that.interactiveEquipment,_that.version,_that.proposal,_that.describe,_that.carefulthing,_that.isNeedUpdate,_that.isDownloading,_that.downloadProgress,_that.playWithDevice,_that.isActionDataLoading,_that.courseIndex,_that.selectedActionIndex,_that.isPlaying,_that.pictureIndex,_that.totalPictureIndex,_that.pictureFileNameList,_that.pictureNamePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CourseDetail? courseDetail,  String courseCover,  String courseId,  String courseTitle,  int interactiveEquipment,  int version,  String proposal,  String describe,  String carefulthing,  bool isNeedUpdate,  bool isDownloading,  double downloadProgress,  bool playWithDevice,  bool isActionDataLoading,  int courseIndex,  int selectedActionIndex,  bool isPlaying,  int pictureIndex,  int totalPictureIndex,  List<String> pictureFileNameList,  String pictureNamePath)  $default,) {final _that = this;
switch (_that) {
case _CourseDetailState():
return $default(_that.courseDetail,_that.courseCover,_that.courseId,_that.courseTitle,_that.interactiveEquipment,_that.version,_that.proposal,_that.describe,_that.carefulthing,_that.isNeedUpdate,_that.isDownloading,_that.downloadProgress,_that.playWithDevice,_that.isActionDataLoading,_that.courseIndex,_that.selectedActionIndex,_that.isPlaying,_that.pictureIndex,_that.totalPictureIndex,_that.pictureFileNameList,_that.pictureNamePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CourseDetail? courseDetail,  String courseCover,  String courseId,  String courseTitle,  int interactiveEquipment,  int version,  String proposal,  String describe,  String carefulthing,  bool isNeedUpdate,  bool isDownloading,  double downloadProgress,  bool playWithDevice,  bool isActionDataLoading,  int courseIndex,  int selectedActionIndex,  bool isPlaying,  int pictureIndex,  int totalPictureIndex,  List<String> pictureFileNameList,  String pictureNamePath)?  $default,) {final _that = this;
switch (_that) {
case _CourseDetailState() when $default != null:
return $default(_that.courseDetail,_that.courseCover,_that.courseId,_that.courseTitle,_that.interactiveEquipment,_that.version,_that.proposal,_that.describe,_that.carefulthing,_that.isNeedUpdate,_that.isDownloading,_that.downloadProgress,_that.playWithDevice,_that.isActionDataLoading,_that.courseIndex,_that.selectedActionIndex,_that.isPlaying,_that.pictureIndex,_that.totalPictureIndex,_that.pictureFileNameList,_that.pictureNamePath);case _:
  return null;

}
}

}

/// @nodoc


class _CourseDetailState implements CourseDetailState {
  const _CourseDetailState({this.courseDetail, this.courseCover = '', this.courseId = '', this.courseTitle = '', this.interactiveEquipment = 0, this.version = 0, this.proposal = '', this.describe = '', this.carefulthing = '', this.isNeedUpdate = true, this.isDownloading = false, this.downloadProgress = 0.0, this.playWithDevice = false, this.isActionDataLoading = false, this.courseIndex = 0, this.selectedActionIndex = 0, this.isPlaying = false, this.pictureIndex = 0, this.totalPictureIndex = 0,  List<String> pictureFileNameList = const [], this.pictureNamePath = ''}): _pictureFileNameList = pictureFileNameList;
  

/// 课程动作详情
@override final  CourseDetail? courseDetail;
/// 课程封面图 URL
@override@JsonKey() final  String courseCover;
/// 课程 ID
@override@JsonKey() final  String courseId;
/// 课程标题
@override@JsonKey() final  String courseTitle;
/// 课程交互设备类型
@override@JsonKey() final  int interactiveEquipment;
/// 版本号（用于判断是否需要更新）
@override@JsonKey() final  int version;
/// 课程建议
@override@JsonKey() final  String proposal;
/// 课程描述
@override@JsonKey() final  String describe;
/// 注意事项
@override@JsonKey() final  String carefulthing;
/// 是否需要更新（下载）
@override@JsonKey() final  bool isNeedUpdate;
/// 是否正在下载
@override@JsonKey() final  bool isDownloading;
/// 下载进度 0-100
@override@JsonKey() final  double downloadProgress;
/// 是否有可连接设备
@override@JsonKey() final  bool playWithDevice;
/// 是否正在加载动作数据
@override@JsonKey() final  bool isActionDataLoading;
/// 课程 index（在列表中的位置）
@override@JsonKey() final  int courseIndex;
/// 当前选中的动作索引（底部 sheet 用）
@override@JsonKey() final  int selectedActionIndex;
/// 图片播放相关
@override@JsonKey() final  bool isPlaying;
@override@JsonKey() final  int pictureIndex;
@override@JsonKey() final  int totalPictureIndex;
 final  List<String> _pictureFileNameList;
@override@JsonKey() List<String> get pictureFileNameList {
  if (_pictureFileNameList is EqualUnmodifiableListView) return _pictureFileNameList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pictureFileNameList);
}

@override@JsonKey() final  String pictureNamePath;

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseDetailStateCopyWith<_CourseDetailState> get copyWith => __$CourseDetailStateCopyWithImpl<_CourseDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseDetailState&&(identical(other.courseDetail, courseDetail) || other.courseDetail == courseDetail)&&(identical(other.courseCover, courseCover) || other.courseCover == courseCover)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.interactiveEquipment, interactiveEquipment) || other.interactiveEquipment == interactiveEquipment)&&(identical(other.version, version) || other.version == version)&&(identical(other.proposal, proposal) || other.proposal == proposal)&&(identical(other.describe, describe) || other.describe == describe)&&(identical(other.carefulthing, carefulthing) || other.carefulthing == carefulthing)&&(identical(other.isNeedUpdate, isNeedUpdate) || other.isNeedUpdate == isNeedUpdate)&&(identical(other.isDownloading, isDownloading) || other.isDownloading == isDownloading)&&(identical(other.downloadProgress, downloadProgress) || other.downloadProgress == downloadProgress)&&(identical(other.playWithDevice, playWithDevice) || other.playWithDevice == playWithDevice)&&(identical(other.isActionDataLoading, isActionDataLoading) || other.isActionDataLoading == isActionDataLoading)&&(identical(other.courseIndex, courseIndex) || other.courseIndex == courseIndex)&&(identical(other.selectedActionIndex, selectedActionIndex) || other.selectedActionIndex == selectedActionIndex)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.pictureIndex, pictureIndex) || other.pictureIndex == pictureIndex)&&(identical(other.totalPictureIndex, totalPictureIndex) || other.totalPictureIndex == totalPictureIndex)&&const DeepCollectionEquality().equals(other._pictureFileNameList, _pictureFileNameList)&&(identical(other.pictureNamePath, pictureNamePath) || other.pictureNamePath == pictureNamePath));
}


@override
int get hashCode => Object.hashAll([runtimeType,courseDetail,courseCover,courseId,courseTitle,interactiveEquipment,version,proposal,describe,carefulthing,isNeedUpdate,isDownloading,downloadProgress,playWithDevice,isActionDataLoading,courseIndex,selectedActionIndex,isPlaying,pictureIndex,totalPictureIndex,const DeepCollectionEquality().hash(_pictureFileNameList),pictureNamePath]);

@override
String toString() {
  return 'CourseDetailState(courseDetail: $courseDetail, courseCover: $courseCover, courseId: $courseId, courseTitle: $courseTitle, interactiveEquipment: $interactiveEquipment, version: $version, proposal: $proposal, describe: $describe, carefulthing: $carefulthing, isNeedUpdate: $isNeedUpdate, isDownloading: $isDownloading, downloadProgress: $downloadProgress, playWithDevice: $playWithDevice, isActionDataLoading: $isActionDataLoading, courseIndex: $courseIndex, selectedActionIndex: $selectedActionIndex, isPlaying: $isPlaying, pictureIndex: $pictureIndex, totalPictureIndex: $totalPictureIndex, pictureFileNameList: $pictureFileNameList, pictureNamePath: $pictureNamePath)';
}


}

/// @nodoc
abstract mixin class _$CourseDetailStateCopyWith<$Res> implements $CourseDetailStateCopyWith<$Res> {
  factory _$CourseDetailStateCopyWith(_CourseDetailState value, $Res Function(_CourseDetailState) _then) = __$CourseDetailStateCopyWithImpl;
@override @useResult
$Res call({
 CourseDetail? courseDetail, String courseCover, String courseId, String courseTitle, int interactiveEquipment, int version, String proposal, String describe, String carefulthing, bool isNeedUpdate, bool isDownloading, double downloadProgress, bool playWithDevice, bool isActionDataLoading, int courseIndex, int selectedActionIndex, bool isPlaying, int pictureIndex, int totalPictureIndex, List<String> pictureFileNameList, String pictureNamePath
});


@override $CourseDetailCopyWith<$Res>? get courseDetail;

}
/// @nodoc
class __$CourseDetailStateCopyWithImpl<$Res>
    implements _$CourseDetailStateCopyWith<$Res> {
  __$CourseDetailStateCopyWithImpl(this._self, this._then);

  final _CourseDetailState _self;
  final $Res Function(_CourseDetailState) _then;

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courseDetail = freezed,Object? courseCover = null,Object? courseId = null,Object? courseTitle = null,Object? interactiveEquipment = null,Object? version = null,Object? proposal = null,Object? describe = null,Object? carefulthing = null,Object? isNeedUpdate = null,Object? isDownloading = null,Object? downloadProgress = null,Object? playWithDevice = null,Object? isActionDataLoading = null,Object? courseIndex = null,Object? selectedActionIndex = null,Object? isPlaying = null,Object? pictureIndex = null,Object? totalPictureIndex = null,Object? pictureFileNameList = null,Object? pictureNamePath = null,}) {
  return _then(_CourseDetailState(
courseDetail: freezed == courseDetail ? _self.courseDetail : courseDetail // ignore: cast_nullable_to_non_nullable
as CourseDetail?,courseCover: null == courseCover ? _self.courseCover : courseCover // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,interactiveEquipment: null == interactiveEquipment ? _self.interactiveEquipment : interactiveEquipment // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,proposal: null == proposal ? _self.proposal : proposal // ignore: cast_nullable_to_non_nullable
as String,describe: null == describe ? _self.describe : describe // ignore: cast_nullable_to_non_nullable
as String,carefulthing: null == carefulthing ? _self.carefulthing : carefulthing // ignore: cast_nullable_to_non_nullable
as String,isNeedUpdate: null == isNeedUpdate ? _self.isNeedUpdate : isNeedUpdate // ignore: cast_nullable_to_non_nullable
as bool,isDownloading: null == isDownloading ? _self.isDownloading : isDownloading // ignore: cast_nullable_to_non_nullable
as bool,downloadProgress: null == downloadProgress ? _self.downloadProgress : downloadProgress // ignore: cast_nullable_to_non_nullable
as double,playWithDevice: null == playWithDevice ? _self.playWithDevice : playWithDevice // ignore: cast_nullable_to_non_nullable
as bool,isActionDataLoading: null == isActionDataLoading ? _self.isActionDataLoading : isActionDataLoading // ignore: cast_nullable_to_non_nullable
as bool,courseIndex: null == courseIndex ? _self.courseIndex : courseIndex // ignore: cast_nullable_to_non_nullable
as int,selectedActionIndex: null == selectedActionIndex ? _self.selectedActionIndex : selectedActionIndex // ignore: cast_nullable_to_non_nullable
as int,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,pictureIndex: null == pictureIndex ? _self.pictureIndex : pictureIndex // ignore: cast_nullable_to_non_nullable
as int,totalPictureIndex: null == totalPictureIndex ? _self.totalPictureIndex : totalPictureIndex // ignore: cast_nullable_to_non_nullable
as int,pictureFileNameList: null == pictureFileNameList ? _self._pictureFileNameList : pictureFileNameList // ignore: cast_nullable_to_non_nullable
as List<String>,pictureNamePath: null == pictureNamePath ? _self.pictureNamePath : pictureNamePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseDetailCopyWith<$Res>? get courseDetail {
    if (_self.courseDetail == null) {
    return null;
  }

  return $CourseDetailCopyWith<$Res>(_self.courseDetail!, (value) {
    return _then(_self.copyWith(courseDetail: value));
  });
}
}

// dart format on
