import 'dart:ui';
import 'dart:math';
import 'dart:core';

import 'package:flutter/material.dart';

import './typedef.dart';
import './point.dart';

class PointsLine {
  List<Point> _allPoints;
  List<Point> selectedPoints = [];
  Offset? temporaryLineEnd;
  final double lineStrokeWidth;
  final Color lineColor;

  final PointSelectedCallback? pointSelectedCallback;

  PointsLine(
      this._allPoints,
      this.lineStrokeWidth,
      this.lineColor,
      this.pointSelectedCallback,
      );

  List<int> get selectedPointsNums {
    List<int> selectedPointsNums = [];
    selectedPoints.forEach((Point point) {
      selectedPointsNums.add(point.num);
    });
    return selectedPointsNums;
  }

  void processCurrentOffset(Offset offset) {
    final nearestPoint = getNearestPoint(offset);
    if (nearestPoint != null) {
      // if this nearest point is not added as last
      addPointToCurrentLine(nearestPoint);
      if(pointSelectedCallback != null) {
        pointSelectedCallback!(nearestPoint.num);
      }
      temporaryLineEnd = null;
    } else {
      temporaryLineEnd = offset;
    }
  }

  Point? getNearestPoint(Offset offset) {
    for (Point point in _allPoints) {
      // Source: https://coderoad.ru/481144/%D0%A3%D1%80%D0%B0%D0%B2%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D0%B4%D0%BB%D1%8F-%D0%BF%D1%80%D0%BE%D0%B2%D0%B5%D1%80%D0%BA%D0%B8-%D1%82%D0%BE%D0%B3%D0%BE-%D0%BD%D0%B0%D1%85%D0%BE%D0%B4%D0%B8%D1%82%D1%81%D1%8F-%D0%BB%D0%B8-%D1%82%D0%BE%D1%87%D0%BA%D0%B0-%D0%B2%D0%BD%D1%83%D1%82%D1%80%D0%B8-%D0%BE%D0%BA%D1%80%D1%83%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8
      var dx = (offset.dx - point.offset.dx).abs();

      var dy = (offset.dy - point.offset.dy).abs();

      if (dx + dy <= point.focusRadius) {
        return point;
      }
      if (dx > point.focusRadius || dy > point.focusRadius) {
        continue;
      }
      if (pow(dx, 2) + pow(dy, 2) <= pow(point.focusRadius, 2)) {
        return point;
      }

      if ((pow(offset.dx - point.offset.dx, 2) + (offset.dy - point.offset.dy)) < pow(point.focusRadius, 2)) {
        return point;
      }

      /*if (offset.dx >= point.focusableArea.left &&
          offset.dy >= point.focusableArea.top &&
          offset.dx < point.focusableArea.right &&
          offset.dy < point.focusableArea.bottom) {

        return point;
      }*/
    }
    return null;
  }

  void addPointToCurrentLine(Point point) {
    if (selectedPoints.isEmpty || selectedPoints.last.num != point.num) {
      selectedPoints.add(point);
    }
  }

  void finish() {
    if (selectedPoints.isNotEmpty) {
      temporaryLineEnd = selectedPoints.last.offset;
    }
  }
}
