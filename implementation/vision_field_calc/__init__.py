"""Deterministic reference engine for Vision Field Calc."""
from .engine import CalculationEngine, CalculationError
from .solvers import SolverEngine
from .router import CalculationRouter, RouteDecision

__all__ = ["CalculationEngine", "CalculationError", "SolverEngine", "CalculationRouter", "RouteDecision"]
__version__ = "0.3.0"
