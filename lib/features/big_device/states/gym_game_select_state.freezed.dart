// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gym_game_select_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GymGameSelectState {

/// 当前选中音乐索引 0~7（对应旧 cbcs.selectIndex）。
 int get selectedMusicIndex;/// 音乐是否正在播放（对应旧 cbcs.isMusicPlaying）。
 bool get isMusicPlaying;/// 音量是否开启（对应旧 cbcs.isVolumeOpen）。
 bool get isVolumeOpen;/// 音乐暂停标志（对应旧 cbcs.ismusicPause，区分暂停恢复 vs 切换新歌）。
 bool get isMusicPaused;/// 专辑封面轮播索引 0~70（对应旧 cbcs.imageIndex）。
 int get albumImageIndex;/// 游戏卡片图片资源列表（对应旧 cbcs.gamePictureList）。
 List<String> get gamePictureList;/// 游戏跳转路由名列表（对应旧 cbcs.gameList）。
 List<String> get gameRouteList;/// 各游戏页 WebView 是否已实装（true=允许跳转 / false=Toast 阻断）。
/// key：gameRouteList 中的路由名。
/// ⚠️ 约束：任何没有 WebView URL 实装的 Placeholder 页，必须为 false。
 Map<String, bool> get gameWebViewReadyMap;
/// Create a copy of GymGameSelectState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GymGameSelectStateCopyWith<GymGameSelectState> get copyWith => _$GymGameSelectStateCopyWithImpl<GymGameSelectState>(this as GymGameSelectState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GymGameSelectState&&(identical(other.selectedMusicIndex, selectedMusicIndex) || other.selectedMusicIndex == selectedMusicIndex)&&(identical(other.isMusicPlaying, isMusicPlaying) || other.isMusicPlaying == isMusicPlaying)&&(identical(other.isVolumeOpen, isVolumeOpen) || other.isVolumeOpen == isVolumeOpen)&&(identical(other.isMusicPaused, isMusicPaused) || other.isMusicPaused == isMusicPaused)&&(identical(other.albumImageIndex, albumImageIndex) || other.albumImageIndex == albumImageIndex)&&const DeepCollectionEquality().equals(other.gamePictureList, gamePictureList)&&const DeepCollectionEquality().equals(other.gameRouteList, gameRouteList)&&const DeepCollectionEquality().equals(other.gameWebViewReadyMap, gameWebViewReadyMap));
}


@override
int get hashCode => Object.hash(runtimeType,selectedMusicIndex,isMusicPlaying,isVolumeOpen,isMusicPaused,albumImageIndex,const DeepCollectionEquality().hash(gamePictureList),const DeepCollectionEquality().hash(gameRouteList),const DeepCollectionEquality().hash(gameWebViewReadyMap));

@override
String toString() {
  return 'GymGameSelectState(selectedMusicIndex: $selectedMusicIndex, isMusicPlaying: $isMusicPlaying, isVolumeOpen: $isVolumeOpen, isMusicPaused: $isMusicPaused, albumImageIndex: $albumImageIndex, gamePictureList: $gamePictureList, gameRouteList: $gameRouteList, gameWebViewReadyMap: $gameWebViewReadyMap)';
}


}

