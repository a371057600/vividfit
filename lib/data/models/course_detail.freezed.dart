// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CourseDetail _$CourseDetailFromJson(Map<String, dynamic> json) {
  return _CourseDetail.fromJson(json);
}

/// @nodoc
mixin _$CourseDetail {
  String? get code => throw _privateConstructorUsedError;
  String? get msg => throw _privateConstructorUsedError;
  List<CourseAction>? get data => throw _privateConstructorUsedError;

  /// Serializes this CourseDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseDetailCopyWith<CourseDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseDetailCopyWith<$Res> {
  factory $CourseDetailCopyWith(
    CourseDetail value,
    $Res Function(CourseDetail) then,
  ) = _$CourseDetailCopyWithImpl<$Res, CourseDetail>;
  @useResult
  $Res call({String? code, String? msg, List<CourseAction>? data});
}

/// @nodoc
class _$CourseDetailCopyWithImpl<$Res, $Val extends CourseDetail>
    implements $CourseDetailCopyWith<$Res> {
  _$CourseDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? msg = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _value.copyWith(
            code:
                freezed == code
                    ? _value.code
                    : code // ignore: cast_nullable_to_non_nullable
                        as String?,
            msg:
                freezed == msg
                    ? _value.msg
                    : msg // ignore: cast_nullable_to_non_nullable
                        as String?,
            data:
                freezed == data
                    ? _value.data
                    : data // ignore: cast_nullable_to_non_nullable
                        as List<CourseAction>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourseDetailImplCopyWith<$Res>
    implements $CourseDetailCopyWith<$Res> {
  factory _$$CourseDetailImplCopyWith(
    _$CourseDetailImpl value,
    $Res Function(_$CourseDetailImpl) then,
  ) = __$$CourseDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? code, String? msg, List<CourseAction>? data});
}

