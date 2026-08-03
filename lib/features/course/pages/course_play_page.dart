import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';

/// 课程播放页（占位版）。
///
/// 本期仅还原基础 UI 框架与横屏切换，不实现：
/// - 蓝牙设备连接与数据接收
/// - 帧动画播放（updateImage / offPlayUpdateImage）
/// - 音频播放（bgm / actionIntroduceVoice）
/// - 文件下载与解压
/// - 实时计分与特效
/// - 运动数据上传
///
/// 上述功能已在原 new_conrtroller_course_play.dart 中实现，
/// 后续可通过 `// TODO: course-play` 标记逐步接入。
class CoursePlayPage extends ConsumerStatefulWidget {
  const CoursePlayPage({super.key});

  @override
  ConsumerState<CoursePlayPage> createState() => _CoursePlayPageState();
}

class _CoursePlayPageState extends ConsumerState<CoursePlayPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.black,
      child: PopScope(
        canPop: false,
        child: Container(
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: const Color.fromARGB(255, 20, 20, 20),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width - 50.w,
                  height: MediaQuery.of(context).size.height * 0.7,
                  color: const Color.fromARGB(255, 40, 40, 40),
                  child: Center(
                    child: Text(
                      l10n.coursePlayPlaceholder,
                      style: TextStyle(
                        color: FitTheme.textColor,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
              _buildDataScreen(l10n),
              Positioned(
                top: 100.h,
                left: 25.w,
                child: _buildBackButton(),
              ),
              _buildEndScreen(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        context.pop();
      },
      child: const Icon(
        Icons.arrow_back_ios,
        color: Color.fromARGB(255, 80, 80, 80),
        size: 35,
      ),
    );
  }

  Widget _buildDataScreen(AppLocalizations l10n) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: 800,
              padding: const EdgeInsets.only(left: 100, right: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDataTopItem(l10n.timeMin, '00:00'),
                  _buildDataTopItem(l10n.sportCount, '0'),
                  _buildDataTopItem(l10n.kcal, '0'),
                  _buildDataTopItem(l10n.score, '0'),
                ],
              ),
            ),
          ),
          const Expanded(flex: 4, child: SizedBox()),
          Expanded(
            flex: 1,
            child: Container(
              width: 800,
              margin: const EdgeInsets.only(left: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.courseTitle,
                    style: TextStyle(
                      color: FitTheme.textColor,
                      fontWeight: FontWeight.bold,
                      height: 0.9,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${l10n.action} 1/10',
                    style: TextStyle(
                      color: FitTheme.textColor,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTopItem(String title, String value) {
    return Expanded(
      flex: 1,
      child: Container(
      alignment: Alignment.bottomCenter,
      height: 100,
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: FitTheme.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildEndScreen(AppLocalizations l10n) {
    return Positioned(
      top: 0,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        color: Colors.black.withValues(alpha: 0.92),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.courseEndedPlaceholder,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildEndCard(l10n.timeMin, '00:00'),
                _buildEndCard(l10n.sportCount, '0'),
                _buildEndCard(l10n.kcal, '0'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: Text(l10n.back),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndCard(String title, String value) {
    return Container(
      height: 80,
      width: 140,
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(top: 10, left: 15, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: FitTheme.buttonColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: FitTheme.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: FitTheme.textColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
