import 'package:flutter/material.dart';
import '../../core/totem_metrics.dart';
import '../../core/totem_motion.dart';
import '../../widgets/embedded_video.dart';

class ELixoPage extends StatefulWidget {
  final String selectedCategory;
  final VoidCallback onBackToVideo;

  const ELixoPage({
    super.key,
    this.selectedCategory = 'Vídeo',
    required this.onBackToVideo,
  });

  static const List<_RepairProtocol> _protocols = [
    _RepairProtocol(
      'Computadores',
      'Desligue da tomada, teste outro cabo e observe os sinais de energia. Reencaixe memória RAM, cabos SATA e conectores. Se não iniciar, verifique fonte, armazenamento e aquecimento antes de descartar.',
    ),
    _RepairProtocol(
      'Monitores e TVs',
      'Confira tomada, cabo de força, fonte externa e cabo de vídeo. Teste em outro equipamento e observe linhas, manchas ou ausência de sinal. Nunca abra o aparelho: telas CRT podem armazenar alta tensão.',
    ),
    _RepairProtocol(
      'Impressoras e scanners',
      'Remova papel preso com cuidado, confira cartuchos e cabeçote, limpe o vidro do scanner e teste USB ou rede. Antes do descarte, separe cartuchos, toners e cabos para encaminhamento adequado.',
    ),
    _RepairProtocol(
      'Teclados, mouses e periféricos',
      'Limpe sem molhar, teste pilhas, receptor ou cabo e confira conectores. Em caso de mau contato, tente outra porta USB. Não descarte pilhas e baterias junto com o equipamento.',
    ),
    _RepairProtocol(
      'Segurança e descarte',
      'Não force componentes, não perfure baterias e não misture eletrônicos ao lixo comum. Separe o equipamento, acessórios, pilhas e cabos; procure assistência técnica, ponto de coleta ou logística reversa.',
    ),
  ];

  @override
  State<ELixoPage> createState() => _ELixoPageState();
}

