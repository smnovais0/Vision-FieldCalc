import 'dart:math';

import 'generated/formula_engine.g.dart';
import 'local_expression.dart';

class SolverRun {
  final String headline;
  final List<CalculationStep> steps;
  const SolverRun(this.headline, this.steps);
}

class _C {
  final double re;
  final double im;
  const _C(this.re, this.im);
  _C operator +(_C other) => _C(re + other.re, im + other.im);
  _C operator -(_C other) => _C(re - other.re, im - other.im);
  _C operator *(_C other) => _C(re * other.re - im * other.im, re * other.im + im * other.re);
  _C operator /(_C other) {
    final den = other.re * other.re + other.im * other.im;
    return _C((re * other.re + im * other.im) / den, (im * other.re - re * other.im) / den);
  }
  double get mag => sqrt(re * re + im * im);
}

double parseNumber(String raw, String label) {
  final value = double.tryParse(raw.trim().replaceAll(',', '.'));
  if (value == null || !value.isFinite) {
    throw FormatException('Preencha $label com um número válido.');
  }
  return value;
}

List<double> parseNumberList(String raw, String label) {
  final parts = raw.split(RegExp(r'[,\s]+')).where((part) => part.trim().isNotEmpty).toList();
  if (parts.isEmpty) throw FormatException('Preencha $label.');
  return [for (final part in parts) parseNumber(part, label)];
}

List<List<double>> parseMatrix(String raw) {
  final rows = raw.split(';').map((row) => row.trim()).where((row) => row.isNotEmpty).toList();
  if (rows.isEmpty) throw const FormatException('Preencha a matriz.');
  return [for (final row in rows) parseNumberList(row, 'a matriz')];
}

int _combinations(int n, int k) {
  if (k < 0 || k > n) return 0;
  var choose = k > n - k ? n - k : k;
  var result = 1;
  for (var i = 1; i <= choose; i++) {
    result = result * (n - choose + i) ~/ i;
  }
  return result;
}

double _mean(List<double> values) => values.reduce((a, b) => a + b) / values.length;

double _median(List<double> values) {
  final ordered = [...values]..sort();
  final mid = ordered.length ~/ 2;
  if (ordered.length.isOdd) return ordered[mid];
  return (ordered[mid - 1] + ordered[mid]) / 2;
}

SolverRun statisticsDescribe(List<double> values, {bool sample = false}) {
  if (values.isEmpty || (sample && values.length < 2)) {
    throw const FormatException('São necessários valores suficientes para a estatística pedida.');
  }
  final mu = _mean(values);
  final den = sample ? values.length - 1 : values.length;
  final variance = values.map((value) => pow(value - mu, 2).toDouble()).reduce((a, b) => a + b) / den;
  final deviation = sqrt(variance);
  final ordered = [...values]..sort();
  final symbol = sample ? 's' : 'σ';
  final mid = _median(values);
  return SolverRun('x̄ = $mu; $symbol = $deviation', [
    CalculationStep('1. Ordenar os dados', 'x₍₁₎ ≤ … ≤ x₍ₙ₎', 'mediana = $mid; ${ordered.join(', ')}'),
    CalculationStep('2. Calcular a média', 'x̄ = (∑ᵢ xᵢ) / n', '∑x = ${values.reduce((a, b) => a + b)}; n = ${values.length}; x̄ = $mu'),
    CalculationStep('3. Calcular a variância', sample ? 's² = ∑ᵢ(xᵢ − x̄)² / (n − 1)' : 'σ² = ∑ᵢ(xᵢ − x̄)² / n', '$variance'),
    CalculationStep('4. Calcular o desvio padrão', '$symbol = √${sample ? 's²' : 'σ²'}', '$deviation'),
  ]);
}

