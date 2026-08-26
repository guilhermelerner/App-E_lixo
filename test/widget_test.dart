// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:e_lixo_app/main.dart';

void main() {
  testWidgets('apresenta os módulos principais do totem', (WidgetTester tester) async {
    await tester.pumpWidget(const ELixoApp());
    expect(find.text('E-LIXO | DESCARTE E CONSERTO'), findsOneWidget);
    expect(find.text('Protocolos de conserto'), findsOneWidget);
    expect(find.text('E-Museu'), findsOneWidget);
  });

  testWidgets('abre o E-Lixo no vídeo e deixa protocolos como única navegação', (WidgetTester tester) async {
    await tester.pumpWidget(const ELixoApp());
    await tester.tap(find.text('E-LIXO').last);
    await tester.pumpAndSettle();

    expect(find.text('Protocolos de conserto'), findsOneWidget);
    expect(find.text('O que fazer com o lixo eletrônico?'), findsOneWidget);
    expect(find.text('Computadores'), findsNothing);
    expect(find.text('Periféricos'), findsNothing);
    expect(find.text('Componentes'), findsNothing);
    expect(find.text('Outros'), findsNothing);
  });

  testWidgets('sidebar ocupa 24 por cento da largura do totem vertical', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(2160, 3840));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ELixoApp());
    await tester.tap(find.text('E-LIXO').last);
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byKey(const Key('totem-sidebar'))).width, closeTo(518.4, 1));
    expect(find.text('O que fazer com o lixo eletrônico?'), findsOneWidget);
  });
}
