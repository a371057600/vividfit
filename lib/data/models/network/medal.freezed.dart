// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedalMsg {

 int? get id; String? get name; String? get image; String? get describe; String? get group; int? get target; bool? get have; bool? get read; String? get createTime;
/// Create a copy of MedalMsg
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedalMsgCopyWith<MedalMsg> get copyWith => _$MedalMsgCopyWithImpl<MedalMsg>(this as MedalMsg, _$identity);

  /// Serializes this MedalMsg to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedalMsg&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.describe, describe) || other.describe == describe)&&(identical(other.group, group) || other.group == group)&&(identical(other.target, target) || other.target == target)&&(identical(other.have, have) || other.have == have)&&(identical(other.read, read) || other.read == read)&&(identical(other.createTime, createTime) || other.createTime == createTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,image,describe,group,target,have,read,createTime);

@override
String toString() {
  return 'MedalMsg(id: $id, name: $name, image: $image, describe: $describe, group: $group, target: $target, have: $have, read: $read, createTime: $createTime)';
}


}

/// @nodoc
abstract mixin class $MedalMsgCopyWith<$Res>  {
  factory $MedalMsgCopyWith(MedalMsg value, $Res Function(MedalMsg) _then) = _$MedalMsgCopyWithImpl;
@useResult
$Res call({
 int? id, String? name, String? image, String? describe, String? group, int? target, bool? have, bool? read, String? createTime
});




}
/// @nodoc
class _$MedalMsgCopyWithImpl<$Res>
    implements $MedalMsgCopyWith<$Res> {
  _$MedalMsgCopyWithImpl(this._self, this._then);

  final MedalMsg _self;
  final $Res Function(MedalMsg) _then;

/// Create a copy of MedalMsg
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? image = freezed,Object? describe = freezed,Object? group = freezed,Object? target = freezed,Object? have = freezed,Object? read = freezed,Object? createTime = freezed,}) {
  return _then(MedalMsg(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,describe: freezed == describe ? _self.describe : describe // ignore: cast_nullable_to_non_nullable
as String?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int?,have: freezed == have ? _self.have : have // ignore: cast_nullable_to_non_nullable
as bool?,read: freezed == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MedalMsg].
extension MedalMsgPatterns on MedalMsg {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedalMsg value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedalMsg() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedalMsg value)  $default,){
final _that = this;
switch (_that) {
case _MedalMsg():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedalMsg value)?  $default,){
final _that = this;
switch (_that) {
case _MedalMsg() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? name,  String? image,  String? describe,  String? group,  int? target,  bool? have,  bool? read,  String? createTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedalMsg() when $default != null:
return $default(_that.id,_that.name,_that.image,_that.describe,_that.group,_that.target,_that.have,_that.read,_that.createTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? name,  String? image,  String? describe,  String? group,  int? target,  bool? have,  bool? read,  String? createTime)  $default,) {final _that = this;
switch (_that) {
case _MedalMsg():
return $default(_that.id,_that.name,_that.image,_that.describe,_that.group,_that.target,_that.have,_that.read,_that.createTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? name,  String? image,  String? describe,  String? group,  int? target,  bool? have,  bool? read,  String? createTime)?  $default,) {final _that = this;
switch (_that) {
case _MedalMsg() when $default != null:
return $default(_that.id,_that.name,_that.image,_that.describe,_that.group,_that.target,_that.have,_that.read,_that.createTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedalMsg implements MedalMsg {
  const _MedalMsg({this.id, this.name, this.image, this.describe, this.group, this.target, this.have, this.read, this.createTime});
  factory _MedalMsg.fromJson(Map<String, dynamic> json) => _$MedalMsgFromJson(json);

@override final  int? id;
@override final  String? name;
@override final  String? image;
@override final  String? describe;
@override final  String? group;
@override final  int? target;
@override final  bool? have;
@override final  bool? read;
@override final  String? createTime;

/// Create a copy of MedalMsg
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedalMsgCopyWith<_MedalMsg> get copyWith => __$MedalMsgCopyWithImpl<_MedalMsg>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedalMsgToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedalMsg&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.describe, describe) || other.describe == describe)&&(identical(other.group, group) || other.group == group)&&(identical(other.target, target) || other.target == target)&&(identical(other.have, have) || other.have == have)&&(identical(other.read, read) || other.read == read)&&(identical(other.createTime, createTime) || other.createTime == createTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,image,describe,group,target,have,read,createTime);

@override
String toString() {
  return 'MedalMsg(id: $id, name: $name, image: $image, describe: $describe, group: $group, target: $target, have: $have, read: $read, createTime: $createTime)';
}


}

/// @nodoc
abstract mixin class _$MedalMsgCopyWith<$Res> implements $MedalMsgCopyWith<$Res> {
  factory _$MedalMsgCopyWith(_MedalMsg value, $Res Function(_MedalMsg) _then) = __$MedalMsgCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? name, String? image, String? describe, String? group, int? target, bool? have, bool? read, String? createTime
});




}
/// @nodoc
class __$MedalMsgCopyWithImpl<$Res>
    implements _$MedalMsgCopyWith<$Res> {
  __$MedalMsgCopyWithImpl(this._self, this._then);

  final _MedalMsg _self;
  final $Res Function(_MedalMsg) _then;

/// Create a copy of MedalMsg
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? image = freezed,Object? describe = freezed,Object? group = freezed,Object? target = freezed,Object? have = freezed,Object? read = freezed,Object? createTime = freezed,}) {
  return _then(_MedalMsg(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,describe: freezed == describe ? _self.describe : describe // ignore: cast_nullable_to_non_nullable
as String?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int?,have: freezed == have ? _self.have : have // ignore: cast_nullable_to_non_nullable
as bool?,read: freezed == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MedalGroup {

 String? get groupName; List<MedalMsg>? get medals;
/// Create a copy of MedalGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedalGroupCopyWith<MedalGroup> get copyWith => _$MedalGroupCopyWithImpl<MedalGroup>(this as MedalGroup, _$identity);

  /// Serializes this MedalGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedalGroup&&(identical(other.groupName, groupName) || other.groupName == groupName)&&const DeepCollectionEquality().equals(other.medals, medals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupName,const DeepCollectionEquality().hash(medals));

@override
String toString() {
  return 'MedalGroup(groupName: $groupName, medals: $medals)';
}


}

/// @nodoc
abstract mixin class $MedalGroupCopyWith<$Res>  {
  factory $MedalGroupCopyWith(MedalGroup value, $Res Function(MedalGroup) _then) = _$MedalGroupCopyWithImpl;
@useResult
$Res call({
 String? groupName, List<MedalMsg>? medals
});




}
/// @nodoc
class _$MedalGroupCopyWithImpl<$Res>
    implements $MedalGroupCopyWith<$Res> {
  _$MedalGroupCopyWithImpl(this._self, this._then);

  final MedalGroup _self;
  final $Res Function(MedalGroup) _then;

/// Create a copy of MedalGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupName = freezed,Object? medals = freezed,}) {
  return _then(MedalGroup(
groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,medals: freezed == medals ? _self.medals : medals // ignore: cast_nullable_to_non_nullable
as List<MedalMsg>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MedalGroup].
extension MedalGroupPatterns on MedalGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedalGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedalGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedalGroup value)  $default,){
final _that = this;
switch (_that) {
case _MedalGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedalGroup value)?  $default,){
final _that = this;
switch (_that) {
case _MedalGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? groupName,  List<MedalMsg>? medals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedalGroup() when $default != null:
return $default(_that.groupName,_that.medals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? groupName,  List<MedalMsg>? medals)  $default,) {final _that = this;
switch (_that) {
case _MedalGroup():
return $default(_that.groupName,_that.medals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? groupName,  List<MedalMsg>? medals)?  $default,) {final _that = this;
switch (_that) {
case _MedalGroup() when $default != null:
return $default(_that.groupName,_that.medals);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedalGroup implements MedalGroup {
  const _MedalGroup({this.groupName,  List<MedalMsg>? medals}): _medals = medals;
  factory _MedalGroup.fromJson(Map<String, dynamic> json) => _$MedalGroupFromJson(json);

@override final  String? groupName;
 final  List<MedalMsg>? _medals;
@override List<MedalMsg>? get medals {
  final value = _medals;
  if (value == null) return null;
  if (_medals is EqualUnmodifiableListView) return _medals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of MedalGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedalGroupCopyWith<_MedalGroup> get copyWith => __$MedalGroupCopyWithImpl<_MedalGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedalGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedalGroup&&(identical(other.groupName, groupName) || other.groupName == groupName)&&const DeepCollectionEquality().equals(other._medals, _medals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupName,const DeepCollectionEquality().hash(_medals));

@override
String toString() {
  return 'MedalGroup(groupName: $groupName, medals: $medals)';
}


}

/// @nodoc
abstract mixin class _$MedalGroupCopyWith<$Res> implements $MedalGroupCopyWith<$Res> {
  factory _$MedalGroupCopyWith(_MedalGroup value, $Res Function(_MedalGroup) _then) = __$MedalGroupCopyWithImpl;
@override @useResult
$Res call({
 String? groupName, List<MedalMsg>? medals
});




}
/// @nodoc
class __$MedalGroupCopyWithImpl<$Res>
    implements _$MedalGroupCopyWith<$Res> {
  __$MedalGroupCopyWithImpl(this._self, this._then);

  final _MedalGroup _self;
  final $Res Function(_MedalGroup) _then;

/// Create a copy of MedalGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupName = freezed,Object? medals = freezed,}) {
  return _then(_MedalGroup(
groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,medals: freezed == medals ? _self._medals : medals // ignore: cast_nullable_to_non_nullable
as List<MedalMsg>?,
  ));
}


}


/// @nodoc
mixin _$ReadMedal {

 int? get userId; List<int>? get medalIds;
/// Create a copy of ReadMedal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadMedalCopyWith<ReadMedal> get copyWith => _$ReadMedalCopyWithImpl<ReadMedal>(this as ReadMedal, _$identity);

  /// Serializes this ReadMedal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadMedal&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.medalIds, medalIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,const DeepCollectionEquality().hash(medalIds));

@override
String toString() {
  return 'ReadMedal(userId: $userId, medalIds: $medalIds)';
}


}

/// @nodoc
abstract mixin class $ReadMedalCopyWith<$Res>  {
  factory $ReadMedalCopyWith(ReadMedal value, $Res Function(ReadMedal) _then) = _$ReadMedalCopyWithImpl;
@useResult
$Res call({
 int? userId, List<int>? medalIds
});




}
/// @nodoc
class _$ReadMedalCopyWithImpl<$Res>
    implements $ReadMedalCopyWith<$Res> {
  _$ReadMedalCopyWithImpl(this._self, this._then);

  final ReadMedal _self;
  final $Res Function(ReadMedal) _then;

/// Create a copy of ReadMedal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = freezed,Object? medalIds = freezed,}) {
  return _then(ReadMedal(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,medalIds: freezed == medalIds ? _self.medalIds : medalIds // ignore: cast_nullable_to_non_nullable
as List<int>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReadMedal].
extension ReadMedalPatterns on ReadMedal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadMedal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadMedal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadMedal value)  $default,){
final _that = this;
switch (_that) {
case _ReadMedal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadMedal value)?  $default,){
final _that = this;
switch (_that) {
case _ReadMedal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? userId,  List<int>? medalIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadMedal() when $default != null:
return $default(_that.userId,_that.medalIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? userId,  List<int>? medalIds)  $default,) {final _that = this;
switch (_that) {
case _ReadMedal():
return $default(_that.userId,_that.medalIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? userId,  List<int>? medalIds)?  $default,) {final _that = this;
switch (_that) {
case _ReadMedal() when $default != null:
return $default(_that.userId,_that.medalIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReadMedal implements ReadMedal {
  const _ReadMedal({this.userId,  List<int>? medalIds}): _medalIds = medalIds;
  factory _ReadMedal.fromJson(Map<String, dynamic> json) => _$ReadMedalFromJson(json);

@override final  int? userId;
 final  List<int>? _medalIds;
@override List<int>? get medalIds {
  final value = _medalIds;
  if (value == null) return null;
  if (_medalIds is EqualUnmodifiableListView) return _medalIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ReadMedal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadMedalCopyWith<_ReadMedal> get copyWith => __$ReadMedalCopyWithImpl<_ReadMedal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReadMedalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadMedal&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._medalIds, _medalIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,const DeepCollectionEquality().hash(_medalIds));

@override
String toString() {
  return 'ReadMedal(userId: $userId, medalIds: $medalIds)';
}


}

/// @nodoc
abstract mixin class _$ReadMedalCopyWith<$Res> implements $ReadMedalCopyWith<$Res> {
  factory _$ReadMedalCopyWith(_ReadMedal value, $Res Function(_ReadMedal) _then) = __$ReadMedalCopyWithImpl;
@override @useResult
$Res call({
 int? userId, List<int>? medalIds
});




}
/// @nodoc
class __$ReadMedalCopyWithImpl<$Res>
    implements _$ReadMedalCopyWith<$Res> {
  __$ReadMedalCopyWithImpl(this._self, this._then);

  final _ReadMedal _self;
  final $Res Function(_ReadMedal) _then;

/// Create a copy of ReadMedal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = freezed,Object? medalIds = freezed,}) {
  return _then(_ReadMedal(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,medalIds: freezed == medalIds ? _self._medalIds : medalIds // ignore: cast_nullable_to_non_nullable
as List<int>?,
  ));
}


}

// dart format on
