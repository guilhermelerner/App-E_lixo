import 'dart:async';

import 'package:flutter/material.dart';
import 'core/immersive_mode.dart';
import 'core/totem_metrics.dart';
import 'core/totem_motion.dart';
import 'modules/e_lixo/e_lixo_page.dart';
import 'modules/e_museu/e_museu_page.dart';

void main() {
  runApp(const ELixoApp());
}

class ELixoApp extends StatelessWidget {
  const ELixoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Lixo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32), // verde escuro
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFF66BB6A),
          surface: const Color(0xFFF1F8E9),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      home: const MainNavigationPage(),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  final VoidCallback onEnterImmersive;

  const MainNavigationPage({
    super.key,
    this.onEnterImmersive = enterImmersiveMode,
  });

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  static const _idleWarnAfter = Duration(seconds: 105);
  static const _idleCountdown = 15;

  int _currentIndex = 0;
  bool _showHome = true;
  String _selectedELixoCategory = 'Vídeo';
  String _selectedMuseuCategory = 'Todos';
  Timer? _idleTimer;
  bool _warnOpen = false;

  @override
  void dispose() {
    _idleTimer?.cancel();
    super.dispose();
  }

  void _armIdleTimer() {
    _idleTimer?.cancel();
    if (_showHome) return;
    _idleTimer = Timer(_idleWarnAfter, () {
      if (mounted && !_showHome) _showIdleWarning();
    });
  }

  void _notifyActivity() {
    if (_warnOpen) {
      _warnOpen = false;
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
    _armIdleTimer();
  }

  void _goHome() {
    _idleTimer?.cancel();
    _warnOpen = false;
    if (mounted) {
      setState(() => _showHome = true);
    }
  }

  void _showIdleWarning() {
    _warnOpen = true;
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _IdleWarningDialog(
        key: const Key('idle-warning-dialog'),
        onTimeout: () {
          Navigator.of(dialogContext, rootNavigator: true).pop();
          _warnOpen = false;
          _goHome();
        },
        onContinue: () {
          Navigator.of(dialogContext, rootNavigator: true).pop();
          _warnOpen = false;
          _armIdleTimer();
        },
      ),
    ).then((_) {
      _warnOpen = false;
      _armIdleTimer();
    });
  }

  Widget get _currentPage {
    if (_currentIndex == 0) {
      return ELixoPage(
        selectedCategory: _selectedELixoCategory,
        onBackToVideo: () => setState(() => _selectedELixoCategory = 'Vídeo'),
      );
    }
    return EMuseuPage(
      key: ValueKey(_selectedMuseuCategory),
      initialCategory: _selectedMuseuCategory,
    );
  }

  List<_SidebarCategory> get _sidebarCategories => _currentIndex == 0
      ? const [
          _SidebarCategory('Vídeo', Icons.play_circle_outline),
          _SidebarCategory(
            'Protocolos de conserto',
            Icons.build_circle_outlined,
          ),
          _SidebarCategory.heading('GUIAS RÁPIDOS'),
          _SidebarCategory('Computadores', Icons.computer_outlined),
          _SidebarCategory('Monitores e TVs', Icons.tv_outlined),
          _SidebarCategory('Impressoras e scanners', Icons.print_outlined),
          _SidebarCategory(
            'Teclados, mouses e periféricos',
            Icons.keyboard_outlined,
          ),
          _SidebarCategory('Segurança e descarte', Icons.shield_outlined),
          _SidebarCategory('Pontos de coleta', Icons.location_on_outlined),
          _SidebarCategory('Quiz', Icons.quiz_outlined),
        ]
      : const [
          _SidebarCategory.heading('CATEGORIAS DO ACERVO'),
          _SidebarCategory('Todos', Icons.grid_view),
          _SidebarCategory('Componentes', Icons.memory),
          _SidebarCategory('Computadores - PC', Icons.computer),
          _SidebarCategory('Outros', Icons.devices_other),
          _SidebarCategory('Periféricos', Icons.mouse),
        ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101820),
      body: Listener(
        onPointerDown: (_) => _notifyActivity(),
        child: AnimatedSwitcher(
          duration: TotemMotion.dur(context, 450),
          switchInCurve: Curves.easeOutCubic,
          child: _showHome
              ? _HomePage(
                  onModuleSelected: (index) {
                    widget.onEnterImmersive();
                    setState(() {
                      _currentIndex = index;
                      if (index == 0) _selectedELixoCategory = 'Vídeo';
                      if (index == 1) _selectedMuseuCategory = 'Todos';
                      _showHome = false;
                    });
                    _armIdleTimer();
                  },
                )
            : Row(
                key: const ValueKey('modules'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TotemSidebar(
                    moduleTitle: _currentIndex == 0 ? 'E-LIXO' : 'E-MUSEU',
                    categories: _sidebarCategories,
                    selectedCategory: _currentIndex == 0
                        ? _selectedELixoCategory
                        : _selectedMuseuCategory,
                    onHome: () => setState(() => _showHome = true),
                    onCategorySelected: (category) => setState(() {
                      if (_currentIndex == 0) {
                        _selectedELixoCategory = category;
                      } else {
                        _selectedMuseuCategory = category;
                      }
                    }),
                  ),
                  Expanded(child: _currentPage),
                ],
              ),
        ),
      ),
    );
  }
}

