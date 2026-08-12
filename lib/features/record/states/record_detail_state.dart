import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/network/sport_history.dart';

part 'record_detail_state.freezed.dart';

@freezed
abstract class RecordDetailState with _$RecordDetailState {
  const factory RecordDetailState({
    SportHistory? currentRecord,
    SportHistory? previousRecord,
    @Default(true) bool isLoading,
  }) = _RecordDetailState;
}