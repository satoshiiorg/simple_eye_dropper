/// Exception during image initialization.
class ImageInitializationException implements Exception {
  /// Create an ImageInitializationException by specifying a [message].
  ImageInitializationException(this.message);

  /// An error message.
  final String message;
}
