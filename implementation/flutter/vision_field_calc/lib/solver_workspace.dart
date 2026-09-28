import 'package:flutter/material.dart';

import 'local_solvers.dart';
import 'math_step_view.dart';
import 'vision_theme.dart';
import 'widgets/vision_widgets.dart';

enum SolverKind {
  describe,
  weighted,
  pearson,
  regression,
  percentile,
  binomial,
  polynomial,
  system,
  bisection,
  newton,
  integral,
  limit,
  derivative,
  ode1,
  ode2,
}

class _SolverSpec {
  final SolverKind kind;
  final String label;
  final Map<String, String> initial;
  const _SolverSpec(this.kind, this.label, this.initial);
}

const _byMenu = <String, List<_SolverSpec>>{
  'Estatística': [
    _SolverSpec(SolverKind.describe, 'Descrever', {'values': '1, 2, 3, 4, 5', 'sample': '1'}),
    _SolverSpec(SolverKind.weighted, 'Média ponderada', {'values': '1, 2, 3', 'weights': '1, 1, 2'}),
    _SolverSpec(SolverKind.pearson, 'Pearson', {'xs': '1, 2, 3', 'ys': '2, 4, 6'}),
    _SolverSpec(SolverKind.regression, 'Regressão', {'xs': '1, 2, 3', 'ys': '2, 4, 6'}),
    _SolverSpec(SolverKind.percentile, 'Percentil', {'values': '1, 2, 3, 4, 5', 'p': '50'}),
    _SolverSpec(SolverKind.binomial, 'Binomial', {'n': '5', 'k': '2', 'p': '0.5'}),
  ],
  'Equações': [
    _SolverSpec(SolverKind.polynomial, 'Polinómio', {'coefficients': '1, 0, -4'}),
    _SolverSpec(SolverKind.system, 'Sistema', {'matrix': '2, 1; 1, -1', 'vector': '5, 1'}),
    _SolverSpec(SolverKind.bisection, 'Bisseção', {'expression': 'x**2-4', 'lower': '0', 'upper': '3'}),
    _SolverSpec(SolverKind.newton, 'Newton', {'expression': 'x**2-2', 'initial': '1'}),
  ],
  'Limites e cálculo': [
    _SolverSpec(SolverKind.integral, 'Integral', {'expression': 'x**2', 'lower': '0', 'upper': '1', 'intervals': '1000'}),
    _SolverSpec(SolverKind.limit, 'Limite', {'expression': 'sin(x)/x', 'point': '0'}),
    _SolverSpec(SolverKind.derivative, 'Derivada', {'expression': 'x**2', 'point': '3'}),
    _SolverSpec(SolverKind.ode1, 'EDO', {'expression': 'y', 'x0': '0', 'y0': '1', 'x1': '1', 'steps': '100'}),
    _SolverSpec(SolverKind.ode2, 'EDO 2.ª ordem', {'expression': '-y', 'x0': '0', 'y0': '1', 'dy0': '0', 'x1': '1', 'steps': '200'}),
  ],
};

class SolverWorkspace extends StatefulWidget {
  final String menu;
  const SolverWorkspace({super.key, required this.menu});

  @override
  State<SolverWorkspace> createState() => _SolverWorkspaceState();
}

class _SolverWorkspaceState extends State<SolverWorkspace> {
  late List<_SolverSpec> specs = _byMenu[widget.menu] ?? _byMenu['Limites e cálculo']!;
  late SolverKind kind = specs.first.kind;
  final controllers = <String, TextEditingController>{};
  SolverRun? run;
  String? error;
  final _doomed = <TextEditingController>{};

  @override
  void initState() {
    super.initState();
    _load(specs.first);
  }

