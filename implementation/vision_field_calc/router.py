from __future__ import annotations
from dataclasses import dataclass
from typing import Callable, Mapping, Any

from .engine import CalculationEngine, CalculationError


@dataclass(frozen=True)
class RouteDecision:
    route: str
    reason_pt: str
    result: Any = None
    ai_request: dict | None = None


class CalculationRouter:
    """Aplica a política local-first e prepara fallback de IA sem o executar."""

    def __init__(self, engine: CalculationEngine | None = None):
        self.engine = engine or CalculationEngine()

    def calculate_formula(self, formula_id: str, inputs: Mapping[str, float]) -> RouteDecision:
        try:
            result = self.engine.calculate(formula_id, inputs)
            return RouteDecision('local', 'Fórmula suportada pelo motor determinístico local.', result=result.to_dict())
        except CalculationError as exc:
            if str(exc) != 'unknown_formula':
                raise
            return RouteDecision(
                'ai_confirmation_required',
                'O catálogo local não reconhece a fórmula. A IA pode interpretar o pedido, mas o utilizador tem de confirmar os parâmetros e o resultado deve ser recalculado ou verificado localmente.',
                ai_request={
                    'purpose': 'interpret_unsupported_calculation',
                    'formula_id_or_prompt': formula_id,
                    'inputs': dict(inputs),
                    'required_response': ['proposed_formula', 'variables', 'units', 'assumptions', 'step_by_step'],
                    'prohibited': ['hidden_execution', 'invented_standard_reference', 'unconfirmed_design_factor'],
                },
            )

    def route_natural_language(self, prompt: str) -> RouteDecision:
        prompt = prompt.strip()
        if not prompt:
            raise CalculationError('empty_prompt')
        return RouteDecision(
            'ai_confirmation_required',
            'A linguagem natural necessita de interpretação. A IA propõe fórmula e parâmetros; o utilizador confirma; o motor local calcula sempre que a expressão for suportada.',
            ai_request={
                'purpose': 'interpret_natural_language',
                'prompt': prompt,
                'required_response': ['catalog_formula_id_or_expression', 'variables', 'units', 'assumptions', 'confidence'],
                'user_confirmation_required': True,
            },
        )
