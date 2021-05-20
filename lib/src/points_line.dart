import 'dart:ui';
import 'dart:math';
import 'dart:core';

import 'package:flutter/material.dart';

import './typedef.dart';
import './point.dart';

/// Contains selected points.
class PointsLine {
  List<Point> allPoints;
  List<Point> _selectedPoints = [];
  Offset? temporaryLineEnd;
  final double focusRadius;

  final PointSelectedCallback? pointSelectedCallback;

  PointsLine({
    required this.allPoints,
    required this.focusRadius,
    this.pointSelectedCallback,
  });

  List<int> get selectedPointsNums {
    List<int> selectedPointsNums = [];
    _selectedPoints.forEach((Point point) {
      selectedPointsNums.add(point.num);
    });
    return selectedPointsNums;
  }

  List<Point> get selectedPoints {
    return _selectedPoints;
  }

  void resetSelection() {
    _selectedPoints.clear();
  }

  /// Checks the position of pointer and adds to [_selectedPoints].
  void processCurrentOffset(Offset offset) {
    final nearestPoint = _getNearestPoint(offset);
    if (nearestPoint != null) {
      // if this nearest point is not added as last
      var isPointAdded = _addPointToCurrentLine(nearestPoint);
      if (pointSelectedCallback != null && isPointAdded) {
        pointSelectedCallback!(nearestPoint.num);
      }
      temporaryLineEnd = null;
    } else {
      temporaryLineEnd = offset;
    }
  }

  Point? _getNearestPoint(Offset offset) {
    for (Point point in allPoints) {
      // Source: https://coderoad.ru/481144/%D0%A3%D1%80%D0%B0%D0%B2%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D0%B4%D0%BB%D1%8F-%D0%BF%D1%80%D0%BE%D0%B2%D0%B5%D1%80%D0%BA%D0%B8-%D1%82%D0%BE%D0%B3%D0%BE-%D0%BD%D0%B0%D1%85%D0%BE%D0%B4%D0%B8%D1%82%D1%81%D1%8F-%D0%BB%D0%B8-%D1%82%D0%BE%D1%87%D0%BA%D0%B0-%D0%B2%D0%BD%D1%83%D1%82%D1%80%D0%B8-%D0%BE%D0%BA%D1%80%D1%83%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8
      var dx = (offset.dx - point.offset.dx).abs();
      var dy = (offset.dy - point.offset.dy).abs();

      if (dx + dy <= focusRadius) {
        return point;
      }

      if (dx > focusRadius || dy > focusRadius) {
        continue;
      }
      if (pow(dx, 2) + pow(dy, 2) <= pow(focusRadius, 2)) {
        return point;
      }

      if ((pow(offset.dx - point.offset.dx, 2) + (offset.dy - point.offset.dy)) < pow(focusRadius, 2)) {
        return point;
      }
    }
    return null;
  }

  bool _addPointToCurrentLine(Point point) {
    if (_selectedPoints.isEmpty || _selectedPoints.last.num != point.num) {
      _selectedPoints.add(point);
      return true;
    }
    return false;
  }

  void finish() {
    if (_selectedPoints.isNotEmpty) {
      temporaryLineEnd = _selectedPoints.last.offset;
    }
  }
}
