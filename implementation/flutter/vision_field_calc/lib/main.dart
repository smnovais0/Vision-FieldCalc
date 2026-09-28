import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'advanced_solver.dart';
import 'ai_gateway.dart';
import 'calculation_record.dart';
import 'catalog_router.dart';
import 'generated/formula_engine.g.dart';
import 'local_solvers.dart';
import 'math_step_view.dart';
import 'privacy_analytics.dart';
import 'proposal_guard.dart';
import 'solver_workspace.dart';
import 'vision_theme.dart';
import 'widgets/vision_widgets.dart';

void main() => runApp(const VisionFieldCalcApp());

class VisionFieldCalcApp extends StatelessWidget {
  final VisionAiGateway? gateway;
  const VisionFieldCalcApp({super.key, this.gateway});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vision Field Calc',
      debugShowCheckedModeBanner: false,
      theme: VisionTheme.light,
      locale: const Locale('pt', 'PT'),
      supportedLocales: const [Locale('pt', 'PT')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: CalculatorHome(gateway: gateway),
    );
  }
}

class HistoryEntry {
  final String title;
  final String summary;
  final String exportJson;
  HistoryEntry(this.title, this.summary, this.exportJson);
}

class CalculatorHome extends StatefulWidget {
  final VisionAiGateway? gateway;
  const CalculatorHome({super.key, this.gateway});

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String menu = catalogMenus.first;
  FormulaDefinition? selected;
  final controllers = <String, TextEditingController>{};
  final problemController = TextEditingController();
  final filterController = TextEditingController();
  LocalCalculation? calculation;
  String? error;
  String? routingMessage;
  AiProposal? aiProposal;
  bool aiBusy = false;
  bool aiOffer = false;
  bool catalogOpen = false;
  bool historyOpen = false;
  String engineMode = 'Cálculo local';
  final history = <HistoryEntry>[];
  final _doomed = <TextEditingController>{};
  final _inputSnapshots = <String, String>{};

  @override
  void initState() {
    super.initState();
    filterController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  List<FormulaDefinition> get visible {
    final query = foldAccents(filterController.text.trim());
    return formulas.where((formula) {
      if (formula.menu != menu) return false;
      if (query.isEmpty) return true;
      final haystack = foldAccents('${formula.name} ${formula.id} ${formula.expression}');
      return haystack.contains(query);
    }).toList();
  }

  void _onInputEdited() {
    var changed = false;
    for (final entry in controllers.entries) {
      if (_inputSnapshots[entry.key] != entry.value.text) {
        _inputSnapshots[entry.key] = entry.value.text;
        changed = true;
      }
    }
    if (changed && calculation != null) setState(() => calculation = null);
  }

  void _releaseControllers() {
    for (final controller in controllers.values) {
      controller.removeListener(_onInputEdited);
      _doomed.add(controller);
    }
    controllers.clear();
    _inputSnapshots.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _flushDoomed());
  }

  void _flushDoomed() {
    final retiring = List<TextEditingController>.of(_doomed);
    _doomed.clear();
    for (final controller in retiring) {
      controller.dispose();
    }
  }

  void choose(FormulaDefinition formula) {
    _releaseControllers();
    PrivacyAnalytics.record('formula_opened', {
      'formula_id': formula.id,
      'formula_version': catalogVersion,
      'menu': formula.menu,
    });
    setState(() {
      selected = formula;
      menu = formula.menu;
      for (final input in formula.inputs) {
        final controller = TextEditingController();
        controller.addListener(_onInputEdited);
        controllers[input] = controller;
      }
      calculation = null;
      error = null;
      catalogOpen = false;
    });
  }

  void clearWork() {
    _releaseControllers();
    problemController.clear();
    filterController.clear();
    setState(() {
      selected = null;
      calculation = null;
      error = null;
      routingMessage = null;
      aiProposal = null;
      aiOffer = false;
      aiBusy = false;
      engineMode = 'Cálculo local';
    });
  }

