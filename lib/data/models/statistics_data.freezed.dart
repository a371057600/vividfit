// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StatisticsItem _$StatisticsItemFromJson(Map<String, dynamic> json) {
  return _StatisticsItem.fromJson(json);
}

/// @nodoc
mixin _$StatisticsItem {
  int get calorie => throw _privateConstructorUsedError;
  int get duringTime => throw _privateConstructorUsedError;
  int get sportCount => throw _privateConstructorUsedError;

  /// Serializes this StatisticsItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StatisticsItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatisticsItemCopyWith<StatisticsItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatisticsItemCopyWith<$Res> {
  factory $StatisticsItemCopyWith(
    StatisticsItem value,
    $Res Function(StatisticsItem) then,
  ) = _$StatisticsItemCopyWithImpl<$Res, StatisticsItem>;
  @useResult
  $Res call({int calorie, int duringTime, int sportCount});
}

/// @nodoc
class _$StatisticsItemCopyWithImpl<$Res, $Val extends StatisticsItem>
    implements $StatisticsItemCopyWith<$Res> {
  _$StatisticsItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatisticsItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? calorie = null,
    Object? duringTime = null,
    Object? sportCount = null,
  }) {
    return _then(
      _value.copyWith(
            calorie:
                null == calorie
                    ? _value.calorie
                    : calorie // ignore: cast_nullable_to_non_nullable
                        as int,
            duringTime:
                null == duringTime
                    ? _value.duringTime
                    : duringTime // ignore: cast_nullable_to_non_nullable
                        as int,
            sportCount:
                null == sportCount
                    ? _value.sportCount
                    : sportCount // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StatisticsItemImplCopyWith<$Res>
    implements $StatisticsItemCopyWith<$Res> {
  factory _$$StatisticsItemImplCopyWith(
    _$StatisticsItemImpl value,
    $Res Function(_$StatisticsItemImpl) then,
  ) = __$$StatisticsItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int calorie, int duringTime, int sportCount});
}

/// @nodoc
class __$$StatisticsItemImplCopyWithImpl<$Res>
    extends _$StatisticsItemCopyWithImpl<$Res, _$StatisticsItemImpl>
    implements _$$StatisticsItemImplCopyWith<$Res> {
  __$$StatisticsItemImplCopyWithImpl(
    _$StatisticsItemImpl _value,
    $Res Function(_$StatisticsItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StatisticsItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? calorie = null,
    Object? duringTime = null,
    Object? sportCount = null,
  }) {
    return _then(
      _$StatisticsItemImpl(
        calorie:
            null == calorie
                ? _value.calorie
                : calorie // ignore: cast_nullable_to_non_nullable
                    as int,
        duringTime:
            null == duringTime
                ? _value.duringTime
                : duringTime // ignore: cast_nullable_to_non_nullable
                    as int,
        sportCount:
            null == sportCount
                ? _value.sportCount
                : sportCount // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StatisticsItemImpl implements _StatisticsItem {
  const _$StatisticsItemImpl({
    this.calorie = 0,
    this.duringTime = 0,
    this.sportCount = 0,
  });

  factory _$StatisticsItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatisticsItemImplFromJson(json);

  @override
  @JsonKey()
  final int calorie;
  @override
  @JsonKey()
  final int duringTime;
  @override
  @JsonKey()
  final int sportCount;

  @override
  String toString() {
    return 'StatisticsItem(calorie: $calorie, duringTime: $duringTime, sportCount: $sportCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatisticsItemImpl &&
            (identical(other.calorie, calorie) || other.calorie == calorie) &&
            (identical(other.duringTime, duringTime) ||
                other.duringTime == duringTime) &&
            (identical(other.sportCount, sportCount) ||
                other.sportCount == sportCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, calorie, duringTime, sportCount);

  /// Create a copy of StatisticsItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatisticsItemImplCopyWith<_$StatisticsItemImpl> get copyWith =>
      __$$StatisticsItemImplCopyWithImpl<_$StatisticsItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StatisticsItemImplToJson(this);
  }
}

abstract class _StatisticsItem implements StatisticsItem {
  const factory _StatisticsItem({
    final int calorie,
    final int duringTime,
    final int sportCount,
  }) = _$StatisticsItemImpl;

  factory _StatisticsItem.fromJson(Map<String, dynamic> json) =
      _$StatisticsItemImpl.fromJson;

  @override
  int get calorie;
  @override
  int get duringTime;
  @override
  int get sportCount;

  /// Create a copy of StatisticsItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatisticsItemImplCopyWith<_$StatisticsItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FitStatsData _$FitStatsDataFromJson(Map<String, dynamic> json) {
  return _FitStatsData.fromJson(json);
}

/// @nodoc
mixin _$FitStatsData {
  String get code => throw _privateConstructorUsedError;
  List<StatisticsItem> get data => throw _privateConstructorUsedError;

  /// Serializes this FitStatsData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FitStatsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FitStatsDataCopyWith<FitStatsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FitStatsDataCopyWith<$Res> {
  factory $FitStatsDataCopyWith(
    FitStatsData value,
    $Res Function(FitStatsData) then,
  ) = _$FitStatsDataCopyWithImpl<$Res, FitStatsData>;
  @useResult
  $Res call({String code, List<StatisticsItem> data});
}

/// @nodoc
class _$FitStatsDataCopyWithImpl<$Res, $Val extends FitStatsData>
    implements $FitStatsDataCopyWith<$Res> {
  _$FitStatsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FitStatsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = null, Object? data = null}) {
    return _then(
      _value.copyWith(
            code:
                null == code
                    ? _value.code
                    : code // ignore: cast_nullable_to_non_nullable
                        as String,
            data:
                null == data
                    ? _value.data
                    : data // ignore: cast_nullable_to_non_nullable
                        as List<StatisticsItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FitStatsDataImplCopyWith<$Res>
    implements $FitStatsDataCopyWith<$Res> {
  factory _$$FitStatsDataImplCopyWith(
    _$FitStatsDataImpl value,
    $Res Function(_$FitStatsDataImpl) then,
  ) = __$$FitStatsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code, List<StatisticsItem> data});
}

/// @nodoc
class __$$FitStatsDataImplCopyWithImpl<$Res>
    extends _$FitStatsDataCopyWithImpl<$Res, _$FitStatsDataImpl>
    implements _$$FitStatsDataImplCopyWith<$Res> {
  __$$FitStatsDataImplCopyWithImpl(
    _$FitStatsDataImpl _value,
    $Res Function(_$FitStatsDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FitStatsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = null, Object? data = null}) {
    return _then(
      _$FitStatsDataImpl(
        code:
            null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                    as String,
        data:
            null == data
                ? _value._data
                : data // ignore: cast_nullable_to_non_nullable
                    as List<StatisticsItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FitStatsDataImpl implements _FitStatsData {
  const _$FitStatsDataImpl({
    this.code = '',
    final List<StatisticsItem> data = const [],
  }) : _data = data;

  factory _$FitStatsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$FitStatsDataImplFromJson(json);

  @override
  @JsonKey()
  final String code;
  final List<StatisticsItem> _data;
  @override
  @JsonKey()
  List<StatisticsItem> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'FitStatsData(code: $code, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FitStatsDataImpl &&
            (identical(other.code, code) || other.code == code) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    code,
    const DeepCollectionEquality().hash(_data),
  );

  /// Create a copy of FitStatsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FitStatsDataImplCopyWith<_$FitStatsDataImpl> get copyWith =>
      __$$FitStatsDataImplCopyWithImpl<_$FitStatsDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FitStatsDataImplToJson(this);
  }
}

abstract class _FitStatsData implements FitStatsData {
  const factory _FitStatsData({
    final String code,
    final List<StatisticsItem> data,
  }) = _$FitStatsDataImpl;

  factory _FitStatsData.fromJson(Map<String, dynamic> json) =
      _$FitStatsDataImpl.fromJson;

  @override
  String get code;
  @override
  List<StatisticsItem> get data;

  /// Create a copy of FitStatsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FitStatsDataImplCopyWith<_$FitStatsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
