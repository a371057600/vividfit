import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/record_repository.dart';
import '../states/record_main_state.dart';
import '../utils/list_extension.dart';

part 'record_main_notifier.g.dart';

@Riverpod()
class RecordMainNotifier extends _$RecordMainNotifier {
  @override
  RecordMainState build() {
    _initData();
    return const RecordMainState(isLoading: true);
  }

  Future<void> _initData() async {
    final repo = ref.read(recordRepositoryProvider);
    final response = await repo.fetchWeekStats();

    int goalCalorie = 300;
    int goalDuration = 45;
    double goalStrength = 5.0;
    double bodyWeight = 70.0;

    for (final item in response.data) {
      if (item.calorie > goalCalorie) goalCalorie = item.calorie.toInt() + 50;
      if (item.duringTime > goalDuration * 60) goalDuration = (item.duringTime / 60).round() + 5;
      if (item.sportStrength > goalStrength) goalStrength = item.sportStrength + 0.5;
    }

    final now = DateTime.now();
    final selectedDayIndex = now.weekday - 1;
    final selectedDayStats = response.data.isValidIndex(selectedDayIndex)
        ? response.data[selectedDayIndex]
        : null;

    state = state.copyWith(
      weekStats: response.data,
      selectedDayStats: selectedDayStats,
      goalCalorie: goalCalorie.toDouble(),
      goalDuration: goalDuration,
      goalStrength: goalStrength,
      bodyWeight: bodyWeight,
      isLoading: false,
      selectedDayIndex: selectedDayIndex,
    );
  }

  Future<void> selectDay(DateTime date) async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(recordRepositoryProvider);
    final dayStats = await repo.fetchDayStats(date);
    final index = date.weekday - 1;
    state = state.copyWith(
      selectedDayStats: dayStats,
      selectedDayIndex: index,
      isLoading: false,
    );
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(recordRepositoryProvider);
    final response = await repo.fetchWeekStats();
    final now = DateTime.now();
    final selectedDayIndex = now.weekday - 1;
    final selectedDayStats = response.data.isValidIndex(selectedDayIndex)
        ? response.data[selectedDayIndex]
        : null;
    state = state.copyWith(
      weekStats: response.data,
      selectedDayStats: selectedDayStats,
      selectedDayIndex: selectedDayIndex,
      isLoading: false,
    );
  }
}