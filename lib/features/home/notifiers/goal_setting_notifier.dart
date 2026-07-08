import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/providers.dart';
import '../../../core/services/storage_service.dart';
import '../states/goal_setting_state.dart';

/// 运动目标设置状态机(1:1 迁移自旧 GoalSettingController)。
///
/// 仅保留数据逻辑(索引/预设值/持久化),显示文本由 UI 层用 l10n 渲染。
class GoalSettingNotifier extends StateNotifier<GoalSettingState> {
  GoalSettingNotifier(this._storage) : super(const GoalSettingState()) {
    _restore();
  }

  final StorageService _storage;

  /// 9 档预设(索引 = first*3 + second):时长 / 强度 / 卡路里。
  static const goalDurationList = [50, 35, 25, 50, 65, 25, 45, 75, 90];
  static const goalStrengthList = [3.0, 9.0, 7.0, 7.0, 6.0, 9.0, 5.0, 2.5, 6.0];
  static const goalKcalList = [165, 345, 400, 400, 400, 325, 125, 400, 600];

  Future<void> _restore() async {
    final firstIdx = _storage.firstSettingIndex ?? 0;
    final secondIdx = _storage.secondSettingIndex ?? 0;
    final goalD = _storage.goalDuring;
    final goalK = _storage.goalKcal;
    final goalS = _storage.goalStrength;
    state = state.copyWith(
      sportTypeSelectIndex: firstIdx,
      sportTypeSelectIndex2: secondIdx,
      sportTypeSelectSubIndexString: '$firstIdx-$secondIdx',
      goalDuring: goalD,
      goalKcal: goalK,
      goalStrength: goalS,
      isLoading: false,
    );
  }

  /// 组合索引(0..8)。
  int goalSportTypeSelectIndex() {
    final first = state.sportTypeSelectIndex;
    final second = state.sportTypeSelectIndex2;
    if (first >= 0 && first <= 2 && second >= 0 && second <= 2) {
      return first * 3 + second;
    }
    return 0;
  }

  /// 选择运动类型 + 子档位,并套用对应 9 档预设。
  void selectType(int first, int second) {
    final idx = first * 3 + second;
    state = state.copyWith(
      sportTypeSelectIndex: first,
      sportTypeSelectIndex2: second,
      sportTypeSelectSubIndexString: '$first-$second',
      goalDuring: goalDurationList[idx],
      goalStrength: goalStrengthList[idx],
      goalKcal: goalKcalList[idx],
    );
  }

  /// 语言对应的图片目录。
  String languageType() {
    switch (_storage.languageNum) {
      case 0:
        return 'cn';
      case 1:
        return 'en';
      case 2:
        return 'hant';
      case 6:
        return 'de';
      default:
        return 'en';
    }
  }

  /// 保存目标(持久化目标值与索引)。
  Future<void> saveGoal() async {
    await _storage.setGoalDuring(state.goalDuring);
    await _storage.setGoalKcal(state.goalKcal);
    await _storage.setGoalStrength(state.goalStrength);
    await _storage.setFirstSettingIndex(state.sportTypeSelectIndex);
    await _storage.setSecondSettingIndex(state.sportTypeSelectIndex2);
  }
}

final goalSettingNotifierProvider =
    StateNotifierProvider<GoalSettingNotifier, GoalSettingState>((ref) {
  return GoalSettingNotifier(ref.watch(storageServiceProvider));
});
