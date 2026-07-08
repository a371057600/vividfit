import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/providers.dart';
import '../../../core/services/storage_service.dart';
import '../states/goal_setting_state.dart';

/// 运动目标设置状态机(1:1 迁移自旧 GoalSettingController)。
///
/// 保留旧控制器的 9 档预设值(goalDurationList/goalStrengthList/goalKcalList)
/// 与运动类型/子类型映射,选择类型时自动套用对应预设。
class GoalSettingNotifier extends StateNotifier<GoalSettingState> {
  GoalSettingNotifier(this._storage) : super(const GoalSettingState()) {
    _restore();
  }

  final StorageService _storage;

  // ---- 静态数据(对应旧 GoalSettingController 的常量列表)----

  /// 3 大运动类型。
  static const sportTypeList = ['Aerobic', 'Anaerobic', 'Rehab'];

  /// 每个类型下的 3 个子档位。
  static const sportTypeSlecet = {
    'Aerobic': ['Basic', 'Moderate', 'HIIT'],
    'Anaerobic': ['Strength', 'Shaping', 'Power'],
    'Rehab': ['Stage 1', 'Stage 2', 'Stage 3'],
  };

  /// 类型说明文本(对应旧 sportContent)。
  static const sportContent = {
    'Aerobic':
        'Oxygen-based endurance exercises: running, swimming, cycling, aerobics, ball games',
    'Anaerobic':
        'High-intensity strength training: weightlifting, resistance training, push-ups, squats, sprints, planks',
    'Rehab':
        'Recovery exercises: phased training for injuries, cardiac rehab under medical supervision',
  };

  /// 子档位说明文本(对应旧 sportAreaText)。
  static const sportAreaText = {
    'Basic': 'Seniors/Pregnant/Rehab',
    'Moderate': 'General fitness/Weight loss',
    'HIIT': 'Advanced fitness/Busy schedules',
    'Strength': 'Builds strength & bone density',
    'Shaping': 'Shapes muscles & posture',
    'Power': 'Explosive power training: sprints, box jumps',
    'Stage 1': 'Prevents muscle atrophy, maintains mobility',
    'Stage 2': 'Strengthens joints & stability',
    'Stage 3': 'Restores daily functions',
  };

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
      sportTypeSelectSubIndexString:
          sportTypeSlecet[sportTypeList[firstIdx]]![secondIdx],
      goalDuring: goalD,
      goalKcal: goalK,
      goalStrength: goalS,
      isLoading: false,
    );
  }

  /// 从路由参数初始化实际运动数据(对应旧 Get.arguments)。
  void setRealData({
    required int realKcal,
    required double realStrength,
    required int realDuring,
  }) {
    state = state.copyWith(
      sportKcal: realKcal,
      sportStrength: realStrength,
      sportDuring: realDuring,
    );
  }

  /// 组合索引(0..8),对应旧 getGoalSportTypeSelectIndex。
  int getGoalSportTypeSelectIndex() {
    final first = state.sportTypeSelectIndex;
    final second = state.sportTypeSelectIndex2;
    if (first >= 0 && first <= 2 && second >= 0 && second <= 2) {
      return first * 3 + second;
    }
    return 0;
  }

  /// 选择运动类型 + 子档位,并套用对应 9 档预设(对应旧 selectGoalDate)。
  void selectType(int first, int second) {
    final sub = sportTypeSlecet[sportTypeList[first]]![second];
    final idx = first * 3 + second;
    state = state.copyWith(
      sportTypeSelectIndex: first,
      sportTypeSelectIndex2: second,
      sportTypeSelectSubIndexString: sub,
      goalDuring: goalDurationList[idx],
      goalStrength: goalStrengthList[idx],
      goalKcal: goalKcalList[idx],
    );
  }

  /// 语言对应的图片目录(对应旧 getLanguageType)。
  String getLanguageType() {
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

  /// 保存目标(对应旧 getBackAndWriteGoal,持久化目标值与索引)。
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
