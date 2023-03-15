import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../exception/image_initialization_exception.dart';
import '../pointer/magnifier_pointer.dart';
import '../pointer/pointer.dart';
import 'image_painter.dart';

/// Abstract eye dropper widget.
abstract class EyeDropper extends StatelessWidget {
  const EyeDropper._({super.key});

  /// The factory constructor.
  ///
  /// If bytes is null, an empty area matching the size is displayed.
  factory EyeDropper.of({
    Key? key,
    required Uint8List? bytes,
    required Size size,
    Pointer Function(ui.Image, double ratio) pointerBuilder =
        MagnifierPointer.new,
    required ValueChanged<Color> onSelected,
  }) {
    if(bytes == null) {
      return _EmptyEyeDropper(key: key, size: size);
    }
    return _EyeDropper(
      key: key, bytes: bytes, size: size, pointerBuilder: pointerBuilder,
      onSelected: onSelected,
    );
  }
}

/// Empty widget to display if image is not specified.
class _EmptyEyeDropper extends EyeDropper {
  const _EmptyEyeDropper({super.key, required this.size}): super._();
  /// Size of image area.
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: size.width,
        height: size.height,
    );
  }
}

/// Eye dropper widget.
class _EyeDropper extends EyeDropper {
  _EyeDropper(
      {super.key,
      required this.bytes,
      required this.size,
      required this.pointerBuilder,
      required this.onSelected,
      }) : super._();

  /// Undefined offset.
  static const nullOffset = Offset(-1, -1);
  /// Encoded Uint8List of the image.
  final Uint8List bytes;
  /// Size of image area.
  final Size size;
  /// Image reduction ratio.
  late final double _ratio;
  /// Builder of a pointer.
  late final Pointer Function(ui.Image, double ratio) pointerBuilder;
  /// Pointer instance.
  late final Pointer _pointer;
  /// ui.Image of the image.
  late final ui.Image _uiImage;
  /// ByteData in RawStraightRgba format of the image.
  late final ByteData _bytesRgba;
  /// Callback on color selection.
  final ValueChanged<Color> onSelected;
  /// Previous tap/drag position.
  final ValueNotifier<Offset> _oldPosition = ValueNotifier(nullOffset);

  /// Initialization.
  ///
  /// Initialize ui.Image, convert to ByteData, and calculate reduction ratio.
  /// Future<void> does not work well with FutureBuilder, so Future<bool> is
  /// used.
  Future<bool> _init() async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    _uiImage = frameInfo.image;

    _bytesRgba = (await _uiImage.toByteData(
        format: ui.ImageByteFormat.rawStraightRgba,
    ))!;

    // Calculate ratio.
    final widthRatio = size.width < _uiImage.width ?
                      (size.width / _uiImage.width) : 1.0;
    final heightRatio = size.height < _uiImage.height ?
                      (size.height / _uiImage.height) : 1.0;
    _ratio = min(widthRatio, heightRatio);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: size.width,
      height: size.height,
      child: FutureBuilder<bool>(
        future: _init(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done
              && snapshot.hasData) {
            return _mainArea();
          } else if (snapshot.hasError) {
            throw ImageInitializationException('${snapshot.error!}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  /// Eye dropper body.
  Widget _mainArea() {
    _pointer = pointerBuilder(_uiImage, _ratio);
    return Stack(
      children: [
        // Display image and set behavior on tap.
        // If you tap outside the pointer, move the pointer to that position.
        // If you tap inside the pointer, drag the pointer to move it.
        GestureDetector(
          onPanStart: (details) {
            final localPosition = details.localPosition;
            // Set tap position.
            _oldPosition.value = localPosition;
            // Tapping outside the pointer frame moves the pointer there.
            if(!_pointer.contains(localPosition)) {
              _selectColor(localPosition);
              // Move to tap position.
              _pointer.position = localPosition;
            }
          },
          onPanUpdate: (details) {
            // Move the pointer by the distance moved from the last tap/drag
            // position.
            final localPosition = details.localPosition;
            final distance = localPosition - _oldPosition.value;
            _pointer.position = _pointer.position + distance;
            _selectColor(_pointer.position);
            _oldPosition.value = localPosition;
          },
          // Use ui.Image to avoid animation.
          // child: Image.memory(_bytes),
          child: CustomPaint(
            painter: ImagePainter(_uiImage, size, _ratio),
            size: Size(_uiImage.width * _ratio, _uiImage.height * _ratio),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _oldPosition,
          builder: (_, oldPosition, __) {
            if(oldPosition == nullOffset) {
              return const SizedBox.shrink();
            }
            // Move the pointer.
            return Positioned(
              left: _pointer.position.dx,
              top: _pointer.position.dy,
              child: CustomPaint(
                painter: _pointer,
              ),
            );
          },
        ),
      ],
    );
  }

  /// Call onSelected with the color of the specified position as an argument.
  void _selectColor(Offset position) {
    // Converts the specified position to the corresponding position in the
    // image.
    final dx = position.dx ~/ _ratio;
    final dy = position.dy ~/ _ratio;

    // Avoid RangeError.
    final position1d = (dy * _uiImage.width + dx) * 4;
    final length = _bytesRgba.lengthInBytes;
    if(position1d < 0 || length < position1d) {
      return;
    }

    // Cut out each channel from Uint32.
    final rgba = _bytesRgba.getUint32(position1d);
    final r = rgba >> 24;
    final g = rgba >> 16 & 0xFF;
    final b = rgba >> 8 & 0xFF;
    final a = rgba & 0xFF;
    final color = Color.fromARGB(a, r, g, b);

    // Pass the selected color and call the callback.
    onSelected(color);
  }
}