/// @nodoc
class __$$CourseDetailImplCopyWithImpl<$Res>
    extends _$CourseDetailCopyWithImpl<$Res, _$CourseDetailImpl>
    implements _$$CourseDetailImplCopyWith<$Res> {
  __$$CourseDetailImplCopyWithImpl(
    _$CourseDetailImpl _value,
    $Res Function(_$CourseDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? msg = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _$CourseDetailImpl(
        code:
            freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                    as String?,
        msg:
            freezed == msg
                ? _value.msg
                : msg // ignore: cast_nullable_to_non_nullable
                    as String?,
        data:
            freezed == data
                ? _value._data
                : data // ignore: cast_nullable_to_non_nullable
                    as List<CourseAction>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseDetailImpl implements _CourseDetail {
  const _$CourseDetailImpl({
    this.code,
    this.msg,
    final List<CourseAction>? data,
  }) : _data = data;

  factory _$CourseDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseDetailImplFromJson(json);

  @override
  final String? code;
  @override
  final String? msg;
  final List<CourseAction>? _data;
  @override
  List<CourseAction>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CourseDetail(code: $code, msg: $msg, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseDetailImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.msg, msg) || other.msg == msg) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    code,
    msg,
    const DeepCollectionEquality().hash(_data),
  );

  /// Create a copy of CourseDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseDetailImplCopyWith<_$CourseDetailImpl> get copyWith =>
      __$$CourseDetailImplCopyWithImpl<_$CourseDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseDetailImplToJson(this);
  }
}

abstract class _CourseDetail implements CourseDetail {
  const factory _CourseDetail({
    final String? code,
    final String? msg,
    final List<CourseAction>? data,
  }) = _$CourseDetailImpl;

  factory _CourseDetail.fromJson(Map<String, dynamic> json) =
      _$CourseDetailImpl.fromJson;

  @override
  String? get code;
  @override
  String? get msg;
  @override
  List<CourseAction>? get data;

  /// Create a copy of CourseDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseDetailImplCopyWith<_$CourseDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CourseAction _$CourseActionFromJson(Map<String, dynamic> json) {
  return _CourseAction.fromJson(json);
}

/// @nodoc
mixin _$CourseAction {
  int? get actionId => throw _privateConstructorUsedError;
  int? get actionType => throw _privateConstructorUsedError;
  String? get video => throw _privateConstructorUsedError;
  String? get cover => throw _privateConstructorUsedError;
  String? get actionName => throw _privateConstructorUsedError;
  String? get actionVoice => throw _privateConstructorUsedError;
  String? get actionIntroduce => throw _privateConstructorUsedError;
  String? get actionIntroduceVoice => throw _privateConstructorUsedError;
  int? get targetAmount => throw _privateConstructorUsedError;
  int? get during => throw _privateConstructorUsedError;
  int? get sets => throw _privateConstructorUsedError;
  int? get speed => throw _privateConstructorUsedError;
  ActionPictures? get picturesList => throw _privateConstructorUsedError;

  /// Serializes this CourseAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseActionCopyWith<CourseAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseActionCopyWith<$Res> {
  factory $CourseActionCopyWith(
    CourseAction value,
    $Res Function(CourseAction) then,
  ) = _$CourseActionCopyWithImpl<$Res, CourseAction>;
  @useResult
  $Res call({
    int? actionId,
    int? actionType,
    String? video,
    String? cover,
    String? actionName,
    String? actionVoice,
    String? actionIntroduce,
    String? actionIntroduceVoice,
    int? targetAmount,
    int? during,
    int? sets,
    int? speed,
    ActionPictures? picturesList,
  });

  $ActionPicturesCopyWith<$Res>? get picturesList;
}

/// @nodoc
class _$CourseActionCopyWithImpl<$Res, $Val extends CourseAction>
    implements $CourseActionCopyWith<$Res> {
  _$CourseActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actionId = freezed,
    Object? actionType = freezed,
    Object? video = freezed,
    Object? cover = freezed,
    Object? actionName = freezed,
    Object? actionVoice = freezed,
    Object? actionIntroduce = freezed,
    Object? actionIntroduceVoice = freezed,
    Object? targetAmount = freezed,
    Object? during = freezed,
    Object? sets = freezed,
    Object? speed = freezed,
    Object? picturesList = freezed,
  }) {
    return _then(
      _value.copyWith(
            actionId:
                freezed == actionId
                    ? _value.actionId
                    : actionId // ignore: cast_nullable_to_non_nullable
                        as int?,
            actionType:
                freezed == actionType
                    ? _value.actionType
                    : actionType // ignore: cast_nullable_to_non_nullable
                        as int?,
            video:
                freezed == video
                    ? _value.video
                    : video // ignore: cast_nullable_to_non_nullable
                        as String?,
            cover:
                freezed == cover
                    ? _value.cover
                    : cover // ignore: cast_nullable_to_non_nullable
                        as String?,
            actionName:
                freezed == actionName
                    ? _value.actionName
                    : actionName // ignore: cast_nullable_to_non_nullable
                        as String?,
            actionVoice:
                freezed == actionVoice
                    ? _value.actionVoice
                    : actionVoice // ignore: cast_nullable_to_non_nullable
                        as String?,
            actionIntroduce:
                freezed == actionIntroduce
                    ? _value.actionIntroduce
                    : actionIntroduce // ignore: cast_nullable_to_non_nullable
                        as String?,
            actionIntroduceVoice:
                freezed == actionIntroduceVoice
                    ? _value.actionIntroduceVoice
                    : actionIntroduceVoice // ignore: cast_nullable_to_non_nullable
                        as String?,
            targetAmount:
                freezed == targetAmount
                    ? _value.targetAmount
                    : targetAmount // ignore: cast_nullable_to_non_nullable
                        as int?,
            during:
                freezed == during
                    ? _value.during
                    : during // ignore: cast_nullable_to_non_nullable
                        as int?,
            sets:
                freezed == sets
                    ? _value.sets
                    : sets // ignore: cast_nullable_to_non_nullable
                        as int?,
            speed:
                freezed == speed
                    ? _value.speed
                    : speed // ignore: cast_nullable_to_non_nullable
                        as int?,
            picturesList:
                freezed == picturesList
                    ? _value.picturesList
                    : picturesList // ignore: cast_nullable_to_non_nullable
                        as ActionPictures?,
          )
          as $Val,
    );
  }

  /// Create a copy of CourseAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActionPicturesCopyWith<$Res>? get picturesList {
    if (_value.picturesList == null) {
      return null;
    }

    return $ActionPicturesCopyWith<$Res>(_value.picturesList!, (value) {
      return _then(_value.copyWith(picturesList: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CourseActionImplCopyWith<$Res>
    implements $CourseActionCopyWith<$Res> {
  factory _$$CourseActionImplCopyWith(
    _$CourseActionImpl value,
    $Res Function(_$CourseActionImpl) then,
  ) = __$$CourseActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? actionId,
    int? actionType,
    String? video,
    String? cover,
    String? actionName,
    String? actionVoice,
    String? actionIntroduce,
    String? actionIntroduceVoice,
    int? targetAmount,
    int? during,
    int? sets,
    int? speed,
    ActionPictures? picturesList,
  });

  @override
  $ActionPicturesCopyWith<$Res>? get picturesList;
}

/// @nodoc
class __$$CourseActionImplCopyWithImpl<$Res>
    extends _$CourseActionCopyWithImpl<$Res, _$CourseActionImpl>
    implements _$$CourseActionImplCopyWith<$Res> {
  __$$CourseActionImplCopyWithImpl(
    _$CourseActionImpl _value,
    $Res Function(_$CourseActionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actionId = freezed,
    Object? actionType = freezed,
    Object? video = freezed,
    Object? cover = freezed,
    Object? actionName = freezed,
    Object? actionVoice = freezed,
    Object? actionIntroduce = freezed,
    Object? actionIntroduceVoice = freezed,
    Object? targetAmount = freezed,
    Object? during = freezed,
    Object? sets = freezed,
    Object? speed = freezed,
    Object? picturesList = freezed,
  }) {
    return _then(
      _$CourseActionImpl(
        actionId:
            freezed == actionId
                ? _value.actionId
                : actionId // ignore: cast_nullable_to_non_nullable
                    as int?,
        actionType:
            freezed == actionType
                ? _value.actionType
                : actionType // ignore: cast_nullable_to_non_nullable
                    as int?,
        video:
            freezed == video
                ? _value.video
                : video // ignore: cast_nullable_to_non_nullable
                    as String?,
        cover:
            freezed == cover
                ? _value.cover
                : cover // ignore: cast_nullable_to_non_nullable
                    as String?,
        actionName:
            freezed == actionName
                ? _value.actionName
                : actionName // ignore: cast_nullable_to_non_nullable
                    as String?,
        actionVoice:
            freezed == actionVoice
                ? _value.actionVoice
                : actionVoice // ignore: cast_nullable_to_non_nullable
                    as String?,
        actionIntroduce:
            freezed == actionIntroduce
                ? _value.actionIntroduce
                : actionIntroduce // ignore: cast_nullable_to_non_nullable
                    as String?,
        actionIntroduceVoice:
            freezed == actionIntroduceVoice
                ? _value.actionIntroduceVoice
                : actionIntroduceVoice // ignore: cast_nullable_to_non_nullable
                    as String?,
        targetAmount:
            freezed == targetAmount
                ? _value.targetAmount
                : targetAmount // ignore: cast_nullable_to_non_nullable
                    as int?,
        during:
            freezed == during
                ? _value.during
                : during // ignore: cast_nullable_to_non_nullable
                    as int?,
        sets:
            freezed == sets
                ? _value.sets
                : sets // ignore: cast_nullable_to_non_nullable
                    as int?,
        speed:
            freezed == speed
                ? _value.speed
                : speed // ignore: cast_nullable_to_non_nullable
                    as int?,
        picturesList:
            freezed == picturesList
                ? _value.picturesList
                : picturesList // ignore: cast_nullable_to_non_nullable
                    as ActionPictures?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseActionImpl implements _CourseAction {
  const _$CourseActionImpl({
    this.actionId,
    this.actionType,
    this.video,
    this.cover,
    this.actionName,
    this.actionVoice,
    this.actionIntroduce,
    this.actionIntroduceVoice,
    this.targetAmount,
    this.during,
    this.sets,
    this.speed,
    this.picturesList,
  });

  factory _$CourseActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseActionImplFromJson(json);

  @override
  final int? actionId;
  @override
  final int? actionType;
  @override
  final String? video;
  @override
  final String? cover;
  @override
  final String? actionName;
  @override
  final String? actionVoice;
  @override
  final String? actionIntroduce;
  @override
  final String? actionIntroduceVoice;
  @override
  final int? targetAmount;
  @override
  final int? during;
  @override
  final int? sets;
  @override
  final int? speed;
  @override
  final ActionPictures? picturesList;

  @override
  String toString() {
    return 'CourseAction(actionId: $actionId, actionType: $actionType, video: $video, cover: $cover, actionName: $actionName, actionVoice: $actionVoice, actionIntroduce: $actionIntroduce, actionIntroduceVoice: $actionIntroduceVoice, targetAmount: $targetAmount, during: $during, sets: $sets, speed: $speed, picturesList: $picturesList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseActionImpl &&
            (identical(other.actionId, actionId) ||
                other.actionId == actionId) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.video, video) || other.video == video) &&
            (identical(other.cover, cover) || other.cover == cover) &&
            (identical(other.actionName, actionName) ||
                other.actionName == actionName) &&
            (identical(other.actionVoice, actionVoice) ||
                other.actionVoice == actionVoice) &&
            (identical(other.actionIntroduce, actionIntroduce) ||
                other.actionIntroduce == actionIntroduce) &&
            (identical(other.actionIntroduceVoice, actionIntroduceVoice) ||
                other.actionIntroduceVoice == actionIntroduceVoice) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.during, during) || other.during == during) &&
            (identical(other.sets, sets) || other.sets == sets) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.picturesList, picturesList) ||
                other.picturesList == picturesList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    actionId,
    actionType,
    video,
    cover,
    actionName,
    actionVoice,
    actionIntroduce,
    actionIntroduceVoice,
    targetAmount,
    during,
    sets,
    speed,
    picturesList,
  );

  /// Create a copy of CourseAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseActionImplCopyWith<_$CourseActionImpl> get copyWith =>
      __$$CourseActionImplCopyWithImpl<_$CourseActionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseActionImplToJson(this);
  }
}

