from pathlib import Path
import json

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "outputs/VisionWorldApps/06_Vision_Field_Calc/implementation"
OUT.mkdir(parents=True, exist_ok=True)

catalog = []

def add(fid, menu, name, expression, inputs, unit, conditions=None, status="implemented", notes=""):
    catalog.append({
        "id": fid, "version": "2.0.0", "menu": menu, "name_pt": name,
        "expression": expression, "inputs": inputs, "output_unit": unit,
        "conditions": conditions or [], "validation_status": status, "notes": notes
    })

# Áreas planas e superfícies.
for row in [
    ("AREA_SQUARE", "Quadrado", "a**2", ["a"], "u²", ["a>0"]),
    ("AREA_RECTANGLE", "Retângulo", "length*width", ["length","width"], "u²", ["length>0","width>0"]),
    ("AREA_TRIANGLE", "Triângulo por base e altura", "base*height/2", ["base","height"], "u²", ["base>0","height>0"]),
    ("AREA_TRIANGLE_HERON", "Triângulo por três lados", "sqrt(((a+b+c)/2)*(((a+b+c)/2)-a)*(((a+b+c)/2)-b)*(((a+b+c)/2)-c))", ["a","b","c"], "u²", ["a>0","b>0","c>0","a+b>c","a+c>b","b+c>a"]),
    ("AREA_EQUILATERAL_TRIANGLE", "Triângulo equilátero", "sqrt(3)*a**2/4", ["a"], "u²", ["a>0"]),
    ("AREA_PARALLELOGRAM", "Paralelogramo", "base*height", ["base","height"], "u²", ["base>0","height>0"]),
    ("AREA_RHOMBUS", "Losango pelas diagonais", "d1*d2/2", ["d1","d2"], "u²", ["d1>0","d2>0"]),
    ("AREA_KITE", "Deltoide pelas diagonais", "d1*d2/2", ["d1","d2"], "u²", ["d1>0","d2>0"]),
    ("AREA_TRAPEZOID", "Trapézio", "(base1+base2)*height/2", ["base1","base2","height"], "u²", ["base1>0","base2>0","height>0"]),
    ("AREA_CIRCLE_RADIUS", "Círculo pelo raio", "pi*r**2", ["r"], "u²", ["r>0"]),
    ("AREA_CIRCLE_DIAMETER", "Círculo pelo diâmetro", "pi*d**2/4", ["d"], "u²", ["d>0"]),
    ("AREA_SEMICIRCLE", "Semicírculo", "pi*r**2/2", ["r"], "u²", ["r>0"]),
    ("AREA_CIRCULAR_SECTOR", "Setor circular", "pi*r**2*angle_deg/360", ["r","angle_deg"], "u²", ["r>0","angle_deg>=0","angle_deg<=360"]),
    ("AREA_ELLIPSE", "Elipse", "pi*a*b", ["a","b"], "u²", ["a>0","b>0"]),
    ("AREA_ANNULUS", "Coroa circular", "pi*(outer_r**2-inner_r**2)", ["outer_r","inner_r"], "u²", ["outer_r>0","inner_r>=0","outer_r>inner_r"]),
    ("AREA_REGULAR_POLYGON", "Polígono regular", "n*side**2/(4*tan(pi/n))", ["n","side"], "u²", ["n>=3","integer(n)","side>0"]),
    ("SURFACE_CUBE", "Área total do cubo", "6*a**2", ["a"], "u²", ["a>0"]),
    ("SURFACE_CUBOID", "Área total do prisma retangular", "2*(length*width+length*height+width*height)", ["length","width","height"], "u²", ["length>0","width>0","height>0"]),
    ("SURFACE_CYLINDER", "Área total do cilindro", "2*pi*r*(r+height)", ["r","height"], "u²", ["r>0","height>0"]),
    ("SURFACE_CONE", "Área total do cone", "pi*r*(r+sqrt(r**2+height**2))", ["r","height"], "u²", ["r>0","height>0"]),
    ("SURFACE_SPHERE", "Área da esfera", "4*pi*r**2", ["r"], "u²", ["r>0"]),
    ("SURFACE_HEMISPHERE", "Área total da semiesfera", "3*pi*r**2", ["r"], "u²", ["r>0"]),
]: add(row[0], "Áreas", row[1], row[2], row[3], row[4], row[5])

