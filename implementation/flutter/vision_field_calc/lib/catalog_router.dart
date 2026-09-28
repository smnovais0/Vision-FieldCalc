import 'generated/formula_engine.g.dart';

const catalogVersion = '2.0.0';
const engineVersion = '0.3.0';

const catalogMenus = <String>[
  'Áreas',
  'Volumes',
  'Fluidos e fluxos',
  'Eletricidade',
  'Física',
  'Estatística',
  'Equações',
  'Limites e cálculo',
  'Estruturas e equipamentos',
  'Field Report',
];

const solverMenus = <String>{'Estatística', 'Equações', 'Limites e cálculo'};

class RoutePlan {
  final String route;
  final String reason;
  final FormulaDefinition? formula;

  const RoutePlan._(this.route, this.reason, this.formula);

  const RoutePlan.local(FormulaDefinition formula, String reason) : this._('local', reason, formula);

  const RoutePlan.ai(String reason) : this._('ai_confirmation_required', reason, null);

  bool get needsAi => route == 'ai_confirmation_required';
}

String foldAccents(String value) {
  const map = {
    'á': 'a',
    'à': 'a',
    'â': 'a',
    'ã': 'a',
    'ä': 'a',
    'é': 'e',
    'ê': 'e',
    'è': 'e',
    'í': 'i',
    'ì': 'i',
    'ó': 'o',
    'ô': 'o',
    'õ': 'o',
    'ò': 'o',
    'ú': 'u',
    'ù': 'u',
    'ü': 'u',
    'ç': 'c',
  };
  final buffer = StringBuffer();
  for (final rune in value.toLowerCase().runes) {
    final char = String.fromCharCode(rune);
    buffer.write(map[char] ?? char);
  }
  return buffer.toString();
}

List<String> queryTokens(String value) => foldAccents(value)
    .split(RegExp(r'[^a-z0-9]+'))
    .where((word) => word.length > 2)
    .toList();

FormulaDefinition? formulaById(String id) {
  for (final formula in formulas) {
    if (formula.id == id) return formula;
  }
  return null;
}

/// Fórmulas locais com a melhor pontuação. Empate não escolhe uma fórmula.
List<FormulaDefinition> matchLocalFormulas(String query) {
  final words = queryTokens(query).toSet();
  if (words.isEmpty) return const [];
  final scored = <FormulaDefinition, int>{};
  var bestScore = 0;
  for (final formula in formulas) {
    final haystack = queryTokens('${formula.name} ${formula.id.replaceAll('_', ' ')}').toSet();
    final score = words.intersection(haystack).length;
    if (score == 0) continue;
    scored[formula] = score;
    if (score > bestScore) bestScore = score;
  }
  return [
    for (final entry in scored.entries)
      if (entry.value == bestScore) entry.key,
  ];
}

/// Procura uma fórmula local única. Empate devolve nulo para exigir confirmação.
FormulaDefinition? findLocalFormula(String query) {
  final matches = matchLocalFormulas(query);
  if (matches.length != 1) return null;
  return matches.single;
}

RoutePlan planNaturalLanguage(String query) {
  final trimmed = query.trim();
  if (trimmed.isEmpty) {
    throw const FormatException('Descreva primeiro o cálculo pretendido.');
  }
  final matches = matchLocalFormulas(trimmed);
  if (matches.length == 1) {
    return RoutePlan.local(
      matches.single,
      'Fórmula local encontrada. Confirme os parâmetros e calcule no dispositivo.',
    );
  }
  if (matches.length > 1) {
    final names = matches.take(4).map((formula) => formula.name).join(', ');
    return RoutePlan.ai(
      'O pedido corresponde a mais do que uma fórmula local ($names). A interpretação por IA requer confirmação antes de calcular.',
    );
  }
  return const RoutePlan.ai(
    'O motor local não encontrou uma fórmula. A interpretação por IA requer confirmação dos dados antes de calcular.',
  );
}

RoutePlan planFormulaId(String formulaId) {
  final formula = formulaById(formulaId);
  if (formula == null) {
    return const RoutePlan.ai(
      'O catálogo local não reconhece a fórmula. A IA pode interpretar o pedido, mas o utilizador tem de confirmar os parâmetros antes de qualquer cálculo.',
    );
  }
  return RoutePlan.local(formula, 'Fórmula suportada pelo motor determinístico local.');
}