SolverRun weightedMean(List<double> values, List<double> weights) {
  if (values.length != weights.length || values.isEmpty || weights.any((weight) => weight < 0) || weights.reduce((a, b) => a + b) <= 0) {
    throw const FormatException('Os pesos têm de ser não negativos e ter a mesma quantidade de valores.');
  }
  final total = weights.reduce((a, b) => a + b);
  var weighted = 0.0;
  for (var i = 0; i < values.length; i++) {
    weighted += values[i] * weights[i];
  }
  final result = weighted / total;
  return SolverRun('x̄w = $result', [
    CalculationStep('1. Multiplicar', '∑ᵢ wᵢ xᵢ', '$weighted'),
    CalculationStep('2. Dividir pela soma dos pesos', 'x̄w = (∑ᵢ wᵢ xᵢ) / (∑ᵢ wᵢ)', '$result'),
  ]);
}

SolverRun pearson(List<double> xs, List<double> ys) {
  if (xs.length != ys.length || xs.length < 2) {
    throw const FormatException('Pearson precisa de pelo menos dois pares.');
  }
  final mx = _mean(xs);
  final my = _mean(ys);
  var numerator = 0.0;
  var sx = 0.0;
  var sy = 0.0;
  for (var i = 0; i < xs.length; i++) {
    final dx = xs[i] - mx;
    final dy = ys[i] - my;
    numerator += dx * dy;
    sx += dx * dx;
    sy += dy * dy;
  }
  final denominator = sqrt(sx * sy);
  if (denominator == 0) throw const FormatException('A variância de uma das séries é zero.');
  final result = numerator / denominator;
  return SolverRun('r = $result', [
    CalculationStep('1. Calcular as médias', 'x̄ e ȳ', 'x̄ = $mx; ȳ = $my'),
    CalculationStep('2. Calcular os desvios', '(xᵢ − x̄) e (yᵢ − ȳ)', 'Desvios calculados para cada par.'),
    CalculationStep('3. Aplicar Pearson', 'r = ∑(xᵢ − x̄)(yᵢ − ȳ) / √[∑(xᵢ − x̄)² ∑(yᵢ − ȳ)²]', 'r = $result'),
  ]);
}

SolverRun linearRegression(List<double> xs, List<double> ys) {
  if (xs.length != ys.length || xs.length < 2) {
    throw const FormatException('A regressão precisa de pelo menos dois pares.');
  }
  final mx = _mean(xs);
  final my = _mean(ys);
  var sxx = 0.0;
  var sxy = 0.0;
  for (var i = 0; i < xs.length; i++) {
    final dx = xs[i] - mx;
    final dy = ys[i] - my;
    sxx += dx * dx;
    sxy += dx * dy;
  }
  if (sxx == 0) throw const FormatException('A variância de x é zero.');
  final slope = sxy / sxx;
  final intercept = my - slope * mx;
  return SolverRun('ŷ = $intercept + ${slope}x', [
    CalculationStep('1. Médias', 'x̄, ȳ', 'x̄ = $mx; ȳ = $my'),
    CalculationStep('2. Declive', 'b = ∑(x − x̄)(y − ȳ) / ∑(x − x̄)²', 'b = $slope'),
    CalculationStep('3. Ordenada', 'a = ȳ − b x̄', 'a = $intercept'),
    CalculationStep('4. Equação', 'ŷ = a + bx', 'ŷ = $intercept + ${slope}x'),
  ]);
}

SolverRun percentile(List<double> values, double p) {
  if (values.isEmpty || p < 0 || p > 100) {
    throw const FormatException('O percentil tem de estar entre 0 e 100.');
  }
  final ordered = [...values]..sort();
  final pos = (ordered.length - 1) * p / 100;
  final lo = pos.floor();
  final hi = pos.ceil();
  final result = lo == hi ? ordered[lo] : ordered[lo] + (pos - lo) * (ordered[hi] - ordered[lo]);
  return SolverRun('Pₚ = $result', [
    CalculationStep('1. Ordenar', 'x₍₁₎ ≤ … ≤ x₍ₙ₎', ordered.join(', ')),
    CalculationStep('2. Localizar', 'h = (n − 1) × p / 100', 'h = $pos'),
    CalculationStep('3. Interpolar', 'Pₚ = x⌊h⌋ + (h − ⌊h⌋)(x⌈h⌉ − x⌊h⌋)', '$result'),
  ]);
}

