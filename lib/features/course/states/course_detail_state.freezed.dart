// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CourseDetailState {
  /// 课程动作详情
  CourseDetail? get courseDetail => throw _privateConstructorUsedError;

  /// 课程封面图 URL
  String get courseCover => throw _privateConstructorUsedError;

  /// 课程 ID
  String get courseId => throw _privateConstructorUsedError;

  /// 课程标题
  String get courseTitle => throw _privateConstructorUsedError;

  /// 课程交互设备类型
  int get interactiveEquipment => throw _privateConstructorUsedError;

  /// 版本号（用于判断是否需要更新）
  int get version => throw _privateConstructorUsedError;

  /// 课程建议
  String get proposal => throw _privateConstructorUsedError;

  /// 课程描述
  String get describe => throw _privateConstructorUsedError;

  /// 注意事项
  String get carefulthing => throw _privateConstructorUsedError;

  /// 是否需要更新（下载）
  bool get isNeedUpdate => throw _privateConstructorUsedError;

  /// 是否正在下载
  bool get isDownloading => throw _privateConstructorUsedError;

  /// 下载进度 0-100
  double get downloadProgress => throw _privateConstructorUsedError;

  /// 是否有可连接设备
  bool get playWithDevice => throw _privateConstructorUsedError;

  /// 是否正在加载动作数据
  bool get isActionDataLoading => throw _privateConstructorUsedError;

  /// 课程 index（在列表中的位置）
  int get courseIndex => throw _privateConstructorUsedError;

  /// 当前选中的动作索引（底部 sheet 用）
  int get selectedActionIndex => throw _privateConstructorUsedError;

  /// 图片播放相关
  bool get isPlaying => throw _privateConstructorUsedError;
  int get pictureIndex => throw _privateConstructorUsedError;
  int get totalPictureIndex => throw _privateConstructorUsedError;
  List<String> get pictureFileNameList => throw _privateConstructorUsedError;
  String get pictureNamePath => throw _privateConstructorUsedError;

  /// Create a copy of CourseDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseDetailStateCopyWith<CourseDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseDetailStateCopyWith<$Res> {
  factory $CourseDetailStateCopyWith(
    CourseDetailState value,
    $Res Function(CourseDetailState) then,
  ) = _$CourseDetailStateCopyWithImpl<$Res, CourseDetailState>;
  @useResult
  $Res call({
    CourseDetail? courseDetail,
    String courseCover,
    String courseId,
    String courseTitle,
    int interactiveEquipment,
    int version,
    String proposal,
    String describe,
    String carefulthing,
    bool isNeedUpdate,
    bool isDownloading,
    double downloadProgress,
    bool playWithDevice,
    bool isActionDataLoading,
    int courseIndex,
    int selectedActionIndex,
    bool isPlaying,
    int pictureIndex,
    int totalPictureIndex,
    List<String> pictureFileNameList,
    String pictureNamePath,
  });

  $CourseDetailCopyWith<$Res>? get courseDetail;
}

