import 'package:flutter/material.dart';

import '../core/totem_motion.dart';

/// Esqueleto pulsante (shimmer) para estados de carregamento do totem.
class LoadingShimmer extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  const LoadingShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (TotemMotion.reduced(context)) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFF223A42),
          borderRadius: widget.borderRadius,
        ),
      );
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Opacity(
        opacity: .30 + (_controller.value * .40),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: const Color(0xFF223A42),
            borderRadius: widget.borderRadius,
          ),
        ),
      ),
    );
  }
}

/// Fade suave para imagens do acervo (asset local).
Widget fadeInImage({
  required String path,
  required BoxFit fit,
  required Widget Function() fallback,
}) {
  return Image.asset(
    path,
    fit: fit,
    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
      if (wasSynchronouslyLoaded) return child;
      return AnimatedOpacity(
        opacity: frame == null ? 0 : 1,
        duration: TotemMotion.dur(context, 300),
        curve: Curves.easeOut,
        child: child,
      );
    },
    errorBuilder: (context, error, stackTrace) => fallback(),
  );
}
