# FTMS 阻力值编码与指令下发修复计划

> 本文档描述 VividFit v2 项目中 FTMS 协议阻力值编码错误和指令下发方式不标准的问题，以及对应的修复方案。AI 可按照本文档逐文件执行修改。

---

## 一、问题概述

### Bug 1：阻力值编码错误（浮点数 → 整数）

FTMS 协议规定 `Set Target Resistance Level (0x04)` 的数据格式为 **uint8（1 字节），分辨率 0.1 unitless**。即：阻力等级 8 对应字节值 80（8 × 10）。

**原代码**将阻力值作为浮点数直接 `× 10` 后 `round()`，导致：
- 按钮值可能出现小数（如 8.5），但设备只认整数等级
- `setTargetResistance(8.5)` 发送字节 85，设备解析为等级 8.5，部分设备不识别

### Bug 2：指令下发方式错误（0x07 包裹 → 标准 OpCode）

**原代码**使用非标准的指令格式：`FtmsCommand(0x07, [子 OpCode, ...参数字节])`，其中 0x07 是 `Start or Reset` 指令，不是参数控制指令。

**正确做法**是直接使用 FTMS 标准 OpCode：
- 速度：`0x02 Set Target Speed`（uint16 LE，分辨率 0.01 km/h）
- 坡度：`0x03 Set Target Inclination`（sint16 LE，分辨率 0.1%）
- 阻力：`0x04 Set Target Resistance Level`（uint8，分辨率 0.1）

### Bug 3：阻力解析缺少分辨率换算

设备回传的阻力值是 sint16，分辨率 0.1。**原代码**直接 `readInt16().toDouble()` 读取原始值，没有 `× 0.1` 还原，导致阻力值偏大 10 倍。

### Bug 4：阻力按钮显示小数

UI 层阻力值使用 `toStringAsFixed(1)` 显示 1 位小数，与"阻力等级必须为整数"的设计不一致。

---

## 二、修复方案

### 修复 1：`lib/core/ftms/ftms_command_builder.dart`

**目标**：阻力值取整后再编码。

**修改前：**
```dart
/// [resistanceLevel] 阻力等级,如 8.5 表示 8.5 级。
static Uint8List setTargetResistance(double resistanceLevel) {
  final raw = (resistanceLevel * 10).round().clamp(0, 255); // uint8
  return Uint8List.fromList([0x04, raw]);
}
```

**修改后：**
```dart
/// [resistanceLevel] 阻力等级,整数如 8 表示 8 级,发送时 ×10 → 字节 80。
static Uint8List setTargetResistance(double resistanceLevel) {
  final intLevel = resistanceLevel.round();
  final raw = (intLevel * 10).clamp(0, 255); // uint8
  return Uint8List.fromList([0x04, raw]);
}
```

**要点**：先 `round()` 取整，再 `× 10`，确保发送的是整数等级。

---

### 修复 2：`lib/core/ftms/parsers/indoor_bike_parser.dart`

**目标**：阻力解析增加 0.1 分辨率换算。

**修改前：**
```dart
// 阻力等级(bit5, sint16)
if (flagSet(flags, 5) && hasData(data, offset, 2)) {
  resistanceLvl = readInt16(bd, offset).toDouble();
  offset += 2;
}
```

**修改后：**
```dart
// 阻力等级(bit5, sint16, 分辨率 0.1)
if (flagSet(flags, 5) && hasData(data, offset, 2)) {
  resistanceLvl = readInt16(bd, offset) * 0.1;
  offset += 2;
}
```

---

### 修复 3：`lib/core/ftms/parsers/rower_parser.dart`

**目标**：同上，划船机阻力解析增加 0.1 分辨率换算。

**修改前：**
```dart
// 阻力等级(bit7, sint16)
if (flagSet(flags, 7) && hasData(data, offset, 2)) {
  resistanceLvl = readInt16(bd, offset).toDouble();
  offset += 2;
}
```

**修改后：**
```dart
// 阻力等级(bit7, sint16, 分辨率 0.1)
if (flagSet(flags, 7) && hasData(data, offset, 2)) {
  resistanceLvl = readInt16(bd, offset) * 0.1;
  offset += 2;
}
```

---

### 修复 4：`lib/features/big_device/notifiers/gym_course_play_notifier.dart`

此文件有多处修改，分为 4 个部分。

#### 4.1 重构 `_buildValueBytes` 方法

**目标**：按 opCode 分发编码，0x04 阻力用 uint8（1 字节），不再统一用 uint16 LE（2 字节）。

**修改前：**
```dart
/// 将 double 值转为 2 字节小端序列（uint16 LE）。
List<int> _buildValueBytes(double value) {
  final raw = value.round().clamp(0, 65535);
  return [raw & 0xFF, (raw >> 8) & 0xFF];
}
```

