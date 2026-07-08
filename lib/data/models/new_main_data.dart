import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_main_data.freezed.dart';
part 'new_main_data.g.dart';

/// 主页三环 + BMI 数据(1:1 迁移自旧 FitMainData)。
///
/// 字段语义对应旧项目:
/// - triCycleDuration ↔ tricycliDuring
/// - triCycleStrength ↔ tricycliSportStrength
/// - triCycleCalorie ↔ tricyclicalorie
/// - goalDuration ↔ goalDuring
/// - goalStrength ↔ goalSportStrength
/// - goalCalorie ↔ goalCalorie
@freezed
class FitMainData with _$FitMainData {
  const factory FitMainData({
    @Default(1) int animationIndex2,
    @Default('') String recordDate,
    @Default(0) int triCycleCalorie,
    @Default(100) int goalCalorie,
    @Default(0) int triCycleDuration,
    @Default(50) int goalDuration,
    @Default(0.0) double triCycleStrength,
    @Default(5.0) double goalStrength,
    @Default(0) int todayCount,
    @Default(40) int bodyWeight,
    @Default(20.0) double bodyBmi,
    @Default(160) int bodyHeight,
    @Default(true) bool isLoading,
    @Default(true) bool isLoading2,
  }) = _FitMainData;

  factory FitMainData.fromJson(Map<String, dynamic> json) =>
      _$FitMainDataFromJson(json);
}
