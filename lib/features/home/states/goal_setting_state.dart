import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_setting_state.freezed.dart';

@freezed
class GoalSettingState with _$GoalSettingState {
  const factory GoalSettingState({
    @Default(165) int goalKcal,
    @Default(3.0) double goalStrength,
    @Default(50) int goalDuring,
    @Default(0) int sportDuring,
    @Default(0.0) double sportStrength,
    @Default(0) int sportKcal,
    @Default(0) int sportTypeSelectIndex,
    @Default(0) int sportTypeSelectIndex2,
    @Default('Basic') String sportTypeSelectSubIndexString,
    @Default(true) bool isLoading,
  }) = _GoalSettingState;
}
