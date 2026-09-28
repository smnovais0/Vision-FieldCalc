import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
    expect(find.textContaining('Vision AI Gateway ainda não está configurado'), findsOneWidget);
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

  testWidgets('tablet 768 mantém coluna única e fundo claro', (tester) async {
    await _pumpAt(tester, const Size(768, 1024));
    final padding = tester.widget<Padding>(find.byKey(const Key('page-padding')));
    expect((padding.padding as EdgeInsets).left, VisionTheme.space20);
    expect(find.byKey(const Key('open-catalog')), findsOneWidget);
    expect(tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor, VisionTheme.canvas);
  });
}
