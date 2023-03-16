import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Display the image in the specified size.
class ImagePainter extends CustomPainter {
  ImagePainter(this.uiImage, this.size, this.ratio);

  /// ui.Image
  final ui.Image uiImage;

  /// Size of the image.
  final Size size;

  /// Image reduction ratio.
  final double ratio;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final source = Rect.fromLTWH(0, 0, size.width / ratio, size.height / ratio);
    final dest = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(
      uiImage,
      source,
      dest,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
