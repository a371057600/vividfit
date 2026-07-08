// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HomeState {
  /// 底部导航当前 tab
  int get currentIndex => throw _privateConstructorUsedError;

  /// 主页三环 + BMI 数据
  NewMainData get mainData => throw _privateConstructorUsedError;

  /// 用户昵称(主页标题用)
  String get nickName => throw _privateConstructorUsedError;

  /// 头像 hash
  String get headImageHash => throw _privateConstructorUsedError;

  /// 选中动画角色索引(0=xinxin 1=rubby 2=cat 3=boxing 4=dog 5=jack 6=carol)
  int get selectedCharacterIndex => throw _privateConstructorUsedError;

  /// 主页"我的排名"
  String get myRank => throw _privateConstructorUsedError;

  /// 今日是否打卡
  bool get isReached => throw _privateConstructorUsedError;

  /// 是否有 AI 报告
  bool get hasAiReport => throw _privateConstructorUsedError;

  /// 是否正在加载(首次进入)
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call({
    int currentIndex,
    NewMainData mainData,
    String nickName,
    String headImageHash,
    int selectedCharacterIndex,
    String myRank,
    bool isReached,
    bool hasAiReport,
    bool isLoading,
  });

  $NewMainDataCopyWith<$Res> get mainData;
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentIndex = null,
    Object? mainData = null,
    Object? nickName = null,
    Object? headImageHash = null,
    Object? selectedCharacterIndex = null,
    Object? myRank = null,
    Object? isReached = null,
    Object? hasAiReport = null,
    Object? isLoading = null,
  }) {
    return _then(
      _value.copyWith(
            currentIndex:
                null == currentIndex
                    ? _value.currentIndex
                    : currentIndex // ignore: cast_nullable_to_non_nullable
                        as int,
            mainData:
                null == mainData
                    ? _value.mainData
                    : mainData // ignore: cast_nullable_to_non_nullable
                        as NewMainData,
            nickName:
                null == nickName
                    ? _value.nickName
                    : nickName // ignore: cast_nullable_to_non_nullable
                        as String,
            headImageHash:
                null == headImageHash
                    ? _value.headImageHash
                    : headImageHash // ignore: cast_nullable_to_non_nullable
                        as String,
            selectedCharacterIndex:
                null == selectedCharacterIndex
                    ? _value.selectedCharacterIndex
                    : selectedCharacterIndex // ignore: cast_nullable_to_non_nullable
                        as int,
            myRank:
                null == myRank
                    ? _value.myRank
                    : myRank // ignore: cast_nullable_to_non_nullable
                        as String,
            isReached:
                null == isReached
                    ? _value.isReached
                    : isReached // ignore: cast_nullable_to_non_nullable
                        as bool,
            hasAiReport:
                null == hasAiReport
                    ? _value.hasAiReport
                    : hasAiReport // ignore: cast_nullable_to_non_nullable
                        as bool,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NewMainDataCopyWith<$Res> get mainData {
    return $NewMainDataCopyWith<$Res>(_value.mainData, (value) {
      return _then(_value.copyWith(mainData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
    _$HomeStateImpl value,
    $Res Function(_$HomeStateImpl) then,
  ) = __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentIndex,
    NewMainData mainData,
    String nickName,
    String headImageHash,
    int selectedCharacterIndex,
    String myRank,
    bool isReached,
    bool hasAiReport,
    bool isLoading,
  });

  @override
  $NewMainDataCopyWith<$Res> get mainData;
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
    _$HomeStateImpl _value,
    $Res Function(_$HomeStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentIndex = null,
    Object? mainData = null,
    Object? nickName = null,
    Object? headImageHash = null,
    Object? selectedCharacterIndex = null,
    Object? myRank = null,
    Object? isReached = null,
    Object? hasAiReport = null,
    Object? isLoading = null,
  }) {
    return _then(
      _$HomeStateImpl(
        currentIndex:
            null == currentIndex
                ? _value.currentIndex
                : currentIndex // ignore: cast_nullable_to_non_nullable
                    as int,
        mainData:
            null == mainData
                ? _value.mainData
                : mainData // ignore: cast_nullable_to_non_nullable
                    as NewMainData,
        nickName:
            null == nickName
                ? _value.nickName
                : nickName // ignore: cast_nullable_to_non_nullable
                    as String,
        headImageHash:
            null == headImageHash
                ? _value.headImageHash
                : headImageHash // ignore: cast_nullable_to_non_nullable
                    as String,
        selectedCharacterIndex:
            null == selectedCharacterIndex
                ? _value.selectedCharacterIndex
                : selectedCharacterIndex // ignore: cast_nullable_to_non_nullable
                    as int,
        myRank:
            null == myRank
                ? _value.myRank
                : myRank // ignore: cast_nullable_to_non_nullable
                    as String,
        isReached:
            null == isReached
                ? _value.isReached
                : isReached // ignore: cast_nullable_to_non_nullable
                    as bool,
        hasAiReport:
            null == hasAiReport
                ? _value.hasAiReport
                : hasAiReport // ignore: cast_nullable_to_non_nullable
                    as bool,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl({
    this.currentIndex = 0,
    this.mainData = const NewMainData(),
    this.nickName = 'UserName',
    this.headImageHash = '',
    this.selectedCharacterIndex = 0,
    this.myRank = '99',
    this.isReached = false,
    this.hasAiReport = false,
    this.isLoading = true,
  });

  /// 底部导航当前 tab
  @override
  @JsonKey()
  final int currentIndex;

  /// 主页三环 + BMI 数据
  @override
  @JsonKey()
  final NewMainData mainData;

  /// 用户昵称(主页标题用)
  @override
  @JsonKey()
  final String nickName;

  /// 头像 hash
  @override
  @JsonKey()
  final String headImageHash;

  /// 选中动画角色索引(0=xinxin 1=rubby 2=cat 3=boxing 4=dog 5=jack 6=carol)
  @override
  @JsonKey()
  final int selectedCharacterIndex;

  /// 主页"我的排名"
  @override
  @JsonKey()
  final String myRank;

  /// 今日是否打卡
  @override
  @JsonKey()
  final bool isReached;

  /// 是否有 AI 报告
  @override
  @JsonKey()
  final bool hasAiReport;

  /// 是否正在加载(首次进入)
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'HomeState(currentIndex: $currentIndex, mainData: $mainData, nickName: $nickName, headImageHash: $headImageHash, selectedCharacterIndex: $selectedCharacterIndex, myRank: $myRank, isReached: $isReached, hasAiReport: $hasAiReport, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.mainData, mainData) ||
                other.mainData == mainData) &&
            (identical(other.nickName, nickName) ||
                other.nickName == nickName) &&
            (identical(other.headImageHash, headImageHash) ||
                other.headImageHash == headImageHash) &&
            (identical(other.selectedCharacterIndex, selectedCharacterIndex) ||
                other.selectedCharacterIndex == selectedCharacterIndex) &&
            (identical(other.myRank, myRank) || other.myRank == myRank) &&
            (identical(other.isReached, isReached) ||
                other.isReached == isReached) &&
            (identical(other.hasAiReport, hasAiReport) ||
                other.hasAiReport == hasAiReport) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentIndex,
    mainData,
    nickName,
    headImageHash,
    selectedCharacterIndex,
    myRank,
    isReached,
    hasAiReport,
    isLoading,
  );

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState({
    final int currentIndex,
    final NewMainData mainData,
    final String nickName,
    final String headImageHash,
    final int selectedCharacterIndex,
    final String myRank,
    final bool isReached,
    final bool hasAiReport,
    final bool isLoading,
  }) = _$HomeStateImpl;

  /// 底部导航当前 tab
  @override
  int get currentIndex;

  /// 主页三环 + BMI 数据
  @override
  NewMainData get mainData;

  /// 用户昵称(主页标题用)
  @override
  String get nickName;

  /// 头像 hash
  @override
  String get headImageHash;

  /// 选中动画角色索引(0=xinxin 1=rubby 2=cat 3=boxing 4=dog 5=jack 6=carol)
  @override
  int get selectedCharacterIndex;

  /// 主页"我的排名"
  @override
  String get myRank;

  /// 今日是否打卡
  @override
  bool get isReached;

  /// 是否有 AI 报告
  @override
  bool get hasAiReport;

  /// 是否正在加载(首次进入)
  @override
  bool get isLoading;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
