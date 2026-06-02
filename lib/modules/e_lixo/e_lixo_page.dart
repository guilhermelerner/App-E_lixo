import 'package:flutter/material.dart';

class ELixoPage extends StatelessWidget {
  const ELixoPage({super.key});

  static const List<_Category> _categories = [
    _Category(
      title: 'Computadores',
      icon: Icons.computer,
      color: Color(0xFF2E7D32),
      items: ['Notebooks', 'Desktops', 'Gabinetes'],
    ),
    _Category(
      title: 'Periféricos',
      icon: Icons.mouse,
      color: Color(0xFF388E3C),
      items: ['Mouse', 'Teclado', 'Monitor', 'Impressoras'],
    ),
    _Category(
      title: 'Componentes',
      icon: Icons.memory,
      color: Color(0xFF43A047),
      items: ['Memórias', 'Placas', 'Processador'],
    ),
    _Category(
      title: 'Outros',
      icon: Icons.devices_other,
      color: Color(0xFF66BB6A),
      items: ['TV', 'DVD', 'Equipamentos de Som'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-LIXO'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      backgroundColor: const Color(0xFFF1F8E9),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return _CategoryCard(category: cat);
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final _Category category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: category.color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(category.icon, color: category.color, size: 26),
        ),
        title: Text(
          category.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: category.color,
          ),
        ),
        subtitle: Text(
          '${category.items.length} itens',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: category.items
            .map(
              (item) => ListTile(
                dense: true,
                leading: Icon(Icons.circle, size: 8, color: category.color),
                title: Text(item, style: const TextStyle(fontSize: 15)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () {
                  // TODO: navegar para detalhe do item
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Category {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;

  const _Category({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
}