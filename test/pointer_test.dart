// import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_eye_dropper/simple_eye_dropper.dart';

void main() {
  testWidgets('Pointer.contains test', (WidgetTester tester) async {
    // Color? actualColor;
    await tester.runAsync(() async {
      final byteData = await rootBundle.load('test/music_castanet_girl.png');
      final pointer = SimplePointer(
        rectSize: 21,
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

      await tester.tapAt(const Offset(400, 300));
      await tester.pump();
      // print('position=${pointer.position}'); // => Offset(364.5, 300.0)
      // print('${aImage!.width}x${aImage!.height}'); // => 729x843
      expect(pointer.contains(const Offset(400 - 35.5, 300)), true);
      expect(pointer.contains(const Offset(410 - 35.5, 310)), true);
      expect(pointer.contains(const Offset(410.5 - 35.5, 310.5)), true);
      expect(pointer.contains(const Offset(411 - 35.5, 311)), false);
    });
  });
}
