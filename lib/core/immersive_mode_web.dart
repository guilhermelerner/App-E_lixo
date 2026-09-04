import 'dart:js_interop';

import 'package:web/web.dart' as web;

void enterImmersiveMode() {
  final root = web.document.documentElement;
  if (root == null || web.document.fullscreenElement != null) return;
  root.requestFullscreen().toDart.catchError((_) => null);
}