# Volumes.
for row in [
    ("VOL_CUBE", "Cubo", "a**3", ["a"], ["a>0"]),
    ("VOL_CUBOID", "Prisma retangular", "length*width*height", ["length","width","height"], ["length>0","width>0","height>0"]),
    ("VOL_PRISM", "Prisma por área da base", "base_area*height", ["base_area","height"], ["base_area>0","height>0"]),
    ("VOL_CYLINDER", "Cilindro", "pi*r**2*height", ["r","height"], ["r>0","height>0"]),
    ("VOL_HOLLOW_CYLINDER", "Cilindro oco", "pi*(outer_r**2-inner_r**2)*height", ["outer_r","inner_r","height"], ["outer_r>inner_r","inner_r>=0","height>0"]),
    ("VOL_CONE", "Cone", "pi*r**2*height/3", ["r","height"], ["r>0","height>0"]),
    ("VOL_CONE_FRUSTUM", "Tronco de cone", "pi*height*(r1**2+r1*r2+r2**2)/3", ["r1","r2","height"], ["r1>=0","r2>=0","r1+r2>0","height>0"]),
    ("VOL_SPHERE", "Esfera", "4*pi*r**3/3", ["r"], ["r>0"]),
    ("VOL_HEMISPHERE", "Semiesfera", "2*pi*r**3/3", ["r"], ["r>0"]),
    ("VOL_PYRAMID", "Pirâmide", "base_area*height/3", ["base_area","height"], ["base_area>0","height>0"]),
    ("VOL_PYRAMID_FRUSTUM", "Tronco de pirâmide", "height*(area1+area2+sqrt(area1*area2))/3", ["area1","area2","height"], ["area1>=0","area2>=0","area1+area2>0","height>0"]),
    ("VOL_ELLIPSOID", "Elipsoide", "4*pi*a*b*c/3", ["a","b","c"], ["a>0","b>0","c>0"]),
    ("VOL_TORUS", "Toro", "2*pi**2*major_r*minor_r**2", ["major_r","minor_r"], ["major_r>minor_r","minor_r>0"]),
]: add(row[0], "Volumes", row[1], row[2], row[3], "u³", row[4])

