import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'pointer.dart';

/// Magnifying pointer.
class MagnifierPointer extends Pointer {
  MagnifierPointer(
    this.uiImage,
    this.ratio, {
    this.magnification = 2,
    this.outerRectSize = 91,
    this.outerStrokeWidth = 2,
    this.innerRectSize = 11,
    this.innerStrokeWidth = 2,
  });

  /// Image of dart:ui.
  final ui.Image uiImage;

  /// Image reduction ratio.
  final double ratio;

  /// Magnification.
  final double magnification;

  /// Size of the outer rect.
  final double outerRectSize;

  /// Stroke width of the outer rect.
  final double outerStrokeWidth;

  /// Size of the inner rect.
  final double innerRectSize;

  /// Stroke width of the inner rect.
  final double innerStrokeWidth;

  /// Offset from center.
  @override
  double get centerOffset => outerRectSize / 2;

  /// Enlarged image with double squares.
  @override
  Future<void> paint(Canvas canvas, Size size) async {
    final paint = Paint();

    final largeRect = Rect.fromLTWH(
      -centerOffset,
      -centerOffset,
      outerRectSize,
      outerRectSize,
    );

    // Fill background with white for transparent images.
    paint
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;
    canvas.drawRect(largeRect, paint);

    // Enlarge image.
    final sourceRect = Rect.fromLTWH(
      (position.dx - (centerOffset / magnification)) / ratio,
      (position.dy - (centerOffset / magnification)) / ratio,
      outerRectSize / magnification / ratio,
      outerRectSize / magnification / ratio,
    );
    canvas.drawImageRect(
      uiImage,
      sourceRect,
      largeRect,
      paint,
    );

    paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerStrokeWidth;
    canvas.drawRect(largeRect, paint);

    final smallRect = Rect.fromLTWH(
      -(innerRectSize / 2),
      -(innerRectSize / 2),
      innerRectSize,
      innerRectSize,
    );
    paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = innerStrokeWidth;
    canvas.drawRect(smallRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
