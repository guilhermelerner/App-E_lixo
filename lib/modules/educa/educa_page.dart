import 'package:flutter/material.dart';

class EducaPage extends StatelessWidget {
  const EducaPage({super.key});

  static const List<_EducaItem> _items = [
    _EducaItem(
      title: 'Vídeo da Sala',
      description: 'Assista ao vídeo produzido pela turma sobre e-lixo.',
      icon: Icons.videocam,
      color: Color(0xFF1565C0),
      type: _ItemType.video,
      assetPath: 'assets/videos/video_sala.mp4',
    ),
    _EducaItem(
      title: 'Imagens do Trabalho',
      description: 'Fotos e registros do trabalho realizado pela turma.',
      icon: Icons.photo_library,
      color: Color(0xFF1976D2),
      type: _ItemType.images,
      assetPath: 'assets/images/trabalho/',
    ),
    _EducaItem(
      title: 'Descarte Correto',
      description: 'Vídeo educativo sobre como descartar e-lixo corretamente.',
      icon: Icons.play_circle_outline,
      color: Color(0xFF1E88E5),
      type: _ItemType.video,
      assetPath: 'assets/videos/descarte_correto.mp4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EDUCA'),
        backgroundColor: const Color(0xFF1565C0),
      ),
      backgroundColor: const Color(0xFFE3F2FD),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _items[index];
          return _EducaCard(item: item);
        },
      ),
    );
  }
}

class _EducaCard extends StatelessWidget {
  final _EducaItem item;

  const _EducaCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // TODO: abrir vídeo ou galeria de imagens
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Abrindo: ${item.title}'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: item.color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: item.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.type == _ItemType.video ? 'Vídeo' : 'Imagens',
                        style: TextStyle(
                          fontSize: 11,
                          color: item.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}

enum _ItemType { video, images }

class _EducaItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final _ItemType type;
  final String assetPath;

  const _EducaItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.type,
    required this.assetPath,
  });
}