import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ftms/device_time_normalizer.dart';
import '../../../core/ftms/ftms_command_dispatcher.dart';
import '../../../core/ftms/ftms_control_response.dart';
import '../../../core/ftms/ftms_data_sync_guard.dart';
import '../../../core/ftms/ftms_device_data.dart';
import '../../../core/ftms/ftms_device_type.dart';
import '../../../core/ftms/ftms_param_sync_engine.dart';
import '../../../core/ftms/ftms_service_base.dart';
import '../../../core/ftms/ftms_service_provider.dart';
import '../../../core/ftms/ftms_status_parser.dart';
import '../../../core/ftms/sport_timer.dart';
import '../mixins/device_control_mixin.dart';
import '../states/goal_banner_display_state.dart';
import '../states/quick_start_state.dart';
import '../utils/device_field_visibility.dart';

part 'quick_start_notifier.g.dart';

// ==================== 目标达成弹窗阈值常量（集中调节入口，严格对齐 XML 档位表） ====================
/// 时间目标档位（分钟）。XML 表格「5/10/15/20/30/45/60/90/120/180」MIN
const List<int> kTimeGoalLevelsMin = [5, 10, 15, 20, 30, 45, 60, 90, 120, 180];

/// 时间目标档位（秒，供内部比对用，由 [kTimeGoalLevelsMin] × 60 生成）。
List<int> get _kTimeGoalLevelsSec =>
    kTimeGoalLevelsMin.map((m) => m * 60).toList(growable: false);

/// 距离目标档位（公里）。XML 表格「0.5/1/2/3/5/8/10/15/20/30/50/70」KM
const List<double> kDistanceGoalLevelsKm = [
  0.5,
  1,
  2,
  3,
  5,
  8,
  10,
  15,
  20,
  30,
  50,
  70,
];

/// 距离目标档位（米，供内部比对用，由 [kDistanceGoalLevelsKm] × 1000 生成）。
List<double> get _kDistanceGoalLevelsM =>
    kDistanceGoalLevelsKm.map((km) => km * 1000).toList(growable: false);

/// 卡路里目标档位（千卡）。XML 表格「30/60/100/150/220/300/500/800/1000/1200/1500/2000」KCAL
const List<double> kEnergyGoalLevelsKcal = [
  30,
  60,
  100,
  150,
  220,
  300,
  500,
  800,
  1000,
  1200,
  1500,
  2000,
];

/// 目标弹窗自动关闭时长（秒）。
const int kGoalDialogAutoDismissSec = 5;

/// 目标弹窗类型枚举，用于队列管理。
enum GoalDialogType { time, distance, energy }

/// 快速开始 Notifier（Riverpod 3.0 代码生成）。
///
/// 接入 FTMS 蓝牙数据监听与运动控制，负责：
/// - 实时数据流（0x2AD1）解析与状态同步
/// - 设备状态流（0x2ADA）回调处理
/// - 运动控制指令（0x2AD9）下发
/// - 目标达成弹窗三态管理
@Riverpod(keepAlive: true)
class QuickStartNotifier extends _$QuickStartNotifier with DeviceControlMixin {
  FtmsDeviceType _deviceType = FtmsDeviceType.indoorBike;

  FtmsDeviceType get deviceType => _deviceType;

  // ==================== 数据帧日志计数器 ====================
  /// 数据帧接收计数器（用于控制日志频率，每 10 帧打印一次完整日志）
  int _dataFrameCount = 0;

  // ==================== FTMS 核心组件 ====================
  /// 运动计时器（本地计时 + 设备时间校准）
  SportTimer? _sportTimer;

  /// 设备时间归一化器（补偿 60 秒循环归零）
  DeviceTimeNormalizer? _timeNormalizer;

  /// 数据同步保护器（长按松手后屏蔽设备回调）
  FtmsDataSyncGuard? _syncGuard;

  /// FTMS 指令调度器（debounce / immediate / tracked 三模式）
  FtmsCommandDispatcher? _dispatcher;

  /// 参数同步引擎（命令锁窗口 + 匹配式同步 + 防超调，防弹跳核心）
  final FtmsParamSyncEngine _syncEngine = FtmsParamSyncEngine();

  /// 🔧 GATT 串行链：能力范围读取（含就绪等待）排队的 Future 链。
  ///
  /// 目的：
  /// 1. 多次 setDeviceType（入口页 + 训练页）触发的读取严格串行，避免并发 GATT 读；
  /// 2. sendResetToDevice 的 0x00 写入 await 本链后再发，避免「读范围 + 写指令」并发
  ///    打到设备（部分健身器材固件不支持并发 GATT 事务，会导致写入失败）。
  Future<void> _paramRangesChain = Future.value();

  /// 实时数据流订阅
  StreamSubscription<FtmsDeviceData>? _dataSubscription;

  /// 设备状态流订阅
  StreamSubscription<FtmsStatusEvent>? _statusSubscription;

  /// 控制点回执流订阅（0x2AD9 Indicate）
  StreamSubscription<FtmsControlResponse>? _responseSubscription;

  /// 设备连接状态流订阅（断连监听）
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;

  /// 设备字段可见性工具（复用划船机 m/s → km/h 速度换算逻辑）。
  DeviceFieldVisibility get _fieldVisibility =>
      DeviceFieldVisibility(_deviceType);

  // ==================== 按钮调节步长与范围常量（回退默认值） ====================
  // 设备能力范围（0x2AD4/0x2AD5/0x2AD6）读取成功后，按钮加减自动切换为
  // 设备上报的动态上下限（见 _loadDeviceParamRanges）；以下常量仅在
  // 设备未上报范围时的回退默认。
  static const double _resistanceStep = 1.0;
  static const double _resistanceMin = 0.0;
  static const double _resistanceMax = 32.0;

  static const double _speedStep = 0.5;
  static const double _speedMin = 0.0;

  /// 速度回退上限（km/h）。注意：不是 FTMS 原始值量级的 100，
  /// 与旧项目图表默认最大速度 20 km/h 对齐。
  static const double _speedMax = 20.0;

  static const double _inclinationStep = 0.5;
  static const double _inclinationMin = -10.0;
  static const double _inclinationMax = 15.0;

  // —— 动态上下限取值（设备上报优先，未读到回退常量） ——

  /// 速度上限（km/h）。
  double get _speedMaxEff =>
      state.speedRangeMax > 0 ? state.speedRangeMax : _speedMax;

  /// 速度下限（km/h）。
  double get _speedMinEff =>
      state.speedRangeMin > 0 ? state.speedRangeMin : _speedMin;

  /// 速度步长（km/h）。
  double get _speedStepEff =>
      state.speedRangeStep > 0 ? state.speedRangeStep : _speedStep;

  /// 阻力上限（level）。
  double get _resistanceMaxEff =>
      state.resistanceRangeMax > 0 ? state.resistanceRangeMax : _resistanceMax;

  /// 阻力下限（level）。
  double get _resistanceMinEff =>
      state.resistanceRangeMin > 0 ? state.resistanceRangeMin : _resistanceMin;

  /// 阻力步长（level）。
  double get _resistanceStepEff => state.resistanceRangeStep > 0
      ? state.resistanceRangeStep
      : _resistanceStep;

  /// 坡度上限（%）。
  double get _inclinationMaxEff => state.inclinationRangeMax > 0
      ? state.inclinationRangeMax
      : _inclinationMax;

  /// 坡度下限（%）。
  double get _inclinationMinEff => state.inclinationRangeMin != 0
      ? state.inclinationRangeMin
      : _inclinationMin;

  /// 坡度步长（%）。
  double get _inclinationStepEff => state.inclinationRangeStep > 0
      ? state.inclinationRangeStep
      : _inclinationStep;

  // ==================== 长按连续加减 ====================
  /// 长按定时器（500ms 周期，步长 1.0，对齐旧项目 _handleLongPress）。
  Timer? _longPressTimer;

  /// 长按步长（固定 1.0，与旧项目 _adjustValue 的 value += 1.0 一致）。
  static const double _longPressStep = 1.0;

  /// 当前长按调节维度（用于 longPressEnd 时识别上下文）。
  _LongPressDimension? _currentLongPressDimension;

  // ==================== 目标达成弹窗：Timer 与队列 ====================
  // 自动关闭计时（visible 状态 5 秒后触发 exiting）
  Timer? _timeGoalTimer;
  Timer? _distanceGoalTimer;
  Timer? _energyGoalTimer;
  // 入场动画计时（entering 状态 300ms 后切到 visible）
  Timer? _timeGoalEnteringTimer;
  Timer? _distanceGoalEnteringTimer;
  Timer? _energyGoalEnteringTimer;
  // 退场动画计时（exiting 状态 250ms 后切到 hidden 并推进队列）
  Timer? _timeGoalExitingTimer;
  Timer? _distanceGoalExitingTimer;
  Timer? _energyGoalExitingTimer;

  /// 弹窗队列：当已有弹窗显示时，后续入队等待展示。
  final List<GoalDialogType> _pendingDialogQueue = [];

  void setDeviceType(FtmsDeviceType type) {
    _deviceType = type;
    // 仅设置设备类型相关的 UI 配置（预设档位列表、坡度支持标记），
    // 运动数据全部由 FTMS dataStream / statusStream 实时驱动，不再注入 mock 值。
    state = _getDeviceConfigState(type);
    // 设备类型变更后重新绑定 FTMS 数据流与指令调度器
    _setupDispatcher();
    _setupStreams();
  }

  /// 根据设备类型返回 UI 配置状态（仅预设档位列表 + 坡度支持标记）。
  ///
  /// **不含任何运动数据**：时间 / 距离 / 卡路里 / 速度 / 踏频 / 心率 / 桨频 / 桨数
  /// 等全部由 [_onDataReceived] 从 FTMS 实时数据流写入。
  /// 按钮当前值（sportXxxButton）也由 [_onStatusReceived] 从设备回调同步。
  QuickStartState _getDeviceConfigState(FtmsDeviceType type) {
    switch (type) {
      case FtmsDeviceType.indoorBike:
        // 单车：阻力预设 4 档，不支持坡度
        return state.copyWith(
          buttonResistanceList: [4.0, 6.0, 10.0, 12.0],
          buttonSpeedList: [0.0, 0.0, 0.0, 0.0],
          buttonInclinationList: [0.0, 0.0, 0.0, 0.0],
          hasInclinationSupport: false,
          hasSpeedSupport: false,
          hasResistanceSupport: true,
        );
      case FtmsDeviceType.treadmill:
        // 跑步机：速度 + 坡度各 4 档预设，支持坡度
        return state.copyWith(
          buttonResistanceList: [0.0, 0.0, 0.0, 0.0],
          buttonSpeedList: [4.0, 6.0, 10.0, 12.0],
          buttonInclinationList: [0.0, 1.0, 5.0, 7.0],
          hasInclinationSupport: true,
          hasSpeedSupport: true,
          hasResistanceSupport: false,
        );
      case FtmsDeviceType.crossTrainer:
        // 椭圆机：仅阻力 4 档预设，无坡度（设备特性：只有阻力调节）
        return state.copyWith(
          buttonResistanceList: [6.0, 9.0, 15.0, 18.0],
          buttonSpeedList: [0.0, 0.0, 0.0, 0.0],
          buttonInclinationList: [0.0, 0.0, 0.0, 0.0],
          hasInclinationSupport: false,
          hasSpeedSupport: false,
          hasResistanceSupport: true,
        );
      case FtmsDeviceType.rower:
        // 划船机：阻力预设 4 档，不支持坡度
        return state.copyWith(
          buttonResistanceList: [2.0, 4.0, 8.0, 10.0],
          buttonSpeedList: [0.0, 0.0, 0.0, 0.0],
          buttonInclinationList: [0.0, 0.0, 0.0, 0.0],
          hasInclinationSupport: false,
          hasSpeedSupport: false,
          hasResistanceSupport: true,
        );
      case FtmsDeviceType.strengthStation:
        return state;
    }
  }

