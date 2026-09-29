// GENERATED from catalog/formulas_v2.json. Do not edit manually.
import 'dart:math';

class FormulaDefinition {
  final String id;
  final String menu;
  final String name;
  final String expression;
  final List<String> inputs;
  final String unit;
  final String status;
  final List<String> conditions;
  final String notes;
  const FormulaDefinition({required this.id, required this.menu, required this.name,
    required this.expression, required this.inputs, required this.unit,
    required this.status, required this.conditions, required this.notes});
}

class LocalCalculation {
  final double value;
  final List<CalculationStep> steps;
  const LocalCalculation(this.value, this.steps);
}

class CalculationStep {
  final String title;
  final String mathematics;
  final String explanation;
  const CalculationStep(this.title, this.mathematics, this.explanation);
}

const formulas = <FormulaDefinition>[
  FormulaDefinition(id: 'AREA_SQUARE', menu: 'Áreas', name: 'Quadrado', expression: 'a**2', inputs: const ['a'], unit: 'u²', status: 'implemented', conditions: const ['a>0'], notes: ''),
  FormulaDefinition(id: 'AREA_RECTANGLE', menu: 'Áreas', name: 'Retângulo', expression: 'length*width', inputs: const ['length', 'width'], unit: 'u²', status: 'implemented', conditions: const ['length>0', 'width>0'], notes: ''),
  FormulaDefinition(id: 'AREA_TRIANGLE', menu: 'Áreas', name: 'Triângulo por base e altura', expression: 'base*height/2', inputs: const ['base', 'height'], unit: 'u²', status: 'implemented', conditions: const ['base>0', 'height>0'], notes: ''),
  FormulaDefinition(id: 'AREA_TRIANGLE_HERON', menu: 'Áreas', name: 'Triângulo por três lados', expression: 'sqrt(((a+b+c)/2)*(((a+b+c)/2)-a)*(((a+b+c)/2)-b)*(((a+b+c)/2)-c))', inputs: const ['a', 'b', 'c'], unit: 'u²', status: 'implemented', conditions: const ['a>0', 'b>0', 'c>0', 'a+b>c', 'a+c>b', 'b+c>a'], notes: ''),
  FormulaDefinition(id: 'AREA_EQUILATERAL_TRIANGLE', menu: 'Áreas', name: 'Triângulo equilátero', expression: 'sqrt(3)*a**2/4', inputs: const ['a'], unit: 'u²', status: 'implemented', conditions: const ['a>0'], notes: ''),
  FormulaDefinition(id: 'AREA_PARALLELOGRAM', menu: 'Áreas', name: 'Paralelogramo', expression: 'base*height', inputs: const ['base', 'height'], unit: 'u²', status: 'implemented', conditions: const ['base>0', 'height>0'], notes: ''),
  FormulaDefinition(id: 'AREA_RHOMBUS', menu: 'Áreas', name: 'Losango pelas diagonais', expression: 'd1*d2/2', inputs: const ['d1', 'd2'], unit: 'u²', status: 'implemented', conditions: const ['d1>0', 'd2>0'], notes: ''),
  FormulaDefinition(id: 'AREA_KITE', menu: 'Áreas', name: 'Deltoide pelas diagonais', expression: 'd1*d2/2', inputs: const ['d1', 'd2'], unit: 'u²', status: 'implemented', conditions: const ['d1>0', 'd2>0'], notes: ''),
  FormulaDefinition(id: 'AREA_TRAPEZOID', menu: 'Áreas', name: 'Trapézio', expression: '(base1+base2)*height/2', inputs: const ['base1', 'base2', 'height'], unit: 'u²', status: 'implemented', conditions: const ['base1>0', 'base2>0', 'height>0'], notes: ''),
  FormulaDefinition(id: 'AREA_CIRCLE_RADIUS', menu: 'Áreas', name: 'Círculo pelo raio', expression: 'pi*r**2', inputs: const ['r'], unit: 'u²', status: 'implemented', conditions: const ['r>0'], notes: ''),
  FormulaDefinition(id: 'AREA_CIRCLE_DIAMETER', menu: 'Áreas', name: 'Círculo pelo diâmetro', expression: 'pi*d**2/4', inputs: const ['d'], unit: 'u²', status: 'implemented', conditions: const ['d>0'], notes: ''),
  FormulaDefinition(id: 'AREA_SEMICIRCLE', menu: 'Áreas', name: 'Semicírculo', expression: 'pi*r**2/2', inputs: const ['r'], unit: 'u²', status: 'implemented', conditions: const ['r>0'], notes: ''),
  FormulaDefinition(id: 'AREA_CIRCULAR_SECTOR', menu: 'Áreas', name: 'Setor circular', expression: 'pi*r**2*angle_deg/360', inputs: const ['r', 'angle_deg'], unit: 'u²', status: 'implemented', conditions: const ['r>0', 'angle_deg>=0', 'angle_deg<=360'], notes: ''),
  FormulaDefinition(id: 'AREA_ELLIPSE', menu: 'Áreas', name: 'Elipse', expression: 'pi*a*b', inputs: const ['a', 'b'], unit: 'u²', status: 'implemented', conditions: const ['a>0', 'b>0'], notes: ''),
  FormulaDefinition(id: 'AREA_ANNULUS', menu: 'Áreas', name: 'Coroa circular', expression: 'pi*(outer_r**2-inner_r**2)', inputs: const ['outer_r', 'inner_r'], unit: 'u²', status: 'implemented', conditions: const ['outer_r>0', 'inner_r>=0', 'outer_r>inner_r'], notes: ''),
  FormulaDefinition(id: 'AREA_REGULAR_POLYGON', menu: 'Áreas', name: 'Polígono regular', expression: 'n*side**2/(4*tan(pi/n))', inputs: const ['n', 'side'], unit: 'u²', status: 'implemented', conditions: const ['n>=3', 'integer(n)', 'side>0'], notes: ''),
  FormulaDefinition(id: 'SURFACE_CUBE', menu: 'Áreas', name: 'Área total do cubo', expression: '6*a**2', inputs: const ['a'], unit: 'u²', status: 'implemented', conditions: const ['a>0'], notes: ''),
  FormulaDefinition(id: 'SURFACE_CUBOID', menu: 'Áreas', name: 'Área total do prisma retangular', expression: '2*(length*width+length*height+width*height)', inputs: const ['length', 'width', 'height'], unit: 'u²', status: 'implemented', conditions: const ['length>0', 'width>0', 'height>0'], notes: ''),
  FormulaDefinition(id: 'SURFACE_CYLINDER', menu: 'Áreas', name: 'Área total do cilindro', expression: '2*pi*r*(r+height)', inputs: const ['r', 'height'], unit: 'u²', status: 'implemented', conditions: const ['r>0', 'height>0'], notes: ''),
  FormulaDefinition(id: 'SURFACE_CONE', menu: 'Áreas', name: 'Área total do cone', expression: 'pi*r*(r+sqrt(r**2+height**2))', inputs: const ['r', 'height'], unit: 'u²', status: 'implemented', conditions: const ['r>0', 'height>0'], notes: ''),
  FormulaDefinition(id: 'SURFACE_SPHERE', menu: 'Áreas', name: 'Área da esfera', expression: '4*pi*r**2', inputs: const ['r'], unit: 'u²', status: 'implemented', conditions: const ['r>0'], notes: ''),
  FormulaDefinition(id: 'SURFACE_HEMISPHERE', menu: 'Áreas', name: 'Área total da semiesfera', expression: '3*pi*r**2', inputs: const ['r'], unit: 'u²', status: 'implemented', conditions: const ['r>0'], notes: ''),
  FormulaDefinition(id: 'VOL_CUBE', menu: 'Volumes', name: 'Cubo', expression: 'a**3', inputs: const ['a'], unit: 'u³', status: 'implemented', conditions: const ['a>0'], notes: ''),
  FormulaDefinition(id: 'VOL_CUBOID', menu: 'Volumes', name: 'Prisma retangular', expression: 'length*width*height', inputs: const ['length', 'width', 'height'], unit: 'u³', status: 'implemented', conditions: const ['length>0', 'width>0', 'height>0'], notes: ''),
  FormulaDefinition(id: 'VOL_PRISM', menu: 'Volumes', name: 'Prisma por área da base', expression: 'base_area*height', inputs: const ['base_area', 'height'], unit: 'u³', status: 'implemented', conditions: const ['base_area>0', 'height>0'], notes: ''),
  FormulaDefinition(id: 'VOL_CYLINDER', menu: 'Volumes', name: 'Cilindro', expression: 'pi*r**2*height', inputs: const ['r', 'height'], unit: 'u³', status: 'implemented', conditions: const ['r>0', 'height>0'], notes: ''),
  FormulaDefinition(id: 'VOL_HOLLOW_CYLINDER', menu: 'Volumes', name: 'Cilindro oco', expression: 'pi*(outer_r**2-inner_r**2)*height', inputs: const ['outer_r', 'inner_r', 'height'], unit: 'u³', status: 'implemented', conditions: const ['outer_r>inner_r', 'inner_r>=0', 'height>0'], notes: ''),
  FormulaDefinition(id: 'VOL_CONE', menu: 'Volumes', name: 'Cone', expression: 'pi*r**2*height/3', inputs: const ['r', 'height'], unit: 'u³', status: 'implemented', conditions: const ['r>0', 'height>0'], notes: ''),
  FormulaDefinition(id: 'VOL_CONE_FRUSTUM', menu: 'Volumes', name: 'Tronco de cone', expression: 'pi*height*(r1**2+r1*r2+r2**2)/3', inputs: const ['r1', 'r2', 'height'], unit: 'u³', status: 'implemented', conditions: const ['r1>=0', 'r2>=0', 'r1+r2>0', 'height>0'], notes: ''),
  FormulaDefinition(id: 'VOL_SPHERE', menu: 'Volumes', name: 'Esfera', expression: '4*pi*r**3/3', inputs: const ['r'], unit: 'u³', status: 'implemented', conditions: const ['r>0'], notes: ''),
  FormulaDefinition(id: 'VOL_HEMISPHERE', menu: 'Volumes', name: 'Semiesfera', expression: '2*pi*r**3/3', inputs: const ['r'], unit: 'u³', status: 'implemented', conditions: const ['r>0'], notes: ''),
  FormulaDefinition(id: 'VOL_PYRAMID', menu: 'Volumes', name: 'Pirâmide', expression: 'base_area*height/3', inputs: const ['base_area', 'height'], unit: 'u³', status: 'implemented', conditions: const ['base_area>0', 'height>0'], notes: ''),
  FormulaDefinition(id: 'VOL_PYRAMID_FRUSTUM', menu: 'Volumes', name: 'Tronco de pirâmide', expression: 'height*(area1+area2+sqrt(area1*area2))/3', inputs: const ['area1', 'area2', 'height'], unit: 'u³', status: 'implemented', conditions: const ['area1>=0', 'area2>=0', 'area1+area2>0', 'height>0'], notes: ''),
  FormulaDefinition(id: 'VOL_ELLIPSOID', menu: 'Volumes', name: 'Elipsoide', expression: '4*pi*a*b*c/3', inputs: const ['a', 'b', 'c'], unit: 'u³', status: 'implemented', conditions: const ['a>0', 'b>0', 'c>0'], notes: ''),
  FormulaDefinition(id: 'VOL_TORUS', menu: 'Volumes', name: 'Toro', expression: '2*pi**2*major_r*minor_r**2', inputs: const ['major_r', 'minor_r'], unit: 'u³', status: 'implemented', conditions: const ['major_r>minor_r', 'minor_r>0'], notes: ''),
  FormulaDefinition(id: 'FLOW_VOLUME_TIME', menu: 'Fluidos e fluxos', name: 'Caudal volumétrico', expression: 'volume/time', inputs: const ['volume', 'time'], unit: 'm³/s', status: 'implemented', conditions: const ['volume>=0', 'time>0'], notes: ''),
  FormulaDefinition(id: 'FLOW_VELOCITY', menu: 'Fluidos e fluxos', name: 'Velocidade média em conduta', expression: 'flow/area', inputs: const ['flow', 'area'], unit: 'm/s', status: 'implemented', conditions: const ['flow>=0', 'area>0'], notes: ''),
  FormulaDefinition(id: 'FLOW_MASS', menu: 'Fluidos e fluxos', name: 'Caudal mássico', expression: 'density*flow', inputs: const ['density', 'flow'], unit: 'kg/s', status: 'implemented', conditions: const ['density>0', 'flow>=0'], notes: ''),
  FormulaDefinition(id: 'FLOW_PIPE_AREA', menu: 'Fluidos e fluxos', name: 'Área interna de tubo', expression: 'pi*diameter**2/4', inputs: const ['diameter'], unit: 'm²', status: 'implemented', conditions: const ['diameter>0'], notes: ''),
  FormulaDefinition(id: 'FLOW_CONTINUITY', menu: 'Fluidos e fluxos', name: 'Continuidade entre secções', expression: 'area1*velocity1/area2', inputs: const ['area1', 'velocity1', 'area2'], unit: 'm/s', status: 'implemented', conditions: const ['area1>0', 'area2>0', 'velocity1>=0'], notes: ''),
  FormulaDefinition(id: 'FLUID_HYDROSTATIC', menu: 'Fluidos e fluxos', name: 'Pressão hidrostática', expression: 'density*g*height', inputs: const ['density', 'g', 'height'], unit: 'Pa', status: 'implemented', conditions: const ['density>0', 'g>0', 'height>=0'], notes: ''),
  FormulaDefinition(id: 'FLUID_PRESSURE_HEAD', menu: 'Fluidos e fluxos', name: 'Altura de pressão', expression: 'pressure/(density*g)', inputs: const ['pressure', 'density', 'g'], unit: 'm', status: 'implemented', conditions: const ['density>0', 'g>0'], notes: ''),
  FormulaDefinition(id: 'FLUID_REYNOLDS', menu: 'Fluidos e fluxos', name: 'Número de Reynolds', expression: 'density*velocity*diameter/dynamic_viscosity', inputs: const ['density', 'velocity', 'diameter', 'dynamic_viscosity'], unit: '1', status: 'implemented', conditions: const ['density>0', 'velocity>=0', 'diameter>0', 'dynamic_viscosity>0'], notes: ''),
  FormulaDefinition(id: 'FLUID_DARCY_HEADLOSS', menu: 'Fluidos e fluxos', name: 'Perda de carga Darcy Weisbach', expression: 'friction_factor*(length/diameter)*velocity**2/(2*g)', inputs: const ['friction_factor', 'length', 'diameter', 'velocity', 'g'], unit: 'm', status: 'implemented', conditions: const ['friction_factor>=0', 'length>=0', 'diameter>0', 'velocity>=0', 'g>0'], notes: ''),
  FormulaDefinition(id: 'FLUID_DARCY_PRESSURE_DROP', menu: 'Fluidos e fluxos', name: 'Queda de pressão Darcy Weisbach', expression: 'friction_factor*(length/diameter)*density*velocity**2/2', inputs: const ['friction_factor', 'length', 'diameter', 'density', 'velocity'], unit: 'Pa', status: 'implemented', conditions: const ['friction_factor>=0', 'length>=0', 'diameter>0', 'density>0', 'velocity>=0'], notes: ''),
  FormulaDefinition(id: 'FLUID_HAZEN_WILLIAMS', menu: 'Fluidos e fluxos', name: 'Perda de carga Hazen Williams SI', expression: '10.67*length*flow**1.852/(coefficient**1.852*diameter**4.87)', inputs: const ['length', 'flow', 'coefficient', 'diameter'], unit: 'm', status: 'implemented', conditions: const ['length>=0', 'flow>=0', 'coefficient>0', 'diameter>0'], notes: ''),
  FormulaDefinition(id: 'FLUID_MANNING', menu: 'Fluidos e fluxos', name: 'Caudal em canal pela fórmula de Manning', expression: 'roughness_inv*area*hydraulic_radius**(2/3)*slope**0.5', inputs: const ['roughness_inv', 'area', 'hydraulic_radius', 'slope'], unit: 'm³/s', status: 'review_pending', conditions: const ['roughness_inv>0', 'area>0', 'hydraulic_radius>0', 'slope>=0'], notes: 'roughness_inv=1/n; confirmar sistema de unidades e coeficiente'),
  FormulaDefinition(id: 'FLUID_ORIFICE', menu: 'Fluidos e fluxos', name: 'Descarga por orifício', expression: 'discharge_coefficient*area*sqrt(2*g*head)', inputs: const ['discharge_coefficient', 'area', 'g', 'head'], unit: 'm³/s', status: 'implemented', conditions: const ['discharge_coefficient>0', 'area>0', 'g>0', 'head>=0'], notes: ''),
  FormulaDefinition(id: 'FLUID_PUMP_POWER', menu: 'Fluidos e fluxos', name: 'Potência hidráulica de bomba', expression: 'density*g*flow*head/efficiency', inputs: const ['density', 'g', 'flow', 'head', 'efficiency'], unit: 'W', status: 'implemented', conditions: const ['density>0', 'g>0', 'flow>=0', 'head>=0', 'efficiency>0', 'efficiency<=1'], notes: ''),
  FormulaDefinition(id: 'FLUID_BERNOULLI_HEAD', menu: 'Fluidos e fluxos', name: 'Carga total de Bernoulli numa secção', expression: 'pressure/(density*g)+velocity**2/(2*g)+elevation', inputs: const ['pressure', 'density', 'g', 'velocity', 'elevation'], unit: 'm', status: 'implemented', conditions: const ['density>0', 'g>0', 'velocity>=0'], notes: ''),
  FormulaDefinition(id: 'ELEC_OHM_CURRENT', menu: 'Eletricidade', name: 'Lei de Ohm corrente', expression: 'voltage/resistance', inputs: const ['voltage', 'resistance'], unit: 'A', status: 'implemented', conditions: const ['resistance>0'], notes: ''),
  FormulaDefinition(id: 'ELEC_OHM_VOLTAGE', menu: 'Eletricidade', name: 'Lei de Ohm tensão', expression: 'current*resistance', inputs: const ['current', 'resistance'], unit: 'V', status: 'implemented', conditions: const ['resistance>=0'], notes: ''),
  FormulaDefinition(id: 'ELEC_OHM_RESISTANCE', menu: 'Eletricidade', name: 'Lei de Ohm resistência', expression: 'voltage/current', inputs: const ['voltage', 'current'], unit: 'ohm', status: 'implemented', conditions: const ['current!=0'], notes: ''),
  FormulaDefinition(id: 'ELEC_DC_POWER', menu: 'Eletricidade', name: 'Potência DC', expression: 'voltage*current', inputs: const ['voltage', 'current'], unit: 'W', status: 'implemented', conditions: const [], notes: ''),
  FormulaDefinition(id: 'ELEC_POWER_I2R', menu: 'Eletricidade', name: 'Potência por corrente e resistência', expression: 'current**2*resistance', inputs: const ['current', 'resistance'], unit: 'W', status: 'implemented', conditions: const ['resistance>=0'], notes: ''),
  FormulaDefinition(id: 'ELEC_POWER_V2R', menu: 'Eletricidade', name: 'Potência por tensão e resistência', expression: 'voltage**2/resistance', inputs: const ['voltage', 'resistance'], unit: 'W', status: 'implemented', conditions: const ['resistance>0'], notes: ''),
  FormulaDefinition(id: 'ELEC_ENERGY', menu: 'Eletricidade', name: 'Energia elétrica', expression: 'power*time', inputs: const ['power', 'time'], unit: 'J', status: 'implemented', conditions: const ['time>=0'], notes: ''),
  FormulaDefinition(id: 'ELEC_CHARGE', menu: 'Eletricidade', name: 'Carga elétrica', expression: 'current*time', inputs: const ['current', 'time'], unit: 'C', status: 'implemented', conditions: const ['time>=0'], notes: ''),
  FormulaDefinition(id: 'ELEC_RESISTANCE_SERIES', menu: 'Eletricidade', name: 'Duas resistências em série', expression: 'r1+r2', inputs: const ['r1', 'r2'], unit: 'ohm', status: 'implemented', conditions: const ['r1>=0', 'r2>=0'], notes: ''),
  FormulaDefinition(id: 'ELEC_RESISTANCE_PARALLEL', menu: 'Eletricidade', name: 'Duas resistências em paralelo', expression: '1/(1/r1+1/r2)', inputs: const ['r1', 'r2'], unit: 'ohm', status: 'implemented', conditions: const ['r1>0', 'r2>0'], notes: ''),
  FormulaDefinition(id: 'ELEC_VOLTAGE_DIVIDER', menu: 'Eletricidade', name: 'Divisor de tensão', expression: 'vin*r2/(r1+r2)', inputs: const ['vin', 'r1', 'r2'], unit: 'V', status: 'implemented', conditions: const ['r1>=0', 'r2>=0', 'r1+r2>0'], notes: ''),
  FormulaDefinition(id: 'ELEC_CAPACITOR_ENERGY', menu: 'Eletricidade', name: 'Energia em condensador', expression: 'capacitance*voltage**2/2', inputs: const ['capacitance', 'voltage'], unit: 'J', status: 'implemented', conditions: const ['capacitance>=0'], notes: ''),
  FormulaDefinition(id: 'ELEC_CAPACITIVE_REACTANCE', menu: 'Eletricidade', name: 'Reatância capacitiva', expression: '1/(2*pi*frequency*capacitance)', inputs: const ['frequency', 'capacitance'], unit: 'ohm', status: 'implemented', conditions: const ['frequency>0', 'capacitance>0'], notes: ''),
  FormulaDefinition(id: 'ELEC_INDUCTIVE_REACTANCE', menu: 'Eletricidade', name: 'Reatância indutiva', expression: '2*pi*frequency*inductance', inputs: const ['frequency', 'inductance'], unit: 'ohm', status: 'implemented', conditions: const ['frequency>=0', 'inductance>=0'], notes: ''),
  FormulaDefinition(id: 'ELEC_RLC_IMPEDANCE', menu: 'Eletricidade', name: 'Impedância série RLC', expression: 'sqrt(resistance**2+(2*pi*frequency*inductance-1/(2*pi*frequency*capacitance))**2)', inputs: const ['resistance', 'frequency', 'inductance', 'capacitance'], unit: 'ohm', status: 'implemented', conditions: const ['resistance>=0', 'frequency>0', 'inductance>=0', 'capacitance>0'], notes: ''),
  FormulaDefinition(id: 'ELEC_RESONANCE', menu: 'Eletricidade', name: 'Frequência de ressonância LC', expression: '1/(2*pi*sqrt(inductance*capacitance))', inputs: const ['inductance', 'capacitance'], unit: 'Hz', status: 'implemented', conditions: const ['inductance>0', 'capacitance>0'], notes: ''),
  FormulaDefinition(id: 'ELEC_AC1_REAL_POWER', menu: 'Eletricidade', name: 'Potência ativa AC monofásica', expression: 'voltage*current*power_factor', inputs: const ['voltage', 'current', 'power_factor'], unit: 'W', status: 'implemented', conditions: const ['voltage>=0', 'current>=0', 'power_factor>=0', 'power_factor<=1'], notes: ''),
  FormulaDefinition(id: 'ELEC_AC1_CURRENT', menu: 'Eletricidade', name: 'Corrente AC monofásica', expression: 'power/(voltage*power_factor*efficiency)', inputs: const ['power', 'voltage', 'power_factor', 'efficiency'], unit: 'A', status: 'implemented', conditions: const ['power>=0', 'voltage>0', 'power_factor>0', 'power_factor<=1', 'efficiency>0', 'efficiency<=1'], notes: ''),
  FormulaDefinition(id: 'ELEC_AC3_REAL_POWER', menu: 'Eletricidade', name: 'Potência ativa AC trifásica', expression: 'sqrt(3)*line_voltage*line_current*power_factor', inputs: const ['line_voltage', 'line_current', 'power_factor'], unit: 'W', status: 'implemented', conditions: const ['line_voltage>=0', 'line_current>=0', 'power_factor>=0', 'power_factor<=1'], notes: ''),
  FormulaDefinition(id: 'ELEC_AC3_CURRENT', menu: 'Eletricidade', name: 'Corrente AC trifásica', expression: 'power/(sqrt(3)*line_voltage*power_factor*efficiency)', inputs: const ['power', 'line_voltage', 'power_factor', 'efficiency'], unit: 'A', status: 'implemented', conditions: const ['power>=0', 'line_voltage>0', 'power_factor>0', 'power_factor<=1', 'efficiency>0', 'efficiency<=1'], notes: ''),
  FormulaDefinition(id: 'ELEC_APPARENT_POWER', menu: 'Eletricidade', name: 'Potência aparente', expression: 'voltage*current', inputs: const ['voltage', 'current'], unit: 'VA', status: 'implemented', conditions: const ['voltage>=0', 'current>=0'], notes: ''),
  FormulaDefinition(id: 'ELEC_REACTIVE_POWER', menu: 'Eletricidade', name: 'Potência reativa', expression: 'apparent_power*sqrt(1-power_factor**2)', inputs: const ['apparent_power', 'power_factor'], unit: 'var', status: 'implemented', conditions: const ['apparent_power>=0', 'power_factor>=0', 'power_factor<=1'], notes: ''),
  FormulaDefinition(id: 'ELEC_TRANSFORMER_VOLTAGE', menu: 'Eletricidade', name: 'Relação de transformação de tensão', expression: 'primary_voltage*secondary_turns/primary_turns', inputs: const ['primary_voltage', 'primary_turns', 'secondary_turns'], unit: 'V', status: 'implemented', conditions: const ['primary_turns>0', 'secondary_turns>0'], notes: ''),
  FormulaDefinition(id: 'ELEC_VDROP_DC', menu: 'Eletricidade', name: 'Queda de tensão DC ou monofásica resistiva', expression: '2*length*current*resistivity/area', inputs: const ['length', 'current', 'resistivity', 'area'], unit: 'V', status: 'review_pending', conditions: const ['length>=0', 'current>=0', 'resistivity>0', 'area>0'], notes: 'Fatores térmicos e de instalação são externos'),
  FormulaDefinition(id: 'ELEC_VDROP_AC3', menu: 'Eletricidade', name: 'Queda de tensão trifásica simplificada', expression: 'sqrt(3)*length*current*(resistance_per_length*power_factor+reactance_per_length*sqrt(1-power_factor**2))', inputs: const ['length', 'current', 'resistance_per_length', 'reactance_per_length', 'power_factor'], unit: 'V', status: 'review_pending', conditions: const ['length>=0', 'current>=0', 'resistance_per_length>=0', 'reactance_per_length>=0', 'power_factor>=0', 'power_factor<=1'], notes: ''),
  FormulaDefinition(id: 'ELEC_DESIGN_CURRENT', menu: 'Eletricidade', name: 'Corrente de projeto com fatores', expression: 'load_current/(correction_factor*grouping_factor*temperature_factor)', inputs: const ['load_current', 'correction_factor', 'grouping_factor', 'temperature_factor'], unit: 'A', status: 'review_pending', conditions: const ['load_current>=0', 'correction_factor>0', 'grouping_factor>0', 'temperature_factor>0'], notes: 'Os fatores e tabelas vêm da norma/edição escolhida pelo utilizador'),
  FormulaDefinition(id: 'ELEC_PROTECTION_MIN_RATING', menu: 'Eletricidade', name: 'Classificação mínima teórica da proteção', expression: 'design_current*safety_factor', inputs: const ['design_current', 'safety_factor'], unit: 'A', status: 'review_pending', conditions: const ['design_current>=0', 'safety_factor>=1'], notes: 'Não seleciona automaticamente um calibre normalizado nem prova coordenação'),
  FormulaDefinition(id: 'ELEC_SHORT_CIRCUIT', menu: 'Eletricidade', name: 'Corrente de curto-circuito por impedância', expression: 'voltage/impedance', inputs: const ['voltage', 'impedance'], unit: 'A', status: 'review_pending', conditions: const ['impedance>0'], notes: ''),
  FormulaDefinition(id: 'PHYS_SPEED', menu: 'Física', name: 'Velocidade média', expression: 'distance/time', inputs: const ['distance', 'time'], unit: 'm/s', status: 'implemented', conditions: const ['time>0'], notes: ''),
  FormulaDefinition(id: 'PHYS_ACCELERATION', menu: 'Física', name: 'Aceleração média', expression: '(final_velocity-initial_velocity)/time', inputs: const ['final_velocity', 'initial_velocity', 'time'], unit: 'm/s²', status: 'implemented', conditions: const ['time>0'], notes: ''),
  FormulaDefinition(id: 'PHYS_KINEMATICS_V', menu: 'Física', name: 'Velocidade com aceleração constante', expression: 'initial_velocity+acceleration*time', inputs: const ['initial_velocity', 'acceleration', 'time'], unit: 'm/s', status: 'implemented', conditions: const ['time>=0'], notes: ''),
  FormulaDefinition(id: 'PHYS_KINEMATICS_S', menu: 'Física', name: 'Deslocamento com aceleração constante', expression: 'initial_velocity*time+acceleration*time**2/2', inputs: const ['initial_velocity', 'acceleration', 'time'], unit: 'm', status: 'implemented', conditions: const ['time>=0'], notes: ''),
  FormulaDefinition(id: 'PHYS_FORCE', menu: 'Física', name: 'Segunda lei de Newton', expression: 'mass*acceleration', inputs: const ['mass', 'acceleration'], unit: 'N', status: 'implemented', conditions: const ['mass>=0'], notes: ''),
  FormulaDefinition(id: 'PHYS_WEIGHT', menu: 'Física', name: 'Peso', expression: 'mass*g', inputs: const ['mass', 'g'], unit: 'N', status: 'implemented', conditions: const ['mass>=0', 'g>0'], notes: ''),
  FormulaDefinition(id: 'PHYS_WORK', menu: 'Física', name: 'Trabalho de força constante', expression: 'force*distance*cos(angle_deg*pi/180)', inputs: const ['force', 'distance', 'angle_deg'], unit: 'J', status: 'implemented', conditions: const ['distance>=0'], notes: ''),
  FormulaDefinition(id: 'PHYS_KINETIC_ENERGY', menu: 'Física', name: 'Energia cinética', expression: 'mass*velocity**2/2', inputs: const ['mass', 'velocity'], unit: 'J', status: 'implemented', conditions: const ['mass>=0'], notes: ''),
  FormulaDefinition(id: 'PHYS_POTENTIAL_ENERGY', menu: 'Física', name: 'Energia potencial gravítica', expression: 'mass*g*height', inputs: const ['mass', 'g', 'height'], unit: 'J', status: 'implemented', conditions: const ['mass>=0', 'g>0'], notes: ''),
  FormulaDefinition(id: 'PHYS_POWER', menu: 'Física', name: 'Potência média', expression: 'work/time', inputs: const ['work', 'time'], unit: 'W', status: 'implemented', conditions: const ['time>0'], notes: ''),
  FormulaDefinition(id: 'PHYS_MOMENTUM', menu: 'Física', name: 'Quantidade de movimento', expression: 'mass*velocity', inputs: const ['mass', 'velocity'], unit: 'kg·m/s', status: 'implemented', conditions: const ['mass>=0'], notes: ''),
  FormulaDefinition(id: 'PHYS_IMPULSE', menu: 'Física', name: 'Impulso', expression: 'force*time', inputs: const ['force', 'time'], unit: 'N·s', status: 'implemented', conditions: const ['time>=0'], notes: ''),
  FormulaDefinition(id: 'PHYS_DENSITY', menu: 'Física', name: 'Densidade', expression: 'mass/volume', inputs: const ['mass', 'volume'], unit: 'kg/m³', status: 'implemented', conditions: const ['mass>=0', 'volume>0'], notes: ''),
  FormulaDefinition(id: 'PHYS_PRESSURE', menu: 'Física', name: 'Pressão média', expression: 'force/area', inputs: const ['force', 'area'], unit: 'Pa', status: 'implemented', conditions: const ['area>0'], notes: ''),
  FormulaDefinition(id: 'PHYS_TORQUE', menu: 'Física', name: 'Momento de força', expression: 'force*lever_arm*sin(angle_deg*pi/180)', inputs: const ['force', 'lever_arm', 'angle_deg'], unit: 'N·m', status: 'implemented', conditions: const ['lever_arm>=0'], notes: ''),
  FormulaDefinition(id: 'PHYS_CENTRIPETAL_FORCE', menu: 'Física', name: 'Força centrípeta', expression: 'mass*velocity**2/radius', inputs: const ['mass', 'velocity', 'radius'], unit: 'N', status: 'implemented', conditions: const ['mass>=0', 'radius>0'], notes: ''),
  FormulaDefinition(id: 'PHYS_GRAVITATION', menu: 'Física', name: 'Gravitação universal', expression: 'G*mass1*mass2/distance**2', inputs: const ['G', 'mass1', 'mass2', 'distance'], unit: 'N', status: 'implemented', conditions: const ['G>0', 'mass1>=0', 'mass2>=0', 'distance>0'], notes: ''),
  FormulaDefinition(id: 'PHYS_HOOKE', menu: 'Física', name: 'Lei de Hooke', expression: 'spring_constant*extension', inputs: const ['spring_constant', 'extension'], unit: 'N', status: 'implemented', conditions: const ['spring_constant>=0'], notes: ''),
  FormulaDefinition(id: 'PHYS_FREQUENCY', menu: 'Física', name: 'Frequência por período', expression: '1/period', inputs: const ['period'], unit: 'Hz', status: 'implemented', conditions: const ['period>0'], notes: ''),
  FormulaDefinition(id: 'PHYS_WAVE_SPEED', menu: 'Física', name: 'Velocidade de onda', expression: 'frequency*wavelength', inputs: const ['frequency', 'wavelength'], unit: 'm/s', status: 'implemented', conditions: const ['frequency>=0', 'wavelength>=0'], notes: ''),
  FormulaDefinition(id: 'PHYS_IDEAL_GAS_PRESSURE', menu: 'Física', name: 'Pressão de gás ideal', expression: 'moles*gas_constant*temperature/volume', inputs: const ['moles', 'gas_constant', 'temperature', 'volume'], unit: 'Pa', status: 'implemented', conditions: const ['moles>=0', 'gas_constant>0', 'temperature>0', 'volume>0'], notes: ''),
  FormulaDefinition(id: 'PHYS_SENSIBLE_HEAT', menu: 'Física', name: 'Calor sensível', expression: 'mass*specific_heat*temperature_change', inputs: const ['mass', 'specific_heat', 'temperature_change'], unit: 'J', status: 'implemented', conditions: const ['mass>=0', 'specific_heat>=0'], notes: ''),
  FormulaDefinition(id: 'PHYS_LINEAR_EXPANSION', menu: 'Física', name: 'Dilatação linear', expression: 'coefficient*initial_length*temperature_change', inputs: const ['coefficient', 'initial_length', 'temperature_change'], unit: 'm', status: 'implemented', conditions: const ['coefficient>=0', 'initial_length>=0'], notes: ''),
  FormulaDefinition(id: 'PHYS_EFFICIENCY', menu: 'Física', name: 'Eficiência', expression: 'useful_output/input_energy', inputs: const ['useful_output', 'input_energy'], unit: '1', status: 'implemented', conditions: const ['input_energy>0', 'useful_output>=0'], notes: ''),
  FormulaDefinition(id: 'PHYS_PHOTON_ENERGY', menu: 'Física', name: 'Energia de fotão', expression: 'planck*frequency', inputs: const ['planck', 'frequency'], unit: 'J', status: 'implemented', conditions: const ['planck>0', 'frequency>=0'], notes: ''),
  FormulaDefinition(id: 'PHYS_SNELL', menu: 'Física', name: 'Ângulo refratado pela lei de Snell', expression: 'asin(refractive_index1*sin(angle1_deg*pi/180)/refractive_index2)*180/pi', inputs: const ['refractive_index1', 'refractive_index2', 'angle1_deg'], unit: 'deg', status: 'implemented', conditions: const ['refractive_index1>0', 'refractive_index2>0'], notes: ''),
  FormulaDefinition(id: 'PHYS_THIN_LENS', menu: 'Física', name: 'Distância de imagem em lente delgada', expression: '1/(1/focal_length-1/object_distance)', inputs: const ['focal_length', 'object_distance'], unit: 'm', status: 'implemented', conditions: const ['focal_length!=0', 'object_distance!=0', '1/focal_length!=1/object_distance'], notes: ''),
  FormulaDefinition(id: 'STRUCT_NORMAL_STRESS', menu: 'Estruturas e equipamentos', name: 'Tensão normal média', expression: 'force/area', inputs: const ['force', 'area'], unit: 'Pa', status: 'review_pending', conditions: const ['area>0'], notes: 'Verificar modelo, apoios, regime, norma, edição, coeficientes e unidades antes de decisão real'),
  FormulaDefinition(id: 'STRUCT_STRAIN', menu: 'Estruturas e equipamentos', name: 'Extensão normal', expression: 'length_change/original_length', inputs: const ['length_change', 'original_length'], unit: '1', status: 'review_pending', conditions: const ['original_length>0'], notes: 'Verificar modelo, apoios, regime, norma, edição, coeficientes e unidades antes de decisão real'),
  FormulaDefinition(id: 'STRUCT_HOOKE_STRESS', menu: 'Estruturas e equipamentos', name: 'Tensão elástica', expression: 'young_modulus*strain', inputs: const ['young_modulus', 'strain'], unit: 'Pa', status: 'review_pending', conditions: const ['young_modulus>0'], notes: 'Verificar modelo, apoios, regime, norma, edição, coeficientes e unidades antes de decisão real'),
  FormulaDefinition(id: 'STRUCT_AXIAL_DEFORMATION', menu: 'Estruturas e equipamentos', name: 'Deformação axial de barra', expression: 'force*length/(area*young_modulus)', inputs: const ['force', 'length', 'area', 'young_modulus'], unit: 'm', status: 'review_pending', conditions: const ['length>=0', 'area>0', 'young_modulus>0'], notes: 'Verificar modelo, apoios, regime, norma, edição, coeficientes e unidades antes de decisão real'),
  FormulaDefinition(id: 'STRUCT_BENDING_STRESS', menu: 'Estruturas e equipamentos', name: 'Tensão de flexão', expression: 'moment*distance_to_extreme_fibre/second_moment_area', inputs: const ['moment', 'distance_to_extreme_fibre', 'second_moment_area'], unit: 'Pa', status: 'review_pending', conditions: const ['distance_to_extreme_fibre>=0', 'second_moment_area>0'], notes: 'Verificar modelo, apoios, regime, norma, edição, coeficientes e unidades antes de decisão real'),
  FormulaDefinition(id: 'STRUCT_RECT_I', menu: 'Estruturas e equipamentos', name: 'Segundo momento de área retangular', expression: 'width*height**3/12', inputs: const ['width', 'height'], unit: 'm⁴', status: 'review_pending', conditions: const ['width>0', 'height>0'], notes: 'Verificar modelo, apoios, regime, norma, edição, coeficientes e unidades antes de decisão real'),
  FormulaDefinition(id: 'STRUCT_CIRCLE_I', menu: 'Estruturas e equipamentos', name: 'Segundo momento de área circular', expression: 'pi*diameter**4/64', inputs: const ['diameter'], unit: 'm⁴', status: 'review_pending', conditions: const ['diameter>0'], notes: 'Verificar modelo, apoios, regime, norma, edição, coeficientes e unidades antes de decisão real'),
  FormulaDefinition(id: 'STRUCT_BEAM_REACTION_POINT', menu: 'Estruturas e equipamentos', name: 'Reação esquerda em viga simplesmente apoiada', expression: 'load*(span-load_position)/span', inputs: const ['load', 'span', 'load_position'], unit: 'N', status: 'review_pending', conditions: const ['span>0', 'load_position>=0', 'load_position<=span'], notes: 'Verificar modelo, apoios, regime, norma, edição, coeficientes e unidades antes de decisão real'),
  FormulaDefinition(id: 'STRUCT_BEAM_MMAX_UDL', menu: 'Estruturas e equipamentos', name: 'Momento máximo em viga simplesmente apoiada com carga uniforme', expression: 'uniform_load*span**2/8', inputs: const ['uniform_load', 'span'], unit: 'N·m', status: 'review_pending', conditions: const ['uniform_load>=0', 'span>0'], notes: 'Verificar modelo, apoios, regime, norma, edição, coeficientes e unidades antes de decisão real'),
  FormulaDefinition(id: 'STRUCT_BEAM_DEFLECTION_UDL', menu: 'Estruturas e equipamentos', name: 'Flecha máxima com carga uniforme', expression: '5*uniform_load*span**4/(384*young_modulus*second_moment_area)', inputs: const ['uniform_load', 'span', 'young_modulus', 'second_moment_area'], unit: 'm', status: 'review_pending', conditions: const ['uniform_load>=0', 'span>0', 'young_modulus>0', 'second_moment_area>0'], notes: 'Verificar modelo, apoios, regime, norma, edição, coeficientes e unidades antes de decisão real'),
  FormulaDefinition(id: 'STRUCT_EULER_BUCKLING', menu: 'Estruturas e equipamentos', name: 'Carga crítica de Euler', expression: 'pi**2*young_modulus*second_moment_area/(effective_length_factor*length)**2', inputs: const ['young_modulus', 'second_moment_area', 'effective_length_factor', 'length'], unit: 'N', status: 'review_pending', conditions: const ['young_modulus>0', 'second_moment_area>0', 'effective_length_factor>0', 'length>0'], notes: 'Verificar modelo, apoios, regime, norma, edição, coeficientes e unidades antes de decisão real'),
  FormulaDefinition(id: 'STRUCT_SAFETY_FACTOR', menu: 'Estruturas e equipamentos', name: 'Fator de segurança', expression: 'capacity/demand', inputs: const ['capacity', 'demand'], unit: '1', status: 'review_pending', conditions: const ['capacity>=0', 'demand>0'], notes: 'Verificar modelo, apoios, regime, norma, edição, coeficientes e unidades antes de decisão real'),
  FormulaDefinition(id: 'PRESSURE_HOOP_STRESS', menu: 'Estruturas e equipamentos', name: 'Tensão circunferencial de parede fina', expression: 'pressure*diameter/(2*thickness)', inputs: const ['pressure', 'diameter', 'thickness'], unit: 'Pa', status: 'review_pending', conditions: const ['diameter>0', 'thickness>0'], notes: 'Verificar modelo, apoios, regime, norma, edição, coeficientes e unidades antes de decisão real'),
  FormulaDefinition(id: 'PRESSURE_LONG_STRESS', menu: 'Estruturas e equipamentos', name: 'Tensão longitudinal de parede fina', expression: 'pressure*diameter/(4*thickness)', inputs: const ['pressure', 'diameter', 'thickness'], unit: 'Pa', status: 'review_pending', conditions: const ['diameter>0', 'thickness>0'], notes: 'Verificar modelo, apoios, regime, norma, edição, coeficientes e unidades antes de decisão real'),
  FormulaDefinition(id: 'PRESSURE_REQUIRED_THICKNESS', menu: 'Estruturas e equipamentos', name: 'Espessura por equação parametrizada', expression: 'pressure*diameter/(2*allowable_stress*joint_efficiency-pressure*coefficient_y)+corrosion_allowance', inputs: const ['pressure', 'diameter', 'allowable_stress', 'joint_efficiency', 'coefficient_y', 'corrosion_allowance'], unit: 'm', status: 'review_pending', conditions: const ['pressure>=0', 'diameter>0', 'allowable_stress>0', 'joint_efficiency>0', 'joint_efficiency<=1', '2*allowable_stress*joint_efficiency-pressure*coefficient_y>0', 'corrosion_allowance>=0'], notes: 'Verificar modelo, apoios, regime, norma, edição, coeficientes e unidades antes de decisão real'),
  FormulaDefinition(id: 'FR_ABSOLUTE_DEVIATION', menu: 'Field Report', name: 'Desvio absoluto face ao nominal', expression: 'measured-nominal', inputs: const ['measured', 'nominal'], unit: 'u', status: 'review_pending', conditions: const [], notes: 'Confirmar unidade, tolerância, método de medição e critério do tipo de inspeção selecionado'),
  FormulaDefinition(id: 'FR_PERCENT_DEVIATION', menu: 'Field Report', name: 'Desvio percentual face ao nominal', expression: '100*(measured-nominal)/nominal', inputs: const ['measured', 'nominal'], unit: '%', status: 'review_pending', conditions: const ['nominal!=0'], notes: 'Confirmar unidade, tolerância, método de medição e critério do tipo de inspeção selecionado'),
  FormulaDefinition(id: 'FR_TOLERANCE_UTILIZATION', menu: 'Field Report', name: 'Utilização da tolerância', expression: '100*abs(measured-nominal)/tolerance', inputs: const ['measured', 'nominal', 'tolerance'], unit: '%', status: 'review_pending', conditions: const ['tolerance>0'], notes: 'Confirmar unidade, tolerância, método de medição e critério do tipo de inspeção selecionado'),
  FormulaDefinition(id: 'FR_AVERAGE_READING', menu: 'Field Report', name: 'Média de quatro leituras', expression: '(reading1+reading2+reading3+reading4)/4', inputs: const ['reading1', 'reading2', 'reading3', 'reading4'], unit: 'u', status: 'review_pending', conditions: const [], notes: 'Confirmar unidade, tolerância, método de medição e critério do tipo de inspeção selecionado'),
  FormulaDefinition(id: 'FR_LINEAR_INTERPOLATION', menu: 'Field Report', name: 'Interpolação linear', expression: 'y1+(x-x1)*(y2-y1)/(x2-x1)', inputs: const ['x', 'x1', 'x2', 'y1', 'y2'], unit: 'u', status: 'review_pending', conditions: const ['x2!=x1'], notes: 'Confirmar unidade, tolerância, método de medição e critério do tipo de inspeção selecionado'),
  FormulaDefinition(id: 'FR_SLOPE_PERCENT', menu: 'Field Report', name: 'Inclinação percentual', expression: '100*rise/run', inputs: const ['rise', 'run'], unit: '%', status: 'review_pending', conditions: const ['run!=0'], notes: 'Confirmar unidade, tolerância, método de medição e critério do tipo de inspeção selecionado'),
  FormulaDefinition(id: 'FR_SLOPE_ANGLE', menu: 'Field Report', name: 'Ângulo de inclinação', expression: 'atan(rise/run)*180/pi', inputs: const ['rise', 'run'], unit: 'deg', status: 'review_pending', conditions: const ['run!=0'], notes: 'Confirmar unidade, tolerância, método de medição e critério do tipo de inspeção selecionado'),
  FormulaDefinition(id: 'FR_RECTANGULAR_QUANTITY', menu: 'Field Report', name: 'Quantidade por área retangular', expression: 'length*width*rate', inputs: const ['length', 'width', 'rate'], unit: 'quantidade', status: 'review_pending', conditions: const ['length>=0', 'width>=0', 'rate>=0'], notes: 'Confirmar unidade, tolerância, método de medição e critério do tipo de inspeção selecionado'),
  FormulaDefinition(id: 'FR_VOLUME_QUANTITY', menu: 'Field Report', name: 'Quantidade por volume', expression: 'volume*rate', inputs: const ['volume', 'rate'], unit: 'quantidade', status: 'review_pending', conditions: const ['volume>=0', 'rate>=0'], notes: 'Confirmar unidade, tolerância, método de medição e critério do tipo de inspeção selecionado'),
];

