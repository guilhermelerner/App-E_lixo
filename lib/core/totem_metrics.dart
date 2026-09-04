import 'package:flutter/material.dart';

/// Métricas responsivas para o totem vertical de 2160 x 3840.
class TotemMetrics {
  TotemMetrics._();

  static double scale(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width / 1080).clamp(.40, 2.0).toDouble();
  }

  static bool isPortrait(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context);
    return viewport.height > viewport.width * 1.20;
  }

  static double size(BuildContext context, double value) =>
      value * scale(context);

  static EdgeInsets pagePadding(BuildContext context) {
    final s = scale(context);
    if (isPortrait(context)) {
      return EdgeInsets.fromLTRB(24 * s, 30 * s, 24 * s, 42 * s);
    }
    return EdgeInsets.fromLTRB(64 * s, 54 * s, 64 * s, 72 * s);
  }

  static double sidebarWidth(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context);
    final percentage = isPortrait(context) ? .31 : .22;
    return (viewport.width * percentage).clamp(132.0, 680.0).toDouble();
  }
}
