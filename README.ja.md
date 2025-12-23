# Simple Eye Dropper

Dart および Flutter の標準ライブラリ以外への依存のない、シンプルなスポイトツールウィジェットです。

🌏
[**English**](https://github.com/satoshiiorg/simple_eye_dropper/blob/master/README.md) |
[**日本語**](https://github.com/satoshiiorg/simple_eye_dropper/blob/master/README.ja.md)

<img src="https://user-images.githubusercontent.com/36852007/225324832-6ca002f4-5bee-4bb9-b9d6-47702a12df7d.png" alt="" width="40%" height="40%" >  

## 目次
- [インストール]()
- [基本的な使い方 (アセット画像との連携例)](#基本的な使い方-アセット画像との連携例)
- [ポインタ](#ポインタ)
  - [ポインタの選択](#ポインタの選択)
  - [ポインタの自作](#ポインタの自作)
- [画像処理関連](#画像処理関連)
  - [対応している画像形式と例外処理](#対応している画像形式と例外処理)
  - [image_picker との連携例](#image_picker-との連携例)
  - [ネットワーク画像との連携例](#ネットワーク画像との連携例)
  - [image パッケージ (Dart Image Library) との連携例](#image-パッケージ-Dart-Image-Library-との連携例)
- [Riverpod と併用する](#Riverpod-と併用する)

## Installing
参照: [simple_eye_dropper install | Flutter package](https://pub.dev/packages/simple_eye_dropper/install)  


コマンドラインから

```console
$ flutter pub add simple_eye_dropper
```

するか、pubspec.yaml に  

```yaml:pubspec.yaml
dependencies:
  simple_eye_dropper: ^0.2.2
```

を追加してから

```console
$ flutter pub get
```

すると、

```dart
import 'package:simple_eye_dropper/simple_eye_dropper.dart';
```

で使えるようになります。

## 基本的な使い方 (アセット画像との連携例)

以下のように `EyeDropper` ウィジェットを構築します。

```dart
final byteData = await rootBundle.load('asset/example.png');

(中略)

EyeDropper.of(
  // デコードされていない画像のUint8List
  bytes: byteData.buffer.asUint8List(),
  // 表示するサイズ
  size: const Size(200, 400),
  // 色が選択された際に呼ばれるコールバック
  onSelected: (color) => print('Selected color is $color'),
);
```

- `bytes` には image_picker などで取得した画像のバイト列を Uint8List 形式で指定します。
  null が渡された場合は空白の領域を表示します。
- `onSelected` には色が選択された際に呼ばれるコールバックを指定します。

## ポインタ

### ポインタの選択

デフォルトでは以下の拡大表示付きのポインタが指定されます。

```dart
EyeDropper.of(
  bytes: bytes,
  size: const Size(200, 400),
  // 拡大表示付きのポインタがデフォルト
  pointerBuilder: MagnifierPointer.new,
  onSelected: (color) => print('Selected color is $color'),
);
```

<img src="https://user-images.githubusercontent.com/36852007/225324832-6ca002f4-5bee-4bb9-b9d6-47702a12df7d.png" alt="" width="40%" height="40%" >  

以下のようなシンプルなポインタを指定することもできます。

```dart
EyeDropper.of(
  bytes: bytes,
  size: const Size(200, 400),
  // 拡大表示のないシンプルな小さな四角のポインタ
  pointerBuilder: (_, __) => SimplePointer(),
  onSelected: (color) => print('Selected color is $color'),
);
```

<img src="https://user-images.githubusercontent.com/36852007/225325274-0a21a598-e94c-4aba-862c-936f48c9b4b3.png" alt="" width="40%" height="40%" >  

以下は拡大表示付きの円形のポインタの例です。

```dart
EyeDropper.of(
  bytes: bytes,
  size: const Size(200, 400),
  // 拡大表示付きの円形のポインタ
  pointerBuilder: CircularMagnifierPointer.new,
  onSelected: (color) => print('Selected color is $color'),
);
```

<img src="https://user-images.githubusercontent.com/36852007/226092922-eb360ceb-dfca-40fd-a6e0-e1bb3c08a6f6.png" alt="" width="40%" height="40%" >  

どのポインタにもいくつかパラメタが用意されており、多少カスタマイズすることができます。

```dart
EyeDropper.of(
  bytes: bytes,
  size: const Size(200, 400),
  // 拡大表示付きのポインタをカスタマイズ
  pointerBuilder: (uiImage, ratio) => MagnifierPointer(
    uiImage,
    ratio,
    // 拡大倍率
    magnification: 2.5,
    // 拡大部分のサイズ
    outerRectSize: 101,
    // 囲みの太さ
    outerStrokeWidth: 3,
    // 中心表示のサイズ
    innerRectSize: 9,
    // 中心表示の囲みの太さ
    innerStrokeWidth: 3,
  ),
  onSelected: (color) => print('Selected color is $color'),
);
```

<img src="https://user-images.githubusercontent.com/36852007/225325531-63dc3de8-bfe4-4254-8c75-7e79fb6e2beb.png" alt="" width="40%" height="40%" >  


### ポインタの自作

`Pointer` クラスを継承することで、より自分好みのポインタを作成することもできます。  
実装の仕方は `CircleMagnifierPointer` クラスのコードなどを参考にしてください。

## 画像処理関連

### 対応している画像形式と例外処理

dart:ui
の [instantiateImageCodec](https://api.flutter.dev/flutter/dart-ui/instantiateImageCodec.html)
関数に準じています。  
少なくとも JPEG・PNG・GIF・アニメーションGIF・WebP・アニメーションWebP・BMP・WBMP に対応しているはずです。

`bytes` に対応していない画像形式の Uint8List を渡した場合は `errorBuilder` がコールされます。  
`errorBuilder` の使い方は
[Image.errorBuilder](https://api.flutter.dev/flutter/widgets/Image/errorBuilder.html) と同様です。  
デフォルトではグレーのエラーアイコンが表示されます。

`bytes` に `null` を渡した場合は空白の領域が表示されます。

### image_picker との連携例

```dart

final picker = ImagePicker();
final image = await
picker.pickImage(source: ImageSource.gallery);
if(image == null) {
  return;
}
final bytes = await image.readAsBytes();

(中略)

EyeDropper.of(
  bytes: bytes,
  size: const Size(200, 400),
  onSelected: (color) => print('Selected color is $color'),
);
```

実際には async/await への対応のため `FutureBuilder` などを使用することになるでしょう。  
詳細なコーディング例は
[example/lib/main.dart](https://github.com/satoshiiorg/simple_eye_dropper/blob/master/example/lib/main.dart)
を参照してください。


### ネットワーク画像との連携例

例えば [http](https://pub.dev/packages/http) パッケージを利用する場合、以下のようにできます。

```dart
import 'package:http/http.dart' as http;

(中略)

final response = await http.get(Uri.parse('https://example.org/sample.jpg'));

(中略)

EyeDropper.of(
  bytes: response.bodyBytes,
  size: const Size(200, 400),
  onSelected: (color) => print('Selected color is $color'),
);
```

基本的にはレスポンスボディをそのまま `bytes` に渡すだけです。

### image パッケージ (Dart Image Library) との連携例

[image](https://pub.dev/packages/image) パッケージ (Dart Image Library) で加工した画像を EyeDropper
に渡したいような場合は、以下のように `img.encodeXXX` で再度エンコードした Uint8List を渡してください。

```dart
import 'package:image/image.dart' as img;

(中略)

final imgImage = img.decodeImage(bytes);
final grayImage = img.grayscale(imgImage!);
grayBytes = img.encodeJpg(grayImage);

(中略)

EyeDropper.of(
  bytes: grayBytes,
  size: const Size(200, 400),
  onSelected: (color) => print('Selected color is $color'),
);
```

## Riverpod と併用する

EyeDropper を [Riverpod](https://riverpod.dev/) の ConsumerWidget や ConsumerStatefulWidget
などと併用すると、EyeDropper ごと再描画が行われてしまいポインタが表示されない場合があります。

```dart
// NG例
import 'package:flutter_riverpod/flutter_riverpod.dart';

final colorProvider = StateProvider<Color>((ref) => Colors.white);

class MyHomePage extends ConsumerWidget {

  (中略)

  // 選択された色のカラーコードを表示
  Text(ref.watch(colorProvider).toString()),

  (中略)

}
```

このような場合、ConsumerWidget や ConsumerStatefulWidget の build の引数として渡された `ref`
をそのまま使用する代わりに、
[Consumer](https://pub.dev/documentation/flutter_riverpod/latest/flutter_riverpod/Consumer-class.html)
を使用して再描画の範囲を指定してください。

```dart
// OK例
class MyHomePage extends ConsumerWidget {

  (中略)

  // 選択された色のカラーコードを表示
  Consumer(
    builder: (_, ref, __) {
      return Text(ref.watch(colorProvider).toString());
    },
  ),

  (中略)

}
```