/// @nodoc
abstract mixin class $GymGameSelectStateCopyWith<$Res>  {
  factory $GymGameSelectStateCopyWith(GymGameSelectState value, $Res Function(GymGameSelectState) _then) = _$GymGameSelectStateCopyWithImpl;
@useResult
$Res call({
 int selectedMusicIndex, bool isMusicPlaying, bool isVolumeOpen, bool isMusicPaused, int albumImageIndex, List<String> gamePictureList, List<String> gameRouteList, Map<String, bool> gameWebViewReadyMap
});




}
/// @nodoc
class _$GymGameSelectStateCopyWithImpl<$Res>
    implements $GymGameSelectStateCopyWith<$Res> {
  _$GymGameSelectStateCopyWithImpl(this._self, this._then);

  final GymGameSelectState _self;
  final $Res Function(GymGameSelectState) _then;

/// Create a copy of GymGameSelectState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedMusicIndex = null,Object? isMusicPlaying = null,Object? isVolumeOpen = null,Object? isMusicPaused = null,Object? albumImageIndex = null,Object? gamePictureList = null,Object? gameRouteList = null,Object? gameWebViewReadyMap = null,}) {
  return _then(GymGameSelectState(
selectedMusicIndex: null == selectedMusicIndex ? _self.selectedMusicIndex : selectedMusicIndex // ignore: cast_nullable_to_non_nullable
as int,isMusicPlaying: null == isMusicPlaying ? _self.isMusicPlaying : isMusicPlaying // ignore: cast_nullable_to_non_nullable
as bool,isVolumeOpen: null == isVolumeOpen ? _self.isVolumeOpen : isVolumeOpen // ignore: cast_nullable_to_non_nullable
as bool,isMusicPaused: null == isMusicPaused ? _self.isMusicPaused : isMusicPaused // ignore: cast_nullable_to_non_nullable
as bool,albumImageIndex: null == albumImageIndex ? _self.albumImageIndex : albumImageIndex // ignore: cast_nullable_to_non_nullable
as int,gamePictureList: null == gamePictureList ? _self.gamePictureList : gamePictureList // ignore: cast_nullable_to_non_nullable
as List<String>,gameRouteList: null == gameRouteList ? _self.gameRouteList : gameRouteList // ignore: cast_nullable_to_non_nullable
as List<String>,gameWebViewReadyMap: null == gameWebViewReadyMap ? _self.gameWebViewReadyMap : gameWebViewReadyMap // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}

}


/// Adds pattern-matching-related methods to [GymGameSelectState].
extension GymGameSelectStatePatterns on GymGameSelectState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GymGameSelectState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GymGameSelectState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GymGameSelectState value)  $default,){
final _that = this;
switch (_that) {
case _GymGameSelectState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GymGameSelectState value)?  $default,){
final _that = this;
switch (_that) {
case _GymGameSelectState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int selectedMusicIndex,  bool isMusicPlaying,  bool isVolumeOpen,  bool isMusicPaused,  int albumImageIndex,  List<String> gamePictureList,  List<String> gameRouteList,  Map<String, bool> gameWebViewReadyMap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GymGameSelectState() when $default != null:
return $default(_that.selectedMusicIndex,_that.isMusicPlaying,_that.isVolumeOpen,_that.isMusicPaused,_that.albumImageIndex,_that.gamePictureList,_that.gameRouteList,_that.gameWebViewReadyMap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int selectedMusicIndex,  bool isMusicPlaying,  bool isVolumeOpen,  bool isMusicPaused,  int albumImageIndex,  List<String> gamePictureList,  List<String> gameRouteList,  Map<String, bool> gameWebViewReadyMap)  $default,) {final _that = this;
switch (_that) {
case _GymGameSelectState():
return $default(_that.selectedMusicIndex,_that.isMusicPlaying,_that.isVolumeOpen,_that.isMusicPaused,_that.albumImageIndex,_that.gamePictureList,_that.gameRouteList,_that.gameWebViewReadyMap);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int selectedMusicIndex,  bool isMusicPlaying,  bool isVolumeOpen,  bool isMusicPaused,  int albumImageIndex,  List<String> gamePictureList,  List<String> gameRouteList,  Map<String, bool> gameWebViewReadyMap)?  $default,) {final _that = this;
switch (_that) {
case _GymGameSelectState() when $default != null:
return $default(_that.selectedMusicIndex,_that.isMusicPlaying,_that.isVolumeOpen,_that.isMusicPaused,_that.albumImageIndex,_that.gamePictureList,_that.gameRouteList,_that.gameWebViewReadyMap);case _:
  return null;

}
}

}

/// @nodoc


class _GymGameSelectState implements GymGameSelectState {
  const _GymGameSelectState({this.selectedMusicIndex = 0, this.isMusicPlaying = false, this.isVolumeOpen = true, this.isMusicPaused = false, this.albumImageIndex = 0,  List<String> gamePictureList = const <String>[],  List<String> gameRouteList = const <String>[],  Map<String, bool> gameWebViewReadyMap = const <String, bool>{}}): _gamePictureList = gamePictureList,_gameRouteList = gameRouteList,_gameWebViewReadyMap = gameWebViewReadyMap;
  

/// 当前选中音乐索引 0~7（对应旧 cbcs.selectIndex）。
@override@JsonKey() final  int selectedMusicIndex;
/// 音乐是否正在播放（对应旧 cbcs.isMusicPlaying）。
@override@JsonKey() final  bool isMusicPlaying;
/// 音量是否开启（对应旧 cbcs.isVolumeOpen）。
@override@JsonKey() final  bool isVolumeOpen;
/// 音乐暂停标志（对应旧 cbcs.ismusicPause，区分暂停恢复 vs 切换新歌）。
@override@JsonKey() final  bool isMusicPaused;
/// 专辑封面轮播索引 0~70（对应旧 cbcs.imageIndex）。
@override@JsonKey() final  int albumImageIndex;
/// 游戏卡片图片资源列表（对应旧 cbcs.gamePictureList）。
 final  List<String> _gamePictureList;
/// 游戏卡片图片资源列表（对应旧 cbcs.gamePictureList）。
@override@JsonKey() List<String> get gamePictureList {
  if (_gamePictureList is EqualUnmodifiableListView) return _gamePictureList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gamePictureList);
}

/// 游戏跳转路由名列表（对应旧 cbcs.gameList）。
 final  List<String> _gameRouteList;
/// 游戏跳转路由名列表（对应旧 cbcs.gameList）。
@override@JsonKey() List<String> get gameRouteList {
  if (_gameRouteList is EqualUnmodifiableListView) return _gameRouteList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gameRouteList);
}

/// 各游戏页 WebView 是否已实装（true=允许跳转 / false=Toast 阻断）。
/// key：gameRouteList 中的路由名。
/// ⚠️ 约束：任何没有 WebView URL 实装的 Placeholder 页，必须为 false。
 final  Map<String, bool> _gameWebViewReadyMap;
