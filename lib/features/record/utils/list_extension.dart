extension ListExtension<T> on List<T> {
  bool isValidIndex(int index) => index >= 0 && index < length;
}