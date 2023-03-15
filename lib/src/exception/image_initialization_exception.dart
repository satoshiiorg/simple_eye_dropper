/// Exception during image initialization.
class ImageInitializationException implements Exception {
  ImageInitializationException(this.message);
  final String message;
}
