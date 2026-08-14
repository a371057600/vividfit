import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ftms/device_time_normalizer.dart';
import '../../../core/ftms/ftms_command_dispatcher.dart';
import '../../../core/ftms/ftms_data_sync_guard.dart';
import '../../../core/ftms/ftms_device_data.dart';
import '../../../core/ftms/ftms_device_type.dart';
import '../../../core/ftms/ftms_service_base.dart';
import '../../../core/ftms/ftms_service_provider.dart';
import '../../../core/ftms/ftms_status_parser.dart';
import '../../../core/ftms/sport_timer.dart';
import '../mixins/device_control_mixin.dart';
import '../states/goal_banner_display_state.dart';
import '../states/quick_start_state.dart';

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

  // ==================== FTMS 核心组件 ====================
  /// 运动计时器（本地计时 + 设备时间校准）
  SportTimer? _sportTimer;

  /// 设备时间归一化器（补偿 60 秒循环归零）
  DeviceTimeNormalizer? _timeNormalizer;

  /// 数据同步保护器（长按松手后屏蔽设备回调）
  FtmsDataSyncGuard? _syncGuard;

  /// FTMS 指令调度器（debounce / immediate 双模式）
  FtmsCommandDispatcher? _dispatcher;

  /// 实时数据流订阅
  StreamSubscription<FtmsDeviceData>? _dataSubscription;

  /// 设备状态流订阅
  StreamSubscription<FtmsStatusEvent>? _statusSubscription;

  // ==================== 按钮调节步长与范围常量 ====================
  // TODO: 步长与范围需根据真机实测微调，暂时使用合理默认值
  static const double _resistanceStep = 1.0;
  static const double _resistanceMin = 0.0;
  static const double _resistanceMax = 32.0;

  static const double _speedStep = 0.5;
  static const double _speedMin = 0.0;
  static const double _speedMax = 100.0;

  static const double _inclinationStep = 0.5;
  static const double _inclinationMin = -10.0;
  static const double _inclinationMax = 15.0;

  // ==================== 长按连续加减 ====================
  /// 长按定时器（500ms 周期，步长 1.0，对齐旧项目 _handleLongPress）。
  Timer? _longPressTimer;

  /// 长按步长（固定 1.0，与旧项目 _adjustValue 的 value += 1.0 一致）。
  static const double _longPressStep = 1.0;

  /// 当前长按调节维度（用于 longPressEnd 时识别上下文）。
  _LongPressDimension? _currentLongPressDimension;

  // ==================== 阻力加载态（任务3） ====================
  /// 阻力指令下发后等待设备回执的超时定时器（3 秒）。
  Timer? _resistanceFetchTimeout;

  /// 阻力加载超时阈值。
  static const Duration _resistanceFetchTimeoutDur = Duration(seconds: 3);

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
        );
      case FtmsDeviceType.treadmill:
        // 跑步机：速度 + 坡度各 4 档预设，支持坡度
        return state.copyWith(
          buttonResistanceList: [0.0, 0.0, 0.0, 0.0],
          buttonSpeedList: [4.0, 6.0, 10.0, 12.0],
          buttonInclinationList: [0.0, 1.0, 5.0, 7.0],
          hasInclinationSupport: true,
        );
      case FtmsDeviceType.crossTrainer:
        // 椭圆机：阻力 + 坡度各 4 档预设，支持坡度
        return state.copyWith(
          buttonResistanceList: [6.0, 9.0, 15.0, 18.0],
          buttonSpeedList: [0.0, 0.0, 0.0, 0.0],
          buttonInclinationList: [1.0, 3.0, 7.0, 9.0],
          hasInclinationSupport: true,
        );
      case FtmsDeviceType.rower:
        // 划船机：阻力预设 4 档，不支持坡度
        return state.copyWith(
          buttonResistanceList: [2.0, 4.0, 8.0, 10.0],
          buttonSpeedList: [0.0, 0.0, 0.0, 0.0],
          buttonInclinationList: [0.0, 0.0, 0.0, 0.0],
          hasInclinationSupport: false,
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
      state = state.copyWith(realSportTime: elapsed);
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
      _sportTimer?.dispose();
      _dispatcher?.dispose();
      _longPressTimer?.cancel();
      _longPressTimer = null;
      _resistanceFetchTimeout?.cancel();
      _resistanceFetchTimeout = null;
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
    );
    print('[Notifier] _setupDispatcher: dispatcher 已创建(getter 模式)');
  }

  /// 蓝牙指令下发失败统一处理。
  ///
  /// 触发场景：服务未就绪 / 写入特征值异常（如 `primary service not found '1826'`）。
  /// 处理：
  /// - 记录失败日志
  /// - 防抖（3 秒内仅弹一次 Toast），避免长按连续失败反复弹窗
  /// - 提示用户重启蓝牙后重新连接
  DateTime? _lastBluetoothErrorToastTime;

  void _handleCommandFailed(String error) {
    print('[Notifier] ⚠️ 指令下发失败: $error');
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

    // 监听实时数据流（0x2AD1）
    _dataSubscription = ftmsService.dataStream.listen(_onDataReceived);
    // 监听设备状态流（0x2ADA）
    _statusSubscription = ftmsService.statusStream.listen(_onStatusReceived);

    print('[Notifier] _setupStreams: dataStream 与 statusStream 已订阅');
  }

  // ==================== 实时数据流处理（Task 11） ====================

  /// 收到 FTMS 实时数据时的处理逻辑。
  /// 1. 归一化设备时间
  /// 2. 校准本地计时器
  /// 3. 更新 state 中的运动数据
  /// 4. 检测设备运行状态（任务5）
  /// 5. 检查目标弹窗
  void _onDataReceived(FtmsDeviceData data) {
    // 归一化设备时间（补偿 60 秒循环归零）
    final rawElapsed = data.timeElapsed ?? 0;
    final normalizedTime = _timeNormalizer!.normalize(rawElapsed);

    // 用归一化值校准本地计时器
    _sportTimer!.syncFromDevice(normalizedTime);

    // 取本帧运动数据（null 时保留旧值）
    final speed = data.instSpeed ?? state.sportSpeed;
    final cadence = data.instCadence ?? state.sportCadence;
    final strokeRate = data.strokesPerMin ?? state.sportStrokeRate;

    // 更新 state 中的运动数据
    state = state.copyWith(
      realSportTime: normalizedTime,
      sportDistance: (data.distTotal ?? 0).toDouble(),
      sportEnergy: (data.energyTotal ?? 0).toDouble(),
      sportSpeed: speed,
      sportCadence: cadence,
      sportHeartRate: data.hr ?? state.sportHeartRate,
      sportStrokeRate: strokeRate,
      sportStrokeCount: (data.strokeCountTotal ?? 0).toDouble(),
      sportResistanceButton: data.resistanceLvl ?? state.sportResistanceButton,
      sportInclinationButton: data.inclineAngle ?? state.sportInclinationButton,
      npcTime: normalizedTime.toDouble(),
    );

    // 任务5：检测设备运行状态（速度/踏频/桨频任一 > 0 即视为运行中）
    final isRunning = speed > 0 || cadence > 0 || strokeRate > 0;
    if (isRunning != state.isDeviceRunningDetected) {
      state = state.copyWith(isDeviceRunningDetected: isRunning);
      print(
        '🔍 [DeviceCheck] data stream → running=$isRunning '
        '(speed=$speed, cadence=$cadence, stroke=$strokeRate)',
      );
    }

    // 检查目标弹窗
    _checkAndTriggerGoalDialogs();
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

  // ==================== 设备状态流处理（Task 13） ====================

  /// 收到 FTMS 设备状态通知（0x2ADA）时的处理逻辑。
  /// 0x2ADA 既作为设备状态回调，也作为 0x2AD9 控制指令的隐式回执。
  void _onStatusReceived(FtmsStatusEvent event) {
    switch (event) {
      case FtmsStatusStartedResumed():
        // 0x04：设备开始/恢复运动
        print('[DeviceStatus] opCode=0x04, action=start');
        _onReceiptReceived(0x07, true);
        if (!state.isPlaying) {
          _startSportLocal();
        }
        break;

      case FtmsStatusStoppedPaused(:final isPause):
        if (isPause) {
          // 0x02 + 0x02：设备暂停
          print('[DeviceStatus] opCode=0x02, action=pause');
          _onReceiptReceived(0x07, true);
          _sportTimer?.pause();
          state = state.copyWith(isPlaying: false);
        } else {
          // 0x02 + 0x01：设备停止
          print('[DeviceStatus] opCode=0x02, action=stop');
          _onReceiptReceived(0x07, true);
          _sportTimer?.stop();
          state = state.copyWith(isPlaying: false);
        }
        break;

      case FtmsStatusTargetSpeedChanged(:final speedKmPerH):
        // 0x05：速度回调
        print('[DeviceStatus] opCode=0x05, action=speed, value=$speedKmPerH');
        _onReceiptReceived(0x05, true);
        if (_syncGuard?.isInGuardWindow() ?? false) {
          print('[DeviceStatus] 在保护窗口内，跳过速度更新');
        } else {
          state = state.copyWith(sportSpeedButton: speedKmPerH);
        }
        break;

      case FtmsStatusTargetInclineChanged(:final inclinePercent):
        // 0x06：坡度回调
        print(
          '[DeviceStatus] opCode=0x06, action=incline, value=$inclinePercent',
        );
        _onReceiptReceived(0x06, true);
        if (_syncGuard?.isInGuardWindow() ?? false) {
          print('[DeviceStatus] 在保护窗口内，跳过坡度更新');
        } else {
          state = state.copyWith(sportInclinationButton: inclinePercent);
        }
        break;

      case FtmsStatusTargetResistanceChanged(:final resistanceLevel):
        // 0x07：阻力回调（含阻力指令隐式回执）
        print(
          '[DeviceStatus] opCode=0x07, action=resistance, value=$resistanceLevel',
        );
        _onReceiptReceived(0x07, true);
        // 收到设备实际阻力回执 → 解除加载态（与保护窗口无关，loading 必须复位）
        _clearResistanceFetch();
        if (_syncGuard?.isInGuardWindow() ?? false) {
          print('[DeviceStatus] 在保护窗口内，跳过阻力数值更新');
        } else {
          state = state.copyWith(sportResistanceButton: resistanceLevel);
        }
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

  /// 开始运动的本地状态同步（不发送蓝牙指令，仅同步本地状态）。
  /// 供设备主动通知开始运动（0x04）时调用。
  void _startSportLocal() {
    state = state.copyWith(
      showPlayButton: false,
      isInQuickPlay: true,
      isPlaying: true,
    );
    _sportTimer?.start();
  }

  /// 将目标值转换为 FTMS 指令字节序列（uint16 小端序）。
  /// TODO: 确认设备具体字节格式与缩放因子，暂时使用原始整数值。
  List<int> _buildValueBytes(double value) {
    final raw = value.round().clamp(0, 65535);
    return [raw & 0xFF, (raw >> 8) & 0xFF];
  }

  // ==================== 阻力加载态辅助（任务3） ====================

  /// 启动阻力加载等待：置 isFetchingResistance=true 并启动超时定时器。
  ///
  /// 超时后自动解除加载态（保留乐观更新值），避免设备不发 0x07 回执时永久 loading。
  /// 每次下发阻力指令都调用本方法重置定时器。
  void _startResistanceFetch() {
    _resistanceFetchTimeout?.cancel();
    state = state.copyWith(isFetchingResistance: true);
    _resistanceFetchTimeout = Timer(_resistanceFetchTimeoutDur, () {
      // 超时兜底：解除 loading，保留乐观更新值
      if (state.isFetchingResistance) {
        state = state.copyWith(isFetchingResistance: false);
        print(
          '🎯 [Resistance] fetch timeout, cleared loading '
          '(value=${state.sportResistanceButton})',
        );
      }
      _resistanceFetchTimeout = null;
    });
    print('🎯 [Resistance] fetching start, waiting 0x07 receipt');
  }

  /// 解除阻力加载等待（收到 0x07 回执时调用）。
  void _clearResistanceFetch() {
    if (_resistanceFetchTimeout != null || state.isFetchingResistance) {
      _resistanceFetchTimeout?.cancel();
      _resistanceFetchTimeout = null;
      state = state.copyWith(isFetchingResistance: false);
      print('🎯 [Resistance] receipt received, cleared loading');
    }
  }

  // ==================== 目标达成弹窗：判定与队列 ====================

  /// 每次运动数据变化后调用：检查 3 个维度是否命中新目标档。
  void _checkAndTriggerGoalDialogs() {
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

  /// 发送重置指令到设备（对应旧 cnfbd.sendResetToDevice）。
  /// 使用 dispatchImmediate 立即下发，OpCode 0x00。
  void sendResetToDevice() {
    _dispatcher?.dispatchImmediate(FtmsCommand(0x00, []));
    print('[Notifier] sendResetToDevice: sending 0x00');
  }

  /// 开始运动（对应旧 cnfbd.startSport）。
  /// 1. 更新本地状态
  /// 2. 启动本地计时器
  /// 3. 下发"开始运动"指令（0x07 + [0x01]）
  void startSport() {
    state = state.copyWith(
      showPlayButton: false,
      isInQuickPlay: true,
      isPlaying: true,
    );
    _sportTimer?.start();
    _dispatcher?.dispatch(FtmsCommand(0x07, [0x01]));
    print('[Notifier] startSport: sending 0x07, timer started');
  }

  /// 停止运动（对应旧 cnfbd.stopSport）。
  /// 1. 停止本地计时器
  /// 2. 下发"停止运动"指令（0x07 + [0x00]）
  /// 3. 更新本地状态
  void stopSport() {
    _sportTimer?.stop();
    _dispatcher?.dispatch(FtmsCommand(0x07, [0x00]));
    state = state.copyWith(isPlaying: false);
    print('[Notifier] stopSport: sending 0x07 stop, timer stopped');
  }

  /// 即时停止运动（任务4：返回按钮专用）。
  ///
  /// 与 [stopSport] 区别：使用 `dispatchImmediate` 立即下发停止指令，
  /// 不走 debounce 合并，确保页面 pop 前停止指令必达设备。
  /// 用于返回按钮「先停后退」流程，提升停止指令可靠性。
  void stopSportImmediate() {
    _sportTimer?.stop();
    _dispatcher?.dispatchImmediate(FtmsCommand(0x07, [0x00]));
    state = state.copyWith(isPlaying: false);
    print('[Notifier] stopSportImmediate: sending 0x07 stop (immediate)');
  }

  /// 暂停运动（对应旧 cnfbd.pauseSport）。
  /// 1. 暂停本地计时器
  /// 2. 下发"暂停运动"指令（0x07 + [0x02]）
  /// 3. 更新本地状态
  void pauseSport() {
    _sportTimer?.pause();
    _dispatcher?.dispatch(FtmsCommand(0x07, [0x02]));
    state = state.copyWith(isPlaying: false);
    print('[Notifier] pauseSport: sending 0x07 pause, timer paused');
  }

  /// 清除数据（对应旧 cnfbd.clearData）。
  void clearData() {
    disposeGoalTimers();
    _sportTimer?.stop();
    _timeNormalizer?.reset();
    state = const QuickStartState();
  }

  /// 阻力 +（对应旧 cnfbd.resistanceAdd）。
  /// 获取当前阻力值 + step，clamp 后下发阻力控制指令（0x07 + [0x0B, ...value]）。
  /// 下发后进入加载态，等待设备 0x07 回执返回实际阻力值。
  @override
  void resistanceAdd() {
    final current = state.sportResistanceButton;
    final newValue = (current + _resistanceStep).clamp(
      _resistanceMin,
      _resistanceMax,
    );
    _dispatcher?.dispatch(
      FtmsCommand(0x07, [0x0B, ..._buildValueBytes(newValue)]),
    );
    // 乐观更新本地值（保证边界检测准确）+ 启动加载等待
    state = state.copyWith(sportResistanceButton: newValue);
    _startResistanceFetch();
    print('[Notifier] resistanceAdd: $current → $newValue');
  }

  /// 阻力 -（对应旧 cnfbd.resistanceDown）。
  /// 下发后进入加载态，等待设备 0x07 回执返回实际阻力值。
  @override
  void resistanceDown() {
    final current = state.sportResistanceButton;
    final newValue = (current - _resistanceStep).clamp(
      _resistanceMin,
      _resistanceMax,
    );
    _dispatcher?.dispatch(
      FtmsCommand(0x07, [0x0B, ..._buildValueBytes(newValue)]),
    );
    state = state.copyWith(sportResistanceButton: newValue);
    _startResistanceFetch();
    print('[Notifier] resistanceDown: $current → $newValue');
  }

  /// 速度 +（对应旧 cnfbd.speedAdd）。
  /// 下发速度控制指令（0x07 + [0x02, ...value]）。
  @override
  void speedAdd() {
    final current = state.sportSpeedButton;
    final newValue = (current + _speedStep).clamp(_speedMin, _speedMax);
    _dispatcher?.dispatch(
      FtmsCommand(0x07, [0x02, ..._buildValueBytes(newValue)]),
    );
    state = state.copyWith(sportSpeedButton: newValue);
    print('[Notifier] speedAdd: $current → $newValue');
  }

  /// 速度 -（对应旧 cnfbd.speedDown）。
  @override
  void speedDown() {
    final current = state.sportSpeedButton;
    final newValue = (current - _speedStep).clamp(_speedMin, _speedMax);
    _dispatcher?.dispatch(
      FtmsCommand(0x07, [0x02, ..._buildValueBytes(newValue)]),
    );
    state = state.copyWith(sportSpeedButton: newValue);
    print('[Notifier] speedDown: $current → $newValue');
  }

  /// 坡度 +（对应旧 cnfbd.inclinationAdd）。
  /// 下发坡度控制指令（0x07 + [0x03, ...value]）。
  void inclinationAdd() {
    final current = state.sportInclinationButton;
    final newValue = (current + _inclinationStep).clamp(
      _inclinationMin,
      _inclinationMax,
    );
    _dispatcher?.dispatch(
      FtmsCommand(0x07, [0x03, ..._buildValueBytes(newValue)]),
    );
    state = state.copyWith(sportInclinationButton: newValue);
    print('[Notifier] inclinationAdd: $current → $newValue');
  }

  /// 坡度 -（对应旧 cnfbd.inclinationDown）。
  void inclinationDown() {
    final current = state.sportInclinationButton;
    final newValue = (current - _inclinationStep).clamp(
      _inclinationMin,
      _inclinationMax,
    );
    _dispatcher?.dispatch(
      FtmsCommand(0x07, [0x03, ..._buildValueBytes(newValue)]),
    );
    state = state.copyWith(sportInclinationButton: newValue);
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

  /// 单次长按步进（更新 state + dispatch debounce 指令）。
  ///
  /// 步长固定 1.0（与旧项目 _adjustValue 一致），达到边界时取消 Timer。
  void _applyLongPressStep(_LongPressDimension dim, bool isAdd) {
    final delta = isAdd ? _longPressStep : -_longPressStep;
    switch (dim) {
      case _LongPressDimension.speed:
        final current = state.sportSpeedButton;
        final newValue = (current + delta).clamp(_speedMin, _speedMax);
        if (newValue == current) {
          _longPressTimer?.cancel();
          _longPressTimer = null;
          print('[Notifier] longPress speed reached boundary: $newValue');
          return;
        }
        _dispatcher?.dispatch(
          FtmsCommand(0x07, [0x02, ..._buildValueBytes(newValue)]),
        );
        state = state.copyWith(sportSpeedButton: newValue);
        print('[Notifier] longPress speed: $current → $newValue');
      case _LongPressDimension.incline:
        final current = state.sportInclinationButton;
        final newValue = (current + delta).clamp(
          _inclinationMin,
          _inclinationMax,
        );
        if (newValue == current) {
          _longPressTimer?.cancel();
          _longPressTimer = null;
          print('[Notifier] longPress incline reached boundary: $newValue');
          return;
        }
        _dispatcher?.dispatch(
          FtmsCommand(0x07, [0x03, ..._buildValueBytes(newValue)]),
        );
        state = state.copyWith(sportInclinationButton: newValue);
        print('[Notifier] longPress incline: $current → $newValue');
      case _LongPressDimension.resistance:
        final current = state.sportResistanceButton;
        final newValue = (current + delta).clamp(
          _resistanceMin,
          _resistanceMax,
        );
        if (newValue == current) {
          _longPressTimer?.cancel();
          _longPressTimer = null;
          print('[Notifier] longPress resistance reached boundary: $newValue');
          return;
        }
        _dispatcher?.dispatch(
          FtmsCommand(0x07, [0x0B, ..._buildValueBytes(newValue)]),
        );
        state = state.copyWith(sportResistanceButton: newValue);
        // 长按期间持续 loading，松手后等待最终回执解除
        _startResistanceFetch();
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
  /// 2. 开启 1500ms 保护窗口，屏蔽设备 0x2ADA 回调对本地按钮值的覆盖
  @override
  void longPressEnd() {
    final dim = _currentLongPressDimension;
    _longPressTimer?.cancel();
    _longPressTimer = null;
    _currentLongPressDimension = null;
    _syncGuard?.beginGuardWindow(const Duration(milliseconds: 1500));
    print(
      '[Notifier] longPressEnd: dim=$dim, timer cancelled, guard window started',
    );
  }

  /// 数字按钮选择（对应旧 cnfbd.numberButton）。
  /// [type]: 0=速度, 1=坡度, 2=阻力。
  /// 使用 debounce 模式下发目标值指令。
  void numberButton(double value, int type) {
    // 根据类型选择子命令码
    final subCommand = switch (type) {
      0 => 0x02, // 速度
      1 => 0x03, // 坡度
      2 => 0x0B, // 阻力
      _ => null,
    };
    if (subCommand == null) {
      print('[Notifier] numberButton: 未知 type=$type');
      return;
    }
    _dispatcher?.dispatch(
      FtmsCommand(0x07, [subCommand, ..._buildValueBytes(value)]),
    );
    // 同步更新本地对应按钮值
    switch (type) {
      case 0:
        state = state.copyWith(sportSpeedButton: value);
        break;
      case 1:
        state = state.copyWith(sportInclinationButton: value);
        break;
      case 2:
        state = state.copyWith(sportResistanceButton: value);
        // 阻力档位预设下发后进入加载态，等待 0x07 回执
        _startResistanceFetch();
        break;
    }
    print('[Notifier] numberButton: target=$value, type=$type');
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

/// 长按调节维度（速度 / 坡度 / 阻力）。
enum _LongPressDimension { speed, incline, resistance }
