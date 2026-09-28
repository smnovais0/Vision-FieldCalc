import 'dart:convert';

import 'package:http/http.dart' as http;

import 'proposal_guard.dart';

class AiProposal {
  final String? formulaId;
  final String proposedExpression;
  final String displayMath;
  final Map<String, dynamic> variables;
  final Map<String, dynamic> units;
  final List<String> assumptions;
  final List<String> missingFields;
  final double? confidence;
  final List<String> explanationSteps;
  final String providerMode;

  const AiProposal({
    required this.formulaId,
    required this.proposedExpression,
    required this.displayMath,
    required this.variables,
    required this.units,
    required this.assumptions,
    required this.missingFields,
    required this.confidence,
    required this.explanationSteps,
    required this.providerMode,
  });

  factory AiProposal.fromJson(Map<String, dynamic> json) => AiProposal(
        formulaId: json['formula_id'] as String?,
        proposedExpression: (json['proposed_expression'] as String?) ?? '',
        displayMath: (json['display_math'] as String?) ?? '',
        variables: Map<String, dynamic>.from((json['variables'] as Map?) ?? const {}),
        units: Map<String, dynamic>.from((json['units'] as Map?) ?? const {}),
        assumptions: List<String>.from((json['assumptions'] as List?) ?? const []),
        missingFields: List<String>.from((json['missing_fields'] as List?) ?? const []),
        confidence: (json['confidence'] as num?)?.toDouble(),
        explanationSteps: List<String>.from((json['steps'] as List?) ?? const []),
        providerMode: (json['provider_mode'] as String?) ?? 'managed',
      );
}

class VisionAiGateway {
  static const endpoint = String.fromEnvironment('VISION_AI_GATEWAY_URL');

  final String baseUrl;
  final http.Client? client;

  VisionAiGateway({String? baseUrl, this.client}) : baseUrl = baseUrl ?? endpoint;

  Future<AiProposal> interpret(String problem) async {
    if (baseUrl.isEmpty) {
      throw StateError('Vision AI Gateway ainda não está configurado nesta instalação.');
    }
    final httpClient = client ?? http.Client();
    final ownsClient = client == null;
    try {
      final http.Response response;
      try {
        response = await httpClient.post(
          Uri.parse('$baseUrl/v1/calc/interpret'),
          headers: const {
            'Content-Type': 'application/json',
            'X-Vision-App': 'vision-field-calc',
          },
          body: jsonEncode({
            'problem': problem,
            'locale': 'pt-PT',
            'mode': 'interpret_only',
            'required_output': {
              'formula_id': true,
              'proposed_expression': true,
              'display_math': true,
              'variables': true,
              'units': true,
              'assumptions': true,
              'missing_fields': true,
              'confidence': true,
              'steps': true,
            },
          }),
        );
      } on http.ClientException {
        throw StateError('Sem rede para o Vision AI Gateway. Os cálculos locais continuam disponíveis.');
      }
      if (response.statusCode == 429) {
        throw StateError('A quota do Vision AI Gateway está esgotada. Os cálculos locais continuam disponíveis.');
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw StateError('O Vision AI Gateway respondeu com o estado ${response.statusCode}.');
      }
      if (responseCarriesCredential(response.body)) {
        throw StateError('A resposta do gateway foi recusada.');
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw StateError('O Vision AI Gateway devolveu um formato inválido.');
      }
      return AiProposal.fromJson(decoded);
    } on FormatException {
      throw StateError('O Vision AI Gateway devolveu um formato inválido.');
    } finally {
      if (ownsClient) httpClient.close();
    }
  }
}
