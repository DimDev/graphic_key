import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import './point.dart';

class PointsPainter extends CustomPainter {
  final Size _size;
  List<Point> _points = [];

  final Color pointColor;
  final double pointStrokeWidth;
  final double pointCircleRadius;
  final double pointCircleStrokeWidth;
  final Color pointCircleColor;

  PointsPainter(
      this._size,
      this.pointColor,
      this.pointStrokeWidth,
      this.pointCircleRadius,
      this.pointCircleStrokeWidth,
      this.pointCircleColor,
      );

  List<Point> get points {
    if (_points.isNotEmpty) {
      return _points;
    }
    var interval = _size.width / 4;
    int column = 1;
    for (var pointNum = 1; pointNum <= 9; pointNum++) {
      final line = (pointNum >= 7)
          ? 3
          : (pointNum >= 4)
          ? 2
          : 1;
      _points.add(Point(
        pointNum,
        column * interval,
        line * interval,
        focusRadius: pointCircleRadius,
      ));
      column = (column == 3) ? 1 : column + 1;
    }
    return _points;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.points;
    final paint = Paint()
      ..color = pointColor
      ..strokeWidth = pointStrokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points.map((Point point) => point.offset).toList(), paint);

    var circlePaint = Paint();
    circlePaint.strokeWidth = pointCircleStrokeWidth;
    circlePaint.color = pointCircleColor;
    circlePaint.style = PaintingStyle.stroke;
    points.forEach((Point point) {
      canvas.drawCircle(point.offset, point.focusRadius, circlePaint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: investigate this method
    return true;
  }
}
