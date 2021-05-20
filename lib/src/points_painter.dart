import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import './point.dart';

class PointsPainter extends CustomPainter {
  final List<Point> points;
  final Color pointColor;
  final double pointStrokeWidth;

  final Color selectedPointColor;
  final double selectedPointStrokeWidth;

  final Color pointCircleColor;
  final double pointCircleRadius;
  final double pointCircleStrokeWidth;

  final Color selectedPointCircleColor;
  final double selectedPointCircleRadius;
  final double selectedPointCircleStrokeWidth;

  late final Paint _pointPaint;
  late final Paint _selectedPointPaint;

  late final Paint _pointCirclePaint;
  late final Paint _selectedPointCirclePaint;

  PointsPainter({
    required this.points,
    required this.pointColor,
    required this.pointStrokeWidth,
    required this.selectedPointColor,
    required this.selectedPointStrokeWidth,
    required this.pointCircleRadius,
    required this.pointCircleStrokeWidth,
    required this.pointCircleColor,
    required this.selectedPointCircleRadius,
    required this.selectedPointCircleStrokeWidth,
    required this.selectedPointCircleColor,
  }) {
    _pointPaint = Paint()
      ..color = pointColor
      ..strokeWidth = pointStrokeWidth
      ..strokeCap = StrokeCap.round;

    _selectedPointPaint = Paint()
      ..color = selectedPointColor
      ..strokeWidth = selectedPointStrokeWidth
      ..strokeCap = StrokeCap.round;

    _pointCirclePaint = Paint()
      ..strokeWidth = pointCircleStrokeWidth
      ..color = pointCircleColor
      ..style = PaintingStyle.stroke;

    _selectedPointCirclePaint = Paint()
      ..strokeWidth = selectedPointCircleStrokeWidth
      ..color = selectedPointCircleColor
      ..style = PaintingStyle.stroke;
  }

  /*List<Point> get points {
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
        num: pointNum,
        x: column * interval,
        y: line * interval,
        focusRadius: pointCircleRadius,
      ));
      column = (column == 3) ? 1 : column + 1;
    }
    return _points;
  }*/

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
      canvas.drawCircle(point.offset, pointCircleRadius, circlePaint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: investigate this method
    return true;
  }
}
