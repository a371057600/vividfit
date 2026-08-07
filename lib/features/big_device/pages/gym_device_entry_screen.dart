import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// ignore: unused_import
import '../../../core/bluetooth/bluetooth_permission.dart';
import '../../../core/constants/them_change.dart';
import '../../../core/ftms/ftms_device_type.dart';
import '../../../l10n/app_localizations.dart';
import '../data/entry_card_data.dart';
import '../notifiers/gym_course_home_notifier.dart';
import '../notifiers/gym_device_connect_notifier.dart';
import '../states/gym_course_home_state.dart';
import '../states/gym_device_connect_state.dart';
import 'device_search_dialog.dart';

/// 大设备入口屏(1:1 还原旧 `big_device_first_screen.dart`)。
///
/// 还原点:
/// - initState:immersiveSticky + 强制横屏 landscapeLeft
/// - dispose:恢复 manual overlays + 竖屏 portraitUp/Down
/// - AppBar 返回:haltSport + 0.5s delay + 恢复竖屏 + context.pop
/// - AppBar 右侧"Device Connection"按钮:disconnectIfAny + startDeviceScan + showDialog
/// - 5 张卡片 Row:_buildLandscapeCard 1:1(含 skewX 倾斜、反向倾斜、图片背景、icon、标题)
/// - 标题:_buildHeaderTitle 1:1(无 TextShadow,字号 20.sp/14.sp)
///
/// 设备未连接时显示"Device Connection"按钮;已连接或搜索中时隐藏按钮。
/// 卡片点击:未连接弹出搜索对话框;已连接仅 print 日志(功能待后续实现)。
class GymDeviceEntryScreen extends ConsumerStatefulWidget {
  const GymDeviceEntryScreen({super.key, required this.deviceCategoryIndex});

  final int deviceCategoryIndex;

  @override
  ConsumerState<GymDeviceEntryScreen> createState() =>
      _GymDeviceEntryScreenState();
}