# Fluidos e fluxos.
for row in [
    ("FLOW_VOLUME_TIME", "Caudal volumétrico", "volume/time", ["volume","time"], "m³/s", ["volume>=0","time>0"]),
    ("FLOW_VELOCITY", "Velocidade média em conduta", "flow/area", ["flow","area"], "m/s", ["flow>=0","area>0"]),
    ("FLOW_MASS", "Caudal mássico", "density*flow", ["density","flow"], "kg/s", ["density>0","flow>=0"]),
    ("FLOW_PIPE_AREA", "Área interna de tubo", "pi*diameter**2/4", ["diameter"], "m²", ["diameter>0"]),
    ("FLOW_CONTINUITY", "Continuidade entre secções", "area1*velocity1/area2", ["area1","velocity1","area2"], "m/s", ["area1>0","area2>0","velocity1>=0"]),
    ("FLUID_HYDROSTATIC", "Pressão hidrostática", "density*g*height", ["density","g","height"], "Pa", ["density>0","g>0","height>=0"]),
    ("FLUID_PRESSURE_HEAD", "Altura de pressão", "pressure/(density*g)", ["pressure","density","g"], "m", ["density>0","g>0"]),
    ("FLUID_REYNOLDS", "Número de Reynolds", "density*velocity*diameter/dynamic_viscosity", ["density","velocity","diameter","dynamic_viscosity"], "1", ["density>0","velocity>=0","diameter>0","dynamic_viscosity>0"]),
    ("FLUID_DARCY_HEADLOSS", "Perda de carga Darcy Weisbach", "friction_factor*(length/diameter)*velocity**2/(2*g)", ["friction_factor","length","diameter","velocity","g"], "m", ["friction_factor>=0","length>=0","diameter>0","velocity>=0","g>0"]),
    ("FLUID_DARCY_PRESSURE_DROP", "Queda de pressão Darcy Weisbach", "friction_factor*(length/diameter)*density*velocity**2/2", ["friction_factor","length","diameter","density","velocity"], "Pa", ["friction_factor>=0","length>=0","diameter>0","density>0","velocity>=0"]),
    ("FLUID_HAZEN_WILLIAMS", "Perda de carga Hazen Williams SI", "10.67*length*flow**1.852/(coefficient**1.852*diameter**4.87)", ["length","flow","coefficient","diameter"], "m", ["length>=0","flow>=0","coefficient>0","diameter>0"]),
    ("FLUID_MANNING", "Caudal em canal pela fórmula de Manning", "roughness_inv*area*hydraulic_radius**(2/3)*slope**0.5", ["roughness_inv","area","hydraulic_radius","slope"], "m³/s", ["roughness_inv>0","area>0","hydraulic_radius>0","slope>=0"], "review_pending", "roughness_inv=1/n; confirmar sistema de unidades e coeficiente"),
    ("FLUID_ORIFICE", "Descarga por orifício", "discharge_coefficient*area*sqrt(2*g*head)", ["discharge_coefficient","area","g","head"], "m³/s", ["discharge_coefficient>0","area>0","g>0","head>=0"]),
    ("FLUID_PUMP_POWER", "Potência hidráulica de bomba", "density*g*flow*head/efficiency", ["density","g","flow","head","efficiency"], "W", ["density>0","g>0","flow>=0","head>=0","efficiency>0","efficiency<=1"]),
    ("FLUID_BERNOULLI_HEAD", "Carga total de Bernoulli numa secção", "pressure/(density*g)+velocity**2/(2*g)+elevation", ["pressure","density","g","velocity","elevation"], "m", ["density>0","g>0","velocity>=0"]),
]: add(row[0], "Fluidos e fluxos", row[1], row[2], row[3], row[4], row[5], *(row[6:] if len(row)>6 else []))