/// 各游戏页 WebView 是否已实装（true=允许跳转 / false=Toast 阻断）。
/// key：gameRouteList 中的路由名。
/// ⚠️ 约束：任何没有 WebView URL 实装的 Placeholder 页，必须为 false。
@override@JsonKey() Map<String, bool> get gameWebViewReadyMap {
  if (_gameWebViewReadyMap is EqualUnmodifiableMapView) return _gameWebViewReadyMap;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_gameWebViewReadyMap);
}


/// Create a copy of GymGameSelectState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GymGameSelectStateCopyWith<_GymGameSelectState> get copyWith => __$GymGameSelectStateCopyWithImpl<_GymGameSelectState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GymGameSelectState&&(identical(other.selectedMusicIndex, selectedMusicIndex) || other.selectedMusicIndex == selectedMusicIndex)&&(identical(other.isMusicPlaying, isMusicPlaying) || other.isMusicPlaying == isMusicPlaying)&&(identical(other.isVolumeOpen, isVolumeOpen) || other.isVolumeOpen == isVolumeOpen)&&(identical(other.isMusicPaused, isMusicPaused) || other.isMusicPaused == isMusicPaused)&&(identical(other.albumImageIndex, albumImageIndex) || other.albumImageIndex == albumImageIndex)&&const DeepCollectionEquality().equals(other._gamePictureList, _gamePictureList)&&const DeepCollectionEquality().equals(other._gameRouteList, _gameRouteList)&&const DeepCollectionEquality().equals(other._gameWebViewReadyMap, _gameWebViewReadyMap));
}


@override
int get hashCode => Object.hash(runtimeType,selectedMusicIndex,isMusicPlaying,isVolumeOpen,isMusicPaused,albumImageIndex,const DeepCollectionEquality().hash(_gamePictureList),const DeepCollectionEquality().hash(_gameRouteList),const DeepCollectionEquality().hash(_gameWebViewReadyMap));

@override
String toString() {
  return 'GymGameSelectState(selectedMusicIndex: $selectedMusicIndex, isMusicPlaying: $isMusicPlaying, isVolumeOpen: $isVolumeOpen, isMusicPaused: $isMusicPaused, albumImageIndex: $albumImageIndex, gamePictureList: $gamePictureList, gameRouteList: $gameRouteList, gameWebViewReadyMap: $gameWebViewReadyMap)';
}


}

/// @nodoc
abstract mixin class _$GymGameSelectStateCopyWith<$Res> implements $GymGameSelectStateCopyWith<$Res> {
  factory _$GymGameSelectStateCopyWith(_GymGameSelectState value, $Res Function(_GymGameSelectState) _then) = __$GymGameSelectStateCopyWithImpl;
@override @useResult
$Res call({
 int selectedMusicIndex, bool isMusicPlaying, bool isVolumeOpen, bool isMusicPaused, int albumImageIndex, List<String> gamePictureList, List<String> gameRouteList, Map<String, bool> gameWebViewReadyMap
});




}
/// @nodoc
class __$GymGameSelectStateCopyWithImpl<$Res>
    implements _$GymGameSelectStateCopyWith<$Res> {
  __$GymGameSelectStateCopyWithImpl(this._self, this._then);

  final _GymGameSelectState _self;
  final $Res Function(_GymGameSelectState) _then;

/// Create a copy of GymGameSelectState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedMusicIndex = null,Object? isMusicPlaying = null,Object? isVolumeOpen = null,Object? isMusicPaused = null,Object? albumImageIndex = null,Object? gamePictureList = null,Object? gameRouteList = null,Object? gameWebViewReadyMap = null,}) {
  return _then(_GymGameSelectState(
selectedMusicIndex: null == selectedMusicIndex ? _self.selectedMusicIndex : selectedMusicIndex // ignore: cast_nullable_to_non_nullable
as int,isMusicPlaying: null == isMusicPlaying ? _self.isMusicPlaying : isMusicPlaying // ignore: cast_nullable_to_non_nullable
as bool,isVolumeOpen: null == isVolumeOpen ? _self.isVolumeOpen : isVolumeOpen // ignore: cast_nullable_to_non_nullable
as bool,isMusicPaused: null == isMusicPaused ? _self.isMusicPaused : isMusicPaused // ignore: cast_nullable_to_non_nullable
as bool,albumImageIndex: null == albumImageIndex ? _self.albumImageIndex : albumImageIndex // ignore: cast_nullable_to_non_nullable
as int,gamePictureList: null == gamePictureList ? _self._gamePictureList : gamePictureList // ignore: cast_nullable_to_non_nullable
as List<String>,gameRouteList: null == gameRouteList ? _self._gameRouteList : gameRouteList // ignore: cast_nullable_to_non_nullable
as List<String>,gameWebViewReadyMap: null == gameWebViewReadyMap ? _self._gameWebViewReadyMap : gameWebViewReadyMap // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}


}

// dart format on
