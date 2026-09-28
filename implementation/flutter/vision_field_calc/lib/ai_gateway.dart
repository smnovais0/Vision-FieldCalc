import 'dart:convert';

import 'package:http/http.dart' as http;

class AiProposal {
  final String? formulaId;
  final String displayMath;
  final Map<String, dynamic> variables;
  final Map<String, dynamic> units;
  final List<String> assumptions;
  final List<String> explanationSteps;

  const AiProposal({
    required this.formulaId,
    required this.displayMath,
    required this.variables,
    required this.units,
    required this.assumptions,
    required this.explanationSteps,
  });

  factory AiProposal.fromJson(Map<String, dynamic> json) => AiProposal(
        formulaId: json['formula_id'] as String?,
        displayMath: (json['display_math'] as String?) ?? '',
        variables: Map<String, dynamic>.from((json['variables'] as Map?) ?? const {}),
        units: Map<String, dynamic>.from((json['units'] as Map?) ?? const {}),
        assumptions: List<String>.from((json['assumptions'] as List?) ?? const []),
        explanationSteps: List<String>.from((json['steps'] as List?) ?? const []),
      );
}

class VisionAiGateway {
  static const endpoint = String.fromEnvironment('VISION_AI_GATEWAY_URL');

  Future<AiProposal> interpret(String problem) async {
    if (endpoint.isEmpty) {
      throw StateError('Vision AI Gateway ainda não está configurado nesta instalação.');
    }
    final response = await http.post(
      Uri.parse('$endpoint/v1/calc/interpret'),
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
          'display_math': true,
          'variables': true,
          'units': true,
          'assumptions': true,
          'steps': true,
        },
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('O Vision AI Gateway respondeu com o estado ${response.statusCode}.');
    }
    return AiProposal.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
