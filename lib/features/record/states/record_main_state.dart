import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/record_stats_item.dart';

part 'record_main_state.freezed.dart';

@freezed
abstract class RecordMainState with _$RecordMainState {
  const factory RecordMainState({
    @Default([]) List<RecordStatsItem> weekStats,
    RecordStatsItem? selectedDayStats,
    @Default(0.0) double goalCalorie,
    @Default(50) int goalDuration,
    @Default(3.0) double goalStrength,
    @Default(70.0) double bodyWeight,
    @Default(true) bool isLoading,
    @Default(0) int selectedDayIndex,
  }) = _RecordMainState;
}