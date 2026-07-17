import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/storage_service_provider.dart';
import '../../../core/services/storage_service.dart';
import '../states/goal_setting_state.dart';

part 'goal_setting_notifier.g.dart';

/// 运动目标设置状态机(1:1 迁移自旧 GoalSettingController)。
///
/// 仅保留数据逻辑(索引/预设值/持久化),显示文本由 UI 层用 l10n 渲染。
@riverpod
class GoalSettingNotifier extends _$GoalSettingNotifier {
  @override
  GoalSettingState build() {
    _storage = ref.watch(storageServiceProvider);
    return _buildInitialState();
  }

  late StorageService _storage;

  static const goalDurationList = [50, 35, 25, 50, 65, 25, 45, 75, 90];
  static const goalStrengthList = [3.0, 9.0, 7.0, 7.0, 6.0, 9.0, 5.0, 2.5, 6.0];
  static const goalKcalList = [165, 345, 400, 400, 400, 325, 125, 400, 600];

  GoalSettingState _buildInitialState() {
    final firstIdx = _storage.firstSettingIndex ?? 0;
    final secondIdx = _storage.secondSettingIndex ?? 0;
    final goalD = _storage.goalDuring;
    final goalK = _storage.goalKcal;
    final goalS = _storage.goalStrength;
    return GoalSettingState(
      sportTypeSelectIndex: firstIdx,
      sportTypeSelectIndex2: secondIdx,
      sportTypeSelectSubIndexString: '$firstIdx-$secondIdx',
      goalDuring: goalD,
      goalKcal: goalK,
      goalStrength: goalS,
      isLoading: false,
    );
  }

  int goalSportTypeSelectIndex() {
    final first = state.sportTypeSelectIndex;
    final second = state.sportTypeSelectIndex2;
    if (first >= 0 && first <= 2 && second >= 0 && second <= 2) {
      return first * 3 + second;
    }
    return 0;
  }

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

  Future<void> saveGoal() async {
    await _storage.setGoalDuring(state.goalDuring);
    await _storage.setGoalKcal(state.goalKcal);
    await _storage.setGoalStrength(state.goalStrength);
    await _storage.setFirstSettingIndex(state.sportTypeSelectIndex);
    await _storage.setSecondSettingIndex(state.sportTypeSelectIndex2);
  }
}
