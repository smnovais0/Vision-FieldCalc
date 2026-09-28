from __future__ import annotations
from dataclasses import dataclass
import json
import math
import re
from pathlib import Path
from typing import Mapping
from .safe_math import evaluate, SafeMathError

ROOT=Path(__file__).resolve().parents[1]

class CalculationError(ValueError): pass

@dataclass(frozen=True)
class CalculationResult:
    formula_id: str
    formula_version: str
    name_pt: str
    menu: str
    result: float
    unit: str
    validation_status: str
    steps: tuple[dict,...]
    limitations: tuple[str,...]

    def to_dict(self):
        return {**self.__dict__,"steps":list(self.steps),"limitations":list(self.limitations)}

def _fmt(value):
    return format(value,'.15g') if isinstance(value,(int,float)) else str(value)

class CalculationEngine:
    def __init__(self, catalog_path: Path|None=None):
        data=json.loads((catalog_path or ROOT/'catalog/formulas_v2.json').read_text(encoding='utf-8'))
        self.catalog_version=data['catalog_version'];self.menus=tuple(data['menus'])
        self.formulas={item['id']:item for item in data['formulas']}

    def list_menu(self, menu): return tuple(x for x in self.formulas.values() if x['menu']==menu)

    def calculate(self, formula_id: str, inputs: Mapping[str,float]) -> CalculationResult:
        if formula_id not in self.formulas: raise CalculationError('unknown_formula')
        formula=self.formulas[formula_id]
        needed=[x for x in formula['inputs'] if '=' not in x]
        if set(inputs)!=set(needed):
            missing=sorted(set(needed)-set(inputs));extra=sorted(set(inputs)-set(needed))
            raise CalculationError(f'input_mismatch:missing={missing}:extra={extra}')
        values={}
        for key,value in inputs.items():
            if isinstance(value,bool) or not isinstance(value,(int,float)) or not math.isfinite(value):
                raise CalculationError(f'invalid_number:{key}')
            values[key]=float(value)
        try:
            failed=[condition for condition in formula['conditions'] if not bool(evaluate(condition,values))]
            if failed: raise CalculationError('domain_error:'+','.join(failed))
            result=float(evaluate(formula['expression'],values))
        except (SafeMathError,ZeroDivisionError,OverflowError,ValueError) as exc:
            if isinstance(exc,CalculationError): raise
            raise CalculationError(f'evaluation_error:{exc}') from exc
        if not math.isfinite(result): raise CalculationError('non_finite_result')
        substitution=formula['expression']
        for key in sorted(values,key=len,reverse=True):
            substitution=re.sub(rf'\b{re.escape(key)}\b',f'({_fmt(values[key])})',substitution)
        steps=(
            {'number':1,'title':'Selecionar a fórmula','math':formula['expression'],'text_pt':formula['name_pt']},
            {'number':2,'title':'Confirmar os dados','math':', '.join(f'{k}={_fmt(v)}' for k,v in values.items()),'text_pt':'Valores confirmados pelo utilizador'},
            {'number':3,'title':'Verificar o domínio','math':' ∧ '.join(formula['conditions']) if formula['conditions'] else 'domínio real','text_pt':'Todas as condições foram satisfeitas'},
            {'number':4,'title':'Substituir','math':substitution,'text_pt':'Substituição dos valores na fórmula versionada'},
            {'number':5,'title':'Calcular','math':f"resultado = {_fmt(result)} {formula['output_unit']}",'text_pt':'Resultado calculado localmente pelo motor determinístico'},
        )
        limits=[]
        if formula['validation_status']!='implemented': limits.append('Validação técnica/certificação pendente; confirmar hipóteses, norma e edição antes de decisão real.')
        if formula.get('notes'): limits.append(formula['notes'])
        return CalculationResult(formula_id,formula['version'],formula['name_pt'],formula['menu'],result,formula['output_unit'],formula['validation_status'],steps,tuple(limits))