  @override
  QuickStartState build() {
    // 1. 初始化运动计时器，设置每秒 tick 回调更新 state.realSportTime
    _sportTimer = SportTimer();
    _sportTimer!.onTick = (elapsed) {
      // 单调递增守卫：本地计时与设备帧时间存在 1~2s 交替偏差时，
      // 仅当本地值不小于当前显示值才写入，避免时间往复闪烁
      if (elapsed >= state.realSportTime) {
        state = state.copyWith(realSportTime: elapsed);
      }
    };

    // 2. 初始化设备时间归一化器（补偿 60 秒循环归零）
    _timeNormalizer = DeviceTimeNormalizer();

    // 3. 初始化数据同步保护器
    _syncGuard = FtmsDataSyncGuard();

    // 4. 初始化 FTMS 指令调度器与数据流监听
    _setupDispatcher();
    _setupStreams();

    // 5. 注册 dispose 回调，清理所有资源
    ref.onDispose(() {
      print('[Notifier] build onDispose: 清理资源');
      _dataSubscription?.cancel();
      _statusSubscription?.cancel();
      _responseSubscription?.cancel();
      _connectionStateSubscription?.cancel();
      _sportTimer?.dispose();
      _dispatcher?.dispose();
      _longPressTimer?.cancel();
      _longPressTimer = null;
      _cancelTimeGoalTimers();
      _cancelDistanceGoalTimers();
      _cancelEnergyGoalTimers();
      _pendingDialogQueue.clear();
    });

    return const QuickStartState();
  }

  // ==================== FTMS 资源初始化与流监听 ====================

  /// 获取当前设备类型对应的 FtmsServiceBase 实例。
  FtmsServiceBase? _getFtmsService() {
    try {
      return ref.read(ftmsServiceProvider(_deviceType));
    } catch (e) {
      print('[Notifier] _getFtmsService error: $e');
      return null;
    }
  }

  /// 初始化 FTMS 指令调度器。
  ///
  /// 传入 getter 函数而非缓存 service 引用,确保 dispatcher 每次执行指令时
  /// 都通过 `ref.read` 获取最新 FtmsService 实例。
  /// 断开重连后 provider 重建为新实例,getter 自动返回新实例,
  /// 避免 dispatcher 持有旧实例的失效特征值引用。
  void _setupDispatcher() {
    _dispatcher = FtmsCommandDispatcher(
      serviceGetter: _getFtmsService,
      syncGuard: _syncGuard,
      onCommandFailed: _handleCommandFailed,
      onRetryExhausted: _handleRetryExhausted,
    );
    print('[Notifier] _setupDispatcher: dispatcher 已创建(getter 模式)');
  }

  /// 指令重发耗尽处理：提示用户并标记失败（按钮值保持用户输入不回滚）。
  void _handleRetryExhausted(int opCode) {
    print('[Notifier] ❌ 指令重发耗尽: opCode=0x${opCode.toRadixString(16)}');
    Fluttertoast.showToast(
      msg: '指令发送失败，请检查设备状态',
      toastLength: Toast.LENGTH_LONG,
    );
    state = state.copyWith(lastParamSyncFailed: true);
  }

  /// 页面消费失败标志后复位（Toast 已由重发耗尽回调弹出）。
  void markParamSyncFailedConsumed() {
    state = state.copyWith(lastParamSyncFailed: false);
  }

  /// 蓝牙指令下发失败统一处理（按失败类型分类）。
  ///
  /// - [FtmsCommandFailure.serviceUnavailable] / [FtmsCommandFailure.serviceNotReady]:
  ///   连接建立期的正常现象（服务发现中 / 实例重建中），
  ///   有「就绪等待 + 0x00 串行链」兜底 → **仅记日志，不弹 Toast**。
  /// - [FtmsCommandFailure.writeError]: 真实写入异常（GATT 错误等），
  ///   防抖（3 秒内仅弹一次）后提示用户重启蓝牙重连。
  DateTime? _lastBluetoothErrorToastTime;

  void _handleCommandFailed(FtmsCommandFailure type, String error) {
    // 服务不可用 / 未就绪：静默（连接建立期正常现象，避免误报骚扰用户）
    if (type != FtmsCommandFailure.writeError) {
      print('[Notifier] ⏳ 指令跳过(type=$type): $error（服务建立期，静默）');
      return;
    }
    print('[Notifier] ⚠️ 指令下发失败(type=$type): $error');
    final now = DateTime.now();
    if (_lastBluetoothErrorToastTime != null &&
        now.difference(_lastBluetoothErrorToastTime!) <
            const Duration(seconds: 3)) {
      // 防抖窗口内，跳过 Toast
      return;
    }
    _lastBluetoothErrorToastTime = now;
    Fluttertoast.showToast(
      msg: '蓝牙指令发送失败，请尝试重启手机蓝牙后重新连接设备',
      toastLength: Toast.LENGTH_LONG,
    );
  }

  /// 绑定 FTMS 数据流与状态流监听。
  /// 在 build() 和 setDeviceType() 时调用，会先取消旧订阅再创建新订阅。
  void _setupStreams() {
    final ftmsService = _getFtmsService();
    if (ftmsService == null) {
      print('[Notifier] _setupStreams: ftmsService 为 null，跳过');
      return;
    }

    // 取消旧订阅
    _dataSubscription?.cancel();
    _statusSubscription?.cancel();
    _responseSubscription?.cancel();
    _connectionStateSubscription?.cancel();

    // 监听实时数据流（0x2AD1）
    _dataSubscription = ftmsService.dataStream.listen(_onDataReceived);
    // 监听设备状态流（0x2ADA）
    _statusSubscription = ftmsService.statusStream.listen(_onStatusReceived);
    // 监听控制点回执流（0x2AD9 Indicate，用于确认指令已被设备接受）
    _responseSubscription = ftmsService.responseStream.listen(
      _onControlResponseReceived,
    );
    // 监听设备连接状态流（断连时解锁同步引擎并停止本地计时）
    _connectionStateSubscription = ftmsService.connectionStateStream.listen((
      connState,
    ) {
      if (connState == BluetoothConnectionState.disconnected) {
        print('[Notifier] ⚠️ 设备断开连接');
        _syncEngine.unlockAll();
        _sportTimer?.stop();
        state = state.copyWith(isDeviceConnectionLost: true);
      }
    });

    print(
      '[Notifier] _setupStreams: dataStream / statusStream / responseStream / connectionStateStream 已订阅',
    );

    // 读取设备能力范围（0x2AD4/0x2AD5/0x2AD6），用于按钮加减的动态上下限。
    // 🔧 GATT 串行化：排队到 _paramRangesChain（等上一个读取链完成 → 等服务就绪 → 按能力读取），
    // 保证多次 setDeviceType 触发的读取严格串行，且与 0x00 控制写入不并发。
    _paramRangesChain = _paramRangesChain.then((_) async {
      final svc = await _waitForServiceReady();
      if (svc != null) {
        await _loadDeviceParamRanges(svc);
      } else {
        print('[Range] ⚠️ 等待服务就绪超时，本次跳过能力范围读取（保持回退默认值）');
      }
    });
  }

  /// 等待 FTMS 服务就绪（实例存在且 isReady=true）。
  ///
  /// 轮询间隔 300ms，最长 [timeout]；超时返回 null（调用方回退默认范围常量）。
  /// 场景：页面进入时蓝牙刚连上、服务发现仍在进行中（connect() 异步），
  /// 若不等待，能力读取与控制写入都会因 isReady=false 失败。
  Future<FtmsServiceBase?> _waitForServiceReady({
    Duration timeout = const Duration(seconds: 6),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      final svc = _getFtmsService();
      if (svc != null && svc.isReady) return svc;
      await Future.delayed(const Duration(milliseconds: 300));
    }
    return null;
  }

  /// 🔴 模块分离：暂停监听设备流（课程播放页接管设备时调用）。
  ///
  /// 本 Notifier 是 keepAlive，页面退出后订阅仍存活；
  /// 若不暂停，快速开始与课程播放会同时监听同一设备流、
  /// 同时响应同一事件（双重 confirmReceipt / 双重状态更新 / 互相干扰）。
  ///
  /// 行为：仅取消 4 个流订阅 + 停止本地计时器 + 丢弃 debounce 待发指令，
  /// **不 dispose、不清 state**——用户回到快速开始页时，
  /// 页面 initState → setDeviceType() → _setupStreams() 自动重新订阅。
  void pauseListening() {
    print('[Notifier] pauseListening: 快速开始暂停设备流监听（课程页接管设备）');
    _dataSubscription?.cancel();
    _dataSubscription = null;
    _statusSubscription?.cancel();
    _statusSubscription = null;
    _responseSubscription?.cancel();
    _responseSubscription = null;
    _connectionStateSubscription?.cancel();
    _connectionStateSubscription = null;
    _sportTimer?.stop();
    _longPressTimer?.cancel();
    _longPressTimer = null;
    _dispatcher?.cancelPending();
  }