# Eletricidade e proteção com fatores explícitos.
for row in [
    ("ELEC_OHM_CURRENT", "Lei de Ohm corrente", "voltage/resistance", ["voltage","resistance"], "A", ["resistance>0"]),
    ("ELEC_OHM_VOLTAGE", "Lei de Ohm tensão", "current*resistance", ["current","resistance"], "V", ["resistance>=0"]),
    ("ELEC_OHM_RESISTANCE", "Lei de Ohm resistência", "voltage/current", ["voltage","current"], "ohm", ["current!=0"]),
    ("ELEC_DC_POWER", "Potência DC", "voltage*current", ["voltage","current"], "W", []),
    ("ELEC_POWER_I2R", "Potência por corrente e resistência", "current**2*resistance", ["current","resistance"], "W", ["resistance>=0"]),
    ("ELEC_POWER_V2R", "Potência por tensão e resistência", "voltage**2/resistance", ["voltage","resistance"], "W", ["resistance>0"]),
    ("ELEC_ENERGY", "Energia elétrica", "power*time", ["power","time"], "J", ["time>=0"]),
    ("ELEC_CHARGE", "Carga elétrica", "current*time", ["current","time"], "C", ["time>=0"]),
    ("ELEC_RESISTANCE_SERIES", "Duas resistências em série", "r1+r2", ["r1","r2"], "ohm", ["r1>=0","r2>=0"]),
    ("ELEC_RESISTANCE_PARALLEL", "Duas resistências em paralelo", "1/(1/r1+1/r2)", ["r1","r2"], "ohm", ["r1>0","r2>0"]),
    ("ELEC_VOLTAGE_DIVIDER", "Divisor de tensão", "vin*r2/(r1+r2)", ["vin","r1","r2"], "V", ["r1>=0","r2>=0","r1+r2>0"]),
    ("ELEC_CAPACITOR_ENERGY", "Energia em condensador", "capacitance*voltage**2/2", ["capacitance","voltage"], "J", ["capacitance>=0"]),
    ("ELEC_CAPACITIVE_REACTANCE", "Reatância capacitiva", "1/(2*pi*frequency*capacitance)", ["frequency","capacitance"], "ohm", ["frequency>0","capacitance>0"]),
    ("ELEC_INDUCTIVE_REACTANCE", "Reatância indutiva", "2*pi*frequency*inductance", ["frequency","inductance"], "ohm", ["frequency>=0","inductance>=0"]),
    ("ELEC_RLC_IMPEDANCE", "Impedância série RLC", "sqrt(resistance**2+(2*pi*frequency*inductance-1/(2*pi*frequency*capacitance))**2)", ["resistance","frequency","inductance","capacitance"], "ohm", ["resistance>=0","frequency>0","inductance>=0","capacitance>0"]),
    ("ELEC_RESONANCE", "Frequência de ressonância LC", "1/(2*pi*sqrt(inductance*capacitance))", ["inductance","capacitance"], "Hz", ["inductance>0","capacitance>0"]),
    ("ELEC_AC1_REAL_POWER", "Potência ativa AC monofásica", "voltage*current*power_factor", ["voltage","current","power_factor"], "W", ["voltage>=0","current>=0","power_factor>=0","power_factor<=1"]),
    ("ELEC_AC1_CURRENT", "Corrente AC monofásica", "power/(voltage*power_factor*efficiency)", ["power","voltage","power_factor","efficiency"], "A", ["power>=0","voltage>0","power_factor>0","power_factor<=1","efficiency>0","efficiency<=1"]),
    ("ELEC_AC3_REAL_POWER", "Potência ativa AC trifásica", "sqrt(3)*line_voltage*line_current*power_factor", ["line_voltage","line_current","power_factor"], "W", ["line_voltage>=0","line_current>=0","power_factor>=0","power_factor<=1"]),
    ("ELEC_AC3_CURRENT", "Corrente AC trifásica", "power/(sqrt(3)*line_voltage*power_factor*efficiency)", ["power","line_voltage","power_factor","efficiency"], "A", ["power>=0","line_voltage>0","power_factor>0","power_factor<=1","efficiency>0","efficiency<=1"]),
    ("ELEC_APPARENT_POWER", "Potência aparente", "voltage*current", ["voltage","current"], "VA", ["voltage>=0","current>=0"]),
    ("ELEC_REACTIVE_POWER", "Potência reativa", "apparent_power*sqrt(1-power_factor**2)", ["apparent_power","power_factor"], "var", ["apparent_power>=0","power_factor>=0","power_factor<=1"]),
    ("ELEC_TRANSFORMER_VOLTAGE", "Relação de transformação de tensão", "primary_voltage*secondary_turns/primary_turns", ["primary_voltage","primary_turns","secondary_turns"], "V", ["primary_turns>0","secondary_turns>0"]),
    ("ELEC_VDROP_DC", "Queda de tensão DC ou monofásica resistiva", "2*length*current*resistivity/area", ["length","current","resistivity","area"], "V", ["length>=0","current>=0","resistivity>0","area>0"], "review_pending", "Fatores térmicos e de instalação são externos"),
    ("ELEC_VDROP_AC3", "Queda de tensão trifásica simplificada", "sqrt(3)*length*current*(resistance_per_length*power_factor+reactance_per_length*sqrt(1-power_factor**2))", ["length","current","resistance_per_length","reactance_per_length","power_factor"], "V", ["length>=0","current>=0","resistance_per_length>=0","reactance_per_length>=0","power_factor>=0","power_factor<=1"], "review_pending"),
    ("ELEC_DESIGN_CURRENT", "Corrente de projeto com fatores", "load_current/(correction_factor*grouping_factor*temperature_factor)", ["load_current","correction_factor","grouping_factor","temperature_factor"], "A", ["load_current>=0","correction_factor>0","grouping_factor>0","temperature_factor>0"], "review_pending", "Os fatores e tabelas vêm da norma/edição escolhida pelo utilizador"),
    ("ELEC_PROTECTION_MIN_RATING", "Classificação mínima teórica da proteção", "design_current*safety_factor", ["design_current","safety_factor"], "A", ["design_current>=0","safety_factor>=1"], "review_pending", "Não seleciona automaticamente um calibre normalizado nem prova coordenação"),
    ("ELEC_SHORT_CIRCUIT", "Corrente de curto-circuito por impedância", "voltage/impedance", ["voltage","impedance"], "A", ["impedance>0"], "review_pending"),
]: add(row[0], "Eletricidade", row[1], row[2], row[3], row[4], row[5], *(row[6:] if len(row)>6 else []))

