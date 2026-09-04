import 'package:flutter/material.dart';

class EmbeddedVideo extends StatelessWidget {
  const EmbeddedVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 16 / 9,
      child: ColoredBox(
        color: Color(0xFF071014),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'O vídeo incorporado está disponível na versão web do totem.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
