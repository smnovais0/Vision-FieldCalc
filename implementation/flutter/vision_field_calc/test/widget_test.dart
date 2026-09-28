import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vision_field_calc/ai_gateway.dart';
import 'package:vision_field_calc/main.dart';
import 'package:vision_field_calc/vision_theme.dart';

Finder editableIn(Key key) => find.descendant(of: find.byKey(key), matching: find.byType(EditableText));

Finder selectableContaining(String part) => find.byWidgetPredicate(
      (widget) => widget is SelectableText && (widget.data?.contains(part) ?? false) || widget is Text && (widget.data?.contains(part) ?? false),
    );

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(const VisionFieldCalcApp());
  await tester.pump();
}

Future<void> _search(WidgetTester tester, String query) async {
  await tester.enterText(editableIn(const Key('problem-field')), query);
  await tester.tap(find.byKey(const Key('route-local')));
  await tester.pump();
}

void main() {
  testWidgets('desktop calcula o círculo localmente com as margens da referência', (tester) async {
    await _pumpAt(tester, const Size(1280, 720));
    expect(find.text('Vision Field Calc'), findsOneWidget);
    expect(find.text('Cálculo local'), findsOneWidget);
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).locale, const Locale('pt', 'PT'));
    final padding = tester.widget<Padding>(find.byKey(const Key('page-padding')));
    expect((padding.padding as EdgeInsets).left, VisionTheme.space64);
    expect(Theme.of(tester.element(find.text('Vision Field Calc'))).colorScheme.primary, VisionTheme.black);

    await _search(tester, 'circulo pelo raio');
    expect(find.text('Círculo pelo raio'), findsWidgets);
    await tester.enterText(editableIn(const Key('input-r')), '2');
    await tester.tap(find.byKey(const Key('calculate-local')));
    await tester.pump();

    expect(find.byKey(const Key('result-value')), findsOneWidget);
    expect(selectableContaining('12.56637061435917'), findsWidgets);
    expect(selectableContaining('∫'), findsWidgets);
    expect(find.byKey(const Key('review-pending')), findsNothing);
    expect(tester.getSize(find.byKey(const Key('calculate-local'))).height, greaterThanOrEqualTo(44));
  });

  testWidgets('revisão pendente permanece visível no resultado', (tester) async {
    await _pumpAt(tester, const Size(1440, 900));
    await _search(tester, 'carga uniforme da viga');
    await tester.enterText(editableIn(const Key('input-uniform_load')), '5000');
    await tester.enterText(editableIn(const Key('input-span')), '4');
    await tester.tap(find.byKey(const Key('calculate-local')));
    await tester.pump();
    expect(find.byKey(const Key('review-pending')), findsOneWidget);
    expect(selectableContaining('10000'), findsWidgets);
    expect(find.textContaining('certifica'), findsOneWidget);
  });

  testWidgets('sem fórmula local a IA não calcula sem gateway configurado', (tester) async {
    await _pumpAt(tester, const Size(1280, 720));
    await _search(tester, 'forma nao catalogada');
    expect(find.text('Interpretação por IA'), findsOneWidget);
    expect(find.byKey(const Key('result-value')), findsNothing);
    await tester.tap(find.byKey(const Key('continue-ai')));
    await tester.pump();
    expect(find.textContaining('Vision AI Gateway ainda não está configurado'), findsWidgets);
    expect(find.byKey(const Key('result-value')), findsNothing);
  });

  testWidgets('móvel usa margem de 20 e catálogo recolhível', (tester) async {
    await _pumpAt(tester, const Size(390, 844));
    final padding = tester.widget<Padding>(find.byKey(const Key('page-padding')));
    expect((padding.padding as EdgeInsets).left, VisionTheme.space20);
    expect(find.byKey(const Key('catalog-list')), findsNothing);
    expect(find.byKey(const Key('math-notation')), findsOneWidget);
    expect(selectableContaining('∫'), findsWidgets);
    await tester.tap(find.byKey(const Key('open-catalog')));
    await tester.pump();
    expect(find.byKey(const Key('catalog-list')), findsOneWidget);
    expect(find.text('Áreas'), findsWidgets);
  });

  testWidgets('domínio inválido aparece no ecrã e o integral local resolve', (tester) async {
    await _pumpAt(tester, const Size(1440, 900));
    await _search(tester, 'quadrado');
    await tester.enterText(editableIn(const Key('input-a')), '0');
    await tester.tap(find.byKey(const Key('calculate-local')));
    await tester.pump();
    expect(find.textContaining('domínio'), findsWidgets);

    await tester.drag(find.byKey(const Key('menu-tabs')), const Offset(-520, 0));
    await tester.pump();
    await tester.tap(find.text('Limites e cálculo'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('solver-run')));
    await tester.pump();
    expect(find.byKey(const Key('solver-workspace')), findsOneWidget);
    expect(selectableContaining('∫'), findsWidgets);
  });

  testWidgets('pedido ambíguo pede confirmação e a proposta local não usa o número remoto', (tester) async {
    await _pumpAt(tester, const Size(1440, 900));
    await _search(tester, 'circulo');
    expect(find.text('Interpretação por IA'), findsOneWidget);
    expect(find.byKey(const Key('result-value')), findsNothing);

    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'formula_id': 'AREA_CIRCLE_RADIUS',
          'display_math': 'π × r²',
          'variables': {'r': 2},
          'units': {'r': 'u'},
          'assumptions': ['raio positivo'],
          'missing_fields': [],
          'confidence': 0.4,
          'steps': ['usar a fórmula local'],
          'provider_mode': 'managed',
          'result': 999,
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    await tester.pumpWidget(VisionFieldCalcApp(gateway: VisionAiGateway(baseUrl: 'https://gateway.test', client: client)));
    await tester.pump();
    await _search(tester, 'forma nao catalogada');
    await tester.tap(find.byKey(const Key('continue-ai')));
    await tester.pump();
    expect(find.byKey(const Key('ai-proposal')), findsOneWidget);
    expect(find.textContaining('999'), findsNothing);
    await tester.tap(find.byKey(const Key('calculate-local')));
    await tester.pump();
    expect(selectableContaining('12.56637061435917'), findsWidgets);
    expect(find.textContaining('999'), findsNothing);
  });

  testWidgets('tablet 768 mantém coluna única e fundo claro', (tester) async {
    await _pumpAt(tester, const Size(768, 1024));
    final padding = tester.widget<Padding>(find.byKey(const Key('page-padding')));
    expect((padding.padding as EdgeInsets).left, VisionTheme.space20);
    expect(find.byKey(const Key('open-catalog')), findsOneWidget);
    expect(tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor, VisionTheme.canvas);
  });
}
