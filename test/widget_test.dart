import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:e_lixo_app/main.dart';

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

  testWidgets(
    'home mantém as duas escolhas visíveis no viewport lógico do totem',
    (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(const ELixoApp());
      await tester.pumpAndSettle();

      final eLixo = find.byKey(const Key('home-elixo-button'));
      final eMuseu = find.byKey(const Key('home-emuseu-button'));
      expect(eLixo, findsOneWidget);
      expect(eMuseu, findsOneWidget);
      expect(tester.getBottomRight(eMuseu).dy, lessThanOrEqualTo(768));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('selecionar um módulo solicita modo imersivo', (tester) async {
    configureViewport(tester);
    var immersiveRequests = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: MainNavigationPage(onEnterImmersive: () => immersiveRequests++),
      ),
    );

    await openModule(tester, 'home-elixo-button');

    expect(immersiveRequests, 1);
    expect(find.byKey(const Key('video-landing')), findsOneWidget);
  });

  testWidgets('E-Lixo abre no vídeo e a lateral mostra somente protocolos', (
    tester,
  ) async {
    configureViewport(tester);
    await tester.pumpWidget(const ELixoApp());
    await openModule(tester, 'home-elixo-button');

    expect(find.byKey(const Key('video-landing')), findsOneWidget);
    expect(find.text('Protocolos de conserto'), findsOneWidget);
    expect(find.text('ECO TECNOLOGIA'), findsNothing);
    expect(find.byIcon(Icons.recycling), findsNothing);
    expect(
      find.text('Use a barra lateral para acessar os protocolos de conserto.'),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('protocolos oferecem retorno explícito ao vídeo', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(const ELixoApp());
    await openModule(tester, 'home-elixo-button');

    await tester.tap(find.text('Protocolos de conserto'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('protocols-page')), findsOneWidget);
    expect(find.text('Voltar ao vídeo'), findsOneWidget);

    await tester.tap(find.text('Voltar ao vídeo'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('video-landing')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('E-Museu prioriza a peça e remove identidade duplicada', (
    tester,
  ) async {
    configureViewport(tester);
    await tester.pumpWidget(const ELixoApp());
    await openModule(tester, 'home-emuseu-button');

    final exhibit = find.byKey(const Key('museum-exhibit-card'));
    expect(exhibit, findsOneWidget);
    expect(tester.getTopLeft(exhibit).dy, lessThan(190));
    expect(find.text('E-MUSEU'), findsOneWidget);
    expect(find.text('Visita interativa • E-Museu'), findsNothing);
    expect(find.byIcon(Icons.collections_bookmark_outlined), findsNothing);
    expect(
      find.byKey(const Key('video-landing'), skipOffstage: false),
      findsNothing,
    );
    expect(
      find.textContaining('Equipamentos multifuncionais ajudaram'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('categorias do E-Museu aparecem somente na barra lateral', (
    tester,
  ) async {
    configureViewport(tester);
    await tester.pumpWidget(const ELixoApp());
    await openModule(tester, 'home-emuseu-button');

    for (final category in const [
      'Todos',
      'Componentes',
      'Computadores - PC',
      'Outros',
      'Periféricos',
    ]) {
      expect(find.text(category), findsOneWidget);
    }

    await tester.tap(find.text('Componentes'));
    await tester.pumpAndSettle();

    expect(find.text('ASUS M2N68-AM SE2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('monitor Positivo exibe conteúdo de monitor, não de mouse', (
    tester,
  ) async {
    configureViewport(tester);
    await tester.pumpWidget(const ELixoApp());
    await openModule(tester, 'home-emuseu-button');

    for (var step = 0; step < 8; step++) {
      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pumpAndSettle();
    }

    expect(find.text('Monitor CRT Positivo'), findsOneWidget);
    expect(find.textContaining('Mouse óptico sem fio'), findsNothing);
    expect(find.textContaining('tubo de raios catódicos'), findsOneWidget);
  });

  testWidgets('Sobre o E-Museu abre como diálogo central amplo', (
    tester,
  ) async {
    configureViewport(tester);
    await tester.pumpWidget(const ELixoApp());
    await openModule(tester, 'home-emuseu-button');

    await tester.tap(find.byKey(const Key('museum-about-button')));
    await tester.pumpAndSettle();

    final dialog = find.byKey(const Key('museum-about-dialog'));
    expect(dialog, findsOneWidget);
    expect(tester.getSize(dialog).width, greaterThan(250));
    expect(find.text('Sobre o E-Museu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('layout permanece sem overflow no tamanho físico 2160 por 3840', (
    tester,
  ) async {
    configureViewport(tester, size: const Size(2160, 3840));
    await tester.pumpWidget(const ELixoApp());
    await openModule(tester, 'home-emuseu-button');

    expect(
      tester.getSize(find.byKey(const Key('totem-sidebar'))).width,
      closeTo(669.6, 1),
    );
    expect(find.byKey(const Key('museum-exhibit-card')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('vídeo e protocolos cabem no totem físico 2160 por 3840', (
    tester,
  ) async {
    configureViewport(tester, size: const Size(2160, 3840));
    await tester.pumpWidget(const ELixoApp());
    await openModule(tester, 'home-elixo-button');

    expect(find.byKey(const Key('video-landing')), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Protocolos de conserto'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('protocols-page')), findsOneWidget);
    expect(find.text('Voltar ao vídeo'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
