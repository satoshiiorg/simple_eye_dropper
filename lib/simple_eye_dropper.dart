/// A simple eye dropper widget that depends only on standard libraries.
library simple_eye_dropper;

export 'src/exception/image_initialization_exception.dart'
    show ImageInitializationException;
export 'src/pointer/pointer.dart' show Pointer;
export 'src/pointer/simple_pointer.dart' show SimplePointer;
export 'src/pointer/magnifier_pointer.dart' show MagnifierPointer;
export 'src/pointer/circle_magnifier_pointer.dart' show CircleMagnifierPointer;
export 'src/widget/eye_dropper.dart' show EyeDropper;
