import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/network/sport_history.dart';
import '../states/record_detail_state.dart';

part 'record_detail_notifier.g.dart';

@Riverpod()
class RecordDetailNotifier extends _$RecordDetailNotifier {
  @override
  RecordDetailState build() {
    return const RecordDetailState(currentRecord: null, previousRecord: null, isLoading: false);
  }

  Future<void> loadDetail(SportHistory record) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 200));

    final previousRecord = SportHistory(
      id: (record.id ?? 1) - 1,
      userId: record.userId,
      equipmentType: record.equipmentType,
      mode: record.mode,
      trainMode: record.trainMode,
      calories: ((record.calories ?? 0) * 0.85).roundToDouble(),
      duringTime: ((record.duringTime ?? 0) * 0.9).round(),
      distance: (record.distance ?? 0) * 0.9,
      count: ((record.count ?? 0) * 0.8).round(),
      isOffline: false,
      startTime: record.startTime,
      createTime: record.createTime,
    );

    state = state.copyWith(
      currentRecord: record,
      previousRecord: previousRecord,
      isLoading: false,
    );
  }
}