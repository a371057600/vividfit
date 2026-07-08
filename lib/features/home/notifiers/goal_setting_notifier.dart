import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/providers.dart';
import '../../../core/services/storage_service.dart';
import '../states/goal_setting_state.dart';

class GoalSettingNotifier extends StateNotifier<GoalSettingState> {
  GoalSettingNotifier(this._storage) : super(const GoalSettingState()) {
    _restore();
  }

  final StorageService _storage;

  Future<void> _restore() async {
    final firstIdx = _storage.firstSettingIndex ?? 0;
    final secondIdx = _storage.secondSettingIndex ?? 0;
    final goalD = _storage.goalDuring;
    final goalK = _storage.goalKcal;
    final goalS = _storage.goalStrength;
    state = state.copyWith(
      sportTypeSelectIndex: firstIdx,
      sportTypeSelectIndex2: secondIdx,
      goalDuring: goalD,
      goalKcal: goalK,
      goalStrength: goalS,
      isLoading: false,
    );
  }

  /// 从路由参数初始化实际运动数据。
  void setRealData({required int realKcal, required double realStrength, required int realDuring}) {
    state = state.copyWith(
      sportKcal: realKcal,
      sportStrength: realStrength,
      sportDuring: realDuring,
    );
  }

  void selectType(int first, int second) {
    state = state.copyWith(sportTypeSelectIndex: first, sportTypeSelectIndex2: second);
    _storage.setFirstSettingIndex(first);
    _storage.setSecondSettingIndex(second);
  }

  /// 保存目标(对应旧 box.write goalD/K/S)。
  Future<void> saveGoal({required int during, required int kcal, required double strength}) async {
    await _storage.setGoalDuring(during);
    await _storage.setGoalKcal(kcal);
    await _storage.setGoalStrength(strength);
    state = state.copyWith(goalDuring: during, goalKcal: kcal, goalStrength: strength);
  }
}

final goalSettingNotifierProvider =
    StateNotifierProvider<GoalSettingNotifier, GoalSettingState>((ref) {
  return GoalSettingNotifier(ref.watch(storageServiceProvider));
});
