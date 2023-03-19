import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'pointer.dart';

/// Circular magnifying pointer.
class CircularMagnifierPointer extends Pointer {
  /// Create CircularMagnifierPointer with [uiImage] and [ratio].
  ///
  /// If [squareDraggableArea] is true, the circumscribed square of the circle
  /// is draggable. Otherwise, the area of the circle is draggable.
  CircularMagnifierPointer(
    this.uiImage,
    this.ratio, {
    this.magnification = 2,
    this.outerCircleRadius = 60,
    this.outerStrokeWidth = 2,
    this.innerCircleRadius = 5,
    this.innerStrokeWidth = 2,
    this.squareDraggableArea = true,
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

  /// If [squareDraggableArea] is true, the circumscribed square of the circle
  /// is draggable. Otherwise, the area of the circle is draggable.
  final bool squareDraggableArea;

  /// Offset from center.
  @override
  double get centerOffset => outerCircleRadius;

  /// Whether or not otherPosition is included in the drawing range of this
  /// pointer.
  ///
  /// If [squareDraggableArea] is true, the circumscribed square of the circle
  /// is draggable. Otherwise, the area of the circle is draggable.
  @override
  bool contains(Offset otherPosition) {
    if (squareDraggableArea) {
      return super.contains(otherPosition);
    }
    final distance = (otherPosition - position).distance;
    return distance <= outerCircleRadius + outerStrokeWidth;
  }

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