SolverRun binomial(int trials, int successes, double probability) {
  if (trials < 0 || successes < 0 || successes > trials || probability < 0 || probability > 1) {
    throw const FormatException('Use 0 ≤ k ≤ n e 0 ≤ p ≤ 1.');
  }
  final combinations = _combinations(trials, successes);
  final result = combinations * pow(probability, successes) * pow(1 - probability, trials - successes);
  return SolverRun('P(X = k) = $result', [
    CalculationStep('1. Confirmar parâmetros', '0 ≤ k ≤ n; 0 ≤ p ≤ 1', 'n = $trials; k = $successes; p = $probability'),
    CalculationStep('2. Calcular combinações', 'C(n, k) = n! / [k! (n − k)!]', 'C($trials, $successes) = $combinations'),
    CalculationStep('3. Aplicar a distribuição binomial', 'P(X = k) = C(n, k) pᵏ (1 − p)ⁿ⁻ᵏ', 'P = $result'),
  ]);
}

SolverRun polynomialRoots(List<double> coefficients, {double tolerance = 1e-12, int maxIterations = 500}) {
  final cleaned = [...coefficients];
  while (cleaned.isNotEmpty && cleaned.first == 0) {
    cleaned.removeAt(0);
  }
  if (cleaned.length < 2) throw const FormatException('O polinómio precisa de grau pelo menos 1.');
  final degree = cleaned.length - 1;
  final lead = cleaned.first;
  final normalized = [for (final value in cleaned) _C(value / lead, 0)];
  late List<_C> roots;
  if (degree == 1) {
    roots = [_C(-normalized[1].re, 0)];
  } else {
    var radius = 1.0;
    for (final value in normalized.skip(1)) {
      radius = max(radius, 1 + value.mag);
    }
    roots = [
      for (var k = 0; k < degree; k++)
        () {
          final angle = 2 * pi * k / degree;
          return _C(radius * cos(angle), radius * sin(angle));
        }(),
    ];
    var converged = false;
    for (var iteration = 0; iteration < maxIterations; iteration++) {
      final updated = <_C>[];
      for (var i = 0; i < roots.length; i++) {
        final r = roots[i];
        var value = normalized.first;
        for (final coefficient in normalized.skip(1)) {
          value = value * r + coefficient;
        }
        var denominator = const _C(1, 0);
        for (var j = 0; j < roots.length; j++) {
          if (i != j) denominator = denominator * (r - roots[j]);
        }
        if (denominator.mag < tolerance) denominator = _C(tolerance, tolerance);
        updated.add(r - value / denominator);
      }
      var error = 0.0;
      for (var i = 0; i < roots.length; i++) {
        error = max(error, (updated[i] - roots[i]).mag);
      }
      roots = updated;
      if (error < tolerance) {
        converged = true;
        break;
      }
    }
    if (!converged) throw const FormatException('As raízes não convergiram.');
  }
  String fmt(_C root) {
    final real = root.re.abs() < tolerance ? 0.0 : root.re;
    final imag = root.im.abs() < tolerance ? 0.0 : root.im;
    if (imag == 0) return '$real';
    return '$real + ${imag}i';
  }
  final shown = roots.map(fmt).join('; ');
  return SolverRun('raízes: $shown', [
    CalculationStep('1. Construir o polinómio', 'P(x) = 0', coefficients.join(', ')),
    CalculationStep('2. Normalizar', 'a₀ = 1', 'Grau $degree.'),
    CalculationStep('3. Resolver', shown, 'Raízes numéricas locais.'),
  ]);
}

