import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import './src/points_painter.dart';
import './src/line_painter.dart';
import './src/points_line.dart';
import './src/typedef.dart';


class GraphicKey extends StatefulWidget {
  final Color pointColor;
  final double pointStrokeWidth;
  final double pointCircleRadius;
  final double pointCircleStrokeWidth;
  final Color pointCircleColor;
  final double lineStrokeWidth;
  final Color lineColor;
  final Color? backgroundColor;

  final KeyEnteredCallback keyEnteredCallback;
  final PointSelectedCallback? pointSelectedCallback;

  GraphicKey(
      {this.pointColor = Colors.red,
        this.pointStrokeWidth = 10,
        this.pointCircleRadius = 20,
        this.pointCircleStrokeWidth = 1,
        this.pointCircleColor = Colors.red,
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
  // TODO: try moving these properties to constructor
  bool isInitialized = false;
  late double _minSize;
  late CustomPaint _pointsPaint;
  late PointsPainter _pointsPainter;
  late PointsLine _pointsLine;

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      //TODO: investigate how to work with parent container size
      _minSize = min<double>(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
      final canvasSize = Size(_minSize, _minSize);
      _pointsPainter = PointsPainter(
        canvasSize,
        widget.pointColor,
        widget.pointStrokeWidth,
        widget.pointCircleRadius,
        widget.pointCircleStrokeWidth,
        widget.pointCircleColor,
      );
      _pointsPaint = CustomPaint(
        painter: _pointsPainter,
        size: canvasSize,
      );
      _pointsLine = PointsLine(
        _pointsPainter.points,
        widget.lineStrokeWidth,
        widget.lineColor,
        widget.pointSelectedCallback,
      );
      isInitialized = true;
    }

    return Stack(
      children: [
        Container(
          width: _minSize,
          height: _minSize,
          decoration: BoxDecoration(color: widget.backgroundColor),
          child: _pointsPaint,
        ),
        GestureDetector(
          onPanStart: (DragStartDetails details) {
            //print("onPanStart: ${details.localPosition.dx}:${details.localPosition.dy}");
            setState(() {
              _pointsLine = PointsLine(
                _pointsPainter.points,
                widget.lineStrokeWidth,
                widget.lineColor,
                widget.pointSelectedCallback,
              );
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
            child: CustomPaint(
              painter: LinePainter(
                pointsLine: _pointsLine,
                lineStrokeWidth: widget.lineStrokeWidth,
                lineColor: widget.lineColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
