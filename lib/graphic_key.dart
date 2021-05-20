import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:graphic_key/src/point.dart';

import './src/points_painter.dart';
import './src/line_painter.dart';
import './src/points_line.dart';
import './src/typedef.dart';

class GraphicKey extends StatefulWidget {
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

  @override
  _GraphicKeyState createState() => _GraphicKeyState();
}

class _GraphicKeyState extends State<GraphicKey> {
  bool isInitialized = false;
  late final double _minSize;

  late final List<Point> _points;
  late final PointsPainter _pointsPainter;
  late final CustomPaint _pointsCanvas;


  late final PointsLine _pointsLine;
  late final LinePainter _pointsLinePainter;
  late CustomPaint _pointsLineCanvas;

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      _minSize = min<double>(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
      final canvasSize = Size(_minSize, _minSize);
      _points = generatePoints(canvasSize);

      _pointsPainter = PointsPainter(
        points: _points,
        pointColor: widget.pointColor,
        pointStrokeWidth: widget.pointStrokeWidth,
        selectedPointColor: widget.selectedPointColor,
        selectedPointStrokeWidth: widget.selectedPointStrokeWidth,
        pointCircleRadius: widget.pointCircleRadius,
        pointCircleStrokeWidth: widget.pointCircleStrokeWidth,
        pointCircleColor: widget.pointCircleColor,
        selectedPointCircleRadius: widget.selectedPointCircleRadius,
        selectedPointCircleStrokeWidth: widget.selectedPointCircleStrokeWidth,
        selectedPointCircleColor: widget.selectedPointCircleColor,
      );

      _pointsCanvas = CustomPaint(
        painter: _pointsPainter,
        size: canvasSize,
      );

      _pointsLine = PointsLine(
        allPoints: _points,
        focusRadius: widget.pointCircleRadius,
      );
      _pointsLinePainter = LinePainter(
        pointsLine: _pointsLine,
        lineStrokeWidth: widget.lineStrokeWidth,
        lineColor: widget.lineColor,
      );
      isInitialized = true;
    }
    _pointsLineCanvas = CustomPaint(
      painter: _pointsLinePainter,
    );

    return Stack(
      children: [
        Container(
          width: _minSize,
          height: _minSize,
          decoration: BoxDecoration(color: widget.backgroundColor),
          child: _pointsCanvas,
        ),
        GestureDetector(
          onPanStart: (DragStartDetails details) {
            //print("onPanStart: ${details.localPosition.dx}:${details.localPosition.dy}");
            setState(() {
              /*_pointsLine = PointsLine(
                _pointsPainter.points,
                widget.lineStrokeWidth,
                widget.lineColor,
                widget.pointSelectedCallback,
              );*/
              _pointsLine.resetSelection();
              _pointsLine.processCurrentOffset(details.localPosition);
            });
          },
          onPanUpdate: (DragUpdateDetails details) {
            //print("onPanUpdate: ${details.localPosition.dx}:${details.localPosition.dy}");
            setState(() {
              _pointsLine.processCurrentOffset(details.localPosition);
            });
          },
          /*onPanCancel: () {
            setState(() {
              _pointsLine.finish();
            });
            widget._keyEntered(_pointsLine);
          },*/
          onPanEnd: (DragEndDetails details) {
            setState(() {
              _pointsLine.finish();
            });
            widget.keyEnteredCallback(_pointsLine.selectedPointsNums);
          },
          child: Container(
            width: _minSize,
            height: _minSize,
            //decoration: BoxDecoration(color: Colors.blueGrey),
            child: _pointsLineCanvas,
          ),
        )
      ],
    );
  }

  List<Point> generatePoints(Size size) {
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
