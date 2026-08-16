import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/home_repository_provider.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_provider.dart';
import '../../../data/models/new_main_data.dart';
import '../repositories/home_repository.dart';
import '../states/home_state.dart';

part 'home_notifier.g.dart';

@Riverpod(keepAlive: true)
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    _repo = ref.watch(homeRepositoryProvider);
    _storage = ref.watch(storageServiceProvider);
    // 进入主页时打印 token(便于调试)
    print('🏠 [Home] enter, userId=${_storage.userId}, token=${_storage.accessToken}');
    final state = _buildInitialState();
    _initData();
    _animationTimer = Timer.periodic(
      const Duration(milliseconds: 30),
      (_) => _onAnimationTick(),
    );
    _touchLockTimer = Timer(const Duration(seconds: 6), _resetTouchLock);
    ref.onDispose(() {
      _animationTimer?.cancel();
      _touchLockTimer?.cancel();
    });
    return state;
  }

  late HomeRepository _repo;
  late StorageService _storage;
  Timer? _animationTimer;
  Timer? _touchLockTimer;
  bool _isAnimating = false;

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

    final isCn = _storage.languageNum == 0 || _storage.languageNum == 2;
    return HomeState(
      mainData: mainData.copyWith(isLoading: false, isLoading2: false),
      nickName: _storage.username ?? (isCn ? '用户' : 'User'),
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
    state = state.copyWith(mainData: state.mainData.copyWith(isLoading: true));
    await _fetchStatistics();
    await _repo.getStatisticsCalendar();
    state = state.copyWith(isReached: _storage.isReached ?? false);
  }

  void changePage(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void syncSelectedCharacter(int index) {
    state = state.copyWith(
      selectedCharacterIndex: index,
      animationIndex: 1,
      allowTouch: true,
    );
    _isAnimating = false;
    print('🎯 [Character] home sync character: $index, animation reset');
  }

  void touchCharacter() {
    if (!state.allowTouch) {
      print('🔒 [Animation] touch locked, ignored');
      return;
    }
    print('🎬 [Animation] touchCharacter triggered');
    _isAnimating = true;
    state = state.copyWith(allowTouch: false);
    _touchLockTimer?.cancel();
    _touchLockTimer = Timer(const Duration(seconds: 6), _resetTouchLock);
  }

  void _onAnimationTick() {
    if (!_isAnimating) return;
    final currentIndex = state.animationIndex;
    if (currentIndex >= 123) {
      print('🎬 [Animation] animation completed, reset to frame 1');
      state = state.copyWith(animationIndex: 1);
      _isAnimating = false;
    } else {
      state = state.copyWith(animationIndex: currentIndex + 1);
    }
  }

  void _resetTouchLock() {
    state = state.copyWith(allowTouch: true);
  }

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

  /// 按 key 获取卡片数据值, 用于配置化卡片网格
  String cardDataValueByKey(String key) {
    final m = state.mainData;
    switch (key) {
      case 'exerciseRecord':
        return m.todayCount.toString();
      case 'bodyData':
      case 'bodyMassIndex':
        return isCn ? m.bodyBmi.toStringAsFixed(1) : '';
      case 'burnRank':
      case 'ranks':
        return state.myRank;
      case 'todaysBurn':
      case 'kcalCons':
        return m.triCycleCalorie.toString();
      default:
        return '';
    }
  }
}
