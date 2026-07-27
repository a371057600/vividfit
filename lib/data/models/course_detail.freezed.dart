// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CourseDetail {

 String? get code; String? get msg; List<CourseAction>? get data;
/// Create a copy of CourseDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseDetailCopyWith<CourseDetail> get copyWith => _$CourseDetailCopyWithImpl<CourseDetail>(this as CourseDetail, _$identity);

  /// Serializes this CourseDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetail&&(identical(other.code, code) || other.code == code)&&(identical(other.msg, msg) || other.msg == msg)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,msg,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'CourseDetail(code: $code, msg: $msg, data: $data)';
}


}

/// @nodoc
abstract mixin class $CourseDetailCopyWith<$Res>  {
  factory $CourseDetailCopyWith(CourseDetail value, $Res Function(CourseDetail) _then) = _$CourseDetailCopyWithImpl;
@useResult
$Res call({
 String? code, String? msg, List<CourseAction>? data
});




}
/// @nodoc
class _$CourseDetailCopyWithImpl<$Res>
    implements $CourseDetailCopyWith<$Res> {
  _$CourseDetailCopyWithImpl(this._self, this._then);

  final CourseDetail _self;
  final $Res Function(CourseDetail) _then;

/// Create a copy of CourseDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = freezed,Object? msg = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,msg: freezed == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<CourseAction>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseDetail].
extension CourseDetailPatterns on CourseDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseDetail value)  $default,){
final _that = this;
switch (_that) {
case _CourseDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseDetail value)?  $default,){
final _that = this;
switch (_that) {
case _CourseDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? code,  String? msg,  List<CourseAction>? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseDetail() when $default != null:
return $default(_that.code,_that.msg,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? code,  String? msg,  List<CourseAction>? data)  $default,) {final _that = this;
switch (_that) {
case _CourseDetail():
return $default(_that.code,_that.msg,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? code,  String? msg,  List<CourseAction>? data)?  $default,) {final _that = this;
switch (_that) {
case _CourseDetail() when $default != null:
return $default(_that.code,_that.msg,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseDetail implements CourseDetail {
  const _CourseDetail({this.code, this.msg, final  List<CourseAction>? data}): _data = data;
  factory _CourseDetail.fromJson(Map<String, dynamic> json) => _$CourseDetailFromJson(json);

@override final  String? code;
@override final  String? msg;
 final  List<CourseAction>? _data;
@override List<CourseAction>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of CourseDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseDetailCopyWith<_CourseDetail> get copyWith => __$CourseDetailCopyWithImpl<_CourseDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseDetail&&(identical(other.code, code) || other.code == code)&&(identical(other.msg, msg) || other.msg == msg)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,msg,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'CourseDetail(code: $code, msg: $msg, data: $data)';
}


}

/// @nodoc
abstract mixin class _$CourseDetailCopyWith<$Res> implements $CourseDetailCopyWith<$Res> {
  factory _$CourseDetailCopyWith(_CourseDetail value, $Res Function(_CourseDetail) _then) = __$CourseDetailCopyWithImpl;
@override @useResult
$Res call({
 String? code, String? msg, List<CourseAction>? data
});




}
/// @nodoc
class __$CourseDetailCopyWithImpl<$Res>
    implements _$CourseDetailCopyWith<$Res> {
  __$CourseDetailCopyWithImpl(this._self, this._then);

  final _CourseDetail _self;
  final $Res Function(_CourseDetail) _then;

/// Create a copy of CourseDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? msg = freezed,Object? data = freezed,}) {
  return _then(_CourseDetail(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,msg: freezed == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<CourseAction>?,
  ));
}


}


/// @nodoc
mixin _$CourseAction {

 int? get actionId; int? get actionType; String? get video; String? get cover; String? get actionName; String? get actionVoice; String? get actionIntroduce; String? get actionIntroduceVoice; int? get targetAmount; int? get during; int? get sets; int? get speed; ActionPictures? get picturesList;
/// Create a copy of CourseAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseActionCopyWith<CourseAction> get copyWith => _$CourseActionCopyWithImpl<CourseAction>(this as CourseAction, _$identity);

  /// Serializes this CourseAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseAction&&(identical(other.actionId, actionId) || other.actionId == actionId)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.video, video) || other.video == video)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.actionName, actionName) || other.actionName == actionName)&&(identical(other.actionVoice, actionVoice) || other.actionVoice == actionVoice)&&(identical(other.actionIntroduce, actionIntroduce) || other.actionIntroduce == actionIntroduce)&&(identical(other.actionIntroduceVoice, actionIntroduceVoice) || other.actionIntroduceVoice == actionIntroduceVoice)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.during, during) || other.during == during)&&(identical(other.sets, sets) || other.sets == sets)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.picturesList, picturesList) || other.picturesList == picturesList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actionId,actionType,video,cover,actionName,actionVoice,actionIntroduce,actionIntroduceVoice,targetAmount,during,sets,speed,picturesList);

@override
String toString() {
  return 'CourseAction(actionId: $actionId, actionType: $actionType, video: $video, cover: $cover, actionName: $actionName, actionVoice: $actionVoice, actionIntroduce: $actionIntroduce, actionIntroduceVoice: $actionIntroduceVoice, targetAmount: $targetAmount, during: $during, sets: $sets, speed: $speed, picturesList: $picturesList)';
}


}

/// @nodoc
abstract mixin class $CourseActionCopyWith<$Res>  {
  factory $CourseActionCopyWith(CourseAction value, $Res Function(CourseAction) _then) = _$CourseActionCopyWithImpl;
@useResult
$Res call({
 int? actionId, int? actionType, String? video, String? cover, String? actionName, String? actionVoice, String? actionIntroduce, String? actionIntroduceVoice, int? targetAmount, int? during, int? sets, int? speed, ActionPictures? picturesList
});


$ActionPicturesCopyWith<$Res>? get picturesList;

}
/// @nodoc
class _$CourseActionCopyWithImpl<$Res>
    implements $CourseActionCopyWith<$Res> {
  _$CourseActionCopyWithImpl(this._self, this._then);

  final CourseAction _self;
  final $Res Function(CourseAction) _then;

/// Create a copy of CourseAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actionId = freezed,Object? actionType = freezed,Object? video = freezed,Object? cover = freezed,Object? actionName = freezed,Object? actionVoice = freezed,Object? actionIntroduce = freezed,Object? actionIntroduceVoice = freezed,Object? targetAmount = freezed,Object? during = freezed,Object? sets = freezed,Object? speed = freezed,Object? picturesList = freezed,}) {
  return _then(_self.copyWith(
actionId: freezed == actionId ? _self.actionId : actionId // ignore: cast_nullable_to_non_nullable
as int?,actionType: freezed == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as int?,video: freezed == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as String?,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,actionName: freezed == actionName ? _self.actionName : actionName // ignore: cast_nullable_to_non_nullable
as String?,actionVoice: freezed == actionVoice ? _self.actionVoice : actionVoice // ignore: cast_nullable_to_non_nullable
as String?,actionIntroduce: freezed == actionIntroduce ? _self.actionIntroduce : actionIntroduce // ignore: cast_nullable_to_non_nullable
as String?,actionIntroduceVoice: freezed == actionIntroduceVoice ? _self.actionIntroduceVoice : actionIntroduceVoice // ignore: cast_nullable_to_non_nullable
as String?,targetAmount: freezed == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as int?,during: freezed == during ? _self.during : during // ignore: cast_nullable_to_non_nullable
as int?,sets: freezed == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as int?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as int?,picturesList: freezed == picturesList ? _self.picturesList : picturesList // ignore: cast_nullable_to_non_nullable
as ActionPictures?,
  ));
}
/// Create a copy of CourseAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionPicturesCopyWith<$Res>? get picturesList {
    if (_self.picturesList == null) {
    return null;
  }

  return $ActionPicturesCopyWith<$Res>(_self.picturesList!, (value) {
    return _then(_self.copyWith(picturesList: value));
  });
}
}


/// Adds pattern-matching-related methods to [CourseAction].
extension CourseActionPatterns on CourseAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseAction value)  $default,){
final _that = this;
switch (_that) {
case _CourseAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseAction value)?  $default,){
final _that = this;
switch (_that) {
case _CourseAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? actionId,  int? actionType,  String? video,  String? cover,  String? actionName,  String? actionVoice,  String? actionIntroduce,  String? actionIntroduceVoice,  int? targetAmount,  int? during,  int? sets,  int? speed,  ActionPictures? picturesList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseAction() when $default != null:
return $default(_that.actionId,_that.actionType,_that.video,_that.cover,_that.actionName,_that.actionVoice,_that.actionIntroduce,_that.actionIntroduceVoice,_that.targetAmount,_that.during,_that.sets,_that.speed,_that.picturesList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? actionId,  int? actionType,  String? video,  String? cover,  String? actionName,  String? actionVoice,  String? actionIntroduce,  String? actionIntroduceVoice,  int? targetAmount,  int? during,  int? sets,  int? speed,  ActionPictures? picturesList)  $default,) {final _that = this;
switch (_that) {
case _CourseAction():
return $default(_that.actionId,_that.actionType,_that.video,_that.cover,_that.actionName,_that.actionVoice,_that.actionIntroduce,_that.actionIntroduceVoice,_that.targetAmount,_that.during,_that.sets,_that.speed,_that.picturesList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? actionId,  int? actionType,  String? video,  String? cover,  String? actionName,  String? actionVoice,  String? actionIntroduce,  String? actionIntroduceVoice,  int? targetAmount,  int? during,  int? sets,  int? speed,  ActionPictures? picturesList)?  $default,) {final _that = this;
switch (_that) {
case _CourseAction() when $default != null:
return $default(_that.actionId,_that.actionType,_that.video,_that.cover,_that.actionName,_that.actionVoice,_that.actionIntroduce,_that.actionIntroduceVoice,_that.targetAmount,_that.during,_that.sets,_that.speed,_that.picturesList);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseAction implements CourseAction {
  const _CourseAction({this.actionId, this.actionType, this.video, this.cover, this.actionName, this.actionVoice, this.actionIntroduce, this.actionIntroduceVoice, this.targetAmount, this.during, this.sets, this.speed, this.picturesList});
  factory _CourseAction.fromJson(Map<String, dynamic> json) => _$CourseActionFromJson(json);

@override final  int? actionId;
@override final  int? actionType;
@override final  String? video;
@override final  String? cover;
@override final  String? actionName;
@override final  String? actionVoice;
@override final  String? actionIntroduce;
@override final  String? actionIntroduceVoice;
@override final  int? targetAmount;
@override final  int? during;
@override final  int? sets;
@override final  int? speed;
@override final  ActionPictures? picturesList;

/// Create a copy of CourseAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseActionCopyWith<_CourseAction> get copyWith => __$CourseActionCopyWithImpl<_CourseAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseAction&&(identical(other.actionId, actionId) || other.actionId == actionId)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.video, video) || other.video == video)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.actionName, actionName) || other.actionName == actionName)&&(identical(other.actionVoice, actionVoice) || other.actionVoice == actionVoice)&&(identical(other.actionIntroduce, actionIntroduce) || other.actionIntroduce == actionIntroduce)&&(identical(other.actionIntroduceVoice, actionIntroduceVoice) || other.actionIntroduceVoice == actionIntroduceVoice)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.during, during) || other.during == during)&&(identical(other.sets, sets) || other.sets == sets)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.picturesList, picturesList) || other.picturesList == picturesList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actionId,actionType,video,cover,actionName,actionVoice,actionIntroduce,actionIntroduceVoice,targetAmount,during,sets,speed,picturesList);

@override
String toString() {
  return 'CourseAction(actionId: $actionId, actionType: $actionType, video: $video, cover: $cover, actionName: $actionName, actionVoice: $actionVoice, actionIntroduce: $actionIntroduce, actionIntroduceVoice: $actionIntroduceVoice, targetAmount: $targetAmount, during: $during, sets: $sets, speed: $speed, picturesList: $picturesList)';
}


}

/// @nodoc
abstract mixin class _$CourseActionCopyWith<$Res> implements $CourseActionCopyWith<$Res> {
  factory _$CourseActionCopyWith(_CourseAction value, $Res Function(_CourseAction) _then) = __$CourseActionCopyWithImpl;
@override @useResult
$Res call({
 int? actionId, int? actionType, String? video, String? cover, String? actionName, String? actionVoice, String? actionIntroduce, String? actionIntroduceVoice, int? targetAmount, int? during, int? sets, int? speed, ActionPictures? picturesList
});


@override $ActionPicturesCopyWith<$Res>? get picturesList;

}
/// @nodoc
class __$CourseActionCopyWithImpl<$Res>
    implements _$CourseActionCopyWith<$Res> {
  __$CourseActionCopyWithImpl(this._self, this._then);

  final _CourseAction _self;
  final $Res Function(_CourseAction) _then;

/// Create a copy of CourseAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actionId = freezed,Object? actionType = freezed,Object? video = freezed,Object? cover = freezed,Object? actionName = freezed,Object? actionVoice = freezed,Object? actionIntroduce = freezed,Object? actionIntroduceVoice = freezed,Object? targetAmount = freezed,Object? during = freezed,Object? sets = freezed,Object? speed = freezed,Object? picturesList = freezed,}) {
  return _then(_CourseAction(
actionId: freezed == actionId ? _self.actionId : actionId // ignore: cast_nullable_to_non_nullable
as int?,actionType: freezed == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as int?,video: freezed == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as String?,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,actionName: freezed == actionName ? _self.actionName : actionName // ignore: cast_nullable_to_non_nullable
as String?,actionVoice: freezed == actionVoice ? _self.actionVoice : actionVoice // ignore: cast_nullable_to_non_nullable
as String?,actionIntroduce: freezed == actionIntroduce ? _self.actionIntroduce : actionIntroduce // ignore: cast_nullable_to_non_nullable
as String?,actionIntroduceVoice: freezed == actionIntroduceVoice ? _self.actionIntroduceVoice : actionIntroduceVoice // ignore: cast_nullable_to_non_nullable
as String?,targetAmount: freezed == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as int?,during: freezed == during ? _self.during : during // ignore: cast_nullable_to_non_nullable
as int?,sets: freezed == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as int?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as int?,picturesList: freezed == picturesList ? _self.picturesList : picturesList // ignore: cast_nullable_to_non_nullable
as ActionPictures?,
  ));
}

/// Create a copy of CourseAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionPicturesCopyWith<$Res>? get picturesList {
    if (_self.picturesList == null) {
    return null;
  }

  return $ActionPicturesCopyWith<$Res>(_self.picturesList!, (value) {
    return _then(_self.copyWith(picturesList: value));
  });
}
}


/// @nodoc
mixin _$ActionPictures {

 int? get id; int? get actionId; String? get actionPictureName; String? get actionPictureHash;
/// Create a copy of ActionPictures
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionPicturesCopyWith<ActionPictures> get copyWith => _$ActionPicturesCopyWithImpl<ActionPictures>(this as ActionPictures, _$identity);

  /// Serializes this ActionPictures to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionPictures&&(identical(other.id, id) || other.id == id)&&(identical(other.actionId, actionId) || other.actionId == actionId)&&(identical(other.actionPictureName, actionPictureName) || other.actionPictureName == actionPictureName)&&(identical(other.actionPictureHash, actionPictureHash) || other.actionPictureHash == actionPictureHash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,actionId,actionPictureName,actionPictureHash);

@override
String toString() {
  return 'ActionPictures(id: $id, actionId: $actionId, actionPictureName: $actionPictureName, actionPictureHash: $actionPictureHash)';
}


}

/// @nodoc
abstract mixin class $ActionPicturesCopyWith<$Res>  {
  factory $ActionPicturesCopyWith(ActionPictures value, $Res Function(ActionPictures) _then) = _$ActionPicturesCopyWithImpl;
@useResult
$Res call({
 int? id, int? actionId, String? actionPictureName, String? actionPictureHash
});




}
/// @nodoc
class _$ActionPicturesCopyWithImpl<$Res>
    implements $ActionPicturesCopyWith<$Res> {
  _$ActionPicturesCopyWithImpl(this._self, this._then);

  final ActionPictures _self;
  final $Res Function(ActionPictures) _then;

/// Create a copy of ActionPictures
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? actionId = freezed,Object? actionPictureName = freezed,Object? actionPictureHash = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,actionId: freezed == actionId ? _self.actionId : actionId // ignore: cast_nullable_to_non_nullable
as int?,actionPictureName: freezed == actionPictureName ? _self.actionPictureName : actionPictureName // ignore: cast_nullable_to_non_nullable
as String?,actionPictureHash: freezed == actionPictureHash ? _self.actionPictureHash : actionPictureHash // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionPictures].
extension ActionPicturesPatterns on ActionPictures {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionPictures value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionPictures() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionPictures value)  $default,){
final _that = this;
switch (_that) {
case _ActionPictures():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionPictures value)?  $default,){
final _that = this;
switch (_that) {
case _ActionPictures() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? actionId,  String? actionPictureName,  String? actionPictureHash)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionPictures() when $default != null:
return $default(_that.id,_that.actionId,_that.actionPictureName,_that.actionPictureHash);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? actionId,  String? actionPictureName,  String? actionPictureHash)  $default,) {final _that = this;
switch (_that) {
case _ActionPictures():
return $default(_that.id,_that.actionId,_that.actionPictureName,_that.actionPictureHash);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? actionId,  String? actionPictureName,  String? actionPictureHash)?  $default,) {final _that = this;
switch (_that) {
case _ActionPictures() when $default != null:
return $default(_that.id,_that.actionId,_that.actionPictureName,_that.actionPictureHash);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionPictures implements ActionPictures {
  const _ActionPictures({this.id, this.actionId, this.actionPictureName, this.actionPictureHash});
  factory _ActionPictures.fromJson(Map<String, dynamic> json) => _$ActionPicturesFromJson(json);

@override final  int? id;
@override final  int? actionId;
@override final  String? actionPictureName;
@override final  String? actionPictureHash;

/// Create a copy of ActionPictures
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionPicturesCopyWith<_ActionPictures> get copyWith => __$ActionPicturesCopyWithImpl<_ActionPictures>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionPicturesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionPictures&&(identical(other.id, id) || other.id == id)&&(identical(other.actionId, actionId) || other.actionId == actionId)&&(identical(other.actionPictureName, actionPictureName) || other.actionPictureName == actionPictureName)&&(identical(other.actionPictureHash, actionPictureHash) || other.actionPictureHash == actionPictureHash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,actionId,actionPictureName,actionPictureHash);

@override
String toString() {
  return 'ActionPictures(id: $id, actionId: $actionId, actionPictureName: $actionPictureName, actionPictureHash: $actionPictureHash)';
}


}

/// @nodoc
abstract mixin class _$ActionPicturesCopyWith<$Res> implements $ActionPicturesCopyWith<$Res> {
  factory _$ActionPicturesCopyWith(_ActionPictures value, $Res Function(_ActionPictures) _then) = __$ActionPicturesCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? actionId, String? actionPictureName, String? actionPictureHash
});




}
/// @nodoc
class __$ActionPicturesCopyWithImpl<$Res>
    implements _$ActionPicturesCopyWith<$Res> {
  __$ActionPicturesCopyWithImpl(this._self, this._then);

  final _ActionPictures _self;
  final $Res Function(_ActionPictures) _then;

/// Create a copy of ActionPictures
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? actionId = freezed,Object? actionPictureName = freezed,Object? actionPictureHash = freezed,}) {
  return _then(_ActionPictures(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,actionId: freezed == actionId ? _self.actionId : actionId // ignore: cast_nullable_to_non_nullable
as int?,actionPictureName: freezed == actionPictureName ? _self.actionPictureName : actionPictureName // ignore: cast_nullable_to_non_nullable
as String?,actionPictureHash: freezed == actionPictureHash ? _self.actionPictureHash : actionPictureHash // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
