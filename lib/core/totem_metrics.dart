import 'package:flutter/material.dart';

/// Métricas responsivas para o totem vertical de 2160 x 3840.
class TotemMetrics {
  TotemMetrics._();

  static double scale(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width / 1080).clamp(.78, 1.35).toDouble();
  }

  static double size(BuildContext context, double value) => value * scale(context);

  static EdgeInsets pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final s = scale(context);
    if (width < 1000) {
      return EdgeInsets.fromLTRB(20 * s, 24 * s, 20 * s, 34 * s);
    }
    return EdgeInsets.fromLTRB(64 * s, 54 * s, 64 * s, 72 * s);
  }

  static double sidebarWidth(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context);
    final percentage = viewport.height > viewport.width * 1.25 ? .24 : .20;
    return viewport.width * percentage;
  }
}