  void routeProblem() {
    try {
      final plan = planNaturalLanguage(problemController.text);
      if (!plan.needsAi && plan.formula != null) {
        choose(plan.formula!);
        setState(() {
          routingMessage = plan.reason;
          engineMode = 'Cálculo local';
          aiOffer = false;
          aiProposal = null;
        });
        return;
      }
      setState(() {
        routingMessage = plan.reason;
        engineMode = 'Interpretação por IA';
        aiOffer = true;
        calculation = null;
        error = null;
      });
    } on FormatException catch (exception) {
      setState(() => routingMessage = exception.message);
    }
  }

  Future<void> interpretWithAi() async {
    final problem = problemController.text.trim();
    setState(() {
      aiBusy = true;
      aiProposal = null;
      error = null;
    });
    try {
      final proposal = await (widget.gateway ?? VisionAiGateway()).interpret(problem);
      if (!mounted) return;
      final match = proposal.formulaId == null ? null : formulaById(proposal.formulaId!);
      if (match != null) choose(match);
      _applyProposalValues(proposal);
      PrivacyAnalytics.record('ai_parse_result', {'mode': 'interpret_only', 'status': 'proposed'});
      setState(() {
        aiProposal = proposal;
        aiOffer = false;
        engineMode = 'Interpretação por IA';
        routingMessage = 'Proposta da IA recebida. Confirme fórmula, variáveis, unidades e hipóteses antes de calcular.';
      });
    } catch (exception) {
      if (!mounted) return;
      final message = exception.toString().replaceFirst('Bad state: ', '');
      final status = message.contains('quota')
          ? 'quota'
          : message.contains('rede')
              ? 'offline'
              : message.contains('configurado')
                  ? 'unconfigured'
                  : 'rejected';
      PrivacyAnalytics.record('ai_parse_result', {'mode': 'interpret_only', 'status': status});
      setState(() => error = message);
    } finally {
      if (mounted) setState(() => aiBusy = false);
    }
  }

  void _applyProposalValues(AiProposal proposal) {
    for (final entry in proposal.variables.entries) {
      final controller = controllers[entry.key];
      final value = entry.value;
      if (controller != null && (value is num || value is String)) {
        controller.text = '$value';
      }
    }
  }

  void confirmProposal() {
    final proposal = aiProposal;
    if (proposal == null) return;
    final review = reviewProposal(
      formulaId: proposal.formulaId,
      proposedExpression: proposal.proposedExpression,
      displayMath: proposal.displayMath,
      assumptions: proposal.assumptions,
      steps: proposal.explanationSteps,
      missingFields: proposal.missingFields,
      variables: proposal.variables,
    );
    PrivacyAnalytics.record('ai_parse_result', {'mode': 'interpret_only', 'status': review.status});
    if (review.formula != null) {
      choose(review.formula!);
      _applyProposalValues(proposal);
      setState(() {
        routingMessage = review.message;
        engineMode = 'Cálculo local';
      });
      calculate();
      return;
    }
    if (review.localValue != null) {
      final value = review.localValue!;
      setState(() {
        calculation = LocalCalculation(value, [
          CalculationStep('Expressão confirmada', proposal.proposedExpression, 'Recalculada no dispositivo a partir da expressão proposta.'),
          CalculationStep('Valor local', '$value', 'Este número não vem do modelo e não certifica a expressão.'),
        ]);
        error = null;
        routingMessage = review.message;
        engineMode = 'Cálculo local';
        history.insert(0, HistoryEntry('Expressão confirmada', '$value', jsonEncode({'status': 'local_expression', 'result': value})));
      });
      return;
    }
    setState(() {
      calculation = null;
      error = review.status == 'blocked' || review.status == 'missing' ? review.message : null;
      routingMessage = review.message;
      engineMode = 'Interpretação por IA';
    });
  }