# Física geral.
for row in [
    ("PHYS_SPEED", "Velocidade média", "distance/time", ["distance","time"], "m/s", ["time>0"]),
    ("PHYS_ACCELERATION", "Aceleração média", "(final_velocity-initial_velocity)/time", ["final_velocity","initial_velocity","time"], "m/s²", ["time>0"]),
    ("PHYS_KINEMATICS_V", "Velocidade com aceleração constante", "initial_velocity+acceleration*time", ["initial_velocity","acceleration","time"], "m/s", ["time>=0"]),
    ("PHYS_KINEMATICS_S", "Deslocamento com aceleração constante", "initial_velocity*time+acceleration*time**2/2", ["initial_velocity","acceleration","time"], "m", ["time>=0"]),
    ("PHYS_FORCE", "Segunda lei de Newton", "mass*acceleration", ["mass","acceleration"], "N", ["mass>=0"]),
    ("PHYS_WEIGHT", "Peso", "mass*g", ["mass","g"], "N", ["mass>=0","g>0"]),
    ("PHYS_WORK", "Trabalho de força constante", "force*distance*cos(angle_deg*pi/180)", ["force","distance","angle_deg"], "J", ["distance>=0"]),
    ("PHYS_KINETIC_ENERGY", "Energia cinética", "mass*velocity**2/2", ["mass","velocity"], "J", ["mass>=0"]),
    ("PHYS_POTENTIAL_ENERGY", "Energia potencial gravítica", "mass*g*height", ["mass","g","height"], "J", ["mass>=0","g>0"]),
    ("PHYS_POWER", "Potência média", "work/time", ["work","time"], "W", ["time>0"]),
    ("PHYS_MOMENTUM", "Quantidade de movimento", "mass*velocity", ["mass","velocity"], "kg·m/s", ["mass>=0"]),
    ("PHYS_IMPULSE", "Impulso", "force*time", ["force","time"], "N·s", ["time>=0"]),
    ("PHYS_DENSITY", "Densidade", "mass/volume", ["mass","volume"], "kg/m³", ["mass>=0","volume>0"]),
    ("PHYS_PRESSURE", "Pressão média", "force/area", ["force","area"], "Pa", ["area>0"]),
    ("PHYS_TORQUE", "Momento de força", "force*lever_arm*sin(angle_deg*pi/180)", ["force","lever_arm","angle_deg"], "N·m", ["lever_arm>=0"]),
    ("PHYS_CENTRIPETAL_FORCE", "Força centrípeta", "mass*velocity**2/radius", ["mass","velocity","radius"], "N", ["mass>=0","radius>0"]),
    ("PHYS_GRAVITATION", "Gravitação universal", "G*mass1*mass2/distance**2", ["G","mass1","mass2","distance"], "N", ["G>0","mass1>=0","mass2>=0","distance>0"]),
    ("PHYS_HOOKE", "Lei de Hooke", "spring_constant*extension", ["spring_constant","extension"], "N", ["spring_constant>=0"]),
    ("PHYS_FREQUENCY", "Frequência por período", "1/period", ["period"], "Hz", ["period>0"]),
    ("PHYS_WAVE_SPEED", "Velocidade de onda", "frequency*wavelength", ["frequency","wavelength"], "m/s", ["frequency>=0","wavelength>=0"]),
    ("PHYS_IDEAL_GAS_PRESSURE", "Pressão de gás ideal", "moles*gas_constant*temperature/volume", ["moles","gas_constant","temperature","volume"], "Pa", ["moles>=0","gas_constant>0","temperature>0","volume>0"]),
    ("PHYS_SENSIBLE_HEAT", "Calor sensível", "mass*specific_heat*temperature_change", ["mass","specific_heat","temperature_change"], "J", ["mass>=0","specific_heat>=0"]),
    ("PHYS_LINEAR_EXPANSION", "Dilatação linear", "coefficient*initial_length*temperature_change", ["coefficient","initial_length","temperature_change"], "m", ["coefficient>=0","initial_length>=0"]),
    ("PHYS_EFFICIENCY", "Eficiência", "useful_output/input_energy", ["useful_output","input_energy"], "1", ["input_energy>0","useful_output>=0"]),
    ("PHYS_PHOTON_ENERGY", "Energia de fotão", "planck*frequency", ["planck","frequency"], "J", ["planck>0","frequency>=0"]),
    ("PHYS_SNELL", "Ângulo refratado pela lei de Snell", "asin(refractive_index1*sin(angle1_deg*pi/180)/refractive_index2)*180/pi", ["refractive_index1","refractive_index2","angle1_deg"], "deg", ["refractive_index1>0","refractive_index2>0"]),
    ("PHYS_THIN_LENS", "Distância de imagem em lente delgada", "1/(1/focal_length-1/object_distance)", ["focal_length","object_distance"], "m", ["focal_length!=0","object_distance!=0","1/focal_length!=1/object_distance"]),
]: add(row[0], "Física", row[1], row[2], row[3], row[4], row[5])

