// Player do totem: web usa a implementação com HTML5/fallback,
// Windows/Linux/macOS usam a implementação nativa (backend media_kit).
export 'embedded_video_native.dart'
    if (dart.library.js_interop) 'embedded_video_web.dart';
