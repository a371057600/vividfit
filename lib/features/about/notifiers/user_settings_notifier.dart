import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_provider.dart';
import '../../auth/notifiers/auth_repository_provider.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../home/notifiers/home_notifier.dart';
import '../states/user_settings_state.dart';

part 'user_settings_notifier.g.dart';

@Riverpod(keepAlive: true)
class UserSettingsNotifier extends _$UserSettingsNotifier {
  @override
  UserSettingsState build() {
    _storage = ref.watch(storageServiceProvider);
    _repository = ref.watch(authRepositoryProvider);
    // 从本地缓存快速显示(对应旧项目 box.read 读取)
    final height = _storage.userHeight;
    final weight = _storage.userWeight;
    return UserSettingsState(
      isLoading: true,
      nickName: _storage.username ?? 'Nick',
      birthday: _storage.userBirthday,
      gander: _storage.userSex,
      bodyHeight: height,
      bodyWeight: weight,
      heightPosition: height - 100,
      weightPosition: weight - 40,
      headImage: _storage.headImageHash ?? '',
      selectedImageIndex: _storage.selectedCharacterIndex,
    );
  }

  late StorageService _storage;
  late AuthRepository _repository;

  /// 从服务器拉取最新用户信息(对应旧项目 getUserInfo)。
  Future<void> loadData() async {
    final userId = _storage.userId;
    final token = _storage.accessToken;
    if (userId == null) {
      print('🎯 [UserSettings] loadData: no userId, skip');
      state = state.copyWith(isLoading: false);
      return;
    }
    print('🎯 [UserSettings] loadData: userId=$userId token=$token');
    try {
      final info = await _repository.getUserInfo(userId);
      if (info != null) {
        final height = info.height ?? state.bodyHeight;
        final weight = info.weight ?? state.bodyWeight;
        final nickName = info.nickName ?? state.nickName;
        final birthday = info.birthday ?? state.birthday;
        final sex = info.sex ?? state.gander;
        // headImage 为完整 URL(新 API 直接返回链接),可能为 "null" 字符串
        final rawHead = info.headImage ?? '';
        final headImage = rawHead.isEmpty || rawHead == 'null' ? '' : rawHead;
        // 打印头像原始值(完整 URL,不拼接)
        print('🖼️ [UserSettings] headImage raw="$headImage"');

        state = state.copyWith(
          isLoading: false,
          nickName: nickName,
          birthday: birthday,
          gander: sex,
          bodyHeight: height,
          bodyWeight: weight,
          heightPosition: height - 100,
          weightPosition: weight - 40,
          headImage: headImage,
        );
        // 同步到本地缓存(对应旧项目 box.write)
        await _storage.setUsername(nickName);
        await _storage.setUserBirthday(birthday);
        await _storage.setUserSex(sex);
        await _storage.setUserHeight(height);
        await _storage.setUserWeight(weight);
        await _storage.setHeadImageHash(headImage);
        print(
          '🎯 [UserSettings] loadData: success '
          'nickName=$nickName height=$height weight=$weight headImage=$headImage',
        );
      } else {
        state = state.copyWith(isLoading: false);
        print('🎯 [UserSettings] loadData: getUserInfo returned null');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('❌ [UserSettings] loadData error: $e');
    }
  }

  void updateNickName(String name) {
    state = state.copyWith(nickName: name);
    print('🎯 [UserSettings] updateNickName: $name');
    unawaited(_persistAndSync());
  }

  void updateBirthday(String date) {
    state = state.copyWith(birthday: date);
    print('🎯 [UserSettings] updateBirthday: $date');
    unawaited(_persistAndSync());
  }

  void updateGender(bool isMale) {
    state = state.copyWith(gander: isMale);
    print('🎯 [UserSettings] updateGender: ${isMale ? 'male' : 'female'}');
    unawaited(_persistAndSync());
  }

  void updateHeight(int height) {
    state = state.copyWith(bodyHeight: height, heightPosition: height - 100);
    print('🎯 [UserSettings] updateHeight: $height');
    unawaited(_persistAndSync());
  }

  void updateWeight(int weight) {
    state = state.copyWith(bodyWeight: weight, weightPosition: weight - 40);
    print('🎯 [UserSettings] updateWeight: $weight');
    unawaited(_persistAndSync());
  }

  void updateSelectedImageIndex(int index) {
    state = state.copyWith(selectedImageIndex: index);
    _storage.setSelectedCharacterIndex(index);
    print('🎯 [Character] selected character index: $index');
    ref.read(homeProvider.notifier).syncSelectedCharacter(index);
  }

  void toggleUpdating(bool isUpdating) {
    state = state.copyWith(isUpdating: isUpdating);
  }

  /// 同步到本地缓存 + 服务器(对应旧项目 updateInofo)。
  /// 每次修改单字段都发完整 payload,与旧项目行为一致。
  Future<void> _persistAndSync() async {
    // 同步本地缓存
    await _storage.setUsername(state.nickName);
    await _storage.setUserBirthday(state.birthday);
    await _storage.setUserSex(state.gander);
    await _storage.setUserHeight(state.bodyHeight);
    await _storage.setUserWeight(state.bodyWeight);

    // 同步服务器(PUT /api/user/info)
    final userId = _storage.userId;
    if (userId == null) {
      print('⚠️ [UserSettings] sync: no userId, skip server sync');
      return;
    }
    final payload = {
      'birthday': state.birthday,
      'height': state.bodyHeight,
      'id': userId,
      'nickName': state.nickName,
      'sex': state.gander,
      'weight': state.bodyWeight,
    };
    try {
      final ok = await _repository.updateUserInfo(payload);
      print('🎯 [UserSettings] syncToServer ok=$ok payload=$payload');
    } catch (e) {
      print('❌ [UserSettings] syncToServer error: $e');
    }
  }

  // ============ 头像上传(对应旧项目 controller_about_user_head) ============

  /// 拍照(对应旧项目 checkPermission + takePhoto)。
  /// 权限检查 → ImagePicker(camera) → 返回图片路径(用于跳裁剪页)。
  /// 返回 null 表示无权限或用户取消。
  Future<String?> takePhoto() async {
    print('📷 [Avatar] takePhoto: checking camera permission...');
    // 1. 相机权限检查(对照旧项目 checkPermission)
    var cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) {
      print('📷 [Avatar] camera permission denied, requesting...');
      // Android 额外提示(对照旧项目 Get.snackbar)
      if (Platform.isAndroid) {
        print('📷 [Avatar] Android: showing permission rationale');
      }
      cameraStatus = await Permission.camera.request();
    }
    if (cameraStatus.isDenied || cameraStatus.isPermanentlyDenied) {
      print('❌ [Avatar] camera permission permanently denied');
      return null;
    }
    // 2. 调用相机(对照旧项目 picker.pickImage(source: camera))
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      print('📷 [Avatar] camera: user cancelled');
      return null;
    }
    print('📷 [Avatar] camera captured: ${image.path}');
    return image.path;
  }

  /// 从相册选图(对应旧项目 pickImage)。
  /// 权限检查 → ImagePicker(gallery) → 返回图片路径(用于跳裁剪页)。
  /// 返回 null 表示无权限或用户取消。
  Future<String?> pickImageFromGallery() async {
    print('📷 [Avatar] pickImageFromGallery: checking photo permission...');
    // 1. 相册权限检查(Android 13+ 用 Permission.photos,12- 用 Permission.storage)
    PermissionStatus photoStatus;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        photoStatus = await Permission.photos.status;
        if (photoStatus.isDenied) {
          photoStatus = await Permission.photos.request();
        }
      } else {
        photoStatus = await Permission.storage.status;
        if (photoStatus.isDenied) {
          photoStatus = await Permission.storage.request();
        }
      }
    } else {
      // iOS
      photoStatus = await Permission.photos.status;
      if (photoStatus.isDenied) {
        photoStatus = await Permission.photos.request();
      }
    }
    if (photoStatus.isPermanentlyDenied) {
      print('❌ [Avatar] photo permission permanently denied');
      return null;
    }
    // 2. 调用相册(对照旧项目 picker.pickImage(source: gallery))
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      print('📷 [Avatar] gallery: user cancelled');
      return null;
    }
    print('📷 [Avatar] gallery picked: ${image.path}');
    return image.path;
  }

  /// 设置裁剪后的待上传图片路径(裁剪页返回后调用)。
  /// 此时不上传,仅存路径,等用户点"确认"按钮才上传。
  /// 对照旧项目: ImageTest 返回 saveFile → imagePickFile.value = saveFile → 不立即上传。
  void setPendingUploadPath(String croppedFilePath) {
    print('🖼️ [Avatar] pending upload path: $croppedFilePath');
    state = state.copyWith(imagePickFile: croppedFilePath);
    _storage.setSaveFile(croppedFilePath);
  }

  /// 确认上传(对应旧项目确认按钮 updateInsetImage / 返回按钮 updateUserImage)。
  /// 优先上传裁剪后的自定义头像(imagePickFile 有值);
  /// 无自定义头像则上传当前选中的默认头像 asset。
  /// 上传成功后重新拉取用户信息刷新 headImage(对应旧项目 getData2)。
  /// [onSendProgress] 上传进度回调(sent已发送,total总大小)。
  Future<bool> confirmUpload({
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final userId = _storage.userId;
    final token = _storage.accessToken;
    if (userId == null || token == null) {
      print('❌ [Avatar] confirmUpload: no userId/token');
      return false;
    }
    state = state.copyWith(isUpdating: true);
    try {
      bool ok;
      if (state.imagePickFile.isNotEmpty) {
        // 上传裁剪后的自定义头像(对照旧项目 updateUserImage)
        print('📤 [Avatar] confirmUpload: custom file=${state.imagePickFile}');
        final file = File(state.imagePickFile);
        ok = await _repository.uploadHeadImage(
          imageFile: file,
          userId: userId,
          accessToken: token,
          onSendProgress: onSendProgress,
        );
      } else {
        // 上传默认头像 asset(对照旧项目 saveImageLocal + updateInsetImage)
        final assetPath =
            'images/newUIScreen/defaultheadimages/deheadImage${state.selectedImageIndex + 1}.jpg';
        print('📤 [Avatar] confirmUpload: default asset=$assetPath');
        final byteData = await rootBundle.load(assetPath);
        ok = await _repository.uploadAssetHeadImage(
          assetBytes: byteData,
          assetPath: assetPath,
          userId: userId,
          accessToken: token,
          onSendProgress: onSendProgress,
        );
      }
      if (ok) {
        print('✅ [Avatar] upload success, refreshing user info...');
        // 上传后重新拉取用户信息刷新 headImage(对照旧项目 getData2)
        await loadData();
        // 清除待上传路径
        state = state.copyWith(isUpdating: false, imagePickFile: '');
        return true;
      } else {
        state = state.copyWith(isUpdating: false);
        return false;
      }
    } catch (e) {
      print('❌ [Avatar] confirmUpload error: $e');
      state = state.copyWith(isUpdating: false);
      return false;
    }
  }
}
