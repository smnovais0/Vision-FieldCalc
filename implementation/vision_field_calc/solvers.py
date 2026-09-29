from __future__ import annotations
import cmath
import math
from statistics import mean, median
from .safe_math import evaluate, SafeMathError
from .engine import CalculationError

def _finite(values):
    out=[]
    for value in values:
        if isinstance(value,bool) or not isinstance(value,(int,float)) or not math.isfinite(value): raise CalculationError('invalid_number')
        out.append(float(value))
    return out

def _step(number,title,math_text,text): return {'number':number,'title':title,'math':math_text,'text_pt':text}

class SolverEngine:
    def pearson(self, xs, ys):
        x,y=_finite(xs),_finite(ys)
        if len(x)!=len(y) or len(x)<2: raise CalculationError('insufficient_pairs')
        mx,my=mean(x),mean(y)
        numerator=sum((a-mx)*(b-my) for a,b in zip(x,y))
        denominator=math.sqrt(sum((a-mx)**2 for a in x)*sum((b-my)**2 for b in y))
        if denominator==0: raise CalculationError('zero_variance')
        result=numerator/denominator
        return {'result':result,'steps':[
            _step(1,'Calcular as médias','x̄ e ȳ',f'x̄={mx:.15g}; ȳ={my:.15g}'),
            _step(2,'Calcular os desvios','(xᵢ−x̄) e (yᵢ−ȳ)','Desvios calculados para cada par'),
            _step(3,'Aplicar Pearson','r = ∑(xᵢ−x̄)(yᵢ−ȳ)/√[∑(xᵢ−x̄)²∑(yᵢ−ȳ)²]',f'r={result:.15g}') ]}

    def binomial(self, trials, successes, probability):
        n,k=int(trials),int(successes);p=float(probability)
        if n<0 or k<0 or k>n or not 0<=p<=1: raise CalculationError('invalid_binomial_parameters')
        combinations=math.comb(n,k);result=combinations*(p**k)*((1-p)**(n-k))
        return {'result':result,'steps':[
            _step(1,'Confirmar parâmetros','0 ≤ k ≤ n; 0 ≤ p ≤ 1',f'n={n}; k={k}; p={p:.15g}'),
            _step(2,'Calcular combinações','C(n,k)=n!/[k!(n−k)!]',f'C({n},{k})={combinations}'),
            _step(3,'Aplicar distribuição binomial','P(X=k)=C(n,k)pᵏ(1−p)ⁿ⁻ᵏ',f'P={result:.15g}') ]}
    def statistics_describe(self, values, sample=False):
        x=_finite(values)
        if not x or (sample and len(x)<2): raise CalculationError('insufficient_values')
        mu=mean(x);den=len(x)-1 if sample else len(x);variance=sum((v-mu)**2 for v in x)/den
        ordered=sorted(x)
        return {'count':len(x),'sum':sum(x),'mean':mu,'median':median(x),'minimum':ordered[0],'maximum':ordered[-1],
                'range':ordered[-1]-ordered[0],'variance':variance,'standard_deviation':math.sqrt(variance),
                'steps':[
                    _step(1,'Ordenar os dados','x₍₁₎ ≤ … ≤ x₍ₙ₎',str(ordered)),
                    _step(2,'Calcular a média','x̄ = (∑ᵢ xᵢ)/n',f'∑x={sum(x):.15g}; n={len(x)}; x̄={mu:.15g}'),
                    _step(3,'Calcular a variância',f"{'s²' if sample else 'σ²'} = ∑ᵢ(xᵢ-x̄)²/{'n-1' if sample else 'n'}",f'{variance:.15g}'),
                    _step(4,'Calcular o desvio padrão',f"{'s' if sample else 'σ'} = √{'s²' if sample else 'σ²'}",f'{math.sqrt(variance):.15g}') ]}

    def weighted_mean(self, values, weights):
        x,w=_finite(values),_finite(weights)
        if len(x)!=len(w) or not x or any(v<0 for v in w) or sum(w)<=0:raise CalculationError('invalid_weights')
        result=sum(a*b for a,b in zip(x,w))/sum(w)
        return {'result':result,'steps':[_step(1,'Multiplicar','∑ᵢ wᵢxᵢ',f'{sum(a*b for a,b in zip(x,w)):.15g}'),_step(2,'Dividir pela soma dos pesos','x̄w = (∑ᵢ wᵢxᵢ)/(∑ᵢ wᵢ)',f'{result:.15g}') ]}

    def linear_regression(self, xs, ys):
        x,y=_finite(xs),_finite(ys)
        if len(x)!=len(y) or len(x)<2:raise CalculationError('insufficient_pairs')
        mx,my=mean(x),mean(y);sxx=sum((v-mx)**2 for v in x);sxy=sum((a-mx)*(b-my) for a,b in zip(x,y))
        if sxx==0:raise CalculationError('zero_x_variance')
        slope=sxy/sxx;intercept=my-slope*mx;syy=sum((v-my)**2 for v in y);r=sxy/math.sqrt(sxx*syy) if syy else 0.0
        return {'slope':slope,'intercept':intercept,'pearson_r':r,'r_squared':r*r,
                'steps':[_step(1,'Médias','x̄, ȳ',f'x̄={mx:.15g}; ȳ={my:.15g}'),_step(2,'Declive','b = ∑(x-x̄)(y-ȳ)/∑(x-x̄)²',f'b={slope:.15g}'),_step(3,'Ordenada','a = ȳ-bx̄',f'a={intercept:.15g}'),_step(4,'Equação','ŷ = a + bx',f'ŷ={intercept:.15g}+{slope:.15g}x')]}

    def percentile(self, values, p):
        x=sorted(_finite(values));p=float(p)
        if not x or not 0<=p<=100:raise CalculationError('invalid_percentile')
        pos=(len(x)-1)*p/100;lo=math.floor(pos);hi=math.ceil(pos);result=x[lo] if lo==hi else x[lo]+(pos-lo)*(x[hi]-x[lo])
        return {'result':result,'method':'linear_type_7','steps':[_step(1,'Ordenar','x₍₁₎ ≤ … ≤ x₍ₙ₎',str(x)),_step(2,'Localizar',f'h=(n-1)×{p}/100',f'h={pos:.15g}'),_step(3,'Interpolar','Pₚ=x⌊h⌋+(h-⌊h⌋)(x⌈h⌉-x⌊h⌋)',f'{result:.15g}') ]}

    def polynomial_roots(self, coefficients, tolerance=1e-12, max_iterations=500):
        c=[complex(x) for x in _finite(coefficients)]
        while c and abs(c[0])==0:c.pop(0)
        if len(c)<2:raise CalculationError('invalid_polynomial')
        degree=len(c)-1;c=[x/c[0] for x in c]
        if degree==1:roots=[-c[1]]
        else:
            radius=1+max(abs(v) for v in c[1:]);roots=[radius*cmath.exp(2j*math.pi*k/degree) for k in range(degree)]
            for iteration in range(max_iterations):
                updated=[]
                for i,r in enumerate(roots):
                    value=c[0]
                    for coefficient in c[1:]:value=value*r+coefficient
                    denominator=1+0j
                    for j,other in enumerate(roots):
                        if i!=j:denominator*=r-other
                    if abs(denominator)<tolerance:denominator=complex(tolerance,tolerance)
                    updated.append(r-value/denominator)
                error=max(abs(a-b) for a,b in zip(updated,roots));roots=updated
                if error<tolerance:break
            else:raise CalculationError('roots_not_converged')
        cleaned=[{'real':0.0 if abs(r.real)<tolerance else r.real,'imaginary':0.0 if abs(r.imag)<tolerance else r.imag} for r in roots]
        powers=' + '.join(f'a{i}x^{degree-i}' for i in range(degree+1))
        return {'degree':degree,'roots':cleaned,'steps':[_step(1,'Construir o polinómio',f'{powers} = 0',str(coefficients)),_step(2,'Normalizar','a₀ = 1',str([complex(v) for v in c])),_step(3,'Resolver','P(x)=0',str(cleaned))]}

    def linear_system(self, matrix, vector):
        a=[_finite(row) for row in matrix];b=_finite(vector);n=len(a)
        if n==0 or len(b)!=n or any(len(row)!=n for row in a):raise CalculationError('invalid_matrix')
        m=[row+[rhs] for row,rhs in zip(a,b)];operations=[]
        for col in range(n):
            pivot=max(range(col,n),key=lambda r:abs(m[r][col]))
            if abs(m[pivot][col])<1e-14:raise CalculationError('singular_matrix')
            if pivot!=col:m[col],m[pivot]=m[pivot],m[col];operations.append(f'R{col+1} ↔ R{pivot+1}')
            scale=m[col][col];m[col]=[v/scale for v in m[col]];operations.append(f'R{col+1} ÷ {scale:.8g}')
            for r in range(n):
                if r==col:continue
                factor=m[r][col]
                if factor:m[r]=[x-factor*y for x,y in zip(m[r],m[col])];operations.append(f'R{r+1} − ({factor:.8g})R{col+1}')
        solution=[m[i][-1] for i in range(n)]
        return {'solution':solution,'steps':[_step(1,'Matriz aumentada','[A|b]',str([row+[rhs] for row,rhs in zip(a,b)])),_step(2,'Eliminação de Gauss Jordan','; '.join(operations),'Aplicar operações elementares'),_step(3,'Solução','x = '+str(solution),'Substituição verificada')]}

    def bisection(self, expression, variable, lower, upper, tolerance=1e-10, max_iterations=200):
        lo,hi=float(lower),float(upper)
        def f(x):return float(evaluate(expression,{variable:x}))
        flo,fhi=f(lo),f(hi)
        if flo==0:return {'root':lo,'iterations':0,'steps':[_step(1,'Raiz no limite',f'{variable}={lo}',f'f={flo}') ]}
        if flo*fhi>0:raise CalculationError('interval_does_not_bracket_root')
        table=[]
        for i in range(max_iterations):
            mid=(lo+hi)/2;fm=f(mid)
            if i<8 or abs(fm)<=tolerance:table.append({'i':i+1,'a':lo,'b':hi,'x':mid,'f':fm})
            if abs(fm)<=tolerance or (hi-lo)/2<=tolerance:break
            if flo*fm<=0:hi=mid;fhi=fm
            else:lo=mid;flo=fm
        else:raise CalculationError('root_not_converged')
        return {'root':mid,'iterations':i+1,'table':table,'steps':[_step(1,'Definir','f(x)=0',expression),_step(2,'Confirmar mudança de sinal','f(a)·f(b) ≤ 0',f'[{lower}, {upper}]'),_step(3,'Bissectar','xₙ=(aₙ+bₙ)/2',f'{i+1} iterações'),_step(4,'Resultado',f'{variable}≈{mid:.15g}',f'|f|={abs(fm):.3g}')]} 

    def newton(self, expression, variable, initial, tolerance=1e-10, max_iterations=100):
        x=float(initial);table=[]
        f=lambda z:float(evaluate(expression,{variable:z}))
        for i in range(max_iterations):
            h=max(1e-7,abs(x)*1e-7)
            fx=f(x);derivative=(f(x+h)-f(x-h))/(2*h)
            if abs(derivative)<1e-14: raise CalculationError('zero_derivative')
            next_x=x-fx/derivative
            if i<8 or abs(next_x-x)<=tolerance: table.append({'i':i+1,'x':x,'f':fx,'derivative':derivative,'next_x':next_x})
            if abs(next_x-x)<=tolerance and abs(f(next_x))<=max(tolerance,1e-8):
                x=next_x;break
            x=next_x
        else: raise CalculationError('root_not_converged')
        return {'root':x,'iterations':i+1,'table':table,'steps':[
            _step(1,'Definir a equação','f(x)=0',expression),
            _step(2,'Escolher valor inicial',f'{variable}₀={initial}','Valor confirmado pelo utilizador'),
            _step(3,'Iterar por Newton',f'{variable}ₙ₊₁={variable}ₙ−f({variable}ₙ)/f′({variable}ₙ)',f'{i+1} iterações'),
            _step(4,'Resultado',f'{variable}≈{x:.15g}',f'|f|={abs(f(x)):.3g}') ]}

    def derivative(self, expression, variable, point, step=None):
        x=float(point);h=float(step or max(1e-5,abs(x)*1e-5))
        f=lambda z:float(evaluate(expression,{variable:z}))
        d=(f(x-2*h)-8*f(x-h)+8*f(x+h)-f(x+2*h))/(12*h)
        return {'result':d,'method':'five_point_central','step':h,'steps':[_step(1,'Definir',f'f({variable})',expression),_step(2,'Aplicar diferença central',"f′(x) ≈ [f(x−2h)−8f(x−h)+8f(x+h)−f(x+2h)]/(12h)",f'h={h:.15g}'),_step(3,'Resultado',f"f′({x:.15g})≈{d:.15g}",'Derivada numérica')]}

    def integral_simpson(self, expression, variable, lower, upper, intervals=1000):
        a,b=float(lower),float(upper);n=int(intervals)
        if n<2 or n%2:raise CalculationError('simpson_requires_positive_even_intervals')
        h=(b-a)/n;f=lambda z:float(evaluate(expression,{variable:z}))
        odd=sum(f(a+i*h) for i in range(1,n,2));even=sum(f(a+i*h) for i in range(2,n,2))
        result=h*(f(a)+f(b)+4*odd+2*even)/3
        return {'result':result,'intervals':n,'steps':[_step(1,'Definir o integral',f'∫₍{a:g}₎^({b:g}) ({expression}) d{variable}','Limites e integrando confirmados'),_step(2,'Dividir o intervalo',f'h=({b:g}−{a:g})/{n}',f'h={h:.15g}'),_step(3,'Aplicar Simpson',"∫ f(x)dx ≈ h/3[f₀+fₙ+4∑fᵢ(ímpar)+2∑fᵢ(par)]",f'∑ímpar={odd:.15g}; ∑par={even:.15g}'),_step(4,'Resultado',f'∫ ≈ {result:.15g}','Integração numérica')]}

    def limit(self, expression, variable, point, direction='both'):
        if point in ('infinity','+infinity','∞'): sequences=[[10.0**k for k in range(2,9)]];labels=['+∞']
        elif point in ('-infinity','-∞'): sequences=[[-10.0**k for k in range(2,9)]];labels=['−∞']
        else:
            p=float(point);scales=[10.0**(-k) for k in range(2,10)]
            sequences=[];labels=[]
            if direction in ('left','both'):sequences.append([p-h for h in scales]);labels.append('x→a⁻')
            if direction in ('right','both'):sequences.append([p+h for h in scales]);labels.append('x→a⁺')
        estimates=[]
        for seq in sequences:
            vals=[]
            for x in seq:
                try:vals.append(float(evaluate(expression,{variable:x})))
                except (ValueError,ZeroDivisionError,OverflowError):vals.append(float('nan'))
            finite=[v for v in vals if math.isfinite(v)]
            if not finite:raise CalculationError('limit_not_estimable')
            estimates.append({'label':labels[len(estimates)],'samples':list(zip(seq,vals)),'estimate':finite[-1]})
        exists=len(estimates)==1 or math.isclose(estimates[0]['estimate'],estimates[1]['estimate'],rel_tol=1e-6,abs_tol=1e-8)
        result=sum(x['estimate'] for x in estimates)/len(estimates) if exists else None
        return {'result':result,'exists_numerically':exists,'estimates':estimates,'steps':[_step(1,'Definir o limite',f'lim {expression}',f'{variable}→{point}'),_step(2,'Aproximar pelos lados','x→a⁻ e x→a⁺','Sequências progressivamente próximas'),_step(3,'Comparar',f'L⁻={estimates[0]["estimate"]:.15g}'+(f'; L⁺={estimates[1]["estimate"]:.15g}' if len(estimates)>1 else ''),'Convergência numérica'),_step(4,'Conclusão',f'L≈{result:.15g}' if exists else 'limite bilateral não confirmado','Estimativa numérica; funções difíceis podem exigir método simbólico')]}

    def rk4_first_order(self, derivative_expression, x0, y0, x1, steps):
        x=float(x0);y=float(y0);target=float(x1);n=int(steps)
        if n<=0:raise CalculationError('invalid_step_count')
        h=(target-x)/n;rows=[{'i':0,'x':x,'y':y}]
        f=lambda xv,yv:float(evaluate(derivative_expression,{'x':xv,'y':yv}))
        for i in range(n):
            k1=f(x,y);k2=f(x+h/2,y+h*k1/2);k3=f(x+h/2,y+h*k2/2);k4=f(x+h,y+h*k3)
            y += h*(k1+2*k2+2*k3+k4)/6;x += h
            if i<5 or i==n-1:rows.append({'i':i+1,'x':x,'y':y,'k1':k1,'k2':k2,'k3':k3,'k4':k4})
        return {'x':x,'y':y,'steps_count':n,'table':rows,'steps':[_step(1,'Definir a EDO',"dy/dx = f(x,y)",derivative_expression),_step(2,'Definir condição inicial',f'y({x0})={y0}',f'Calcular até x={x1}'),_step(3,'Aplicar Runge Kutta 4','yₙ₊₁=yₙ+h(k₁+2k₂+2k₃+k₄)/6',f'n={n}; h={h:.15g}'),_step(4,'Resultado',f'y({x:.15g})≈{y:.15g}','Solução numérica do problema de valor inicial')]}

    def rk4_second_order(self, acceleration_expression, x0, y0, dy0, x1, steps):
        x=float(x0);y=float(y0);v=float(dy0);target=float(x1);n=int(steps)
        if n<=0:raise CalculationError('invalid_step_count')
        h=(target-x)/n;rows=[{'i':0,'x':x,'y':y,'dy':v}]
        a=lambda xv,yv,vv:float(evaluate(acceleration_expression,{'x':xv,'y':yv,'dy':vv}))
        for i in range(n):
            k1y=v;k1v=a(x,y,v)
            k2y=v+h*k1v/2;k2v=a(x+h/2,y+h*k1y/2,v+h*k1v/2)
            k3y=v+h*k2v/2;k3v=a(x+h/2,y+h*k2y/2,v+h*k2v/2)
            k4y=v+h*k3v;k4v=a(x+h,y+h*k3y,v+h*k3v)
            y+=h*(k1y+2*k2y+2*k3y+k4y)/6;v+=h*(k1v+2*k2v+2*k3v+k4v)/6;x+=h
            if i<5 or i==n-1:rows.append({'i':i+1,'x':x,'y':y,'dy':v})
        return {'x':x,'y':y,'dy':v,'steps_count':n,'table':rows,'steps':[_step(1,'Reduzir a ordem',"y′=v; v′=f(x,y,v)",acceleration_expression),_step(2,'Condições iniciais',f'y({x0})={y0}; y′({x0})={dy0}',f'Calcular até x={x1}'),_step(3,'Aplicar Runge Kutta 4 ao sistema','[y,v]ₙ₊₁ = RK4([y,v]ₙ)',f'n={n}; h={h:.15g}'),_step(4,'Resultado',f'y≈{y:.15g}; y′≈{v:.15g}',f'x={x:.15g}') ]}
