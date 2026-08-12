import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/network/sport_history.dart';
import '../models/record_equipment_type.dart';
import '../repositories/record_repository.dart';
import '../states/record_list_state.dart';

part 'record_list_notifier.g.dart';

@Riverpod()
class RecordListNotifier extends _$RecordListNotifier {
  @override
  RecordListState build() {
    _initData();
    return const RecordListState();
  }

  Future<void> _initData() async {
    final repo = ref.read(recordRepositoryProvider);
    final year = DateTime.now().year;
    final records = await repo.fetchHistory(year: year);
    state = _computeState(records, RecordEquipmentType.all, year);
  }

  RecordListState _computeState(
    List<SportHistory> records,
    RecordEquipmentType equipmentType,
    int year,
  ) {
    final groupedData = <int, List<SportHistory>>{};
    int totalCount = 0;
    int totalDuration = 0;
    double totalCalorie = 0.0;

    for (final r in records) {
      totalCount += r.count ?? 0;
      totalDuration += r.duringTime ?? 0;
      totalCalorie += r.calories ?? 0.0;

      final startTime = r.startTime ?? '';
      if (startTime.isNotEmpty) {
        final month = int.tryParse(startTime.substring(5, 7)) ?? 0;
        if (month > 0) {
          groupedData.putIfAbsent(month, () => []).add(r);
        }
      }
    }

    return RecordListState(
      historyList: records,
      groupedData: groupedData,
      equipmentType: equipmentType,
      year: year,
      totalCount: totalCount,
      totalDuration: totalDuration,
      totalCalorie: totalCalorie,
      isLoading: false,
    );
  }

  Future<void> changeEquipmentType(RecordEquipmentType type) async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(recordRepositoryProvider);
    final records = await repo.fetchHistory(year: state.year, equipmentType: type);
    state = _computeState(records, type, state.year);
  }

  Future<void> changeYear(int year) async {
    if (year < 2021 || year > DateTime.now().year) return;
    state = state.copyWith(isLoading: true);
    final repo = ref.read(recordRepositoryProvider);
    final records = await repo.fetchHistory(year: year, equipmentType: state.equipmentType);
    state = _computeState(records, state.equipmentType, year);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(recordRepositoryProvider);
    final records = await repo.fetchHistory(year: state.year, equipmentType: state.equipmentType);
    state = _computeState(records, state.equipmentType, state.year);
  }
}