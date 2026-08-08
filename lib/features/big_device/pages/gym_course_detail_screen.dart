import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/constants/them_change.dart';
import '../../../core/ftms/ftms_device_type.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/gym_course_detail_notifier.dart';
import '../states/gym_course_detail_state.dart';
import 'widgets/download_progress_dialog.dart';

/// 课程详情页(1:1 还原旧 `big_device_course_detail_screen.dart`)。
///
/// big_device 模块统一横屏:initState 强制 landscapeLeft,dispose 不恢复
/// (竖屏恢复由入口页 GymDeviceEntryScreen.dispose 负责)。
///
/// 阶段一:实装数据加载 + UI 展示(课程图/描述/建议/注意事项/动作列表/底部按钮)。
/// 下载/解压/跳转 play 逻辑待后续阶段实现(下载任务需先做测试)。
class GymCourseDetailScreen extends ConsumerStatefulWidget {
  final int? courseId;
  final FtmsDeviceType deviceType;

  const GymCourseDetailScreen({
    super.key,
    required this.courseId,
    required this.deviceType,
  });

  @override
  ConsumerState<GymCourseDetailScreen> createState() =>
      _GymCourseDetailScreenState();
}

class _GymCourseDetailScreenState extends ConsumerState<GymCourseDetailScreen> {
  // 测试用:模拟下载进度弹窗
  bool _isTestDownloading = false;
  double _testProgress = 0.0;
  DateTime? _testStartTime;

