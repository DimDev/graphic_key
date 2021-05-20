import 'package:flutter/material.dart';

import './point.dart';
import './points_line.dart';

class LinePainter extends CustomPainter {
  PointsLine pointsLine;
  final double lineStrokeWidth;
  final Color lineColor;

  late final Paint paintBrush;

  LinePainter({
    required this.pointsLine,
    this.lineStrokeWidth = 5,
    this.lineColor = Colors.red,
  }) {
    paintBrush = Paint()
      ..color = lineColor
      ..strokeWidth = lineStrokeWidth
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    print('Painting line');
    if (pointsLine.selectedPoints.isEmpty) {
      return;
    }

    if (pointsLine.selectedPoints.length > 1) {
      var start = pointsLine.selectedPoints.first;
      for (Point point in pointsLine.selectedPoints) {
        canvas.drawLine(start.offset, point.offset, paintBrush);
        start = point;
      }
    }
    if (pointsLine.temporaryLineEnd != null) {
      canvas.drawLine(pointsLine.selectedPoints.last.offset, pointsLine.temporaryLineEnd!, paintBrush);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    print('shouldRepaint Painting line');
    return true;
  }
}