**修改后：**
```dart
/// 按 FTMS 协议编码参数字节。
/// - 0x02 速度：km/h × 100 → uint16 LE (2 字节)
/// - 0x03 坡度：% × 10 → sint16 LE (2 字节)
/// - 0x04 阻力：level × 10 → uint8 (1 字节)
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
      final intValue = value.round();
      final raw = (intValue * 10).clamp(0, 255);
      return [raw];
    default:
      final raw = value.round();
      final clamped = raw & 0xFFFF;
      return [clamped & 0xFF, (clamped >> 8) & 0xFF];
  }
}
```

**要点**：
- 方法签名从 `_buildValueBytes(double value)` 改为 `_buildValueBytes(int opCode, double value)`
- 0x04 阻力返回 1 字节（uint8），不是 2 字节
- 所有调用处需同步传入 opCode 参数

#### 4.2 修改所有指令下发调用

**目标**：从 `FtmsCommand(0x07, [子OpCode, ..._buildValueBytes(value)])` 改为 `FtmsCommand(标准OpCode, _buildValueBytes(OpCode, value))`。

需要修改的位置（所有涉及速度/坡度/阻力的 dispatch 调用）：

**速度指令（原 0x07 + 0x02 → 直接 0x02）：**
```dart
// 修改前：
_dispatcher?.dispatch(FtmsCommand(0x07, [0x02, ..._buildValueBytes(newValue)]));
// 修改后：
_dispatcher?.dispatch(FtmsCommand(0x02, _buildValueBytes(0x02, newValue)));
```

**坡度指令（原 0x07 + 0x03 → 直接 0x03）：**
```dart
// 修改前：
_dispatcher?.dispatch(FtmsCommand(0x07, [0x03, ..._buildValueBytes(newValue)]));
// 修改后：
_dispatcher?.dispatch(FtmsCommand(0x03, _buildValueBytes(0x03, newValue)));
```

**阻力指令（原 0x07 + 0x0B → 直接 0x04）：**
```dart
// 修改前：
_dispatcher?.dispatch(FtmsCommand(0x07, [0x0B, ..._buildValueBytes(newValue)]));
// 修改后：
_dispatcher?.dispatch(FtmsCommand(0x04, _buildValueBytes(0x04, newValue)));
```

**需要遍历修改的方法清单**（在该文件中搜索 `FtmsCommand(0x07` 找到所有调用）：
- `_applyActionParameters` 中的 treadmill（速度）和 bike/rower（阻力）分支
- `speedAdd()` / `speedDown()`
- `inclinationAdd()` / `inclinationDown()`
- `resistanceAdd()` / `resistanceDown()`
- `speedAddLongPress()` / `speedDownLongPress()`
- `inclinationAddLongPress()` / `inclinationDownLongPress()`
- `resistanceAddLongPress()` / `resistanceDownLongPress()`

#### 4.3 阻力相关方法取整

**目标**：所有阻力操作的结果值 `round()` 取整，不再保留小数。

**修改模式**（适用于 `resistanceAdd`、`resistanceDown`、`resistanceAddLongPress`、`resistanceDownLongPress`）：
```dart
// 修改前：
final newValue = double.parse(v.toStringAsFixed(1));
// 修改后：
final newValue = v.round().toDouble();
```

**`_applyActionParameters` 中的阻力分支：**
```dart
// 修改前：
final resistance = action.resistance.toDouble();
state = state.copyWith(sportResistanceButton: resistance);
// 修改后：
final resistance = action.resistance.round().toDouble();
state = state.copyWith(sportResistanceButton: resistance);
```

#### 4.4 阻力回调取整

**目标**：设备回传阻力值时取整后再写入按钮状态。

**修改前：**
```dart
case FtmsStatusTargetResistanceChanged(:final resistanceLevel):
  debugPrint('... value=$resistanceLevel');
  // ... 后续直接使用 resistanceLevel
  state = state.copyWith(sportResistanceButton: resistanceLevel);
```

**修改后：**
```dart
case FtmsStatusTargetResistanceChanged(:final resistanceLevel):
  final intLevel = resistanceLevel.round().toDouble();
  debugPrint('... value=$intLevel');
  // ... 后续使用 intLevel
  state = state.copyWith(sportResistanceButton: intLevel);
```

---

### 修复 5：`lib/features/big_device/notifiers/quick_start_notifier.dart`

此文件与 `gym_course_play_notifier.dart` 修复方式相同，分为 4 个部分。

#### 5.1 重构 `_buildValueBytes` 方法

