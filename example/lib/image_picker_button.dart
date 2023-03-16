import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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
