// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CourseList _$CourseListFromJson(Map<String, dynamic> json) {
  return _CourseList.fromJson(json);
}

/// @nodoc
mixin _$CourseList {
  String? get code => throw _privateConstructorUsedError;
  CourseListData? get data => throw _privateConstructorUsedError;

  /// Serializes this CourseList to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseListCopyWith<CourseList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseListCopyWith<$Res> {
  factory $CourseListCopyWith(
    CourseList value,
    $Res Function(CourseList) then,
  ) = _$CourseListCopyWithImpl<$Res, CourseList>;
  @useResult
  $Res call({String? code, CourseListData? data});

  $CourseListDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$CourseListCopyWithImpl<$Res, $Val extends CourseList>
    implements $CourseListCopyWith<$Res> {
  _$CourseListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = freezed, Object? data = freezed}) {
    return _then(
      _value.copyWith(
            code:
                freezed == code
                    ? _value.code
                    : code // ignore: cast_nullable_to_non_nullable
                        as String?,
            data:
                freezed == data
                    ? _value.data
                    : data // ignore: cast_nullable_to_non_nullable
                        as CourseListData?,
          )
          as $Val,
    );
  }

  /// Create a copy of CourseList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CourseListDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $CourseListDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CourseListImplCopyWith<$Res>
    implements $CourseListCopyWith<$Res> {
  factory _$$CourseListImplCopyWith(
    _$CourseListImpl value,
    $Res Function(_$CourseListImpl) then,
  ) = __$$CourseListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? code, CourseListData? data});

  @override
  $CourseListDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$CourseListImplCopyWithImpl<$Res>
    extends _$CourseListCopyWithImpl<$Res, _$CourseListImpl>
    implements _$$CourseListImplCopyWith<$Res> {
  __$$CourseListImplCopyWithImpl(
    _$CourseListImpl _value,
    $Res Function(_$CourseListImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = freezed, Object? data = freezed}) {
    return _then(
      _$CourseListImpl(
        code:
            freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                    as String?,
        data:
            freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                    as CourseListData?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseListImpl implements _CourseList {
  const _$CourseListImpl({this.code, this.data});

  factory _$CourseListImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseListImplFromJson(json);

  @override
  final String? code;
  @override
  final CourseListData? data;

  @override
  String toString() {
    return 'CourseList(code: $code, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseListImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, data);

  /// Create a copy of CourseList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseListImplCopyWith<_$CourseListImpl> get copyWith =>
      __$$CourseListImplCopyWithImpl<_$CourseListImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseListImplToJson(this);
  }
}

abstract class _CourseList implements CourseList {
  const factory _CourseList({final String? code, final CourseListData? data}) =
      _$CourseListImpl;

  factory _CourseList.fromJson(Map<String, dynamic> json) =
      _$CourseListImpl.fromJson;

  @override
  String? get code;
  @override
  CourseListData? get data;

  /// Create a copy of CourseList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseListImplCopyWith<_$CourseListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CourseListData _$CourseListDataFromJson(Map<String, dynamic> json) {
  return _CourseListData.fromJson(json);
}

/// @nodoc
mixin _$CourseListData {
  List<CourseItem>? get dataList => throw _privateConstructorUsedError;
  int? get currentPageNum => throw _privateConstructorUsedError;
  int? get totalElements => throw _privateConstructorUsedError;
  int? get totalPages => throw _privateConstructorUsedError;

  /// Serializes this CourseListData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseListData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseListDataCopyWith<CourseListData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseListDataCopyWith<$Res> {
  factory $CourseListDataCopyWith(
    CourseListData value,
    $Res Function(CourseListData) then,
  ) = _$CourseListDataCopyWithImpl<$Res, CourseListData>;
  @useResult
  $Res call({
    List<CourseItem>? dataList,
    int? currentPageNum,
    int? totalElements,
    int? totalPages,
  });
}

/// @nodoc
class _$CourseListDataCopyWithImpl<$Res, $Val extends CourseListData>
    implements $CourseListDataCopyWith<$Res> {
  _$CourseListDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseListData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataList = freezed,
    Object? currentPageNum = freezed,
    Object? totalElements = freezed,
    Object? totalPages = freezed,
  }) {
    return _then(
      _value.copyWith(
            dataList:
                freezed == dataList
                    ? _value.dataList
                    : dataList // ignore: cast_nullable_to_non_nullable
                        as List<CourseItem>?,
            currentPageNum:
                freezed == currentPageNum
                    ? _value.currentPageNum
                    : currentPageNum // ignore: cast_nullable_to_non_nullable
                        as int?,
            totalElements:
                freezed == totalElements
                    ? _value.totalElements
                    : totalElements // ignore: cast_nullable_to_non_nullable
                        as int?,
            totalPages:
                freezed == totalPages
                    ? _value.totalPages
                    : totalPages // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourseListDataImplCopyWith<$Res>
    implements $CourseListDataCopyWith<$Res> {
  factory _$$CourseListDataImplCopyWith(
    _$CourseListDataImpl value,
    $Res Function(_$CourseListDataImpl) then,
  ) = __$$CourseListDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<CourseItem>? dataList,
    int? currentPageNum,
    int? totalElements,
    int? totalPages,
  });
}

/// @nodoc
class __$$CourseListDataImplCopyWithImpl<$Res>
    extends _$CourseListDataCopyWithImpl<$Res, _$CourseListDataImpl>
    implements _$$CourseListDataImplCopyWith<$Res> {
  __$$CourseListDataImplCopyWithImpl(
    _$CourseListDataImpl _value,
    $Res Function(_$CourseListDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseListData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataList = freezed,
    Object? currentPageNum = freezed,
    Object? totalElements = freezed,
    Object? totalPages = freezed,
  }) {
    return _then(
      _$CourseListDataImpl(
        dataList:
            freezed == dataList
                ? _value._dataList
                : dataList // ignore: cast_nullable_to_non_nullable
                    as List<CourseItem>?,
        currentPageNum:
            freezed == currentPageNum
                ? _value.currentPageNum
                : currentPageNum // ignore: cast_nullable_to_non_nullable
                    as int?,
        totalElements:
            freezed == totalElements
                ? _value.totalElements
                : totalElements // ignore: cast_nullable_to_non_nullable
                    as int?,
        totalPages:
            freezed == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseListDataImpl implements _CourseListData {
  const _$CourseListDataImpl({
    final List<CourseItem>? dataList,
    this.currentPageNum,
    this.totalElements,
    this.totalPages,
  }) : _dataList = dataList;

  factory _$CourseListDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseListDataImplFromJson(json);

  final List<CourseItem>? _dataList;
  @override
  List<CourseItem>? get dataList {
    final value = _dataList;
    if (value == null) return null;
    if (_dataList is EqualUnmodifiableListView) return _dataList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? currentPageNum;
  @override
  final int? totalElements;
  @override
  final int? totalPages;

  @override
  String toString() {
    return 'CourseListData(dataList: $dataList, currentPageNum: $currentPageNum, totalElements: $totalElements, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseListDataImpl &&
            const DeepCollectionEquality().equals(other._dataList, _dataList) &&
            (identical(other.currentPageNum, currentPageNum) ||
                other.currentPageNum == currentPageNum) &&
            (identical(other.totalElements, totalElements) ||
                other.totalElements == totalElements) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_dataList),
    currentPageNum,
    totalElements,
    totalPages,
  );

  /// Create a copy of CourseListData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseListDataImplCopyWith<_$CourseListDataImpl> get copyWith =>
      __$$CourseListDataImplCopyWithImpl<_$CourseListDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseListDataImplToJson(this);
  }
}

abstract class _CourseListData implements CourseListData {
  const factory _CourseListData({
    final List<CourseItem>? dataList,
    final int? currentPageNum,
    final int? totalElements,
    final int? totalPages,
  }) = _$CourseListDataImpl;

  factory _CourseListData.fromJson(Map<String, dynamic> json) =
      _$CourseListDataImpl.fromJson;

  @override
  List<CourseItem>? get dataList;
  @override
  int? get currentPageNum;
  @override
  int? get totalElements;
  @override
  int? get totalPages;

  /// Create a copy of CourseListData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseListDataImplCopyWith<_$CourseListDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CourseItem _$CourseItemFromJson(Map<String, dynamic> json) {
  return _CourseItem.fromJson(json);
}

/// @nodoc
mixin _$CourseItem {
  int? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get cover => throw _privateConstructorUsedError;
  String? get describe => throw _privateConstructorUsedError;
  String? get proposal => throw _privateConstructorUsedError;
  String? get people => throw _privateConstructorUsedError;
  String? get carefulthing => throw _privateConstructorUsedError;
  int? get expectCalorie => throw _privateConstructorUsedError;
  int? get during => throw _privateConstructorUsedError;
  int? get level => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  int? get interactiveEquipment => throw _privateConstructorUsedError;
  String? get createTime => throw _privateConstructorUsedError;
  String? get courseBgm => throw _privateConstructorUsedError;
  int? get version => throw _privateConstructorUsedError;
  bool? get timing => throw _privateConstructorUsedError;
  bool? get collect => throw _privateConstructorUsedError;

  /// Serializes this CourseItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseItemCopyWith<CourseItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseItemCopyWith<$Res> {
  factory $CourseItemCopyWith(
    CourseItem value,
    $Res Function(CourseItem) then,
  ) = _$CourseItemCopyWithImpl<$Res, CourseItem>;
  @useResult
  $Res call({
    int? id,
    String? title,
    String? cover,
    String? describe,
    String? proposal,
    String? people,
    String? carefulthing,
    int? expectCalorie,
    int? during,
    int? level,
    List<String>? tags,
    int? interactiveEquipment,
    String? createTime,
    String? courseBgm,
    int? version,
    bool? timing,
    bool? collect,
  });
}

/// @nodoc
class _$CourseItemCopyWithImpl<$Res, $Val extends CourseItem>
    implements $CourseItemCopyWith<$Res> {
  _$CourseItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? cover = freezed,
    Object? describe = freezed,
    Object? proposal = freezed,
    Object? people = freezed,
    Object? carefulthing = freezed,
    Object? expectCalorie = freezed,
    Object? during = freezed,
    Object? level = freezed,
    Object? tags = freezed,
    Object? interactiveEquipment = freezed,
    Object? createTime = freezed,
    Object? courseBgm = freezed,
    Object? version = freezed,
    Object? timing = freezed,
    Object? collect = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int?,
            title:
                freezed == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String?,
            cover:
                freezed == cover
                    ? _value.cover
                    : cover // ignore: cast_nullable_to_non_nullable
                        as String?,
            describe:
                freezed == describe
                    ? _value.describe
                    : describe // ignore: cast_nullable_to_non_nullable
                        as String?,
            proposal:
                freezed == proposal
                    ? _value.proposal
                    : proposal // ignore: cast_nullable_to_non_nullable
                        as String?,
            people:
                freezed == people
                    ? _value.people
                    : people // ignore: cast_nullable_to_non_nullable
                        as String?,
            carefulthing:
                freezed == carefulthing
                    ? _value.carefulthing
                    : carefulthing // ignore: cast_nullable_to_non_nullable
                        as String?,
            expectCalorie:
                freezed == expectCalorie
                    ? _value.expectCalorie
                    : expectCalorie // ignore: cast_nullable_to_non_nullable
                        as int?,
            during:
                freezed == during
                    ? _value.during
                    : during // ignore: cast_nullable_to_non_nullable
                        as int?,
            level:
                freezed == level
                    ? _value.level
                    : level // ignore: cast_nullable_to_non_nullable
                        as int?,
            tags:
                freezed == tags
                    ? _value.tags
                    : tags // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            interactiveEquipment:
                freezed == interactiveEquipment
                    ? _value.interactiveEquipment
                    : interactiveEquipment // ignore: cast_nullable_to_non_nullable
                        as int?,
            createTime:
                freezed == createTime
                    ? _value.createTime
                    : createTime // ignore: cast_nullable_to_non_nullable
                        as String?,
            courseBgm:
                freezed == courseBgm
                    ? _value.courseBgm
                    : courseBgm // ignore: cast_nullable_to_non_nullable
                        as String?,
            version:
                freezed == version
                    ? _value.version
                    : version // ignore: cast_nullable_to_non_nullable
                        as int?,
            timing:
                freezed == timing
                    ? _value.timing
                    : timing // ignore: cast_nullable_to_non_nullable
                        as bool?,
            collect:
                freezed == collect
                    ? _value.collect
                    : collect // ignore: cast_nullable_to_non_nullable
                        as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourseItemImplCopyWith<$Res>
    implements $CourseItemCopyWith<$Res> {
  factory _$$CourseItemImplCopyWith(
    _$CourseItemImpl value,
    $Res Function(_$CourseItemImpl) then,
  ) = __$$CourseItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String? title,
    String? cover,
    String? describe,
    String? proposal,
    String? people,
    String? carefulthing,
    int? expectCalorie,
    int? during,
    int? level,
    List<String>? tags,
    int? interactiveEquipment,
    String? createTime,
    String? courseBgm,
    int? version,
    bool? timing,
    bool? collect,
  });
}

/// @nodoc
class __$$CourseItemImplCopyWithImpl<$Res>
    extends _$CourseItemCopyWithImpl<$Res, _$CourseItemImpl>
    implements _$$CourseItemImplCopyWith<$Res> {
  __$$CourseItemImplCopyWithImpl(
    _$CourseItemImpl _value,
    $Res Function(_$CourseItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? cover = freezed,
    Object? describe = freezed,
    Object? proposal = freezed,
    Object? people = freezed,
    Object? carefulthing = freezed,
    Object? expectCalorie = freezed,
    Object? during = freezed,
    Object? level = freezed,
    Object? tags = freezed,
    Object? interactiveEquipment = freezed,
    Object? createTime = freezed,
    Object? courseBgm = freezed,
    Object? version = freezed,
    Object? timing = freezed,
    Object? collect = freezed,
  }) {
    return _then(
      _$CourseItemImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int?,
        title:
            freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String?,
        cover:
            freezed == cover
                ? _value.cover
                : cover // ignore: cast_nullable_to_non_nullable
                    as String?,
        describe:
            freezed == describe
                ? _value.describe
                : describe // ignore: cast_nullable_to_non_nullable
                    as String?,
        proposal:
            freezed == proposal
                ? _value.proposal
                : proposal // ignore: cast_nullable_to_non_nullable
                    as String?,
        people:
            freezed == people
                ? _value.people
                : people // ignore: cast_nullable_to_non_nullable
                    as String?,
        carefulthing:
            freezed == carefulthing
                ? _value.carefulthing
                : carefulthing // ignore: cast_nullable_to_non_nullable
                    as String?,
        expectCalorie:
            freezed == expectCalorie
                ? _value.expectCalorie
                : expectCalorie // ignore: cast_nullable_to_non_nullable
                    as int?,
        during:
            freezed == during
                ? _value.during
                : during // ignore: cast_nullable_to_non_nullable
                    as int?,
        level:
            freezed == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                    as int?,
        tags:
            freezed == tags
                ? _value._tags
                : tags // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        interactiveEquipment:
            freezed == interactiveEquipment
                ? _value.interactiveEquipment
                : interactiveEquipment // ignore: cast_nullable_to_non_nullable
                    as int?,
        createTime:
            freezed == createTime
                ? _value.createTime
                : createTime // ignore: cast_nullable_to_non_nullable
                    as String?,
        courseBgm:
            freezed == courseBgm
                ? _value.courseBgm
                : courseBgm // ignore: cast_nullable_to_non_nullable
                    as String?,
        version:
            freezed == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                    as int?,
        timing:
            freezed == timing
                ? _value.timing
                : timing // ignore: cast_nullable_to_non_nullable
                    as bool?,
        collect:
            freezed == collect
                ? _value.collect
                : collect // ignore: cast_nullable_to_non_nullable
                    as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseItemImpl implements _CourseItem {
  const _$CourseItemImpl({
    this.id,
    this.title,
    this.cover,
    this.describe,
    this.proposal,
    this.people,
    this.carefulthing,
    this.expectCalorie,
    this.during,
    this.level,
    final List<String>? tags,
    this.interactiveEquipment,
    this.createTime,
    this.courseBgm,
    this.version,
    this.timing,
    this.collect,
  }) : _tags = tags;

  factory _$CourseItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseItemImplFromJson(json);

  @override
  final int? id;
  @override
  final String? title;
  @override
  final String? cover;
  @override
  final String? describe;
  @override
  final String? proposal;
  @override
  final String? people;
  @override
  final String? carefulthing;
  @override
  final int? expectCalorie;
  @override
  final int? during;
  @override
  final int? level;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? interactiveEquipment;
  @override
  final String? createTime;
  @override
  final String? courseBgm;
  @override
  final int? version;
  @override
  final bool? timing;
  @override
  final bool? collect;

  @override
  String toString() {
    return 'CourseItem(id: $id, title: $title, cover: $cover, describe: $describe, proposal: $proposal, people: $people, carefulthing: $carefulthing, expectCalorie: $expectCalorie, during: $during, level: $level, tags: $tags, interactiveEquipment: $interactiveEquipment, createTime: $createTime, courseBgm: $courseBgm, version: $version, timing: $timing, collect: $collect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.cover, cover) || other.cover == cover) &&
            (identical(other.describe, describe) ||
                other.describe == describe) &&
            (identical(other.proposal, proposal) ||
                other.proposal == proposal) &&
            (identical(other.people, people) || other.people == people) &&
            (identical(other.carefulthing, carefulthing) ||
                other.carefulthing == carefulthing) &&
            (identical(other.expectCalorie, expectCalorie) ||
                other.expectCalorie == expectCalorie) &&
            (identical(other.during, during) || other.during == during) &&
            (identical(other.level, level) || other.level == level) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.interactiveEquipment, interactiveEquipment) ||
                other.interactiveEquipment == interactiveEquipment) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.courseBgm, courseBgm) ||
                other.courseBgm == courseBgm) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.timing, timing) || other.timing == timing) &&
            (identical(other.collect, collect) || other.collect == collect));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    cover,
    describe,
    proposal,
    people,
    carefulthing,
    expectCalorie,
    during,
    level,
    const DeepCollectionEquality().hash(_tags),
    interactiveEquipment,
    createTime,
    courseBgm,
    version,
    timing,
    collect,
  );

  /// Create a copy of CourseItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseItemImplCopyWith<_$CourseItemImpl> get copyWith =>
      __$$CourseItemImplCopyWithImpl<_$CourseItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseItemImplToJson(this);
  }
}

abstract class _CourseItem implements CourseItem {
  const factory _CourseItem({
    final int? id,
    final String? title,
    final String? cover,
    final String? describe,
    final String? proposal,
    final String? people,
    final String? carefulthing,
    final int? expectCalorie,
    final int? during,
    final int? level,
    final List<String>? tags,
    final int? interactiveEquipment,
    final String? createTime,
    final String? courseBgm,
    final int? version,
    final bool? timing,
    final bool? collect,
  }) = _$CourseItemImpl;

  factory _CourseItem.fromJson(Map<String, dynamic> json) =
      _$CourseItemImpl.fromJson;

  @override
  int? get id;
  @override
  String? get title;
  @override
  String? get cover;
  @override
  String? get describe;
  @override
  String? get proposal;
  @override
  String? get people;
  @override
  String? get carefulthing;
  @override
  int? get expectCalorie;
  @override
  int? get during;
  @override
  int? get level;
  @override
  List<String>? get tags;
  @override
  int? get interactiveEquipment;
  @override
  String? get createTime;
  @override
  String? get courseBgm;
  @override
  int? get version;
  @override
  bool? get timing;
  @override
  bool? get collect;

  /// Create a copy of CourseItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseItemImplCopyWith<_$CourseItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