  /// 读取设备能力范围特征值并写入 state（按钮加减动态上限的数据源）。
  ///
  /// - 速度：0x2AD4 Supported Speed Range（uint16 ×3，单位 0.01 km/h → ÷100）
  /// - 坡度：0x2AD5 Supported Inclination Range（sint16 ×3，单位 0.1% → ÷10）
  /// - 阻力：0x2AD6 Supported Resistance Level Range（sint16 ×3，旧项目按 ÷10 换算）
  ///
  /// 各维度 [min, max, step]；特征值不存在（设备不支持）时跳过该维度，
  /// 按钮回退默认常量上下限。
  ///
  /// 🔧 按设备能力过滤读取维度（与 FtmsDeviceTypeConfig 对齐）：
  /// - 速度：仅跑步机读取（supportsSpeedControl）
  /// - 坡度：跑步机 / 椭圆机读取（supportsInclinationControl）
  /// - 阻力：非跑步机读取（supportsResistanceControl）
  ///
  /// 跑步机**禁止读取 0x2AD6**：跑步机固件返回的原始值（如 max=2550）被 ÷10
  /// 换算成 0~255 后会污染阻力预设档位（[0,85,170,255]），
  /// 造成「跑步机页面出现阻力 0-255」的错误数据源。
  Future<void> _loadDeviceParamRanges(FtmsServiceBase ftmsService) async {
    // —— 速度范围（仅跑步机） ——
    if (!_deviceType.supportsSpeedControl) {
      print('[Range] ⏭️ 速度范围(0x2AD4)：$_deviceType 不支持速度控制，跳过读取');
    } else {
      try {
        final data = await ftmsService.readSpeedRange();
        if (data != null && data.length >= 6) {
          final min = _readUint16LE(data, 0);
          final max = _readUint16LE(data, 2);
          final step = _readUint16LE(data, 4);
          // 设备上报范围无效（max <= min，如 0/0）→ 设备实际不支持速度调节
          // → 隐藏速度按钮组并清空速度预设，避免出现无效调节
          final speedUsable = max > min;
          state = state.copyWith(
            speedRangeMin: min / 100,
            speedRangeMax: max / 100,
            speedRangeStep: step / 100,
            hasSpeedSupport: speedUsable,
            buttonSpeedList: speedUsable
                ? state.buttonSpeedList
                : [0.0, 0.0, 0.0, 0.0],
          );
          print(
            '[Range] 📏 速度范围(0x2AD4): min=${min / 100}km/h, '
            'max=${max / 100}km/h, step=${step / 100}km/h（原始 $min/$max/$step）'
            '${speedUsable ? '' : ' → 设备不支持速度调节，已隐藏速度按钮组'}',
          );
        }
      } catch (e) {
        print('[Range] ⚠️ 速度范围读取失败（设备不支持）: $e');
      }
    }

    // —— 坡度范围（跑步机 / 椭圆机） ——
    if (!_deviceType.supportsInclinationControl) {
      print('[Range] ⏭️ 坡度范围(0x2AD5)：$_deviceType 不支持坡度控制，跳过读取');
    } else {
      try {
        final data = await ftmsService.readInclinationRange();
        if (data != null && data.length >= 6) {
          final min = _readSint16LE(data, 0);
          final max = _readSint16LE(data, 2);
          final step = _readUint16LE(data, 4);
          // 设备上报范围无效（max <= min，如 0/0）→ 设备实际不支持坡度调节
          // → 隐藏坡度按钮组并清空坡度预设，避免出现无效调节
          final inclinationUsable = max > min;
          state = state.copyWith(
            inclinationRangeMin: min / 10,
            inclinationRangeMax: max / 10,
            inclinationRangeStep: step / 10,
            hasInclinationSupport: inclinationUsable,
            buttonInclinationList: inclinationUsable
                ? state.buttonInclinationList
                : [0.0, 0.0, 0.0, 0.0],
          );
          print(
            '[Range] 📏 坡度范围(0x2AD5): min=${min / 10}%, '
            'max=${max / 10}%, step=${step / 10}%（原始 $min/$max/$step）'
            '${inclinationUsable ? '' : ' → 设备不支持坡度，已隐藏坡度按钮组'}',
          );
        }
      } catch (e) {
        print('[Range] ⚠️ 坡度范围读取失败（设备不支持）: $e');
      }
    }

    // —— 阻力范围（非跑步机：单车/椭圆机/划船机） ——
    if (!_deviceType.supportsResistanceControl) {
      print(
        '[Range] ⏭️ 阻力范围(0x2AD6)：$_deviceType 不支持阻力控制，跳过读取（防止跑步机 0-255 污染）',
      );
    } else {
      try {
        final data = await ftmsService.readResistanceRange();
        if (data != null && data.length >= 6) {
          final min = _readSint16LE(data, 0);
          final max = _readSint16LE(data, 2);
          final step = _readUint16LE(data, 4);
          // 设备上报范围无效（max <= min，如 0/0）→ 设备实际不支持阻力调节
          // → 隐藏阻力按钮组并清空阻力预设，避免出现无效调节
          final resistanceUsable = max > min;
          state = state.copyWith(
            resistanceRangeMin: min / 10,
            resistanceRangeMax: max / 10,
            resistanceRangeStep: step / 10,
            hasResistanceSupport: resistanceUsable,
            buttonResistanceList: resistanceUsable
                ? state.buttonResistanceList
                : [0.0, 0.0, 0.0, 0.0],
          );
          print(
            '[Range] 📏 阻力范围(0x2AD6): min=${min / 10}, '
            'max=${max / 10}, step=${step / 10}（原始 $min/$max/$step）'
            '${resistanceUsable ? '' : ' → 设备不支持阻力调节，已隐藏阻力按钮组'}',
          );
        }
      } catch (e) {
        print('[Range] ⚠️ 阻力范围读取失败（设备不支持）: $e');
      }
    }

    // 根据设备实际能力范围，动态更新预设按钮值
    _updatePresetButtonsByDeviceRange();
  }

  /// 根据设备实际读取的范围，动态计算 4 档预设按钮值。
  ///
  /// 规则：将 [min, max] 区间均匀分成 4 档，端点取 min 和 max。
  /// 设备返回了有效范围（max > min）时才更新，否则保持原有硬编码值。
  void _updatePresetButtonsByDeviceRange() {
    List<double>? newSpeedList;
    List<double>? newInclinationList;
    List<double>? newResistanceList;

    // —— 速度预设 ——
    // 使用 max > min 判断设备是否返回了有效范围（而非 max > 0）
    // 因为速度 min 可能是 0，max 一定 > 0；坡度 max 可能为 0（如 -10%~0%）
    if (state.speedRangeMax > state.speedRangeMin) {
      newSpeedList = _calcPresetButtons(
        state.speedRangeMin,
        state.speedRangeMax,
      );
      print('[Preset] 🚀 速度预设: ${newSpeedList.join(', ')}');
    }

    // —— 坡度预设 ——
    // 坡度可能有负值，且 max 可能为 0（如 -10%~0%），所以用 max > min 判断
    if (state.inclinationRangeMax > state.inclinationRangeMin) {
      newInclinationList = _calcPresetButtons(
        state.inclinationRangeMin,
        state.inclinationRangeMax,
      );
      print('[Preset] ⛰️ 坡度预设: ${newInclinationList.join(', ')}');
    }

    // —— 阻力预设 ——
    if (state.resistanceRangeMax > state.resistanceRangeMin) {
      newResistanceList = _calcPresetButtons(
        state.resistanceRangeMin,
        state.resistanceRangeMax,
      );
      print('[Preset] 💪 阻力预设: ${newResistanceList.join(', ')}');
    }

    // 仅更新有效维度，保持其他维度原有值
    if (newSpeedList != null ||
        newInclinationList != null ||
        newResistanceList != null) {
      state = state.copyWith(
        buttonSpeedList: newSpeedList ?? state.buttonSpeedList,
        buttonInclinationList:
            newInclinationList ?? state.buttonInclinationList,
        buttonResistanceList: newResistanceList ?? state.buttonResistanceList,
      );
      print(
        '[Preset] ✅ 预设按钮已更新: speed=${newSpeedList ?? "保持"}, '
        'inclination=${newInclinationList ?? "保持"}, '
        'resistance=${newResistanceList ?? "保持"}',
      );
    }
  }

  /// 将 [min, max] 区间均匀分成 4 档，返回 4 个预设值。
  ///
  /// 示例：min=0, max=12 → [0, 4, 8, 12]
  List<double> _calcPresetButtons(double min, double max) {
    if (max <= min) return [min, min, min, min];
    final step = (max - min) / 3;
    return [
      double.parse((min).toStringAsFixed(1)),
      double.parse((min + step).toStringAsFixed(1)),
      double.parse((min + step * 2).toStringAsFixed(1)),
      double.parse((max).toStringAsFixed(1)),
    ];
  }

  /// 小端 uint16 解析。
  int _readUint16LE(List<int> data, int offset) =>
      data[offset] + data[offset + 1] * 256;

  /// 小端 sint16 解析（二补码，支持负坡度）。
  int _readSint16LE(List<int> data, int offset) {
    final raw = _readUint16LE(data, offset);
    return raw >= 0x8000 ? raw - 0x10000 : raw;
  }

  /// 控制点回执（0x2AD9 Response）处理。
  ///
  /// - success：确认指令跟踪（结束超时重发计时）
  /// - 失败：仅记录日志，不重置重发轨道（交由 dispatcher 超时轨道统一处理，
  ///   避免与设备端延迟回执产生竞态）
  void _onControlResponseReceived(FtmsControlResponse resp) {
    if (resp.resultCode == FtmsControlResultCode.success) {
      _dispatcher?.confirmReceipt(resp.requestOpCode);
      print(
        '[Receipt] 回执成功: request=0x${resp.requestOpCode.toRadixString(16)}',
      );
    } else {
      print(
        '[Receipt] ⚠️ 回执失败: request=0x${resp.requestOpCode.toRadixString(16)}, '
        'result=${resp.resultCode.name}',
      );
    }
  }

  // ==================== 实时数据流处理（Task 11） ====================

  /// 收到 FTMS 实时数据时的处理逻辑。
  /// 1. 归一化设备时间
  /// 2. 校准本地计时器
  /// 3. 更新 state 中的运动数据
  /// 4. 检测设备运行状态（任务5）
  /// 5. 检查目标弹窗
  void _onDataReceived(FtmsDeviceData data) {
    // ========== 数据帧日志（每 10 帧打印一次完整日志） ==========
    _dataFrameCount++;
    final shouldLog = _dataFrameCount % 10 == 0;
    if (shouldLog) {
      _logDeviceDataFrame(data);
    }
    // 首次接收帧打印详细日志
    if (_dataFrameCount <= 3) {
      _logDeviceDataFrame(data);
    }

    // 取本帧速度/踏频/桨频（null 时保留旧值），用于设备运行检测
    final speed = data.instSpeed ?? state.sportSpeed;
    final cadence = data.instCadence ?? state.sportCadence;
    final strokeRate = data.strokesPerMin ?? state.sportStrokeRate;

    // 任务5：检测设备运行状态（速度/踏频/桨频任一 > 0 即视为运行中）
    // ⚠️ 此检测必须在停止态守卫之前执行：否则用户未点开始就蹬踏时，
    // isDeviceRunningDetected 永远不会被置 true，阻塞层无法弹出，
    // 用户就能带着未清零的数据进入下级界面（违反业务约束）。
    //
    // ⚠️ 用户主动开始（isPlaying=true）后，设备运行是预期行为，
    // 不应触发阻塞弹窗；仅当用户未主动开始（isPlaying=false）时
    // 才检测设备被动运行。
    if (!state.isPlaying) {
      final isRunning = speed > 0 || cadence > 0 || strokeRate > 0;
      if (isRunning != state.isDeviceRunningDetected) {
        state = state.copyWith(isDeviceRunningDetected: isRunning);
        print(
          '🔍 [DeviceCheck] data stream → running=$isRunning '
          '(speed=$speed, cadence=$cadence, stroke=$strokeRate)',
        );
      }
    }

    // 停止态守卫：非播放态时，仅做运行检测，不更新运动数据、不校准计时器、
    // 不检查目标弹窗。防止：
    // 1. syncFromDevice → _calibrate 复活已停止的计时器（"停止后依旧计时"）
    // 2. 残留/胡乱蹬踏数据帧污染已清零的运动数据
    // 3. 停止态触发目标弹窗
    if (!state.isPlaying) {
      return;
    }

    // 归一化设备时间（补偿 60 秒循环归零）
    final rawElapsed = data.timeElapsed ?? 0;
    final normalizedTime = _timeNormalizer!.normalize(rawElapsed);

    // 用归一化值校准本地计时器
    _sportTimer!.syncFromDevice(normalizedTime);

    // 速度实际值：本帧 instSpeed 优先；划船机需 m/s → km/h 换算（复用 convertSpeed）。
    // 旧值 sportSpeedActual 已换算过，保留旧值时不可重复换算。
    final speedActual = data.instSpeed != null
        ? _fieldVisibility.convertSpeed(data.instSpeed!)
        : state.sportSpeedActual;

    // 更新 state 中的运动数据（三维度实际值 null 保留旧值）。
    // ⚠️ 防弹跳根因修复：阻力/坡度按钮值不再由数据帧直接覆盖，
    // 改由 _processParamSync 决策（命令锁 + 匹配式同步）驱动。
    //
    // 单调递增守卫：时间/距离/卡路里/桨数为累计量，物理上只增不减。
    // 设备抖动帧回退旧值、或本地计时器与设备帧时间交错写入时，
    // 统一取「较大值」，杜绝顶栏数据往复闪烁。
    state = state.copyWith(
      // 时间：仅本地计时器真正运行中才允许设备帧驱动显示。
      // 武装等待期（点开始后设备未计时的几秒）设备帧值不写入，
      // 杜绝「0-1-2 后停住」的假启动显示。
      realSportTime:
          _sportTimer!.isRunning && normalizedTime >= state.realSportTime
          ? normalizedTime
          : state.realSportTime,
      sportDistance: (data.distTotal ?? 0).toDouble() >= state.sportDistance
          ? (data.distTotal ?? 0).toDouble()
          : state.sportDistance,
      sportEnergy: (data.energyTotal ?? 0).toDouble() >= state.sportEnergy
          ? (data.energyTotal ?? 0).toDouble()
          : state.sportEnergy,
      sportSpeed: speed,
      sportCadence: cadence,
      sportHeartRate: data.hr ?? state.sportHeartRate,
      sportStrokeRate: strokeRate,
      sportStrokeCount:
          (data.strokeCountTotal ?? 0).toDouble() >= state.sportStrokeCount
          ? (data.strokeCountTotal ?? 0).toDouble()
          : state.sportStrokeCount,
      sportSpeedActual: speedActual,
      sportResistanceActual: data.resistanceLvl ?? state.sportResistanceActual,
      sportInclinationActual: data.inclineAngle ?? state.sportInclinationActual,
      npcTime: normalizedTime.toDouble(),
    );

    // 参数同步决策（防弹跳核心）：仅播放态可到达此处（上方守卫已拦截非播放态）
    _processParamSync(ParamDimension.speed, speedActual, 0x02);
    _processParamSync(
      ParamDimension.resistance,
      data.resistanceLvl ?? state.sportResistanceActual,
      0x04,
    );
    _processParamSync(
      ParamDimension.inclination,
      data.inclineAngle ?? state.sportInclinationActual,
      0x03,
    );

    // 检查目标弹窗
    _checkAndTriggerGoalDialogs();
  }

