import 'package:flutter/material.dart';
import '../../core/totem_metrics.dart';
import '../../widgets/embedded_video.dart';

class ELixoPage extends StatelessWidget {
  final String selectedCategory;
  final String? focusProtocol;
  final VoidCallback onBackToVideo;
  final ValueChanged<String> onSelectProtocol;

  const ELixoPage({
    super.key,
    this.selectedCategory = 'Vídeo',
    this.focusProtocol,
    required this.onBackToVideo,
    required this.onSelectProtocol,
  });

  static const List<_RepairProtocol> _protocols = [
    _RepairProtocol(
      'Computadores',
      'Desligue da tomada, teste outro cabo e observe os sinais de energia. Reencaixe memória RAM, cabos SATA e conectores. Se não iniciar, verifique fonte, armazenamento e aquecimento antes de descartar.',
      Icons.computer,
    ),
    _RepairProtocol(
      'Monitores e TVs',
      'Confira tomada, cabo de força, fonte externa e cabo de vídeo. Teste em outro equipamento e observe linhas, manchas ou ausência de sinal. Nunca abra o aparelho: telas CRT podem armazenar alta tensão.',
      Icons.tv_outlined,
    ),
    _RepairProtocol(
      'Impressoras e scanners',
      'Remova papel preso com cuidado, confira cartuchos e cabeçote, limpe o vidro do scanner e teste USB ou rede. Antes do descarte, separe cartuchos, toners e cabos para encaminhamento adequado.',
      Icons.print_outlined,
    ),
    _RepairProtocol(
      'Teclados, mouses e periféricos',
      'Limpe sem molhar, teste pilhas, receptor ou cabo e confira conectores. Em caso de mau contato, tente outra porta USB. Não descarte pilhas e baterias junto com o equipamento.',
      Icons.keyboard_outlined,
    ),
    _RepairProtocol(
      'Segurança e descarte',
      'Não force componentes, não perfure baterias e não misture eletrônicos ao lixo comum. Separe o equipamento, acessórios, pilhas e cabos; procure assistência técnica, ponto de coleta ou logística reversa.',
      Icons.warning_amber_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Scaffold(
      backgroundColor: const Color(0xFF101820),
      body: ListView(
        padding: EdgeInsets.fromLTRB(28 * s, 24 * s, 28 * s, 48 * s),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1500),
              child: selectedCategory == 'Protocolos de conserto'
                  ? _ProtocolsCard(
                      protocols: _protocols,
                      focusProtocol: focusProtocol,
                      onBackToVideo: onBackToVideo,
                    )
                  : _VideoLanding(
                      protocols: _protocols,
                      onSelectProtocol: onSelectProtocol,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoLanding extends StatelessWidget {
  final List<_RepairProtocol> protocols;
  final ValueChanged<String> onSelectProtocol;

  const _VideoLanding({
    required this.protocols,
    required this.onSelectProtocol,
  });

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Card(
      key: const Key('video-landing'),
      margin: EdgeInsets.zero,
      color: const Color(0xFF182A32),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: Color(0xFF35515A)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EmbeddedVideo(),
          Padding(
            padding: EdgeInsets.fromLTRB(34 * s, 24 * s, 34 * s, 28 * s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'O que fazer com o lixo eletrônico?',
                  style: TextStyle(
                    color: const Color(0xFFA8D94A),
                    fontSize: 36 * s,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10 * s),
                Text(
                  'Assista sem sair do totem.',
                  style: TextStyle(
                    color: const Color(0xFFF5F1E8),
                    fontSize: 23 * s,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 30 * s),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final stacked = constraints.maxWidth < 760 * s;
                    final facts = const [
                      _QuickFact(
                        Icons.build_circle_outlined,
                        '5 protocolos',
                        'Guias de teste antes do descarte',
                      ),
                      _QuickFact(
                        Icons.battery_alert_outlined,
                        'Descarte seguro',
                        'Pilhas e baterias exigem cuidado extra',
                      ),
                      _QuickFact(
                        Icons.eco_outlined,
                        'Menos poluição',
                        'Cada equipamento reaproveitado ajuda o planeta',
                      ),
                    ];
                    if (stacked) {
                      return Column(
                        children: [
                          for (final f in facts) ...[
                            _QuickFactTile(fact: f, scale: s),
                            if (f != facts.last) SizedBox(height: 12 * s),
                          ],
                        ],
                      );
                    }
                    return Row(
                      children: [
                        for (final f in facts) ...[
                          Expanded(child: _QuickFactTile(fact: f, scale: s)),
                          if (f != facts.last) SizedBox(width: 16 * s),
                        ],
                      ],
                    );
                  },
                ),
                SizedBox(height: 30 * s),
                Text(
                  'IR DIRETO PARA UM PROTOCOLO',
                  style: TextStyle(
                    color: const Color(0xFFDE924F),
                    fontSize: 16 * s,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.4,
                  ),
                ),
                SizedBox(height: 14 * s),
                Wrap(
                  spacing: 12 * s,
                  runSpacing: 12 * s,
                  children: [
                    for (final p in protocols)
                      _ProtocolChip(
                        protocol: p,
                        scale: s,
                        onTap: () => onSelectProtocol(p.name),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProtocolChip extends StatelessWidget {
  final _RepairProtocol protocol;
  final double scale;
  final VoidCallback onTap;
  const _ProtocolChip({
    required this.protocol,
    required this.scale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18 * s, vertical: 12 * s),
        decoration: BoxDecoration(
          color: const Color(0xFF223A42),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF5E7A43)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(protocol.icon, color: const Color(0xFFA8D94A), size: 20 * s),
            SizedBox(width: 8 * s),
            Text(
              protocol.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15 * s,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickFact {
  final IconData icon;
  final String title;
  final String description;
  const _QuickFact(this.icon, this.title, this.description);
}

class _QuickFactTile extends StatelessWidget {
  final _QuickFact fact;
  final double scale;
  const _QuickFactTile({required this.fact, required this.scale});

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      padding: EdgeInsets.all(18 * s),
      decoration: BoxDecoration(
        color: const Color(0xFF223A42),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF35515A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(fact.icon, color: const Color(0xFF2EC4B6), size: 26 * s),
          SizedBox(width: 12 * s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fact.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17 * s,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3 * s),
                Text(
                  fact.description,
                  style: TextStyle(
                    color: const Color(0xFFA9BBC0),
                    fontSize: 14 * s,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProtocolsCard extends StatefulWidget {
  final List<_RepairProtocol> protocols;
  final String? focusProtocol;
  final VoidCallback onBackToVideo;

  const _ProtocolsCard({
    required this.protocols,
    required this.focusProtocol,
    required this.onBackToVideo,
  });

  @override
  State<_ProtocolsCard> createState() => _ProtocolsCardState();
}

class _ProtocolsCardState extends State<_ProtocolsCard> {
  late Set<String> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.focusProtocol != null ? {widget.focusProtocol!} : {};
  }

  @override
  void didUpdateWidget(covariant _ProtocolsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusProtocol != null &&
        widget.focusProtocol != oldWidget.focusProtocol) {
      setState(() => _expanded = {widget.focusProtocol!});
    }
  }

  void _toggle(String name) {
    setState(() {
      if (_expanded.contains(name)) {
        _expanded.remove(name);
      } else {
        _expanded.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Column(
      key: const Key('protocols-page'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: widget.onBackToVideo,
          icon: Icon(Icons.play_circle_outline, size: 30 * s),
          label: Text(
            'Voltar ao vídeo',
            style: TextStyle(fontSize: 22 * s, fontWeight: FontWeight.w700),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFA8D94A),
            side: const BorderSide(color: Color(0xFF5E7A43), width: 1.5),
            padding: EdgeInsets.symmetric(horizontal: 26 * s, vertical: 20 * s),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        SizedBox(height: 24 * s),
        Card(
          margin: EdgeInsets.zero,
          color: const Color(0xFF182A32),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Color(0xFF35515A)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(34 * s, 30 * s, 34 * s, 34 * s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GUIA DE PROTOCOLOS',
                      style: TextStyle(
                        color: const Color(0xFFDE924F),
                        fontSize: 18 * s,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12 * s),
                    Text(
                      'Cuidados antes do descarte',
                      style: TextStyle(
                        color: const Color(0xFFA8D94A),
                        fontSize: 38 * s,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12 * s),
                    Text(
                      'Siga estas orientações para testar, preservar e encaminhar equipamentos eletrônicos com segurança. Toque em cada categoria para ver o passo a passo.',
                      style: TextStyle(
                        color: const Color(0xFFF5F1E8),
                        fontSize: 24 * s,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30 * s),
        Text(
          'GUIA RÁPIDO: ANTES DE DESCARTAR',
          style: TextStyle(
            color: const Color(0xFFDE924F),
            fontSize: 19 * s,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 18 * s),
        ...widget.protocols.map(
          (protocol) => _ProtocolStep(
            protocol: protocol,
            expanded: _expanded.contains(protocol.name),
            onTap: () => _toggle(protocol.name),
          ),
        ),
        SizedBox(height: 30 * s),
        const _CollectionPointsCard(),
      ],
    );
  }
}

class _CollectionPointsCard extends StatelessWidget {
  const _CollectionPointsCard();

  static const _points = [
    _CollectionPoint(
      Icons.recycling,
      'Ainda funciona?',
      'Doe ou venda para reuso — o melhor descarte é o que não precisa acontecer.',
    ),
    _CollectionPoint(
      Icons.storefront_outlined,
      'Assistência técnica',
      'Peças com defeito específico podem ser reparadas em vez de descartadas.',
    ),
    _CollectionPoint(
      Icons.location_on_outlined,
      'Ponto de coleta',
      'Procure ecopontos ou logística reversa do fabricante mais próximos.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Card(
      margin: EdgeInsets.zero,
      color: const Color(0xFF182A32),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: Color(0xFF35515A)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(30 * s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.map_outlined,
                  color: const Color(0xFFA8D94A),
                  size: 30 * s,
                ),
                SizedBox(width: 14 * s),
                Text(
                  'PARA ONDE LEVAR DEPOIS',
                  style: TextStyle(
                    color: const Color(0xFFA8D94A),
                    fontSize: 22 * s,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .8,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24 * s),
            LayoutBuilder(
              builder: (context, constraints) {
                final stacked = constraints.maxWidth < 780 * s;
                if (stacked) {
                  return Column(
                    children: [
                      for (final p in _points) ...[
                        _CollectionPointTile(point: p, scale: s),
                        if (p != _points.last) SizedBox(height: 14 * s),
                      ],
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final p in _points) ...[
                      Expanded(child: _CollectionPointTile(point: p, scale: s)),
                      if (p != _points.last) SizedBox(width: 18 * s),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionPoint {
  final IconData icon;
  final String title;
  final String description;
  const _CollectionPoint(this.icon, this.title, this.description);
}

class _CollectionPointTile extends StatelessWidget {
  final _CollectionPoint point;
  final double scale;
  const _CollectionPointTile({required this.point, required this.scale});

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      padding: EdgeInsets.all(18 * s),
      decoration: BoxDecoration(
        color: const Color(0xFF223A42),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF35515A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(point.icon, color: const Color(0xFFDE924F), size: 26 * s),
          SizedBox(height: 10 * s),
          Text(
            point.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18 * s,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6 * s),
          Text(
            point.description,
            style: TextStyle(
              color: const Color(0xFFA9BBC0),
              fontSize: 15 * s,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProtocolStep extends StatelessWidget {
  final _RepairProtocol protocol;
  final bool expanded;
  final VoidCallback onTap;

  const _ProtocolStep({
    required this.protocol,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Container(
      margin: EdgeInsets.only(bottom: 16 * s),
      decoration: BoxDecoration(
        color: const Color(0xFF223A42),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: expanded ? const Color(0xFFA8D94A) : const Color(0xFF35515A),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(24 * s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46 * s,
                      height: 46 * s,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFB25900),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        protocol.icon,
                        color: Colors.white,
                        size: 24 * s,
                      ),
                    ),
                    SizedBox(width: 20 * s),
                    Expanded(
                      child: Text(
                        protocol.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25 * s,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.expand_more,
                        color: const Color(0xFFA9BBC0),
                        size: 30 * s,
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 220),
                  crossFadeState: expanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Padding(
                    padding: EdgeInsets.only(
                      top: 14 * s,
                      left: 66 * s,
                    ),
                    child: Text(
                      protocol.description,
                      style: TextStyle(
                        color: const Color(0xFFA9BBC0),
                        fontSize: 21 * s,
                        height: 1.5,
                      ),
                    ),
                  ),
                  secondChild: const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RepairProtocol {
  final String name;
  final String description;
  final IconData icon;
  const _RepairProtocol(this.name, this.description, this.icon);
}
