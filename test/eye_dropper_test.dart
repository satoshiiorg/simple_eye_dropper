import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_eye_dropper/simple_eye_dropper.dart';

void main() {
  testWidgets('EyeDropper smoke test', (WidgetTester tester) async {
    Color? actualColor;

    await tester.runAsync(() async {
      final byteData = await rootBundle.load('test/test.png');
      final eyeDropper = EyeDropper.of(
        bytes: byteData.buffer.asUint8List(),
        size: const Size(200, 200),
        pointerBuilder: (_, __) => SimplePointer(),
        onSelected: (color) => actualColor = color,
      );
      await tester.pumpWidget(MaterialApp(home: eyeDropper));

      // Initial display is CircularProgressIndicator.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Wait for FutureBuilder.
      await Future<void>.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      // Pointer and ImagePainter.
      expect(find.byType(CustomPaint), findsNWidgets(2));

      // Combination of offsets and colors.
      final map = {
        const Offset(400, 300): const Color(0xff6912a1), // center
        const Offset(300, 200): const Color(0xffff1e31), // top left
        const Offset(499, 200): const Color(0xff1b32ff), // top right
        const Offset(300, 399): const Color(0xff1028ff), // bottom left
        const Offset(499, 399): const Color(0xffff1025), // bottom right
        const Offset(400, 295): const Color(0xffffe500), // center top
        const Offset(400, 305): const Color(0xff000000), // center bottom
        const Offset(390, 300): const Color(0xffe400ff), // center left
        const Offset(410, 300): const Color(0xff1eff00), // center right
      };
      for (final offsetColor in map.entries) {
        await tester.tapAt(offsetColor.key);
        await tester.pump();
        expect(actualColor, offsetColor.value);
      }
    });
  });

  testWidgets('EyeDropper exception test', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final eyeDropper = EyeDropper.of(
        bytes: Uint8List(0),
        size: const Size(200, 200),
        pointerBuilder: (_, __) => SimplePointer(),
        onSelected: (color) {},
      );
      await tester.pumpWidget(MaterialApp(home: eyeDropper));

      // Initial display is CircularProgressIndicator.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Wait for FutureBuilder.
      await Future<void>.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      // An error icon.
      expect(find.byType(Icon), findsNWidgets(1));
    });
  });
}