# Estruturas e equipamentos sob pressão; cálculo funcional, revisão técnica pendente.
for row in [
    ("STRUCT_NORMAL_STRESS", "Tensão normal média", "force/area", ["force","area"], "Pa", ["area>0"]),
    ("STRUCT_STRAIN", "Extensão normal", "length_change/original_length", ["length_change","original_length"], "1", ["original_length>0"]),
    ("STRUCT_HOOKE_STRESS", "Tensão elástica", "young_modulus*strain", ["young_modulus","strain"], "Pa", ["young_modulus>0"]),
    ("STRUCT_AXIAL_DEFORMATION", "Deformação axial de barra", "force*length/(area*young_modulus)", ["force","length","area","young_modulus"], "m", ["length>=0","area>0","young_modulus>0"]),
    ("STRUCT_BENDING_STRESS", "Tensão de flexão", "moment*distance_to_extreme_fibre/second_moment_area", ["moment","distance_to_extreme_fibre","second_moment_area"], "Pa", ["distance_to_extreme_fibre>=0","second_moment_area>0"]),
    ("STRUCT_RECT_I", "Segundo momento de área retangular", "width*height**3/12", ["width","height"], "m⁴", ["width>0","height>0"]),
    ("STRUCT_CIRCLE_I", "Segundo momento de área circular", "pi*diameter**4/64", ["diameter"], "m⁴", ["diameter>0"]),
    ("STRUCT_BEAM_REACTION_POINT", "Reação esquerda em viga simplesmente apoiada", "load*(span-load_position)/span", ["load","span","load_position"], "N", ["span>0","load_position>=0","load_position<=span"]),
    ("STRUCT_BEAM_MMAX_UDL", "Momento máximo em viga simplesmente apoiada com carga uniforme", "uniform_load*span**2/8", ["uniform_load","span"], "N·m", ["uniform_load>=0","span>0"]),
    ("STRUCT_BEAM_DEFLECTION_UDL", "Flecha máxima com carga uniforme", "5*uniform_load*span**4/(384*young_modulus*second_moment_area)", ["uniform_load","span","young_modulus","second_moment_area"], "m", ["uniform_load>=0","span>0","young_modulus>0","second_moment_area>0"]),
    ("STRUCT_EULER_BUCKLING", "Carga crítica de Euler", "pi**2*young_modulus*second_moment_area/(effective_length_factor*length)**2", ["young_modulus","second_moment_area","effective_length_factor","length"], "N", ["young_modulus>0","second_moment_area>0","effective_length_factor>0","length>0"]),
    ("STRUCT_SAFETY_FACTOR", "Fator de segurança", "capacity/demand", ["capacity","demand"], "1", ["capacity>=0","demand>0"]),
    ("PRESSURE_HOOP_STRESS", "Tensão circunferencial de parede fina", "pressure*diameter/(2*thickness)", ["pressure","diameter","thickness"], "Pa", ["diameter>0","thickness>0"]),
    ("PRESSURE_LONG_STRESS", "Tensão longitudinal de parede fina", "pressure*diameter/(4*thickness)", ["pressure","diameter","thickness"], "Pa", ["diameter>0","thickness>0"]),
    ("PRESSURE_REQUIRED_THICKNESS", "Espessura por equação parametrizada", "pressure*diameter/(2*allowable_stress*joint_efficiency-pressure*coefficient_y)+corrosion_allowance", ["pressure","diameter","allowable_stress","joint_efficiency","coefficient_y","corrosion_allowance"], "m", ["pressure>=0","diameter>0","allowable_stress>0","joint_efficiency>0","joint_efficiency<=1","2*allowable_stress*joint_efficiency-pressure*coefficient_y>0","corrosion_allowance>=0"]),
]: add(row[0], "Estruturas e equipamentos", row[1], row[2], row[3], row[4], row[5], "review_pending", "Verificar modelo, apoios, regime, norma, edição, coeficientes e unidades antes de decisão real")

