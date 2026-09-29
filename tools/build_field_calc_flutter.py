from __future__ import annotations
import ast
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
IMPL = ROOT / 'implementation'
CATALOG = json.loads((IMPL / 'catalog/formulas_v2.json').read_text(encoding='utf-8'))
APP = IMPL / 'flutter/vision_field_calc'
(APP / 'lib/generated').mkdir(parents=True, exist_ok=True)


def q(value: str) -> str:
    return "'" + value.replace('\\', '\\\\').replace("'", "\\'").replace('$', '\\$') + "'"


def dart(node):
    if isinstance(node, ast.Expression): return dart(node.body)
    if isinstance(node, ast.Constant): return repr(node.value)
    if isinstance(node, ast.Name):
        if node.id == 'pi': return 'pi'
        if node.id == 'e': return 'e'
        return f"v[{q(node.id)}]!"
    if isinstance(node, ast.BinOp):
        if isinstance(node.op, ast.Pow): return f"pow({dart(node.left)}, {dart(node.right)}).toDouble()"
        op = {ast.Add: '+', ast.Sub: '-', ast.Mult: '*', ast.Div: '/', ast.Mod: '%'}[type(node.op)]
        return f"({dart(node.left)} {op} {dart(node.right)})"
    if isinstance(node, ast.UnaryOp):
        op = {ast.UAdd: '+', ast.USub: '-', ast.Not: '!'}[type(node.op)]
        return f"({op}{dart(node.operand)})"
    if isinstance(node, ast.Call):
        name=node.func.id; args=[dart(a) for a in node.args]
        if name == 'abs': return f"({args[0]}).abs().toDouble()"
        if name == 'floor': return f"({args[0]}).floorToDouble()"
        if name == 'ceil': return f"({args[0]}).ceilToDouble()"
        if name == 'integer': return f"({args[0]}).isFinite && ({args[0]}) == ({args[0]}).truncateToDouble()"
        if name == 'log10': return f"(log({args[0]}) / ln10)"
        return f"{name}({', '.join(args)})"
    if isinstance(node, ast.Compare):
        parts=[];left=node.left
        ops={ast.Lt:'<',ast.LtE:'<=',ast.Gt:'>',ast.GtE:'>=',ast.Eq:'==',ast.NotEq:'!='}
        for op,right in zip(node.ops,node.comparators):
            parts.append(f"({dart(left)} {ops[type(op)]} {dart(right)})");left=right
        return ' && '.join(parts)
    if isinstance(node, ast.BoolOp):
        op=' && ' if isinstance(node.op,ast.And) else ' || '
        return '('+op.join(dart(x) for x in node.values)+')'
    raise ValueError(type(node).__name__)


def convert(expr): return dart(ast.parse(expr, mode='eval'))


definitions=[];cases=[]
for f in CATALOG['formulas']:
    conditions=', '.join(q(x) for x in f['conditions'])
    inputs=', '.join(q(x) for x in f['inputs'])
    definitions.append(
        '  FormulaDefinition('
        f"id: {q(f['id'])}, menu: {q(f['menu'])}, name: {q(f['name_pt'])}, "
        f"expression: {q(f['expression'])}, inputs: const [{inputs}], unit: {q(f['output_unit'])}, "
        f"status: {q(f['validation_status'])}, conditions: const [{conditions}], notes: {q(f.get('notes',''))}),"
    )
    checks='\n'.join(f"        if (!({convert(condition)})) throw const FormatException('Dados fora do domínio da fórmula.');" for condition in f['conditions'])
    cases.append(f"      case {q(f['id'])}:\n{checks}\n        result = {convert(f['expression'])};\n        break;")

source=f"""// GENERATED from catalog/formulas_v2.json. Do not edit manually.
import 'dart:math';

class FormulaDefinition {{
  final String id;
  final String menu;
  final String name;
  final String expression;
  final List<String> inputs;
  final String unit;
  final String status;
  final List<String> conditions;
  final String notes;
  const FormulaDefinition({{required this.id, required this.menu, required this.name,
    required this.expression, required this.inputs, required this.unit,
    required this.status, required this.conditions, required this.notes}});
}}

class LocalCalculation {{
  final double value;
  final List<CalculationStep> steps;
  const LocalCalculation(this.value, this.steps);
}}

class CalculationStep {{
  final String title;
  final String mathematics;
  final String explanation;
  const CalculationStep(this.title, this.mathematics, this.explanation);
}}

const formulas = <FormulaDefinition>[
{chr(10).join(definitions)}
];

String prettyMath(String value) => value
  .replaceAll('**2', '²').replaceAll('**3', '³').replaceAll('sqrt', '√')
  .replaceAll('pi', 'π').replaceAll('*', ' × ');

LocalCalculation calculateFormula(FormulaDefinition formula, Map<String, double> v) {{
  for (final input in formula.inputs) {{
    if (!v.containsKey(input) || !v[input]!.isFinite) {{
      throw FormatException('Preencha o parâmetro $input com um número válido.');
    }}
  }}
  late final double result;
  switch (formula.id) {{
{chr(10).join(cases)}
    default: throw const UnsupportedError('Fórmula não suportada localmente.');
  }}
  if (!result.isFinite) throw const FormatException('O resultado não é finito.');
  final substituted = formula.inputs.fold<String>(formula.expression,
    (text, input) => text.replaceAll(RegExp('\\\\b' + RegExp.escape(input) + '\\\\b'), '(${{v[input]}})'));
  return LocalCalculation(result, [
    CalculationStep('1. Selecionar a fórmula', prettyMath(formula.expression), formula.name),
    CalculationStep('2. Confirmar os dados', formula.inputs.map((x) => '$x=${{v[x]}}').join('; '), 'Parâmetros confirmados pelo utilizador.'),
    CalculationStep('3. Verificar o domínio', formula.conditions.isEmpty ? 'domínio real' : formula.conditions.join(' ∧ '), 'Condições verificadas localmente.'),
    CalculationStep('4. Substituir', prettyMath(substituted), 'Valores inseridos na fórmula versionada.'),
    CalculationStep('5. Calcular', 'resultado = $result ${{formula.unit}}', 'Resultado do motor determinístico local.'),
  ]);
}}
"""
(APP/'lib/generated/formula_engine.g.dart').write_text(source,encoding='utf-8')
print(json.dumps({'generated_formulas':len(definitions),'dart_cases':len(cases),'path':str(APP)},ensure_ascii=False))
