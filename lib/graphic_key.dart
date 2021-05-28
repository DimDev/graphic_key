import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphic_key/src/line_painter.dart';
import 'package:graphic_key/src/point.dart';
import 'package:graphic_key/src/points_line.dart';
import 'package:graphic_key/src/points_painter.dart';
import 'package:graphic_key/src/typedef.dart';

class GraphicKey extends StatelessWidget {
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

  final Color lineColor;
  final double lineStrokeWidth;

  final Color? backgroundColor;

  final KeyEnteredCallback keyEnteredCallback;
  final PointSelectedCallback? pointSelectedCallback;

  GraphicKey(
      {this.pointColor = Colors.red,
      this.pointStrokeWidth = 10,
      this.selectedPointColor = Colors.red,
      this.selectedPointStrokeWidth = 10,
      this.pointCircleRadius = 20,
      this.pointCircleStrokeWidth = 1,
      this.pointCircleColor = Colors.red,
      this.selectedPointCircleRadius = 20,
      this.selectedPointCircleStrokeWidth = 1,
      this.selectedPointCircleColor = Colors.red,
      this.lineStrokeWidth = 5,
      this.lineColor = Colors.red,
      this.backgroundColor,
      required this.keyEnteredCallback,
      this.pointSelectedCallback,
      Key? key})
      : super(key: key);

  ValueNotifier<Offset> pointLineOffsetNotifier = ValueNotifier<Offset>(Offset(0.0, 0.0));
  ValueNotifier<int> pointSelectedNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final minSize = min<double>(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    final canvasSize = Size(minSize, minSize);
    final points = _generatePoints(canvasSize);

    final pointsPainter = PointsPainter(
      points: points,
      pointColor: pointColor,
      pointStrokeWidth: pointStrokeWidth,
      selectedPointColor: selectedPointColor,
      selectedPointStrokeWidth: selectedPointStrokeWidth,
      pointCircleRadius: pointCircleRadius,
      pointCircleStrokeWidth: pointCircleStrokeWidth,
      pointCircleColor: pointCircleColor,
      selectedPointCircleRadius: selectedPointCircleRadius,
      selectedPointCircleStrokeWidth: selectedPointCircleStrokeWidth,
      selectedPointCircleColor: selectedPointCircleColor,
      repaint: pointSelectedNotifier,
    );

    final pointsCanvas = CustomPaint(
      painter: pointsPainter,
      size: canvasSize,
    );

    final pointsLine = PointsLine(
      allPoints: points,
      focusRadius: pointCircleRadius,
    );

    if (pointSelectedCallback != null) {
      pointsLine.selectedPointCallbacks.add(pointSelectedCallback!);
    }

    final pointsLinePainter = LinePainter(
      pointsLine: pointsLine,
      lineStrokeWidth: lineStrokeWidth,
      lineColor: lineColor,
      repaint: pointLineOffsetNotifier,
    );
    final pointsLineCanvas = CustomPaint(
      painter: pointsLinePainter,
    );

    final pointsContainer = Container(
      width: minSize,
      height: minSize,
      decoration: BoxDecoration(color: backgroundColor),
      child: pointsCanvas,
    );
    final gestureDetector = GestureDetector(
      onPanStart: (DragStartDetails details) {
        pointsLine.resetSelection();
        pointsLine.processCurrentOffset(details.localPosition);
        pointLineOffsetNotifier.value = details.localPosition;
      },
      onPanUpdate: (DragUpdateDetails details) {
        pointsLine.processCurrentOffset(details.localPosition);
        pointLineOffsetNotifier.value = details.localPosition;
      },
      onPanCancel: () {
        pointsLine.finish();
        pointLineOffsetNotifier.value = const Offset(0.0, 0.0);
        keyEnteredCallback(pointsLine.selectedPointsNums);
      },
      onPanEnd: (DragEndDetails details) {
        pointLineOffsetNotifier.value = const Offset(0.0, 0.0);
        keyEnteredCallback(pointsLine.selectedPointsNums);
        pointsLine.finish();
      },
      child: Container(
        width: minSize,
        height: minSize,
        child: pointsLineCanvas,
      ),
    );

    return Column(
      children: [
        Stack(
          children: [
            pointsContainer,
            gestureDetector,
          ],
        ),
      ],
    );
  }

  List<Point> _generatePoints(Size size) {
    var points = <Point>[];
    var interval = size.width / 4;
    int column = 1;
    for (var pointNum = 1; pointNum <= 9; pointNum++) {
      final line = (pointNum >= 7)
          ? 3
          : (pointNum >= 4)
              ? 2
              : 1;

      points.add(Point(
        num: pointNum,
        x: column * interval,
        y: line * interval,
      ));

      column = (column == 3) ? 1 : column + 1;
    }
    return points;
  }
}
