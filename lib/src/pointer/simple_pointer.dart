import 'package:flutter/material.dart';
import 'pointer.dart';

/// Simple pointer.
///
/// Simple rect frame without magnification.
class SimplePointer extends Pointer {
  SimplePointer({
    this.color = Colors.red,
    this.rectSize = 11,
    this.strokeWidth = 2,
  });

  /// Color of rect.
  final Color color;
  /// Size of rect.
  final double rectSize;
  /// Stroke width of rect.
  final double strokeWidth;
  /// Offset from center.
  @override
  double get centerOffset => rectSize / 2;

  /// Displays squares of specified color and size.
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final rect = Rect.fromLTWH(
        - centerOffset,
        - centerOffset,
        rectSize,
        rectSize,
    );
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
