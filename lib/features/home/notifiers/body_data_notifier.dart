import 'package:riverpod/riverpod.dart';

import '../../../core/services/storage_service_provider.dart';
import '../../../core/services/storage_service.dart';
import '../states/body_data_state.dart';

class BodyDataNotifier extends Notifier<BodyDataState> {
  @override
  BodyDataState build() {
    _storage = ref.watch(storageServiceProvider);
    return _buildInitialState();
  }

  late StorageService _storage;

  BodyDataState _buildInitialState() {
    final b = _storage.userBirthday;
    final d = DateTime.parse(b);
    final height = _storage.userHeight;
    final weight = _storage.userWeight;
    return BodyDataState(
      nickName: _storage.username ?? 'UserName',
      birthday: b,
      sexValue: _storage.userSex,
      bodyHeight: height,
      bodyWeight: weight,
      bodyAgeYear: d.year.toString(),
      bodyAgeMonth: d.month.toString().padLeft(2, '0'),
      bodyAgeDay: d.day.toString().padLeft(2, '0'),
      heightPosition: (height - 100).clamp(0, 140),
      weightPosition: (weight - 40).clamp(0, 160),
    );
  }

  void setSex(bool v) => state = state.copyWith(sexValue: v);

  void setHeightPosition(int v) =>
      state = state.copyWith(heightPosition: v);
  void setWeightPosition(int v) =>
      state = state.copyWith(weightPosition: v);

  void confirmHeight() =>
      state = state.copyWith(bodyHeight: state.heightPosition + 100);

  void confirmWeight() =>
      state = state.copyWith(bodyWeight: state.weightPosition + 40);

  void resetHeightPosition() =>
      state = state.copyWith(heightPosition: state.bodyHeight - 100);

  void setDate({required String year, required String month, required String day}) {
    state = state.copyWith(bodyAgeYear: year, bodyAgeMonth: month, bodyAgeDay: day);
  }

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