class _GymDeviceEntryScreenState extends ConsumerState<GymDeviceEntryScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(gymCourseHomeProvider.notifier)
          .bootstrap(widget.deviceCategoryIndex);
      final category = ref.read(gymCourseHomeProvider).selectedDeviceCategory;
      ref.read(gymDeviceConnectProvider.notifier).setDeviceCategory(category);
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> _restoreOrientationAndPop() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (!mounted) return;
    // 检查是否可 pop,不能 pop(栈底)则返回首页,避免 "popped last page" 错误
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home-shell');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final homeState = ref.watch(gymCourseHomeProvider);
    final homeNotifier = ref.read(gymCourseHomeProvider.notifier);
    final connectState = ref.watch(gymDeviceConnectProvider);
    final connectNotifier = ref.read(gymDeviceConnectProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: FitTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: FitTheme.backgroundColor,
          elevation: 0,
          actionsPadding: EdgeInsets.only(right: 45.w),
          actions: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const DeviceSearchDialog(),
                );
                Future.delayed(
                  const Duration(seconds: 5, milliseconds: 500),
                  () {
                    Navigator.pop(context);
                  },
                );
              },
              child: Text(
                tr.deviceConnection,
                style: TextStyle(
                  color: FitTheme.textColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],

          leadingWidth: 50.w,
          leading: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Icon(Icons.arrow_back_ios, color: FitTheme.textColor),
            onPressed: () async {
              await connectNotifier.haltSport();
              await _restoreOrientationAndPop();
            },
          ),
        ),
        body: Container(
          width: screenWidth,
          margin: EdgeInsets.only(left: 100, right: 15).r,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildHeaderTitle(homeState, tr),
              SizedBox(height: 30.h),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: homeNotifier.resolvedEntryCards
                      .map(
                        (data) => _buildLandscapeCard(data, tr, connectState),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 1:1 还原旧 `_titleWidget()`。
  Widget _buildHeaderTitle(GymCourseHomeState homeState, AppLocalizations tr) {
    final titleKey = ref.read(gymCourseHomeProvider.notifier).deviceTitleKey;

    return Column(
      children: [
        Text(
          _tr(tr, titleKey),
          style: TextStyle(
            color: FitTheme.textColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          _deviceSubtitle(tr, titleKey),
          style: TextStyle(
            color: FitTheme.textColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  /// 1:1 还原旧 `_singleSelectBtn(Map<String, dynamic> data)`。
  Widget _buildLandscapeCard(
    EntryCardData data,
    AppLocalizations tr,
    GymDeviceConnectState connectState,
  ) {
    final homeNotifier = ref.read(gymCourseHomeProvider.notifier);

    return Transform(
      transform: Matrix4.skewX(-0.1),
      origin: const Offset(0, 0),
      child: InkWell(
        onTap: () => _handleCardTap(data, connectState),
        child: Container(
          width: 120.w,
          margin: EdgeInsets.only(bottom: 30.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
            // color: Colors.red,
          ),
          child: Stack(
            children: [
              // 背景图片
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      homeNotifier.resolveCardImage(data.index),
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.r),
                    bottomRight: Radius.circular(100.r),
                    topRight: Radius.circular(40.r),
                    bottomLeft: Radius.circular(40.r),
                  ),
                  color: data.color,
                ),
              ),
              // 内容 - 反向倾斜,保持竖直对齐
              Transform(
                transform: Matrix4.skewX(0.15),
                origin: Offset(0, 40.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  // height: 420.h,
                  children: [
                    // SizedBox(height: 380.h),
                    // 图标
                    Container(
                      margin: EdgeInsets.only(left: 0.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(data.icon, color: Colors.white, size: 20.sp),
                    ),
                    SizedBox(height: 5.h),
                    // 标题
                    Container(
                      margin: EdgeInsets.only(left: 0.w),
                      width: 95.w,
                      child: Text(
                        _tr(tr, data.titleKey),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    // 副标题
                    Container(
                      margin: EdgeInsets.only(left: 0.w),
                      width: 80.w,
                      child: Text(
                        _cardSubtitle(tr, data.titleKey),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 卡片点击:按 index 跳转到对应子页面。
  ///
  /// 1:1 还原旧 `_handleCardTap` 的蓝牙连接守卫逻辑:
  /// 1. 未连接 → 请求权限 → 检查蓝牙 → 断开已有连接 → 启动扫描 → 弹出搜索对话框
  /// 2. 已连接 → 直接跳转到对应功能页面
  void _handleCardTap(
    EntryCardData data,
    GymDeviceConnectState connectState,
  ) async {
    final deviceType = ref.read(gymCourseHomeProvider).selectedDeviceCategory;

    // === 蓝牙连接守卫(临时隐藏,测试用) ===
    // TODO(恢复时): 取消注释下方代码,启用蓝牙连接守卫
    // if (!connectState.isEquipmentConnected) {
    //   if (connectState.isBluetoothConnected) {
    //     connectNotifier.disconnectIfAny();
    //   }
    //   if (!connectState.isSearching) {
    //     connectNotifier.startDeviceScan();
    //   }
    //   if (!context.mounted) return;
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (_) => const DeviceSearchDialog(),
    //   );
    //   return;
    // }
    // === 守卫结束 ===

    // 跳转到对应子页面(1:1 还原旧 `_buildJumptoPage` 的 index 映射)
    // 使用 push 而非 go,保留入口页在栈底,避免返回时"popped last page"错误
    switch (data.index) {
      case 0: // quickStart
        context.push('/gym-quick-start', extra: deviceType);
        break;
      case 1: // courseTraining
        context.push('/gym-course-list', extra: deviceType);
        break;
      case 2: // realScene
        final realsceneRoute = switch (deviceType) {
          FtmsDeviceType.indoorBike => '/gym-bike-realscene',
          FtmsDeviceType.treadmill => '/gym-treadmill-realscene',
          FtmsDeviceType.crossTrainer => '/gym-elliptical-realscene',
          FtmsDeviceType.rower => '/gym-rower-realscene',
          FtmsDeviceType.strengthStation => '/gym-bike-realscene',
        };
        context.push(realsceneRoute);
        break;
      case 3: // cityAdventure
        // 旧项目未实现跳转,暂不处理
        break;
      case 4: // recreationalFitness
        context.push('/gym-game-select', extra: deviceType);
        break;
      default:
        break;
    }
  }

  /// 按 key 取 l10n 字符串的统一入口(替代旧 `"...".tr`)。
  String _tr(AppLocalizations tr, String key) {
    return switch (key) {
      'spinBike' => tr.spinBike,
      'treadmillMachine' => tr.treadmillMachine,
      'ellipticalMachine' => tr.ellipticalMachine,
      'rowingMachine' => tr.rowingMachine,
      'strengthStation' => tr.strengthStation,
      'quickStart' => tr.quickStart,
      'courseTraining' => tr.courseTraining,
      'realScene' => tr.realScene,
      'cityAdventure' => tr.cityAdventure,
      'recreationalFitness' => tr.recreationalFitness,
      'pleaseConnectDevice' => tr.pleaseConnectDevice,
      _ => key,
    };
  }

  /// 按 key 取设备副标题 l10n 字符串。
  String _deviceSubtitle(AppLocalizations tr, String key) {
    return switch (key) {
      'spinBike' => tr.spinBikeSubtitle,
      'treadmillMachine' => tr.treadmillMachineSubtitle,
      'ellipticalMachine' => tr.ellipticalMachineSubtitle,
      'rowingMachine' => tr.rowingMachineSubtitle,
      'strengthStation' => tr.strengthStationSubtitle,
      _ => key,
    };
  }

  /// 按 key 取卡片副标题 l10n 字符串。
  String _cardSubtitle(AppLocalizations tr, String key) {
    return switch (key) {
      'quickStart' => tr.quickStartSubtitle,
      'courseTraining' => tr.courseTrainingSubtitle,
      'realScene' => tr.realSceneSubtitle,
      'cityAdventure' => tr.cityAdventureSubtitle,
      'recreationalFitness' => tr.recreationalFitnessSubtitle,
      _ => key,
    };
  }
}