class _IdleWarningDialog extends StatefulWidget {
  final VoidCallback onTimeout;
  final VoidCallback onContinue;
  const _IdleWarningDialog({
    super.key,
    required this.onTimeout,
    required this.onContinue,
  });

  @override
  State<_IdleWarningDialog> createState() => _IdleWarningDialogState();
}

class _IdleWarningDialogState extends State<_IdleWarningDialog> {
  int _left = _MainNavigationPageState._idleCountdown;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _left--);
      if (_left <= 0) {
        t.cancel();
        widget.onTimeout();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return AlertDialog(
      backgroundColor: const Color(0xFF182A32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: Color(0xFF2EC4B6), width: 2),
      ),
      title: Text(
        'Ainda está aí?',
        style: TextStyle(
          color: const Color(0xFFA8D94A),
          fontSize: 34 * s,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Voltando ao início em $_left segundos.\nToque em qualquer lugar para continuar.',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 24 * s,
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onContinue,
          child: Text(
            'Continuar',
            style: TextStyle(
              color: const Color(0xFF2EC4B6),
              fontSize: 24 * s,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _TotemSidebar extends StatefulWidget {
  final String moduleTitle;
  final List<_SidebarCategory> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback onHome;

  const _TotemSidebar({
    required this.moduleTitle,
    required this.categories,
    required this.selectedCategory,
    required this.onHome,
    required this.onCategorySelected,
  });

  @override
  State<_TotemSidebar> createState() => _TotemSidebarState();
}

class _TotemSidebarState extends State<_TotemSidebar> {
  final Map<String, GlobalKey> _itemKeys = {};
  final GlobalKey _stackKey = GlobalKey();
  double? _ringTop;
  double? _ringHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateRing());
  }

  @override
  void didUpdateWidget(covariant _TotemSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.moduleTitle != widget.moduleTitle) {
      _itemKeys.clear();
      _ringTop = null;
      _ringHeight = null;
    }
    if (oldWidget.selectedCategory != widget.selectedCategory ||
        oldWidget.moduleTitle != widget.moduleTitle) {
      _updateRing();
    }
  }

  void _updateRing() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final stackCtx = _stackKey.currentContext;
      final itemCtx = _itemKeys[widget.selectedCategory]?.currentContext;
      if (stackCtx == null || itemCtx == null) return;
      final stackBox = stackCtx.findRenderObject() as RenderBox?;
      final itemBox = itemCtx.findRenderObject() as RenderBox?;
      if (stackBox == null || itemBox == null || !itemBox.attached) return;
      final pos = itemBox.localToGlobal(Offset.zero, ancestor: stackBox);
      if (_ringTop == pos.dy && _ringHeight == itemBox.size.height) return;
      setState(() {
        _ringTop = pos.dy;
        _ringHeight = itemBox.size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String moduleTitle = widget.moduleTitle;
    final List<_SidebarCategory> categories = widget.categories;
    final String selectedCategory = widget.selectedCategory;
    final ValueChanged<String> onCategorySelected = widget.onCategorySelected;
    final VoidCallback onHome = widget.onHome;
    final s = TotemMetrics.scale(context);
    final ui = s;
    final museum = moduleTitle == 'E-MUSEU';
    final background = museum
        ? const Color(0xFFF3E4D1)
        : const Color(0xFF101820);
    final surface = museum ? const Color(0xFFFFFBF5) : const Color(0xFF182A32);
    final selectedSurface = museum
        ? const Color(0xFF663300)
        : const Color(0xFF964B00);
    final primary = museum ? const Color(0xFF422100) : Colors.white;
    final secondary = museum
        ? const Color(0xFF966B46)
        : const Color(0xFFA9BBC0);
    final accent = museum ? const Color(0xFFB25900) : const Color(0xFF2EC4B6);

    return Container(
      key: const Key('totem-sidebar'),
      width: TotemMetrics.sidebarWidth(context),
      height: double.infinity,
      padding: EdgeInsets.fromLTRB(34 * ui, 46 * ui, 34 * ui, 34 * ui),
      decoration: BoxDecoration(
        color: background,
        border: museum
            ? const Border(
                right: BorderSide(color: Color(0xFFD6A36A), width: 1.2),
              )
            : null,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 14,
            offset: Offset(3, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                key: _stackKey,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
            if (museum) ...[
              Icon(Icons.account_balance, color: accent, size: 68 * ui),
              SizedBox(height: 18 * ui),
              Text(
                'E-MUSEU',
                style: TextStyle(
                  color: primary,
                  fontSize: 32 * ui,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 6 * ui),
              Text(
                'Galeria de tecnologia',
                style: TextStyle(
                  color: secondary,
                  fontSize: 18 * ui,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 42 * ui),
            ] else
              SizedBox(height: 10 * ui),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onHome,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 18 * ui,
                  vertical: 20 * ui,
                ),
                decoration: BoxDecoration(
                  color: museum
                      ? const Color(0xFFFFFBF5)
                      : Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: museum
                      ? Border.all(color: const Color(0xFFE2BA8A))
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(Icons.home_outlined, color: secondary, size: 32 * ui),
                    SizedBox(width: 12 * ui),
                    Expanded(
                      child: Text(
                        'Início',
                        style: TextStyle(
                          color: museum
                              ? const Color(0xFF663300)
                              : Colors.white70,
                          fontSize: 22 * ui,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 26 * ui),
            ...List.generate(categories.length, (index) {
              final item = categories[index];
              if (item.isHeading) {
                return Padding(
                  padding: EdgeInsets.only(top: 22 * ui, bottom: 12 * ui),
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: accent,
                      fontSize: 15 * ui,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                );
              }
              final selected = item.label == selectedCategory;
              return Padding(
                key: _itemKeys.putIfAbsent(
                  item.label,
                  () => GlobalKey(),
                ),
                padding: EdgeInsets.only(bottom: 14 * ui),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onCategorySelected(item.label),
                  child: AnimatedContainer(
                    duration: TotemMotion.dur(context, 180),
                    padding: EdgeInsets.symmetric(
                      horizontal: 18 * ui,
                      vertical: 21 * ui,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? selectedSurface : surface,
                      borderRadius: BorderRadius.circular(12),
                      border: museum && !selected
                          ? Border.all(color: const Color(0xFFE2BA8A))
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          color: selected ? const Color(0xFFF3E4D1) : secondary,
                          size: 34 * ui,
                        ),
                        SizedBox(width: 12 * ui),
                        Expanded(
                          child: Text(
                            item.label,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : (museum
                                        ? const Color(0xFF663300)
                                        : Colors.white70),
                              fontSize: 21 * ui,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
                    ],
                  ),
                  if (_ringTop != null && _ringHeight != null)
                    AnimatedPositioned(
                      duration: TotemMotion.dur(context, 280),
                      curve: Curves.easeOutCubic,
                      top: _ringTop!,
                      left: 0,
                      right: 0,
                      height: _ringHeight!,
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: accent,
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accent.withValues(alpha: .35),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 18 * ui),
          Divider(
            color: (museum ? const Color(0xFFD6A36A) : Colors.white)
                .withValues(alpha: .18),
            height: 1,
          ),
          SizedBox(height: 18 * ui),
          _SidebarFooter(scale: ui, museum: museum, secondary: secondary),
        ],
      ),
    );
  }
}

class _SidebarFooter extends StatelessWidget {
  final double scale;
  final bool museum;
  final Color secondary;
  const _SidebarFooter({
    required this.scale,
    required this.museum,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    final ui = scale;
    final now = DateTime.now();
    final weekday = const [
      'segunda',
      'terça',
      'quarta',
      'quinta',
      'sexta',
      'sábado',
      'domingo',
    ][now.weekday - 1];
    return Row(
      children: [
        Container(
          width: 40 * ui,
          height: 40 * ui,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: secondary.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.school_outlined,
            color: secondary,
            size: 22 * ui,
          ),
        ),
        SizedBox(width: 12 * ui),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'UNICENTRO',
                style: TextStyle(
                  color: museum ? const Color(0xFF422100) : Colors.white,
                  fontSize: 15 * ui,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              SizedBox(height: 2 * ui),
              Text(
                'hoje é $weekday',
                style: TextStyle(
                  color: secondary,
                  fontSize: 13 * ui,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SidebarCategory {
  final String label;
  final IconData icon;
  final bool isHeading;
  const _SidebarCategory(this.label, this.icon) : isHeading = false;
  const _SidebarCategory.heading(this.label)
    : icon = Icons.circle,
      isHeading = true;
}

class _HomePage extends StatefulWidget {
  final ValueChanged<int> onModuleSelected;
  const _HomePage({required this.onModuleSelected});

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );
  late final Animation<Offset> _slide = Tween(
    begin: const Offset(0, 0.12),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (TotemMotion.reduced(context)) {
      _controller.duration = Duration.zero;
      if (!_controller.isCompleted) _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _attractTimer?.cancel();
    super.dispose();
  }

  static const _attractAfter = Duration(seconds: 60);
  Timer? _attractTimer;
  bool _attract = false;
  bool _attractArmed = false;

  @override
  void initState() {
    super.initState();
    _attractArmed = true;
    _armAttract();
  }

  void _armAttract() {
    _attractTimer?.cancel();
    if (!mounted) return;
    _attractTimer = Timer(_attractAfter, () {
      if (mounted && _attractArmed) setState(() => _attract = true);
    });
  }

  void _dismissAttract() {
    _attractTimer?.cancel();
    if (_attract && mounted) setState(() => _attract = false);
    _armAttract();
  }

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    final portrait = TotemMetrics.isPortrait(context);
    return Listener(
      onPointerDown: (_) => _dismissAttract(),
      child: Stack(
        key: const ValueKey('home'),
        fit: StackFit.expand,
        children: [
        Image.asset(
          'assets/images/home/home-background.png',
          fit: BoxFit.cover,
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black26, Color(0xCC071014), Color(0xF2071014)],
            ),
          ),
        ),
        FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: LayoutBuilder(
              builder: (context, viewport) => SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 70 * s,
                  vertical: 54 * s,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        (viewport.maxHeight - (108 * s)).clamp(0.0, double.infinity),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: portrait ? 1480 * s : 1650 * s,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _KickerBadge(scale: s),
                          SizedBox(height: 34 * s),
                          Text(
                            'E-LIXO',
                            style: TextStyle(
                              color: const Color(0xFFA8D94A),
                              fontSize: 92 * s,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 5,
                            ),
                          ),
                          SizedBox(height: 18 * s),
                          Text(
                            'Tecnologia, memória e futuro',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34 * s,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 52 * s),
                          _HighlightRow(scale: s, portrait: portrait),
                          SizedBox(height: 58 * s),
                          Text(
                            'O que você deseja explorar?',
                            style: TextStyle(
                              color: const Color(0xFFA9BBC0),
                              fontSize: 30 * s,
                            ),
                          ),
                          SizedBox(height: 34 * s),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final buttons = [
                                _HomeButton(
                                  key: const Key('home-elixo-button'),
                                  icon: Icons.recycling,
                                  label: 'E-LIXO',
                                  subtitle: 'Descarte e conserto',
                                  color: const Color(0xFFA8D94A),
                                  onTap: () => widget.onModuleSelected(0),
                                ),
                                _HomeButton(
                                  key: const Key('home-emuseu-button'),
                                  icon: Icons.museum_outlined,
                                  label: 'E-MUSEU',
                                  subtitle: 'Acervo de tecnologia',
                                  color: const Color(0xFFD39B63),
                                  onTap: () => widget.onModuleSelected(1),
                                ),
                              ];
                              final requiredRowWidth = (540 * s * 2) + (34 * s);
                              if (portrait ||
                                  constraints.maxWidth < requiredRowWidth) {
                                return Column(
                                  children: [
                                    buttons[0],
                                    SizedBox(height: 22 * s),
                                    buttons[1],
                                  ],
                                );
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buttons[0],
                                  SizedBox(width: 34 * s),
                                  buttons[1],
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 64 * s),
                          _TouchHint(scale: s),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_attract) const _AttractOverlay(),
      ],
      ),
    );
  }
}

class _AttractOverlay extends StatefulWidget {
  const _AttractOverlay();

  static const images = [
    'assets/images/home/home-background.png',
    'assets/images/museu/acervo_site/full/prologica-cp500.jpg',
    'assets/images/museu/acervo_site/full/Macintosh-Classic.jpg',
    'assets/images/museu/acervo_site/full/acer-3690.jpeg',
    'assets/images/museu/monitor-positivo.jpg',
    'assets/images/museu/epson-526x526.jpg',
  ];

  @override
  State<_AttractOverlay> createState() => _AttractOverlayState();
}

class _AttractOverlayState extends State<_AttractOverlay>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  Timer? _timer;
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) setState(() => _index = (_index + 1) % _AttractOverlay.images.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    final reduced = TotemMotion.reduced(context);
    final hint = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.touch_app_outlined, color: Colors.white, size: 40 * s),
        SizedBox(width: 16 * s),
        Text(
          'TOQUE PARA COMEÇAR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40 * s,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
          ),
        ),
      ],
    );
    return Container(
      key: const Key('attract-screen'),
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: TotemMotion.dur(context, 800),
            switchInCurve: Curves.easeInOut,
            child: Image.asset(
              _AttractOverlay.images[_index],
              key: ValueKey(_index),
              fit: BoxFit.contain,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black45, Colors.transparent, Color(0xE6071014)],
              ),
            ),
          ),
          Positioned(
            top: 60 * s,
            left: 0,
            right: 0,
            child: Text(
              'E-LIXO · E-MUSEU · UNICENTRO',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFA8D94A),
                fontSize: 26 * s,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          ),
          Positioned(
            bottom: 120 * s,
            left: 0,
            right: 0,
            child: reduced
                ? hint
                : FadeTransition(
                    opacity: Tween(begin: .45, end: 1.0).animate(_pulse),
                    child: hint,
                  ),
          ),
        ],
      ),
    );
  }
}

class _KickerBadge extends StatelessWidget {
  final double scale;
  const _KickerBadge({required this.scale});

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22 * s, vertical: 10 * s),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF2EC4B6).withValues(alpha: .55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9 * s,
            height: 9 * s,
            decoration: const BoxDecoration(
              color: Color(0xFF2EC4B6),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10 * s),
          Text(
            'TOTEM DIGITAL INTERATIVO · UNICENTRO',
            style: TextStyle(
              color: const Color(0xFFA9BBC0),
              fontSize: 18 * s,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightRow extends StatelessWidget {
  final double scale;
  final bool portrait;
  const _HighlightRow({required this.scale, required this.portrait});

  static const _items = [
    _HighlightData(
      Icons.recycling,
      'Descarte correto',
      'Protocolos de teste e conserto antes de descartar',
      Color(0xFFA8D94A),
    ),
    _HighlightData(
      Icons.museum_outlined,
      'Acervo de memória',
      'Peças e equipamentos que marcaram a informática',
      Color(0xFFD39B63),
    ),
    _HighlightData(
      Icons.eco_outlined,
      'Impacto ambiental',
      'Menos metais pesados no solo e na água',
      Color(0xFF2EC4B6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final s = scale;
    if (portrait) {
      return Column(
        children: [
          for (final item in _items) ...[
            _HighlightChip(scale: s, data: item, fullWidth: true),
            if (item != _items.last) SizedBox(height: 16 * s),
          ],
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final item in _items) ...[
          Expanded(child: _HighlightChip(scale: s, data: item, fullWidth: false)),
          if (item != _items.last) SizedBox(width: 20 * s),
        ],
      ],
    );
  }
}

class _HighlightData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  const _HighlightData(this.icon, this.title, this.description, this.color);
}

class _HighlightChip extends StatelessWidget {
  final double scale;
  final _HighlightData data;
  final bool fullWidth;
  const _HighlightChip({
    required this.scale,
    required this.data,
    required this.fullWidth,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: EdgeInsets.all(20 * s),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: data.color.withValues(alpha: .35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10 * s),
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.color, size: 26 * s),
          ),
          SizedBox(width: 14 * s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20 * s,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4 * s),
                Text(
                  data.description,
                  style: TextStyle(
                    color: const Color(0xFFA9BBC0),
                    fontSize: 17 * s,
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

class _TouchHint extends StatelessWidget {
  final double scale;
  const _TouchHint({required this.scale});

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.touch_app_outlined, color: const Color(0xFF6B8087), size: 26 * s),
        SizedBox(width: 10 * s),
        Text(
          'Toque em uma das opções acima para começar',
          style: TextStyle(
            color: const Color(0xFF6B8087),
            fontSize: 20 * s,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _HomeButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _HomeButton({
    super.key,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  State<_HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<_HomeButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.04 : 1,
        duration: TotemMotion.dur(context, 180),
        child: SizedBox(
          width: TotemMetrics.isPortrait(context) ? double.infinity : 540 * s,
          height: 220 * s,
          child: Card(
            color: widget.color.withValues(alpha: _hovered ? 0.22 : 0.14),
            elevation: _hovered ? 12 : 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: BorderSide(
                color: widget.color.withValues(alpha: 0.75),
                width: 1.5,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: widget.onTap,
              child: Padding(
                padding: EdgeInsets.all(30 * s),
                child: Row(
                  children: [
                    Icon(widget.icon, color: widget.color, size: 70 * s),
                    SizedBox(width: 26 * s),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.label,
                              style: TextStyle(
                                color: widget.color,
                                fontSize: 34 * s,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 8 * s),
                          Text(
                            widget.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 21 * s,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
