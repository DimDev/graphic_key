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

  Listenable? repaint;

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
    this.repaint,
  }) : super(repaint: repaint) {
    print('Rebuilding canvas');
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

  @override
  void paint(Canvas canvas, Size size) {
    print('Draw points');
    List<Offset> notSelectedPoints =
        points.where((Point point) => !point.isSelected).map((Point point) => point.offset).toList();
    List<Offset> selectedPoints =
        points.where((Point point) => point.isSelected).map((Point point) => point.offset).toList();

    canvas.drawPoints(
      ui.PointMode.points,
      notSelectedPoints,
      _pointPaint,
    );
    canvas.drawPoints(
      ui.PointMode.points,
      selectedPoints,
      _selectedPointPaint,
    );

    selectedPoints.forEach((Offset offset) {
      canvas.drawCircle(
        offset,
        pointCircleRadius,
        _selectedPointCirclePaint,
      );
    });

    notSelectedPoints.forEach((Offset offset) {
      canvas.drawCircle(
        offset,
        pointCircleRadius,
        _pointCirclePaint,
      );
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
