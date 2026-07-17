// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CourseListState {
  /// 当前选中的设备类型索引(0-6)
  int get deviceType => throw _privateConstructorUsedError;

  /// 课程数据缓存（按 deviceType 索引）
  Map<int, CourseList> get courseDataMap => throw _privateConstructorUsedError;

  /// 是否正在加载
  bool get isLoading => throw _privateConstructorUsedError;

  /// 是否首次进入
  bool get isFirstIn => throw _privateConstructorUsedError;

  /// 设备名称列表（用于左侧分类展示）
  List<String> get showDeviceNameList => throw _privateConstructorUsedError;

  /// 是否允许跳转到游戏页面（防重复点击）
  bool get allowToGamePage => throw _privateConstructorUsedError;

  /// Create a copy of CourseListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseListStateCopyWith<CourseListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseListStateCopyWith<$Res> {
  factory $CourseListStateCopyWith(
    CourseListState value,
    $Res Function(CourseListState) then,
  ) = _$CourseListStateCopyWithImpl<$Res, CourseListState>;
  @useResult
  $Res call({
    int deviceType,
    Map<int, CourseList> courseDataMap,
    bool isLoading,
    bool isFirstIn,
    List<String> showDeviceNameList,
    bool allowToGamePage,
  });
}

/// @nodoc
class _$CourseListStateCopyWithImpl<$Res, $Val extends CourseListState>
    implements $CourseListStateCopyWith<$Res> {
  _$CourseListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceType = null,
    Object? courseDataMap = null,
    Object? isLoading = null,
    Object? isFirstIn = null,
    Object? showDeviceNameList = null,
    Object? allowToGamePage = null,
  }) {
    return _then(
      _value.copyWith(
            deviceType:
                null == deviceType
                    ? _value.deviceType
                    : deviceType // ignore: cast_nullable_to_non_nullable
                        as int,
            courseDataMap:
                null == courseDataMap
                    ? _value.courseDataMap
                    : courseDataMap // ignore: cast_nullable_to_non_nullable
                        as Map<int, CourseList>,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            isFirstIn:
                null == isFirstIn
                    ? _value.isFirstIn
                    : isFirstIn // ignore: cast_nullable_to_non_nullable
                        as bool,
            showDeviceNameList:
                null == showDeviceNameList
                    ? _value.showDeviceNameList
                    : showDeviceNameList // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            allowToGamePage:
                null == allowToGamePage
                    ? _value.allowToGamePage
                    : allowToGamePage // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourseListStateImplCopyWith<$Res>
    implements $CourseListStateCopyWith<$Res> {
  factory _$$CourseListStateImplCopyWith(
    _$CourseListStateImpl value,
    $Res Function(_$CourseListStateImpl) then,
  ) = __$$CourseListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int deviceType,
    Map<int, CourseList> courseDataMap,
    bool isLoading,
    bool isFirstIn,
    List<String> showDeviceNameList,
    bool allowToGamePage,
  });
}

/// @nodoc
class __$$CourseListStateImplCopyWithImpl<$Res>
    extends _$CourseListStateCopyWithImpl<$Res, _$CourseListStateImpl>
    implements _$$CourseListStateImplCopyWith<$Res> {
  __$$CourseListStateImplCopyWithImpl(
    _$CourseListStateImpl _value,
    $Res Function(_$CourseListStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceType = null,
    Object? courseDataMap = null,
    Object? isLoading = null,
    Object? isFirstIn = null,
    Object? showDeviceNameList = null,
    Object? allowToGamePage = null,
  }) {
    return _then(
      _$CourseListStateImpl(
        deviceType:
            null == deviceType
                ? _value.deviceType
                : deviceType // ignore: cast_nullable_to_non_nullable
                    as int,
        courseDataMap:
            null == courseDataMap
                ? _value._courseDataMap
                : courseDataMap // ignore: cast_nullable_to_non_nullable
                    as Map<int, CourseList>,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        isFirstIn:
            null == isFirstIn
                ? _value.isFirstIn
                : isFirstIn // ignore: cast_nullable_to_non_nullable
                    as bool,
        showDeviceNameList:
            null == showDeviceNameList
                ? _value._showDeviceNameList
                : showDeviceNameList // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        allowToGamePage:
            null == allowToGamePage
                ? _value.allowToGamePage
                : allowToGamePage // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$CourseListStateImpl implements _CourseListState {
  const _$CourseListStateImpl({
    this.deviceType = 0,
    final Map<int, CourseList> courseDataMap = const {},
    this.isLoading = true,
    this.isFirstIn = true,
    final List<String> showDeviceNameList = const [
      'Skipping',
      'Grip',
      'Dumbbell',
      'Adj-Dumbbell',
      'Push-up',
      'Kettlebell',
      'Game',
    ],
    this.allowToGamePage = true,
  }) : _courseDataMap = courseDataMap,
       _showDeviceNameList = showDeviceNameList;

  /// 当前选中的设备类型索引(0-6)
  @override
  @JsonKey()
  final int deviceType;

  /// 课程数据缓存（按 deviceType 索引）
  final Map<int, CourseList> _courseDataMap;

  /// 课程数据缓存（按 deviceType 索引）
  @override
  @JsonKey()
  Map<int, CourseList> get courseDataMap {
    if (_courseDataMap is EqualUnmodifiableMapView) return _courseDataMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_courseDataMap);
  }

  /// 是否正在加载
  @override
  @JsonKey()
  final bool isLoading;

  /// 是否首次进入
  @override
  @JsonKey()
  final bool isFirstIn;

  /// 设备名称列表（用于左侧分类展示）
  final List<String> _showDeviceNameList;

  /// 设备名称列表（用于左侧分类展示）
  @override
  @JsonKey()
  List<String> get showDeviceNameList {
    if (_showDeviceNameList is EqualUnmodifiableListView)
      return _showDeviceNameList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_showDeviceNameList);
  }

  /// 是否允许跳转到游戏页面（防重复点击）
  @override
  @JsonKey()
  final bool allowToGamePage;

  @override
  String toString() {
    return 'CourseListState(deviceType: $deviceType, courseDataMap: $courseDataMap, isLoading: $isLoading, isFirstIn: $isFirstIn, showDeviceNameList: $showDeviceNameList, allowToGamePage: $allowToGamePage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseListStateImpl &&
            (identical(other.deviceType, deviceType) ||
                other.deviceType == deviceType) &&
            const DeepCollectionEquality().equals(
              other._courseDataMap,
              _courseDataMap,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isFirstIn, isFirstIn) ||
                other.isFirstIn == isFirstIn) &&
            const DeepCollectionEquality().equals(
              other._showDeviceNameList,
              _showDeviceNameList,
            ) &&
            (identical(other.allowToGamePage, allowToGamePage) ||
                other.allowToGamePage == allowToGamePage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    deviceType,
    const DeepCollectionEquality().hash(_courseDataMap),
    isLoading,
    isFirstIn,
    const DeepCollectionEquality().hash(_showDeviceNameList),
    allowToGamePage,
  );

  /// Create a copy of CourseListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseListStateImplCopyWith<_$CourseListStateImpl> get copyWith =>
      __$$CourseListStateImplCopyWithImpl<_$CourseListStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CourseListState implements CourseListState {
  const factory _CourseListState({
    final int deviceType,
    final Map<int, CourseList> courseDataMap,
    final bool isLoading,
    final bool isFirstIn,
    final List<String> showDeviceNameList,
    final bool allowToGamePage,
  }) = _$CourseListStateImpl;

  /// 当前选中的设备类型索引(0-6)
  @override
  int get deviceType;

  /// 课程数据缓存（按 deviceType 索引）
  @override
  Map<int, CourseList> get courseDataMap;

  /// 是否正在加载
  @override
  bool get isLoading;

  /// 是否首次进入
  @override
  bool get isFirstIn;

  /// 设备名称列表（用于左侧分类展示）
  @override
  List<String> get showDeviceNameList;

  /// 是否允许跳转到游戏页面（防重复点击）
  @override
  bool get allowToGamePage;

  /// Create a copy of CourseListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseListStateImplCopyWith<_$CourseListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