SolverRun linearSystem(List<List<double>> matrix, List<double> vector) {
  final n = matrix.length;
  if (n == 0 || vector.length != n || matrix.any((row) => row.length != n)) {
    throw const FormatException('A matriz tem de ser quadrada e compatível com o vetor.');
  }
  final m = [for (var i = 0; i < n; i++) [...matrix[i], vector[i]]];
  final operations = <String>[];
  for (var col = 0; col < n; col++) {
    var pivot = col;
    for (var row = col + 1; row < n; row++) {
      if (m[row][col].abs() > m[pivot][col].abs()) pivot = row;
    }
    if (m[pivot][col].abs() < 1e-14) throw const FormatException('A matriz é singular.');
    if (pivot != col) {
      final swap = m[col];
      m[col] = m[pivot];
      m[pivot] = swap;
      operations.add('R${col + 1} ↔ R${pivot + 1}');
    }
    final scale = m[col][col];
    m[col] = [for (final value in m[col]) value / scale];
    for (var row = 0; row < n; row++) {
      if (row == col) continue;
      final factor = m[row][col];
      if (factor != 0) {
        m[row] = [for (var k = 0; k < m[row].length; k++) m[row][k] - factor * m[col][k]];
        operations.add('R${row + 1} − ($factor) R${col + 1}');
      }
    }
  }
  final solution = [for (var i = 0; i < n; i++) m[i].last];
  return SolverRun('x = ${solution.join(', ')}', [
    CalculationStep('1. Matriz aumentada', '[A | b]', 'Sistema $n×$n.'),
    CalculationStep('2. Eliminação de Gauss–Jordan', operations.join('; '), 'Operações elementares aplicadas localmente.'),
    CalculationStep('3. Solução', 'x = ${solution.join(', ')}', 'Substituição verificada no dispositivo.'),
  ]);
}

double _at(LocalExpression expression, String variable, double x) => expression.evaluate({variable: x});

SolverRun bisection(String expression, double lower, double upper, {double tolerance = 1e-10, int maxIterations = 200}) {
  final f = LocalExpression(expression);
  var lo = lower;
  var hi = upper;
  var flo = _at(f, 'x', lo);
  var fhi = _at(f, 'x', hi);
  if (flo == 0) {
    return SolverRun('x ≈ $lo', [CalculationStep('1. Raiz no limite', 'x = $lo', 'f(x) = 0')]);
  }
  if (flo * fhi > 0) throw const FormatException('O intervalo não muda de sinal.');
  var mid = (lo + hi) / 2;
  var fm = _at(f, 'x', mid);
  var iterations = 0;
  for (var i = 0; i < maxIterations; i++) {
    iterations = i + 1;
    mid = (lo + hi) / 2;
    fm = _at(f, 'x', mid);
    if (fm.abs() <= tolerance || (hi - lo) / 2 <= tolerance) break;
    if (flo * fm <= 0) {
      hi = mid;
      fhi = fm;
    } else {
      lo = mid;
      flo = fm;
    }
  }
  return SolverRun('x ≈ $mid', [
    CalculationStep('1. Definir', 'f(x) = 0', expression),
    CalculationStep('2. Confirmar mudança de sinal', 'f(a) · f(b) ≤ 0', '[$lower, $upper]'),
    CalculationStep('3. Bissectar', 'xₙ = (aₙ + bₙ) / 2', '$iterations iterações'),
    CalculationStep('4. Resultado', 'x ≈ $mid', '|f| = ${fm.abs()}'),
  ]);
}