class _ELixoPageState extends State<ELixoPage> {
  final ScrollController _scrollController = ScrollController();
  late final Map<String, GlobalKey> _anchors = {
    for (final p in ELixoPage._protocols) p.name: GlobalKey(),
  };
  String _lastScrolledTo = '';
  final Set<String> _completed = {};
  bool _reducedMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reducedMotion = TotemMotion.reduced(context);
  }

  void _toggleProtocol(String name) {
    setState(() {
      if (!_completed.remove(name)) {
        _completed.add(name);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollToTarget();
  }

  @override
  void didUpdateWidget(covariant ELixoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      _scrollToTarget();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTarget() {
    final target = widget.selectedCategory;
    if (target == 'Vídeo' || target == 'Protocolos de conserto') {
      if (target == 'Protocolos de conserto' && _scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: _reducedMotion
              ? Duration.zero
              : const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
      _lastScrolledTo = target;
      return;
    }
    if (target == 'Localização de descarte' || target == 'Quiz') {
      _lastScrolledTo = target;
      return;
    }
    if (target == _lastScrolledTo) return;
    _lastScrolledTo = target;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _anchors[target];
      final context = key?.currentContext;
      if (context != null && mounted) {
        Scrollable.ensureVisible(
          context,
          duration: _reducedMotion
              ? Duration.zero
              : const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          alignment: 0.08,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    final showVideo = widget.selectedCategory == 'Vídeo';
    final showQuiz = widget.selectedCategory == 'Quiz';
    final showCollectionPoints = widget.selectedCategory == 'Localização de descarte';
    return Scaffold(
      backgroundColor: const Color(0xFF101820),
      body: LayoutBuilder(
        builder: (context, viewport) => SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(28 * s, 32 * s, 28 * s, 56 * s),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  (viewport.maxHeight - (88 * s)).clamp(0.0, double.infinity),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1500),
                child: showVideo
                    ? const _VideoLanding()
                    : showQuiz
                        ? _QuizPage(
                            onBackToVideo: widget.onBackToVideo,
                          )
                        : showCollectionPoints
                            ? _CollectionPointsPage(
                                onBackToVideo: widget.onBackToVideo,
                              )
                            : _ProtocolsCard(
                                protocols: ELixoPage._protocols,
                                onBackToVideo: widget.onBackToVideo,
                                anchors: _anchors,
                                completed: _completed,
                                onToggleProtocol: _toggleProtocol,
                              ),
              ),
            ),
          ),
        ),
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
            padding: EdgeInsets.fromLTRB(48 * s, 36 * s, 48 * s, 44 * s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'O que fazer com o lixo eletrônico?',
                  softWrap: true,
                  style: TextStyle(
                    color: const Color(0xFFA8D94A),
                    fontSize: 40 * s,
                    fontWeight: FontWeight.bold,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 14 * s),
                Text(
                  'Assista sem sair do totem.',
                  style: TextStyle(
                    color: const Color(0xFFF5F1E8),
                    fontSize: 28 * s,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 36 * s),
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
              ],
            ),
          ),
        ],
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
      padding: EdgeInsets.all(26 * s),
      decoration: BoxDecoration(
        color: const Color(0xFF223A42),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF35515A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(fact.icon, color: const Color(0xFF2EC4B6), size: 34 * s),
          SizedBox(width: 16 * s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fact.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22 * s,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4 * s),
                Text(
                  fact.description,
                  style: TextStyle(
                    color: const Color(0xFFA9BBC0),
                    fontSize: 18 * s,
                    height: 1.35,
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

class _ProtocolsCard extends StatelessWidget {
  final List<_RepairProtocol> protocols;
  final VoidCallback onBackToVideo;
  final Map<String, GlobalKey> anchors;
  final Set<String> completed;
  final ValueChanged<String> onToggleProtocol;

  const _ProtocolsCard({
    required this.protocols,
    required this.onBackToVideo,
    this.anchors = const {},
    this.completed = const {},
    required this.onToggleProtocol,
  });

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Column(
      key: const Key('protocols-page'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: onBackToVideo,
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
                      'Siga estas orientações para testar, preservar e encaminhar equipamentos eletrônicos com segurança.',
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
        _ProgressTracker(
          done: completed.length,
          total: protocols.length,
          allDone: completed.length == protocols.length,
        ),
        SizedBox(height: 22 * s),
        ...protocols.asMap().entries.map(
          (entry) => Container(
            key: anchors[entry.value.name],
            child: _ProtocolStep(
              number: entry.key + 1,
              protocol: entry.value,
              done: completed.contains(entry.value.name),
              onToggle: () => onToggleProtocol(entry.value.name),
            ),
          ),
        ),
      ],
    );
  }
}

class _CollectionPointData {
  final IconData icon;
  final String title;
  final String description;
  const _CollectionPointData(this.icon, this.title, this.description);
}

class _CollectionPointTile extends StatelessWidget {
  final _CollectionPointData point;
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

class _ProgressTracker extends StatelessWidget {
  final int done;
  final int total;
  final bool allDone;
  const _ProgressTracker({
    required this.done,
    required this.total,
    required this.allDone,
  });

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(24 * s),
          decoration: BoxDecoration(
            color: const Color(0xFF223A42),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: allDone
                  ? const Color(0xFFA8D94A)
                  : const Color(0xFF35515A),
              width: allDone ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    allDone
                        ? Icons.verified
                        : Icons.checklist_outlined,
                    color: const Color(0xFFA8D94A),
                    size: 30 * s,
                  ),
                  SizedBox(width: 12 * s),
                  Expanded(
                    child: Text(
                      allDone
                          ? 'Protocolos concluídos! Bom trabalho.'
                          : '$done de $total protocolos concluídos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22 * s,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14 * s),
              TweenAnimationBuilder<double>(
                tween: Tween(
                  begin: 0,
                  end: total == 0 ? 0 : done / total,
                ),
                duration: TotemMotion.dur(context, 450),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) =>
                    LinearProgressIndicator(
                      value: value,
                      minHeight: 12 * s,
                      borderRadius: BorderRadius.circular(8),
                      backgroundColor: const Color(0xFF101820),
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFFA8D94A),
                      ),
                    ),
              ),
              AnimatedSwitcher(
                duration: TotemMotion.dur(context, 350),
                switchInCurve: Curves.easeOutBack,
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: allDone
                    ? Padding(
                        key: const ValueKey('all-done'),
                        padding: EdgeInsets.only(top: 14 * s),
                        child: Text(
                          'Você já pode descartar com segurança ou procurar um ponto de coleta abaixo.',
                          style: TextStyle(
                            color: const Color(0xFFA8D94A),
                            fontSize: 19 * s,
                            height: 1.4,
                          ),
                        ),
                      )
                    : SizedBox(key: const ValueKey('pending'), height: 4 * s),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProtocolStep extends StatelessWidget {
  final int number;
  final _RepairProtocol protocol;
  final bool done;
  final VoidCallback onToggle;

  const _ProtocolStep({
    required this.number,
    required this.protocol,
    this.done = false,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Opacity(
      opacity: done ? .75 : 1,
      child: Container(
        margin: EdgeInsets.only(bottom: 16 * s),
        padding: EdgeInsets.all(24 * s),
        decoration: BoxDecoration(
          color: const Color(0xFF223A42),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: done
                ? const Color(0xFFA8D94A)
                : const Color(0xFF35515A),
            width: done ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46 * s,
              height: 46 * s,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: done
                    ? const Color(0xFFA8D94A)
                    : const Color(0xFFB25900),
                shape: BoxShape.circle,
              ),
              child: done
                  ? Icon(Icons.check, color: Colors.black, size: 26 * s)
                  : Text(
                      '$number',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21 * s,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            SizedBox(width: 20 * s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    protocol.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25 * s,
                    ),
                  ),
                  SizedBox(height: 8 * s),
                  Text(
                    protocol.description,
                    style: TextStyle(
                      color: const Color(0xFFA9BBC0),
                      fontSize: 21 * s,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 14 * s),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: onToggle,
                      icon: Icon(
                        done
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        size: 26 * s,
                      ),
                      label: Text(
                        done ? 'Concluído' : 'Marcar como lido',
                        style: TextStyle(
                          fontSize: 20 * s,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFA8D94A),
                        side: const BorderSide(
                          color: Color(0xFF5E7A43),
                          width: 1.5,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 22 * s,
                          vertical: 16 * s,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
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

class _QuizQuestion {
  final String pergunta;
  final List<String> opcoes;
  final int correta;
  final String explicacao;
  const _QuizQuestion({
    required this.pergunta,
    required this.opcoes,
    required this.correta,
    required this.explicacao,
  });
}

class _QuizPage extends StatefulWidget {
  final VoidCallback onBackToVideo;
  const _QuizPage({required this.onBackToVideo});

  static const questions = [
    _QuizQuestion(
      pergunta: 'Onde devem ser descartadas pilhas e baterias?',
      opcoes: ['No lixo comum', 'Em ponto de coleta', 'No ralo ou vaso'],
      correta: 1,
      explicacao:
          'Pilhas e baterias têm metais pesados: ponto de coleta, nunca lixo comum.',
    ),
    _QuizQuestion(
      pergunta: 'O computador não liga. O que testar primeiro?',
      opcoes: [
        'Abrir a fonte com faca',
        'Cabo, tomada e conexões',
        'Jogar fora direto',
      ],
      correta: 1,
      explicacao:
          'Teste cabo, tomada, fonte e reencaixe memórias e conectores antes de descartar.',
    ),
    _QuizQuestion(
      pergunta: 'Pode abrir um monitor CRT em casa?',
      opcoes: [
        'Sim, é seguro',
        'Nunca — guarda alta tensão',
        'Só com as mãos molhadas',
      ],
      correta: 1,
      explicacao:
          'Telas CRT armazenam alta tensão mesmo desligadas. Nunca abra.',
    ),
    _QuizQuestion(
      pergunta: 'Cartuchos e toners usados devem ir...',
      opcoes: [
        'Para o lixo comum',
        'Separados para encaminhamento',
        'Queimados no quintal',
      ],
      correta: 1,
      explicacao:
          'Separe cartuchos, toners e cabos para encaminhamento adequado.',
    ),
    _QuizQuestion(
      pergunta: 'Eletrônico ainda funcionando: melhor destino?',
      opcoes: ['Doação ou reuso', 'Caçamba', 'Guardar quebrado para sempre'],
      correta: 0,
      explicacao: 'O melhor descarte é o que não acontece: doe ou venda.',
    ),
  ];

  @override
  State<_QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<_QuizPage> {
  int _index = 0;
  int _score = 0;
  int? _escolhida;

  void _responder(int i) {
    if (_escolhida != null) return;
    setState(() {
      _escolhida = i;
      if (i == _QuizPage.questions[_index].correta) _score++;
    });
  }

  void _proxima() {
    setState(() {
      _index++;
      _escolhida = null;
    });
  }

  void _refazer() {
    setState(() {
      _index = 0;
      _score = 0;
      _escolhida = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    final total = _QuizPage.questions.length;
    if (_index >= total) return _resultado(s, total);
    final q = _QuizPage.questions[_index];
    return Column(
      key: const Key('quiz-page'),
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
        Text(
          'QUIZ · PERGUNTA ${_index + 1} DE $total',
          style: TextStyle(
            color: const Color(0xFFDE924F),
            fontSize: 19 * s,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 14 * s),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: (_index + 1) / total),
          duration: TotemMotion.dur(context, 400),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => LinearProgressIndicator(
            value: value,
            minHeight: 12 * s,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: const Color(0xFF223A42),
            valueColor: const AlwaysStoppedAnimation(Color(0xFF2EC4B6)),
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
          child: Padding(
            padding: EdgeInsets.all(36 * s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  q.pergunta,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34 * s,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 28 * s),
                for (var i = 0; i < q.opcoes.length; i++)
                  _opcao(context, s, q, i),
                if (_escolhida != null) ...[
                  SizedBox(height: 20 * s),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(22 * s),
                    decoration: BoxDecoration(
                      color: const Color(0xFF223A42),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _escolhida == q.correta
                            ? const Color(0xFFA8D94A)
                            : const Color(0xFFDE924F),
                      ),
                    ),
                    child: Text(
                      _escolhida == q.correta
                          ? 'Correto! ${q.explicacao}'
                          : 'Ops! ${q.explicacao}',
                      style: TextStyle(
                        color: const Color(0xFFF5F1E8),
                        fontSize: 22 * s,
                        height: 1.45,
                      ),
                    ),
                  ),
                  SizedBox(height: 20 * s),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _proxima,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA8D94A),
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 22 * s),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        _index + 1 == total
                            ? 'Ver resultado'
                            : 'Próxima pergunta',
                        style: TextStyle(
                          fontSize: 24 * s,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _opcao(BuildContext context, double s, _QuizQuestion q, int i) {
    final respondida = _escolhida != null;
    final certa = i == q.correta;
    final escolhida = i == _escolhida;
    final cor = !respondida
        ? const Color(0xFF35515A)
        : certa
            ? const Color(0xFFA8D94A)
            : escolhida
                ? const Color(0xFFDE924F)
                : const Color(0xFF35515A);
    return Padding(
      padding: EdgeInsets.only(bottom: 14 * s),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: respondida ? null : () => _responder(i),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white70,
            side: BorderSide(color: cor, width: 2),
            padding: EdgeInsets.symmetric(
              horizontal: 24 * s,
              vertical: 24 * s,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              q.opcoes[i],
              style: TextStyle(fontSize: 24 * s, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultado(double s, int total) {
    final passou = _score >= 4;
    return Column(
      key: const Key('quiz-result'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          margin: EdgeInsets.zero,
          color: const Color(0xFF182A32),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(
              color: passou
                  ? const Color(0xFFA8D94A)
                  : const Color(0xFFDE924F),
              width: 2,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(48 * s),
            child: Column(
              children: [
                Icon(
                  passou ? Icons.emoji_events : Icons.recycling,
                  color: const Color(0xFFA8D94A),
                  size: 90 * s,
                ),
                SizedBox(height: 20 * s),
                Text(
                  'Você acertou $_score de $total',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 44 * s,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 14 * s),
                Text(
                  passou
                      ? 'Você já sabe descartar eletrônicos com segurança!'
                      : 'Que tal rever os protocolos e tentar de novo?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFA9BBC0),
                    fontSize: 24 * s,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 30 * s),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _refazer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA8D94A),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 22 * s),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Refazer quiz',
                      style: TextStyle(
                        fontSize: 24 * s,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CollectionPointsPage extends StatelessWidget {
  final VoidCallback onBackToVideo;

  const _CollectionPointsPage({required this.onBackToVideo});

  static const _points = [
    _CollectionPointData(
      Icons.recycling,
      'Ainda funciona?',
      'Doe ou venda para reuso — o melhor descarte é o que não precisa acontecer.',
    ),
    _CollectionPointData(
      Icons.storefront_outlined,
      'Assistência técnica',
      'Peças com defeito específico podem ser reparadas em vez de descartadas.',
    ),
    _CollectionPointData(
      Icons.location_on_outlined,
      'Ponto de coleta',
      'Procure ecopontos ou logística reversa do fabricante mais próximos.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Column(
      key: const Key('collection-points-page'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: onBackToVideo,
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
            side: BorderSide(
              color: const Color(0xFFA8D94A),
              width: 2,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(36 * s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.map_outlined,
                      color: const Color(0xFFA8D94A),
                      size: 34 * s,
                    ),
                    SizedBox(width: 16 * s),
                    Expanded(
                      child: Text(
                        'LOCALIZAÇÃO DE DESCARTE',
                        style: TextStyle(
                          color: const Color(0xFFA8D94A),
                          fontSize: 24 * s,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 28 * s),
                Text(
                  'Separe o equipamento, acessórios, pilhas e cabos; procure o destino adequado:',
                  style: TextStyle(
                    color: const Color(0xFFF5F1E8),
                    fontSize: 22 * s,
                    height: 1.45,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                SizedBox(height: 28 * s),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final stacked = constraints.maxWidth < 780 * s;
                    if (stacked) {
                      return Column(
                        children: [
                          for (final p in _points) ...[
                            _CollectionPointTile(point: p, scale: s),
                            if (p != _points.last) SizedBox(height: 16 * s),
                          ],
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final p in _points) ...[
                          Expanded(child: _CollectionPointTile(point: p, scale: s)),
                          if (p != _points.last) SizedBox(width: 20 * s),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RepairProtocol {
  final String name;
  final String description;
  const _RepairProtocol(this.name, this.description);
}
