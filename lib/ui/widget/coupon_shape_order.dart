import 'dart:math';

import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CouponShapeBorder extends ShapeBorder {
  final double circleRadius;
  final bool dash;
  final Color color;
  final Color strokeColor;
  final Color dashColor;
  final double circleBottom;
  final BorderSide borderSide;

  CouponShapeBorder({
    this.circleRadius = 15,
    this.borderSide = BorderSide.none,
    this.circleBottom = 40,
    this.dash = true,
    this.color = Colour.f0F8FFB,
    this.dashColor = Colour.FFDDDDDD,
    this.strokeColor = Colour.c0xFFF7F8FD,
  });

  @override
  EdgeInsetsGeometry get dimensions => new EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    var path = Path();
    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(18)));

    _formHoleLeft(path, rect);
    _formHoldRight(path, rect);
    path.fillType = PathFillType.evenOdd;

    return path;
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    return super.lerpFrom(a, t);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    var path = Path();
    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(8)));

    _formHoleLeft(path, rect);
    _formHoldRight(path, rect);
    path.fillType = PathFillType.evenOdd;

    return path;
  }

  void _formHoleLeft(Path path, Rect rect) {
    var h = rect.height;
    var left = -circleRadius / 2;
    var top = h - circleBottom - circleRadius;
    var right = left + circleRadius;
    var bottom = top + circleRadius;
    path.addArc(Rect.fromLTRB(left, top, right, bottom), -pi / 2, pi);
  }

  void _formHoldRight(Path path, Rect rect) {
    var w = rect.width;
    var h = rect.height;
    var left = -circleRadius / 2 + w;
    var top = h - circleBottom - circleRadius;
    var right = left + circleRadius;
    var bottom = top + circleRadius;
    path.addArc(Rect.fromLTRB(left, top, right, bottom), pi / 2, pi);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    var paint = Paint()
      ..color = dashColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    // var d = rect.height / 10;
    if (dash) {
      _drawDashLine(
          canvas,
          Offset(circleRadius, rect.height - circleBottom - circleRadius / 2),
          (rect.width - circleRadius * 2) / 10,
          rect.width - circleRadius * 2,
          paint);
    } else {
      canvas.drawLine(
          Offset(circleRadius, rect.height - circleBottom - circleRadius / 2),
          Offset(rect.width - circleRadius,
              rect.height - circleBottom - circleRadius / 2),
          paint);
    }
    Paint paint2 = new Paint()
      ..color = color
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(getOuterPath(rect), paint2);
    paint2.color = strokeColor;
    paint2.strokeWidth = 1.5;
    canvas.drawLine(Offset(0, rect.height - circleBottom - circleRadius),
        Offset(0, rect.height - circleBottom), paint2);
    canvas.drawLine(
        Offset(rect.width, rect.height - circleBottom - circleRadius),
        Offset(rect.width, rect.height - circleBottom),
        paint2);
  }

  _drawDashLine(
      Canvas canvas, Offset start, double count, double length, Paint paint) {
    var step = length / count / 2;
    for (int i = 0; i < count; i++) {
      var offset = start + Offset(2 * step * i, 0);
      canvas.drawLine(offset, offset + Offset(step, 0), paint);
    }
  }

  @override
  ShapeBorder scale(double t) {
    throw UnimplementedError();
  }
}
