import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings_state.freezed.dart';

@freezed
class UserSettingsState with _$UserSettingsState {
  const factory UserSettingsState({
    @Default('') String headImage,
    @Default(0) int selectedImageIndex,
    @Default('') String imagePickFile,
    @Default(true) bool isLoading,
    @Default('Nick') String nickName,
    @Default('2000-01-01') String birthday,
    @Default('01') String bodyAgeDay,
    @Default('01') String bodyAgeMonth,
    @Default('1991') String bodyAgeYear,
    @Default(true) bool gander,
    @Default(170) int bodyHeight,
    @Default(80) int bodyWeight,
    @Default(70) int bodyGoalWeight,
    @Default(70) int heightPosition,
    @Default(50) int weightPosition,
    @Default(30) int goalWeightPosition,
    @Default(false) bool isUpdating,
  }) = _UserSettingsState;
}
