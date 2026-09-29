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
import 'l10n/app_text.dart';
import 'l10n/formula_names.dart';
import 'privacy_analytics.dart';
import 'proposal_guard.dart';
import 'solver_workspace.dart';
import 'vision_theme.dart';
import 'widgets/vision_widgets.dart';

void main() => runApp(const VisionFieldCalcApp());

class VisionFieldCalcApp extends StatefulWidget {
  final VisionAiGateway? gateway;
  const VisionFieldCalcApp({super.key, this.gateway});

  @override
  State<VisionFieldCalcApp> createState() => _VisionFieldCalcAppState();
}

class _VisionFieldCalcAppState extends State<VisionFieldCalcApp> {
  Locale _locale = const Locale('en');

  void _selectLocale(Locale locale) {
    if (AppText.plannedLanguageCodes.contains(locale.languageCode)) return;
    if (!AppText.pickerLocales.any((item) => item == locale)) return;
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    final text = AppText(_locale.languageCode);
    return AppScope(
      text: text,
      onLocale: _selectLocale,
      child: MaterialApp(
        title: 'Vision Field Calc',
        debugShowCheckedModeBanner: false,
        theme: VisionTheme.light,
        locale: _locale,
        supportedLocales: AppText.supported,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: CalculatorHome(gateway: widget.gateway),
      ),
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
  String engineMode = 'local';
  int? errorStatus;
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
      final haystack = foldAccents('${formulaSearchBlob(formula.id, formula.name)} ${formula.expression}');
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
      engineMode = 'local';
      errorStatus = null;
    });
  }

  void routeProblem() {
    try {
      final plan = planNaturalLanguage(problemController.text);
      if (!plan.needsAi && plan.formula != null) {
        choose(plan.formula!);
        setState(() {
          routingMessage = plan.reason;
          engineMode = 'local';
          aiOffer = false;
          aiProposal = null;
        });
        return;
      }
      setState(() {
        routingMessage = plan.reason;
        engineMode = 'ai';
        aiOffer = true;
        calculation = null;
        error = null;
        errorStatus = null;
      });
    } on FormatException catch (exception) {
      setState(() => routingMessage = exception.message);
    }
  }

  Future<void> interpretWithAi() async {
    final problem = problemController.text.trim();
    final localeTag = AppScope.of(context).text.localeTag;
    setState(() {
      aiBusy = true;
      aiProposal = null;
      error = null;
      errorStatus = null;
    });
    try {
      final proposal = await (widget.gateway ?? VisionAiGateway()).interpret(problem, locale: localeTag);
      if (!mounted) return;
      final match = proposal.formulaId == null ? null : formulaById(proposal.formulaId!);
      if (match != null) choose(match);
      _applyProposalValues(proposal);
      PrivacyAnalytics.record('ai_parse_result', {'mode': 'interpret_only', 'status': 'proposed'});
      setState(() {
        aiProposal = proposal;
        aiOffer = false;
        engineMode = 'ai';
        routingMessage = 'proposal_received';
      });
    } on GatewayFailure catch (failure) {
      if (!mounted) return;
      PrivacyAnalytics.record('ai_parse_result', {'mode': 'interpret_only', 'status': failure.code});
      setState(() {
        error = failure.code;
        errorStatus = failure.statusCode;
      });
    } catch (exception) {
      if (!mounted) return;
      PrivacyAnalytics.record('ai_parse_result', {'mode': 'interpret_only', 'status': 'rejected'});
      setState(() {
        error = exception.toString().replaceFirst('Bad state: ', '');
        errorStatus = null;
      });
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
        engineMode = 'local';
        errorStatus = null;
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
        errorStatus = null;
        routingMessage = review.message;
        engineMode = 'local';
        history.insert(0, HistoryEntry('Expressão confirmada', '$value', jsonEncode({'status': 'local_expression', 'result': value})));
      });
      return;
    }
    setState(() {
      calculation = null;
      error = review.status == 'blocked' || review.status == 'missing' ? review.message : null;
      errorStatus = null;
      routingMessage = review.message;
      engineMode = 'ai';
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
      final text = AppScope.of(context).text;
      final record = calculationRecord(
        formulaId: formula.id,
        formulaVersion: catalogVersion,
        engineVersion: engineVersion,
        status: formula.status,
        inputs: values,
        result: result.value,
        unit: formula.unit,
        limitations: text.limitations(formula.status, formula.notes, catalogVersion),
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
        engineMode = 'local';
        history.insert(0, HistoryEntry(formula.id, '${result.value} ${formula.unit}', jsonEncode(record)));
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
        errorStatus = null;
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

  String _historyTitle(AppText text, String titleId) {
    final formula = formulaById(titleId);
    if (formula != null) return text.formulaName(formula.id, formula.name);
    return text.phrase(titleId);
  }

  Widget _statusBar(bool wide) {
    final text = AppScope.of(context).text;
    return Row(children: [
      Expanded(
        child: Text(
          engineMode == 'ai' ? text.aiMode : text.localMode,
          key: const Key('engine-status'),
          style: VisionTheme.inter(size: 14, height: 21 / 14),
        ),
      ),
      TextButton(onPressed: () => setState(() => historyOpen = !historyOpen), child: Text(historyOpen ? text.closeHistory : text.history)),
      if (wide)
        TextButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const AdvancedSolverPage())),
          child: Text(text.advanced),
        ),
    ]);
  }

  Widget _header(bool wide) {
    final text = AppScope.of(context).text;
    return Row(children: [
      if (!wide)
        IconButton(
          key: const Key('open-catalog'),
          tooltip: text.openCatalog,
          onPressed: () => setState(() => catalogOpen = !catalogOpen),
          icon: const Icon(Icons.menu),
        ),
      Expanded(
        child: Text('Vision Field Calc', maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleLarge),
      ),
      const LanguageButton(),
      VisionSecondaryButton(label: text.clear, onPressed: clearWork),
    ]);
  }

  Widget _intro(bool wide) {
    final text = AppScope.of(context).text;
    final title = Text(
      text.headline,
      style: wide ? Theme.of(context).textTheme.displayLarge : Theme.of(context).textTheme.headlineSmall,
    );
    final copy = Text(
      text.intro,
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
          labels: [for (final item in catalogMenus) AppScope.of(context).text.menu(item)],
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
    final text = AppScope.of(context).text;
    final solver = solverMenus.contains(menu);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      VisionField(
        key: const Key('problem-field'),
        controller: problemController,
        label: text.describe,
        keyboardType: TextInputType.text,
        onSubmitted: (_) => routeProblem(),
      ),
      const SizedBox(height: VisionTheme.space12),
      VisionPrimaryButton(key: const Key('route-local'), label: text.searchLocal, onPressed: routeProblem),
      if (aiOffer) ...[
        const SizedBox(height: VisionTheme.space8),
        VisionPrimaryButton(key: const Key('continue-ai'), label: text.continueAi, onPressed: aiBusy ? null : () => interpretWithAi()),
      ],
      if (error != null) _error(error!),
      const SizedBox(height: VisionTheme.space12),
      Expanded(
        child: ListView(
          key: const Key('catalog-list'),
          children: [
        if (routingMessage != null) ...[
          const SizedBox(height: VisionTheme.space12),
          Text(text.present(routingMessage!, statusCode: errorStatus), style: Theme.of(context).textTheme.bodyMedium),
        ],
        if (aiOffer) ...[
          const SizedBox(height: VisionTheme.space16),
          Text(text.aiExplain, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: VisionTheme.space12),
          VisionSecondaryButton(label: text.cancel, onPressed: () => setState(() {
            aiOffer = false;
            engineMode = 'local';
          })),
        ],
        const SizedBox(height: VisionTheme.space16),
        if (solver)
          Text(text.solverIntro, style: Theme.of(context).textTheme.bodyMedium)
        else ...[
          VisionField(
            controller: filterController,
            label: text.filter,
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
                      Text(text.formulaName(formula.id, formula.name), maxLines: 2, overflow: TextOverflow.ellipsis, style: VisionTheme.inter(size: 16, height: 24 / 16)),
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
    final text = AppScope.of(context).text;
    if (solverMenus.contains(menu)) return SolverWorkspace(menu: menu);
    final formula = selected;
    if (formula == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(key: const Key('work-list'), children: [
              Semantics(
                label: text.notationLabel,
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
              Text(text.chooseFormula, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: VisionTheme.space12),
              Text(text.chooseBody, style: Theme.of(context).textTheme.bodyLarge),
            ]),
          ),
          if (aiProposal != null) ...[
            const SizedBox(height: VisionTheme.space12),
            VisionPrimaryButton(key: const Key('confirm-ai'), label: text.confirmParameters, onPressed: confirmProposal),
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
                  name: text.formulaName(formula.id, formula.name),
                  expression: prettyMath(formula.expression),
                  spoken: formula.expression,
                  unit: formula.unit,
                  statusLabel: formula.status == 'review_pending' ? text.pending : text.implemented,
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
        VisionPrimaryButton(key: const Key('calculate-local'), label: text.confirmCalculate, onPressed: calculate),
      ],
    );
  }

  Widget _historyPanel() {
    final text = AppScope.of(context).text;
    if (history.isEmpty) {
      return Text(text.historyEmpty, style: Theme.of(context).textTheme.bodyLarge);
    }
    return ListView(children: [
      Row(children: [
        Expanded(child: Text(text.historyTitle, style: Theme.of(context).textTheme.titleMedium)),
        VisionSecondaryButton(label: text.deleteAll, onPressed: () => setState(history.clear)),
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
              Text(_historyTitle(text, history[index].title), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: VisionTheme.space8),
              SelectableText(history[index].summary, style: VisionTheme.math.copyWith(fontSize: 22)),
              const SizedBox(height: VisionTheme.space8),
              SelectableText(history[index].exportJson, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: VisionTheme.space8),
              VisionSecondaryButton(
                label: text.deleteOne,
                onPressed: () => setState(() => history.removeAt(index)),
              ),
            ]),
          ),
        ),
    ]);
  }

  Widget _error(String message) {
    final text = AppScope.of(context).text;
    final shown = text.present(message, statusCode: errorStatus);
    return Padding(
      padding: const EdgeInsets.only(top: VisionTheme.space12),
      child: Text('${text.errorPrefix}: $shown', style: VisionTheme.inter(size: 14, color: VisionTheme.error, height: 21 / 14)),
    );
  }
}
