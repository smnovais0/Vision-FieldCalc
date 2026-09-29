import json
import math
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from vision_field_calc import CalculationEngine, CalculationError, CalculationRouter, SolverEngine
from vision_field_calc.safe_math import evaluate, SafeMathError


def representative_value(name):
    values = {
        'inner_r': 1.0, 'outer_r': 2.0, 'minor_r': 1.0, 'major_r': 2.0,
        'r1': 1.0, 'r2': 2.0, 'area1': 1.0, 'area2': 2.0,
        'power_factor': 0.8, 'efficiency': 0.8, 'joint_efficiency': 0.8,
        'correction_factor': 0.9, 'grouping_factor': 0.9, 'temperature_factor': 0.9,
        'coefficient_y': 0.4, 'corrosion_allowance': 0.001,
        'n': 5.0, 'angle_deg': 30.0, 'angle1_deg': 20.0,
        'x': 1.0, 'x1': 0.0, 'x2': 2.0, 'y1': 1.0, 'y2': 3.0,
        'span': 2.0, 'load_position': 1.0, 'focal_length': 2.0, 'object_distance': 4.0,
        'nominal': 2.0, 'measured': 2.1, 'tolerance': 0.2,
        'run': 2.0, 'rise': 1.0, 'input_energy': 4.0, 'useful_output': 2.0,
        'primary_turns': 4.0, 'secondary_turns': 2.0,
        'refractive_index1': 1.0, 'refractive_index2': 1.5,
    }
    return values.get(name, 2.0)


class CatalogTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.engine = CalculationEngine()
        cls.solver = SolverEngine()

    def test_every_menu_has_functionality(self):
        for menu in self.engine.menus:
            if menu in ('Estatística', 'Equações', 'Limites e cálculo'):
                continue
            self.assertTrue(self.engine.list_menu(menu), menu)

    def test_all_129_catalog_formulas_execute(self):
        self.assertEqual(129, len(self.engine.formulas))
        failures = []
        for fid, formula in self.engine.formulas.items():
            inputs = {name: representative_value(name) for name in formula['inputs']}
            try:
                result = self.engine.calculate(fid, inputs)
                self.assertTrue(math.isfinite(result.result))
                self.assertEqual(5, len(result.steps))
            except Exception as exc:
                failures.append((fid, str(exc), inputs))
        self.assertEqual([], failures)

    def test_substitution_does_not_corrupt_function_names(self):
        result = self.engine.calculate('AREA_CIRCLE_RADIUS', {'r': 2})
        self.assertIn('pi*(2)', result.steps[3]['math'])
        self.assertNotIn('sq(2)t', result.steps[3]['math'])

    def test_integral_and_symbols(self):
        result = self.solver.integral_simpson('x**2', 'x', 0, 1, 1000)
        self.assertAlmostEqual(1/3, result['result'], places=10)
        display = ' '.join(step['math'] for step in result['steps'])
        self.assertIn('∫', display)
        self.assertIn('∑', display)
        self.assertIn('x', display)

    def test_limit(self):
        result = self.solver.limit('sin(x)/x', 'x', 0)
        self.assertTrue(result['exists_numerically'])
        self.assertAlmostEqual(1, result['result'], places=6)

    def test_statistics_and_greek_symbols(self):
        result = self.solver.statistics_describe([1, 2, 3, 4])
        self.assertEqual(2.5, result['mean'])
        display = ' '.join(step['math'] for step in result['steps'])
        self.assertIn('∑', display)
        self.assertIn('σ', display)

    def test_equations_and_differential_equations(self):
        roots = self.solver.polynomial_roots([1, 0, -4])['roots']
        self.assertEqual([-2.0, 2.0], sorted(round(r['real'], 8) for r in roots))
        system = self.solver.linear_system([[2, 1], [1, -1]], [5, 1])['solution']
        self.assertAlmostEqual(2, system[0]); self.assertAlmostEqual(1, system[1])
        ode = self.solver.rk4_first_order('y', 0, 1, 1, 100)
        self.assertAlmostEqual(math.e, ode['y'], places=7)
        self.assertIn('dy/dx', ode['steps'][0]['math'])

    def test_newton_binomial_and_pearson(self):
        self.assertAlmostEqual(math.sqrt(2), self.solver.newton('x**2-2', 'x', 1)['root'], places=8)
        self.assertAlmostEqual(0.3125, self.solver.binomial(5, 2, 0.5)['result'])
        self.assertAlmostEqual(1, self.solver.pearson([1,2,3], [2,4,6])['result'])

    def test_local_first_router(self):
        router = CalculationRouter(self.engine)
        local = router.calculate_formula('AREA_SQUARE', {'a': 3})
        self.assertEqual('local', local.route)
        ai = router.route_natural_language('calcular uma forma não catalogada')
        self.assertEqual('ai_confirmation_required', ai.route)
        self.assertTrue(ai.ai_request['user_confirmation_required'])

    def test_safe_expression_rejects_code(self):
        with self.assertRaises(SafeMathError):
            evaluate("__import__('os').system('whoami')", {})


if __name__ == '__main__':
    unittest.main(verbosity=2)