  @override
  void didUpdateWidget(covariant SolverWorkspace oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.menu != widget.menu) {
      specs = _byMenu[widget.menu] ?? _byMenu['Limites e cálculo']!;
      _load(specs.first);
    }
  }

  void _load(_SolverSpec spec) {
    for (final controller in controllers.values) {
      _doomed.add(controller);
    }
    controllers
      ..clear()
      ..addEntries(spec.initial.entries.map((entry) => MapEntry(entry.key, TextEditingController(text: entry.value))));
    kind = spec.kind;
    run = null;
    error = null;
    WidgetsBinding.instance.addPostFrameCallback((_) => _flushDoomed());
  }

  void _flushDoomed() {
    final retiring = List<TextEditingController>.of(_doomed);
    _doomed.clear();
    for (final controller in retiring) {
      controller.dispose();
    }
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      _doomed.add(controller);
    }
    controllers.clear();
    _flushDoomed();
    super.dispose();
  }

  String _text(String key) => controllers[key]?.text ?? '';

  void solve() {
    try {
      final value = switch (kind) {
        SolverKind.describe => statisticsDescribe(parseNumberList(_text('values'), 'os valores'), sample: _text('sample').trim() == '1'),
        SolverKind.weighted => weightedMean(parseNumberList(_text('values'), 'os valores'), parseNumberList(_text('weights'), 'os pesos')),
        SolverKind.pearson => pearson(parseNumberList(_text('xs'), 'x'), parseNumberList(_text('ys'), 'y')),
        SolverKind.regression => linearRegression(parseNumberList(_text('xs'), 'x'), parseNumberList(_text('ys'), 'y')),
        SolverKind.percentile => percentile(parseNumberList(_text('values'), 'os valores'), parseNumber(_text('p'), 'o percentil')),
        SolverKind.binomial => binomial(parseNumber(_text('n'), 'n').round(), parseNumber(_text('k'), 'k').round(), parseNumber(_text('p'), 'p')),
        SolverKind.polynomial => polynomialRoots(parseNumberList(_text('coefficients'), 'os coeficientes')),
        SolverKind.system => linearSystem(parseMatrix(_text('matrix')), parseNumberList(_text('vector'), 'o vetor')),
        SolverKind.bisection => bisection(_text('expression'), parseNumber(_text('lower'), 'o limite inferior'), parseNumber(_text('upper'), 'o limite superior')),
        SolverKind.newton => newton(_text('expression'), parseNumber(_text('initial'), 'o valor inicial')),
        SolverKind.integral => integralSimpson(_text('expression'), parseNumber(_text('lower'), 'o limite inferior'), parseNumber(_text('upper'), 'o limite superior'), parseNumber(_text('intervals'), 'os intervalos').round()),
        SolverKind.limit => limitAt(_text('expression'), parseNumber(_text('point'), 'o ponto')),
        SolverKind.derivative => derivativeAt(_text('expression'), parseNumber(_text('point'), 'o ponto')),
        SolverKind.ode1 => rk4FirstOrder(_text('expression'), parseNumber(_text('x0'), 'x inicial'), parseNumber(_text('y0'), 'y inicial'), parseNumber(_text('x1'), 'x final'), parseNumber(_text('steps'), 'os passos').round()),
        SolverKind.ode2 => rk4SecondOrder(_text('expression'), parseNumber(_text('x0'), 'x inicial'), parseNumber(_text('y0'), 'y inicial'), parseNumber(_text('dy0'), 'dy/dx inicial'), parseNumber(_text('x1'), 'x final'), parseNumber(_text('steps'), 'os passos').round()),
      };
      setState(() {
        run = value;
        error = null;
      });
    } catch (exception) {
      setState(() {
        run = null;
        error = exception.toString().replaceFirst('FormatException: ', '').replaceFirst('Bad state: ', '');
      });
    }
  }

  String _label(String key) => switch (key) {
        'values' => 'Valores',
        'weights' => 'Pesos',
        'xs' => 'x',
        'ys' => 'y',
        'p' => 'Percentil p',
        'n' => 'n',
        'k' => 'k',
        'sample' => 'Amostra (1 = sim)',
        'coefficients' => 'Coeficientes a₀, a₁, …',
        'matrix' => 'Matriz, linhas separadas por ;',
        'vector' => 'Vetor b',
        'expression' => kind == SolverKind.ode1 || kind == SolverKind.ode2 ? 'dy/dx ou y′′' : 'Expressão em x',
        'lower' => 'Limite inferior',
        'upper' => 'Limite superior',
        'intervals' => 'Intervalos pares',
        'point' => 'Ponto x',
        'initial' => 'Valor inicial',
        'x0' => 'x inicial',
        'y0' => 'y inicial',
        'dy0' => 'dy/dx inicial',
        'x1' => 'x final',
        'steps' => 'Passos',
        _ => key,
      };

  @override
  Widget build(BuildContext context) {
    final spec = specs.firstWhere((item) => item.kind == kind);
    return ListView(
      key: const Key('solver-workspace'),
      children: [
        Text(widget.menu, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: VisionTheme.space8),
        Text(
          'Método numérico local. A aproximação não é apresentada como igualdade exata.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VisionTheme.mutedText),
        ),
        const SizedBox(height: VisionTheme.space16),
        VisionTabBar(
          tabs: [for (final item in specs) item.label],
          selected: spec.label,
          onSelected: (label) {
            setState(() => _load(specs.firstWhere((item) => item.label == label)));
          },
        ),
        const SizedBox(height: VisionTheme.space16),
        for (final entry in spec.initial.entries) ...[
          VisionField(
            key: Key('solver-${entry.key}'),
            controller: controllers[entry.key]!,
            label: _label(entry.key),
            keyboardType: entry.key == 'expression' || entry.key == 'matrix' || entry.key == 'coefficients'
                ? TextInputType.text
                : const TextInputType.numberWithOptions(decimal: true, signed: true),
          ),
          const SizedBox(height: VisionTheme.space12),
        ],
        VisionPrimaryButton(label: 'Resolver localmente', onPressed: solve),
        if (error != null) ...[
          const SizedBox(height: VisionTheme.space12),
          Text('Erro: $error', style: VisionTheme.inter(size: 14, color: VisionTheme.error, height: 21 / 14)),
        ],
        if (run != null) ...[
          const SizedBox(height: VisionTheme.space16),
          MathStepView(steps: run!.steps, pendingReview: false, resultText: run!.headline, unit: ''),
        ],
      ],
    );
  }
}