/// @nodoc
class _$CourseDetailStateCopyWithImpl<$Res, $Val extends CourseDetailState>
    implements $CourseDetailStateCopyWith<$Res> {
  _$CourseDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseDetail = freezed,
    Object? courseCover = null,
    Object? courseId = null,
    Object? courseTitle = null,
    Object? interactiveEquipment = null,
    Object? version = null,
    Object? proposal = null,
    Object? describe = null,
    Object? carefulthing = null,
    Object? isNeedUpdate = null,
    Object? isDownloading = null,
    Object? downloadProgress = null,
    Object? playWithDevice = null,
    Object? isActionDataLoading = null,
    Object? courseIndex = null,
    Object? selectedActionIndex = null,
    Object? isPlaying = null,
    Object? pictureIndex = null,
    Object? totalPictureIndex = null,
    Object? pictureFileNameList = null,
    Object? pictureNamePath = null,
  }) {
    return _then(
      _value.copyWith(
            courseDetail:
                freezed == courseDetail
                    ? _value.courseDetail
                    : courseDetail // ignore: cast_nullable_to_non_nullable
                        as CourseDetail?,
            courseCover:
                null == courseCover
                    ? _value.courseCover
                    : courseCover // ignore: cast_nullable_to_non_nullable
                        as String,
            courseId:
                null == courseId
                    ? _value.courseId
                    : courseId // ignore: cast_nullable_to_non_nullable
                        as String,
            courseTitle:
                null == courseTitle
                    ? _value.courseTitle
                    : courseTitle // ignore: cast_nullable_to_non_nullable
                        as String,
            interactiveEquipment:
                null == interactiveEquipment
                    ? _value.interactiveEquipment
                    : interactiveEquipment // ignore: cast_nullable_to_non_nullable
                        as int,
            version:
                null == version
                    ? _value.version
                    : version // ignore: cast_nullable_to_non_nullable
                        as int,
            proposal:
                null == proposal
                    ? _value.proposal
                    : proposal // ignore: cast_nullable_to_non_nullable
                        as String,
            describe:
                null == describe
                    ? _value.describe
                    : describe // ignore: cast_nullable_to_non_nullable
                        as String,
            carefulthing:
                null == carefulthing
                    ? _value.carefulthing
                    : carefulthing // ignore: cast_nullable_to_non_nullable
                        as String,
            isNeedUpdate:
                null == isNeedUpdate
                    ? _value.isNeedUpdate
                    : isNeedUpdate // ignore: cast_nullable_to_non_nullable
                        as bool,
            isDownloading:
                null == isDownloading
                    ? _value.isDownloading
                    : isDownloading // ignore: cast_nullable_to_non_nullable
                        as bool,
            downloadProgress:
                null == downloadProgress
                    ? _value.downloadProgress
                    : downloadProgress // ignore: cast_nullable_to_non_nullable
                        as double,
            playWithDevice:
                null == playWithDevice
                    ? _value.playWithDevice
                    : playWithDevice // ignore: cast_nullable_to_non_nullable
                        as bool,
            isActionDataLoading:
                null == isActionDataLoading
                    ? _value.isActionDataLoading
                    : isActionDataLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            courseIndex:
                null == courseIndex
                    ? _value.courseIndex
                    : courseIndex // ignore: cast_nullable_to_non_nullable
                        as int,
            selectedActionIndex:
                null == selectedActionIndex
                    ? _value.selectedActionIndex
                    : selectedActionIndex // ignore: cast_nullable_to_non_nullable
                        as int,
            isPlaying:
                null == isPlaying
                    ? _value.isPlaying
                    : isPlaying // ignore: cast_nullable_to_non_nullable
                        as bool,
            pictureIndex:
                null == pictureIndex
                    ? _value.pictureIndex
                    : pictureIndex // ignore: cast_nullable_to_non_nullable
                        as int,
            totalPictureIndex:
                null == totalPictureIndex
                    ? _value.totalPictureIndex
                    : totalPictureIndex // ignore: cast_nullable_to_non_nullable
                        as int,
            pictureFileNameList:
                null == pictureFileNameList
                    ? _value.pictureFileNameList
                    : pictureFileNameList // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            pictureNamePath:
                null == pictureNamePath
                    ? _value.pictureNamePath
                    : pictureNamePath // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }

  /// Create a copy of CourseDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CourseDetailCopyWith<$Res>? get courseDetail {
    if (_value.courseDetail == null) {
      return null;
    }

    return $CourseDetailCopyWith<$Res>(_value.courseDetail!, (value) {
      return _then(_value.copyWith(courseDetail: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CourseDetailStateImplCopyWith<$Res>
    implements $CourseDetailStateCopyWith<$Res> {
  factory _$$CourseDetailStateImplCopyWith(
    _$CourseDetailStateImpl value,
    $Res Function(_$CourseDetailStateImpl) then,
  ) = __$$CourseDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    CourseDetail? courseDetail,
    String courseCover,
    String courseId,
    String courseTitle,
    int interactiveEquipment,
    int version,
    String proposal,
    String describe,
    String carefulthing,
    bool isNeedUpdate,
    bool isDownloading,
    double downloadProgress,
    bool playWithDevice,
    bool isActionDataLoading,
    int courseIndex,
    int selectedActionIndex,
    bool isPlaying,
    int pictureIndex,
    int totalPictureIndex,
    List<String> pictureFileNameList,
    String pictureNamePath,
  });

  @override
  $CourseDetailCopyWith<$Res>? get courseDetail;
}

/// @nodoc
class __$$CourseDetailStateImplCopyWithImpl<$Res>
    extends _$CourseDetailStateCopyWithImpl<$Res, _$CourseDetailStateImpl>
    implements _$$CourseDetailStateImplCopyWith<$Res> {
  __$$CourseDetailStateImplCopyWithImpl(
    _$CourseDetailStateImpl _value,
    $Res Function(_$CourseDetailStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseDetail = freezed,
    Object? courseCover = null,
    Object? courseId = null,
    Object? courseTitle = null,
    Object? interactiveEquipment = null,
    Object? version = null,
    Object? proposal = null,
    Object? describe = null,
    Object? carefulthing = null,
    Object? isNeedUpdate = null,
    Object? isDownloading = null,
    Object? downloadProgress = null,
    Object? playWithDevice = null,
    Object? isActionDataLoading = null,
    Object? courseIndex = null,
    Object? selectedActionIndex = null,
    Object? isPlaying = null,
    Object? pictureIndex = null,
    Object? totalPictureIndex = null,
    Object? pictureFileNameList = null,
    Object? pictureNamePath = null,
  }) {
    return _then(
      _$CourseDetailStateImpl(
        courseDetail:
            freezed == courseDetail
                ? _value.courseDetail
                : courseDetail // ignore: cast_nullable_to_non_nullable
                    as CourseDetail?,
        courseCover:
            null == courseCover
                ? _value.courseCover
                : courseCover // ignore: cast_nullable_to_non_nullable
                    as String,
        courseId:
            null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                    as String,
        courseTitle:
            null == courseTitle
                ? _value.courseTitle
                : courseTitle // ignore: cast_nullable_to_non_nullable
                    as String,
        interactiveEquipment:
            null == interactiveEquipment
                ? _value.interactiveEquipment
                : interactiveEquipment // ignore: cast_nullable_to_non_nullable
                    as int,
        version:
            null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                    as int,
        proposal:
            null == proposal
                ? _value.proposal
                : proposal // ignore: cast_nullable_to_non_nullable
                    as String,
        describe:
            null == describe
                ? _value.describe
                : describe // ignore: cast_nullable_to_non_nullable
                    as String,
        carefulthing:
            null == carefulthing
                ? _value.carefulthing
                : carefulthing // ignore: cast_nullable_to_non_nullable
                    as String,
        isNeedUpdate:
            null == isNeedUpdate
                ? _value.isNeedUpdate
                : isNeedUpdate // ignore: cast_nullable_to_non_nullable
                    as bool,
        isDownloading:
            null == isDownloading
                ? _value.isDownloading
                : isDownloading // ignore: cast_nullable_to_non_nullable
                    as bool,
        downloadProgress:
            null == downloadProgress
                ? _value.downloadProgress
                : downloadProgress // ignore: cast_nullable_to_non_nullable
                    as double,
        playWithDevice:
            null == playWithDevice
                ? _value.playWithDevice
                : playWithDevice // ignore: cast_nullable_to_non_nullable
                    as bool,
        isActionDataLoading:
            null == isActionDataLoading
                ? _value.isActionDataLoading
                : isActionDataLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        courseIndex:
            null == courseIndex
                ? _value.courseIndex
                : courseIndex // ignore: cast_nullable_to_non_nullable
                    as int,
        selectedActionIndex:
            null == selectedActionIndex
                ? _value.selectedActionIndex
                : selectedActionIndex // ignore: cast_nullable_to_non_nullable
                    as int,
        isPlaying:
            null == isPlaying
                ? _value.isPlaying
                : isPlaying // ignore: cast_nullable_to_non_nullable
                    as bool,
        pictureIndex:
            null == pictureIndex
                ? _value.pictureIndex
                : pictureIndex // ignore: cast_nullable_to_non_nullable
                    as int,
        totalPictureIndex:
            null == totalPictureIndex
                ? _value.totalPictureIndex
                : totalPictureIndex // ignore: cast_nullable_to_non_nullable
                    as int,
        pictureFileNameList:
            null == pictureFileNameList
                ? _value._pictureFileNameList
                : pictureFileNameList // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        pictureNamePath:
            null == pictureNamePath
                ? _value.pictureNamePath
                : pictureNamePath // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$CourseDetailStateImpl implements _CourseDetailState {
  const _$CourseDetailStateImpl({
    this.courseDetail,
    this.courseCover = '',
    this.courseId = '',
    this.courseTitle = '',
    this.interactiveEquipment = 0,
    this.version = 0,
    this.proposal = '',
    this.describe = '',
    this.carefulthing = '',
    this.isNeedUpdate = true,
    this.isDownloading = false,
    this.downloadProgress = 0.0,
    this.playWithDevice = false,
    this.isActionDataLoading = false,
    this.courseIndex = 0,
    this.selectedActionIndex = 0,
    this.isPlaying = false,
    this.pictureIndex = 0,
    this.totalPictureIndex = 0,
    final List<String> pictureFileNameList = const [],
    this.pictureNamePath = '',
  }) : _pictureFileNameList = pictureFileNameList;

  /// 课程动作详情
  @override
  final CourseDetail? courseDetail;

  /// 课程封面图 URL
  @override
  @JsonKey()
  final String courseCover;

  /// 课程 ID
  @override
  @JsonKey()
  final String courseId;

  /// 课程标题
  @override
  @JsonKey()
  final String courseTitle;

  /// 课程交互设备类型
  @override
  @JsonKey()
  final int interactiveEquipment;

  /// 版本号（用于判断是否需要更新）
  @override
  @JsonKey()
  final int version;

  /// 课程建议
  @override
  @JsonKey()
  final String proposal;

  /// 课程描述
  @override
  @JsonKey()
  final String describe;

  /// 注意事项
  @override
  @JsonKey()
  final String carefulthing;

  /// 是否需要更新（下载）
  @override
  @JsonKey()
  final bool isNeedUpdate;

  /// 是否正在下载
  @override
  @JsonKey()
  final bool isDownloading;

  /// 下载进度 0-100
  @override
  @JsonKey()
  final double downloadProgress;

  /// 是否有可连接设备
  @override
  @JsonKey()
  final bool playWithDevice;

  /// 是否正在加载动作数据
  @override
  @JsonKey()
  final bool isActionDataLoading;

  /// 课程 index（在列表中的位置）
  @override
  @JsonKey()
  final int courseIndex;

  /// 当前选中的动作索引（底部 sheet 用）
  @override
  @JsonKey()
  final int selectedActionIndex;

  /// 图片播放相关
  @override
  @JsonKey()
  final bool isPlaying;
  @override
  @JsonKey()
  final int pictureIndex;
  @override
  @JsonKey()
  final int totalPictureIndex;
  final List<String> _pictureFileNameList;
  @override
  @JsonKey()
  List<String> get pictureFileNameList {
    if (_pictureFileNameList is EqualUnmodifiableListView)
      return _pictureFileNameList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pictureFileNameList);
  }

  @override
  @JsonKey()
  final String pictureNamePath;

  @override
  String toString() {
    return 'CourseDetailState(courseDetail: $courseDetail, courseCover: $courseCover, courseId: $courseId, courseTitle: $courseTitle, interactiveEquipment: $interactiveEquipment, version: $version, proposal: $proposal, describe: $describe, carefulthing: $carefulthing, isNeedUpdate: $isNeedUpdate, isDownloading: $isDownloading, downloadProgress: $downloadProgress, playWithDevice: $playWithDevice, isActionDataLoading: $isActionDataLoading, courseIndex: $courseIndex, selectedActionIndex: $selectedActionIndex, isPlaying: $isPlaying, pictureIndex: $pictureIndex, totalPictureIndex: $totalPictureIndex, pictureFileNameList: $pictureFileNameList, pictureNamePath: $pictureNamePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseDetailStateImpl &&
            (identical(other.courseDetail, courseDetail) ||
                other.courseDetail == courseDetail) &&
            (identical(other.courseCover, courseCover) ||
                other.courseCover == courseCover) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.courseTitle, courseTitle) ||
                other.courseTitle == courseTitle) &&
            (identical(other.interactiveEquipment, interactiveEquipment) ||
                other.interactiveEquipment == interactiveEquipment) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.proposal, proposal) ||
                other.proposal == proposal) &&
            (identical(other.describe, describe) ||
                other.describe == describe) &&
            (identical(other.carefulthing, carefulthing) ||
                other.carefulthing == carefulthing) &&
            (identical(other.isNeedUpdate, isNeedUpdate) ||
                other.isNeedUpdate == isNeedUpdate) &&
            (identical(other.isDownloading, isDownloading) ||
                other.isDownloading == isDownloading) &&
            (identical(other.downloadProgress, downloadProgress) ||
                other.downloadProgress == downloadProgress) &&
            (identical(other.playWithDevice, playWithDevice) ||
                other.playWithDevice == playWithDevice) &&
            (identical(other.isActionDataLoading, isActionDataLoading) ||
                other.isActionDataLoading == isActionDataLoading) &&
            (identical(other.courseIndex, courseIndex) ||
                other.courseIndex == courseIndex) &&
            (identical(other.selectedActionIndex, selectedActionIndex) ||
                other.selectedActionIndex == selectedActionIndex) &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying) &&
            (identical(other.pictureIndex, pictureIndex) ||
                other.pictureIndex == pictureIndex) &&
            (identical(other.totalPictureIndex, totalPictureIndex) ||
                other.totalPictureIndex == totalPictureIndex) &&
            const DeepCollectionEquality().equals(
              other._pictureFileNameList,
              _pictureFileNameList,
            ) &&
            (identical(other.pictureNamePath, pictureNamePath) ||
                other.pictureNamePath == pictureNamePath));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    courseDetail,
    courseCover,
    courseId,
    courseTitle,
    interactiveEquipment,
    version,
    proposal,
    describe,
    carefulthing,
    isNeedUpdate,
    isDownloading,
    downloadProgress,
    playWithDevice,
    isActionDataLoading,
    courseIndex,
    selectedActionIndex,
    isPlaying,
    pictureIndex,
    totalPictureIndex,
    const DeepCollectionEquality().hash(_pictureFileNameList),
    pictureNamePath,
  ]);

  /// Create a copy of CourseDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseDetailStateImplCopyWith<_$CourseDetailStateImpl> get copyWith =>
      __$$CourseDetailStateImplCopyWithImpl<_$CourseDetailStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CourseDetailState implements CourseDetailState {
  const factory _CourseDetailState({
    final CourseDetail? courseDetail,
    final String courseCover,
    final String courseId,
    final String courseTitle,
    final int interactiveEquipment,
    final int version,
    final String proposal,
    final String describe,
    final String carefulthing,
    final bool isNeedUpdate,
    final bool isDownloading,
    final double downloadProgress,
    final bool playWithDevice,
    final bool isActionDataLoading,
    final int courseIndex,
    final int selectedActionIndex,
    final bool isPlaying,
    final int pictureIndex,
    final int totalPictureIndex,
    final List<String> pictureFileNameList,
    final String pictureNamePath,
  }) = _$CourseDetailStateImpl;

  /// 课程动作详情
  @override
  CourseDetail? get courseDetail;

  /// 课程封面图 URL
  @override
  String get courseCover;

  /// 课程 ID
  @override
  String get courseId;

  /// 课程标题
  @override
  String get courseTitle;

  /// 课程交互设备类型
  @override
  int get interactiveEquipment;

  /// 版本号（用于判断是否需要更新）
  @override
  int get version;

  /// 课程建议
  @override
  String get proposal;

  /// 课程描述
  @override
  String get describe;

  /// 注意事项
  @override
  String get carefulthing;

  /// 是否需要更新（下载）
  @override
  bool get isNeedUpdate;

  /// 是否正在下载
  @override
  bool get isDownloading;

  /// 下载进度 0-100
  @override
  double get downloadProgress;

  /// 是否有可连接设备
  @override
  bool get playWithDevice;

  /// 是否正在加载动作数据
  @override
  bool get isActionDataLoading;

  /// 课程 index（在列表中的位置）
  @override
  int get courseIndex;

  /// 当前选中的动作索引（底部 sheet 用）
  @override
  int get selectedActionIndex;

  /// 图片播放相关
  @override
  bool get isPlaying;
  @override
  int get pictureIndex;
  @override
  int get totalPictureIndex;
  @override
  List<String> get pictureFileNameList;
  @override
  String get pictureNamePath;

  /// Create a copy of CourseDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseDetailStateImplCopyWith<_$CourseDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
