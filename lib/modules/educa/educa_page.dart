import 'package:flutter/material.dart';

class EducaPage extends StatelessWidget {
  const EducaPage({super.key});

  // Lista original mantida para a aba de Mídias
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
    // DefaultTabController gerencia a navegação entre as abas automaticamente
    return DefaultTabController(
      length: 4, // Número total de categorias (abas)
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EDUCA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: const Color(0xFF1565C0),
          centerTitle: true,
          // TabBar cria os botões no formato de abas logo abaixo do título
          bottom: const TabBar(
            isScrollable: true, // Permite rolar os botões para os lados se não couberem na tela
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.play_circle_fill), text: 'Mídias'),
              Tab(icon: Icon(Icons.security), text: 'Segurança'),
              Tab(icon: Icon(Icons.location_on), text: 'Coleta'),
              Tab(icon: Icon(Icons.eco), text: 'Impacto'),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFE3F2FD),
        // TabBarView mostra o conteúdo correspondente à aba selecionada
        body: TabBarView(
          children: [
            _buildMidiasTab(),
            _buildSegurancaTab(),
            _buildColetaTab(),
            _buildImpactoTab(),
          ],
        ),
      ),
    );
  }

  // --- ABA 1: MÍDIAS (Seu código original encapsulado) ---
  Widget _buildMidiasTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _EducaCard(item: _items[index]);
      },
    );
  }

  // --- ABA 2: SEGURANÇA DE DADOS ---
  Widget _buildSegurancaTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Proteja seus dados antes de descartar!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1565C0)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: '1. Faça Backup',
          description: 'Salve suas fotos, documentos e contatos na nuvem (Google Drive, iCloud) ou em um pen drive seguro.',
          icon: Icons.cloud_upload,
        ),
        _buildInfoCard(
          title: '2. Remova Cartões e Chips',
          description: 'Não esqueça de tirar o chip da operadora (SIM card) e o cartão de memória (MicroSD) de celulares velhos.',
          icon: Icons.sd_card,
        ),
        _buildInfoCard(
          title: '3. Restaure de Fábrica',
          description: 'Vá nas configurações do seu celular ou computador e procure por "Restaurar Padrões de Fábrica" para apagar tudo.',
          icon: Icons.settings_backup_restore,
        ),
      ],
    );
  }

  // --- ABA 3: PONTOS DE COLETA ---
  Widget _buildColetaTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          title: 'Campus Cedeteg (Novatec)',
          description: 'Endereço: Alameda Élio Antonio Dalla Vecchia, 838 - Vila Carli, Guarapuava.\n\nHorário: 09h às 12h e 13h às 17h.',
          icon: Icons.business,
        ),
        _buildInfoCard(
          title: 'Ecopontos da Prefeitura',
          description: 'A prefeitura de Guarapuava realiza campanhas periódicas. Fique atento ao calendário de coleta solidária de eletrônicos da Secretaria de Meio Ambiente.',
          icon: Icons.map,
        ),
      ],
    );
  }

  // --- ABA 4: IMPACTO AMBIENTAL ---
  Widget _buildImpactoTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          title: 'Contaminação do Solo',
          description: 'O lixo eletrônico possui metais pesados como chumbo e mercúrio. Uma única bateria descartada no lixo comum pode contaminar milhares de litros de água.',
          icon: Icons.water_drop,
        ),
        _buildInfoCard(
          title: 'Mineração Urbana',
          description: 'Muitos componentes possuem ouro, prata e cobre. Reciclar essas placas evita a necessidade de extrair novos recursos da natureza.',
          icon: Icons.recycling,
        ),
      ],
    );
  }

  // Widget auxiliar para criar os cards informativos das novas abas
  Widget _buildInfoCard({required String title, required String description, required IconData icon}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF1565C0)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    // Fonte levemente maior para melhor acessibilidade de leitura
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Seu componente Card original para a aba de vídeos
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