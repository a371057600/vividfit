import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../../../core/ftms/ftms_device_type.dart';

/// 游戏选择页（对应旧 big_device_game_select.dart 的 GameSelect）
/// 1:1 还原UI，使用mock数据，业务逻辑全部置空
class GymGameSelectScreen extends ConsumerStatefulWidget {
  final FtmsDeviceType deviceType;

  const GymGameSelectScreen({super.key, required this.deviceType});

  @override
  ConsumerState<GymGameSelectScreen> createState() =>
      _GymGameSelectScreenState();
}

class _GymGameSelectScreenState extends ConsumerState<GymGameSelectScreen> {
  // Mock状态（对应旧 ControllerBigCourseSelect / ControllerNewFourBigDeviceSprot）
  int _selectedMusicIndex = 0;
  bool _isMusicPlaying = false;
  bool _isVolumeOpen = true;
  bool _isPlaying = false;
  int _imageIndex = 0;

  // Mock运动数据
  String get _sportTime => '02:05';
  String get _distance => '1.25';
  String get _energy => '45';

  // 设备相关mock数据
  late List<String> _gamePictureList;
  late String _metric1Title;
  late String _metric1Unit;
  late String _metric1Value;
  late String _metric2Title;
  late String _metric2Unit;
  late String _metric2Value;
  late String _metric3Title;
  late String _metric3Unit;
  late String _metric3Value;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    _initMockData();
  }

  void _initMockData() {
    switch (widget.deviceType) {
      case FtmsDeviceType.indoorBike:
        _gamePictureList = [
          "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bike_game1.jpg",
          "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bike_game2.jpg",
        ];
        _metric1Title = 'Heart Rate';
        _metric1Unit = '(bpm)';
        _metric1Value = '128';
        _metric2Title = 'Cadence';
        _metric2Unit = '(rpm)';
        _metric2Value = '85';
        _metric3Title = 'Speed';
        _metric3Unit = '(km/h)';
        _metric3Value = '22.50';
        break;
      case FtmsDeviceType.treadmill:
        _gamePictureList = [
          "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/treadmill_game1.jpg",
          "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/treadmill_game2.jpg",
        ];
        _metric1Title = 'Heart Rate';
        _metric1Unit = '(bpm)';
        _metric1Value = '135';
        _metric2Title = 'Inclination';
        _metric2Unit = '(%)';
        _metric2Value = '3';
        _metric3Title = 'Speed';
        _metric3Unit = '(km/h)';
        _metric3Value = '8.50';
        break;
      case FtmsDeviceType.crossTrainer:
        _gamePictureList = [
          "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/crossTrainer_game1.jpg",
          "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/crossTrainer_game2.jpg",
        ];
        _metric1Title = 'Heart Rate';
        _metric1Unit = '(bpm)';
        _metric1Value = '142';
        _metric2Title = 'Cadence';
        _metric2Unit = '(rpm)';
        _metric2Value = '70';
        _metric3Title = 'Speed';
        _metric3Unit = '(km/h)';
        _metric3Value = '18.00';
        break;
      case FtmsDeviceType.rower:
        _gamePictureList = [
          "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/rowing_game1.jpg",
          "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/rowing_game2.jpg",
        ];
        _metric1Title = 'Heart Rate';
        _metric1Unit = '(bpm)';
        _metric1Value = '155';
        _metric2Title = 'Stroke Count';
        _metric2Unit = '(T)';
        _metric2Value = '850';
        _metric3Title = 'Stroke Rate';
        _metric3Unit = '(rpm)';
        _metric3Value = '28';
        break;
      case FtmsDeviceType.strengthStation:
        _gamePictureList = [
          "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bike_game1.jpg",
          "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/bike_game2.jpg",
        ];
        _metric1Title = 'Heart Rate';
        _metric1Unit = '(bpm)';
        _metric1Value = '120';
        _metric2Title = 'Stroke Count';
        _metric2Unit = '(T)';
        _metric2Value = '0';
        _metric3Title = 'Stroke Rate';
        _metric3Unit = '(rpm)';
        _metric3Value = '0';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: FitTheme.backgroundColorOld,
      body: Stack(
        children: [
          // 主内容区 — 1:1 还原
          Container(
            margin: EdgeInsets.only(left: 120, right: 0, top: 150).r,
            height: screenHeight,
            width: screenWidth,
            child: Row(
              children: [
                _leftContainer(screenWidth, screenHeight),
                SizedBox(width: 10.w),
                _rightContainer(screenWidth, screenHeight),
              ],
            ),
          ),
          // 返回按钮 — 1:1 还原
          Positioned(
            top: 40.h,
            left: 20.w,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== 右侧容器 — 1:1 还原 _rightContainer ====================
  Widget _rightContainer(double screenWidth, double screenHeight) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 0, left: 10, right: 50).r,
        height: screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 专辑封面+播放控制区 — 1:1 还原
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(40).r,
              ),
              height: screenHeight * 2 / 5,
              width: double.infinity,
              child: Stack(
                children: [
                  // 专辑封面图
                  SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      "images/newUIScreen/bigScreenAnimation/bigDeviceMusicPlay/$_imageIndex.jpg",
                      gaplessPlayback: true,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Colors.green);
                      },
                    ),
                  ),
                  // 播放/暂停/音量按钮覆盖层 — 1:1 还原
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        // opacity: 0.8,
                        borderRadius: BorderRadius.circular(40).r,
                      ),
                      height: screenHeight * 2 / 5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // 播放/暂停按钮 — 1:1 还原
                          _isMusicPlaying
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isMusicPlaying = false;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(40).r,
                                    width: 150.r,
                                    height: 150.r,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(40).w,
                                    ),
                                    child: Image.asset(
                                      "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/music_pause.png",
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.pause, size: 50.w),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isMusicPlaying = true;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(40).r,
                                    width: 150.r,
                                    height: 150.r,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(40).w,
                                    ),
                                    child: Image.asset(
                                      "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/music_play.png",
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                            Icons.play_arrow,
                                            size: 50.w,
                                          ),
                                    ),
                                  ),
                                ),
                          SizedBox(width: 100.w),
                          // 音量按钮 — 1:1 还原
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isVolumeOpen = !_isVolumeOpen;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(40).r,
                              width: 150.r,
                              height: 150.r,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40).w,
                              ),
                              child: _isVolumeOpen
                                  ? Image.asset(
                                      "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/volume_open.png",
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.volume_up, size: 50.w),
                                    )
                                  : Image.asset(
                                      "images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/volume_close.png",
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                            Icons.volume_off,
                                            size: 50.w,
                                          ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 45.r),
            // 数据+按钮区 — 1:1 还原
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(40).r,
                  // color: Colors.white,
                ),
                width: double.infinity,
                child: ListView(
                  shrinkWrap: false,
                  // physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // 第一行数据：时间、距离、卡路里 — 1:1 还原
                    Container(
                      decoration: BoxDecoration(
                        color: FitTheme.secondbackGroundOld,
                        borderRadius: BorderRadius.circular(40).r,
                      ),
                      height: 200.h,
                      width: double.infinity,
                      child: Row(
                        children: [
                          _singleDataShow('Sport Time', '', _sportTime),
                          _singleDataShow('Distance', '(km)', _distance),
                          _singleDataShow('Energy', '(Kcal)', _energy),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.r),
                    // 第二行数据：设备相关指标 — 1:1 还原
                    Container(
                      decoration: BoxDecoration(
                        color: FitTheme.secondbackGroundOld,
                        borderRadius: BorderRadius.circular(40).r,
                      ),
                      height: 200.h,
                      width: double.infinity,
                      child: Row(
                        children: [
                          _singleDataShow(
                            _metric1Title,
                            _metric1Unit,
                            _metric1Value,
                          ),
                          _singleDataShow(
                            _metric2Title,
                            _metric2Unit,
                            _metric2Value,
                          ),
                          _singleDataShow(
                            _metric3Title,
                            _metric3Unit,
                            _metric3Value,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 80.r),
                    // 开始/停止按钮 — 1:1 还原（居中显示）
                    Center(
                      child: _isPlaying
                          ? InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  _isPlaying = false;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: FitTheme.buttonColor,
                                  borderRadius: BorderRadius.circular(40).r,
                                ),
                                height: 120.h,
                                width: screenWidth * 0.25,
                                child: Text(
                                  'STOP',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.bebas,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  _isPlaying = true;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(40).r,
                                ),
                                height: 120.h,
                                width: screenWidth * 0.25,
                                child: Text(
                                  'STRAT',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.bebas,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== 左侧容器 — 1:1 还原 _leftContainer ====================
  Widget _leftContainer(double screenWidth, double screenHeight) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 0).r,
      height: screenHeight,
      width: screenWidth / 2,
      child: Column(
        children: [
          // 游戏选择区（两个大卡片）— 1:1 还原
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40).r,
            ),
            height: screenHeight * 2 / 5,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // TODO: 跳转到游戏1
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40).r,
                      child: SizedBox(
                        width: screenWidth / 4 - 5.w,
                        child: Image.asset(
                          _gamePictureList[0],
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: Colors.grey);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // TODO: 跳转到游戏2
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40).r,
                      child: SizedBox(
                        width: screenWidth / 4 - 5.w,
                        child: Image.asset(
                          _gamePictureList[1],
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: Colors.grey);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 音乐选择区 — 1:1 还原
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40).r,
              ),
              height: screenHeight,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.r),
                    // 第一行音乐：大封面(0) + 2x2小封面(1-4) — 1:1 还原
                    Container(
                      height: 440.h,
                      width: double.infinity,
                      child: Row(
                        children: [
                          // 大封面 — 1:1 还原
                          InkWell(
                            onTap: () {
                              setState(() {
                                _selectedMusicIndex = 0;
                                _isMusicPlaying = true;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(20).r,
                              alignment: Alignment.bottomLeft,
                              height: 440.h,
                              width: screenWidth / 6 - 5.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40).r,
                                border: Border.all(
                                  color: _selectedMusicIndex == 0
                                      ? Colors.grey.shade300
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40).r,
                                child: Image.asset(
                                  'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/big_select.jpg',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(color: Colors.grey);
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          // 2x2 小封面 — 1:1 还原
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      _singleMusicSelectWidget(1),
                                      SizedBox(width: 10.w),
                                      _singleMusicSelectWidget(2),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.w),
                                Expanded(
                                  child: Row(
                                    children: [
                                      _singleMusicSelectWidget(3),
                                      SizedBox(width: 10.w),
                                      _singleMusicSelectWidget(4),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.r),
                    // 第二行音乐：3个小封面(5-7) — 1:1 还原
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40).r,
                      ),
                      height: 200.h,
                      width: screenWidth / 2,
                      child: Row(
                        children: [
                          _singleMusicSelectWidget(5),
                          SizedBox(width: 10.w),
                          _singleMusicSelectWidget(6),
                          SizedBox(width: 10.w),
                          _singleMusicSelectWidget(7),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== 小组件 — 1:1 还原 ====================

  /// 单个音乐封面选择 — 1:1 还原 _singleMusicSelectWidget
  Widget _singleMusicSelectWidget(int index) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMusicIndex = index;
            _isMusicPlaying = true;
          });
        },
        child: Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40).r,
            border: Border.all(
              color: _selectedMusicIndex == index
                  ? Colors.grey.shade300
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40).r,
            child: Image.asset(
              'images/newUIScreen/bigScreenAnimation/bigDeviceFirstPage/0${index + 1}.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.grey);
              },
            ),
          ),
        ),
      ),
    );
  }

  /// 单个数据展示 — 1:1 还原 _singleDataShow
  Widget _singleDataShow(String title, String unit, String data) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 30).r,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 8.sp, color: Colors.white),
                  ),
                  Text(
                    unit,
                    style: TextStyle(fontSize: 8.sp, color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                data,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.bebas,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
