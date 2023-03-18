import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'pointer.dart';

/// Circular magnifying pointer.
class CircularMagnifierPointer extends Pointer {
  /// Create CircularMagnifierPointer with [uiImage] and [ratio].
  CircularMagnifierPointer(
    this.uiImage,
    this.ratio, {
    this.magnification = 2,
    this.outerCircleRadius = 50,
    this.outerStrokeWidth = 2,
    this.innerCircleRadius = 5,
    this.innerStrokeWidth = 2,
  });

  /// Image of dart:ui.
  final ui.Image uiImage;

  /// Image reduction ratio.
  final double ratio;

  /// Magnification.
  final double magnification;

  /// Size of the outer circle.
  final double outerCircleRadius;

  /// Stroke width of the outer circle.
  final double outerStrokeWidth;

  /// Size of the inner circle.
  final double innerCircleRadius;

  /// Stroke width of the inner circle.
  final double innerStrokeWidth;

  /// Offset from center.
  @override
  double get centerOffset => outerCircleRadius;

  /// Enlarged image with double squares.
  @override
  Future<void> paint(Canvas canvas, Size size) async {
    // Clip circle.
    final circleSizeRect = Rect.fromLTWH(
      -centerOffset - outerStrokeWidth / 2,
      -centerOffset - outerStrokeWidth / 2,
      outerCircleRadius * 2 + outerStrokeWidth,
      outerCircleRadius * 2 + outerStrokeWidth,
    );
    canvas.clipPath(Path()..addOval(circleSizeRect));

    // Fill background with white for transparent images.
    final paint = Paint();
    paint
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;
    canvas.drawCircle(Offset.zero, outerCircleRadius, paint);

    // Enlarge image.
    final largeRect = Rect.fromLTWH(
      -centerOffset,
      -centerOffset,
      outerCircleRadius * 2,
      outerCircleRadius * 2,
    );
    final sourceRect = Rect.fromLTWH(
      (position.dx - (centerOffset / magnification)) / ratio,
      (position.dy - (centerOffset / magnification)) / ratio,
      outerCircleRadius * 2 / magnification / ratio,
      outerCircleRadius * 2 / magnification / ratio,
    );
    canvas.drawImageRect(
      uiImage,
      sourceRect,
      largeRect,
      paint,
    );

    // Draw circles.
    paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerStrokeWidth;
    canvas.drawCircle(Offset.zero, outerCircleRadius, paint);
    paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = innerStrokeWidth;
    canvas.drawCircle(Offset.zero, innerCircleRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