# Cálculos transversais usados nas medições do Vision Field Report.
for row in [
    ("FR_ABSOLUTE_DEVIATION", "Desvio absoluto face ao nominal", "measured-nominal", ["measured","nominal"], "u", []),
    ("FR_PERCENT_DEVIATION", "Desvio percentual face ao nominal", "100*(measured-nominal)/nominal", ["measured","nominal"], "%", ["nominal!=0"]),
    ("FR_TOLERANCE_UTILIZATION", "Utilização da tolerância", "100*abs(measured-nominal)/tolerance", ["measured","nominal","tolerance"], "%", ["tolerance>0"]),
    ("FR_AVERAGE_READING", "Média de quatro leituras", "(reading1+reading2+reading3+reading4)/4", ["reading1","reading2","reading3","reading4"], "u", []),
    ("FR_LINEAR_INTERPOLATION", "Interpolação linear", "y1+(x-x1)*(y2-y1)/(x2-x1)", ["x","x1","x2","y1","y2"], "u", ["x2!=x1"]),
    ("FR_SLOPE_PERCENT", "Inclinação percentual", "100*rise/run", ["rise","run"], "%", ["run!=0"]),
    ("FR_SLOPE_ANGLE", "Ângulo de inclinação", "atan(rise/run)*180/pi", ["rise","run"], "deg", ["run!=0"]),
    ("FR_RECTANGULAR_QUANTITY", "Quantidade por área retangular", "length*width*rate", ["length","width","rate"], "quantidade", ["length>=0","width>=0","rate>=0"]),
    ("FR_VOLUME_QUANTITY", "Quantidade por volume", "volume*rate", ["volume","rate"], "quantidade", ["volume>=0","rate>=0"]),
]: add(row[0], "Field Report", row[1], row[2], row[3], row[4], row[5], "review_pending", "Confirmar unidade, tolerância, método de medição e critério do tipo de inspeção selecionado")

payload = {
    "schema_version": "2.0", "catalog_version": "2.0.0", "language": "pt-PT",
    "menus": ["Áreas","Volumes","Fluidos e fluxos","Eletricidade","Física","Estatística","Equações","Limites e cálculo","Estruturas e equipamentos","Field Report"],
    "formula_count": len(catalog), "formulas": catalog,
    "special_solvers": [
        "statistics.describe", "statistics.weighted_mean", "statistics.linear_regression", "statistics.pearson", "statistics.percentile", "statistics.binomial",
        "equations.polynomial_roots", "equations.linear_system", "equations.bisection", "equations.newton",
        "calculus.limit", "calculus.derivative", "calculus.integral_simpson", "differential.rk4_first_order", "differential.rk4_second_order"
    ]
}
(OUT / "catalog").mkdir(exist_ok=True)
(OUT / "catalog/formulas_v2.json").write_text(json.dumps(payload, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")
print(json.dumps({"formulas": len(catalog), "menus": len(payload["menus"]), "special_solvers": len(payload["special_solvers"])}))
