import 'dart:ui' show Offset;

class Point {
  final int num;
  late Offset offset;
  bool isSelected = false;

  Point({
    required this.num,
    required double x,
    required double y,
  }) {
    offset = Offset(x, y);
  }
}
