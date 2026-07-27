import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';

/// 设备搜索页(1:1 还原旧 `device_connect_screen.dart` 的 `_buildNewMainBody()`)。
///
/// 结构:
/// ```
/// Container(full screen, backgroundColor)
///   Column
///     Container(margin:25.r, width:700.w)     ← 上半区
///       Column
///         Image.asset(搜索动画, fit:BoxFit.fitWidth)
///         InkWell → "Search Device" 按钮(buttonColor, h:100, w:full, r:20, sp:40)
///     Expanded                                ← 下半区
///       Container(margin:left:25,right:25,bottom:25)
///         ListView > Wrap(设备卡片网格,根据 _isSearching 切换 _buildDeviceContainers / _buildLoadingContainers)
/// ```
///
/// 仅 UI 框架,不实现蓝牙搜索/连接/删除逻辑;无 GetX,无 permission_handler,无
/// 任何 controller 依赖。所有交互(onTap 设备卡片、长按、删除对话框、搜索按钮)仅触发
/// 一次 `print` 调试输出,保留 1:1 视觉结构以便后续接入真实逻辑。
class DeviceSearchScreen extends ConsumerStatefulWidget {
  const DeviceSearchScreen({super.key});

  @override
  ConsumerState<DeviceSearchScreen> createState() => _DeviceSearchScreenState();
}

class _DeviceSearchScreenState extends ConsumerState<DeviceSearchScreen> {
  /// 搜索动画帧索引(对应旧 `ainimationIndex2`,范围 0-47)。
  int _animationFrameIndex = 0;

  /// 是否正在搜索(对应旧 `searchingDevice`)。
  bool _isSearching = false;

  /// 搜索到的设备名列表(对应旧 `newSearchList`)。1:1 UI 无功能,留空。
  final List<String> _foundDeviceNames = const [];

  /// 加载中占位设备名列表(对应旧 `loadingList`)。1:1 UI 无功能,留空。
  final List<String> _loadingDeviceNames = const [];

  /// 动画定时器(对应旧 `_timer`)。
  Timer? _animationTimer;

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  /// 启动搜索动画(对应旧 `animationPlay`,40ms 间隔,0-47 循环)。
  /// 仅在用户点击 "Search Device" 按钮后触发。
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
  }

  /// 1:1 还原旧 `checkPermission` + 点击搜索按钮的行为。
  /// 1:1 UI 无功能,仅切换 _isSearching 并启动/停止动画。
  void _onTapSearchDevice() {
    print('[DeviceSearch] search device tapped, start searching');
    if (_isSearching) {
      return;
    }
    setState(() {
      _isSearching = true;
    });
    _startSearchAnimation();
  }

  /// 1:1 还原旧 `_deleteDeviceWidget` 的 Get.defaultDialog 弹窗。
  /// 1:1 UI 无功能,仅 print 后关闭弹窗。
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
            style: TextStyle(
              color: FitTheme.textColor,
              fontSize: 25.sp,
            ),
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
      print('[DeviceSearch] delete device at index=$index');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 1:1 还原旧 `_buildNewMainBody()`。
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.sp,
                      ),
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
                  _isSearching
                      ? Wrap(
                          spacing: 20.r,
                          runSpacing: 20.r,
                          children: _buildLoadingContainers(),
                        )
                      : Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 20.r,
                          runSpacing: 20.r,
                          children: _buildDeviceContainers(),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 1:1 还原旧 `_containers()` — 已发现/已配对设备卡片。
  /// 1:1 UI 无功能:onTap 仅 print,onLongPress 弹删除确认。
  List<Widget> _buildDeviceContainers() {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    return List.generate(_foundDeviceNames.length, (index) {
      final name = _foundDeviceNames[index];
      return InkWell(
        onTap: () {
          print('[DeviceSearch] device $index tapped: $name');
        },
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

  /// 1:1 还原旧 `_loadingContainers()` — 搜索中加载占位卡片。
  /// 1:1 UI 无功能:onTap 仅 print 一句 "请等待"。
  List<Widget> _buildLoadingContainers() {
    final l10n = AppLocalizations.of(context)!;
    return List.generate(_loadingDeviceNames.length, (index) {
      final name = _loadingDeviceNames[index];
      return InkWell(
        onTap: () {
          print('[DeviceSearch] loading device $index tapped: please wait');
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
}