  void calculate() {
    final formula = selected;
    if (formula == null) return;
    try {
      final values = <String, double>{
        for (final entry in controllers.entries) entry.key: parseNumber(entry.value.text, entry.key),
      };
      final result = calculateFormula(formula, values);
      final record = calculationRecord(
        formulaId: formula.id,
        formulaVersion: catalogVersion,
        engineVersion: engineVersion,
        status: formula.status,
        inputs: values,
        result: result.value,
        unit: formula.unit,
        limitations: formula.status == 'review_pending'
            ? (formula.notes.isEmpty ? 'Revisão pendente. O cálculo não certifica conformidade.' : formula.notes)
            : 'Cálculo local do catálogo $catalogVersion.',
        confirmedAt: DateTime.now(),
      );
      PrivacyAnalytics.record('calculation_completed', {
        'formula_id': formula.id,
        'formula_version': catalogVersion,
        'outcome': 'completed',
        'status': formula.status,
      });
      setState(() {
        calculation = result;
        error = null;
        engineMode = 'Cálculo local';
        history.insert(0, HistoryEntry(formula.name, '${result.value} ${formula.unit}', jsonEncode(record)));
      });
    } on FormatException catch (exception) {
      PrivacyAnalytics.record('validation_failed', {
        'formula_id': formula.id,
        'code': 'domain',
        'status': formula.status,
      });
      setState(() {
        calculation = null;
        error = exception.message;
      });
    }
  }

  @override
  void dispose() {
    _releaseControllers();
    _flushDoomed();
    problemController.dispose();
    filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 960;
      final compact = constraints.maxHeight < 860;
      final gutter = !wide ? VisionTheme.space20 : (constraints.maxWidth >= 1265 ? VisionTheme.space64 : VisionTheme.space32);
      final blockGap = compact ? VisionTheme.space16 : VisionTheme.space32;
      return Scaffold(
        backgroundColor: VisionTheme.canvas,
        body: SafeArea(
          child: Padding(
            key: const Key('page-padding'),
            padding: EdgeInsets.fromLTRB(gutter, compact ? VisionTheme.space12 : VisionTheme.space16, gutter, compact ? VisionTheme.space20 : VisionTheme.space32),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: VisionTheme.contentMaxWidth),
                child: Column(children: [
                  _statusBar(wide),
                  SizedBox(height: compact ? VisionTheme.space8 : VisionTheme.space16),
                  _header(wide),
                  SizedBox(height: blockGap),
                  _intro(wide && !compact),
                  SizedBox(height: blockGap),
                  Expanded(child: _panel(wide, compact)),
                ]),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _statusBar(bool wide) {
    return Row(children: [
      Expanded(child: Text(engineMode, key: const Key('engine-status'), style: VisionTheme.inter(size: 14, height: 21 / 14))),
      TextButton(onPressed: () => setState(() => historyOpen = !historyOpen), child: Text(historyOpen ? 'Fechar' : 'Histórico')),
      if (wide)
        TextButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const AdvancedSolverPage())),
          child: const Text('Avançado'),
        ),
    ]);
  }

  Widget _header(bool wide) {
    return Row(children: [
      if (!wide)
        IconButton(
          key: const Key('open-catalog'),
          tooltip: 'Abrir catálogo',
          onPressed: () => setState(() => catalogOpen = !catalogOpen),
          icon: const Icon(Icons.menu),
        ),
      Expanded(child: Text('Vision Field Calc', style: Theme.of(context).textTheme.titleLarge)),
      VisionSecondaryButton(label: 'Limpar', onPressed: clearWork),
    ]);
  }

