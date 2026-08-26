import 'package:flutter/material.dart';
import 'core/totem_metrics.dart';
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
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  bool _showHome = true;
  String _selectedELixoCategory = 'Vídeo';
  String _selectedMuseuCategory = 'Todos';

  List<Widget> get _pages => [
        ELixoPage(selectedCategory: _selectedELixoCategory),
        EMuseuPage(key: ValueKey(_selectedMuseuCategory), initialCategory: _selectedMuseuCategory),
      ];

  List<_SidebarCategory> get _sidebarCategories => _currentIndex == 0
      ? const [
          _SidebarCategory.heading('NAVEGAÇÃO'),
          _SidebarCategory('Protocolos de conserto', Icons.build_circle_outlined),
        ]
      : const [
          _SidebarCategory.heading('CATEGORIAS DO ACERVO'),
          _SidebarCategory('Todos', Icons.grid_view),
          _SidebarCategory('Componentes', Icons.memory),
          _SidebarCategory('Computadores - PC', Icons.computer),
          _SidebarCategory('Outros', Icons.devices_other),
          _SidebarCategory('Periféricos', Icons.mouse),
        ];

  final List<_NavItem> _navItems = const [
    _NavItem(
      label: 'E-Lixo',
      icon: Icons.delete_outline,
      activeIcon: Icons.delete,
      color: Color(0xFF2E7D32),
    ),
    _NavItem(
      label: 'E-Museu',
      icon: Icons.museum_outlined,
      activeIcon: Icons.museum,
      color: Color(0xFFA0522D),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101820),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        switchInCurve: Curves.easeOutCubic,
        child: _showHome
            ? _HomePage(onModuleSelected: (index) => setState(() {
                _currentIndex = index;
                if (index == 0) _selectedELixoCategory = 'Vídeo';
                if (index == 1) _selectedMuseuCategory = 'Todos';
                _showHome = false;
              }))
            : Row(
                key: const ValueKey('modules'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TotemSidebar(
                    moduleTitle: _currentIndex == 0 ? 'E-LIXO' : 'E-MUSEU',
                    categories: _sidebarCategories,
                    selectedCategory: _currentIndex == 0 ? _selectedELixoCategory : _selectedMuseuCategory,
                    onHome: () => setState(() => _showHome = true),
                    onCategorySelected: (category) => setState(() {
                      if (_currentIndex == 0) {
                        _selectedELixoCategory = category;
                      } else {
                        _selectedMuseuCategory = category;
                      }
                    }),
                  ),
                  Expanded(child: IndexedStack(index: _currentIndex, children: _pages)),
                ],
              ),
      ),
    );
  }
}

class _TotemSidebar extends StatelessWidget {
  final String moduleTitle;
  final List<_SidebarCategory> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback onHome;

  const _TotemSidebar({required this.moduleTitle, required this.categories, required this.selectedCategory, required this.onHome, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    final compact = MediaQuery.sizeOf(context).width < 700;
    final ui = compact ? .62 : s;
    final museum = moduleTitle == 'E-MUSEU';
    final background = museum ? const Color(0xFFF3E4D1) : const Color(0xFF101820);
    final surface = museum ? const Color(0xFFFFFBF5) : const Color(0xFF182A32);
    final selectedSurface = museum ? const Color(0xFF663300) : const Color(0xFF964B00);
    final primary = museum ? const Color(0xFF422100) : Colors.white;
    final secondary = museum ? const Color(0xFF966B46) : const Color(0xFFA9BBC0);
    final accent = museum ? const Color(0xFFB25900) : const Color(0xFF2EC4B6);

    return Container(
      key: const Key('totem-sidebar'),
      width: TotemMetrics.sidebarWidth(context),
      height: double.infinity,
      padding: EdgeInsets.fromLTRB(28 * ui, 42 * ui, 28 * ui, 30 * ui),
      decoration: BoxDecoration(
        color: background,
        border: museum ? const Border(right: BorderSide(color: Color(0xFFD6A36A), width: 1.2)) : null,
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 14, offset: Offset(3, 0))],
      ),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(museum ? Icons.account_balance : Icons.recycling, color: accent, size: 62 * ui),
          SizedBox(height: 18 * ui),
          Text(museum ? 'E-MUSEU' : 'ECO TECNOLOGIA', style: TextStyle(color: primary, fontSize: 30 * ui, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          SizedBox(height: 6 * ui),
          if (!compact) Text(museum ? 'Galeria de tecnologia' : 'Tecnologia, cuidado e futuro', style: TextStyle(color: secondary, fontSize: 18 * ui)),
          SizedBox(height: 52 * ui),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onHome,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 18 * ui, vertical: 20 * ui),
              decoration: BoxDecoration(color: museum ? const Color(0xFFFFFBF5) : Colors.white.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: museum ? Border.all(color: const Color(0xFFE2BA8A)) : null),
              child: Row(children: [Icon(Icons.home_outlined, color: secondary, size: 32 * ui), SizedBox(width: 12 * ui), Expanded(child: Text('Início', style: TextStyle(color: museum ? const Color(0xFF663300) : Colors.white70, fontSize: 22 * ui, fontWeight: FontWeight.w600)))]),
            ),
          ),
          SizedBox(height: 36 * ui),
          Text(moduleTitle, style: TextStyle(color: accent, fontSize: 17 * ui, fontWeight: FontWeight.bold, letterSpacing: 1.8)),
          SizedBox(height: 16 * ui),
          ...List.generate(categories.length, (index) {
            final item = categories[index];
            if (item.isHeading) {
              return Padding(padding: EdgeInsets.only(top: 22 * ui, bottom: 12 * ui), child: Text(item.label, style: TextStyle(color: accent, fontSize: 15 * ui, fontWeight: FontWeight.bold, letterSpacing: 1.5)));
            }
            final selected = item.label == selectedCategory;
            return Padding(
              padding: EdgeInsets.only(bottom: 14 * ui),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onCategorySelected(item.label),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(horizontal: 18 * ui, vertical: 21 * ui),
                  decoration: BoxDecoration(color: selected ? selectedSurface : surface, borderRadius: BorderRadius.circular(12), border: museum && !selected ? Border.all(color: const Color(0xFFE2BA8A)) : null),
                  child: Row(children: [Icon(item.icon, color: selected ? const Color(0xFFF3E4D1) : secondary, size: 34 * ui), SizedBox(width: 12 * ui), Expanded(child: Text(item.label, style: TextStyle(color: selected ? Colors.white : (museum ? const Color(0xFF663300) : Colors.white70), fontSize: 21 * ui, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)))]),
                ),
              ),
            );
          }),
          SizedBox(height: 36 * ui),
          if (!compact) Text(museum ? 'Visita interativa • E-Museu' : 'Totem interativo • E-Lixo', style: TextStyle(color: museum ? const Color(0xFF966B46) : Colors.white54, fontSize: 15 * ui)),
        ]),
      ),
    );
  }
}

