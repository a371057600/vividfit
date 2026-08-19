import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_fonts.dart';
import '../models/device_control_callbacks.dart';
import '../models/device_control_data.dart';

// ==================== 5 档控制按钮缩放与尺寸常量 ====================
// 数值与原 quick_start_training_page.dart 中的常量保持一致，
// 此处使用文件私有常量，避免与页面文件中的同名常量产生导入冲突。

/// 控制按钮整体宽度缩放系数（默认 1.0）。
const double _kWidthFactor = 1.0;

/// 控制按钮整体高度缩放系数（默认 0.98）。
const double _kHeightFactor = 0.98;

/// 控制按钮可用高度占屏幕高度的比例（0.82 × 屏幕高度）。
const double _kUsableHeightRatio = 0.82;

/// 5 档控制按钮组件。
///
/// 从 `quick_start_training_page.dart` 的 `_buildLevelControlButton` 方法提取，
/// 在保持原版视觉表现（色值、圆角、字体、间距、图标尺寸）的前提下重组为独立 Widget。
///
/// 内部根据 [DeviceControlCallbacks] 中已注入的回调与 [DeviceControlData.hasInclinationSupport]
/// 自动决定展示哪些按钮组（速度 / 坡度 / 阻力），每组沿用原版 5 档竖排布局：
///   - 上方 2 个预设档位按钮
///   - 中央组合区：加号按钮 + 当前数值 + 类型标签 + 减号按钮
///   - 下方 2 个预设档位按钮
///
/// 加号 / 减号按钮通过 [GestureDetector] 支持长按手势
/// （[GestureDetector.onLongPress] + [GestureDetector.onLongPressEnd]）。
///
/// 按钮组排列顺序：阻力 → 坡度 → 速度，与原版单车页（阻力+坡度）和跑步机页（坡度+速度）一致。
class LevelControlButton extends StatelessWidget {
  const LevelControlButton({
    super.key,
    this.callbacks,
    this.data,
    this.widthFactor,
    this.heightFactor,
  });

  /// 设备控制回调集合（速度 / 坡度 / 阻力的加减、长按加减、档位预设点击及长按结束）。
  ///
  /// 传入 null 时组件不渲染任何内容。各组按钮仅当对应回调非 null 时才展示。
  final DeviceControlCallbacks? callbacks;

  /// 设备控制数据（当前值、档位预设列表、设备是否支持坡度等）。
  ///
  /// 传入 null 时组件不渲染任何内容。
  final DeviceControlData? data;

  /// 整体宽度缩放系数，默认取 [_kWidthFactor]（1.0）。
  final double? widthFactor;

  /// 整体高度缩放系数，默认取 [_kHeightFactor]（0.98）。
  final double? heightFactor;

