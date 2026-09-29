from __future__ import annotations
import ast
import math
from typing import Mapping

FUNCTIONS = {
    "sqrt": math.sqrt, "sin": math.sin, "cos": math.cos, "tan": math.tan,
    "asin": math.asin, "acos": math.acos, "atan": math.atan, "exp": math.exp,
    "log": math.log, "log10": math.log10, "abs": abs, "floor": math.floor,
    "ceil": math.ceil, "integer": lambda x: math.isfinite(x) and x == math.trunc(x),
}
CONSTANTS = {"pi": math.pi, "e": math.e}
BIN = {ast.Add: lambda a,b:a+b, ast.Sub: lambda a,b:a-b, ast.Mult: lambda a,b:a*b,
       ast.Div: lambda a,b:a/b, ast.Pow: lambda a,b:a**b, ast.Mod: lambda a,b:a%b}
UNARY = {ast.UAdd: lambda a:a, ast.USub: lambda a:-a, ast.Not: lambda a:not a}
COMPARE = {ast.Lt: lambda a,b:a<b, ast.LtE: lambda a,b:a<=b, ast.Gt: lambda a,b:a>b,
           ast.GtE: lambda a,b:a>=b, ast.Eq: lambda a,b:a==b, ast.NotEq: lambda a,b:a!=b}

class SafeMathError(ValueError): pass

def evaluate(expression: str, variables: Mapping[str, float]) -> float | bool:
    if len(expression) > 2000: raise SafeMathError("expression_too_long")
    try: tree = ast.parse(expression, mode="eval")
    except SyntaxError as exc: raise SafeMathError("invalid_expression") from exc

    def visit(node, depth=0):
        if depth > 64: raise SafeMathError("expression_too_deep")
        if isinstance(node, ast.Expression): return visit(node.body, depth+1)
        if isinstance(node, ast.Constant) and type(node.value) in (int,float): return node.value
        if isinstance(node, ast.Name):
            if node.id in variables: return variables[node.id]
            if node.id in CONSTANTS: return CONSTANTS[node.id]
            raise SafeMathError(f"unknown_name:{node.id}")
        if isinstance(node, ast.BinOp) and type(node.op) in BIN: return BIN[type(node.op)](visit(node.left,depth+1),visit(node.right,depth+1))
        if isinstance(node, ast.UnaryOp) and type(node.op) in UNARY: return UNARY[type(node.op)](visit(node.operand,depth+1))
        if isinstance(node, ast.Call) and isinstance(node.func,ast.Name) and node.func.id in FUNCTIONS and not node.keywords:
            return FUNCTIONS[node.func.id](*[visit(x,depth+1) for x in node.args])
        if isinstance(node, ast.Compare):
            left=visit(node.left,depth+1)
            for op,right_node in zip(node.ops,node.comparators):
                if type(op) not in COMPARE: raise SafeMathError("comparison_not_allowed")
                right=visit(right_node,depth+1)
                if not COMPARE[type(op)](left,right): return False
                left=right
            return True
        if isinstance(node, ast.BoolOp) and isinstance(node.op,(ast.And,ast.Or)):
            values=[bool(visit(x,depth+1)) for x in node.values]
            return all(values) if isinstance(node.op,ast.And) else any(values)
        raise SafeMathError(f"node_not_allowed:{type(node).__name__}")

    result=visit(tree)
    if isinstance(result,(int,float)) and not isinstance(result,bool) and not math.isfinite(result):
        raise SafeMathError("non_finite_result")
    return result