  Widget _intro(bool wide) {
    final title = Text(
      'Cálculo técnico, no dispositivo.',
      style: wide ? Theme.of(context).textTheme.displayLarge : Theme.of(context).textTheme.headlineSmall,
    );
    final copy = Text(
      'A Vision Field Calc procura primeiro uma fórmula local. A IA só interpreta o que o motor não resolve, e o resultado numérico continua a ser confirmado e calculado no dispositivo.',
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: VisionTheme.mutedText),
    );
    if (!wide) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        title,
        const SizedBox(height: VisionTheme.space12),
        copy,
      ]);
    }
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(flex: 3, child: title),
      const SizedBox(width: VisionTheme.space64),
      Expanded(flex: 2, child: copy),
    ]);
  }

  Widget _panel(bool wide, bool compact) {
    return VisionPanel(
      padding: EdgeInsets.all(wide && !compact ? VisionTheme.space32 : VisionTheme.space20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SizedBox(height: 4, child: aiBusy ? const LinearProgressIndicator(minHeight: 2) : const SizedBox.shrink()),
        const SizedBox(height: VisionTheme.space12),
        VisionTabBar(
          scrollKey: const Key('menu-tabs'),
          tabs: catalogMenus,
          selected: menu,
          onSelected: (value) => setState(() {
            menu = value;
            selected = null;
            calculation = null;
            error = null;
            _releaseControllers();
          }),
        ),
        const SizedBox(height: VisionTheme.space24),
        Expanded(
          child: historyOpen
              ? _historyPanel()
              : wide
                  ? Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      SizedBox(width: 360, child: _catalog()),
                      const SizedBox(width: VisionTheme.space32),
                      Expanded(child: _work()),
                    ])
                  : catalogOpen
                      ? _catalog()
                      : _work(),
        ),
      ]),
    );
  }

  Widget _catalog() {
    final solver = solverMenus.contains(menu);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      VisionField(
        key: const Key('problem-field'),
        controller: problemController,
        label: 'Descreva o cálculo',
        keyboardType: TextInputType.text,
        onSubmitted: (_) => routeProblem(),
      ),
      const SizedBox(height: VisionTheme.space12),
      VisionPrimaryButton(key: const Key('route-local'), label: 'Procurar no motor local', onPressed: routeProblem),
      if (aiOffer) ...[
        const SizedBox(height: VisionTheme.space8),
        VisionPrimaryButton(key: const Key('continue-ai'), label: 'Continuar com IA', onPressed: aiBusy ? null : () => interpretWithAi()),
      ],
      if (error != null) _error(error!),
      const SizedBox(height: VisionTheme.space12),
      Expanded(
        child: ListView(
          key: const Key('catalog-list'),
          children: [
        if (routingMessage != null) ...[
          const SizedBox(height: VisionTheme.space12),
          Text(routingMessage!, style: Theme.of(context).textTheme.bodyMedium),
        ],
        if (error != null) ...[
          const SizedBox(height: VisionTheme.space12),
          _error(error!),
        ],
        if (aiOffer) ...[
          const SizedBox(height: VisionTheme.space16),
          Text(
            'O pedido pode ser enviado ao Vision AI Gateway. A IA propõe a fórmula, variáveis, unidades e hipóteses. Nenhum resultado é aceite até confirmar esses parâmetros.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: VisionTheme.space12),
          VisionSecondaryButton(label: 'Cancelar', onPressed: () => setState(() {
            aiOffer = false;
            engineMode = 'Cálculo local';
          })),
        ],
        const SizedBox(height: VisionTheme.space16),
        if (solver)
          Text(
            'Este menu usa solucionadores numéricos locais, com os passos e a notação matemática no ecrã.',
            style: Theme.of(context).textTheme.bodyMedium,
          )
        else ...[
          VisionField(
            controller: filterController,
            label: 'Filtrar neste menu',
            keyboardType: TextInputType.text,
            onSubmitted: (_) => setState(() {}),
          ),
          const SizedBox(height: VisionTheme.space12),
          for (final formula in visible)
            Padding(
              padding: const EdgeInsets.only(bottom: VisionTheme.space8),
              child: Material(
                color: selected?.id == formula.id ? VisionTheme.white : Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VisionTheme.radiusControl)),
                child: InkWell(
                  onTap: () => choose(formula),
                  borderRadius: BorderRadius.circular(VisionTheme.radiusControl),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 44),
                    padding: const EdgeInsets.symmetric(horizontal: VisionTheme.space12, vertical: VisionTheme.space8),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(formula.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: VisionTheme.inter(size: 16, height: 24 / 16)),
                      Text(prettyMath(formula.expression), maxLines: 1, overflow: TextOverflow.ellipsis, style: VisionTheme.math.copyWith(fontSize: 16, color: VisionTheme.mutedText)),
                    ]),
                  ),
                ),
              ),
            ),
        ],
          ],
        ),
      ),
    ]);
  }

  Widget _work() {
    if (solverMenus.contains(menu)) return SolverWorkspace(menu: menu);
    final formula = selected;
    if (formula == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(key: const Key('work-list'), children: [
              Semantics(
                label: 'Notação suportada: integral, somatório, pi, sigma, mu, delta, teta, lambda, ró, ómega, x, y e derivada',
                child: const SelectableText(
                  '∫    ∑    √    π    σ    μ    Δ    θ    λ    ρ    ω    x    y    dy/dx',
                  key: Key('math-notation'),
                  style: VisionTheme.math,
                ),
              ),
              if (aiProposal != null) ...[
                const SizedBox(height: VisionTheme.space16),
                AiProposalPanel(proposal: aiProposal!, onConfirm: confirmProposal, showAction: false),
              ],
              const SizedBox(height: VisionTheme.space16),
              Text('Escolha uma fórmula no catálogo.', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: VisionTheme.space12),
              Text(
                'Cada resultado mostra a fórmula, os dados confirmados, o domínio, a substituição e o valor. Entradas em revisão pendente continuam calculáveis e avisam que a validação técnica ainda não foi feita.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ]),
          ),
          if (aiProposal != null) ...[
            const SizedBox(height: VisionTheme.space12),
            VisionPrimaryButton(key: const Key('confirm-ai'), label: 'Confirmar parâmetros', onPressed: confirmProposal),
          ],
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            key: const Key('work-list'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormulaCard(
                  name: formula.name,
                  expression: prettyMath(formula.expression),
                  spoken: formula.expression,
                  unit: formula.unit,
                  statusLabel: formula.status == 'review_pending' ? 'Revisão pendente' : 'Implementado',
                  version: catalogVersion,
                ),
                const SizedBox(height: VisionTheme.space16),
                for (final input in formula.inputs) ...[
                  VisionField(key: Key('input-$input'), controller: controllers[input]!, label: input),
                  const SizedBox(height: VisionTheme.space12),
                ],
                if (error != null) _error(error!),
                if (calculation != null) ...[
                  const SizedBox(height: VisionTheme.space16),
                  MathStepView(
                    steps: calculation!.steps,
                    pendingReview: formula.status == 'review_pending',
                    resultText: '${calculation!.value}',
                    unit: formula.unit,
                  ),
                ],
              if (aiProposal != null) ...[
                const SizedBox(height: VisionTheme.space16),
                AiProposalPanel(proposal: aiProposal!, onConfirm: confirmProposal, showAction: false),
              ],
              ],
            ),
          ),
        ),
        const SizedBox(height: VisionTheme.space12),
        VisionPrimaryButton(key: const Key('calculate-local'), label: 'Confirmar parâmetros e calcular', onPressed: calculate),
      ],
    );
  }

  Widget _historyPanel() {
    if (history.isEmpty) {
      return Text('Ainda não há cálculos nesta sessão. O histórico fica no dispositivo e pode ser apagado.', style: Theme.of(context).textTheme.bodyLarge);
    }
    return ListView(children: [
      Row(children: [
        Expanded(child: Text('Histórico local desta sessão', style: Theme.of(context).textTheme.titleMedium)),
        VisionSecondaryButton(label: 'Apagar tudo', onPressed: () => setState(history.clear)),
      ]),
      const SizedBox(height: VisionTheme.space16),
      for (var index = 0; index < history.length; index++)
        Padding(
          padding: const EdgeInsets.only(bottom: VisionTheme.space12),
          child: Container(
            padding: const EdgeInsets.all(VisionTheme.space16),
            decoration: BoxDecoration(
              color: VisionTheme.white,
              borderRadius: BorderRadius.circular(VisionTheme.radiusControl),
              border: Border.all(color: VisionTheme.subtleBorder, width: 0.5),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(history[index].title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: VisionTheme.space8),
              SelectableText(history[index].summary, style: VisionTheme.math.copyWith(fontSize: 22)),
              const SizedBox(height: VisionTheme.space8),
              SelectableText(history[index].exportJson, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: VisionTheme.space8),
              VisionSecondaryButton(
                label: 'Apagar',
                onPressed: () => setState(() => history.removeAt(index)),
              ),
            ]),
          ),
        ),
    ]);
  }

  Widget _error(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: VisionTheme.space12),
      child: Text('Erro: $message', style: VisionTheme.inter(size: 14, color: VisionTheme.error, height: 21 / 14)),
    );
  }
}