abstract class _CourseAction implements CourseAction {
  const factory _CourseAction({
    final int? actionId,
    final int? actionType,
    final String? video,
    final String? cover,
    final String? actionName,
    final String? actionVoice,
    final String? actionIntroduce,
    final String? actionIntroduceVoice,
    final int? targetAmount,
    final int? during,
    final int? sets,
    final int? speed,
    final ActionPictures? picturesList,
  }) = _$CourseActionImpl;

  factory _CourseAction.fromJson(Map<String, dynamic> json) =
      _$CourseActionImpl.fromJson;

  @override
  int? get actionId;
  @override
  int? get actionType;
  @override
  String? get video;
  @override
  String? get cover;
  @override
  String? get actionName;
  @override
  String? get actionVoice;
  @override
  String? get actionIntroduce;
  @override
  String? get actionIntroduceVoice;
  @override
  int? get targetAmount;
  @override
  int? get during;
  @override
  int? get sets;
  @override
  int? get speed;
  @override
  ActionPictures? get picturesList;

  /// Create a copy of CourseAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseActionImplCopyWith<_$CourseActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActionPictures _$ActionPicturesFromJson(Map<String, dynamic> json) {
  return _ActionPictures.fromJson(json);
}

/// @nodoc
mixin _$ActionPictures {
  int? get id => throw _privateConstructorUsedError;
  int? get actionId => throw _privateConstructorUsedError;
  String? get actionPictureName => throw _privateConstructorUsedError;
  String? get actionPictureHash => throw _privateConstructorUsedError;

  /// Serializes this ActionPictures to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActionPictures
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActionPicturesCopyWith<ActionPictures> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionPicturesCopyWith<$Res> {
  factory $ActionPicturesCopyWith(
    ActionPictures value,
    $Res Function(ActionPictures) then,
  ) = _$ActionPicturesCopyWithImpl<$Res, ActionPictures>;
  @useResult
  $Res call({
    int? id,
    int? actionId,
    String? actionPictureName,
    String? actionPictureHash,
  });
}

/// @nodoc
class _$ActionPicturesCopyWithImpl<$Res, $Val extends ActionPictures>
    implements $ActionPicturesCopyWith<$Res> {
  _$ActionPicturesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActionPictures
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? actionId = freezed,
    Object? actionPictureName = freezed,
    Object? actionPictureHash = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int?,
            actionId:
                freezed == actionId
                    ? _value.actionId
                    : actionId // ignore: cast_nullable_to_non_nullable
                        as int?,
            actionPictureName:
                freezed == actionPictureName
                    ? _value.actionPictureName
                    : actionPictureName // ignore: cast_nullable_to_non_nullable
                        as String?,
            actionPictureHash:
                freezed == actionPictureHash
                    ? _value.actionPictureHash
                    : actionPictureHash // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActionPicturesImplCopyWith<$Res>
    implements $ActionPicturesCopyWith<$Res> {
  factory _$$ActionPicturesImplCopyWith(
    _$ActionPicturesImpl value,
    $Res Function(_$ActionPicturesImpl) then,
  ) = __$$ActionPicturesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    int? actionId,
    String? actionPictureName,
    String? actionPictureHash,
  });
}

