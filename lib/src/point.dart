import 'dart:ui';

class Point {
  final int num;
  late Offset offset;
  bool isActive = false;
  double focusRadius;

  Point(this.num, double x, double y, {this.focusRadius = 20}) {
    offset = Offset(x, y);
  }
}
