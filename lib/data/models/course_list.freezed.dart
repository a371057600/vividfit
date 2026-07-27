// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CourseList {

 String? get code; CourseListData? get data;
/// Create a copy of CourseList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseListCopyWith<CourseList> get copyWith => _$CourseListCopyWithImpl<CourseList>(this as CourseList, _$identity);

  /// Serializes this CourseList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseList&&(identical(other.code, code) || other.code == code)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,data);

@override
String toString() {
  return 'CourseList(code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class $CourseListCopyWith<$Res>  {
  factory $CourseListCopyWith(CourseList value, $Res Function(CourseList) _then) = _$CourseListCopyWithImpl;
@useResult
$Res call({
 String? code, CourseListData? data
});


$CourseListDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$CourseListCopyWithImpl<$Res>
    implements $CourseListCopyWith<$Res> {
  _$CourseListCopyWithImpl(this._self, this._then);

  final CourseList _self;
  final $Res Function(CourseList) _then;

/// Create a copy of CourseList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CourseListData?,
  ));
}
/// Create a copy of CourseList
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseListDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $CourseListDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [CourseList].
extension CourseListPatterns on CourseList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseList value)  $default,){
final _that = this;
switch (_that) {
case _CourseList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseList value)?  $default,){
final _that = this;
switch (_that) {
case _CourseList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? code,  CourseListData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseList() when $default != null:
return $default(_that.code,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? code,  CourseListData? data)  $default,) {final _that = this;
switch (_that) {
case _CourseList():
return $default(_that.code,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? code,  CourseListData? data)?  $default,) {final _that = this;
switch (_that) {
case _CourseList() when $default != null:
return $default(_that.code,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseList implements CourseList {
  const _CourseList({this.code, this.data});
  factory _CourseList.fromJson(Map<String, dynamic> json) => _$CourseListFromJson(json);

@override final  String? code;
@override final  CourseListData? data;

/// Create a copy of CourseList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseListCopyWith<_CourseList> get copyWith => __$CourseListCopyWithImpl<_CourseList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseList&&(identical(other.code, code) || other.code == code)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,data);

@override
String toString() {
  return 'CourseList(code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class _$CourseListCopyWith<$Res> implements $CourseListCopyWith<$Res> {
  factory _$CourseListCopyWith(_CourseList value, $Res Function(_CourseList) _then) = __$CourseListCopyWithImpl;
@override @useResult
$Res call({
 String? code, CourseListData? data
});


@override $CourseListDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$CourseListCopyWithImpl<$Res>
    implements _$CourseListCopyWith<$Res> {
  __$CourseListCopyWithImpl(this._self, this._then);

  final _CourseList _self;
  final $Res Function(_CourseList) _then;

/// Create a copy of CourseList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? data = freezed,}) {
  return _then(_CourseList(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CourseListData?,
  ));
}

/// Create a copy of CourseList
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseListDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $CourseListDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$CourseListData {

 List<CourseItem>? get dataList; int? get currentPageNum; int? get totalElements; int? get totalPages;
/// Create a copy of CourseListData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseListDataCopyWith<CourseListData> get copyWith => _$CourseListDataCopyWithImpl<CourseListData>(this as CourseListData, _$identity);

  /// Serializes this CourseListData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseListData&&const DeepCollectionEquality().equals(other.dataList, dataList)&&(identical(other.currentPageNum, currentPageNum) || other.currentPageNum == currentPageNum)&&(identical(other.totalElements, totalElements) || other.totalElements == totalElements)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(dataList),currentPageNum,totalElements,totalPages);

@override
String toString() {
  return 'CourseListData(dataList: $dataList, currentPageNum: $currentPageNum, totalElements: $totalElements, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $CourseListDataCopyWith<$Res>  {
  factory $CourseListDataCopyWith(CourseListData value, $Res Function(CourseListData) _then) = _$CourseListDataCopyWithImpl;
@useResult
$Res call({
 List<CourseItem>? dataList, int? currentPageNum, int? totalElements, int? totalPages
});




}
/// @nodoc
class _$CourseListDataCopyWithImpl<$Res>
    implements $CourseListDataCopyWith<$Res> {
  _$CourseListDataCopyWithImpl(this._self, this._then);

  final CourseListData _self;
  final $Res Function(CourseListData) _then;

/// Create a copy of CourseListData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dataList = freezed,Object? currentPageNum = freezed,Object? totalElements = freezed,Object? totalPages = freezed,}) {
  return _then(_self.copyWith(
dataList: freezed == dataList ? _self.dataList : dataList // ignore: cast_nullable_to_non_nullable
as List<CourseItem>?,currentPageNum: freezed == currentPageNum ? _self.currentPageNum : currentPageNum // ignore: cast_nullable_to_non_nullable
as int?,totalElements: freezed == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int?,totalPages: freezed == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseListData].
extension CourseListDataPatterns on CourseListData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseListData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseListData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseListData value)  $default,){
final _that = this;
switch (_that) {
case _CourseListData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseListData value)?  $default,){
final _that = this;
switch (_that) {
case _CourseListData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CourseItem>? dataList,  int? currentPageNum,  int? totalElements,  int? totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseListData() when $default != null:
return $default(_that.dataList,_that.currentPageNum,_that.totalElements,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CourseItem>? dataList,  int? currentPageNum,  int? totalElements,  int? totalPages)  $default,) {final _that = this;
switch (_that) {
case _CourseListData():
return $default(_that.dataList,_that.currentPageNum,_that.totalElements,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CourseItem>? dataList,  int? currentPageNum,  int? totalElements,  int? totalPages)?  $default,) {final _that = this;
switch (_that) {
case _CourseListData() when $default != null:
return $default(_that.dataList,_that.currentPageNum,_that.totalElements,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseListData implements CourseListData {
  const _CourseListData({final  List<CourseItem>? dataList, this.currentPageNum, this.totalElements, this.totalPages}): _dataList = dataList;
  factory _CourseListData.fromJson(Map<String, dynamic> json) => _$CourseListDataFromJson(json);

 final  List<CourseItem>? _dataList;
@override List<CourseItem>? get dataList {
  final value = _dataList;
  if (value == null) return null;
  if (_dataList is EqualUnmodifiableListView) return _dataList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? currentPageNum;
@override final  int? totalElements;
@override final  int? totalPages;

/// Create a copy of CourseListData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseListDataCopyWith<_CourseListData> get copyWith => __$CourseListDataCopyWithImpl<_CourseListData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseListDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseListData&&const DeepCollectionEquality().equals(other._dataList, _dataList)&&(identical(other.currentPageNum, currentPageNum) || other.currentPageNum == currentPageNum)&&(identical(other.totalElements, totalElements) || other.totalElements == totalElements)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_dataList),currentPageNum,totalElements,totalPages);

@override
String toString() {
  return 'CourseListData(dataList: $dataList, currentPageNum: $currentPageNum, totalElements: $totalElements, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$CourseListDataCopyWith<$Res> implements $CourseListDataCopyWith<$Res> {
  factory _$CourseListDataCopyWith(_CourseListData value, $Res Function(_CourseListData) _then) = __$CourseListDataCopyWithImpl;
@override @useResult
$Res call({
 List<CourseItem>? dataList, int? currentPageNum, int? totalElements, int? totalPages
});




}
/// @nodoc
class __$CourseListDataCopyWithImpl<$Res>
    implements _$CourseListDataCopyWith<$Res> {
  __$CourseListDataCopyWithImpl(this._self, this._then);

  final _CourseListData _self;
  final $Res Function(_CourseListData) _then;

/// Create a copy of CourseListData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dataList = freezed,Object? currentPageNum = freezed,Object? totalElements = freezed,Object? totalPages = freezed,}) {
  return _then(_CourseListData(
dataList: freezed == dataList ? _self._dataList : dataList // ignore: cast_nullable_to_non_nullable
as List<CourseItem>?,currentPageNum: freezed == currentPageNum ? _self.currentPageNum : currentPageNum // ignore: cast_nullable_to_non_nullable
as int?,totalElements: freezed == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int?,totalPages: freezed == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$CourseItem {

 int? get id; String? get title; String? get cover; String? get describe; String? get proposal; String? get people; String? get carefulthing; int? get expectCalorie; int? get during; int? get level; List<String>? get tags; int? get interactiveEquipment; String? get createTime; String? get courseBgm; int? get version; bool? get timing; bool? get collect;
/// Create a copy of CourseItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseItemCopyWith<CourseItem> get copyWith => _$CourseItemCopyWithImpl<CourseItem>(this as CourseItem, _$identity);

  /// Serializes this CourseItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.describe, describe) || other.describe == describe)&&(identical(other.proposal, proposal) || other.proposal == proposal)&&(identical(other.people, people) || other.people == people)&&(identical(other.carefulthing, carefulthing) || other.carefulthing == carefulthing)&&(identical(other.expectCalorie, expectCalorie) || other.expectCalorie == expectCalorie)&&(identical(other.during, during) || other.during == during)&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.interactiveEquipment, interactiveEquipment) || other.interactiveEquipment == interactiveEquipment)&&(identical(other.createTime, createTime) || other.createTime == createTime)&&(identical(other.courseBgm, courseBgm) || other.courseBgm == courseBgm)&&(identical(other.version, version) || other.version == version)&&(identical(other.timing, timing) || other.timing == timing)&&(identical(other.collect, collect) || other.collect == collect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,cover,describe,proposal,people,carefulthing,expectCalorie,during,level,const DeepCollectionEquality().hash(tags),interactiveEquipment,createTime,courseBgm,version,timing,collect);

@override
String toString() {
  return 'CourseItem(id: $id, title: $title, cover: $cover, describe: $describe, proposal: $proposal, people: $people, carefulthing: $carefulthing, expectCalorie: $expectCalorie, during: $during, level: $level, tags: $tags, interactiveEquipment: $interactiveEquipment, createTime: $createTime, courseBgm: $courseBgm, version: $version, timing: $timing, collect: $collect)';
}


}

/// @nodoc
abstract mixin class $CourseItemCopyWith<$Res>  {
  factory $CourseItemCopyWith(CourseItem value, $Res Function(CourseItem) _then) = _$CourseItemCopyWithImpl;
@useResult
$Res call({
 int? id, String? title, String? cover, String? describe, String? proposal, String? people, String? carefulthing, int? expectCalorie, int? during, int? level, List<String>? tags, int? interactiveEquipment, String? createTime, String? courseBgm, int? version, bool? timing, bool? collect
});




}
/// @nodoc
class _$CourseItemCopyWithImpl<$Res>
    implements $CourseItemCopyWith<$Res> {
  _$CourseItemCopyWithImpl(this._self, this._then);

  final CourseItem _self;
  final $Res Function(CourseItem) _then;

/// Create a copy of CourseItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = freezed,Object? cover = freezed,Object? describe = freezed,Object? proposal = freezed,Object? people = freezed,Object? carefulthing = freezed,Object? expectCalorie = freezed,Object? during = freezed,Object? level = freezed,Object? tags = freezed,Object? interactiveEquipment = freezed,Object? createTime = freezed,Object? courseBgm = freezed,Object? version = freezed,Object? timing = freezed,Object? collect = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,describe: freezed == describe ? _self.describe : describe // ignore: cast_nullable_to_non_nullable
as String?,proposal: freezed == proposal ? _self.proposal : proposal // ignore: cast_nullable_to_non_nullable
as String?,people: freezed == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as String?,carefulthing: freezed == carefulthing ? _self.carefulthing : carefulthing // ignore: cast_nullable_to_non_nullable
as String?,expectCalorie: freezed == expectCalorie ? _self.expectCalorie : expectCalorie // ignore: cast_nullable_to_non_nullable
as int?,during: freezed == during ? _self.during : during // ignore: cast_nullable_to_non_nullable
as int?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,interactiveEquipment: freezed == interactiveEquipment ? _self.interactiveEquipment : interactiveEquipment // ignore: cast_nullable_to_non_nullable
as int?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,courseBgm: freezed == courseBgm ? _self.courseBgm : courseBgm // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,timing: freezed == timing ? _self.timing : timing // ignore: cast_nullable_to_non_nullable
as bool?,collect: freezed == collect ? _self.collect : collect // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseItem].
extension CourseItemPatterns on CourseItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseItem value)  $default,){
final _that = this;
switch (_that) {
case _CourseItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseItem value)?  $default,){
final _that = this;
switch (_that) {
case _CourseItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? title,  String? cover,  String? describe,  String? proposal,  String? people,  String? carefulthing,  int? expectCalorie,  int? during,  int? level,  List<String>? tags,  int? interactiveEquipment,  String? createTime,  String? courseBgm,  int? version,  bool? timing,  bool? collect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseItem() when $default != null:
return $default(_that.id,_that.title,_that.cover,_that.describe,_that.proposal,_that.people,_that.carefulthing,_that.expectCalorie,_that.during,_that.level,_that.tags,_that.interactiveEquipment,_that.createTime,_that.courseBgm,_that.version,_that.timing,_that.collect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? title,  String? cover,  String? describe,  String? proposal,  String? people,  String? carefulthing,  int? expectCalorie,  int? during,  int? level,  List<String>? tags,  int? interactiveEquipment,  String? createTime,  String? courseBgm,  int? version,  bool? timing,  bool? collect)  $default,) {final _that = this;
switch (_that) {
case _CourseItem():
return $default(_that.id,_that.title,_that.cover,_that.describe,_that.proposal,_that.people,_that.carefulthing,_that.expectCalorie,_that.during,_that.level,_that.tags,_that.interactiveEquipment,_that.createTime,_that.courseBgm,_that.version,_that.timing,_that.collect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? title,  String? cover,  String? describe,  String? proposal,  String? people,  String? carefulthing,  int? expectCalorie,  int? during,  int? level,  List<String>? tags,  int? interactiveEquipment,  String? createTime,  String? courseBgm,  int? version,  bool? timing,  bool? collect)?  $default,) {final _that = this;
switch (_that) {
case _CourseItem() when $default != null:
return $default(_that.id,_that.title,_that.cover,_that.describe,_that.proposal,_that.people,_that.carefulthing,_that.expectCalorie,_that.during,_that.level,_that.tags,_that.interactiveEquipment,_that.createTime,_that.courseBgm,_that.version,_that.timing,_that.collect);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseItem implements CourseItem {
  const _CourseItem({this.id, this.title, this.cover, this.describe, this.proposal, this.people, this.carefulthing, this.expectCalorie, this.during, this.level, final  List<String>? tags, this.interactiveEquipment, this.createTime, this.courseBgm, this.version, this.timing, this.collect}): _tags = tags;
  factory _CourseItem.fromJson(Map<String, dynamic> json) => _$CourseItemFromJson(json);

@override final  int? id;
@override final  String? title;
@override final  String? cover;
@override final  String? describe;
@override final  String? proposal;
@override final  String? people;
@override final  String? carefulthing;
@override final  int? expectCalorie;
@override final  int? during;
@override final  int? level;
 final  List<String>? _tags;
@override List<String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? interactiveEquipment;
@override final  String? createTime;
@override final  String? courseBgm;
@override final  int? version;
@override final  bool? timing;
@override final  bool? collect;

/// Create a copy of CourseItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseItemCopyWith<_CourseItem> get copyWith => __$CourseItemCopyWithImpl<_CourseItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.describe, describe) || other.describe == describe)&&(identical(other.proposal, proposal) || other.proposal == proposal)&&(identical(other.people, people) || other.people == people)&&(identical(other.carefulthing, carefulthing) || other.carefulthing == carefulthing)&&(identical(other.expectCalorie, expectCalorie) || other.expectCalorie == expectCalorie)&&(identical(other.during, during) || other.during == during)&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.interactiveEquipment, interactiveEquipment) || other.interactiveEquipment == interactiveEquipment)&&(identical(other.createTime, createTime) || other.createTime == createTime)&&(identical(other.courseBgm, courseBgm) || other.courseBgm == courseBgm)&&(identical(other.version, version) || other.version == version)&&(identical(other.timing, timing) || other.timing == timing)&&(identical(other.collect, collect) || other.collect == collect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,cover,describe,proposal,people,carefulthing,expectCalorie,during,level,const DeepCollectionEquality().hash(_tags),interactiveEquipment,createTime,courseBgm,version,timing,collect);

@override
String toString() {
  return 'CourseItem(id: $id, title: $title, cover: $cover, describe: $describe, proposal: $proposal, people: $people, carefulthing: $carefulthing, expectCalorie: $expectCalorie, during: $during, level: $level, tags: $tags, interactiveEquipment: $interactiveEquipment, createTime: $createTime, courseBgm: $courseBgm, version: $version, timing: $timing, collect: $collect)';
}


}

/// @nodoc
abstract mixin class _$CourseItemCopyWith<$Res> implements $CourseItemCopyWith<$Res> {
  factory _$CourseItemCopyWith(_CourseItem value, $Res Function(_CourseItem) _then) = __$CourseItemCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? title, String? cover, String? describe, String? proposal, String? people, String? carefulthing, int? expectCalorie, int? during, int? level, List<String>? tags, int? interactiveEquipment, String? createTime, String? courseBgm, int? version, bool? timing, bool? collect
});




}
/// @nodoc
class __$CourseItemCopyWithImpl<$Res>
    implements _$CourseItemCopyWith<$Res> {
  __$CourseItemCopyWithImpl(this._self, this._then);

  final _CourseItem _self;
  final $Res Function(_CourseItem) _then;

/// Create a copy of CourseItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = freezed,Object? cover = freezed,Object? describe = freezed,Object? proposal = freezed,Object? people = freezed,Object? carefulthing = freezed,Object? expectCalorie = freezed,Object? during = freezed,Object? level = freezed,Object? tags = freezed,Object? interactiveEquipment = freezed,Object? createTime = freezed,Object? courseBgm = freezed,Object? version = freezed,Object? timing = freezed,Object? collect = freezed,}) {
  return _then(_CourseItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,describe: freezed == describe ? _self.describe : describe // ignore: cast_nullable_to_non_nullable
as String?,proposal: freezed == proposal ? _self.proposal : proposal // ignore: cast_nullable_to_non_nullable
as String?,people: freezed == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as String?,carefulthing: freezed == carefulthing ? _self.carefulthing : carefulthing // ignore: cast_nullable_to_non_nullable
as String?,expectCalorie: freezed == expectCalorie ? _self.expectCalorie : expectCalorie // ignore: cast_nullable_to_non_nullable
as int?,during: freezed == during ? _self.during : during // ignore: cast_nullable_to_non_nullable
as int?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,interactiveEquipment: freezed == interactiveEquipment ? _self.interactiveEquipment : interactiveEquipment // ignore: cast_nullable_to_non_nullable
as int?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,courseBgm: freezed == courseBgm ? _self.courseBgm : courseBgm // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,timing: freezed == timing ? _self.timing : timing // ignore: cast_nullable_to_non_nullable
as bool?,collect: freezed == collect ? _self.collect : collect // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
