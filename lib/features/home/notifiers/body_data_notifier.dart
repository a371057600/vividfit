import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/storage_service_provider.dart';
import '../../../core/services/storage_service.dart';
import '../states/body_data_state.dart';

/// 身体数据状态机(1:1 迁移自旧 BodyDataController 的本地状态部分)。
///
/// 网络上传 PUT 接口在后续 user 模块补齐,本阶段只做本地存储 + UI 状态。
class BodyDataNotifier extends StateNotifier<BodyDataState> {
  BodyDataNotifier(this._storage) : super(const BodyDataState()) {
    _restore();
  }

  final StorageService _storage;

  void _restore() {
    final b = _storage.userBirthday;
    final d = DateTime.parse(b);
    final height = _storage.userHeight;
    final weight = _storage.userWeight;
    state = state.copyWith(
      nickName: _storage.username ?? 'UserName',
      birthday: b,
      sexValue: _storage.userSex,
      bodyHeight: height,
      bodyWeight: weight,
      bodyAgeYear: d.year.toString(),
      bodyAgeMonth: d.month.toString().padLeft(2, '0'),
      bodyAgeDay: d.day.toString().padLeft(2, '0'),
      // picker 起始位置:身高 100~240 → position = height - 100;体重 40~200 → position = weight - 40
      heightPosition: (height - 100).clamp(0, 140),
      weightPosition: (weight - 40).clamp(0, 160),
    );
  }

  void setSex(bool v) => state = state.copyWith(sexValue: v);

  /// 滚动选择器临时位置(未确认前不写回 bodyHeight/bodyWeight)。
  void setHeightPosition(int v) =>
      state = state.copyWith(heightPosition: v);
  void setWeightPosition(int v) =>
      state = state.copyWith(weightPosition: v);

  /// 确认身高:position → bodyHeight。
  void confirmHeight() =>
      state = state.copyWith(bodyHeight: state.heightPosition + 100);

  /// 确认体重:position → bodyWeight。
  void confirmWeight() =>
      state = state.copyWith(bodyWeight: state.weightPosition + 40);

  /// 取消身高选择:恢复 position 到当前 bodyHeight。
  void resetHeightPosition() =>
      state = state.copyWith(heightPosition: state.bodyHeight - 100);

  /// 日期选择器回调。
  void setDate({required String year, required String month, required String day}) {
    state = state.copyWith(bodyAgeYear: year, bodyAgeMonth: month, bodyAgeDay: day);
  }

  /// 校验生日不能晚于今天(对应旧 compareData)。
  /// 返回 null 表示通过,否则返回错误提示。
  String? compareDate() {
    final today = DateTime.now();
    final inputDate = DateTime(
      int.parse(state.bodyAgeYear),
      int.parse(state.bodyAgeMonth),
      int.parse(state.bodyAgeDay),
    );
    if (inputDate.isAfter(today)) {
      return 'Please select date before today';
    }
    final birthday =
        '${state.bodyAgeYear}-${state.bodyAgeMonth.padLeft(2, '0')}-${state.bodyAgeDay.padLeft(2, '0')}';
    state = state.copyWith(birthday: birthday);
    return null;
  }

  /// 保存(对应旧 updateInofo 的本地存储部分,网络 PUT 留待 user 模块)。
  Future<void> save() async {
    await _storage.setUserHeight(state.bodyHeight);
    final w = state.bodyWeight < 20 ? 20 : state.bodyWeight;
    await _storage.setUserWeight(w);
    await _storage.setUserSex(state.sexValue);
    final b =
        '${state.bodyAgeYear}-${state.bodyAgeMonth.padLeft(2, '0')}-${state.bodyAgeDay.padLeft(2, '0')}';
    await _storage.setUserBirthday(b);
  }
}

final bodyDataNotifierProvider =
    StateNotifierProvider<BodyDataNotifier, BodyDataState>((ref) {
  return BodyDataNotifier(ref.watch(storageServiceProvider));
});
