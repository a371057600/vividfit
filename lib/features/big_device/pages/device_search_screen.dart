import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/gym_device_connect_notifier.dart';

/// 设备搜索页(1:1 还原旧 `device_connect_screen.dart` 的 `_buildNewMainBody()`)。
///
/// 已对接 [GymDeviceConnectNotifier],支持:
/// - 点击搜索按钮:调用 [startDeviceScan] 启动蓝牙扫描
/// - 搜索状态:通过 [ref.watch] 监听 isSearching / foundDeviceNames 实时更新
/// - 选择设备:点击设备卡片调用 [connectSelectedDevice] 连接
/// - 删除设备:长按设备卡片弹确认对话框
class DeviceSearchScreen extends ConsumerStatefulWidget {
  const DeviceSearchScreen({super.key});

  @override
  ConsumerState<DeviceSearchScreen> createState() => _DeviceSearchScreenState();
}

class _DeviceSearchScreenState extends ConsumerState<DeviceSearchScreen> {
  /// 搜索动画帧索引(对应旧 `ainimationIndex2`,范围 0-47)。
  int _animationFrameIndex = 0;

  /// 动画定时器(对应旧 `_timer`)。
  Timer? _animationTimer;

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  /// 启动搜索动画(对应旧 `animationPlay`,40ms 间隔,0-47 循环)。
  void _startSearchAnimation() {
    _animationTimer?.cancel();
    _animationTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _animationFrameIndex++;
        if (_animationFrameIndex >= 48) {
          _animationFrameIndex = 0;
        }
      });
    });
  }

  /// 停止搜索动画(对应旧 `animationStop`)。
  void _stopSearchAnimation() {
    _animationTimer?.cancel();
    _animationTimer = null;
    if (mounted) {
      setState(() {
        _animationFrameIndex = 0;
      });
    }
  }

  /// 点击搜索按钮:调用 Notifier 启动蓝牙扫描。
  Future<void> _onTapSearchDevice() async {
    debugPrint('[DeviceSearch] === search device tapped ===');
    final notifier = ref.read(gymDeviceConnectProvider.notifier);
    final connectState = ref.read(gymDeviceConnectProvider);
    
    if (connectState.isSearching) {
      debugPrint('[DeviceSearch] already searching, skip');
      return;
    }

    _startSearchAnimation();
    debugPrint('[DeviceSearch] animation started, calling startDeviceScan...');
    
    try {
      await notifier.startDeviceScan(context);
      debugPrint('[DeviceSearch] startDeviceScan completed');
    } catch (e) {
      debugPrint('[DeviceSearch] ❌ startDeviceScan error: $e');
      _stopSearchAnimation();
    }
  }

  /// 选择设备:停止扫描并连接。
  Future<void> _onSelectDevice(String name) async {
    debugPrint('[DeviceSearch] === select device: "$name" ===');
    final notifier = ref.read(gymDeviceConnectProvider.notifier);
    
    _stopSearchAnimation();
    await notifier.stopScan();
    debugPrint('[DeviceSearch] stopped scan, connecting to "$name"...');
    await notifier.connectSelectedDevice(name);
  }

  /// 删除设备对话框。
  Future<void> _showDeleteDeviceDialog(int index) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: FitTheme.backgroundColor,
          contentPadding: EdgeInsets.zero,
          title: Text(
            l10n.deleteDevice,
            style: TextStyle(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontSize: 40.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            l10n.warningDeleteDevice,
            style: TextStyle(color: FitTheme.textColor, fontSize: 25.sp),
          ),
          actions: [
            Container(
              height: 30.h,
              width: MediaQuery.of(ctx).size.width,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 0, bottom: 25).r,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => Navigator.of(ctx).pop(false),
                    child: Container(
                      alignment: Alignment.center,
                      width: 200.w,
                      height: 60.h,
                      child: Text(
                        l10n.cancel,
                        style: TextStyle(fontSize: 25.sp, color: Colors.blue),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => Navigator.of(ctx).pop(true),
                    child: Container(
                      alignment: Alignment.center,
                      width: 200.w,
                      height: 60.h,
                      child: Text(
                        l10n.confirm,
                        style: TextStyle(fontSize: 25.sp, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      debugPrint('[DeviceSearch] delete device at index=$index');
      // TODO: 实现删除已保存设备名的逻辑
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final connectState = ref.watch(gymDeviceConnectProvider);
    final isSearching = connectState.isSearching;
    final foundDevices = connectState.foundDeviceNames;

    // 搜索结束后停止动画
    if (!isSearching && _animationTimer != null) {
      _stopSearchAnimation();
    }

    return Container(
      height: screenHeight,
      width: screenWidth,
      color: FitTheme.backgroundColor,
      child: Column(
        children: [
          // 上半区: 搜索动画 + 搜索按钮
          Container(
            margin: const EdgeInsets.all(25).r,
            width: 700.w,
            child: Column(
              children: [
                // 搜索动画图片
                Container(
                  margin: EdgeInsets.zero.r,
                  child: Image.asset(
                    'images/newUIScreen/HomePageAnimation/search_animation/search_picture$_animationFrameIndex.jpg',
                    gaplessPlayback: true,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                // "Search Device" 按钮
                InkWell(
                  onTap: _onTapSearchDevice,
                  onLongPress: () {},
                  child: Container(
                    margin: const EdgeInsets.only(top: 20).r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: FitTheme.buttonColor,
                      borderRadius: BorderRadius.circular(20).r,
                    ),
                    height: 100.h,
                    width: screenWidth,
                    child: Text(
                      l10n.searchDevice,
                      style: TextStyle(color: Colors.white, fontSize: 40.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 下半区: 设备卡片网格
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25).r,
              child: ListView(
                children: [
                  isSearching && foundDevices.isEmpty
                      ? Wrap(
                          spacing: 20.r,
                          runSpacing: 20.r,
                          children: _buildLoadingContainers(),
                        )
                      : Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 20.r,
                          runSpacing: 20.r,
                          children: _buildDeviceContainers(foundDevices),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 已发现设备卡片列表。
  List<Widget> _buildDeviceContainers(List<String> deviceNames) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (deviceNames.isEmpty) {
      return [
        SizedBox(height: 100.h),
        Text(
          l10n.noDevicesFound,
          style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
        ),
      ];
    }
    
    return List.generate(deviceNames.length, (index) {
      final name = deviceNames[index];
      return InkWell(
        onTap: () => _onSelectDevice(name),
        onLongPress: () => _showDeleteDeviceDialog(index),
        child: Container(
          width: screenWidth / 2 - 40.w,
          height: 380.r,
          padding: const EdgeInsets.all(20).r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
            color: FitTheme.secondbackGround,
          ),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
              ),
              Text(
                name,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'images/newUIScreen/device_icons/icon_smartbike_show.png',
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.add_circle_outlined, size: 25.sp),
                  SizedBox(width: 5.r),
                  Text(
                    l10n.connectDevice,
                    style: TextStyle(
                      fontSize: 25.sp,
                      color: FitTheme.textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  /// 搜索中加载占位卡片。
  List<Widget> _buildLoadingContainers() {
    final l10n = AppLocalizations.of(context)!;
    return List.generate(4, (index) {
      return InkWell(
        onTap: () {
          debugPrint('[DeviceSearch] loading device $index tapped');
        },
        child: Container(
          width: 340.r,
          height: 380.r,
          padding: const EdgeInsets.all(20).r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
            color: FitTheme.secondbackGround,
          ),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '...',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
              ),
              Text(
                '...',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'images/newUIScreen/device_icons/icon_smartbike_show.png',
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.add_circle_outlined, size: 25.sp),
                  SizedBox(width: 5.r),
                  Text(
                    l10n.connectDevice,
                    style: TextStyle(
                      fontSize: 25.sp,
                      color: FitTheme.textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
