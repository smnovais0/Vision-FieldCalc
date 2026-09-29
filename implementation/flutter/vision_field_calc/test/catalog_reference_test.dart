import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:vision_field_calc/ai_gateway.dart';
import 'package:vision_field_calc/catalog_router.dart';
import 'package:vision_field_calc/generated/formula_engine.g.dart';
import 'package:vision_field_calc/l10n/app_copy.dart';
import 'package:vision_field_calc/l10n/app_text.dart';
import 'package:vision_field_calc/local_expression.dart';
import 'package:vision_field_calc/local_solvers.dart';

double representativeValue(String name) {
  const values = {
    'inner_r': 1.0,
    'outer_r': 2.0,
    'minor_r': 1.0,
    'major_r': 2.0,
    'r1': 1.0,
    'r2': 2.0,
    'area1': 1.0,
    'area2': 2.0,
    'power_factor': 0.8,
    'efficiency': 0.8,
    'joint_efficiency': 0.8,
    'correction_factor': 0.9,
    'grouping_factor': 0.9,
    'temperature_factor': 0.9,
    'coefficient_y': 0.4,
    'corrosion_allowance': 0.001,
    'n': 5.0,
    'angle_deg': 30.0,
    'angle1_deg': 20.0,
    'x': 1.0,
    'x1': 0.0,
    'x2': 2.0,
    'y1': 1.0,
    'y2': 3.0,
    'span': 2.0,
    'load_position': 1.0,
    'focal_length': 2.0,
    'object_distance': 4.0,
    'nominal': 2.0,
    'measured': 2.1,
    'tolerance': 0.2,
    'run': 2.0,
    'rise': 1.0,
    'input_energy': 4.0,
    'useful_output': 2.0,
    'primary_turns': 4.0,
    'secondary_turns': 2.0,
    'refractive_index1': 1.0,
    'refractive_index2': 1.5,
  };
  return values[name] ?? 2.0;
}

double _lastNumber(String text) {
  final matches = RegExp(r'[-+]?(?:\d+\.?\d*|\.\d+)(?:[eE][-+]?\d+)?').allMatches(text).toList();
  return double.parse(matches.last.group(0)!);
}

