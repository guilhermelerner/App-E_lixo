import 'dart:async';
import 'package:e_lixo_app/modules/e_museu/e_museu_acervo_page.dart';
import 'package:flutter/material.dart';

class EMuseuHomePage extends StatefulWidget {
  const EMuseuHomePage({super.key});

  @override
  State<EMuseuHomePage> createState() => _EMuseuHomePageState();
}

class _EMuseuHomePageState extends State<EMuseuHomePage> {
  final PageController _pageController = PageController();
  Timer? _timer;

  int _currentIndex = 0;
  bool _goingForward = true;
  double _scrollOffset = 0.0;

  final List<Map<String, String>> _panels = [
    {
      'image': 'assets/images/museu/bg1.jpg',
      'title': 'Sobre o E-Museu',
      'desc':
          'O E-Museu é parte do projeto E-Lixo, que atua na coleta e destinação adequada de lixo eletrônico. Nossa proposta é reunir e expor equipamentos eletrônicos, como computadores antigos, impressoras e outros dispositivos que marcaram a evolução tecnológica.',
    },
    {
      'image': 'assets/images/museu/bg2.jpg',
      'title': 'Exposições Virtuais',
      'desc': 'Conheça nosso acervo digital exclusivo.',
    },
  ];

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        _scrollOffset = _pageController.page ?? 0.0;
      });
    });

    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 12), (timer) {
      if (_goingForward) {
        if (_currentIndex < _panels.length - 1) {
          _currentIndex++;
        } else {
          _goingForward = false;
          _currentIndex--;
        }
      } else {
        if (_currentIndex > 0) {
          _currentIndex--;
        } else {
          _goingForward = true;
          _currentIndex++;
        }
      }

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'E-Museu',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.brown.withValues(alpha: 0.9),
        elevation: 2,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _panels.length,
        onPageChanged: (index) {
          _currentIndex = index;
          if (_currentIndex == 0) {
            _goingForward = true;
          } else if (_currentIndex == _panels.length - 1) {
            _goingForward = false;
          }
        },
        itemBuilder: (context, index) {
          double pageOffset = index - _scrollOffset;
          double textTranslation = pageOffset * 180;

          Widget cardContent = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _panels[index]['title']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _panels[index]['desc']!,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              if (index == 1) ...[
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Toque para conhecer',
                      style: TextStyle(
                        color: Color(0xFFF5F5DC),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      color: Color(0xFFF5F5DC),
                      size: 16,
                    ),
                  ],
                ),
              ],
            ],
          );

          return Stack(
            children: [
              Image.asset(
                _panels[index]['image']!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(textTranslation, 0),
                      child: Opacity(
                        opacity: (1 - pageOffset.abs()).clamp(0.0, 1.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            index == 1
                                ? ElevatedButton(
                                    onPressed: () async {
                                      _timer?.cancel();

                                      await Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => const EMuseuAcervoPage(),
                                          transitionsBuilder: (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) {
                                            const begin = Offset(1.0, 0.0);
                                            const end = Offset.zero;
                                            const curve = Curves.easeInOutCubic;
                                            var tween = Tween(
                                              begin: begin,
                                              end: end,
                                            ).chain(CurveTween(curve: curve));
                                            return SlideTransition(
                                              position: animation.drive(tween),
                                              child: child,
                                            );
                                          },
                                          transitionDuration: const Duration(
                                            milliseconds: 550,
                                          ),
                                          reverseTransitionDuration: const Duration(
                                            milliseconds: 500,
                                          ),
                                        ),
                                      );
                                      _startAutoPlay();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.brown.withValues(alpha: 0.7),
                                      padding: const EdgeInsets.all(16),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      // Altera o efeito ripple para branco sutil, removendo o tom verde
                                      overlayColor: Colors.white.withValues(alpha: 0.15),
                                    ),
                                    child: cardContent,
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.brown.withValues(alpha: 0.7),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: cardContent,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}