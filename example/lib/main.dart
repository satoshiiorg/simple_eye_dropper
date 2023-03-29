import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_eye_dropper/simple_eye_dropper.dart';

/// Example of Simple Eye Dropper widget.
///
/// When used on iOS, the following settings are required in info.plist:
/// <key>NSPhotoLibraryUsageDescription</key>
/// <string>This app requires access to the photo library.</string>
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Ratio of image display area to the entire screen.
  static const imageAreaWidthRatio = 0.95;
  static const imageAreaHeightRatio = 0.65;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eye Dropper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) {
          // Size of the image.
          final screenSize = MediaQuery.of(context).size;
          final imageAreaSize = Size(
            screenSize.width * imageAreaWidthRatio,
            screenSize.height * imageAreaHeightRatio,
          );
          return MyHomePage(title: 'Eye Dropper', imageAreaSize: imageAreaSize);
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title, required this.imageAreaSize});

  final String title;
  final Size imageAreaSize;
  final ValueNotifier<Uint8List?> _bytes = ValueNotifier(null);
  final ValueNotifier<Color> _color = ValueNotifier(Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Part of the extracted color to be used.
            ValueListenableBuilder(
              valueListenable: _color,
              builder: (_, color, __) {
                return Column(
                  children: [
                    // Sample of the selected color.
                    CustomPaint(
                      size: const Size(50, 50),
                      painter: PickedPainter(color),
                    ),
                    // Hex triplet of the selected color.
                    Text(color.hexTriplet()),
                  ],
                );
              },
            ),
            // Part of extracting color from the image.
            ValueListenableBuilder(
              valueListenable: _bytes,
              builder: (_, bytes, __) {
                // Eye dropper instantiation.
                return EyeDropper.of(
                  bytes: bytes, // Raw image bytes.
                  size: imageAreaSize,
                  // Callback when color is selected.
                  onSelected: (color) => _color.value = color,
                );
              },
            ),
            ImagePickerButton(
              onSelected: (bytes) => _bytes.value = bytes,
            ),
          ],
        ),
      ),
    );
  }
}

/// A button to select an image from the camera roll.
class ImagePickerButton extends StatelessWidget {
  const ImagePickerButton({super.key, required this.onSelected});

  /// Callback when an image is selected.
  final ValueChanged<Uint8List> onSelected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: selectImage,
      child: const Text('Select Image'),
    );
  }

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    final bytes = await image.readAsBytes();
    onSelected(bytes);
  }
}

/// Display the specified color.
@immutable
class PickedPainter extends CustomPainter {
  const PickedPainter(this.color);

  static const double rectSize = 50;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    const rect = Rect.fromLTWH(0, 0, rectSize, rectSize);
    paint
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// Show hex triplet like #FFFFFF.
extension HexTriplet on Color {
  String hexTriplet() {
    return '#${value.toRadixString(16).padLeft(8, '0').substring(2, 8).toUpperCase()}';
  }
}