class _SidebarCategory {
  final String label;
  final IconData icon;
  final bool isHeading;
  const _SidebarCategory(this.label, this.icon) : isHeading = false;
  const _SidebarCategory.heading(this.label) : icon = Icons.circle, isHeading = true;
}

class _HomePage extends StatefulWidget {
  final ValueChanged<int> onModuleSelected;
  const _HomePage({required this.onModuleSelected});

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
  late final Animation<double> _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween(begin: const Offset(0, 0.12), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Stack(
      key: const ValueKey('home'),
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/home/home-background.png', fit: BoxFit.cover),
        Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black26, Color(0xCC071014), Color(0xF2071014)]))),
        FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1650 * s),
                child: Padding(
                  padding: EdgeInsets.all(52 * s),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Image.asset('assets/images/home/unicentro-logo-neg.png', width: 250 * s, height: 225 * s, fit: BoxFit.contain),
                    SizedBox(height: 24 * s),
                    Text('E-LIXO', style: TextStyle(color: const Color(0xFFA8D94A), fontSize: 92 * s, fontWeight: FontWeight.w800, letterSpacing: 5)),
                    SizedBox(height: 18 * s),
                    Text('Tecnologia, memória e futuro', style: TextStyle(color: Colors.white, fontSize: 34 * s, fontWeight: FontWeight.w400)),
                    SizedBox(height: 78 * s),
                    Text('O que você deseja explorar?', style: TextStyle(color: const Color(0xFFA9BBC0), fontSize: 30 * s)),
                    SizedBox(height: 34 * s),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final buttons = [
                          _HomeButton(icon: Icons.recycling, label: 'E-LIXO', subtitle: 'Descarte e conserto', color: const Color(0xFFA8D94A), onTap: () => widget.onModuleSelected(0)),
                          _HomeButton(icon: Icons.museum_outlined, label: 'E-MUSEU', subtitle: 'Acervo de tecnologia', color: const Color(0xFFD39B63), onTap: () => widget.onModuleSelected(1)),
                        ];
                        if (constraints.maxWidth < 1000) {
                          return Column(children: [buttons[0], SizedBox(height: 18 * s), buttons[1]]);
                        }
                        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [buttons[0], SizedBox(width: 34 * s), buttons[1]]);
                      },
                    ),
                  ]),
                ),
              ),
            ),
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
  const _HomeButton({required this.icon, required this.label, required this.subtitle, required this.color, required this.onTap});

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
          duration: const Duration(milliseconds: 180),
          child: SizedBox(
            width: 540 * s,
            height: 220 * s,
            child: Card(
              color: widget.color.withOpacity(_hovered ? 0.22 : 0.14),
              elevation: _hovered ? 12 : 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: BorderSide(color: widget.color.withOpacity(0.75), width: 1.5)),
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: widget.onTap,
                child: Padding(padding: EdgeInsets.all(30 * s), child: Row(children: [Icon(widget.icon, color: widget.color, size: 70 * s), SizedBox(width: 26 * s), Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.label, style: TextStyle(color: widget.color, fontSize: 34 * s, fontWeight: FontWeight.bold)), SizedBox(height: 8 * s), Text(widget.subtitle, style: TextStyle(color: Colors.white70, fontSize: 21 * s))])])),
              ),
            ),
          ),
        ),
      );
  }
}

class _SidebarInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool museum;
  const _SidebarInfo({required this.icon, required this.text, this.museum = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(children: [Icon(icon, color: museum ? const Color(0xFFB25900) : const Color(0xFFA9BBC0), size: 22), const SizedBox(width: 12), Expanded(child: Text(text, style: TextStyle(color: museum ? const Color(0xFF805936) : Colors.white70, fontSize: 15)))]),
      );
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Color color;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.color,
  });
}
