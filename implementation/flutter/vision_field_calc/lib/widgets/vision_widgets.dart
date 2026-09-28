import 'package:flutter/material.dart';

import '../ai_gateway.dart';
import '../vision_theme.dart';

class VisionPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const VisionPanel({super.key, required this.child, this.padding = const EdgeInsets.all(VisionTheme.space32)});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: VisionTheme.panel,
        borderRadius: BorderRadius.circular(VisionTheme.radiusPanel),
        border: Border.all(color: VisionTheme.subtleBorder, width: 0.5),
      ),
      padding: padding,
      child: child,
    );
  }
}

class VisionPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  const VisionPrimaryButton({super.key, required this.label, required this.onPressed, this.busy = false});

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    return FilledButton(
      onPressed: busy ? null : onPressed,
      style: FilledButton.styleFrom(
        animationDuration: reduce ? Duration.zero : VisionTheme.motion,
      ),
      child: busy
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: VisionTheme.white))
          : Text(label),
    );
  }
}

class VisionSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const VisionSecondaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(9999)),
        boxShadow: VisionTheme.controlShadow,
      ),
      child: OutlinedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}

class VisionTabBar extends StatelessWidget {
  final List<String> tabs;
  final String selected;
  final ValueChanged<String> onSelected;
  final Key? scrollKey;
  const VisionTabBar({super.key, required this.tabs, required this.selected, required this.onSelected, this.scrollKey});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: scrollKey,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final tab in tabs) ...[
            _TabChip(label: tab, active: tab == selected, onTap: () => onSelected(tab)),
            const SizedBox(width: VisionTheme.space8),
          ],
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: Material(
        color: active ? VisionTheme.white : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VisionTheme.radiusControl),
          side: BorderSide(color: active ? VisionTheme.subtleBorder : Colors.transparent, width: 0.5),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(VisionTheme.radiusControl),
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            decoration: active
                ? const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(14)), boxShadow: VisionTheme.controlShadow)
                : null,
            padding: const EdgeInsets.symmetric(horizontal: VisionTheme.space16, vertical: VisionTheme.space12),
            child: Text(label, style: VisionTheme.inter(size: 14, height: 21 / 14, color: active ? VisionTheme.black : VisionTheme.mutedText)),
          ),
        ),
      ),
    );
  }
}

class VisionField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? unit;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;
  final TextInputType keyboardType;
  const VisionField({
    super.key,
    required this.controller,
    required this.label,
    this.unit,
    this.errorText,
    this.onSubmitted,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true, signed: true),
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      scrollPadding: EdgeInsets.zero,
      onSubmitted: onSubmitted,
      style: VisionTheme.inter(size: 16, height: 24 / 16),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        suffixText: unit,
        suffixStyle: VisionTheme.inter(size: 14, color: VisionTheme.mutedText, height: 21 / 14),
      ),
    );
  }
}

class FormulaCard extends StatelessWidget {
  final String name;
  final String expression;
  final String spoken;
  final String unit;
  final String statusLabel;
  final String version;
  const FormulaCard({
    super.key,
    required this.name,
    required this.expression,
    required this.spoken,
    required this.unit,
    required this.statusLabel,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(VisionTheme.space20),
      decoration: BoxDecoration(
        color: VisionTheme.white,
        borderRadius: BorderRadius.circular(VisionTheme.radiusControl),
        border: Border.all(color: VisionTheme.subtleBorder, width: 0.5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: VisionTheme.space8),
        Text('$statusLabel · catálogo $version · unidade $unit', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: VisionTheme.space16),
        Semantics(
          label: 'Fórmula: $spoken',
          child: Text(expression, maxLines: 2, overflow: TextOverflow.ellipsis, style: VisionTheme.math),
        ),
      ]),
    );
  }
}

class AiProposalPanel extends StatelessWidget {
  final AiProposal proposal;
  final VoidCallback onConfirm;
  final bool showAction;
  const AiProposalPanel({super.key, required this.proposal, required this.onConfirm, this.showAction = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('ai-proposal'),
      width: double.infinity,
      padding: const EdgeInsets.all(VisionTheme.space20),
      decoration: BoxDecoration(
        color: VisionTheme.white,
        borderRadius: BorderRadius.circular(VisionTheme.radiusControl),
        border: Border.all(color: VisionTheme.subtleBorder, width: 0.5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Proposta da IA — confirmar antes de calcular', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: VisionTheme.space8),
        Text(
          'Esta proposta não é um resultado validado. Confirme fórmula, variáveis, unidades e hipóteses. O número, quando existir, volta a ser calculado pelo motor local.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (proposal.displayMath.isNotEmpty) ...[
          const SizedBox(height: VisionTheme.space16),
          SelectableText(proposal.displayMath, style: VisionTheme.math),
        ],
        const SizedBox(height: VisionTheme.space12),
        Text('Variáveis: ${proposal.variables}', style: Theme.of(context).textTheme.bodyMedium),
        Text('Unidades: ${proposal.units}', style: Theme.of(context).textTheme.bodyMedium),
        if (proposal.assumptions.isNotEmpty)
          Text('Hipóteses: ${proposal.assumptions.join('; ')}', style: Theme.of(context).textTheme.bodyMedium),
        if (proposal.missingFields.isNotEmpty)
          Text('Em falta: ${proposal.missingFields.join(', ')}', style: Theme.of(context).textTheme.bodyMedium),
        if (proposal.confidence != null)
          Text('Confiança da proposta: ${proposal.confidence}', style: Theme.of(context).textTheme.bodySmall),
        Text('Modo: ${proposal.providerMode}. Um número remoto não é resultado.', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: VisionTheme.space12),
        for (var index = 0; index < proposal.explanationSteps.length; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: VisionTheme.space8),
            child: SelectableText('${index + 1}. ${proposal.explanationSteps[index]}', style: VisionTheme.math.copyWith(fontSize: 18)),
          ),
        if (showAction) ...[
          const SizedBox(height: VisionTheme.space8),
          VisionPrimaryButton(key: const Key('confirm-ai'), label: 'Confirmar parâmetros', onPressed: onConfirm),
        ],
      ]),
    );
  }
}
