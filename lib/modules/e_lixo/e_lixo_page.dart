import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../core/totem_metrics.dart';

class ELixoPage extends StatelessWidget {
  final String selectedCategory;
  const ELixoPage({super.key, this.selectedCategory = 'Vídeo'});

  static const List<_Category> _categories = [
    _Category('Computadores', Icons.computer, Color(0xFFA8D94A), ['Notebooks', 'Desktops', 'Gabinetes']),
    _Category('Periféricos', Icons.mouse, Color(0xFF2EC4B6), ['Mouse', 'Teclado', 'Monitor', 'Impressoras']),
    _Category('Componentes', Icons.memory, Color(0xFF70C1B3), ['Memórias', 'Placas', 'Processador']),
    _Category('Outros', Icons.devices_other, Color(0xFFF2C14E), ['TV', 'DVD', 'Equipamentos de Som']),
  ];

  static const List<_RepairProtocol> _protocols = [
    _RepairProtocol('Computadores', 'Desligue da tomada, teste outro cabo e observe os sinais de energia. Reencaixe memória RAM, cabos SATA e conectores. Se não iniciar, verifique fonte, armazenamento e aquecimento antes de descartar.'),
    _RepairProtocol('Monitores e TVs', 'Confira tomada, cabo de força, fonte externa e cabo de vídeo. Teste em outro equipamento e observe linhas, manchas ou ausência de sinal. Nunca abra o aparelho: telas CRT podem armazenar alta tensão.'),
    _RepairProtocol('Impressoras e scanners', 'Remova papel preso com cuidado, confira cartuchos e cabeçote, limpe o vidro do scanner e teste USB ou rede. Antes do descarte, separe cartuchos, toners e cabos para encaminhamento adequado.'),
    _RepairProtocol('Teclados, mouses e periféricos', 'Limpe sem molhar, teste pilhas, receptor ou cabo e confira conectores. Em caso de mau contato, tente outra porta USB. Não descarte pilhas e baterias junto com o equipamento.'),
    _RepairProtocol('Segurança e descarte', 'Não force componentes, não perfure baterias e não misture eletrônicos ao lixo comum. Separe o equipamento, acessórios, pilhas e cabos; procure assistência técnica, ponto de coleta ou logística reversa.'),
  ];

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 92 * s,
        title: Text('E-LIXO', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 30 * s)),
        backgroundColor: const Color(0xFF182A32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF101820),
      body: ListView(
        padding: TotemMetrics.pagePadding(context),
        children: [
          SizedBox(height: 12 * s),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1600 * s),
              child: selectedCategory == 'Protocolos de conserto'
                  ? const _ProtocolsCard(protocols: _protocols)
                  : const _VideoLanding(),
            ),
          ),
          SizedBox(height: 38 * s),
          Center(child: Text('Use a barra lateral para acessar os protocolos de conserto.', textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFFA9BBC0), fontSize: 20 * s))),
        ],
      ),
    );
  }

}

class _SelectedCategoryPanel extends StatelessWidget {
  final _Category category;
  const _SelectedCategoryPanel({required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('${category.items.length} itens disponíveis', style: const TextStyle(color: Color(0xFFA9BBC0), fontSize: 16)),
      const SizedBox(height: 16),
      LayoutBuilder(builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1200 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: category.items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 2.4),
          itemBuilder: (context, index) => Card(
            color: const Color(0xFF223A42),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFF35515A))),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(backgroundColor: const Color(0xFF223A42), title: Text(category.items[index], style: const TextStyle(color: Color(0xFFA8D94A))), content: const Text('Consulte os cuidados de manutenção, reaproveitamento e descarte correto deste equipamento.', style: TextStyle(color: Colors.white, fontSize: 17)), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Fechar', style: TextStyle(color: Color(0xFF2EC4B6))))])),
              child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: category.color.withOpacity(0.18), borderRadius: BorderRadius.circular(12)), child: Icon(category.icon, color: category.color)), const SizedBox(width: 14), Expanded(child: Text(category.items[index], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))), Icon(Icons.arrow_forward_rounded, color: category.color)])),
            ),
          ),
        );
      }),
    ]);
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF182A32),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: Color(0xFF35515A))),
      child: Padding(
        padding: EdgeInsets.all(TotemMetrics.size(context, 42)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Tecnologia que continua viva', style: TextStyle(color: const Color(0xFFA8D94A), fontSize: TotemMetrics.size(context, 46), fontWeight: FontWeight.bold)),
          SizedBox(height: TotemMetrics.size(context, 14)),
          Text('Explore o vídeo educativo e descubra como cuidar, consertar e encaminhar equipamentos eletrônicos.', style: TextStyle(color: const Color(0xFFF5F1E8), fontSize: TotemMetrics.size(context, 27), height: 1.4)),
        ]),
      ),
    );
  }
}

