/// 字体 family 常量(迁移自旧项目 jsp_name.dart 的字体部分)。
///
/// pubspec.yaml 已声明对应字体文件:
/// - BEBAS → fonts/BEBAS-1.ttf
/// - hofontmedium → fonts/HARMONYOS_SANS_SC_MEDIUM.ttf
/// - hofontregular → fonts/HARMONYOS_SANS_SC_REGULAR.ttf
/// - hofontblod → fonts/HARMONYOS_SANS_SC_REGULAR.ttf(旧项目未单独声明,用 regular 代替)
/// - hofontrelight → fonts/HARMONYOS_SANS_SC_REGULAR.ttf
class AppFonts {
  AppFonts._();

  static const String bebas = 'BEBAS';
  static const String hofontblod = 'hofontblod';
  static const String hofontrelight = 'hofontrelight';
  static const String hofontregular = 'hofontregular';
  static const String hofontmedium = 'hofontmedium';
}
