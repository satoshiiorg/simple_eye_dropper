# Simple Eye Dropper

A simple eye dropper widget that depends only on standard libraries.

🌏
[**English**](https://github.com/satoshiiorg/simple_eye_dropper/blob/master/README.md) |
[**日本語**](https://github.com/satoshiiorg/simple_eye_dropper/blob/master/README.ja.md)

<img src="https://user-images.githubusercontent.com/36852007/225324832-6ca002f4-5bee-4bb9-b9d6-47702a12df7d.png" alt="" width="40%" height="40%" >  

## Table of Contents
- [Use with asset images](#Use-with-asset-images)
- [Pointer](#pointer)
    - [Choose a Pointer implementation](#Choose-a-Pointer-implementation)
    - [Implement Pointer](#Implement-Pointer)
- [Image related](#Image-related)
    - [Supported image formats and exception handling](#Supported-image-formats-and-exception-handling)
    - [Use with image_picker](#Use-with-image_picker)
    - [Use with network images](#Use-with-network-images)
    - [Use with Dart Image Library](#Use-with-Dart-Image-Library)
- [Use with Riverpod](#Use-with-Riverpod)

## Use with asset images

Build the `EyeDropper` widget as follows:

```dart
final byteData = await rootBundle.load('asset/example.png');

(snip)
      
EyeDropper.of(
  // Encoded Uint8List.
  bytes: byteData.buffer.asUint8List(),
  // Size to display.
  size: const Size(200, 400),
  // Callback called when color is selected.
  onSelected: (color) => print('Selected color is $color'),
);
```

- `bytes` argument is a Uint8List of image bytes obtained by image_picker etc.
If `bytes` argument is null, a blank area is displayed.
- `onSelected` specifies a callback to be called when the color is selected.

[//]: # (TODO 空白の領域を表示するのはやめた方がよい？ image連携などでも微妙)

## Pointer

### Choose a Pointer implementation

By default, the following pointers with magnification are specified.

```dart
EyeDropper.of(
  bytes: bytes,
  size: const Size(200, 400),
  // By default.
  pointerBuilder: MagnifierPointer.new,
  onSelected: (color) => print('Selected color is $color'),
);
```

<img src="https://user-images.githubusercontent.com/36852007/225324832-6ca002f4-5bee-4bb9-b9d6-47702a12df7d.png" alt="" width="40%" height="40%" >  

You can also specify a simple pointer as follows

```dart
EyeDropper.of(
  bytes: bytes,
  size: const Size(200, 400),
  // Simple small square pointer without magnification.
  pointerBuilder: (_, __) => SimplePointer(),
  onSelected: (color) => print('Selected color is $color'),
);
```

<img src="https://user-images.githubusercontent.com/36852007/225325274-0a21a598-e94c-4aba-862c-936f48c9b4b3.png" alt="" width="40%" height="40%" >  

Both pointers have several parameters providing for some customization.

```dart
EyeDropper.of(
  bytes: bytes,
  size: const Size(200, 400),
  // Customize the pointer with magnification.
  pointerBuilder: (uiImage, ratio) => MagnifierPointer(
    uiImage,
    ratio,
    magnification: 2.5,
    outerRectSize: 101,
    outerStrokeWidth: 3,
    innerRectSize: 9,
    innerStrokeWidth: 3,
  ),
  onSelected: (color) => print('Selected color is $color'),
);
```

<img src="https://user-images.githubusercontent.com/36852007/225325531-63dc3de8-bfe4-4254-8c75-7e79fb6e2beb.png" alt="" width="40%" height="40%" >  

```dart
EyeDropper.of(
  bytes: bytes,
  size: const Size(200, 400),
  // Customize a simple small square pointer without magnification.
  pointerBuilder: (_, __) => SimplePointer(
    color: Colors.blue,
    rectSize: 9,
    strokeWidth: 3,
  ),
  onSelected: (color) => print('Selected color is $color'),
);
```

<img src="https://user-images.githubusercontent.com/36852007/225325656-175ece87-b5d9-43e2-a6d0-49e7315cf9ba.png" alt="" width="40%" height="40%" >  


### Implement Pointer

You can also create your own pointers by inheriting from `Pointer` or `MagnifierPointer` classes.  
Refer to the code of the `MagnifierPointer` class for how to implement `Pointer`.  
  

## Image related

### Supported image formats and exception handling

It follows
[instantiateImageCodec](https://api.flutter.dev/flutter/dart-ui/instantiateImageCodec.html)
function of dart:ui.  
At least the following image formats are supported: JPEG, PNG, GIF, Animated GIF, WebP,
Animated WebP, BMP, and WBMP.  
  
Passing an unsupported image format Uint8List to `bytes` will throw an `ImageInitializationException`.  
If you pass `null` for `bytes`, a blank area will be displayed.  

### Use with image_picker

```dart
final picker = ImagePicker();
final image = await picker.pickImage(source: ImageSource.gallery);
if(image == null) {
  return;
}
final bytes = await image.readAsBytes();

(snip)
    
EyeDropper.of(
  bytes: bytes,
  size: const Size(200, 400),
  onSelected: (color) => print('Selected color is $color'),
);
```

In practice, you will probably use `FutureBuilder` for async/await support.  
See example/lib/main.dart and example/lib/image_picker_button.dart for detailed coding examples.

[//]: # (TODO リンク)

### Use with network images

For example, if you use the [http](https://pub.dev/packages/http) package, you can do the following:

```dart
import 'package:http/http.dart' as http;

(snip)

final response = await http.get(Uri.parse('https://example.org/sample.jpg'));

(snip)

EyeDropper.of(
  bytes: response.bodyBytes,
  size: const Size(200, 400),
  onSelected: (color) => print('Selected color is $color'),
);
```

Just pass the response body as is to `bytes`.

### Use with Dart Image Library

If you want to pass an image processed with [image](https://pub.dev/packages/image)
(Dart Image Library) to EyeDropper, pass a Uint8List that has been re-encoded with `img.encodeXXX`
as shown below.

```dart
import 'package:image/image.dart' as img;

(snip)

final imgImage = img.decodeImage(bytes);
final grayImage = img.grayscale(imgImage!);
grayBytes = img.encodeJpg(grayImage);

(snip)

EyeDropper.of(
  bytes: grayBytes,
  size: const Size(200, 400),
  onSelected: (color) => print('Selected color is $color'),
);
```

## Use with Riverpod

When EyeDropper is used with ConsumerWidget or ConsumerStatefulWidget of
[Riverpod](https://riverpod.dev/),
the pointer may not be displayed because it is redrawn in its entirety.

```dart
// BAD example.
import 'package:flutter_riverpod/flutter_riverpod.dart';

final colorProvider = StateProvider<Color>((ref) => Colors.white);

(snip)

class MyHomePage extends ConsumerWidget {

(snip)

  // Display color code.
  Text(ref.watch(colorProvider).toString()),

(snip)

  EyeDropper.of(
    bytes: grayBytes,
    size: const Size(200, 400),
    onSelected: (color) => ref.read(colorProvider.notifier).state = color,
  );

}
```

In such cases, instead of using ConsumerWidget or ConsumerStatefulWidget's `ref` as is, use
[Consumer](https://pub.dev/documentation/flutter_riverpod/latest/flutter_riverpod/Consumer-class.html)
to specify the redraw range.

```dart
// GOOD example.
import 'package:flutter_riverpod/flutter_riverpod.dart';

final colorProvider = StateProvider<Color>((ref) => Colors.white);

class MyHomePage extends StatelessWidget {

(snip)

  // Display color code.
  Consumer(
    builder: (_, ref, __) {
      return Text(ref.watch(colorProvider).toString());
    },
  ),

(snip)

  Consumer(
    builder: (_, ref, __) {
      return EyeDropper.of(
        bytes: grayBytes,
        size: const Size(200, 400),
        onSelected: (color) => ref.read(colorProvider.notifier).state = color,
      );
    },
  ),

}
```