  @override
  Widget build(BuildContext context) {
    final cb = callbacks;
    final d = data;
    if (cb == null || d == null) return const SizedBox.shrink();

    // —— 根据回调非空 + 设备能力，决定展示哪些按钮组 ——
    final groups = <_ControlGroupType>[];
    if (cb.onResistanceAdd != null || cb.onResistanceDown != null) {
      groups.add(_ControlGroupType.resistance);
    }
    if (d.hasInclinationSupport &&
        (cb.onInclineAdd != null || cb.onInclineDown != null)) {
      groups.add(_ControlGroupType.inclination);
    }
    if (cb.onSpeedAdd != null || cb.onSpeedDown != null) {
      groups.add(_ControlGroupType.speed);
    }

    if (groups.isEmpty) return const SizedBox.shrink();

    // 组与组之间插入 Spacer，复刻原版 Row + spaceBetween 布局
    final children = <Widget>[];
    for (int i = 0; i < groups.length; i++) {
      if (i > 0) children.add(const Spacer());
      children.add(_buildSingleGroup(context, groups[i], cb, d));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }

  /// 构建单个 5 档按钮组（1:1 复刻原版 `_buildLevelControlButton` 视觉）。
  Widget _buildSingleGroup(
    BuildContext context,
    _ControlGroupType type,
    DeviceControlCallbacks cb,
    DeviceControlData d,
  ) {
    // —— 缩放系数 ——
    final wf = widthFactor ?? _kWidthFactor;
    final hf = heightFactor ?? _kHeightFactor;
    // 文字 / 图标取较小系数，保证不溢出（与原版一致）
    final scaleFactor = wf < hf ? wf : hf;

    final screenHeight = MediaQuery.of(context).size.height;
    final buttonWidth = 70.w * wf;
    final buttonHeight = screenHeight * _kUsableHeightRatio * hf;

    // —— 解析当前组的数值、档位预设、回调 ——
    final String currentValueText;
    final String typeLabel;
    final List<double> presets;
    final VoidCallback? onAdd;
    final VoidCallback? onDown;
    final VoidCallback? onLongPressAdd;
    final VoidCallback? onLongPressDown;
    final void Function(double)? onPreset;

    switch (type) {
      case _ControlGroupType.speed:
        currentValueText = d.speedValue.toStringAsFixed(1);
        typeLabel = 'Speed';
        presets = d.speedPresets;
        onAdd = cb.onSpeedAdd;
        onDown = cb.onSpeedDown;
        onLongPressAdd = cb.onSpeedLongPressAdd;
        onLongPressDown = cb.onSpeedLongPressDown;
        onPreset = cb.onSpeedPreset;
        break;
      case _ControlGroupType.inclination:
        currentValueText = d.inclineValue.toStringAsFixed(1);
        typeLabel = 'Inclination';
        presets = d.inclinePresets;
        onAdd = cb.onInclineAdd;
        onDown = cb.onInclineDown;
        onLongPressAdd = cb.onInclineLongPressAdd;
        onLongPressDown = cb.onInclineLongPressDown;
        onPreset = cb.onInclinePreset;
        break;
      case _ControlGroupType.resistance:
        currentValueText = d.resistanceValue.toStringAsFixed(0);
        typeLabel = 'Resistance';
        presets = d.resistancePresets;
        onAdd = cb.onResistanceAdd;
        onDown = cb.onResistanceDown;
        onLongPressAdd = cb.onResistanceLongPressAdd;
        onLongPressDown = cb.onResistanceLongPressDown;
        onPreset = cb.onResistancePreset;
        break;
    }

    // 长按结束回调（速度 / 坡度 / 阻力共用同一个）
    final onLongPressEnd = cb.onLongPressEnd;

    // —— 样式参数（与原版完全一致） ——
    final buttonDecoration = BoxDecoration(
      color: const Color.fromARGB(255, 25, 25, 25),
      borderRadius: BorderRadius.circular(3),
      border: Border.all(
        color: const Color.fromARGB(255, 106, 95, 95),
        width: 1,
      ),
    );

    final textStyle = TextStyle(
      fontSize: 18.sp * scaleFactor,
      height: 0.8,
      fontWeight: FontWeight.w500,
      fontFamily: AppFonts.bebas,
      color: Colors.white,
    );

    final innerMargin =
        EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5).r * scaleFactor;
    final innerBottomPadding = 4 * scaleFactor;

    // —— 预设档位值（原版顺序：top=presets[3], second=presets[2], fourth=presets[1], fifth=presets[0]） ——
    final preset0 = presets.isNotEmpty ? presets[0] : 0.0;
    final preset1 = presets.length > 1 ? presets[1] : 0.0;
    final preset2 = presets.length > 2 ? presets[2] : 0.0;
    final preset3 = presets.length > 3 ? presets[3] : 0.0;

    /// 构建预设档位按钮（Expanded + InkWell + Container）。
    Widget buildPresetButton(String value, VoidCallback? onTapCallback) {
      return Expanded(
        flex: 1,
        child: InkWell(
          // 点击日志：确认手势已触达按钮（与 Notifier 层日志形成链路对照）
          onTap: onTapCallback != null
              ? () {
                  print('👆 [Button] 点击: $typeLabel 预设档位=$value');
                  onTapCallback();
                }
              : null,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: innerBottomPadding),
            margin: innerMargin,
            decoration: buttonDecoration,
            child: Text(value, style: textStyle),
          ),
        ),
      );
    }

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // —— 顶部第 1 个预设（presets[3]） ——
          buildPresetButton(
            preset3.toStringAsFixed(1),
            onPreset != null ? () => onPreset!(preset3) : null,
          ),
          // —— 顶部第 2 个预设（presets[2]） ——
          buildPresetButton(
            preset2.toStringAsFixed(1),
            onPreset != null ? () => onPreset!(preset2) : null,
          ),
          // —— 中央组合区：加号 + 当前值 + 减号 ——
          Expanded(
            flex: 3,
            child: Container(
              margin: innerMargin,
              decoration: buttonDecoration,
              child: Column(
                children: [
                  // 加号按钮（仅速度支持长按；长按回调为 null 时不绑定长按手势）
                  Expanded(
                    child: GestureDetector(
                      onLongPress: onLongPressAdd != null
                          ? () {
                              print('👆 [Button] 长按开始: $typeLabel +');
                              onLongPressAdd!();
                            }
                          : null,
                      onLongPressEnd:
                          (onLongPressAdd != null && onLongPressEnd != null)
                          ? (_) {
                              print('👆 [Button] 长按结束: $typeLabel +');
                              onLongPressEnd();
                            }
                          : null,
                      onTap: onAdd != null
                          ? () {
                              print('👆 [Button] 点击: $typeLabel +');
                              onAdd!();
                            }
                          : null,
                      child: Container(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.add,
                          size: 30.sp * scaleFactor,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // 当前数值 + 类型标签
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(currentValueText, style: textStyle),
                          SizedBox(height: 8.sp * scaleFactor),
                          Text(
                            typeLabel,
                            style: TextStyle(
                              fontSize: 8.sp * scaleFactor,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 减号按钮（仅速度支持长按；长按回调为 null 时不绑定长按手势）
                  Expanded(
                    child: GestureDetector(
                      onLongPress: onLongPressDown != null
                          ? () {
                              print('👆 [Button] 长按开始: $typeLabel -');
                              onLongPressDown!();
                            }
                          : null,
                      onLongPressEnd:
                          (onLongPressDown != null && onLongPressEnd != null)
                          ? (_) {
                              print('👆 [Button] 长按结束: $typeLabel -');
                              onLongPressEnd();
                            }
                          : null,
                      onTap: onDown != null
                          ? () {
                              print('👆 [Button] 点击: $typeLabel -');
                              onDown!();
                            }
                          : null,
                      child: Container(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.remove,
                          size: 30.sp * scaleFactor,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // —— 底部第 1 个预设（presets[1]） ——
          buildPresetButton(
            preset1.toStringAsFixed(1),
            onPreset != null ? () => onPreset!(preset1) : null,
          ),
          // —— 底部第 2 个预设（presets[0]） ——
          buildPresetButton(
            preset0.toStringAsFixed(1),
            onPreset != null ? () => onPreset!(preset0) : null,
          ),
        ],
      ),
    );
  }
}

/// 内部按钮组类型枚举。
enum _ControlGroupType { speed, inclination, resistance }
