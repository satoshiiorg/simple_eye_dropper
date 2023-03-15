import 'package:flutter/material.dart';

/// Point to the selected position.
///
/// You can create your own pointers by extending this class or
/// MagnifierPointer, etc.
abstract class Pointer extends CustomPainter {
  /// Offset from center.
  abstract final double centerOffset;

  /// Selected position.
  Offset position = Offset.zero;

  /// Whether or not otherPosition is included in the drawing range of this
  /// pointer. (This implementation assumes a rectangular pointer.)
  bool contains(Offset otherPosition) {
    return position.dx <= otherPosition.dx + centerOffset
        && position.dy <= otherPosition.dy + centerOffset
        && otherPosition.dx + centerOffset <= position.dx + centerOffset * 2
        && otherPosition.dy + centerOffset <= position.dy + centerOffset * 2;
  }
}
