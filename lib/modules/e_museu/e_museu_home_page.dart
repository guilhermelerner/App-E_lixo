import 'dart:async';
import 'package:flutter/material.dart';

class EMuseuHomePage extends StatefulWidget {
  const EMuseuHomePage({super.key});

  @override
  State<EMuseuHomePage> createState() => _EMuseuHomePageState();
}

class _EMuseuHomePageState extends State<EMuseuHomePage> {
  // Mudamos para PageController para capturar o scroll em tempo real (essencial para o Parallax)
  final PageController _pageController = PageController();
  Timer? _timer;

  int _currentIndex = 0;
  bool _goingForward = true;
  double _scrollOffset = 0.0; // Controla a posição exata do scroll

  // Dados dos painéis (Fundo + Texto específico de cada um)
  final List<Map<String, String>> _panels = [
    {
      'image': 'assets/images/museu/bg1.jpg',
      'title': 'Sobre o E-Museu',
      'desc': 'O E-Museu é parte do projeto E-Lixo, que atua na coleta e destinação adequada de lixo eletrônico. Nossa proposta é reunir e expor equipamentos eletrônicos, como computadores antigos, impressoras e outros dispositivos que marcaram a evolução tecnológica.',
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
    
    // Ouvinte para atualizar o offset do scroll e criar o efeito visual fluído
    _pageController.addListener(() {
      setState(() {
        _scrollOffset = _pageController.page ?? 0.0;
      });
    });

    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 13), (timer) {
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
        duration: const Duration(seconds: 3),
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
        iconTheme: const IconThemeData(
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 4.0,
              color: Colors.black45,
              offset: Offset(1.5, 1.5),
            ),
          ],
        ),
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
          // --- CÁLCULO DO PARALLAX ---
          // Descobrimos o quanto a página atual se moveu em relação ao scroll
          double pageOffset = index - _scrollOffset;
          
          // O texto vai se mover horizontalmente multiplicando esse offset.
          // Quanto maior o multiplicador (ex: 150), mais rápido o texto se move (Efeito Parallax)
          double textTranslation = pageOffset * 180; 

          return Stack(
            children: [
              // 1. Imagem de Fundo (Se move na velocidade normal do slide)
              Image.asset(
                _panels[index]['image']!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              
              // Camada escura opcional para dar leitura ao texto


              // 2. Bloco de Texto com Efeito Parallax
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    // O Transform.translate move o texto horizontalmente baseado no scroll
                    child: Transform.translate(
                      offset: Offset(textTranslation, 0),
                      // Efeito extra: esmaecer (fade) o texto enquanto ele sai da tela
                      child: Opacity(
                        opacity: (1 - pageOffset.abs()).clamp(0.0, 1.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.brown.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
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
                                ],
                              ),
                            ),
                            const SizedBox(height: 40), // Empurra o bloco um pouco para cima do rodapé
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