与修复 4.1 完全相同的修改。注意该文件可能已有 opCode 参数版本（如果代码库已部分修复），需确认 0x04 分支返回 1 字节 uint8 而非 2 字节。

#### 5.2 修改所有指令下发调用

与修复 4.2 相同的修改模式。搜索 `FtmsCommand(0x07` 找到所有调用并改为直接 OpCode。

#### 5.3 阻力相关方法取整

与修复 4.3 相同。涉及方法：
- `resistanceAdd()` / `resistanceDown()`
- 长按中的阻力方法
- 数字预设选择（`numberButton` 方法中 `case 2:` 阻力分支）

**数字预设选择修改：**
```dart
// 修改前：
case 2:
  _syncEngine.lock(ParamDimension.resistance, clampedValue, ...);
  _dispatcher?.dispatchTracked(
    FtmsCommand(opCode, _buildValueBytes(opCode, clampedValue)),
  );
  state = state.copyWith(sportResistanceButton: clampedValue, ...);
// 修改后：
case 2:
  final intValue = clampedValue.round().toDouble();
  _syncEngine.lock(ParamDimension.resistance, intValue, ...);
  _dispatcher?.dispatchTracked(
    FtmsCommand(opCode, _buildValueBytes(opCode, intValue)),
  );
  state = state.copyWith(sportResistanceButton: intValue, ...);
```

#### 5.4 阻力回调取整

与修复 4.4 相同。

#### 5.5 参数同步引擎中的阻力取整

**目标**：`_processParamSync` 方法中，阻力维度的设备回传值取整。

**修改前：**
```dart
void _processParamSync(ParamDimension dim, double actual, int opCode) {
  final decision = _syncEngine.onActualUpdate(dim, actual);
  switch (decision) {
    case ParamSyncMatched():
      state = _copyWithDimState(dim, buttonValue: actual, locked: false);
    case ParamSyncStableIdle(:final value):
      if (!_syncEngine.isLocked(dim)) {
        state = _copyWithDimState(dim, buttonValue: value);
      }
```

**修改后：**
```dart
void _processParamSync(ParamDimension dim, double actual, int opCode) {
  // 阻力维度：设备回传值取整，保持按钮值为整数
  final roundedActual = dim == ParamDimension.resistance
      ? actual.round().toDouble()
      : actual;
  final decision = _syncEngine.onActualUpdate(dim, roundedActual);
  switch (decision) {
    case ParamSyncMatched():
      state = _copyWithDimState(dim, buttonValue: roundedActual, locked: false);
    case ParamSyncStableIdle(:final value):
      if (!_syncEngine.isLocked(dim)) {
        final roundedValue = dim == ParamDimension.resistance
            ? value.round().toDouble()
            : value;
        state = _copyWithDimState(dim, buttonValue: roundedValue);
      }
```

---

### 修复 6：`lib/features/big_device/pages/gym_device_play_screen.dart`

**目标**：阻力按钮显示整数。

**修改前：**
```dart
value: state.sportResistanceButton.toStringAsFixed(1),
```

**修改后：**
```dart
value: state.sportResistanceButton.toStringAsFixed(0),
```

---

### 修复 7：`lib/features/big_device/widgets/level_control_button.dart`

**目标**：同上，阻力值显示整数。

**修改前：**
```dart
currentValueText = d.resistanceValue.toStringAsFixed(1);
```

**修改后：**
```dart
currentValueText = d.resistanceValue.toStringAsFixed(0);
```

---

### 修复 8：`lib/features/big_device/widgets/sport_control_panel.dart`

**目标**：同上，阻力值显示整数。

**修改前：**
```dart
value: d.resistanceValue.toStringAsFixed(1),
```

**修改后：**
```dart
value: d.resistanceValue.toStringAsFixed(0);
```

---

## 三、验证要点

1. **阻力编码验证**：`setTargetResistance(8)` 应发送字节 `[0x04, 80]`（即 0x04 + 8×10=80）
2. **速度编码验证**：速度 10.0 km/h 应发送 `[0x02, 0xE8, 0x03]`（即 0x02 + 1000=0x03E8 小端序）
3. **坡度编码验证**：坡度 5.0% 应发送 `[0x03, 0x32, 0x00]`（即 0x03 + 50=0x0032 小端序）
4. **阻力解析验证**：设备回传 sint16 值 80 时，解析为 8.0（80 × 0.1）
5. **UI 显示验证**：阻力按钮始终显示整数（如"8"而非"8.0"或"8.5"）
6. **无 0x07 残留**：全项目搜索 `FtmsCommand(0x07` 应只在 `Start/Reset` 场景出现（如 `FtmsCommand(0x07, [])`），不应出现在参数控制指令中
