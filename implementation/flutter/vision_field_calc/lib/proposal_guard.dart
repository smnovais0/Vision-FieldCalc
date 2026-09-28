import 'catalog_router.dart';
import 'generated/formula_engine.g.dart';
import 'local_expression.dart';

final _execution = RegExp(r'__import__|\bimport\b|eval\s*\(|subprocess|os\.system|Process\.|Runtime\.|open\s*\(');

class ProposalReview {
  final String status;
  final FormulaDefinition? formula;
  final double? localValue;
  final String message;

  const ProposalReview({required this.status, this.formula, this.localValue, required this.message});
}

bool responseCarriesCredential(String body) {
  final folded = body.toLowerCase();
  return folded.contains('api_key') || body.contains('sk-') || folded.contains('bearer ');
}

bool proposalRequestsExecution(String blob) => _execution.hasMatch(blob);

ProposalReview reviewProposal({
  required String? formulaId,
  required String proposedExpression,
  required String displayMath,
  required List<String> assumptions,
  required List<String> steps,
  required List<String> missingFields,
  required Map<String, dynamic> variables,
}) {
  final blob = [proposedExpression, displayMath, ...assumptions, ...steps].join('\n');
  if (proposalRequestsExecution(blob)) {
    return const ProposalReview(
      status: 'blocked',
      message: 'A proposta pede execução de código e foi recusada. Nenhum cálculo foi feito.',
    );
  }
  if (missingFields.isNotEmpty) {
    return ProposalReview(
      status: 'missing',
      message: 'Faltam parâmetros confirmados: ${missingFields.join(', ')}.',
    );
  }
  final formula = formulaId == null ? null : formulaById(formulaId);
  if (formula != null) {
    return ProposalReview(
      status: 'local_formula',
      formula: formula,
      message: 'Fórmula local confirmada. O número é calculado no dispositivo.',
    );
  }
  if (proposedExpression.trim().isNotEmpty) {
    final numbers = <String, double>{};
    for (final entry in variables.entries) {
      final value = entry.value;
      if (value is num) numbers[entry.key] = value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value.replaceAll(',', '.'));
        if (parsed != null) numbers[entry.key] = parsed;
      }
    }
    try {
      final value = LocalExpression(proposedExpression).evaluate(numbers);
      return ProposalReview(
        status: 'local_expression',
        localValue: value,
        message: 'A expressão foi recalculada no dispositivo. Não é uma fórmula certificada do catálogo.',
      );
    } on FormatException {
      return const ProposalReview(
        status: 'assisted',
        message: 'Resultado assistido. Não há fórmula local para esta proposta, por isso nenhum número remoto é aceite. Verifique o cálculo de forma independente.',
      );
    }
  }
  return const ProposalReview(
    status: 'assisted',
    message: 'Resultado assistido. Não há fórmula local para esta proposta, por isso nenhum número remoto é aceite. Verifique o cálculo de forma independente.',
  );
}