class _VideoLanding extends StatelessWidget {
  const _VideoLanding();

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Card(
      color: const Color(0xFF182A32),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: const BorderSide(color: Color(0xFF35515A))),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _EmbeddedVideo(),
          Padding(
            padding: EdgeInsets.fromLTRB(42 * s, 34 * s, 42 * s, 40 * s),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('VÍDEO EDUCATIVO', style: TextStyle(color: const Color(0xFFDE924F), fontSize: 18 * s, letterSpacing: 1.8, fontWeight: FontWeight.bold)),
              SizedBox(height: 14 * s),
              Text('O que fazer com o lixo eletrônico?', style: TextStyle(color: const Color(0xFFA8D94A), fontSize: 42 * s, fontWeight: FontWeight.bold)),
              SizedBox(height: 14 * s),
              Text('Assista sem sair do totem e descubra como prolongar a vida útil dos equipamentos e encaminhar cada material corretamente.', style: TextStyle(color: const Color(0xFFF5F1E8), fontSize: 27 * s, height: 1.45)),
            ]),
          ),
        ],
      ),
    );
  }
}

class _ProtocolsCard extends StatelessWidget {
  final List<_RepairProtocol> protocols;
  const _ProtocolsCard({required this.protocols});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: const Color(0xFF182A32),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: const BorderSide(color: Color(0xFF35515A))),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 22, 26, 26),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('GUIA DE PROTOCOLOS', style: TextStyle(color: Color(0xFFDE924F), fontSize: 14, letterSpacing: 1.8, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Cuidados antes do descarte', style: TextStyle(color: Color(0xFFA8D94A), fontSize: 27, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Siga estas orientações para testar, preservar e encaminhar equipamentos eletrônicos com segurança.', style: TextStyle(color: Color(0xFFF5F1E8), fontSize: 17, height: 1.4)),
                ]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text('GUIA RÁPIDO: ANTES DE DESCARTAR', style: TextStyle(color: Color(0xFFDE924F), fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        const SizedBox(height: 12),
        ...protocols.asMap().entries.map((entry) => _ProtocolStep(number: entry.key + 1, protocol: entry.value)),
      ],
    );
  }
}

class _EmbeddedVideo extends StatefulWidget {
  const _EmbeddedVideo();

  @override
  State<_EmbeddedVideo> createState() => _EmbeddedVideoState();
}

class _EmbeddedVideoState extends State<_EmbeddedVideo> {
  late final YoutubePlayerController _controller = YoutubePlayerController.fromVideoId(
    videoId: 'FGlJnjUytMs',
    autoPlay: false,
    params: const YoutubePlayerParams(
      showControls: true,
      showFullscreenButton: true,
      interfaceLanguage: 'pt',
      captionLanguage: 'pt',
      privacyEnhancedMode: true,
      strictRelatedVideos: true,
      color: 'white',
    ),
  );

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: YoutubePlayer(controller: _controller),
    );
  }
}

class _ProtocolStep extends StatelessWidget {
  final int number;
  final _RepairProtocol protocol;

  const _ProtocolStep({required this.number, required this.protocol});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF223A42), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF35515A))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 34, height: 34, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xFFB25900), shape: BoxShape.circle), child: Text('$number', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(protocol.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)), const SizedBox(height: 4), Text(protocol.description, style: const TextStyle(color: Color(0xFFA9BBC0), fontSize: 15, height: 1.35))])),
      ]),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final _Category category;
  final int index;
  const _CategoryCard({required this.category, required this.index});

  void _showCategory(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF223A42),
          title: Text(category.title, style: const TextStyle(color: Color(0xFFA8D94A), fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: category.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  const Icon(Icons.arrow_forward, color: Color(0xFF2EC4B6), size: 18),
                  const SizedBox(width: 10),
                  Text(item, style: const TextStyle(color: Colors.white, fontSize: 17)),
                ]),
              );
            }).toList(),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Fechar', style: TextStyle(color: Color(0xFF2EC4B6)))),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 350 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(opacity: value, child: Transform.translate(offset: Offset(0, 18 * (1 - value)), child: child)),
      child: Card(
        color: const Color(0xFF223A42),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFF35515A))),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showCategory(context),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 58, height: 58, decoration: BoxDecoration(color: category.color.withOpacity(0.2), borderRadius: BorderRadius.circular(16)), child: Icon(category.icon, color: category.color, size: 32)),
              const Spacer(),
              Text(category.title, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text('${category.items.length} itens disponíveis', style: const TextStyle(color: Color(0xFFA9BBC0), fontSize: 14)),
              const SizedBox(height: 12),
              Row(children: [Text('Explorar', style: TextStyle(color: category.color, fontWeight: FontWeight.bold)), const Spacer(), Icon(Icons.arrow_forward_rounded, color: category.color)]),
            ]),
          ),
        ),
      ),
    );
  }
}

class _Category {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;
  const _Category(this.title, this.icon, this.color, this.items);
}

class _RepairProtocol {
  final String name;
  final String description;
  const _RepairProtocol(this.name, this.description);
}
