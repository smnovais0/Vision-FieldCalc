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

class GatewayFailure extends StateError {
  final String code;
  final int? statusCode;
  GatewayFailure(this.code, [this.statusCode]) : super(code);
}

class VisionAiGateway {
  static const endpoint = String.fromEnvironment('VISION_AI_GATEWAY_URL');

  final String baseUrl;
  final http.Client? client;

  VisionAiGateway({String? baseUrl, this.client}) : baseUrl = baseUrl ?? endpoint;

  Future<AiProposal> interpret(String problem, {String locale = 'en'}) async {
    if (baseUrl.isEmpty) {
      throw GatewayFailure('unconfigured');
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
            'locale': locale,
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
        throw GatewayFailure('offline');
      }
      if (response.statusCode == 429) {
        throw GatewayFailure('quota');
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw GatewayFailure('status', response.statusCode);
      }
      if (responseCarriesCredential(response.body)) {
        throw GatewayFailure('rejected');
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw GatewayFailure('invalid');
      }
      return AiProposal.fromJson(decoded);
    } on FormatException {
      throw GatewayFailure('invalid');
    } finally {
      if (ownsClient) httpClient.close();
    }
  }
}
