export 'immersive_mode_stub.dart'
    if (dart.library.io) 'immersive_mode_windows.dart'
    if (dart.library.js_interop) 'immersive_mode_web.dart';
