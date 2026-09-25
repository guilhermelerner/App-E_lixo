import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:e_lixo_app/main.dart';
import 'package:e_lixo_app/widgets/embedded_video.dart';

class MediaAppWithReducedMotion extends StatelessWidget {
  const MediaAppWithReducedMotion({super.key});

  @override
  Widget build(BuildContext context) {
    return const MediaQuery(
      data: MediaQueryData(disableAnimations: true),
      child: ELixoApp(),
    );
  }
}

void main() {
  void configureViewport(
    WidgetTester tester, {
    Size size = const Size(432, 768),
    double devicePixelRatio = 1,
  }) {
    tester.view.devicePixelRatio = devicePixelRatio;
    tester.view.physicalSize = size * devicePixelRatio;
    addTearDown(() {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    });
  }

  Future<void> openModule(WidgetTester tester, String key) async {
    await tester.tap(find.byKey(Key(key)));
    await tester.pumpAndSettle();
  }

  testWidgets('vídeo ausente não quebra e mostra estado seguro', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: EmbeddedVideo())));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
    // Ou loading ou aviso offline — ambos seguros.
    final loading = find.byType(CircularProgressIndicator);
    final warning = find.textContaining('offline');
    expect(
      loading.evaluate().isNotEmpty || warning.evaluate().isNotEmpty,
      isTrue,
    );
  });

  testWidgets('navegação vídeo -> protocolos -> voltar', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(const ELixoApp());
    await openModule(tester, 'home-elixo-button');
    expect(find.byKey(const Key('video-landing')), findsOneWidget);

    await tester.tap(find.text('Protocolos de conserto'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('protocols-page')), findsOneWidget);

    await tester.tap(find.text('Voltar ao vídeo'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('video-landing')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('troca de categoria no E-Museu filtra peças', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(const ELixoApp());
    await openModule(tester, 'home-emuseu-button');
    expect(find.byKey(const Key('museum-exhibit-card')), findsOneWidget);

    await tester.tap(find.text('Componentes'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('museum-exhibit-card')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('guia da sidebar abre protocolos e rola até o item', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(const ELixoApp());
    await openModule(tester, 'home-elixo-button');

    await tester.tap(find.text('Computadores'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('protocols-page')), findsOneWidget);
    expect(find.text('Computadores'), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Localização de descarte'));
    await tester.pumpAndSettle();
    expect(find.text('LOCALIZAÇÃO DE DESCARTE'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('checklist de protocolos marca progresso', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(const ELixoApp());
    await openModule(tester, 'home-elixo-button');

    await tester.tap(find.text('Protocolos de conserto'));
    await tester.pumpAndSettle();
    expect(find.text('0 de 5 protocolos concluídos'), findsOneWidget);

    await tester.tap(find.text('Marcar como lido').first);
    await tester.pumpAndSettle();
    expect(find.text('1 de 5 protocolos concluídos'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('modo movimento reduzido não quebra', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(
      const MediaAppWithReducedMotion(),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('idle avisa e permite continuar', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(const ELixoApp());
    await openModule(tester, 'home-elixo-button');

    await tester.pump(const Duration(seconds: 106));
    await tester.pump();
    expect(find.byKey(const Key('idle-warning-dialog')), findsOneWidget);

    await tester.tap(find.text('Continuar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byKey(const Key('idle-warning-dialog')), findsNothing);
    expect(find.byKey(const Key('video-landing')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('busca do acervo filtra peças', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(const ELixoApp());
    await openModule(tester, 'home-emuseu-button');

    await tester.tap(find.byKey(const Key('museum-search-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('museum-search-field')),
      'epson',
    );
    await tester.pumpAndSettle();
    expect(find.text('Impressora Epson'), findsOneWidget);
    expect(find.text('1 de 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('quiz pontua e mostra resultado', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(const ELixoApp());
    await openModule(tester, 'home-elixo-button');

    await tester.tap(find.text('Quiz'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('quiz-page')), findsOneWidget);

    await tester.tap(find.text('Em ponto de coleta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Próxima pergunta'));
    await tester.pumpAndSettle();
    expect(find.textContaining('PERGUNTA 2 DE 5'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('descanso aparece após 60s e sai no toque', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(const ELixoApp());
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('attract-screen')), findsNothing);

    await tester.pump(const Duration(seconds: 61));
    await tester.pump();
    expect(find.byKey(const Key('attract-screen')), findsOneWidget);

    await tester.tap(find.text('TOQUE PARA COMEÇAR'));
    await tester.pump();
    expect(find.byKey(const Key('attract-screen')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('descanso mostra "Sejam bem-vindos" e apenas o Instagram', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(const ELixoApp());
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 61));
    await tester.pump();
    expect(find.byKey(const Key('attract-screen')), findsOneWidget);
    expect(find.text('SEJAM BEM-VINDOS'), findsOneWidget);
    expect(find.text('Siga-nos nas redes sociais'), findsOneWidget);
    expect(find.text('@lixo_eletronico_unicentro'), findsOneWidget);
    expect(find.byKey(const Key('attract-instagram-icon')), findsOneWidget);
    expect(find.textContaining('youtube'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('descanso sem overflow em 2160x3840', (tester) async {
    configureViewport(tester, size: const Size(2160, 3840));
    await tester.pumpWidget(const ELixoApp());
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 61));
    await tester.pump();
    expect(find.byKey(const Key('attract-screen')), findsOneWidget);
    expect(find.text('SEJAM BEM-VINDOS'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('home + módulos sem overflow em 2160x3840', (tester) async {
    configureViewport(tester, size: const Size(2160, 3840));
    await tester.pumpWidget(const ELixoApp());
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-elixo-button')), findsOneWidget);
    expect(tester.takeException(), isNull);

    await openModule(tester, 'home-elixo-button');
    expect(find.byKey(const Key('video-landing')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