  /// 参数同步决策统一处理（防弹跳核心）。
  ///
  /// - matched：解锁 + 按钮同步 + 确认指令跟踪
  /// - waiting：仅实际值更新，按钮保持（防弹跳）
  /// - lockTimeout：解除锁定标志，走 dispatcher 超时重发轨道
  /// - stableIdle：未锁定时设备端稳定值同步按钮（设备优先级）
  void _processParamSync(ParamDimension dim, double actual, int opCode) {
    // 阻力维度：设备回传值取整，保持按钮值为整数
    final roundedActual = dim == ParamDimension.resistance
        ? actual.round().toDouble()
        : actual;
    final decision = _syncEngine.onActualUpdate(dim, roundedActual);
    switch (decision) {
      case ParamSyncMatched():
        // 匹配成功：确认指令跟踪 + 解锁 + 按钮写实际值
        _dispatcher?.confirmReceipt(opCode);
        state = _copyWithDimState(dim, buttonValue: roundedActual, locked: false);
        print('[Notifier] ✅ 参数同步成功: dim=${dim.name}, value=$roundedActual');
      case ParamSyncLockTimeout():
        // 锁超时：仅解锁标志，按钮保持用户输入，等待指令重发轨道
        state = _copyWithDimState(dim, locked: false);
        print('[Notifier] ⏰ 锁超时: dim=${dim.name}，等待指令重发轨道');
      case ParamSyncStableIdle(:final value):
        // 设备端自行调整后稳定：未锁定时同步按钮（设备优先级）
        if (!_syncEngine.isLocked(dim)) {
          final roundedValue = dim == ParamDimension.resistance
              ? value.round().toDouble()
              : value;
          state = _copyWithDimState(dim, buttonValue: roundedValue);
          print('[Notifier] 📡 设备端稳定值同步按钮: dim=${dim.name}, value=$roundedValue');
        }
      case ParamSyncWaiting():
        // 中间值/渐变中：不改按钮（实际值已在主 copyWith 中更新）
        break;
    }
  }

  /// 按维度映射写回按钮值与锁定标志（null 时保留当前值）。
  QuickStartState _copyWithDimState(
    ParamDimension dim, {
    double? buttonValue,
    bool? locked,
  }) {
    switch (dim) {
      case ParamDimension.speed:
        return state.copyWith(
          sportSpeedButton: buttonValue ?? state.sportSpeedButton,
          isSpeedLocked: locked ?? state.isSpeedLocked,
        );
      case ParamDimension.inclination:
        return state.copyWith(
          sportInclinationButton: buttonValue ?? state.sportInclinationButton,
          isInclinationLocked: locked ?? state.isInclinationLocked,
        );
      case ParamDimension.resistance:
        return state.copyWith(
          sportResistanceButton: buttonValue ?? state.sportResistanceButton,
          isResistanceLocked: locked ?? state.isResistanceLocked,
        );
    }
  }

  /// 打印设备数据帧详细日志
  ///
  /// 用于验证实时数据通道返回的字段内容,包含:
  /// - 设备类型和数据通道 UUID
  /// - 所有关键字段的值（速度、阻力、坡度、踏频、心率等）
  /// - null 字段标注（表示该设备不支持该字段）
  void _logDeviceDataFrame(FtmsDeviceData data) {
    final deviceName = _deviceType.name;
    final channelUuid = _deviceType.dataCharacteristicUuid.toString();

    // 格式化字段值的辅助方法
    String fmt(dynamic value, {String unit = ''}) {
      if (value == null) return 'null';
      if (value is double) return '${value.toStringAsFixed(2)}$unit';
      return '$value$unit';
    }

    final buffer = StringBuffer()
      ..writeln('')
      ..writeln('╔══════════════════════════════════════════════════════╗')
      ..writeln('║   📡 [FTMS] 实时数据帧接收日志                        ║')
      ..writeln('╠══════════════════════════════════════════════════════╣')
      ..writeln('║ 帧编号: #$_dataFrameCount')
      ..writeln('║ 设备类型: $deviceName')
      ..writeln('║ 数据通道: $channelUuid')
      ..writeln('╠══════════════════════════════════════════════════════╣')
      ..writeln('║ 【运动控制参数】')
      ..writeln(
        '║   瞬时速度 (instSpeed):      ${fmt(data.instSpeed, unit: ' km/h')}',
      )
      ..writeln('║   阻力等级 (resistanceLvl):   ${fmt(data.resistanceLvl)}')
      ..writeln(
        '║   坡度角度 (inclineAngle):    ${fmt(data.inclineAngle, unit: ' %')}',
      )
      ..writeln('║   设备状态 (machineState):    ${fmt(data.machineState)}')
      ..writeln('╠══════════════════════════════════════════════════════╣')
      ..writeln('║ 【运动数据】')
      ..writeln(
        '║   平均速度 (avgSpeed):        ${fmt(data.avgSpeed, unit: ' km/h')}',
      )
      ..writeln(
        '║   踏频 (instCadence):         ${fmt(data.instCadence, unit: ' rpm')}',
      )
      ..writeln(
        '║   平均踏频 (avgCadence):      ${fmt(data.avgCadence, unit: ' rpm')}',
      )
      ..writeln(
        '║   步频 (stepsPerMin):         ${fmt(data.stepsPerMin, unit: ' spm')}',
      )
      ..writeln(
        '║   桨频 (strokesPerMin):       ${fmt(data.strokesPerMin, unit: ' spm')}',
      )
      ..writeln(
        '║   瞬时功率 (instPower):       ${fmt(data.instPower, unit: ' W')}',
      )
      ..writeln('║   平均功率 (avgPower):        ${fmt(data.avgPower, unit: ' W')}')
      ..writeln('║   心率 (hr):                  ${fmt(data.hr, unit: ' bpm')}')
      ..writeln('║   代谢当量 (met):             ${fmt(data.met)}')
      ..writeln('╠══════════════════════════════════════════════════════╣')
      ..writeln('║ 【距离/能耗/时间】')
      ..writeln(
        '║   总距离 (distTotal):         ${fmt(data.distTotal, unit: ' m')}',
      )
      ..writeln(
        '║   总能耗 (energyTotal):       ${fmt(data.energyTotal, unit: ' kcal')}',
      )
      ..writeln(
        '║   运动时长 (timeElapsed):     ${fmt(data.timeElapsed, unit: ' s')}',
      )
      ..writeln(
        '║   剩余时间 (timeRemaining):   ${fmt(data.timeRemaining, unit: ' s')}',
      )
      ..writeln('║   总桨次 (strokeCountTotal):  ${fmt(data.strokeCountTotal)}')
      ..writeln('║   总步数 (strideCountTotal):  ${fmt(data.strideCountTotal)}')
      ..writeln('╠══════════════════════════════════════════════════════╣')
      ..writeln('║ 【配速/海拔】')
      ..writeln('║   瞬时配速 (instPace):        ${fmt(data.instPace)}')
      ..writeln('║   平均配速 (avgPace):         ${fmt(data.avgPace)}')
      ..writeln(
        '║   正海拔增益 (elevationGainPos): ${fmt(data.elevationGainPos, unit: ' m')}',
      )
      ..writeln(
        '║   负海拔增益 (elevationGainNeg): ${fmt(data.elevationGainNeg, unit: ' m')}',
      )
      ..writeln(
        '║   坡度角度 (rampAngle):       ${fmt(data.rampAngle, unit: ' °')}',
      )
      ..writeln('╠══════════════════════════════════════════════════════╣')
      ..writeln('║ 【设备特有字段】')
      ..writeln('║   运动方向 (movementDirection): ${fmt(data.movementDirection)}')
      ..writeln(
        '║   皮带受力 (forceOnBelt):    ${fmt(data.forceOnBelt, unit: ' N')}',
      )
      ..writeln(
        '║   每小时能耗 (energyPerHr):  ${fmt(data.energyPerHr, unit: ' kcal/h')}',
      )
      ..writeln(
        '║   每分钟能耗 (energyPerMin):  ${fmt(data.energyPerMin, unit: ' kcal/min')}',
      )
      ..writeln('╚══════════════════════════════════════════════════════╝');

    debugPrint(buffer.toString());
  }

  // ==================== 设备运行状态检测（任务5） ====================

  /// 进入界面时检测设备是否正在运行（供页面 initState 调用）。
  ///
  /// 判定依据：当前 state 中速度/踏频/桨频任一 > 0，或 isPlaying。
  /// 由于 FTMS 为 Notify 模式，进入瞬间可能尚未收到数据，
  /// 页面侧需配合数据流持续监听（isDeviceRunningDetected 变化时自动触发弹窗）。
  bool checkDeviceRunningOnEntry() {
    final isRunning =
        state.isPlaying ||
        state.sportSpeed > 0 ||
        state.sportCadence > 0 ||
        state.sportStrokeRate > 0;
    state = state.copyWith(isDeviceRunningDetected: isRunning);
    print(
      '🔍 [DeviceCheck] entry: '
      'speed=${state.sportSpeed}, cadence=${state.sportCadence}, '
      'stroke=${state.sportStrokeRate}, isPlaying=${state.isPlaying} '
      '→ running=$isRunning',
    );
    return isRunning;
  }

  // ==================== 设备就绪四级校验（Task 9.1） ====================

