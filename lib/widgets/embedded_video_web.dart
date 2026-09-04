import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

const _viewType = 'elixo-youtube-player';
bool _factoryRegistered = false;

class EmbeddedVideo extends StatefulWidget {
  const EmbeddedVideo({super.key});

  @override
  State<EmbeddedVideo> createState() => _EmbeddedVideoState();
}

class _EmbeddedVideoState extends State<EmbeddedVideo> {
  @override
  void initState() {
    super.initState();
    if (_factoryRegistered) return;
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = web.HTMLIFrameElement()
        ..src =
            'https://www.youtube-nocookie.com/embed/FGlJnjUytMs?rel=0&hl=pt-BR&cc_lang_pref=pt&cc_load_policy=1'
        ..title = 'O que fazer com o lixo eletrônico?'
        ..allow =
            'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share'
        ..allowFullscreen = true;
      iframe.style
        ..border = '0'
        ..width = '100%'
        ..height = '100%';
      return iframe;
    });
    _factoryRegistered = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
