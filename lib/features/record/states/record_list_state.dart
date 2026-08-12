import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/network/sport_history.dart';
import '../models/record_equipment_type.dart';

part 'record_list_state.freezed.dart';

@freezed
abstract class RecordListState with _$RecordListState {
  const factory RecordListState({
    @Default([]) List<SportHistory> historyList,
    @Default({}) Map<int, List<SportHistory>> groupedData,
    @Default(RecordEquipmentType.all) RecordEquipmentType equipmentType,
    @Default(2026) int year,
    @Default(0) int totalCount,
    @Default(0) int totalDuration,
    @Default(0.0) double totalCalorie,
    @Default(true) bool isLoading,
  }) = _RecordListState;
}