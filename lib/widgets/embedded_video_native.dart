import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'loading_shimmer.dart';

/// Player offline (Windows/Linux/macOS): reproduz `assets/videos/e-lixo.mp4`
/// através do backend `video_player_media_kit` (libmpv/ffmpeg).
/// Se o arquivo ainda não foi colocado, mostra aviso sem quebrar.
class EmbeddedVideo extends StatefulWidget {
  const EmbeddedVideo({super.key});

  @override
  State<EmbeddedVideo> createState() => _EmbeddedVideoState();
}

class _EmbeddedVideoState extends State<EmbeddedVideo> {
  VideoPlayerController? _controller;
  bool _missing = false;

  @override
  void initState() {
    super.initState();
    final controller = VideoPlayerController.asset('assets/videos/e-lixo.mp4');
    _controller = controller;
    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    }).catchError((Object error) {
      debugPrint('EmbeddedVideo: falha ao abrir o vídeo nativo: $error');
      if (!mounted) return;
      setState(() => _missing = true);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_missing) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: ColoredBox(
          color: Color(0xFF071014),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Vídeo offline indisponível.\nVerifique o arquivo assets/videos/e-lixo.mp4.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
          ),
        ),
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
          _Controls(
            controller: controller,
            onFullscreen: () => _openFullscreen(context, controller),
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

  void _openFullscreen(
    BuildContext context,
    VideoPlayerController controller,
  ) {
    if (!controller.value.isPlaying) {
      controller.play();
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _FullscreenVideo(controller: controller),
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

class _Controls extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback onFullscreen;
  const _Controls({required this.controller, required this.onFullscreen});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onFullscreen,
            ),
          ),
          if (!controller.value.isPlaying)
            const Center(
              child: Icon(
                Icons.play_circle_fill,
                color: Color(0xFFA8D94A),
                size: 96,
              ),
            ),
          Positioned(
            right: 8,
            top: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    controller.value.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.white,
                    size: 48,
                  ),
                  tooltip: controller.value.isPlaying ? 'Pausar' : 'Assistir',
                  onPressed: () => controller.value.isPlaying
                      ? controller.pause()
                      : controller.play(),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: 48,
                  ),
                  tooltip: 'Tela cheia',
                  onPressed: onFullscreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