  @override
  void initState() {
    super.initState();
    // 强制横屏(与入口页/课程列表页保持一致,避免竖屏导致布局崩溃)
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    // 加载课程详情数据(对应旧 onInit → getData())
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(gymCourseDetailProvider.notifier)
          .loadDetail(courseId: widget.courseId, deviceType: widget.deviceType);
    });
  }

  /// 开始模拟下载进度(测试用)
  void _startTestDownload() {
    setState(() {
      _isTestDownloading = true;
      _testProgress = 0.0;
      _testStartTime = DateTime.now();
    });
    // 模拟 3 秒从 0 到 100%
    const totalDuration = Duration(seconds: 3);
    const tickInterval = Duration(milliseconds: 50);
    Future.doWhile(() async {
      await Future.delayed(tickInterval);
      if (!mounted || !_isTestDownloading) return false;
      final elapsed = DateTime.now().difference(_testStartTime!);
      final progress = elapsed.inMilliseconds / totalDuration.inMilliseconds;
      setState(() {
        _testProgress = progress.clamp(0.0, 1.0);
      });
      return progress < 1.0;
    }).then((_) {
      if (mounted) {
        setState(() {
          _isTestDownloading = false;
        });
      }
    });
  }

  /// 取消测试下载
  void _cancelTestDownload() {
    setState(() {
      _isTestDownloading = false;
      _testProgress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(gymCourseDetailProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // courseId 在 JSON 中找不到 → 退回上一页(对应旧 Get.back())
    ref.listen<bool>(gymCourseDetailProvider.select((s) => s.notFound), (
      previous,
      next,
    ) {
      if (next && previous != true) {
        Fluttertoast.showToast(msg: '课程数据不存在');
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/gym-course-list');
        }
      }
    });

    // 下载失败 toast
    ref.listen<String?>(
      gymCourseDetailProvider.select((s) => s.downloadError),
      (previous, next) {
        if (next != null && next != previous) {
          Fluttertoast.showToast(msg: next);
        }
      },
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: FitTheme.backgroundColor,
        body: Stack(
          children: [
            // 背景图(1:1 还原旧 Image.asset width: Get.width height: Get.height)
            Image.asset(
              'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/big_device_background.jpg',
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => Container(color: Colors.black),
            ),
            // 返回按钮(1:1 还原旧 Positioned top:40.h left:10.w)
            Positioned(
              top: 40.h,
              left: 10.w,
              child: InkWell(
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/gym-course-list');
                  }
                },
                child: Icon(Icons.arrow_back_ios, color: FitTheme.textColor),
              ),
            ),
            // 主内容(1:1 还原旧 Positioned top:160.h)
            Positioned(
              top: 150.h,
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                width: screenWidth,
                height: screenHeight - 180.h,
                child: Column(
                  children: [
                    // 课程图 + 中间内容
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          _buildCourseImage(state, screenWidth, screenHeight),
                          Expanded(
                            child: _buildMiddleContent(
                              state,
                              l10n,
                              screenWidth,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 动作列表
                    Expanded(flex: 2, child: _buildActionList(state)),
                    // 底部按钮区(1:1 还原旧 Obx 三态:loading / downloading / ready)
                    if (state.isLoading)
                      const Expanded(flex: 1, child: SizedBox())
                    else if (state.isNeedDownloaded)
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: _buildBottomDownloadButton(state),
                        ),
                      )
                    else
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: _buildBottomButton(l10n, state),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // 下载进度弹窗覆盖层(真实下载 + 测试模式)
            if (state.isNeedDownloaded || _isTestDownloading)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _isTestDownloading ? _cancelTestDownload : null,
                  child: Container(
                    color: Colors.black54,
                    child: DownloadProgressDialog(
                      progress: _isTestDownloading
                          ? _testProgress
                          : state.downLoadProgress,
                      currentFileName: _isTestDownloading
                          ? 'test_file.zip'
                          : state.currentDownloadingFile,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 课程封面图(1:1 还原旧 `_buildCourseImageWidget`)。
  ///
  /// courseImage 为空时显示 LoadingAnimationWidget.waveDots 占位。
  Widget _buildCourseImage(
    GymCourseDetailState state,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      height: screenHeight,
      decoration: BoxDecoration(
        color: FitTheme.backgroundColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.only(left: 10.w),
      child: state.courseImage.isNotEmpty
          ? Image.network(state.courseImage, fit: BoxFit.contain)
          : SizedBox(
              width: screenWidth * 0.42,
              height: screenHeight,
              child: Center(
                child: LoadingAnimationWidget.waveDots(
                  color: FitTheme.textColor,
                  size: 50,
                ),
              ),
            ),
    );
  }

  /// 中间内容(1:1 还原旧 `_buildMiddleContent`)。
  ///
  /// 课程描述 + details + 课程建议 + suggestions + 注意事项 + notes。
  Widget _buildMiddleContent(
    GymCourseDetailState state,
    AppLocalizations l10n,
    double screenWidth,
  ) {
    final cp = state.courseProperties;
    return Container(
      margin: EdgeInsets.all(10),
      // width: screenWidth * 0.4,
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: ListView(
          children: [
            Text(
              l10n.courseDescription,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 18.sp,
                fontFamily: FitTheme.fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              cp?.details ?? ' ',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 10.sp,
                fontFamily: FitTheme.fontFamily,
              ),
            ),
            Text(
              l10n.courseProposal,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 18.sp,
                fontFamily: FitTheme.fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              cp?.suggestions ?? '无',
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 10.sp,
                fontFamily: FitTheme.fontFamily,
              ),
            ),
            Text(
              l10n.notice,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 18.sp,
                fontFamily: FitTheme.fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${cp?.notes ?? '无'}',
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 10.sp,
                fontFamily: FitTheme.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 动作列表(1:1 还原旧 `_actionListShow`)。
  ///
  /// 横向 ListView,isRestStage==true 的项渲染空 Container。
  Widget _buildActionList(GymCourseDetailState state) {
    final actions = state.courseActionList;
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(left: 10, right: 20),
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 30.h, top: 30.h),
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          if (action.isRestStage == false) {
            return Container(
              margin: const EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      action.imagePath ?? '',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: FitTheme.textColor);
                      },
                    ),
                  ),
                  Container(
                    width: 80.w,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      action.name ?? '',
                      style: TextStyle(
                        color: FitTheme.textColor,
                        fontSize: 10.sp,
                        fontFamily: FitTheme.fontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  /// 底部按钮(1:1 还原旧 `_buildBottomButton`)。
  ///
  /// 根据 isCourseReady 显示不同文本:
  /// - 已就绪 → "开始播放"
  /// - 未就绪 → "下载课程"
  /// 附带一个测试按钮,用于模拟下载进度弹窗
  Widget _buildBottomButton(AppLocalizations l10n, GymCourseDetailState state) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonText = state.isCourseReady
        ? l10n.startPlaying
        : l10n.downloadCourse;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 主按钮
        SizedBox(
          height: 160.h,
          width: screenWidth * 0.25,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: FitTheme.buttonColor,
              elevation: 5,
              shadowColor: FitTheme.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            onPressed: () {
              if (state.isCourseReady) {
                // 课程已就绪 → 直接导航到 Play 页面
                context.push(
                  '/gym-device-play',
                  extra: {
                    'courseId': widget.courseId,
                    'deviceType': widget.deviceType,
                  },
                );
              } else {
                // 未就绪 → 开始下载
                ref
                    .read(gymCourseDetailProvider.notifier)
                    .onEnterCoursePressed();
              }
            },
            child: Container(
              alignment: Alignment.center,
              child: Text(
                buttonText,
                style: TextStyle(
                  color: FitTheme.textButtonColor,
                  fontSize: FitTheme.fonSizeBig,
                  fontFamily: FitTheme.fontFamily,
                ),
              ),
            ),
          ),
        ),
        // 测试按钮(小一号,灰色边框)
        SizedBox(width: 20.w),
        SizedBox(
          height: 80.h,
          width: screenWidth * 0.08,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: FitTheme.textColor,
              side: BorderSide(
                color: FitTheme.textColor.withValues(alpha: 0.5),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: _isTestDownloading
                ? _cancelTestDownload
                : _startTestDownload,
            child: Text(
              _isTestDownloading ? '取消' : '测试下载',
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: FitTheme.fontFamily,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 下载进度按钮(1:1 还原旧 `_buildBottomDownloadButton`)。
  ///
  /// LinearProgressIndicator + 居中百分比文字,数据源为 state.downLoadProgress。
  Widget _buildBottomDownloadButton(GymCourseDetailState state) {
    return Container(
      margin: EdgeInsets.only(top: 50, bottom: 50).h,
      height: 80.h,
      width: MediaQuery.of(context).size.width * 0.3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
            child: LinearProgressIndicator(
              value: state.downLoadProgress,
              backgroundColor: FitTheme.backgroundColor,
              minHeight: 40,
              valueColor: AlwaysStoppedAnimation<Color>(FitTheme.buttonColor),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          Text(
            '${(state.downLoadProgress * 100).toInt()}%',
            style: TextStyle(
              color: FitTheme.textColor,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}
