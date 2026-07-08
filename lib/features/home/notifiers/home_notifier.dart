import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/storage_service.dart';
import '../repositories/home_repository.dart';
import '../states/home_state.dart';

/// 主页状态机(1:1 迁移自旧 HomeController + NewMainController 的状态逻辑)。
class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier(this._repo, this._storage) : super(const HomeState()) {
    _restoreFromStorage();
    _initData();
  }

  final HomeRepository _repo;
  final StorageService _storage;

  /// 启动时从本地存储恢复基础数据。
  void _restoreFromStorage() {
    var mainData = state.mainData;
    // 目标数据
    mainData = mainData.copyWith(
      goalCalorie: _storage.goalKcal,
      goalDuration: _storage.goalDuring,
      goalStrength: _storage.goalStrength,
    );
    // 身高体重 BMI
    final h = _storage.userHeight;
    final w = _storage.userWeight;
    final bmi = w / ((h / 100) * (h / 100));
    mainData = mainData.copyWith(bodyHeight: h, bodyWeight: w, bodyBmi: bmi);

    state = state.copyWith(
      mainData: mainData,
      nickName: _storage.username ?? 'UserName',
      headImageHash: _storage.headImageHash ?? '',
      selectedCharacterIndex: _storage.selectedCharacterIndex,
      myRank: _storage.myRank ?? '99',
      isReached: _storage.isReached ?? false,
      hasAiReport: _storage.hasAiReport,
      currentIndex: 0,
      isLoading: false,
    );
    _formatRecordDate();
  }

  void _formatRecordDate() {
    final d = DateTime.now();
    final m = d.month < 10 ? '0${d.month}' : '${d.month}';
    final day = d.day < 10 ? '0${d.day}' : '${d.day}';
    state = state.copyWith(
      mainData: state.mainData.copyWith(recordDate: '$m/$day'),
    );
  }

  /// 初始化数据(对应旧 initData)。
  Future<void> _initData() async {
    await _fetchStatistics();
    await _repo.getStatisticsCalendar();
    state = state.copyWith(isReached: _storage.isReached ?? false);
  }

  /// 拉取运动统计并整合(对应旧 getsportStatistics + integratedData)。
  Future<void> _fetchStatistics() async {
    final stats = await _repo.getSportStatistics();
    if (stats.code == '200') {
      final integrated = _repo.integrateStatistics(stats, state.mainData);
      state = state.copyWith(
        mainData: integrated.copyWith(isLoading: false, isLoading2: false),
      );
    } else {
      // token 过期,尝试刷新后重试一次
      final ok = await _repo.refreshToken();
      if (ok) {
        await _fetchStatistics();
      }
    }
  }

  /// 下拉刷新。
  Future<void> refresh() async {
    state = state.copyWith(
      mainData: state.mainData.copyWith(isLoading: true),
    );
    await _fetchStatistics();
    await _repo.getStatisticsCalendar();
    state = state.copyWith(isReached: _storage.isReached ?? false);
  }

  /// 切换底部 tab(对应旧 changePage)。
  void changePage(int index) {
    state = state.copyWith(currentIndex: index);
  }

  /// 点击动画人物(对应旧 touchAnmiation)。
  /// 旧项目用 30ms 递增 ainimationIndex2 到 123 再回到 1。
  /// 这里仅做触发标记,实际动画由 UI 用 AnimationController 实现。
  void touchCharacter() {
    // UI 层自行处理帧动画;此处保留方法签名供 UI 调用。
  }

  /// BMI 档位(0=偏瘦 1=正常 2=超重 3=肥胖),对应旧 bmiIndexSelect。
  int bmiIndex() {
    final bmi = state.mainData.bodyBmi;
    if (bmi < 18.5) return 0;
    if (bmi < 25) return 1;
    if (bmi < 30) return 2;
    return 3;
  }

  /// 主页三环显示值,对应旧 mainDataShow。
  /// index 0=时长 1=强度 2=卡路里。
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

  /// 主页卡片显示数据,对应旧 homePageWrapData。
  String homePageWrapData(int index) {
    final m = state.mainData;
    switch (index) {
      case 0:
        return m.todayCount.toString();
      case 1:
        return _storage.languageNum == 0 ? m.bodyBmi.toStringAsFixed(1) : '';
      case 2:
        return state.myRank;
      case 3:
        return m.triCycleCalorie.toString();
      case 4:
        return state.isReached ? 'Achieved' : 'Unachieved';
      case 5:
        if (_storage.languageNum == 0) {
          return state.hasAiReport ? 'Customized' : 'Unsatisfactory';
        }
        return '';
      default:
        return '';
    }
  }

  /// 主页卡片单位,对应旧 homePageUnit。
  String homePageUnit(int index) {
    switch (index) {
      case 0:
        return 'Times';
      case 1:
        return _storage.languageNum == 0 ? 'BMI' : '';
      case 2:
        return _storage.languageNum == 0 ? '名' : '';
      case 3:
        return 'Kcal';
      default:
        return '';
    }
  }
}
