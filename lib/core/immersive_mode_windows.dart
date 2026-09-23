import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// Windows: tela cheia verdadeira (kiosk) — remove bordas, barra de título e esconde a taskbar.
Future<void> enterImmersiveMode() async {
  // Garante que o window_manager está inicializado
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(2160, 3840), // resolução do totem (vertical)
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden, // esconde a barra de título
    windowButtonVisibility: false, // esconde botões min/max/close
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setFullScreen(true); // fullscreen verdadeiro (cobre taskbar)
    await windowManager.setMaximizable(false);
    await windowManager.setMinimizable(false);
    await windowManager.setResizable(false);
    await windowManager.setClosable(false);
    await windowManager.show();
  });
}