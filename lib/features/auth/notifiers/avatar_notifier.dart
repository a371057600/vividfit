import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_provider.dart';
import '../states/avatar_state.dart';

part 'avatar_notifier.g.dart';

@Riverpod(keepAlive: true)
class AvatarNotifier extends _$AvatarNotifier {
  @override
  AvatarState build() {
    _storage = ref.watch(storageServiceProvider);
    return _buildInitialState();
  }

  late StorageService _storage;

  AvatarState _buildInitialState() {
    final idx = _storage.selectedAvatarIndex ?? 0;
    final path = _storage.customAvatarPath ?? '';
    final isCustom = path.isNotEmpty;
    print('📷 [AvatarNotifier.init] idx=$idx isCustom=$isCustom path=$path');
    return AvatarState(
      selectedImageIndex: idx,
      customImagePath: path,
      isCustomImage: isCustom,
    );
  }

  /// 选择默认头像(0-19)。
  void selectDefaultAvatar(int index) {
    state = state.copyWith(
      selectedImageIndex: index,
      isCustomImage: false,
      customImagePath: '',
    );
    print('📷 [AvatarNotifier.selectDefault] index=$index');
  }

  /// 设置自定义图片路径(拍照/相册选择后)。
  void setCustomImage(String path) {
    state = state.copyWith(
      customImagePath: path,
      isCustomImage: true,
    );
    print('📷 [AvatarNotifier.setCustomImage] path=$path');
  }

  /// 确认选择 → 持久化到 SharedPreferences。
  Future<void> confirmSelection() async {
    state = state.copyWith(isLoading: true);
    if (state.isCustomImage) {
      await _storage.setCustomAvatarPath(state.customImagePath);
      await _storage.setSelectedAvatarIndex(-1);
    } else {
      await _storage.setSelectedAvatarIndex(state.selectedImageIndex);
      await _storage.setCustomAvatarPath('');
    }
    state = state.copyWith(isLoading: false);
    print('📷 [AvatarNotifier.confirm] idx=${state.selectedImageIndex} '
        'isCustom=${state.isCustomImage}');
  }
}