  /// 设备就绪四级校验（开始运动前调用，逐级排查失败原因）。
  ///
  /// 校验顺序：
  /// 1. 蓝牙连接（无法获取 FTMS 服务视为未连接）
  /// 2. FTMS 服务就绪（特征值已发现）
  /// 3. 首包数据（数据通道已收到至少一帧）
  /// 4. 参数初始态（未播放 + 设备未运行 + 三对 actual ≈ button）
  DeviceReadyResult validateDeviceReady() {
    // 第 1 级：蓝牙连接
    final ftmsService = _getFtmsService();
    if (ftmsService == null) {
      print('[DeviceCheck] validate step 1: 失败（无法获取 FTMS 服务，蓝牙未连接）');
      return const DeviceReadyResult(
        isReady: false,
        failedStep: 1,
        reason: '蓝牙未连接',
      );
    }
    print('[DeviceCheck] validate step 1: 通过（FTMS 服务实例可获取）');

    // 第 2 级：FTMS 服务就绪
    if (!ftmsService.isReady) {
      print('[DeviceCheck] validate step 2: 失败（FTMS 服务未就绪，isReady=false）');
      return const DeviceReadyResult(
        isReady: false,
        failedStep: 2,
        reason: 'FTMS 服务未就绪',
      );
    }
    print('[DeviceCheck] validate step 2: 通过（isReady=true）');

    // 第 3 级：首包数据
    if (!ftmsService.hasReceivedFirstData) {
      print('[DeviceCheck] validate step 3: 失败（未收到设备首包数据）');
      return const DeviceReadyResult(
        isReady: false,
        failedStep: 3,
        reason: '未收到设备首包数据',
      );
    }
    print('[DeviceCheck] validate step 3: 通过（hasReceivedFirstData=true）');

    // 第 4 级：参数初始态
    if (state.isPlaying) {
      print('[DeviceCheck] validate step 4: 失败（本地运动进行中 isPlaying=true）');
      return const DeviceReadyResult(
        isReady: false,
        failedStep: 4,
        reason: '本地运动进行中',
      );
    }
    if (state.isDeviceRunningDetected) {
      print(
        '[DeviceCheck] validate step 4: 失败（检测到设备运行中 isDeviceRunningDetected=true）',
      );
      return const DeviceReadyResult(
        isReady: false,
        failedStep: 4,
        reason: '设备正在运行',
      );
    }
    // 三对 actual ≈ button 容差判定（差值超容差视为未复位）
    final speedDiff = (state.sportSpeedActual - state.sportSpeedButton).abs();
    if (speedDiff > kParamTolerance[ParamDimension.speed]!) {
      print(
        '[DeviceCheck] validate step 4: 失败（速度未复位: '
        'actual=${state.sportSpeedActual}, button=${state.sportSpeedButton}）',
      );
      return const DeviceReadyResult(
        isReady: false,
        failedStep: 4,
        reason: '速度实际值与按钮值不一致',
      );
    }
    final resistanceDiff =
        (state.sportResistanceActual - state.sportResistanceButton).abs();
    if (resistanceDiff > kParamTolerance[ParamDimension.resistance]!) {
      print(
        '[DeviceCheck] validate step 4: 失败（阻力未复位: '
        'actual=${state.sportResistanceActual}, button=${state.sportResistanceButton}）',
      );
      return const DeviceReadyResult(
        isReady: false,
        failedStep: 4,
        reason: '阻力实际值与按钮值不一致',
      );
    }
    final inclinationDiff =
        (state.sportInclinationActual - state.sportInclinationButton).abs();
    if (inclinationDiff > kParamTolerance[ParamDimension.inclination]!) {
      print(
        '[DeviceCheck] validate step 4: 失败（坡度未复位: '
        'actual=${state.sportInclinationActual}, button=${state.sportInclinationButton}）',
      );
      return const DeviceReadyResult(
        isReady: false,
        failedStep: 4,
        reason: '坡度实际值与按钮值不一致',
      );
    }
    print('[DeviceCheck] validate step 4: 通过（未播放 + 设备未运行 + 参数已复位）');
    return const DeviceReadyResult(
      isReady: true,
      failedStep: 0,
      reason: '全部通过',
    );
  }

  // ==================== 设备状态流处理（Task 13） ====================

  /// 收到 FTMS 设备状态通知（0x2ADA）时的处理逻辑。
  /// 0x2ADA 既作为设备状态回调，也作为 0x2AD9 控制指令的隐式回执。
  void _onStatusReceived(FtmsStatusEvent event) {
    switch (event) {
      case FtmsStatusStartedResumed():
        // 0x04：设备开始/恢复运动
        print('[DeviceStatus] opCode=0x04, action=start');
        _onReceiptReceived(0x07, true);
        // 开始指令已被设备确认（0x2ADA 隐式回执），结束 0x07 跟踪重发
        _dispatcher?.confirmReceipt(0x07);
        if (!state.isPlaying) {
          // 设备自启动（用户未点开始就蹬踏）：不自动开始本地运动，
          // 仅标记设备运行中，触发阻塞层要求用户先手动停止再重新开始。
          // （若自动 _startSportLocal 会导致本地数据累积、阻塞层逻辑混乱）
          state = state.copyWith(isDeviceRunningDetected: true);
          print('🔍 [DeviceCheck] 设备自启动（0x04）但本地未播放 → 标记 running=true，触发阻塞层');
        } else {
          // 已点开始但计时器未运行（如启动流程中被 0x02 暂停事件停掉）：
          // 重新武装，等设备时间递增后以设备值为基准恢复计时
          if (_sportTimer?.isRunning != true) {
            _sportTimer?.resume();
            print('[DeviceStatus] 0x04 收到但计时器未运行 → 重新武装等待设备递增');
          }
        }
        break;

      case FtmsStatusStoppedPaused(:final isPause):
        if (isPause) {
          // 0x02 + 0x02：设备暂停
          print('[DeviceStatus] opCode=0x02, action=pause');
          _onReceiptReceived(0x07, true);
          // 暂停指令已被设备确认，结束 0x08 跟踪重发
          _dispatcher?.confirmReceipt(0x08);
          _sportTimer?.pause();
          state = state.copyWith(isPlaying: false);
        } else {
          // 0x02 + 0x01：设备停止
          print('[DeviceStatus] opCode=0x02, action=stop');
          _onReceiptReceived(0x07, true);
          // 停止指令已被设备确认，结束 0x08 跟踪重发
          _dispatcher?.confirmReceipt(0x08);
          _sportTimer?.stop();
          state = state.copyWith(isPlaying: false);
        }
        break;

      case FtmsStatusTargetSpeedChanged(:final speedKmPerH):
        // 0x05：速度回调（设备主动变更目标，含 0x02 指令隐式回执）
        // 设备优先级规则：设备返回值无条件覆盖本地按钮值（不设保护窗口阻塞）
        print('[DeviceStatus] opCode=0x05, action=speed, value=$speedKmPerH');
        _onReceiptReceived(0x05, true);
        // 对齐引擎 target/actual 防误判重发 + 结束 0x02 跟踪 + 解锁按钮
        _syncEngine.notifyDeviceTargetChanged(
          ParamDimension.speed,
          speedKmPerH,
        );
        _dispatcher?.confirmReceipt(0x02);
        state = state.copyWith(
          sportSpeedButton: speedKmPerH,
          isSpeedLocked: false,
        );
        break;

      case FtmsStatusTargetInclineChanged(:final inclinePercent):
        // 0x06：坡度回调（设备主动变更目标，含 0x03 指令隐式回执）
        // 设备优先级规则：设备返回值无条件覆盖本地按钮值（不设保护窗口阻塞）
        print(
          '[DeviceStatus] opCode=0x06, action=incline, value=$inclinePercent',
        );
        _onReceiptReceived(0x06, true);
        _syncEngine.notifyDeviceTargetChanged(
          ParamDimension.inclination,
          inclinePercent,
        );
        _dispatcher?.confirmReceipt(0x03);
        state = state.copyWith(
          sportInclinationButton: inclinePercent,
          isInclinationLocked: false,
        );
        break;

      case FtmsStatusTargetResistanceChanged(:final resistanceLevel):
        // 0x07：阻力回调（取整保持按钮值为整数）
        final intLevel = resistanceLevel.round().toDouble();
        print(
          '[DeviceStatus] opCode=0x07, action=resistance, value=$intLevel',
        );
        _onReceiptReceived(0x07, true);
        _syncEngine.notifyDeviceTargetChanged(
          ParamDimension.resistance,
          intLevel,
        );
        _dispatcher?.confirmReceipt(0x04);
        state = state.copyWith(
          sportResistanceButton: intLevel,
          isResistanceLocked: false,
        );
        break;

      case FtmsStatusReset():
        print('[DeviceStatus] opCode=0x01, action=reset');
        _onReceiptReceived(0x00, true);
        break;

      case FtmsStatusSafetyKey():
        print('[DeviceStatus] opCode=0x03, action=safetyKey');
        break;

      case FtmsStatusTargetPowerChanged(:final powerWatts):
        print('[DeviceStatus] opCode=0x08, action=power, value=${powerWatts}W');
        break;

      case FtmsStatusControlPermissionLost():
        print('[DeviceStatus] opCode=0xFF, action=permissionLost');
        break;

      case FtmsStatusUnknown(:final opCode):
        print(
          '[DeviceStatus] opCode=0x${opCode.toRadixString(16)}, action=unknown',
        );
        break;
    }
  }

  // ==================== 指令回执处理（Task 14） ====================

  /// 0x2AD9 回执处理。
  /// FtmsServiceBase 使用 withoutResponse 写入模式，无独立回执流，
  /// 实际回执通过 0x2ADA 状态通知间接体现。
  /// 这里在指令下发成功后由 FtmsCommandDispatcher 内部记录日志。
  void _onReceiptReceived(int opCode, bool success) {
    print(
      '[Receipt] opCode=0x${opCode.toRadixString(16).padLeft(2, '0')}, result=${success ? 'success' : 'failure'}',
    );
  }

  // ==================== 运动控制辅助方法 ====================

  /// 按 FTMS 协议编码参数字节。
  /// - 0x02 速度：km/h × 100 → uint16 LE (2 字节)
  /// - 0x03 坡度：% × 10 → sint16 LE (2 字节,负值二补码)
  /// - 0x04 阻力：level × 10 → uint8 (1 字节)
  ///
  /// FTMS 协议规定:
  /// - Set Target Speed (0x02):   uint16, 分辨率 0.01 km/h
  /// - Set Target Inclination (0x03): sint16, 分辨率 0.1 %
  /// - Set Target Resistance (0x04): uint8, 分辨率 0.1 unitless
  List<int> _buildValueBytes(int opCode, double value) {
    switch (opCode) {
      case 0x02:
        final raw = (value * 100).round();
        final clamped = raw & 0xFFFF;
        return [clamped & 0xFF, (clamped >> 8) & 0xFF];
      case 0x03:
        final raw = (value * 10).round();
        final clamped = raw & 0xFFFF;
        return [clamped & 0xFF, (clamped >> 8) & 0xFF];
      case 0x04:
        // Set Target Resistance Level: uint8, 0.1 unitless
        // 阻力按钮值必须为整数(如 8)，发送时 ×10 → 字节 80
        // 整数 8 → raw=80, 单字节发送
        final intValue = value.round();
        final raw = (intValue * 10).clamp(0, 255);
        return [raw];
      default:
        final raw = value.round();
        final clamped = raw & 0xFFFF;
        return [clamped & 0xFF, (clamped >> 8) & 0xFF];
    }
  }

  // ==================== 目标达成弹窗：判定与队列 ====================

  /// 每次运动数据变化后调用：检查 3 个维度是否命中新目标档。
  void _checkAndTriggerGoalDialogs() {
    // 非播放态不检查目标，避免停止后残留数据帧反复触发弹窗（根因 F）
    if (!state.isPlaying) return;
    // 3 个维度互相独立并行，同时弹窗不互斥；enqueue 内已按类型判断是否该类型已显示。
    _checkTimeGoal();
    _checkDistanceGoal();
    _checkEnergyGoal();
  }

  void _checkTimeGoal() {
    final timeLevelsSec = _kTimeGoalLevelsSec;
    if (state.achievedTimeLevels.length >= timeLevelsSec.length) return;
    for (int i = 0; i < timeLevelsSec.length; i++) {
      if (state.achievedTimeLevels.contains(i)) continue;
      if (state.realSportTime >= timeLevelsSec[i]) {
        print(
          '🎯 [GoalDialog] ✨ 触发时间目标弹窗：level=$i, '
          'minutes=${kTimeGoalLevelsMin[i]}',
        );
        state = state.copyWith(
          achievedTimeLevels: [...state.achievedTimeLevels, i],
          currentTimeGoalSec: timeLevelsSec[i],
        );
        _enqueueDialog(GoalDialogType.time);
        return;
      }
    }
  }

