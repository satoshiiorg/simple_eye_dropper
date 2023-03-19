// import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_eye_dropper/simple_eye_dropper.dart';

void main() {
  testWidgets('Pointer.contains test', (WidgetTester tester) async {
    // Color? actualColor;
    await tester.runAsync(() async {
      final byteData = await rootBundle.load('test/test.png');
      final pointer = SimplePointer(
          // rectSize: 11,
          );
      // var aRatio = 0.0;
      // ui.Image? aImage;
      final eyeDropper = EyeDropper.of(
        bytes: byteData.buffer.asUint8List(),
        size: const Size(729, 834),
        pointerBuilder: (uiImage, ratio) {
          // aRatio = ratio;
          // aImage = uiImage;
          return pointer;
        },
        onSelected: (color) {
          // actualColor = color;
        },
      );
      await tester.pumpWidget(MaterialApp(home: eyeDropper));

      // Initial display is CircularProgressIndicator.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Wait for FutureBuilder.
      await Future<void>.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      // Pointer and ImagePainter.
      expect(find.byType(CustomPaint), findsNWidgets(2));

      await tester.tapAt(const Offset(400, 300)); // center
      await tester.pump();
      expect(pointer.contains(const Offset(95, 95)), true);
      expect(pointer.contains(const Offset(95, 105)), true);
      expect(pointer.contains(const Offset(105, 95)), true);
      expect(pointer.contains(const Offset(105, 105)), true);
      expect(pointer.contains(const Offset(94, 95)), false);
      expect(pointer.contains(const Offset(94, 105)), false);
      expect(pointer.contains(const Offset(95, 94)), false);
      expect(pointer.contains(const Offset(95, 106)), false);
      expect(pointer.contains(const Offset(105, 94)), false);
      expect(pointer.contains(const Offset(105, 106)), false);
      expect(pointer.contains(const Offset(106, 95)), false);
      expect(pointer.contains(const Offset(106, 105)), false);
    });
  });

  testWidgets(
      'CircularMagnifierPointer.contains test (squareDraggableArea=true)',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      final byteData = await rootBundle.load('test/test.png');
      late CircularMagnifierPointer pointer;
      final eyeDropper = EyeDropper.of(
        bytes: byteData.buffer.asUint8List(),
        size: const Size(729, 834),
        pointerBuilder: (uiImage, ratio) {
          pointer = CircularMagnifierPointer(uiImage, ratio);
          return pointer;
        },
        onSelected: (color) {
          // actualColor = color;
        },
      );
      await tester.pumpWidget(MaterialApp(home: eyeDropper));

      // Initial display is CircularProgressIndicator.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Wait for FutureBuilder.
      await Future<void>.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      // Pointer and ImagePainter.
      expect(find.byType(CustomPaint), findsNWidgets(2));

      await tester.tapAt(const Offset(400, 300)); // center
      await tester.pump();
      expect(pointer.contains(const Offset(60, 60)), true);
      expect(pointer.contains(const Offset(60, 140)), true);
      expect(pointer.contains(const Offset(140, 60)), true);
      expect(pointer.contains(const Offset(140, 140)), true);
      expect(pointer.contains(const Offset(39, 39)), false);
      expect(pointer.contains(const Offset(56, 56)), true);
      expect(pointer.contains(const Offset(56, 144)), true);
      expect(pointer.contains(const Offset(144, 56)), true);
      expect(pointer.contains(const Offset(144, 144)), true);
      expect(pointer.contains(const Offset(161, 161)), false);
    });
  });

  testWidgets(
      'CircularMagnifierPointer.contains test (squareDraggableArea=false)',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      final byteData = await rootBundle.load('test/test.png');
      late CircularMagnifierPointer pointer;
      final eyeDropper = EyeDropper.of(
        bytes: byteData.buffer.asUint8List(),
        size: const Size(729, 834),
        pointerBuilder: (uiImage, ratio) {
          pointer = CircularMagnifierPointer(
            uiImage,
            ratio,
            squareDraggableArea: false,
          );
          return pointer;
        },
        onSelected: (color) {
          // actualColor = color;
        },
      );
      await tester.pumpWidget(MaterialApp(home: eyeDropper));

      // Initial display is CircularProgressIndicator.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Wait for FutureBuilder.
      await Future<void>.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      // Pointer and ImagePainter.
      expect(find.byType(CustomPaint), findsNWidgets(2));

      await tester.tapAt(const Offset(400, 300)); // center
      await tester.pump();
      expect(pointer.contains(const Offset(60, 60)), true);
      expect(pointer.contains(const Offset(60, 140)), true);
      expect(pointer.contains(const Offset(140, 60)), true);
      expect(pointer.contains(const Offset(140, 140)), true);
      expect(pointer.contains(const Offset(50, 50)), false);
      expect(pointer.contains(const Offset(56, 56)), false);
      expect(pointer.contains(const Offset(56, 144)), false);
      expect(pointer.contains(const Offset(144, 56)), false);
      expect(pointer.contains(const Offset(144, 144)), false);
      expect(pointer.contains(const Offset(150, 150)), false);
    });
  });
}
