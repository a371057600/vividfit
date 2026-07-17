import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../data/entry_card_data.dart';
import '../notifiers/gym_course_home_notifier.dart';
import '../notifiers/gym_device_connect_notifier.dart';
import '../states/gym_course_home_state.dart';
import '../states/gym_device_connect_state.dart';
import 'device_search_dialog.dart';

/// 大设备入口屏(1:1 还原旧 `big_device_first_screen.dart` 第一界面)。
///
/// 还原点:
/// - initState:immersiveSticky + 支持横竖屏
/// - dispose:恢复 manual overlays + 竖屏 portraitUp/Down
/// - OrientationBuilder 区分横竖屏布局
/// - AppBar 返回:haltSport + 0.5s delay + 恢复竖屏 + context.pop
/// - AppBar 右侧"Device Connection"按钮:disconnectIfAny + startDeviceScan + showDialog
/// - 5 张卡片 Row/Wrap:_buildEntryCard 1:1(含 skewX 倾斜、反向倾斜、图片背景、icon、标题)
/// - 卡片点击:_handleCardTap 未连接弹出搜索对话框;已连接仅日志
/// - 标题:_buildHeaderTitle 1:1 带 TextShadow
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(gymCourseHomeNotifierProvider.notifier)
          .bootstrap(widget.deviceCategoryIndex);
      final category = ref
          .read(gymCourseHomeNotifierProvider)
          .selectedDeviceCategory;
      ref
          .read(gymDeviceConnectNotifierProvider.notifier)
          .setDeviceCategory(category);
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
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final homeState = ref.watch(gymCourseHomeNotifierProvider);
    final connectState = ref.watch(gymDeviceConnectNotifierProvider);
    final connectNotifier =
        ref.read(gymDeviceConnectNotifierProvider.notifier);

    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;

        final appBar = AppBar(
          backgroundColor: FitTheme.backgroundColor,
          elevation: 0,
          actionsPadding: EdgeInsets.only(right: 45.w),
          actions: (!connectState.isEquipmentConnected &&
                  !connectState.isSearching)
              ? [
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      connectNotifier.disconnectIfAny();
                      if (!connectState.isSearching) {
                        connectNotifier.startDeviceScan();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const DeviceSearchDialog(),
                        );
                      }
                    },
                    child: Text(
                      tr.deviceConnection,
                      style: TextStyle(
                        color: FitTheme.textColor,
                        fontSize: FitTheme.fonSizeBig,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]
              : null,
          leadingWidth: 50.w,
          leading: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Icon(
              Icons.arrow_back_ios,
              color: FitTheme.textColor,
            ),
            onPressed: () async {
              await connectNotifier.haltSport();
              await _restoreOrientationAndPop();
            },
          ),
        );

        return SafeArea(
          child: Scaffold(
            backgroundColor: FitTheme.backgroundColor,
            appBar: isLandscape ? null : appBar,
            bottomNavigationBar: isLandscape ? appBar : null,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: isLandscape ? 20.h : 40.h),
                  _buildHeaderTitle(homeState, tr),
                  SizedBox(height: 50.h),
                  SizedBox(
                    width: isLandscape ? 880.w : 750.w,
                    height: isLandscape ? 460.h : 1000.h,
                    child: isLandscape
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: homeState.entryCards.asMap().entries.map(
                              (e) {
                                return _buildEntryCard(
                                  e.value,
                                  tr,
                                  connectState,
                                  isLandscape,
                                  e.key,
                                );
                              },
                            ).toList(),
                          )
                        : Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 24.w,
                            runSpacing: 24.h,
                            children: homeState.entryCards.asMap().entries.map(
                              (e) {
                                return _buildEntryCard(
                                  e.value,
                                  tr,
                                  connectState,
                                  isLandscape,
                                  e.key,
                                );
                              },
                            ).toList(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 1:1 还原旧 `_titleWidget()`，增加 TextShadow。
  Widget _buildHeaderTitle(
    GymCourseHomeState homeState,
    AppLocalizations tr,
  ) {
    final titleKey =
        ref.read(gymCourseHomeNotifierProvider.notifier).deviceTitleKey;
    final englishTitle =
        ref.read(gymCourseHomeNotifierProvider.notifier).deviceEnglishTitle;

    final shadow = Shadow(
      color: Colors.black.withValues(alpha: 0.25),
      offset: Offset(1.w, 1.h),
      blurRadius: 2.r,
    );

    return Column(
      children: [
        Text(
          _tr(tr, titleKey),
          style: TextStyle(
            color: FitTheme.textColor,
            fontSize: FitTheme.fonSizeBig,
            fontWeight: FontWeight.bold,
            fontFamily: FitTheme.fontFamily,
            shadows: [shadow],
          ),
        ),
        Text(
          englishTitle,
          style: TextStyle(
            color: FitTheme.textColor,
            fontSize: FitTheme.fonSizeSmall,
            fontWeight: FontWeight.normal,
            shadows: [shadow],
          ),
        ),
      ],
    );
  }

  /// 1:1 还原旧 `_singleSelectBtn(Map<String, dynamic> data)`。
  /// 横竖屏共用，尺寸与 skew 按 orientation / index 区分。
  Widget _buildEntryCard(
    EntryCardData data,
    AppLocalizations tr,
    GymDeviceConnectState connectState,
    bool isLandscape,
    int index,
  ) {
    final homeNotifier = ref.read(gymCourseHomeNotifierProvider.notifier);
    final cardWidth = isLandscape ? 120.w : 200.w;
    final cardHeight = isLandscape ? 460.h : 500.h;
    final skewX = index < 2 ? -0.1 : (index > 2 ? 0.15 : 0.0);

    return Transform(
      transform: Matrix4.skewX(skewX),
      origin: const Offset(0, 0),
      child: InkWell(
        onTap: () => _handleCardTap(data, connectState),
        child: SizedBox(
          width: cardWidth,
          child: AspectRatio(
            aspectRatio: cardWidth / cardHeight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Stack(
                children: [
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
                  Transform(
                    transform: Matrix4.skewX(0.15),
                    origin: Offset(0, 40.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: cardHeight * 0.52),
                        Container(
                          margin: EdgeInsets.only(left: 0.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            data.icon,
                            color: FitTheme.textButtonColor,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Container(
                          margin: EdgeInsets.only(left: 0.w),
                          width: cardWidth * 0.8,
                          child: Text(
                            _tr(tr, data.titleKey),
                            style: TextStyle(
                              color: FitTheme.textButtonColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Container(
                          margin: EdgeInsets.only(left: 0.w),
                          width: cardWidth * 0.67,
                          child: Text(
                            data.englishTitle,
                            style: TextStyle(
                              color: FitTheme.textButtonColor,
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
        ),
      ),
    );
  }

  /// 卡片点击：未连接时弹出搜索对话框；已连接仅日志。
  void _handleCardTap(
    EntryCardData data,
    GymDeviceConnectState connectState,
  ) {
    final connectNotifier =
        ref.read(gymDeviceConnectNotifierProvider.notifier);
    if (!connectState.isEquipmentConnected) {
      connectNotifier.disconnectIfAny();
      if (!connectState.isSearching) {
        connectNotifier.startDeviceScan();
      }
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const DeviceSearchDialog(),
      );
      return;
    }
    debugPrint('card ${data.index} tapped, device connected');
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
}
