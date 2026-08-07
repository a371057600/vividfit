// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

/// 底部导航当前 tab
 int get currentIndex;/// 主页三环 + BMI 数据
 FitMainData get mainData;/// 用户昵称(主页标题用)
 String get nickName;/// 头像 hash
 String get headImageHash;/// 选中动画角色索引(0=xinxin 1=rubby 2=cat 3=boxing 4=dog 5=jack 6=carol)
 int get selectedCharacterIndex;/// 主页"我的排名"
 String get myRank;/// 今日是否打卡
 bool get isReached;/// 是否有 AI 报告
 bool get hasAiReport;/// 是否正在加载(首次进入)
 bool get isLoading;/// 动画帧索引(1~123,初始1)
 int get animationIndex;/// 防重复点击锁(6秒冷却)
 bool get allowTouch;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.mainData, mainData) || other.mainData == mainData)&&(identical(other.nickName, nickName) || other.nickName == nickName)&&(identical(other.headImageHash, headImageHash) || other.headImageHash == headImageHash)&&(identical(other.selectedCharacterIndex, selectedCharacterIndex) || other.selectedCharacterIndex == selectedCharacterIndex)&&(identical(other.myRank, myRank) || other.myRank == myRank)&&(identical(other.isReached, isReached) || other.isReached == isReached)&&(identical(other.hasAiReport, hasAiReport) || other.hasAiReport == hasAiReport)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.animationIndex, animationIndex) || other.animationIndex == animationIndex)&&(identical(other.allowTouch, allowTouch) || other.allowTouch == allowTouch));
}


@override
int get hashCode => Object.hash(runtimeType,currentIndex,mainData,nickName,headImageHash,selectedCharacterIndex,myRank,isReached,hasAiReport,isLoading,animationIndex,allowTouch);

@override
String toString() {
  return 'HomeState(currentIndex: $currentIndex, mainData: $mainData, nickName: $nickName, headImageHash: $headImageHash, selectedCharacterIndex: $selectedCharacterIndex, myRank: $myRank, isReached: $isReached, hasAiReport: $hasAiReport, isLoading: $isLoading, animationIndex: $animationIndex, allowTouch: $allowTouch)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 int currentIndex, FitMainData mainData, String nickName, String headImageHash, int selectedCharacterIndex, String myRank, bool isReached, bool hasAiReport, bool isLoading, int animationIndex, bool allowTouch
});


$FitMainDataCopyWith<$Res> get mainData;

}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentIndex = null,Object? mainData = null,Object? nickName = null,Object? headImageHash = null,Object? selectedCharacterIndex = null,Object? myRank = null,Object? isReached = null,Object? hasAiReport = null,Object? isLoading = null,Object? animationIndex = null,Object? allowTouch = null,}) {
  return _then(HomeState(
currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,mainData: null == mainData ? _self.mainData : mainData // ignore: cast_nullable_to_non_nullable
as FitMainData,nickName: null == nickName ? _self.nickName : nickName // ignore: cast_nullable_to_non_nullable
as String,headImageHash: null == headImageHash ? _self.headImageHash : headImageHash // ignore: cast_nullable_to_non_nullable
as String,selectedCharacterIndex: null == selectedCharacterIndex ? _self.selectedCharacterIndex : selectedCharacterIndex // ignore: cast_nullable_to_non_nullable
as int,myRank: null == myRank ? _self.myRank : myRank // ignore: cast_nullable_to_non_nullable
as String,isReached: null == isReached ? _self.isReached : isReached // ignore: cast_nullable_to_non_nullable
as bool,hasAiReport: null == hasAiReport ? _self.hasAiReport : hasAiReport // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,animationIndex: null == animationIndex ? _self.animationIndex : animationIndex // ignore: cast_nullable_to_non_nullable
as int,allowTouch: null == allowTouch ? _self.allowTouch : allowTouch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FitMainDataCopyWith<$Res> get mainData {
  
  return $FitMainDataCopyWith<$Res>(_self.mainData, (value) {
    return _then(_self.copyWith(mainData: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentIndex,  FitMainData mainData,  String nickName,  String headImageHash,  int selectedCharacterIndex,  String myRank,  bool isReached,  bool hasAiReport,  bool isLoading,  int animationIndex,  bool allowTouch)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.currentIndex,_that.mainData,_that.nickName,_that.headImageHash,_that.selectedCharacterIndex,_that.myRank,_that.isReached,_that.hasAiReport,_that.isLoading,_that.animationIndex,_that.allowTouch);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentIndex,  FitMainData mainData,  String nickName,  String headImageHash,  int selectedCharacterIndex,  String myRank,  bool isReached,  bool hasAiReport,  bool isLoading,  int animationIndex,  bool allowTouch)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.currentIndex,_that.mainData,_that.nickName,_that.headImageHash,_that.selectedCharacterIndex,_that.myRank,_that.isReached,_that.hasAiReport,_that.isLoading,_that.animationIndex,_that.allowTouch);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentIndex,  FitMainData mainData,  String nickName,  String headImageHash,  int selectedCharacterIndex,  String myRank,  bool isReached,  bool hasAiReport,  bool isLoading,  int animationIndex,  bool allowTouch)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.currentIndex,_that.mainData,_that.nickName,_that.headImageHash,_that.selectedCharacterIndex,_that.myRank,_that.isReached,_that.hasAiReport,_that.isLoading,_that.animationIndex,_that.allowTouch);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState implements HomeState {
  const _HomeState({this.currentIndex = 0, this.mainData = const FitMainData(), this.nickName = 'UserName', this.headImageHash = '', this.selectedCharacterIndex = 0, this.myRank = '99', this.isReached = false, this.hasAiReport = false, this.isLoading = true, this.animationIndex = 1, this.allowTouch = true});
  

/// 底部导航当前 tab
@override@JsonKey() final  int currentIndex;
/// 主页三环 + BMI 数据
@override@JsonKey() final  FitMainData mainData;
/// 用户昵称(主页标题用)
@override@JsonKey() final  String nickName;
/// 头像 hash
@override@JsonKey() final  String headImageHash;
/// 选中动画角色索引(0=xinxin 1=rubby 2=cat 3=boxing 4=dog 5=jack 6=carol)
@override@JsonKey() final  int selectedCharacterIndex;
/// 主页"我的排名"
@override@JsonKey() final  String myRank;
/// 今日是否打卡
@override@JsonKey() final  bool isReached;
/// 是否有 AI 报告
@override@JsonKey() final  bool hasAiReport;
/// 是否正在加载(首次进入)
@override@JsonKey() final  bool isLoading;
/// 动画帧索引(1~123,初始1)
@override@JsonKey() final  int animationIndex;
/// 防重复点击锁(6秒冷却)
@override@JsonKey() final  bool allowTouch;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.mainData, mainData) || other.mainData == mainData)&&(identical(other.nickName, nickName) || other.nickName == nickName)&&(identical(other.headImageHash, headImageHash) || other.headImageHash == headImageHash)&&(identical(other.selectedCharacterIndex, selectedCharacterIndex) || other.selectedCharacterIndex == selectedCharacterIndex)&&(identical(other.myRank, myRank) || other.myRank == myRank)&&(identical(other.isReached, isReached) || other.isReached == isReached)&&(identical(other.hasAiReport, hasAiReport) || other.hasAiReport == hasAiReport)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.animationIndex, animationIndex) || other.animationIndex == animationIndex)&&(identical(other.allowTouch, allowTouch) || other.allowTouch == allowTouch));
}


