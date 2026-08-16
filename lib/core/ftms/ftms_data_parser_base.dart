import 'dart:typed_data';

import 'ftms_device_data.dart';

/// FTMS 数据解析器抽象基类(模板方法模式)。
///
/// 封装 4 种设备解析器共享的工具方法:
/// - 小端序 uint16/uint24/int16 读取
/// - uint24 组装
/// - 精度修正
///
/// 子类只需实现 [parse] 方法,按各自设备的 Flags bit 映射字段。
abstract class FtmsDataParserBase {
  /// 解析原始二进制数据为 [FtmsDeviceData]。
  FtmsDeviceData parse(Uint8List data);

  // ---- 通用工具方法 ----

  /// 读取 uint16 小端序。
  int readUint16(ByteData bd, int offset) =>
      bd.getUint16(offset, Endian.little);

  /// 读取 int16 小端序。
  int readInt16(ByteData bd, int offset) =>
      bd.getInt16(offset, Endian.little);

  /// 读取 uint8。
  int readUint8(ByteData bd, int offset) => bd.getUint8(offset);

  /// 读取 uint24 小端序(3 字节)。
  int readUint24(Uint8List data, int offset) {
    if (offset + 3 > data.length) return 0;
    return (data[offset] & 0xFF) |
        ((data[offset + 1] & 0xFF) << 8) |
        ((data[offset + 2] & 0xFF) << 16);
  }

  /// 保留指定小数位精度(与旧项目 DataConvert.fixPrecision 保持一致)。
  ///
  /// 使用字符串转换实现,保证舍入行为与旧项目完全相同。
  double fixPrecision(double value, int fractionDigits) {
    return double.parse(value.toStringAsFixed(fractionDigits));
  }

  /// 检查 Flags 的第 [bit] 位是否置 1。
  bool flagSet(int flags, int bit) => (flags & (1 << bit)) != 0;

  /// 检查数据长度是否足够读取 [size] 字节。
  bool hasData(Uint8List data, int offset, int size) =>
      offset + size <= data.length;
}
