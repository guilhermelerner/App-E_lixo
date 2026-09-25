import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:web/web.dart' as web;

import 'loading_shimmer.dart';

const _viewType = 'elixo-youtube-player';
bool _factoryRegistered = false;

/// Web: prefere o MP4 local offline; se ausente, usa o YouTube.
class EmbeddedVideo extends StatefulWidget {
  const EmbeddedVideo({super.key});

  @override
  State<EmbeddedVideo> createState() => _EmbeddedVideoState();
}

class _EmbeddedVideoState extends State<EmbeddedVideo> {
  VideoPlayerController? _controller;
  bool _useFallback = false;

  @override
  void initState() {
    super.initState();
    _registerFallback();
    final controller = VideoPlayerController.asset('assets/videos/e-lixo.mp4');
    _controller = controller;
    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    }).catchError((Object error) {
      debugPrint(
        'EmbeddedVideo (web): MP4 local indisponível, usando YouTube: $error',
      );
      if (!mounted) return;
      setState(() => _useFallback = true);
    });
  }

  void _registerFallback() {
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
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_useFallback) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: HtmlElementView(viewType: _viewType),
      );
    }
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            LoadingShimmer(
              width: double.infinity,
              height: double.infinity,
            ),
            CircularProgressIndicator(color: Color(0xFFA8D94A)),
          ],
        ),
      );
    }
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          VideoPlayer(controller),
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) => Center(
              child: controller.value.isPlaying
                  ? const SizedBox.shrink()
                  : const Icon(
                      Icons.play_circle_fill,
                      color: Color(0xFFA8D94A),
                      size: 96,
                    ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (!controller.value.isPlaying) {
                controller.play();
              }
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  fullscreenDialog: true,
                  builder: (_) => _FullscreenVideo(controller: controller),
                ),
              );
            },
            child: const SizedBox.expand(),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              icon: const Icon(
                Icons.fullscreen,
                color: Colors.white,
                size: 48,
              ),
              tooltip: 'Tela cheia',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  fullscreenDialog: true,
                  builder: (_) => _FullscreenVideo(controller: controller),
                ),
              ),
            ),
          ),
          VideoProgressIndicator(
            controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Color(0xFFA8D94A),
              bufferedColor: Colors.white24,
              backgroundColor: Colors.white10,
            ),
          ),
        ],
      ),
    );
  }
}

class _FullscreenVideo extends StatelessWidget {
  final VideoPlayerController controller;
  const _FullscreenVideo({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
            AnimatedBuilder(
              animation: controller,
              builder: (context, _) => controller.value.isPlaying
                  ? const SizedBox.shrink()
                  : const Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        color: Color(0xFFA8D94A),
                        size: 120,
                      ),
                    ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => controller.value.isPlaying
                  ? controller.pause()
                  : controller.play(),
              child: const SizedBox.expand(),
            ),
            VideoProgressIndicator(
              controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Color(0xFFA8D94A),
                bufferedColor: Colors.white24,
                backgroundColor: Colors.white10,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 56,
                  ),
                  tooltip: 'Fechar',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
