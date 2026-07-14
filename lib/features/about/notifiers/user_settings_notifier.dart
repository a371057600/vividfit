import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/user_settings_state.dart';

class UserSettingsNotifier extends StateNotifier<UserSettingsState> {
  UserSettingsNotifier() : super(const UserSettingsState());

  // 模拟数据加载 (暂不接通云端)
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

  // 更新昵称
  void updateNickName(String name) {
    state = state.copyWith(nickName: name);
  }

  // 更新生日
  void updateBirthday(String date) {
    state = state.copyWith(birthday: date);
  }

  // 更新性别
  void updateGender(bool isMale) {
    state = state.copyWith(gander: isMale);
  }

  // 更新身高
  void updateHeight(int height) {
    state = state.copyWith(
      bodyHeight: height,
      heightPosition: height - 100,
    );
  }

  // 更新体重
  void updateWeight(int weight) {
    state = state.copyWith(
      bodyWeight: weight,
      weightPosition: weight - 40,
    );
  }

  // 更新头像索引
  void updateSelectedImageIndex(int index) {
    state = state.copyWith(selectedImageIndex: index);
  }

  // 切换更新状态
  void toggleUpdating(bool isUpdating) {
    state = state.copyWith(isUpdating: isUpdating);
  }
}