  void _checkDistanceGoal() {
    final distLevelsM = _kDistanceGoalLevelsM;
    if (state.achievedDistanceLevels.length >= distLevelsM.length) {
      return;
    }
    for (int i = 0; i < distLevelsM.length; i++) {
      if (state.achievedDistanceLevels.contains(i)) continue;
      if (state.sportDistance >= distLevelsM[i]) {
        print(
          '🎯 [GoalDialog] ✨ 触发距离目标弹窗：level=$i, '
          'km=${kDistanceGoalLevelsKm[i]}',
        );
        state = state.copyWith(
          achievedDistanceLevels: [...state.achievedDistanceLevels, i],
          currentDistanceGoalKm: kDistanceGoalLevelsKm[i],
        );
        _enqueueDialog(GoalDialogType.distance);
        return;
      }
    }
  }

  void _checkEnergyGoal() {
    if (state.achievedEnergyLevels.length >= kEnergyGoalLevelsKcal.length) {
      return;
    }
    for (int i = 0; i < kEnergyGoalLevelsKcal.length; i++) {
      if (state.achievedEnergyLevels.contains(i)) continue;
      // 浮点容差比较，避免 219.999... 漏触发 220 档
      final threshold = kEnergyGoalLevelsKcal[i];
      if (state.sportEnergy + 0.0005 >= threshold) {
        print(
          '🎯 [GoalDialog] ✨ 触发卡路里目标弹窗：level=$i, kcal=${threshold.toStringAsFixed(0)}',
        );
        state = state.copyWith(
          achievedEnergyLevels: [...state.achievedEnergyLevels, i],
          currentEnergyGoalKcal: threshold,
        );
        _enqueueDialog(GoalDialogType.energy);
        return;
      }
    }
  }

  void _enqueueDialog(GoalDialogType type) {
    // —— 允许三个类型同时弹窗：
    // 1. 同一类型：已经展示时，新事件先入队（避免同一槽位瞬间覆盖），Timer 结束后自动推进该类型队列
    // 2. 不同类型：并行展示，彼此互不阻塞
    if (_isDialogTypeVisible(type)) {
      _pendingDialogQueue.add(type);
      return;
    }
    _showDialog(type);
  }

  /// 按 [dismissedType] 推进对应类型的队列（允许其他类型继续显示，互不阻塞）。
  void _processPendingDialogQueue(GoalDialogType dismissedType) {
    if (_isDialogTypeVisible(dismissedType)) return;
    // 只找队列中下一个"被关闭的类型"，其他类型不动
    final idx = _pendingDialogQueue.indexWhere((e) => e == dismissedType);
    if (idx < 0) return;
    final next = _pendingDialogQueue.removeAt(idx);
    _showDialog(next);
  }

  /// 判断指定类型是否正在显示（displayState 非 hidden 即视为可见，含 entering/visible/exiting）。
  bool _isDialogTypeVisible(GoalDialogType type) => switch (type) {
    GoalDialogType.time =>
      state.timeDialogDisplayState != GoalBannerDisplayState.hidden,
    GoalDialogType.distance =>
      state.distanceDialogDisplayState != GoalBannerDisplayState.hidden,
    GoalDialogType.energy =>
      state.energyDialogDisplayState != GoalBannerDisplayState.hidden,
  };

  void _showDialog(GoalDialogType type) {
    switch (type) {
      case GoalDialogType.time:
        // 1. 进入 entering 状态（触发入场动画）
        _cancelTimeGoalTimers();
        state = state.copyWith(
          timeDialogDisplayState: GoalBannerDisplayState.entering,
        );
        print(
          '[Notifier] showDialog: type=time, displayState=entering, '
          'seconds=${state.currentTimeGoalSec}',
        );
        // 2. 300ms 后切到 visible，并从此刻起 5 秒自动关闭
        _timeGoalEnteringTimer = Timer(const Duration(milliseconds: 300), () {
          state = state.copyWith(
            timeDialogDisplayState: GoalBannerDisplayState.visible,
          );
          _timeGoalTimer = Timer(
            const Duration(seconds: kGoalDialogAutoDismissSec),
            () {
              print(
                '🎯 [GoalDialog] ⏱️ ${kGoalDialogAutoDismissSec}秒到，自动关闭：时间目标弹窗',
              );
              dismissTimeGoalDialog();
            },
          );
        });
        break;
      case GoalDialogType.distance:
        _cancelDistanceGoalTimers();
        state = state.copyWith(
          distanceDialogDisplayState: GoalBannerDisplayState.entering,
        );
        print(
          '[Notifier] showDialog: type=distance, displayState=entering, '
          'km=${state.currentDistanceGoalKm}',
        );
        _distanceGoalEnteringTimer = Timer(const Duration(milliseconds: 300), () {
          state = state.copyWith(
            distanceDialogDisplayState: GoalBannerDisplayState.visible,
          );
          _distanceGoalTimer = Timer(
            const Duration(seconds: kGoalDialogAutoDismissSec),
            () {
              print(
                '🎯 [GoalDialog] ⏱️ ${kGoalDialogAutoDismissSec}秒到，自动关闭：距离目标弹窗',
              );
              dismissDistanceGoalDialog();
            },
          );
        });
        break;
      case GoalDialogType.energy:
        _cancelEnergyGoalTimers();
        state = state.copyWith(
          energyDialogDisplayState: GoalBannerDisplayState.entering,
        );
        print(
          '[Notifier] showDialog: type=energy, displayState=entering, '
          'kcal=${state.currentEnergyGoalKcal.toStringAsFixed(0)}',
        );
        _energyGoalEnteringTimer = Timer(const Duration(milliseconds: 300), () {
          state = state.copyWith(
            energyDialogDisplayState: GoalBannerDisplayState.visible,
          );
          _energyGoalTimer = Timer(
            const Duration(seconds: kGoalDialogAutoDismissSec),
            () {
              print(
                '🎯 [GoalDialog] ⏱️ ${kGoalDialogAutoDismissSec}秒到，自动关闭：卡路里目标弹窗',
              );
              dismissEnergyGoalDialog();
            },
          );
        });
        break;
    }
  }

  /// 取消时间目标弹窗的全部 Timer（entering / exiting / auto-dismiss）。
  void _cancelTimeGoalTimers() {
    _timeGoalTimer?.cancel();
    _timeGoalTimer = null;
    _timeGoalEnteringTimer?.cancel();
    _timeGoalEnteringTimer = null;
    _timeGoalExitingTimer?.cancel();
    _timeGoalExitingTimer = null;
  }

  /// 取消距离目标弹窗的全部 Timer。
  void _cancelDistanceGoalTimers() {
    _distanceGoalTimer?.cancel();
    _distanceGoalTimer = null;
    _distanceGoalEnteringTimer?.cancel();
    _distanceGoalEnteringTimer = null;
    _distanceGoalExitingTimer?.cancel();
    _distanceGoalExitingTimer = null;
  }

  /// 取消卡路里目标弹窗的全部 Timer。
  void _cancelEnergyGoalTimers() {
    _energyGoalTimer?.cancel();
    _energyGoalTimer = null;
    _energyGoalEnteringTimer?.cancel();
    _energyGoalEnteringTimer = null;
    _energyGoalExitingTimer?.cancel();
    _energyGoalExitingTimer = null;
  }

  void dismissTimeGoalDialog() {
    // 取消自动关闭与入场 Timer，进入 exiting 状态
    _timeGoalTimer?.cancel();
    _timeGoalTimer = null;
    _timeGoalEnteringTimer?.cancel();
    _timeGoalEnteringTimer = null;
    state = state.copyWith(
      timeDialogDisplayState: GoalBannerDisplayState.exiting,
    );
    print('[Notifier] dismissDialog: type=time, displayState=exiting');
    // 250ms 后切到 hidden，再推进队列
    _timeGoalExitingTimer?.cancel();
    _timeGoalExitingTimer = Timer(const Duration(milliseconds: 250), () {
      state = state.copyWith(
        timeDialogDisplayState: GoalBannerDisplayState.hidden,
      );
      _timeGoalExitingTimer = null;
      _processPendingDialogQueue(GoalDialogType.time);
    });
  }

  void dismissDistanceGoalDialog() {
    _distanceGoalTimer?.cancel();
    _distanceGoalTimer = null;
    _distanceGoalEnteringTimer?.cancel();
    _distanceGoalEnteringTimer = null;
    state = state.copyWith(
      distanceDialogDisplayState: GoalBannerDisplayState.exiting,
    );
    print('[Notifier] dismissDialog: type=distance, displayState=exiting');
    _distanceGoalExitingTimer?.cancel();
    _distanceGoalExitingTimer = Timer(const Duration(milliseconds: 250), () {
      state = state.copyWith(
        distanceDialogDisplayState: GoalBannerDisplayState.hidden,
      );
      _distanceGoalExitingTimer = null;
      _processPendingDialogQueue(GoalDialogType.distance);
    });
  }

  void dismissEnergyGoalDialog() {
    _energyGoalTimer?.cancel();
    _energyGoalTimer = null;
    _energyGoalEnteringTimer?.cancel();
    _energyGoalEnteringTimer = null;
    state = state.copyWith(
      energyDialogDisplayState: GoalBannerDisplayState.exiting,
    );
    print('[Notifier] dismissDialog: type=energy, displayState=exiting');
    _energyGoalExitingTimer?.cancel();
    _energyGoalExitingTimer = Timer(const Duration(milliseconds: 250), () {
      state = state.copyWith(
        energyDialogDisplayState: GoalBannerDisplayState.hidden,
      );
      _energyGoalExitingTimer = null;
      _processPendingDialogQueue(GoalDialogType.energy);
    });
  }

  /// 仅清理弹窗全部 Timer 与待展示队列，**不修改 state**。
  ///
  /// 专用于页面 dispose：卸载阶段 widget tree 处于重建周期，此时修改 provider
  /// state 会触发 Riverpod「Tried to modify a provider while the widget tree
  /// was building」异常，因此这里只做资源释放（取消 Timer / 清空队列）。
  void cancelAllGoalTimers() {
    print('🎯 [GoalDialog] 🧹 清理弹窗全部 Timer（不修改 state）');
    _cancelTimeGoalTimers();
    _cancelDistanceGoalTimers();
    _cancelEnergyGoalTimers();
    _pendingDialogQueue.clear();
  }

  /// 页面退出时统一清理所有弹窗 Timer，并将全部 displayState 置为 hidden。
  ///
  /// 注意：此方法会修改 state，**不可在 widget tree 构建期间调用**（如 dispose）。
  /// dispose 场景请改用 [cancelAllGoalTimers]。
  void disposeGoalTimers() {
    print('🎯 [GoalDialog] 🧹 清理弹窗全部 Timer');
    cancelAllGoalTimers();
    // 清理所有 displayState 为 hidden，避免页面退出后残留 entering/exiting 状态
    state = state.copyWith(
      timeDialogDisplayState: GoalBannerDisplayState.hidden,
      distanceDialogDisplayState: GoalBannerDisplayState.hidden,
      energyDialogDisplayState: GoalBannerDisplayState.hidden,
    );
  }

  // ==================== 业务方法（FTMS 蓝牙指令下发） ====================

