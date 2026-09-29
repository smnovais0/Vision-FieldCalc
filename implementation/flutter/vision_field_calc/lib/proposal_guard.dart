import 'catalog_router.dart';
import 'generated/formula_engine.g.dart';
import 'local_expression.dart';

final _execution = RegExp(r'__import__|\bimport\b|eval\s*\(|subprocess|os\.system|Process\.|Runtime\.|open\s*\(');
final _credentialField = RegExp(
  r'''['"]?(?:[\w-]*?(?:password|token|secret))['"]?\s*[:=]''',
  caseSensitive: false,
);

class ProposalReview {
  final String status;
  final FormulaDefinition? formula;
  final double? localValue;
  final String message;

  const ProposalReview({required this.status, this.formula, this.localValue, required this.message});
}

bool responseCarriesCredential(String body) {
  final folded = body.toLowerCase();
  if (folded.contains('api_key') || body.contains('sk-') || folded.contains('bearer ')) {
    return true;
  }
  return _credentialField.hasMatch(body);
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
      message: 'blocked',
    );
  }
  if (missingFields.isNotEmpty) {
    return ProposalReview(
      status: 'missing',
      message: 'missing:${missingFields.join(', ')}',
    );
  }
  final formula = formulaId == null ? null : formulaById(formulaId);
  if (formula != null) {
    return ProposalReview(
      status: 'local_formula',
      formula: formula,
      message: 'local_formula',
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
        message: 'local_expression',
      );
    } on FormatException {
      return const ProposalReview(
        status: 'assisted',
        message: 'assisted',
      );
    }
  }
  return const ProposalReview(
    status: 'assisted',
    message: 'assisted',
  );
}
