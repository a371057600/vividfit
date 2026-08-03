import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../states/user_settings_state.dart';

part 'user_settings_notifier.g.dart';

@Riverpod(keepAlive: true)
class UserSettingsNotifier extends _$UserSettingsNotifier {
  @override
  UserSettingsState build() {
    return const UserSettingsState();
  }

  Future<void> loadData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      isLoading: false,
      nickName: 'TestUser',
      birthday: '2000-01-01',
      gander: true,
      bodyHeight: 175,
      bodyWeight: 70,
    );
  }

  void updateNickName(String name) {
    state = state.copyWith(nickName: name);
  }

  void updateBirthday(String date) {
    state = state.copyWith(birthday: date);
  }

  void updateGender(bool isMale) {
    state = state.copyWith(gander: isMale);
  }

  void updateHeight(int height) {
    state = state.copyWith(
      bodyHeight: height,
      heightPosition: height - 100,
    );
  }

  void updateWeight(int weight) {
    state = state.copyWith(
      bodyWeight: weight,
      weightPosition: weight - 40,
    );
  }

  void updateSelectedImageIndex(int index) {
    state = state.copyWith(selectedImageIndex: index);
  }

  void toggleUpdating(bool isUpdating) {
    state = state.copyWith(isUpdating: isUpdating);
  }
}