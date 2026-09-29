import 'package:flutter/material.dart';

import 'generated/formula_engine.g.dart';
import 'l10n/app_text.dart';
import 'unit_policy.dart';
import 'vision_theme.dart';

class MathStepView extends StatelessWidget {
  final List<CalculationStep> steps;
  final bool pendingReview;
  final String? resultText;
  final String? unit;
  const MathStepView({super.key, required this.steps, required this.pendingReview, this.resultText, this.unit});

  @override
  Widget build(BuildContext context) {
    final text = AppScope.of(context).text;
    final imperial = _imperialNote(resultText, unit);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (pendingReview)
        Container(
          key: const Key('review-pending'),
          margin: const EdgeInsets.only(bottom: VisionTheme.space16),
          padding: const EdgeInsets.all(VisionTheme.space16),
          decoration: BoxDecoration(
            color: VisionTheme.white,
            borderRadius: BorderRadius.circular(VisionTheme.radiusControl),
            border: Border.all(color: VisionTheme.black, width: 1),
          ),
          child: Text(text.reviewPending, style: VisionTheme.inter(size: 16, height: 24 / 16)),
        ),
      if (resultText != null && unit != null) ...[
        ResultLine(value: resultText!, unit: unit!),
        if (imperial != null) ...[
          const SizedBox(height: VisionTheme.space8),
          Text(text.imperialLine(imperial, resultText!, unit!), style: Theme.of(context).textTheme.bodySmall),
        ],
        const SizedBox(height: VisionTheme.space8),
        Text(text.unitNote(unit!), style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: VisionTheme.space16),
      ],
      for (var index = 0; index < steps.length; index++) ...[
        if (index > 0) const SizedBox(height: VisionTheme.space12),
        _StepCard(index: index + 1, step: steps[index]),
      ],
      const SizedBox(height: VisionTheme.space16),
      Semantics(
        label: text.notationLabel,
        child: SelectableText(
          text.notationLine,
          style: VisionTheme.math.copyWith(fontSize: 20),
        ),
      ),
    ]);
  }
}

String? _imperialNote(String? resultText, String? unit) {
  if (resultText == null || unit == null) return null;
  final value = double.tryParse(resultText.trim());
  if (value == null) return null;
  return UnitPolicy.imperialEquivalent(value, unit);
}

class ResultLine extends StatelessWidget {
  final String value;
  final String unit;
  const ResultLine({super.key, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    final text = AppScope.of(context).text;
    return Semantics(
      label: text.resultLabel(value, unit),
      child: Container(
        key: const Key('result-value'),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: VisionTheme.space24, vertical: VisionTheme.space20),
        decoration: BoxDecoration(color: VisionTheme.black, borderRadius: BorderRadius.circular(VisionTheme.radiusPanel)),
        child: SelectableText(
          unit.isEmpty ? value : '$value $unit',
          style: VisionTheme.inter(size: 32, weight: FontWeight.w400, height: 1.2, letterSpacing: -0.4, color: VisionTheme.white),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int index;
  final CalculationStep step;
  const _StepCard({required this.index, required this.step});

  @override
  Widget build(BuildContext context) {
    final text = AppScope.of(context).text;
    return Container(
      padding: const EdgeInsets.all(VisionTheme.space16),
      decoration: BoxDecoration(
        color: VisionTheme.white,
        borderRadius: BorderRadius.circular(VisionTheme.radiusControl),
        border: Border.all(color: VisionTheme.subtleBorder, width: 0.5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$index. ${_shown(text, step.title)}', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: VisionTheme.space8),
        Semantics(
          label: _shown(text, step.explanation),
          child: Text(step.mathematics, style: VisionTheme.math.copyWith(fontSize: 22)),
        ),
        const SizedBox(height: VisionTheme.space8),
        Text(_shown(text, step.explanation), style: Theme.of(context).textTheme.bodyMedium),
      ]),
    );
  }
}

String _shown(AppText text, String raw) {
  final localized = text.phrase(raw);
  final bare = raw.replaceFirst(RegExp(r'^\d+\.\s*'), '');
  if (localized != bare) return localized;
  for (final formula in formulas) {
    if (formula.name == bare) return text.formulaName(formula.id, formula.name);
  }
  return localized;
}