  /// 进入快速启动页的设备参数复位（对应旧 cnfbd.sendResetToDevice）。
  ///
  /// 旧版实际行为（controller_new_four_big_device_sprot.dart:1181）：
  /// 1. 发送阻力=1 指令（0x04 + 小端 sint16 "0100"）
  /// 2. 同步本地按钮状态（阻力=1）
  /// 3. 等待 500ms（设备处理第一条指令的响应）
  /// 4. 发送坡度=0 指令（0x03 + 小端 sint16 "0000"）
  /// 5. 同步本地按钮状态（坡度=0）
  ///
  /// ⚠️ 历史偏差修正：迁移初期误发 OpCode 0x00（协议保留值，设备不识别、
  /// 静默丢弃），导致进入页面时「阻力归 1、坡度归 0」的复位功能实际丢失。
  /// 本次已按旧版指令序列等价还原。
  ///
  /// 🔧 GATT 串行化：先 await 能力范围读取链（_paramRangesChain）完成，
  /// 确保写入不与 0x2AD4/0x2AD5/0x2AD6 的特征读取并发——
  /// 部分健身器材固件不支持并发 GATT 事务，并发会导致写入失败。
  /// 指令走 dispatchTracked（与 numberButton 等参数指令一致，4s 超时重发上限 3 次）。
  Future<void> sendResetToDevice() async {
    await _paramRangesChain;

    // —— 第 1 条：阻力 = 1（0x04 Set Target Resistance Level） ——
    _syncEngine.lock(
      ParamDimension.resistance,
      1.0,
      state.sportResistanceButton,
    );
    _dispatcher?.dispatchTracked(
      FtmsCommand(0x04, _buildValueBytes(0x04, 1.0)),
    );
    // 乐观更新按钮（对应旧 sportResistanceButton.value = 1）
    state = state.copyWith(
      sportResistanceButton: 1.0,
      isResistanceLocked: true,
    );
    print('[Notifier] sendResetToDevice: 阻力复位 → 1（0x04）');

    // 等待设备处理阻力指令（旧版 500ms 间隔，避免设备来不及响应）
    await Future.delayed(const Duration(milliseconds: 500));

    // —— 第 2 条：坡度 = 0（0x03 Set Target Inclination） ——
    _syncEngine.lock(
      ParamDimension.inclination,
      0.0,
      state.sportInclinationButton,
    );
    _dispatcher?.dispatchTracked(
      FtmsCommand(0x03, _buildValueBytes(0x03, 0.0)),
    );
    // 乐观更新按钮（对应旧 sportInclinationButton.value = 0）
    state = state.copyWith(
      sportInclinationButton: 0.0,
      isInclinationLocked: true,
    );
    print('[Notifier] sendResetToDevice: 坡度复位 → 0（0x03）完成');
  }

  /// 开始运动（对应旧 cnfbd.startSport）。
  /// 1. 更新本地状态
  /// 2. 启动本地计时器
  /// 3. 带跟踪下发"开始运动"指令（0x07 Start or Resume，无参数），
  ///    3 秒未确认自动重发（上限 3 次），由 0x2ADA 开始事件确认
  void startSport() {
    state = state.copyWith(
      showPlayButton: false,
      isInQuickPlay: true,
      isPlaying: true,
    );
    _sportTimer?.start();
    _dispatcher?.dispatchTracked(
      FtmsCommand(0x07, []),
      timeout: FtmsCommandDispatcher.binaryAckTimeout,
    );
    print(
      '[Notifier] startSport: sending 0x07 (Start or Resume), timer started',
    );
  }

  /// 停止运动（对应旧 cnfbd.stopSport）。
  /// 1. 停止本地计时器
  /// 2. 带跟踪下发"停止运动"指令（0x08 + [0x01] = Stop），
  ///    3 秒未确认自动重发（上限 3 次），由 0x2ADA 停止事件确认
  /// 3. 更新本地状态
  void stopSport() {
    _sportTimer?.stop();
    _dispatcher?.dispatchTracked(
      FtmsCommand(0x08, [0x01]),
      timeout: FtmsCommandDispatcher.binaryAckTimeout,
    );
    state = state.copyWith(isPlaying: false);
    print('[Notifier] stopSport: sending 0x08 0x01 (Stop), timer stopped');
  }

  /// 即时停止运动（任务4：返回按钮 / 阻塞层"发送停止指令"专用）。
  ///
  /// 与 [stopSport] 区别：使用 `dispatchTracked` 立即下发并跟踪停止指令，
  /// 不走 debounce 合并，确保页面 pop 前停止指令必达设备。
  void stopSportImmediate() {
    _sportTimer?.stop();
    _dispatcher?.dispatchTracked(
      FtmsCommand(0x08, [0x01]),
      timeout: FtmsCommandDispatcher.binaryAckTimeout,
    );
    state = state.copyWith(isPlaying: false);
    print('[Notifier] stopSportImmediate: sending 0x08 0x01 (Stop, immediate)');
  }

  /// 暂停运动（对应旧 cnfbd.pauseSport）。
  /// 快速开始模块业务上不使用暂停（仅退出立即停止），保留方法以兼容协议完整性。
  /// 1. 暂停本地计时器
  /// 2. 带跟踪下发"暂停运动"指令（0x08 + [0x02] = Pause），
  ///    3 秒未确认自动重发（上限 3 次），由 0x2ADA 暂停事件确认
  /// 3. 更新本地状态
  void pauseSport() {
    _sportTimer?.pause();
    _dispatcher?.dispatchTracked(
      FtmsCommand(0x08, [0x02]),
      timeout: FtmsCommandDispatcher.binaryAckTimeout,
    );
    state = state.copyWith(isPlaying: false);
    print('[Notifier] pauseSport: sending 0x08 0x02 (Pause), timer paused');
  }

  /// 停止运动并清零本地数据（阻塞层"发送停止指令"按钮 + 返回键专用）。
  ///
  /// 业务流：用户点击开始 → 设备开始；若检测到设备自启动 → 阻塞层要求用户
  /// 手动停止 → 调用本方法下发停止指令并清零 → 用户再点开始。
  /// 对齐旧项目 stopSport「停止即清零」的终端表现：
  /// 1. dispatchImmediate 立即下发 0x08 0x01（Stop）
  /// 2. 停止本地计时器并归零
  /// 3. 重置设备时间归一化器
  /// 4. 清空目标弹窗 Timer 与队列
  /// 5. state 重置为初始态（运动数据全部归零）
  void stopAndClear() {
    // 清零前先解锁全部参数同步锁并丢弃 debounce 待发指令（state 重置已含新字段复位）
    _syncEngine.unlockAll();
    _dispatcher?.cancelPending();
    _sportTimer?.stop();
    _dispatcher?.dispatchImmediate(FtmsCommand(0x08, [0x01]));
    disposeGoalTimers();
    _timeNormalizer?.reset();
    // 保留设备能力范围（0x2AD4/0x2AD5/0x2AD6 读取结果），避免清零后按钮回退默认上限
    state = _resetStatePreservingRanges();
    print('[Notifier] stopAndClear: sending 0x08 0x01 (Stop) + 清零本地数据');
  }

  /// 清除数据（对应旧 cnfbd.clearData）。
  void clearData() {
    // 清零前先解锁全部参数同步锁并丢弃 debounce 待发指令（state 重置已含新字段复位）
    _syncEngine.unlockAll();
    _dispatcher?.cancelPending();
    disposeGoalTimers();
    _sportTimer?.stop();
    _timeNormalizer?.reset();
    // 保留设备能力范围（0x2AD4/0x2AD5/0x2AD6 读取结果），避免清零后按钮回退默认上限
    state = _resetStatePreservingRanges();
  }

  /// 重置 state 但保留设备能力范围字段（速度/坡度/阻力的 min/max/step）。
  ///
  /// 范围特征值只需在连接后读取一次；返回/停止清零运动数据时不应丢失，
  /// 否则按钮加减会回退默认常量上限（如速度 20），与设备实际上限不符。
  QuickStartState _resetStatePreservingRanges() {
    final s = state;
    return const QuickStartState().copyWith(
      speedRangeMin: s.speedRangeMin,
      speedRangeMax: s.speedRangeMax,
      speedRangeStep: s.speedRangeStep,
      inclinationRangeMin: s.inclinationRangeMin,
      inclinationRangeMax: s.inclinationRangeMax,
      inclinationRangeStep: s.inclinationRangeStep,
      resistanceRangeMin: s.resistanceRangeMin,
      resistanceRangeMax: s.resistanceRangeMax,
      resistanceRangeStep: s.resistanceRangeStep,
      // 同步保留三维度支持判定（与 0x2AD4/0x2AD5/0x2AD6 读取结果一致），
      // 避免停止/重置后按钮组显示状态回退
      hasInclinationSupport: s.hasInclinationSupport,
      hasSpeedSupport: s.hasSpeedSupport,
      hasResistanceSupport: s.hasResistanceSupport,
    );
  }

  /// 阻力 +（对应旧 cnfbd.resistanceAdd）。
  /// 获取当前阻力值 + step，clamp 后取整，下发阻力控制指令（0x04 Set Target Resistance Level）。
  @override
  void resistanceAdd() {
    final current = state.sportResistanceButton;
    final rawValue = (current + _resistanceStepEff).clamp(
      _resistanceMinEff,
      _resistanceMaxEff,
    );
    final newValue = rawValue.round().toDouble();
    // 乐观更新按钮 + 命令锁 + 带跟踪下发（4 秒超时，重发上限 3 次）
    _syncEngine.lock(ParamDimension.resistance, newValue, current);
    _dispatcher?.dispatchTracked(
      FtmsCommand(0x04, _buildValueBytes(0x04, newValue)),
    );
    state = state.copyWith(
      sportResistanceButton: newValue,
      isResistanceLocked: true,
    );
    print('[Notifier] resistanceAdd: $current → $newValue');
  }

  /// 阻力 -（对应旧 cnfbd.resistanceDown）。
  @override
  void resistanceDown() {
    final current = state.sportResistanceButton;
    final rawValue = (current - _resistanceStepEff).clamp(
      _resistanceMinEff,
      _resistanceMaxEff,
    );
    final newValue = rawValue.round().toDouble();
    // 乐观更新按钮 + 命令锁 + 带跟踪下发（4 秒超时，重发上限 3 次）
    _syncEngine.lock(ParamDimension.resistance, newValue, current);
    _dispatcher?.dispatchTracked(
      FtmsCommand(0x04, _buildValueBytes(0x04, newValue)),
    );
    state = state.copyWith(
      sportResistanceButton: newValue,
      isResistanceLocked: true,
    );
    print('[Notifier] resistanceDown: $current → $newValue');
  }

  /// 速度 +（对应旧 cnfbd.speedAdd）。
  /// 下发速度控制指令（0x02 Set Target Speed）。
  @override
  void speedAdd() {
    final current = state.sportSpeedButton;
    final newValue = (current + _speedStepEff).clamp(
      _speedMinEff,
      _speedMaxEff,
    );
    // 乐观更新按钮 + 命令锁 + 带跟踪下发（4 秒超时，重发上限 3 次）
    _syncEngine.lock(ParamDimension.speed, newValue, current);
    _dispatcher?.dispatchTracked(
      FtmsCommand(0x02, _buildValueBytes(0x02, newValue)),
    );
    state = state.copyWith(sportSpeedButton: newValue, isSpeedLocked: true);
    print('[Notifier] speedAdd: $current → $newValue');
  }

  /// 速度 -（对应旧 cnfbd.speedDown）。
  @override
  void speedDown() {
    final current = state.sportSpeedButton;
    final newValue = (current - _speedStepEff).clamp(
      _speedMinEff,
      _speedMaxEff,
    );
    // 乐观更新按钮 + 命令锁 + 带跟踪下发（4 秒超时，重发上限 3 次）
    _syncEngine.lock(ParamDimension.speed, newValue, current);
    _dispatcher?.dispatchTracked(
      FtmsCommand(0x02, _buildValueBytes(0x02, newValue)),
    );
    state = state.copyWith(sportSpeedButton: newValue, isSpeedLocked: true);
    print('[Notifier] speedDown: $current → $newValue');
  }