/// @nodoc
class __$$ActionPicturesImplCopyWithImpl<$Res>
    extends _$ActionPicturesCopyWithImpl<$Res, _$ActionPicturesImpl>
    implements _$$ActionPicturesImplCopyWith<$Res> {
  __$$ActionPicturesImplCopyWithImpl(
    _$ActionPicturesImpl _value,
    $Res Function(_$ActionPicturesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActionPictures
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? actionId = freezed,
    Object? actionPictureName = freezed,
    Object? actionPictureHash = freezed,
  }) {
    return _then(
      _$ActionPicturesImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int?,
        actionId:
            freezed == actionId
                ? _value.actionId
                : actionId // ignore: cast_nullable_to_non_nullable
                    as int?,
        actionPictureName:
            freezed == actionPictureName
                ? _value.actionPictureName
                : actionPictureName // ignore: cast_nullable_to_non_nullable
                    as String?,
        actionPictureHash:
            freezed == actionPictureHash
                ? _value.actionPictureHash
                : actionPictureHash // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActionPicturesImpl implements _ActionPictures {
  const _$ActionPicturesImpl({
    this.id,
    this.actionId,
    this.actionPictureName,
    this.actionPictureHash,
  });

  factory _$ActionPicturesImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionPicturesImplFromJson(json);

  @override
  final int? id;
  @override
  final int? actionId;
  @override
  final String? actionPictureName;
  @override
  final String? actionPictureHash;

  @override
  String toString() {
    return 'ActionPictures(id: $id, actionId: $actionId, actionPictureName: $actionPictureName, actionPictureHash: $actionPictureHash)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionPicturesImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actionId, actionId) ||
                other.actionId == actionId) &&
            (identical(other.actionPictureName, actionPictureName) ||
                other.actionPictureName == actionPictureName) &&
            (identical(other.actionPictureHash, actionPictureHash) ||
                other.actionPictureHash == actionPictureHash));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    actionId,
    actionPictureName,
    actionPictureHash,
  );

  /// Create a copy of ActionPictures
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionPicturesImplCopyWith<_$ActionPicturesImpl> get copyWith =>
      __$$ActionPicturesImplCopyWithImpl<_$ActionPicturesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionPicturesImplToJson(this);
  }
}

abstract class _ActionPictures implements ActionPictures {
  const factory _ActionPictures({
    final int? id,
    final int? actionId,
    final String? actionPictureName,
    final String? actionPictureHash,
  }) = _$ActionPicturesImpl;

  factory _ActionPictures.fromJson(Map<String, dynamic> json) =
      _$ActionPicturesImpl.fromJson;

  @override
  int? get id;
  @override
  int? get actionId;
  @override
  String? get actionPictureName;
  @override
  String? get actionPictureHash;

  /// Create a copy of ActionPictures
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActionPicturesImplCopyWith<_$ActionPicturesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