String prettyMath(String value) => value
  .replaceAll('**2', '²').replaceAll('**3', '³').replaceAll('sqrt', '√')
  .replaceAll('pi', 'π').replaceAll('*', ' × ');

LocalCalculation calculateFormula(FormulaDefinition formula, Map<String, double> v) {
  for (final input in formula.inputs) {
    if (!v.containsKey(input) || !v[input]!.isFinite) {
      throw FormatException('Preencha o parâmetro $input com um número válido.');
    }
  }
  late final double result;
  switch (formula.id) {
      case 'AREA_SQUARE':
        if (!((v['a']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = pow(v['a']!, 2).toDouble();
        break;
      case 'AREA_RECTANGLE':
        if (!((v['length']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['width']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['length']! * v['width']!);
        break;
      case 'AREA_TRIANGLE':
        if (!((v['base']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['height']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['base']! * v['height']!) / 2);
        break;
      case 'AREA_TRIANGLE_HERON':
        if (!((v['a']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['b']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['c']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!(((v['a']! + v['b']!) > v['c']!))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!(((v['a']! + v['c']!) > v['b']!))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!(((v['b']! + v['c']!) > v['a']!))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = sqrt(((((((v['a']! + v['b']!) + v['c']!) / 2) * ((((v['a']! + v['b']!) + v['c']!) / 2) - v['a']!)) * ((((v['a']! + v['b']!) + v['c']!) / 2) - v['b']!)) * ((((v['a']! + v['b']!) + v['c']!) / 2) - v['c']!)));
        break;
      case 'AREA_EQUILATERAL_TRIANGLE':
        if (!((v['a']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((sqrt(3) * pow(v['a']!, 2).toDouble()) / 4);
        break;
      case 'AREA_PARALLELOGRAM':
        if (!((v['base']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['height']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['base']! * v['height']!);
        break;
      case 'AREA_RHOMBUS':
        if (!((v['d1']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['d2']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['d1']! * v['d2']!) / 2);
        break;
      case 'AREA_KITE':
        if (!((v['d1']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['d2']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['d1']! * v['d2']!) / 2);
        break;
      case 'AREA_TRAPEZOID':
        if (!((v['base1']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['base2']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['height']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((v['base1']! + v['base2']!) * v['height']!) / 2);
        break;
      case 'AREA_CIRCLE_RADIUS':
        if (!((v['r']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (pi * pow(v['r']!, 2).toDouble());
        break;
      case 'AREA_CIRCLE_DIAMETER':
        if (!((v['d']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((pi * pow(v['d']!, 2).toDouble()) / 4);
        break;
      case 'AREA_SEMICIRCLE':
        if (!((v['r']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((pi * pow(v['r']!, 2).toDouble()) / 2);
        break;
      case 'AREA_CIRCULAR_SECTOR':
        if (!((v['r']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['angle_deg']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['angle_deg']! <= 360))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((pi * pow(v['r']!, 2).toDouble()) * v['angle_deg']!) / 360);
        break;
      case 'AREA_ELLIPSE':
        if (!((v['a']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['b']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((pi * v['a']!) * v['b']!);
        break;
      case 'AREA_ANNULUS':
        if (!((v['outer_r']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['inner_r']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['outer_r']! > v['inner_r']!))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (pi * (pow(v['outer_r']!, 2).toDouble() - pow(v['inner_r']!, 2).toDouble()));
        break;
      case 'AREA_REGULAR_POLYGON':
        if (!((v['n']! >= 3))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['n']!).isFinite && (v['n']!) == (v['n']!).truncateToDouble())) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['side']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['n']! * pow(v['side']!, 2).toDouble()) / (4 * tan((pi / v['n']!))));
        break;
      case 'SURFACE_CUBE':
        if (!((v['a']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (6 * pow(v['a']!, 2).toDouble());
        break;
      case 'SURFACE_CUBOID':
        if (!((v['length']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['width']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['height']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (2 * (((v['length']! * v['width']!) + (v['length']! * v['height']!)) + (v['width']! * v['height']!)));
        break;
      case 'SURFACE_CYLINDER':
        if (!((v['r']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['height']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((2 * pi) * v['r']!) * (v['r']! + v['height']!));
        break;
      case 'SURFACE_CONE':
        if (!((v['r']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['height']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((pi * v['r']!) * (v['r']! + sqrt((pow(v['r']!, 2).toDouble() + pow(v['height']!, 2).toDouble()))));
        break;
      case 'SURFACE_SPHERE':
        if (!((v['r']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((4 * pi) * pow(v['r']!, 2).toDouble());
        break;
      case 'SURFACE_HEMISPHERE':
        if (!((v['r']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((3 * pi) * pow(v['r']!, 2).toDouble());
        break;
      case 'VOL_CUBE':
        if (!((v['a']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = pow(v['a']!, 3).toDouble();
        break;
      case 'VOL_CUBOID':
        if (!((v['length']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['width']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['height']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['length']! * v['width']!) * v['height']!);
        break;
      case 'VOL_PRISM':
        if (!((v['base_area']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['height']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['base_area']! * v['height']!);
        break;
      case 'VOL_CYLINDER':
        if (!((v['r']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['height']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((pi * pow(v['r']!, 2).toDouble()) * v['height']!);
        break;
      case 'VOL_HOLLOW_CYLINDER':
        if (!((v['outer_r']! > v['inner_r']!))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['inner_r']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['height']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((pi * (pow(v['outer_r']!, 2).toDouble() - pow(v['inner_r']!, 2).toDouble())) * v['height']!);
        break;
      case 'VOL_CONE':
        if (!((v['r']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['height']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((pi * pow(v['r']!, 2).toDouble()) * v['height']!) / 3);
        break;
      case 'VOL_CONE_FRUSTUM':
        if (!((v['r1']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['r2']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!(((v['r1']! + v['r2']!) > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['height']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((pi * v['height']!) * ((pow(v['r1']!, 2).toDouble() + (v['r1']! * v['r2']!)) + pow(v['r2']!, 2).toDouble())) / 3);
        break;
      case 'VOL_SPHERE':
        if (!((v['r']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((4 * pi) * pow(v['r']!, 3).toDouble()) / 3);
        break;
      case 'VOL_HEMISPHERE':
        if (!((v['r']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((2 * pi) * pow(v['r']!, 3).toDouble()) / 3);
        break;
      case 'VOL_PYRAMID':
        if (!((v['base_area']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['height']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['base_area']! * v['height']!) / 3);
        break;
      case 'VOL_PYRAMID_FRUSTUM':
        if (!((v['area1']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['area2']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!(((v['area1']! + v['area2']!) > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['height']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['height']! * ((v['area1']! + v['area2']!) + sqrt((v['area1']! * v['area2']!)))) / 3);
        break;
      case 'VOL_ELLIPSOID':
        if (!((v['a']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['b']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['c']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((((4 * pi) * v['a']!) * v['b']!) * v['c']!) / 3);
        break;
      case 'VOL_TORUS':
        if (!((v['major_r']! > v['minor_r']!))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['minor_r']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((2 * pow(pi, 2).toDouble()) * v['major_r']!) * pow(v['minor_r']!, 2).toDouble());
        break;
      case 'FLOW_VOLUME_TIME':
        if (!((v['volume']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['time']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['volume']! / v['time']!);
        break;
      case 'FLOW_VELOCITY':
        if (!((v['flow']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['area']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['flow']! / v['area']!);
        break;
      case 'FLOW_MASS':
        if (!((v['density']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['flow']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['density']! * v['flow']!);
        break;
      case 'FLOW_PIPE_AREA':
        if (!((v['diameter']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((pi * pow(v['diameter']!, 2).toDouble()) / 4);
        break;
      case 'FLOW_CONTINUITY':
        if (!((v['area1']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['area2']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['velocity1']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['area1']! * v['velocity1']!) / v['area2']!);
        break;
      case 'FLUID_HYDROSTATIC':
        if (!((v['density']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['g']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['height']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['density']! * v['g']!) * v['height']!);
        break;
      case 'FLUID_PRESSURE_HEAD':
        if (!((v['density']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['g']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['pressure']! / (v['density']! * v['g']!));
        break;
      case 'FLUID_REYNOLDS':
        if (!((v['density']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['velocity']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['diameter']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['dynamic_viscosity']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((v['density']! * v['velocity']!) * v['diameter']!) / v['dynamic_viscosity']!);
        break;
      case 'FLUID_DARCY_HEADLOSS':
        if (!((v['friction_factor']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['length']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['diameter']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['velocity']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['g']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((v['friction_factor']! * (v['length']! / v['diameter']!)) * pow(v['velocity']!, 2).toDouble()) / (2 * v['g']!));
        break;
      case 'FLUID_DARCY_PRESSURE_DROP':
        if (!((v['friction_factor']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['length']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['diameter']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['density']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['velocity']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((((v['friction_factor']! * (v['length']! / v['diameter']!)) * v['density']!) * pow(v['velocity']!, 2).toDouble()) / 2);
        break;
      case 'FLUID_HAZEN_WILLIAMS':
        if (!((v['length']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['flow']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['coefficient']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['diameter']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((10.67 * v['length']!) * pow(v['flow']!, 1.852).toDouble()) / (pow(v['coefficient']!, 1.852).toDouble() * pow(v['diameter']!, 4.87).toDouble()));
        break;
      case 'FLUID_MANNING':
        if (!((v['roughness_inv']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['area']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['hydraulic_radius']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['slope']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((v['roughness_inv']! * v['area']!) * pow(v['hydraulic_radius']!, (2 / 3)).toDouble()) * pow(v['slope']!, 0.5).toDouble());
        break;
      case 'FLUID_ORIFICE':
        if (!((v['discharge_coefficient']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['area']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['g']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['head']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['discharge_coefficient']! * v['area']!) * sqrt(((2 * v['g']!) * v['head']!)));
        break;
      case 'FLUID_PUMP_POWER':
        if (!((v['density']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['g']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['flow']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['head']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['efficiency']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['efficiency']! <= 1))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((((v['density']! * v['g']!) * v['flow']!) * v['head']!) / v['efficiency']!);
        break;
      case 'FLUID_BERNOULLI_HEAD':
        if (!((v['density']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['g']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['velocity']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((v['pressure']! / (v['density']! * v['g']!)) + (pow(v['velocity']!, 2).toDouble() / (2 * v['g']!))) + v['elevation']!);
        break;
      case 'ELEC_OHM_CURRENT':
        if (!((v['resistance']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['voltage']! / v['resistance']!);
        break;
      case 'ELEC_OHM_VOLTAGE':
        if (!((v['resistance']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['current']! * v['resistance']!);
        break;
      case 'ELEC_OHM_RESISTANCE':
        if (!((v['current']! != 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['voltage']! / v['current']!);
        break;
      case 'ELEC_DC_POWER':

        result = (v['voltage']! * v['current']!);
        break;
      case 'ELEC_POWER_I2R':
        if (!((v['resistance']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (pow(v['current']!, 2).toDouble() * v['resistance']!);
        break;
      case 'ELEC_POWER_V2R':
        if (!((v['resistance']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (pow(v['voltage']!, 2).toDouble() / v['resistance']!);
        break;
      case 'ELEC_ENERGY':
        if (!((v['time']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['power']! * v['time']!);
        break;
      case 'ELEC_CHARGE':
        if (!((v['time']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['current']! * v['time']!);
        break;
      case 'ELEC_RESISTANCE_SERIES':
        if (!((v['r1']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['r2']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['r1']! + v['r2']!);
        break;
      case 'ELEC_RESISTANCE_PARALLEL':
        if (!((v['r1']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['r2']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (1 / ((1 / v['r1']!) + (1 / v['r2']!)));
        break;
      case 'ELEC_VOLTAGE_DIVIDER':
        if (!((v['r1']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['r2']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!(((v['r1']! + v['r2']!) > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['vin']! * v['r2']!) / (v['r1']! + v['r2']!));
        break;
      case 'ELEC_CAPACITOR_ENERGY':
        if (!((v['capacitance']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['capacitance']! * pow(v['voltage']!, 2).toDouble()) / 2);
        break;
      case 'ELEC_CAPACITIVE_REACTANCE':
        if (!((v['frequency']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['capacitance']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (1 / (((2 * pi) * v['frequency']!) * v['capacitance']!));
        break;
      case 'ELEC_INDUCTIVE_REACTANCE':
        if (!((v['frequency']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['inductance']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((2 * pi) * v['frequency']!) * v['inductance']!);
        break;
      case 'ELEC_RLC_IMPEDANCE':
        if (!((v['resistance']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['frequency']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['inductance']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['capacitance']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = sqrt((pow(v['resistance']!, 2).toDouble() + pow(((((2 * pi) * v['frequency']!) * v['inductance']!) - (1 / (((2 * pi) * v['frequency']!) * v['capacitance']!))), 2).toDouble()));
        break;
      case 'ELEC_RESONANCE':
        if (!((v['inductance']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['capacitance']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (1 / ((2 * pi) * sqrt((v['inductance']! * v['capacitance']!))));
        break;
      case 'ELEC_AC1_REAL_POWER':
        if (!((v['voltage']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['current']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['power_factor']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['power_factor']! <= 1))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['voltage']! * v['current']!) * v['power_factor']!);
        break;
      case 'ELEC_AC1_CURRENT':
        if (!((v['power']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['voltage']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['power_factor']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['power_factor']! <= 1))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['efficiency']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['efficiency']! <= 1))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['power']! / ((v['voltage']! * v['power_factor']!) * v['efficiency']!));
        break;
      case 'ELEC_AC3_REAL_POWER':
        if (!((v['line_voltage']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['line_current']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['power_factor']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['power_factor']! <= 1))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((sqrt(3) * v['line_voltage']!) * v['line_current']!) * v['power_factor']!);
        break;
      case 'ELEC_AC3_CURRENT':
        if (!((v['power']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['line_voltage']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['power_factor']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['power_factor']! <= 1))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['efficiency']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['efficiency']! <= 1))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['power']! / (((sqrt(3) * v['line_voltage']!) * v['power_factor']!) * v['efficiency']!));
        break;
      case 'ELEC_APPARENT_POWER':
        if (!((v['voltage']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['current']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['voltage']! * v['current']!);
        break;
      case 'ELEC_REACTIVE_POWER':
        if (!((v['apparent_power']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['power_factor']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['power_factor']! <= 1))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['apparent_power']! * sqrt((1 - pow(v['power_factor']!, 2).toDouble())));
        break;
      case 'ELEC_TRANSFORMER_VOLTAGE':
        if (!((v['primary_turns']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['secondary_turns']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['primary_voltage']! * v['secondary_turns']!) / v['primary_turns']!);
        break;
      case 'ELEC_VDROP_DC':
        if (!((v['length']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['current']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['resistivity']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['area']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((((2 * v['length']!) * v['current']!) * v['resistivity']!) / v['area']!);
        break;
      case 'ELEC_VDROP_AC3':
        if (!((v['length']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['current']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['resistance_per_length']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['reactance_per_length']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['power_factor']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['power_factor']! <= 1))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((sqrt(3) * v['length']!) * v['current']!) * ((v['resistance_per_length']! * v['power_factor']!) + (v['reactance_per_length']! * sqrt((1 - pow(v['power_factor']!, 2).toDouble())))));
        break;
      case 'ELEC_DESIGN_CURRENT':
        if (!((v['load_current']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['correction_factor']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['grouping_factor']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['temperature_factor']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['load_current']! / ((v['correction_factor']! * v['grouping_factor']!) * v['temperature_factor']!));
        break;
      case 'ELEC_PROTECTION_MIN_RATING':
        if (!((v['design_current']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['safety_factor']! >= 1))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['design_current']! * v['safety_factor']!);
        break;
      case 'ELEC_SHORT_CIRCUIT':
        if (!((v['impedance']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['voltage']! / v['impedance']!);
        break;
      case 'PHYS_SPEED':
        if (!((v['time']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['distance']! / v['time']!);
        break;
      case 'PHYS_ACCELERATION':
        if (!((v['time']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['final_velocity']! - v['initial_velocity']!) / v['time']!);
        break;
      case 'PHYS_KINEMATICS_V':
        if (!((v['time']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['initial_velocity']! + (v['acceleration']! * v['time']!));
        break;
      case 'PHYS_KINEMATICS_S':
        if (!((v['time']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['initial_velocity']! * v['time']!) + ((v['acceleration']! * pow(v['time']!, 2).toDouble()) / 2));
        break;
      case 'PHYS_FORCE':
        if (!((v['mass']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['mass']! * v['acceleration']!);
        break;
      case 'PHYS_WEIGHT':
        if (!((v['mass']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['g']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['mass']! * v['g']!);
        break;
      case 'PHYS_WORK':
        if (!((v['distance']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['force']! * v['distance']!) * cos(((v['angle_deg']! * pi) / 180)));
        break;
      case 'PHYS_KINETIC_ENERGY':
        if (!((v['mass']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['mass']! * pow(v['velocity']!, 2).toDouble()) / 2);
        break;
      case 'PHYS_POTENTIAL_ENERGY':
        if (!((v['mass']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['g']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['mass']! * v['g']!) * v['height']!);
        break;
      case 'PHYS_POWER':
        if (!((v['time']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['work']! / v['time']!);
        break;
      case 'PHYS_MOMENTUM':
        if (!((v['mass']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['mass']! * v['velocity']!);
        break;
      case 'PHYS_IMPULSE':
        if (!((v['time']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['force']! * v['time']!);
        break;
      case 'PHYS_DENSITY':
        if (!((v['mass']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['volume']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['mass']! / v['volume']!);
        break;
      case 'PHYS_PRESSURE':
        if (!((v['area']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['force']! / v['area']!);
        break;
      case 'PHYS_TORQUE':
        if (!((v['lever_arm']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['force']! * v['lever_arm']!) * sin(((v['angle_deg']! * pi) / 180)));
        break;
      case 'PHYS_CENTRIPETAL_FORCE':
        if (!((v['mass']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['radius']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['mass']! * pow(v['velocity']!, 2).toDouble()) / v['radius']!);
        break;
      case 'PHYS_GRAVITATION':
        if (!((v['G']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['mass1']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['mass2']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['distance']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((v['G']! * v['mass1']!) * v['mass2']!) / pow(v['distance']!, 2).toDouble());
        break;
      case 'PHYS_HOOKE':
        if (!((v['spring_constant']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['spring_constant']! * v['extension']!);
        break;
      case 'PHYS_FREQUENCY':
        if (!((v['period']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (1 / v['period']!);
        break;
      case 'PHYS_WAVE_SPEED':
        if (!((v['frequency']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['wavelength']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['frequency']! * v['wavelength']!);
        break;
      case 'PHYS_IDEAL_GAS_PRESSURE':
        if (!((v['moles']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['gas_constant']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['temperature']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['volume']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((v['moles']! * v['gas_constant']!) * v['temperature']!) / v['volume']!);
        break;
      case 'PHYS_SENSIBLE_HEAT':
        if (!((v['mass']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['specific_heat']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['mass']! * v['specific_heat']!) * v['temperature_change']!);
        break;
      case 'PHYS_LINEAR_EXPANSION':
        if (!((v['coefficient']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['initial_length']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['coefficient']! * v['initial_length']!) * v['temperature_change']!);
        break;
      case 'PHYS_EFFICIENCY':
        if (!((v['input_energy']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['useful_output']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['useful_output']! / v['input_energy']!);
        break;
      case 'PHYS_PHOTON_ENERGY':
        if (!((v['planck']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['frequency']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['planck']! * v['frequency']!);
        break;
      case 'PHYS_SNELL':
        if (!((v['refractive_index1']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['refractive_index2']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((asin(((v['refractive_index1']! * sin(((v['angle1_deg']! * pi) / 180))) / v['refractive_index2']!)) * 180) / pi);
        break;
      case 'PHYS_THIN_LENS':
        if (!((v['focal_length']! != 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['object_distance']! != 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!(((1 / v['focal_length']!) != (1 / v['object_distance']!)))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (1 / ((1 / v['focal_length']!) - (1 / v['object_distance']!)));
        break;
      case 'STRUCT_NORMAL_STRESS':
        if (!((v['area']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['force']! / v['area']!);
        break;
      case 'STRUCT_STRAIN':
        if (!((v['original_length']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['length_change']! / v['original_length']!);
        break;
      case 'STRUCT_HOOKE_STRESS':
        if (!((v['young_modulus']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['young_modulus']! * v['strain']!);
        break;
      case 'STRUCT_AXIAL_DEFORMATION':
        if (!((v['length']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['area']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['young_modulus']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['force']! * v['length']!) / (v['area']! * v['young_modulus']!));
        break;
      case 'STRUCT_BENDING_STRESS':
        if (!((v['distance_to_extreme_fibre']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['second_moment_area']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['moment']! * v['distance_to_extreme_fibre']!) / v['second_moment_area']!);
        break;
      case 'STRUCT_RECT_I':
        if (!((v['width']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['height']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['width']! * pow(v['height']!, 3).toDouble()) / 12);
        break;
      case 'STRUCT_CIRCLE_I':
        if (!((v['diameter']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((pi * pow(v['diameter']!, 4).toDouble()) / 64);
        break;
      case 'STRUCT_BEAM_REACTION_POINT':
        if (!((v['span']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['load_position']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['load_position']! <= v['span']!))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['load']! * (v['span']! - v['load_position']!)) / v['span']!);
        break;
      case 'STRUCT_BEAM_MMAX_UDL':
        if (!((v['uniform_load']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['span']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['uniform_load']! * pow(v['span']!, 2).toDouble()) / 8);
        break;
      case 'STRUCT_BEAM_DEFLECTION_UDL':
        if (!((v['uniform_load']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['span']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['young_modulus']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['second_moment_area']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((5 * v['uniform_load']!) * pow(v['span']!, 4).toDouble()) / ((384 * v['young_modulus']!) * v['second_moment_area']!));
        break;
      case 'STRUCT_EULER_BUCKLING':
        if (!((v['young_modulus']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['second_moment_area']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['effective_length_factor']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['length']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((pow(pi, 2).toDouble() * v['young_modulus']!) * v['second_moment_area']!) / pow((v['effective_length_factor']! * v['length']!), 2).toDouble());
        break;
      case 'STRUCT_SAFETY_FACTOR':
        if (!((v['capacity']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['demand']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['capacity']! / v['demand']!);
        break;
      case 'PRESSURE_HOOP_STRESS':
        if (!((v['diameter']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['thickness']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['pressure']! * v['diameter']!) / (2 * v['thickness']!));
        break;
      case 'PRESSURE_LONG_STRESS':
        if (!((v['diameter']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['thickness']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['pressure']! * v['diameter']!) / (4 * v['thickness']!));
        break;
      case 'PRESSURE_REQUIRED_THICKNESS':
        if (!((v['pressure']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['diameter']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['allowable_stress']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['joint_efficiency']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['joint_efficiency']! <= 1))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!(((((2 * v['allowable_stress']!) * v['joint_efficiency']!) - (v['pressure']! * v['coefficient_y']!)) > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['corrosion_allowance']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (((v['pressure']! * v['diameter']!) / (((2 * v['allowable_stress']!) * v['joint_efficiency']!) - (v['pressure']! * v['coefficient_y']!))) + v['corrosion_allowance']!);
        break;
      case 'FR_ABSOLUTE_DEVIATION':

        result = (v['measured']! - v['nominal']!);
        break;
      case 'FR_PERCENT_DEVIATION':
        if (!((v['nominal']! != 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((100 * (v['measured']! - v['nominal']!)) / v['nominal']!);
        break;
      case 'FR_TOLERANCE_UTILIZATION':
        if (!((v['tolerance']! > 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((100 * ((v['measured']! - v['nominal']!)).abs().toDouble()) / v['tolerance']!);
        break;
      case 'FR_AVERAGE_READING':

        result = ((((v['reading1']! + v['reading2']!) + v['reading3']!) + v['reading4']!) / 4);
        break;
      case 'FR_LINEAR_INTERPOLATION':
        if (!((v['x2']! != v['x1']!))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['y1']! + (((v['x']! - v['x1']!) * (v['y2']! - v['y1']!)) / (v['x2']! - v['x1']!)));
        break;
      case 'FR_SLOPE_PERCENT':
        if (!((v['run']! != 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((100 * v['rise']!) / v['run']!);
        break;
      case 'FR_SLOPE_ANGLE':
        if (!((v['run']! != 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((atan((v['rise']! / v['run']!)) * 180) / pi);
        break;
      case 'FR_RECTANGULAR_QUANTITY':
        if (!((v['length']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['width']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['rate']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = ((v['length']! * v['width']!) * v['rate']!);
        break;
      case 'FR_VOLUME_QUANTITY':
        if (!((v['volume']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        if (!((v['rate']! >= 0))) throw const FormatException('Dados fora do domínio da fórmula.');
        result = (v['volume']! * v['rate']!);
        break;
    default: throw UnsupportedError('Fórmula não suportada localmente.');
  }
  if (!result.isFinite) throw const FormatException('O resultado não é finito.');
  final substituted = formula.inputs.fold<String>(formula.expression,
    (text, input) => text.replaceAll(RegExp('\\b' + RegExp.escape(input) + '\\b'), '(${v[input]})'));
  return LocalCalculation(result, [
    CalculationStep('1. Selecionar a fórmula', prettyMath(formula.expression), formula.name),
    CalculationStep('2. Confirmar os dados', formula.inputs.map((x) => '$x=${v[x]}').join('; '), 'Parâmetros confirmados pelo utilizador.'),
    CalculationStep('3. Verificar o domínio', formula.conditions.isEmpty ? 'domínio real' : formula.conditions.join(' ∧ '), 'Condições verificadas localmente.'),
    CalculationStep('4. Substituir', prettyMath(substituted), 'Valores inseridos na fórmula versionada.'),
    CalculationStep('5. Calcular', 'resultado = $result ${formula.unit}', 'Resultado do motor determinístico local.'),
  ]);
}
