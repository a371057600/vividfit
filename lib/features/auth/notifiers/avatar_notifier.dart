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
import '../repositories/auth_repository.dart';
import 'auth_repository_provider.dart';
import '../states/avatar_state.dart';

part 'avatar_notifier.g.dart';

@Riverpod(keepAlive: true)
class AvatarNotifier extends _$AvatarNotifier {
  @override
  AvatarState build() {
    _storage = ref.watch(storageServiceProvider);
    _repository = ref.watch(authRepositoryProvider);
    return _buildInitialState();
  }

  late StorageService _storage;
  late AuthRepository _repository;

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

  /// 选择默认头像(0-19)。同时清除自定义待上传路径,预览回到默认头像。
  void selectDefaultAvatar(int index) {
    state = state.copyWith(
      selectedImageIndex: index,
      isCustomImage: false,
      customImagePath: '',
      imagePickFile: '',
    );
    print('📷 [AvatarNotifier.selectDefault] index=$index');
  }

  /// 设置自定义图片路径(拍照/相册选择后,未裁剪前的原始路径)。
  void setCustomImage(String path) {
    state = state.copyWith(
      customImagePath: path,
      isCustomImage: true,
    );
    print('📷 [AvatarNotifier.setCustomImage] path=$path');
  }

  /// 设置裁剪后的待上传图片路径(裁剪页返回后调用)。
  /// 此时不上传,仅存路径,等用户点"确认/下一步"才上传。
  /// 对照 UserSettingsNotifier.setPendingUploadPath。
  void setPendingUploadPath(String croppedFilePath) {
    print('🖼️ [AvatarNotifier.pendingUpload] path=$croppedFilePath');
    state = state.copyWith(
      imagePickFile: croppedFilePath,
      isCustomImage: true,
    );
    _storage.setSaveFile(croppedFilePath);
  }

  // ============ 头像上传(对照 UserSettingsNotifier,逻辑等价) ============

  /// 拍照(对照旧项目 checkPermission + takePhoto)。
  /// 权限检查 → ImagePicker(camera) → 返回图片路径(用于跳裁剪页)。
  /// 返回 null 表示无权限或用户取消。
  Future<String?> takePhoto() async {
    print('📷 [Avatar] takePhoto: checking camera permission...');
    var cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) {
      print('📷 [Avatar] camera permission denied, requesting...');
      cameraStatus = await Permission.camera.request();
    }
    if (cameraStatus.isDenied || cameraStatus.isPermanentlyDenied) {
      print('❌ [Avatar] camera permission permanently denied');
      return null;
    }
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      print('📷 [Avatar] camera: user cancelled');
      return null;
    }
    print('📷 [Avatar] camera captured: ${image.path}');
    return image.path;
  }

  /// 从相册选图(对照旧项目 pickImage)。
  /// 权限检查(Android 13+ 用 photos,12- 用 storage;iOS 用 photos) → ImagePicker(gallery) → 返回路径。
  /// 返回 null 表示无权限或用户取消。
  Future<String?> pickImageFromGallery() async {
    print('📷 [Avatar] pickImageFromGallery: checking photo permission...');
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
      photoStatus = await Permission.photos.status;
      if (photoStatus.isDenied) {
        photoStatus = await Permission.photos.request();
      }
    }
    if (photoStatus.isPermanentlyDenied) {
      print('❌ [Avatar] photo permission permanently denied');
      return null;
    }
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      print('📷 [Avatar] gallery: user cancelled');
      return null;
    }
    print('📷 [Avatar] gallery picked: ${image.path}');
    return image.path;
  }

  /// 确认上传(对照 UserSettingsNotifier.confirmUpload,注册流程版)。
  /// 优先上传裁剪后的自定义头像(imagePickFile 有值);
  /// 无自定义头像则上传当前选中的默认头像 asset。
  /// 上传成功后本地持久化 + 清空待上传路径,返回 true。
  /// 注册流程差异:不调用 loadData 刷新(新用户未进主页,由主页/设置页自行拉取)。
  Future<bool> confirmUpload({
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final userId = _storage.userId;
    final token = _storage.accessToken;
    if (userId == null || token == null) {
      print('❌ [Avatar] confirmUpload: no userId/token');
      return false;
    }
    state = state.copyWith(isLoading: true);
    try {
      bool ok;
      if (state.imagePickFile.isNotEmpty) {
        // 上传裁剪后的自定义头像(对照旧项目 posAvater)
        print('📤 [Avatar] confirmUpload: custom file=${state.imagePickFile}');
        final file = File(state.imagePickFile);
        ok = await _repository.uploadHeadImage(
          imageFile: file,
          userId: userId,
          accessToken: token,
          onSendProgress: onSendProgress,
        );
      } else {
        // 上传默认头像 asset(对照旧项目 selectAvater + posAvater)
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
        print('✅ [Avatar] upload success, persisting local state...');
        // 本地持久化(对照原 confirmSelection)
        if (state.imagePickFile.isNotEmpty) {
          await _storage.setCustomAvatarPath(state.imagePickFile);
          await _storage.setSelectedAvatarIndex(-1);
        } else {
          await _storage.setSelectedAvatarIndex(state.selectedImageIndex);
          await _storage.setCustomAvatarPath('');
        }
        // 清空待上传路径(注册完成进入主页后,设置页 loadData 会拉最新 headImage)
        state = state.copyWith(isLoading: false, imagePickFile: '');
        print('📷 [AvatarNotifier.confirmUpload] success, state reset');
        return true;
      } else {
        state = state.copyWith(isLoading: false);
        return false;
      }
    } catch (e) {
      print('❌ [Avatar] confirmUpload error: $e');
      state = state.copyWith(isLoading: false);
      return false;
    }
  }
}