void main() {
  final examples = jsonDecode(File('../../example_results.json').readAsStringSync()) as Map<String, dynamic>;

  test('o catálogo tem 129 fórmulas e os 10 menus', () {
    expect(formulas, hasLength(129));
    expect(catalogMenus, hasLength(10));
    expect(formulas.where((formula) => formula.status == 'review_pending'), hasLength(30));
    expect(formulas.where((formula) => formula.status == 'implemented'), hasLength(99));
    expect(formulas.map((formula) => formula.menu).toSet(), isNot(contains('Estatística')));
  });

  test('as 129 fórmulas executam com dados representativos', () {
    final failures = <String>[];
    for (final formula in formulas) {
      final inputs = {for (final name in formula.inputs) name: representativeValue(name)};
      try {
        final result = calculateFormula(formula, inputs);
        if (!result.value.isFinite || result.steps.length != 5) {
          failures.add(formula.id);
        }
      } catch (exception) {
        failures.add('${formula.id}: $exception');
      }
    }
    expect(failures, isEmpty);
  });

  test('os resultados de referência coincidem com example_results.json', () {
    final cases = {
      'area_circle': {'r': 2.0},
      'volume_cylinder': {'r': 1.5, 'height': 4.0},
      'flow_darcy_headloss': {'friction_factor': 0.02, 'length': 100.0, 'diameter': 0.1, 'velocity': 2.0, 'g': 9.80665},
      'three_phase_power': {'line_voltage': 400.0, 'line_current': 32.0, 'power_factor': 0.9},
      'beam_moment': {'uniform_load': 5000.0, 'span': 4.0},
      'field_report_tolerance': {'measured': 10.3, 'nominal': 10.0, 'tolerance': 0.5},
    };
    for (final entry in cases.entries) {
      final example = examples[entry.key] as Map<String, dynamic>;
      final formula = formulaById(example['formula_id'] as String);
      expect(formula, isNotNull, reason: entry.key);
      final result = calculateFormula(formula!, entry.value);
      expect(result.value, closeTo((example['result'] as num).toDouble(), 1e-9), reason: entry.key);
      expect(formula.status, example['validation_status'], reason: entry.key);
      expect(result.steps.map((step) => step.title).join('\n'), contains('Substituir'));
      if (formula.status == 'review_pending') {
        expect(example['validation_status'], 'review_pending');
      }
    }
    expect(formulaById('STRUCT_BEAM_MMAX_UDL')!.status, 'review_pending');
    expect(formulaById('FR_TOLERANCE_UTILIZATION')!.status, 'review_pending');
  });

  test('domínio inválido é recusado', () {
    expect(() => calculateFormula(formulaById('AREA_SQUARE')!, {'a': 0}), throwsFormatException);
    expect(() => calculateFormula(formulaById('AREA_CIRCLE_RADIUS')!, {'r': -1}), throwsFormatException);
  });

  test('linguagem natural procura localmente antes da IA', () {
    final circle = planNaturalLanguage('area do circulo pelo raio');
    expect(circle.route, 'local');
    expect(circle.formula!.id, 'AREA_CIRCLE_RADIUS');

    final unknown = planNaturalLanguage('forma nao catalogada');
    expect(unknown.route, 'ai_confirmation_required');
    expect(unknown.formula, isNull);

    final missing = planFormulaId('NAO_EXISTE');
    expect(missing.route, 'ai_confirmation_required');
    expect(() => planNaturalLanguage('   '), throwsFormatException);

    final ambiguous = planNaturalLanguage('circulo');
    expect(ambiguous.route, 'ai_confirmation_required');
    expect(ambiguous.formula, isNull);
    expect(matchLocalFormulas('circulo').length, greaterThan(1));
  });

  test('solucionadores locais reproduzem os exemplos numéricos', () {
    final integral = integralSimpson('x**2', 0, 1, 1000);
    expect(_lastNumber(integral.headline), closeTo(1 / 3, 1e-10));
    final integralText = integral.steps.map((step) => step.mathematics).join(' ');
    expect(integralText, contains('∫'));
    expect(integralText, contains('∑'));

    final limit = limitAt('sin(x)/x', 0);
    expect(_lastNumber(limit.steps[3].mathematics), closeTo(1, 1e-6));

    final ode = rk4FirstOrder('y', 0, 1, 1, 100);
    expect(_lastNumber(ode.headline), closeTo(e, 1e-7));
    expect(ode.steps.first.mathematics, contains('dy/dx'));

    final stats = statisticsDescribe([1, 2, 3, 4, 5], sample: true);
    expect(stats.steps.map((step) => step.mathematics).join(' '), contains('∑'));
    expect(stats.headline, contains('3.0'));
    expect((examples['statistics'] as Map)['mean'], 3);

    final roots = polynomialRoots([1, 0, -4]).steps.last.mathematics.split(';').map((part) => double.parse(part.trim())).toList()..sort();
    expect(roots[0], closeTo(-2, 1e-6));
    expect(roots[1], closeTo(2, 1e-6));

    final system = linearSystem([
      [2, 1],
      [1, -1],
    ], [5, 1]);
    expect(_lastNumber(system.steps.last.mathematics.split(',').first), closeTo(2, 1e-9));
    expect(_lastNumber(system.steps.last.mathematics.split(',').last), closeTo(1, 1e-9));

    expect(_lastNumber(newton('x**2-2', 1).headline), closeTo(sqrt(2), 1e-8));
    expect(_lastNumber(binomial(5, 2, 0.5).headline), closeTo(0.3125, 1e-12));
    expect(_lastNumber(pearson([1, 2, 3], [2, 4, 6]).headline), closeTo(1, 1e-12));
  });

  test('expressões com execução ou símbolos estranhos são recusadas', () {
    expect(() => LocalExpression('__import__("os")').evaluate({}), throwsFormatException);
    expect(() => LocalExpression('import os').evaluate({}), throwsFormatException);
    expect(() => const LocalExpression('open("/etc/passwd")').evaluate({}), throwsFormatException);
    expect(() => LocalExpression('eval(1)').evaluate({}), throwsFormatException);
    expect(() => LocalExpression('subprocess.call()').evaluate({}), throwsFormatException);
    expect(() => LocalExpression('Process.start()').evaluate({}), throwsFormatException);
  });

  test('expressões acima de 2000 caracteres ou profundidade 64 são recusadas', () {
    final atLimit = '${' ' * 1999}1';
    expect(atLimit.length, 2000);
    expect(LocalExpression(atLimit).evaluate({}), 1);
    expect(() => LocalExpression('$atLimit ').evaluate({}), throwsFormatException);

    expect(LocalExpression('${'(' * 64}1${')' * 64}').evaluate({}), 1);
    expect(() => LocalExpression('${'(' * 65}1${')' * 65}').evaluate({}), throwsFormatException);
    expect(LocalExpression('0${'+1' * 64}').evaluate({}), 64);
    expect(() => LocalExpression('0${'+1' * 65}').evaluate({}), throwsFormatException);
    expect(LocalExpression('${'-' * 64}1').evaluate({}), 1);
    expect(() => LocalExpression('${'-' * 65}1').evaluate({}), throwsFormatException);
  });

  test('fr es e de traduzem os títulos dos solucionadores e pt mantém o original', () {
    final source = File('lib/local_solvers.dart').readAsStringSync();
    final titles = RegExp(r"CalculationStep\('(?:\d+\. )?([^']+)'")
        .allMatches(source)
        .map((match) => match.group(1)!)
        .toSet();
    expect(titles, isNotEmpty);
    for (final title in titles) {
      expect(appPhrases['en']!.containsKey(title), isTrue, reason: title);
      for (final code in ['fr', 'es', 'de']) {
        expect(appPhrases[code]![title], isNotEmpty, reason: '$code $title');
      }
      expect(AppText('pt').phrase('1. $title'), title);
      expect(AppText('fr').phrase('1. $title'), isNot(title));
    }
    expect(AppText('pt').phrase('4. Substituir'), 'Substituir');
  });

  test('o gateway só usa VISION_AI_GATEWAY_URL e não tem credenciais', () {
    expect(VisionAiGateway.endpoint, isEmpty);
    final source = File('lib/ai_gateway.dart').readAsStringSync();
    expect(source, contains("String.fromEnvironment('VISION_AI_GATEWAY_URL')"));
    expect(source.contains('sk-'), isFalse);
    expect(source.toLowerCase().contains('api_key'), isFalse);
    expect(source.toLowerCase().contains('secret'), isFalse);
    expect(() => VisionAiGateway().interpret('area de uma forma desconhecida'), throwsA(isA<StateError>()));
  });
}
