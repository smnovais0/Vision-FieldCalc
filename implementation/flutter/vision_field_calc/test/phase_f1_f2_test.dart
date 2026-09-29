import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vision_field_calc/ai_gateway.dart';
import 'package:vision_field_calc/calculation_record.dart';
import 'package:vision_field_calc/privacy_analytics.dart';
import 'package:vision_field_calc/proposal_guard.dart';
import 'package:vision_field_calc/unit_policy.dart';

void main() {
  setUp(PrivacyAnalytics.clear);

  test('a apresentação imperial não substitui a unidade do catálogo', () {
    expect(UnitPolicy.imperialEquivalent(1, 'm'), '3.280840 ft');
    expect(UnitPolicy.imperialEquivalent(1, 'u²'), isNull);
    expect(UnitPolicy.imperialEquivalent(1, 'C'), isNull);
    expect(UnitPolicy.note('C'), contains('Coulomb'));
    expect(UnitPolicy.note('Pa'), contains('manométrica'));
    expect(UnitPolicy.litresFromUsGallon(1), isNot(UnitPolicy.litresFromImperialGallon(1)));
    expect(UnitPolicy.fahrenheitFromCelsius(0), 32);
    expect(UnitPolicy.fahrenheitDifferenceFromCelsius(100), 180);
  });

  test('o registo local tem hash e o analytics não leva o valor', () {
    final record = calculationRecord(
      formulaId: 'AREA_CIRCLE_RADIUS',
      formulaVersion: '2.0.0',
      engineVersion: '0.3.0',
      status: 'implemented',
      inputs: {'r': 2},
      result: 12.566370614359172,
      unit: 'u²',
      limitations: 'Cálculo local do catálogo 2.0.0.',
      confirmedAt: DateTime.utc(2026, 9, 28),
    );
    expect(record['sha256'], hasLength(64));
    expect(() => PrivacyAnalytics.record('calculation_completed', {'result': '12.5'}), throwsArgumentError);
    PrivacyAnalytics.record('calculation_completed', {
      'formula_id': 'AREA_CIRCLE_RADIUS',
      'outcome': 'completed',
      'status': 'implemented',
    });
    expect(jsonEncode(PrivacyAnalytics.events.single.fields).contains('12.5'), isFalse);
    expect(jsonEncode(PrivacyAnalytics.events.single.fields).contains('2'), isFalse);
  });

  test('proposta com execução, quota, rede ou credencial não calcula', () async {
    final blocked = reviewProposal(
      formulaId: null,
      proposedExpression: '__import__("os")',
      displayMath: '',
      assumptions: const [],
      steps: const [],
      missingFields: const [],
      variables: const {},
    );
    expect(blocked.status, 'blocked');
    expect(blocked.localValue, isNull);

    final assisted = reviewProposal(
      formulaId: 'NAO_EXISTE',
      proposedExpression: '',
      displayMath: 'forma livre',
      assumptions: const [],
      steps: const ['o modelo diz 42'],
      missingFields: const [],
      variables: const {'result': 42},
    );
    expect(assisted.status, 'assisted');
    expect(assisted.localValue, isNull);

    final quota = VisionAiGateway(
      baseUrl: 'https://gateway.test',
      client: MockClient((request) async => http.Response('busy', 429)),
    );
    expect(quota.interpret('forma livre'), throwsA(predicate<StateError>((error) => error.message.contains('quota'))));

    final offline = VisionAiGateway(
      baseUrl: 'https://gateway.test',
      client: MockClient((request) async => throw http.ClientException('offline')),
    );
    expect(offline.interpret('forma livre'), throwsA(predicate<StateError>((error) => error.message.contains('offline'))));

    final leaked = VisionAiGateway(
      baseUrl: 'https://gateway.test',
      client: MockClient((request) async {
        expect(request.headers.containsKey('Authorization'), isFalse);
        return http.Response(jsonEncode({'formula_id': 'AREA_CIRCLE_RADIUS', 'api_key': 'sk-test'}), 200);
      }),
    );
    expect(leaked.interpret('forma livre'), throwsA(predicate<StateError>((error) => error.message.contains('rejected'))));
  });
}
