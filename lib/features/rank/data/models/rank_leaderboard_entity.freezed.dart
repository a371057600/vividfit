// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rank_leaderboard_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RankLeaderboardEntity {

@JsonKey(name: 'myRank') int get rank;@JsonKey(name: 'nickName') String get nickName;@JsonKey(name: 'headImg') String? get headImg;@JsonKey(name: 'count') int get count;@JsonKey(name: 'calories') double get calories;@JsonKey(name: 'equipmentType') int? get equipmentType;
/// Create a copy of RankLeaderboardEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankLeaderboardEntityCopyWith<RankLeaderboardEntity> get copyWith => _$RankLeaderboardEntityCopyWithImpl<RankLeaderboardEntity>(this as RankLeaderboardEntity, _$identity);

  /// Serializes this RankLeaderboardEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankLeaderboardEntity&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.nickName, nickName) || other.nickName == nickName)&&(identical(other.headImg, headImg) || other.headImg == headImg)&&(identical(other.count, count) || other.count == count)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.equipmentType, equipmentType) || other.equipmentType == equipmentType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,nickName,headImg,count,calories,equipmentType);

@override
String toString() {
  return 'RankLeaderboardEntity(rank: $rank, nickName: $nickName, headImg: $headImg, count: $count, calories: $calories, equipmentType: $equipmentType)';
}


}

/// @nodoc
abstract mixin class $RankLeaderboardEntityCopyWith<$Res>  {
  factory $RankLeaderboardEntityCopyWith(RankLeaderboardEntity value, $Res Function(RankLeaderboardEntity) _then) = _$RankLeaderboardEntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'myRank') int rank,@JsonKey(name: 'nickName') String nickName,@JsonKey(name: 'headImg') String? headImg,@JsonKey(name: 'count') int count,@JsonKey(name: 'calories') double calories,@JsonKey(name: 'equipmentType') int? equipmentType
});




}
/// @nodoc
class _$RankLeaderboardEntityCopyWithImpl<$Res>
    implements $RankLeaderboardEntityCopyWith<$Res> {
  _$RankLeaderboardEntityCopyWithImpl(this._self, this._then);

  final RankLeaderboardEntity _self;
  final $Res Function(RankLeaderboardEntity) _then;

/// Create a copy of RankLeaderboardEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = null,Object? nickName = null,Object? headImg = freezed,Object? count = null,Object? calories = null,Object? equipmentType = freezed,}) {
  return _then(RankLeaderboardEntity(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,nickName: null == nickName ? _self.nickName : nickName // ignore: cast_nullable_to_non_nullable
as String,headImg: freezed == headImg ? _self.headImg : headImg // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double,equipmentType: freezed == equipmentType ? _self.equipmentType : equipmentType // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [RankLeaderboardEntity].
extension RankLeaderboardEntityPatterns on RankLeaderboardEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankLeaderboardEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankLeaderboardEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankLeaderboardEntity value)  $default,){
final _that = this;
switch (_that) {
case _RankLeaderboardEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankLeaderboardEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RankLeaderboardEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'myRank')  int rank, @JsonKey(name: 'nickName')  String nickName, @JsonKey(name: 'headImg')  String? headImg, @JsonKey(name: 'count')  int count, @JsonKey(name: 'calories')  double calories, @JsonKey(name: 'equipmentType')  int? equipmentType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankLeaderboardEntity() when $default != null:
return $default(_that.rank,_that.nickName,_that.headImg,_that.count,_that.calories,_that.equipmentType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'myRank')  int rank, @JsonKey(name: 'nickName')  String nickName, @JsonKey(name: 'headImg')  String? headImg, @JsonKey(name: 'count')  int count, @JsonKey(name: 'calories')  double calories, @JsonKey(name: 'equipmentType')  int? equipmentType)  $default,) {final _that = this;
switch (_that) {
case _RankLeaderboardEntity():
return $default(_that.rank,_that.nickName,_that.headImg,_that.count,_that.calories,_that.equipmentType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'myRank')  int rank, @JsonKey(name: 'nickName')  String nickName, @JsonKey(name: 'headImg')  String? headImg, @JsonKey(name: 'count')  int count, @JsonKey(name: 'calories')  double calories, @JsonKey(name: 'equipmentType')  int? equipmentType)?  $default,) {final _that = this;
switch (_that) {
case _RankLeaderboardEntity() when $default != null:
return $default(_that.rank,_that.nickName,_that.headImg,_that.count,_that.calories,_that.equipmentType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankLeaderboardEntity implements RankLeaderboardEntity {
  const _RankLeaderboardEntity({@JsonKey(name: 'myRank') required this.rank, @JsonKey(name: 'nickName') required this.nickName, @JsonKey(name: 'headImg') this.headImg, @JsonKey(name: 'count') required this.count, @JsonKey(name: 'calories') required this.calories, @JsonKey(name: 'equipmentType') this.equipmentType});
  factory _RankLeaderboardEntity.fromJson(Map<String, dynamic> json) => _$RankLeaderboardEntityFromJson(json);

@override@JsonKey(name: 'myRank') final  int rank;
@override@JsonKey(name: 'nickName') final  String nickName;
@override@JsonKey(name: 'headImg') final  String? headImg;
@override@JsonKey(name: 'count') final  int count;
@override@JsonKey(name: 'calories') final  double calories;
@override@JsonKey(name: 'equipmentType') final  int? equipmentType;

/// Create a copy of RankLeaderboardEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankLeaderboardEntityCopyWith<_RankLeaderboardEntity> get copyWith => __$RankLeaderboardEntityCopyWithImpl<_RankLeaderboardEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankLeaderboardEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankLeaderboardEntity&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.nickName, nickName) || other.nickName == nickName)&&(identical(other.headImg, headImg) || other.headImg == headImg)&&(identical(other.count, count) || other.count == count)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.equipmentType, equipmentType) || other.equipmentType == equipmentType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,nickName,headImg,count,calories,equipmentType);

@override
String toString() {
  return 'RankLeaderboardEntity(rank: $rank, nickName: $nickName, headImg: $headImg, count: $count, calories: $calories, equipmentType: $equipmentType)';
}


}

/// @nodoc
abstract mixin class _$RankLeaderboardEntityCopyWith<$Res> implements $RankLeaderboardEntityCopyWith<$Res> {
  factory _$RankLeaderboardEntityCopyWith(_RankLeaderboardEntity value, $Res Function(_RankLeaderboardEntity) _then) = __$RankLeaderboardEntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'myRank') int rank,@JsonKey(name: 'nickName') String nickName,@JsonKey(name: 'headImg') String? headImg,@JsonKey(name: 'count') int count,@JsonKey(name: 'calories') double calories,@JsonKey(name: 'equipmentType') int? equipmentType
});




}
/// @nodoc
class __$RankLeaderboardEntityCopyWithImpl<$Res>
    implements _$RankLeaderboardEntityCopyWith<$Res> {
  __$RankLeaderboardEntityCopyWithImpl(this._self, this._then);

  final _RankLeaderboardEntity _self;
  final $Res Function(_RankLeaderboardEntity) _then;

/// Create a copy of RankLeaderboardEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = null,Object? nickName = null,Object? headImg = freezed,Object? count = null,Object? calories = null,Object? equipmentType = freezed,}) {
  return _then(_RankLeaderboardEntity(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,nickName: null == nickName ? _self.nickName : nickName // ignore: cast_nullable_to_non_nullable
as String,headImg: freezed == headImg ? _self.headImg : headImg // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double,equipmentType: freezed == equipmentType ? _self.equipmentType : equipmentType // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
