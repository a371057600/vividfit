import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../core/ftms/ftms_device_type.dart';
import '../../../l10n/app_localizations.dart';
import '../data/course_catalog.dart';
import '../notifiers/course_catalog_notifier.dart';
import '../states/course_catalog_state.dart';

/// 课程列表页(对应旧 `big_device_sec_screen.dart`)。
///
/// UI 1:1 还原旧页面,控制器替换为 Riverpod 3.0。
/// JSON 数据源直接获取(无需 Token)。
class CoursePageList extends ConsumerStatefulWidget {
  final FtmsDeviceType deviceType;

  const CoursePageList({super.key, required this.deviceType});

  @override
  ConsumerState<CoursePageList> createState() => _CoursePageListState();
}

class _CoursePageListState extends ConsumerState<CoursePageList> {
  @override
  void initState() {
    super.initState();
    // 强制横屏(与入口页保持一致,避免竖屏导致布局崩溃)
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(courseCatalogProvider.notifier);
      notifier.setDeviceType(widget.deviceType);
      notifier.loadCourses();
    });
  }

  @override
  void dispose() {
    // 不恢复竖屏:返回到入口页时入口页仍保持横屏
    // 竖屏恢复由入口页 dispose 负责(返回到首页时)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(courseCatalogProvider);
    final tr = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: FitTheme.backgroundColor,
        body: _buildBody(state, tr, screenWidth, screenHeight),
      ),
    );
  }

  Widget _buildBody(
    CourseCatalogState state,
    AppLocalizations tr,
    double screenWidth,
    double screenHeight,
  ) {
    // 空数据态
    final categories = state.catalog?.categories;
    final isEmpty = categories == null || categories.isEmpty;
    if (isEmpty && !state.isLoading) {
      return InkWell(
        onTap: () {
          ref.read(courseCatalogProvider.notifier).loadCourses();
        },
        child: Center(
          child: Text(
            tr.noDataTapToRetry,
            style: TextStyle(
              color: FitTheme.textColor,
              fontSize: 20,
            ),
          ),
        ),
      );
    }

    // 加载态
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 数据态
    return Stack(
      children: [
        // 背景图
        Positioned.fill(
          child: Image.asset(
            'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/big_device_background.jpg',
            width: screenWidth,
            height: screenHeight,
            fit: BoxFit.fill,
            errorBuilder: (_, _, _) =>
                Container(color: FitTheme.backgroundColor),
          ),
        ),
        // 课程网格
        Positioned(
          top: 160.h,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.all(25).r,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2 / 1,
                      children: _buildCourseList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 返回按钮
        Positioned(
          top: 50.h,
          left: 20.w,
          child: InkWell(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/big-device-entry');
              }
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: FitTheme.textColor,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCourseList() {
    final notifier = ref.read(courseCatalogProvider.notifier);
    final courses = notifier.currentCourseList;
    return List.generate(
      courses.length,
      (i) => _buildCourseCard(i, courses),
    );
  }

  Widget _buildCourseCard(int index, List<CourseEntry> courses) {
    final notifier = ref.read(courseCatalogProvider.notifier);
    final course = courses[index];
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        notifier.selectCourse(index);
        final courseId = notifier.currentCourseId;
        context.go('/gym-course-detail', extra: courseId);
      },
      child: Container(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
        ),
        child: Image.network(
          course.imagePath ?? '',
          fit: BoxFit.fill,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                    : null,
                color: Colors.white,
              ),
            );
          },
          errorBuilder: (_, _, _) => Container(
            color: Colors.grey.shade800,
            child: Icon(Icons.broken_image, color: Colors.white54),
          ),
        ),
      ),
    );
  }
}