  /// 坡度 +（对应旧 cnfbd.inclinationAdd）。
  /// 下发坡度控制指令（0x03 Set Target Inclination）。
  void inclinationAdd() {
    final current = state.sportInclinationButton;
    final newValue = (current + _inclinationStepEff).clamp(
      _inclinationMinEff,
      _inclinationMaxEff,
    );
    // 乐观更新按钮 + 命令锁 + 带跟踪下发（4 秒超时，重发上限 3 次）
    _syncEngine.lock(ParamDimension.inclination, newValue, current);
    _dispatcher?.dispatchTracked(
      FtmsCommand(0x03, _buildValueBytes(0x03, newValue)),
    );
    state = state.copyWith(
      sportInclinationButton: newValue,
      isInclinationLocked: true,
    );
    print('[Notifier] inclinationAdd: $current → $newValue');
  }

  /// 坡度 -（对应旧 cnfbd.inclinationDown）。
  void inclinationDown() {
    final current = state.sportInclinationButton;
    final newValue = (current - _inclinationStepEff).clamp(
      _inclinationMinEff,
      _inclinationMaxEff,
    );
    // 乐观更新按钮 + 命令锁 + 带跟踪下发（4 秒超时，重发上限 3 次）
    _syncEngine.lock(ParamDimension.inclination, newValue, current);
    _dispatcher?.dispatchTracked(
      FtmsCommand(0x03, _buildValueBytes(0x03, newValue)),
    );
    state = state.copyWith(
      sportInclinationButton: newValue,
      isInclinationLocked: true,
    );
    print('[Notifier] inclinationDown: $current → $newValue');
  }

  // ==================== 长按连续加减（对应旧 _handleLongPress / _adjustValue） ====================

  /// 启动长按连续加减。
  ///
  /// 1. 立即执行一次步进（首 tick 不等 500ms，与旧项目一致）
  /// 2. 启动 Timer.periodic(500ms) 持续步进
  /// 3. 每个 tick 更新本地 state + dispatch（debounce 自动合并，松手后仅发最终值）
  void _startLongPress(_LongPressDimension dim, bool isAdd) {
    _currentLongPressDimension = dim;
    print('[Notifier] longPress start: dim=$dim, isAdd=$isAdd');
    // 首 tick 立即执行
    _applyLongPressStep(dim, isAdd);
    // 启动周期定时器
    _longPressTimer?.cancel();
    _longPressTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => _applyLongPressStep(dim, isAdd),
    );
  }

  /// 单次长按步进（更新 state + dispatchImmediate 即时指令）。
  ///
  /// 步长固定 1.0（与旧项目 _adjustValue 一致），达到边界时取消 Timer。
  /// 步进指令使用 dispatchImmediate 即时下发（设备实时响应，中间步不跟踪重发）；
  /// 每步刷新命令锁（可重入）防止数据帧中间值回写按钮，
  /// 松手后由 longPressEnd 以跟踪模式发送最终值。
  void _applyLongPressStep(_LongPressDimension dim, bool isAdd) {
    final delta = isAdd ? _longPressStep : -_longPressStep;
    switch (dim) {
      case _LongPressDimension.speed:
        final current = state.sportSpeedButton;
        final newValue = (current + delta).clamp(_speedMinEff, _speedMaxEff);
        if (newValue == current) {
          _longPressTimer?.cancel();
          _longPressTimer = null;
          print('[Notifier] longPress speed reached boundary: $newValue');
          return;
        }
        // 命令锁可重入刷新：更新目标值与超时基准，防中间值弹跳
        _syncEngine.lock(ParamDimension.speed, newValue, current);
        _dispatcher?.dispatchImmediate(
          FtmsCommand(0x02, _buildValueBytes(0x02, newValue)),
        );
        state = state.copyWith(sportSpeedButton: newValue, isSpeedLocked: true);
        print('[Notifier] longPress speed: $current → $newValue');
      case _LongPressDimension.incline:
        final current = state.sportInclinationButton;
        final newValue = (current + delta).clamp(
          _inclinationMinEff,
          _inclinationMaxEff,
        );
        if (newValue == current) {
          _longPressTimer?.cancel();
          _longPressTimer = null;
          print('[Notifier] longPress incline reached boundary: $newValue');
          return;
        }
        _syncEngine.lock(ParamDimension.inclination, newValue, current);
        _dispatcher?.dispatchImmediate(
          FtmsCommand(0x03, _buildValueBytes(0x03, newValue)),
        );
        state = state.copyWith(
          sportInclinationButton: newValue,
          isInclinationLocked: true,
        );
        print('[Notifier] longPress incline: $current → $newValue');
      case _LongPressDimension.resistance:
        final current = state.sportResistanceButton;
        final rawValue = (current + delta).clamp(
          _resistanceMinEff,
          _resistanceMaxEff,
        );
        final newValue = rawValue.round().toDouble();
        if (newValue == current) {
          _longPressTimer?.cancel();
          _longPressTimer = null;
          print('[Notifier] longPress resistance reached boundary: $newValue');
          return;
        }
        _syncEngine.lock(ParamDimension.resistance, newValue, current);
        _dispatcher?.dispatchImmediate(
          FtmsCommand(0x04, _buildValueBytes(0x04, newValue)),
        );
        state = state.copyWith(
          sportResistanceButton: newValue,
          isResistanceLocked: true,
        );
        print('[Notifier] longPress resistance: $current → $newValue');
    }
  }

  /// 速度长按加（对应旧 cnfbd.longPressSpeedAdd）。
  @override
  void speedLongPressAdd() => _startLongPress(_LongPressDimension.speed, true);

  /// 速度长按减（对应旧 cnfbd.longPressSpeedDown）。
  @override
  void speedLongPressDown() =>
      _startLongPress(_LongPressDimension.speed, false);

  /// 坡度长按加（对应旧 cnfbd.longPressInclinationAdd）。
  /// 注意：mixin 定义的是 inclineLongPressAdd，此处沿用 inclination 前缀与
  /// inclinationAdd/inclinationDown 命名保持一致，由页面直接引用。
  void inclinationLongPressAdd() =>
      _startLongPress(_LongPressDimension.incline, true);

  /// 坡度长按减（对应旧 cnfbd.longPressInclinationDown）。
  void inclinationLongPressDown() =>
      _startLongPress(_LongPressDimension.incline, false);

  /// 阻力长按加（对应旧 cnfbd.longPressResistanceAdd）。
  @override
  void resistanceLongPressAdd() =>
      _startLongPress(_LongPressDimension.resistance, true);

  /// 阻力长按减（对应旧 cnfbd.longPressResistanceDown）。
  @override
  void resistanceLongPressDown() =>
      _startLongPress(_LongPressDimension.resistance, false);

  /// 长按结束（对应旧 cnfbd.longPressEnd）。
  /// 1. 取消长按定时器
  /// 2. 通过 debounce 模式下发最终值（合并长按过程指令为一条）
  /// 3. 保护窗口仅作日志标记，不阻塞设备回调（设备优先级规则）
  @override
  void longPressEnd() {
    final dim = _currentLongPressDimension;
    _longPressTimer?.cancel();
    _longPressTimer = null;
    _currentLongPressDimension = null;
    // 长按最终值立即下发（debounce 模式，与其他 pending 指令合并）
    if (dim != null) {
      _dispatchFinalLongPressValue(dim);
    }
    print(
      '[Notifier] longPressEnd: dim=$dim, timer cancelled, final value dispatched',
    );
  }

  /// 长按结束后下发当前维度的最终值（带跟踪模式，超时自动重发确保终值必达）。
  void _dispatchFinalLongPressValue(_LongPressDimension dim) {
    final FtmsCommand command = switch (dim) {
      _LongPressDimension.speed => FtmsCommand(
        0x02,
        _buildValueBytes(0x02, state.sportSpeedButton),
      ),
      _LongPressDimension.incline => FtmsCommand(
        0x03,
        _buildValueBytes(0x03, state.sportInclinationButton),
      ),
      _LongPressDimension.resistance => FtmsCommand(
        0x04,
        _buildValueBytes(0x04, state.sportResistanceButton),
      ),
    };
    _dispatcher?.dispatchTracked(command);
  }

  /// 数字按钮选择（对应旧 cnfbd.numberButton）。
  /// [type]: 0=速度, 1=坡度, 2=阻力。
  /// 带跟踪下发目标值指令（各自独立 OpCode，4 秒超时重发上限 3 次）。
  void numberButton(double value, int type) {
    // 根据类型选择 OpCode（FTMS 协议 §14.2，均为独立 OpCode）
    final opCode = switch (type) {
      0 => 0x02, // 速度 Set Target Speed
      1 => 0x03, // 坡度 Set Target Inclination
      2 => 0x04, // 阻力 Set Target Resistance Level
      _ => null,
    };
    if (opCode == null) {
      print('[Notifier] numberButton: 未知 type=$type');
      return;
    }
    // 预设值钳制到设备有效范围（防止硬编码预设超出设备实际上限）
    final double clampedValue = switch (type) {
      0 => value.clamp(_speedMinEff, _speedMaxEff),
      1 => value.clamp(_inclinationMinEff, _inclinationMaxEff),
      2 => value.clamp(_resistanceMinEff, _resistanceMaxEff),
      _ => value,
    };
    // 按维度执行：命令锁 + 带跟踪下发 + 乐观更新按钮并锁定
    switch (type) {
      case 0:
        _syncEngine.lock(
          ParamDimension.speed,
          clampedValue,
          state.sportSpeedButton,
        );
        _dispatcher?.dispatchTracked(
          FtmsCommand(opCode, _buildValueBytes(opCode, clampedValue)),
        );
        state = state.copyWith(
          sportSpeedButton: clampedValue,
          isSpeedLocked: true,
        );
        break;
      case 1:
        _syncEngine.lock(
          ParamDimension.inclination,
          clampedValue,
          state.sportInclinationButton,
        );
        _dispatcher?.dispatchTracked(
          FtmsCommand(opCode, _buildValueBytes(opCode, clampedValue)),
        );
        state = state.copyWith(
          sportInclinationButton: clampedValue,
          isInclinationLocked: true,
        );
        break;
      case 2:
        final intValue = clampedValue.round().toDouble();
        _syncEngine.lock(
          ParamDimension.resistance,
          intValue,
          state.sportResistanceButton,
        );
        _dispatcher?.dispatchTracked(
          FtmsCommand(opCode, _buildValueBytes(opCode, intValue)),
        );
        state = state.copyWith(
          sportResistanceButton: intValue,
          isResistanceLocked: true,
        );
        break;
    }
    print(
      '[Notifier] numberButton: target=$clampedValue(原始 $value), type=$type, opCode=0x${opCode.toRadixString(16)}',
    );
  }

  /// 更新音乐播放状态（对应旧 setState isMusicPlaying）。
  void updateMusicPlaying(bool playing) {
    state = state.copyWith(isMusicPlaying: playing);
  }

  /// 秒转时间字符串（对应旧 cnfbd.convertSecondsToTime）。
  String convertSecondsToTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

/// 设备就绪四级校验结果。
class DeviceReadyResult {
  const DeviceReadyResult({
    required this.isReady,
    required this.failedStep,
    required this.reason,
  });

  /// 是否全部通过。
  final bool isReady;

  /// 失败层级：0=全部通过, 1~4=失败层级。
  final int failedStep;

  /// 失败原因说明（供 UI 提示）。
  final String reason;
}

/// 长按调节维度（速度 / 坡度 / 阻力）。
enum _LongPressDimension { speed, incline, resistance }
