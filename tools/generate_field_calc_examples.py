import json
import math
import sys
from pathlib import Path

ROOT=Path(__file__).resolve().parent.parent
IMPL=ROOT/'outputs/VisionWorldApps/06_Vision_Field_Calc/implementation'
sys.path.insert(0,str(IMPL))
from vision_field_calc import CalculationEngine,SolverEngine

engine=CalculationEngine();solver=SolverEngine()
examples={
  'area_circle':engine.calculate('AREA_CIRCLE_RADIUS',{'r':2}).to_dict(),
  'volume_cylinder':engine.calculate('VOL_CYLINDER',{'r':1.5,'height':4}).to_dict(),
  'flow_darcy_headloss':engine.calculate('FLUID_DARCY_HEADLOSS',{'friction_factor':0.02,'length':100,'diameter':0.1,'velocity':2,'g':9.80665}).to_dict(),
  'three_phase_power':engine.calculate('ELEC_AC3_REAL_POWER',{'line_voltage':400,'line_current':32,'power_factor':0.9}).to_dict(),
  'beam_moment':engine.calculate('STRUCT_BEAM_MMAX_UDL',{'uniform_load':5000,'span':4}).to_dict(),
  'field_report_tolerance':engine.calculate('FR_TOLERANCE_UTILIZATION',{'measured':10.3,'nominal':10,'tolerance':0.5}).to_dict(),
  'statistics':solver.statistics_describe([1,2,3,4,5],sample=True),
  'equation':solver.polynomial_roots([1,0,-4]),
  'limit':solver.limit('sin(x)/x','x',0),
  'integral':solver.integral_simpson('x**2','x',0,1,1000),
  'differential_equation':solver.rk4_first_order('y',0,1,1,100),
}
(IMPL/'example_results.json').write_text(json.dumps(examples,ensure_ascii=False,indent=2,default=str)+'\n',encoding='utf-8')
print(json.dumps({'examples':len(examples),'path':str(IMPL/'example_results.json')},ensure_ascii=False))
