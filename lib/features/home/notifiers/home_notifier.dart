import 'package:riverpod/riverpod.dart';

import '../../../core/services/home_repository_provider.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_provider.dart';
import '../../../data/models/new_main_data.dart';
import '../repositories/home_repository.dart';
import '../states/home_state.dart';

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    _repo = ref.watch(homeRepositoryProvider);
    _storage = ref.watch(storageServiceProvider);
    final state = _buildInitialState();
    _initData();
    return state;
  }

  late HomeRepository _repo;
  late StorageService _storage;

  HomeState _buildInitialState() {
    var mainData = FitMainData();
    mainData = mainData.copyWith(
      goalCalorie: _storage.goalKcal,
      goalDuration: _storage.goalDuring,
      goalStrength: _storage.goalStrength,
    );
    final h = _storage.userHeight;
    final w = _storage.userWeight;
    final bmi = w / ((h / 100) * (h / 100));
    mainData = mainData.copyWith(bodyHeight: h, bodyWeight: w, bodyBmi: bmi);

    final d = DateTime.now();
    final m = d.month < 10 ? '0${d.month}' : '${d.month}';
    final day = d.day < 10 ? '0${d.day}' : '${d.day}';
    mainData = mainData.copyWith(recordDate: '$m/$day');

    return HomeState(
      mainData: mainData.copyWith(isLoading: false, isLoading2: false),
      nickName: _storage.username ?? 'UserName',
      headImageHash: _storage.headImageHash ?? '',
      selectedCharacterIndex: _storage.selectedCharacterIndex,
      myRank: _storage.myRank ?? '99',
      isReached: _storage.isReached ?? false,
      hasAiReport: _storage.hasAiReport,
      currentIndex: 0,
      isLoading: false,
    );
  }

  Future<void> _initData() async {
    await _fetchStatistics();
    await _repo.getStatisticsCalendar();
    state = state.copyWith(isReached: _storage.isReached ?? false);
  }

  Future<void> _fetchStatistics() async {
    final stats = await _repo.getSportStatistics();
    if (stats.code == '200') {
      final integrated = _repo.integrateStatistics(stats, state.mainData);
      state = state.copyWith(
        mainData: integrated.copyWith(isLoading: false, isLoading2: false),
      );
    } else {
      final ok = await _repo.refreshToken();
      if (ok) {
        await _fetchStatistics();
      }
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(
      mainData: state.mainData.copyWith(isLoading: true),
    );
    await _fetchStatistics();
    await _repo.getStatisticsCalendar();
    state = state.copyWith(isReached: _storage.isReached ?? false);
  }

  void changePage(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void touchCharacter() {}

  int bmiIndex() {
    final bmi = state.mainData.bodyBmi;
    if (bmi < 18.5) return 0;
    if (bmi < 25) return 1;
    if (bmi < 30) return 2;
    return 3;
  }

  String mainDataShow(int index) {
    final m = state.mainData;
    switch (index) {
      case 0:
        if (m.triCycleDuration == 0) return '00:00:00';
        return _formatSeconds(m.triCycleDuration);
      case 1:
        return m.triCycleStrength.toStringAsFixed(1);
      case 2:
        return m.triCycleCalorie.toString();
      default:
        return '0';
    }
  }

  String _formatSeconds(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  bool get isCn => _storage.languageNum == 0;

  String cardDataValue(int index) {
    final m = state.mainData;
    switch (index) {
      case 0:
        return m.todayCount.toString();
      case 1:
        return isCn ? m.bodyBmi.toStringAsFixed(1) : '';
      case 2:
        return state.myRank;
      case 3:
        return m.triCycleCalorie.toString();
      default:
        return '';
    }
  }
}