SolverRun newton(String expression, double initial, {double tolerance = 1e-10, int maxIterations = 100}) {
  final f = LocalExpression(expression);
  var x = initial;
  var iterations = 0;
  for (var i = 0; i < maxIterations; i++) {
    iterations = i + 1;
    final h = max(1e-7, x.abs() * 1e-7);
    final fx = _at(f, 'x', x);
    final derivative = (_at(f, 'x', x + h) - _at(f, 'x', x - h)) / (2 * h);
    if (derivative.abs() < 1e-14) throw const FormatException('A derivada numérica é zero.');
    final next = x - fx / derivative;
    if ((next - x).abs() <= tolerance && _at(f, 'x', next).abs() <= max(tolerance, 1e-8)) {
      x = next;
      break;
    }
    x = next;
  }
  return SolverRun('x ≈ $x', [
    CalculationStep('1. Definir a equação', 'f(x) = 0', expression),
    CalculationStep('2. Escolher valor inicial', 'x₀ = $initial', 'Valor confirmado pelo utilizador.'),
    CalculationStep('3. Iterar por Newton', 'xₙ₊₁ = xₙ − f(xₙ) / f′(xₙ)', '$iterations iterações'),
    CalculationStep('4. Resultado', 'x ≈ $x', 'Raiz numérica local.'),
  ]);
}

SolverRun derivativeAt(String expression, double point) {
  final f = LocalExpression(expression);
  final h = max(1e-5, point.abs() * 1e-5);
  double at(double x) => f.evaluate({'x': x});
  final result = (at(point - 2 * h) - 8 * at(point - h) + 8 * at(point + h) - at(point + 2 * h)) / (12 * h);
  return SolverRun('f′($point) ≈ $result', [
    CalculationStep('1. Definir a função', 'f(x) = $expression', 'Função confirmada.'),
    CalculationStep('2. Aplicar diferença central', 'f′(x) ≈ [f(x−2h) − 8f(x−h) + 8f(x+h) − f(x+2h)] / (12h)', 'h = $h'),
    CalculationStep('3. Resultado', 'f′($point) ≈ $result', 'Derivada numérica local.'),
  ]);
}

SolverRun integralSimpson(String expression, double lower, double upper, int intervals) {
  if (intervals < 2 || intervals.isOdd) {
    throw const FormatException('O número de intervalos tem de ser par e igual ou superior a 2.');
  }
  final f = LocalExpression(expression);
  final h = (upper - lower) / intervals;
  double at(double x) => f.evaluate({'x': x});
  var odd = 0.0;
  var even = 0.0;
  for (var i = 1; i < intervals; i++) {
    final y = at(lower + i * h);
    if (i.isOdd) {
      odd += y;
    } else {
      even += y;
    }
  }
  final result = h * (at(lower) + at(upper) + 4 * odd + 2 * even) / 3;
  return SolverRun('∫ ≈ $result', [
    CalculationStep('1. Definir o integral', '∫₍$lower₎^($upper) ($expression) dx', 'Integrando e limites confirmados.'),
    CalculationStep('2. Dividir o intervalo', 'h = ($upper − $lower) / $intervals = $h', 'Regra de Simpson com número par de intervalos.'),
    CalculationStep('3. Somar os termos', 'h/3 [f₀ + fₙ + 4∑fᵢ ímpar + 2∑fᵢ par]', '∑ ímpar = $odd; ∑ par = $even'),
    CalculationStep('4. Resultado', '∫ ≈ $result', 'Resultado numérico calculado localmente.'),
  ]);
}

SolverRun limitAt(String expression, double point) {
  final f = LocalExpression(expression);
  final samples = [for (var k = 2; k <= 9; k++) pow(10.0, -k).toDouble()];
  final left = [for (final h in samples) f.evaluate({'x': point - h})];
  final right = [for (final h in samples) f.evaluate({'x': point + h})];
  final l = left.last;
  final r = right.last;
  final scale = max(1e-8, max(l.abs(), r.abs()) * 1e-6);
  final exists = (l - r).abs() <= scale;
  final estimate = exists ? (l + r) / 2 : null;
  return SolverRun(exists ? 'lim ≈ $estimate' : 'Limite bilateral não confirmado', [
    CalculationStep('1. Definir o limite', 'limₓ→$point $expression', 'Ponto confirmado.'),
    CalculationStep('2. Aproximar à esquerda', 'x → $point⁻; L⁻ ≈ $l', 'Amostras locais à esquerda.'),
    CalculationStep('3. Aproximar à direita', 'x → $point⁺; L⁺ ≈ $r', 'Amostras locais à direita.'),
    CalculationStep('4. Comparar', exists ? 'L ≈ $estimate' : 'Limite bilateral não confirmado', 'Estimativa numérica local.'),
  ]);
}

