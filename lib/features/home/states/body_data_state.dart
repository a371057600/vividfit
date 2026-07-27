import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_data_state.freezed.dart';

@freezed
abstract class BodyDataState with _$BodyDataState {
  const factory BodyDataState({
    @Default(false) bool sexValue,
    @Default(150) int bodyHeight,
    @Default(50) int bodyWeight,
    @Default('2000-01-01') String birthday,
    @Default('01') String bodyAgeDay,
    @Default('01') String bodyAgeMonth,
    @Default('1991') String bodyAgeYear,
    @Default('UserName') String nickName,
    @Default(70) int heightPosition,
    @Default(50) int weightPosition,
  }) = _BodyDataState;
}
