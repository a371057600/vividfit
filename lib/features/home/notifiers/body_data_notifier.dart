import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/providers.dart';
import '../../../core/services/storage_service.dart';
import '../states/body_data_state.dart';

class BodyDataNotifier extends StateNotifier<BodyDataState> {
  BodyDataNotifier(this._storage) : super(const BodyDataState()) {
    _restore();
  }

  final StorageService _storage;

  void _restore() {
    final b = _storage.userBirthday;
    final d = DateTime.parse(b);
    state = state.copyWith(
      nickName: _storage.username ?? 'UserName',
      birthday: b,
      sexValue: _storage.userSex,
      bodyHeight: _storage.userHeight,
      bodyWeight: _storage.userWeight,
      bodyAgeYear: d.year.toString(),
      bodyAgeMonth: d.month.toString().padLeft(2, '0'),
      bodyAgeDay: d.day.toString().padLeft(2, '0'),
    );
  }

  void setSex(bool v) => state = state.copyWith(sexValue: v);
  void setHeight(int v) => state = state.copyWith(bodyHeight: v);
  void setWeight(int v) => state = state.copyWith(bodyWeight: v);
  void setDate({required String year, required String month, required String day}) {
    state = state.copyWith(bodyAgeYear: year, bodyAgeMonth: month, bodyAgeDay: day);
  }

  /// 保存(对应旧 updateInofo,本地存储 + 调 PUT 接口)。
  /// 本阶段只存本地,接口在后续 user 模块补。
  Future<void> save() async {
    await _storage.setUserHeight(state.bodyHeight);
    await _storage.setUserWeight(state.bodyWeight);
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
