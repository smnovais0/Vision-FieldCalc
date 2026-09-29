import argparse,json
from .engine import CalculationEngine
from .solvers import SolverEngine

def main():
    parser=argparse.ArgumentParser(description='Vision Field Calc reference engine')
    sub=parser.add_subparsers(dest='command',required=True)
    sub.add_parser('menus');p=sub.add_parser('formulas');p.add_argument('menu')
    p=sub.add_parser('calculate');p.add_argument('formula_id');p.add_argument('inputs',help='JSON object')
    p=sub.add_parser('integral');p.add_argument('expression');p.add_argument('variable');p.add_argument('lower',type=float);p.add_argument('upper',type=float);p.add_argument('--intervals',type=int,default=1000)
    p=sub.add_parser('limit');p.add_argument('expression');p.add_argument('variable');p.add_argument('point')
    p=sub.add_parser('ode1');p.add_argument('expression');p.add_argument('x0',type=float);p.add_argument('y0',type=float);p.add_argument('x1',type=float);p.add_argument('steps',type=int)
    args=parser.parse_args();engine=CalculationEngine();solver=SolverEngine()
    if args.command=='menus':result=engine.menus
    elif args.command=='formulas':result=[{'id':x['id'],'name_pt':x['name_pt']} for x in engine.list_menu(args.menu)]
    elif args.command=='calculate':result=engine.calculate(args.formula_id,json.loads(args.inputs)).to_dict()
    elif args.command=='integral':result=solver.integral_simpson(args.expression,args.variable,args.lower,args.upper,args.intervals)
    elif args.command=='limit':
        point=args.point if 'inf' in args.point or args.point=='∞' else float(args.point);result=solver.limit(args.expression,args.variable,point)
    else:result=solver.rk4_first_order(args.expression,args.x0,args.y0,args.x1,args.steps)
    print(json.dumps(result,ensure_ascii=False,indent=2))
if __name__=='__main__':main()