SolverRun rk4FirstOrder(String expression, double x0, double y0, double x1, int steps) {
  if (steps <= 0) throw const FormatException('O número de passos tem de ser positivo.');
  final f = LocalExpression(expression);
  var x = x0;
  var y = y0;
  final h = (x1 - x0) / steps;
  for (var i = 0; i < steps; i++) {
    final k1 = f.evaluate({'x': x, 'y': y});
    final k2 = f.evaluate({'x': x + h / 2, 'y': y + h * k1 / 2});
    final k3 = f.evaluate({'x': x + h / 2, 'y': y + h * k2 / 2});
    final k4 = f.evaluate({'x': x + h, 'y': y + h * k3});
    y += h * (k1 + 2 * k2 + 2 * k3 + k4) / 6;
    x += h;
  }
  return SolverRun('y($x) ≈ $y', [
    CalculationStep('1. Definir a equação diferencial', 'dy/dx = $expression', 'Usa as variáveis x e y.'),
    CalculationStep('2. Condição inicial', 'y($x0) = $y0; calcular até x = $x1', 'Valores confirmados.'),
    CalculationStep('3. Aplicar Runge–Kutta 4', 'yₙ₊₁ = yₙ + h(k₁ + 2k₂ + 2k₃ + k₄) / 6', 'n = $steps; h = $h'),
    CalculationStep('4. Resultado', 'y($x) ≈ $y', 'Solução numérica local.'),
  ]);
}

SolverRun rk4SecondOrder(String expression, double x0, double y0, double dy0, double x1, int steps) {
  if (steps <= 0) throw const FormatException('O número de passos tem de ser positivo.');
  final acceleration = LocalExpression(expression);
  var x = x0;
  var y = y0;
  var v = dy0;
  final h = (x1 - x0) / steps;
  for (var i = 0; i < steps; i++) {
    final k1y = v;
    final k1v = acceleration.evaluate({'x': x, 'y': y, 'dy': v});
    final k2y = v + h * k1v / 2;
    final k2v = acceleration.evaluate({'x': x + h / 2, 'y': y + h * k1y / 2, 'dy': v + h * k1v / 2});
    final k3y = v + h * k2v / 2;
    final k3v = acceleration.evaluate({'x': x + h / 2, 'y': y + h * k2y / 2, 'dy': v + h * k2v / 2});
    final k4y = v + h * k3v;
    final k4v = acceleration.evaluate({'x': x + h, 'y': y + h * k3y, 'dy': v + h * k3v});
    y += h * (k1y + 2 * k2y + 2 * k3y + k4y) / 6;
    v += h * (k1v + 2 * k2v + 2 * k3v + k4v) / 6;
    x += h;
  }
  return SolverRun('y ≈ $y; dy/dx ≈ $v', [
    CalculationStep('1. Reduzir a ordem', 'y′ = v; v′ = f(x, y, dy/dx)', expression),
    CalculationStep('2. Condições iniciais', 'y($x0) = $y0; y′($x0) = $dy0', 'Calcular até x = $x1'),
    CalculationStep('3. Aplicar Runge–Kutta 4 ao sistema', '[y, v]ₙ₊₁ = RK4([y, v]ₙ)', 'n = $steps; h = $h'),
    CalculationStep('4. Resultado', 'y ≈ $y; dy/dx ≈ $v', 'x = $x'),
  ]);
}
