import 'package:flutter/material.dart';
import 'modules/e_lixo/e_lixo_page.dart';
import 'modules/educa/educa_page.dart';
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

  final List<Widget> _pages = const [
    ELixoPage(),
    EducaPage(),
    EMuseuPage(),
  ];

  final List<_NavItem> _navItems = const [
    _NavItem(
      label: 'E-Lixo',
      icon: Icons.delete_outline,
      activeIcon: Icons.delete,
      color: Color(0xFF2E7D32),
    ),
    _NavItem(
      label: 'Educa',
      icon: Icons.school_outlined,
      activeIcon: Icons.school,
      color: Color(0xFF1565C0),
    ),
    _NavItem(
      label: 'E-Museu',
      icon: Icons.museum_outlined,
      activeIcon: Icons.museum,
      color: Color(0xFF6A1B9A),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: _navItems[_currentIndex].color,
          unselectedItemColor: Colors.grey[500],
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          elevation: 0,
          items: _navItems
              .map(
                (item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  activeIcon: Icon(item.activeIcon, color: item.color),
                  label: item.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
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