@override
int get hashCode => Object.hash(runtimeType,currentIndex,mainData,nickName,headImageHash,selectedCharacterIndex,myRank,isReached,hasAiReport,isLoading,animationIndex,allowTouch);

@override
String toString() {
  return 'HomeState(currentIndex: $currentIndex, mainData: $mainData, nickName: $nickName, headImageHash: $headImageHash, selectedCharacterIndex: $selectedCharacterIndex, myRank: $myRank, isReached: $isReached, hasAiReport: $hasAiReport, isLoading: $isLoading, animationIndex: $animationIndex, allowTouch: $allowTouch)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 int currentIndex, FitMainData mainData, String nickName, String headImageHash, int selectedCharacterIndex, String myRank, bool isReached, bool hasAiReport, bool isLoading, int animationIndex, bool allowTouch
});


@override $FitMainDataCopyWith<$Res> get mainData;

}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentIndex = null,Object? mainData = null,Object? nickName = null,Object? headImageHash = null,Object? selectedCharacterIndex = null,Object? myRank = null,Object? isReached = null,Object? hasAiReport = null,Object? isLoading = null,Object? animationIndex = null,Object? allowTouch = null,}) {
  return _then(_HomeState(
currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,mainData: null == mainData ? _self.mainData : mainData // ignore: cast_nullable_to_non_nullable
as FitMainData,nickName: null == nickName ? _self.nickName : nickName // ignore: cast_nullable_to_non_nullable
as String,headImageHash: null == headImageHash ? _self.headImageHash : headImageHash // ignore: cast_nullable_to_non_nullable
as String,selectedCharacterIndex: null == selectedCharacterIndex ? _self.selectedCharacterIndex : selectedCharacterIndex // ignore: cast_nullable_to_non_nullable
as int,myRank: null == myRank ? _self.myRank : myRank // ignore: cast_nullable_to_non_nullable
as String,isReached: null == isReached ? _self.isReached : isReached // ignore: cast_nullable_to_non_nullable
as bool,hasAiReport: null == hasAiReport ? _self.hasAiReport : hasAiReport // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,animationIndex: null == animationIndex ? _self.animationIndex : animationIndex // ignore: cast_nullable_to_non_nullable
as int,allowTouch: null == allowTouch ? _self.allowTouch : allowTouch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FitMainDataCopyWith<$Res> get mainData {
  
  return $FitMainDataCopyWith<$Res>(_self.mainData, (value) {
    return _then(_self.copyWith(mainData: value));
  });
}
}

// dart format on
