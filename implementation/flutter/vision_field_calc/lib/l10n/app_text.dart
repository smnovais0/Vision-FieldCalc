import 'package:flutter/widgets.dart';

import '../catalog_router.dart';
import 'app_copy.dart';
import 'formula_names.dart';

class AppScope extends InheritedWidget {
  final AppText text;
  final ValueChangedLocale onLocale;
  const AppScope({super.key, required this.text, required this.onLocale, required super.child});

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope missing');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => text.languageCode != oldWidget.text.languageCode;
}

typedef ValueChangedLocale = void Function(Locale locale);

class AppText {
  final String languageCode;
  const AppText(this.languageCode);

  static const supported = <Locale>[
    Locale('en'),
    Locale('pt', 'PT'),
    Locale('fr'),
    Locale('es'),
    Locale('de'),
  ];

  /// Reserved for a later release. The picker ignores these codes even if a
  /// partial catalog is added. To ship one: add its [Locale] to [supported],
  /// remove the code here, and provide copy plus formula names.
  static const plannedLanguageCodes = ['ar', 'zh', 'id'];

  static const plannedEndonyms = {
    'ar': 'العربية',
    'zh': '中文',
    'id': 'Bahasa Indonesia',
  };

  static const endonyms = {
    'en': 'English',
    'pt': 'Português',
    'fr': 'Français',
    'es': 'Español',
    'de': 'Deutsch',
  };

  static List<Locale> get pickerLocales => [
        for (final locale in supported)
          if (!plannedLanguageCodes.contains(locale.languageCode)) locale,
      ];

  String _t(String key) => appCopy[languageCode]?[key] ?? appCopy['en']![key] ?? key;

  String menu(String canonical) => _menus[languageCode]?[canonical] ?? _menus['en']![canonical] ?? canonical;

  String formulaName(String id, String catalogName) {
    if (languageCode == 'pt') return catalogName;
    return formulaNames[languageCode]?[id] ?? formulaNames['en']?[id] ?? catalogName;
  }

  String phrase(String raw) {
    final bare = raw.replaceFirst(RegExp(r'^\d+\.\s*'), '');
    final localized = appPhrases[languageCode]?[bare];
    if (localized != null && localized.isNotEmpty) return localized;
    if (languageCode == 'pt') return bare;
    return appPhrases['en']?[bare] ?? bare;
  }

  String gateway(String code, [int? statusCode]) => switch (code) {
        'unconfigured' => _t('gatewayUnconfigured'),
        'offline' => _t('gatewayOffline'),
        'quota' => _t('gatewayQuota'),
        'rejected' => _t('gatewayRejected'),
        'invalid' => _t('gatewayInvalid'),
        'status' => _t('gatewayStatus').replaceAll('{status}', '${statusCode ?? ''}'),
        _ => _t('gatewayInvalid'),
      };

  String unitNote(String unit) => switch (unit) {
        'Pa' => _t('unitPa'),
        'C' => _t('unitC'),
        'u' || 'u²' || 'u³' => _t('unitConsistent'),
        'm' || 'm²' || 'm/s' || 'm/s²' || 'N' || 'N·m' => _t('unitConvertible'),
        _ => _t('unitCatalog'),
      };

  String imperialLine(String equivalent, String value, String unit) =>
      _t('imperialLine').replaceAll('{equivalent}', equivalent).replaceAll('{value}', value).replaceAll('{unit}', unit);

  String get localMode => _t('localMode');
  String get aiMode => _t('aiMode');
  String get history => _t('history');
  String get closeHistory => _t('closeHistory');
  String get clear => _t('clear');
  String get advanced => _t('advanced');
  String get openCatalog => _t('openCatalog');
  String get headline => _t('headline');
  String get intro => _t('intro');
  String get describe => _t('describe');
  String get searchLocal => _t('searchLocal');
  String get continueAi => _t('continueAi');
  String get aiExplain => _t('aiExplain');
  String get cancel => _t('cancel');
  String get solverIntro => _t('solverIntro');
  String get filter => _t('filter');
  String get chooseFormula => _t('chooseFormula');
  String get chooseBody => _t('chooseBody');
  String get confirmCalculate => _t('confirmCalculate');
  String get confirmParameters => _t('confirmParameters');
  String get notationLabel => _t('notationLabel');
  String get reviewPending => _t('reviewPending');
  String get implemented => _t('implemented');
  String get pending => _t('pending');
  String get historyEmpty => _t('historyEmpty');
  String get historyTitle => _t('historyTitle');
  String get deleteAll => _t('deleteAll');
  String get deleteOne => _t('deleteOne');
  String get errorPrefix => _t('errorPrefix');
  String get localFound => _t('localFound');
  String get unknownFormula => _t('unknownFormula');
  String ambiguous(String names) => _t('ambiguous').replaceAll('{names}', names);
  String get proposalReceived => _t('proposalReceived');
  String get proposalTitle => _t('proposalTitle');
  String get proposalBody => _t('proposalBody');
  String get variables => _t('variables');
  String get units => _t('units');
  String get assumptions => _t('assumptions');
  String get missing => _t('missing');
  String get confidence => _t('confidence');
  String get remoteNotResult => _t('remoteNotResult');
  String get domainError => _t('domainError');
  String get fillNumber => _t('fillNumber');
  String get formulaSpoken => _t('formulaSpoken');
  String resultLabel(String value, String unit) => _t('resultLabel').replaceAll('{value}', value).replaceAll('{unit}', unit);
  String get advancedTitle => _t('advancedTitle');
  String get solveLocal => _t('solveLocal');
  String get catalogNote => _t('catalogNote');
  String missingParams(String fields) => _t('missingParams').replaceAll('{fields}', fields);
  String get blockedExecution => _t('blockedExecution');
  String get assistedResult => _t('assistedResult');
  String get localFormulaConfirmed => _t('localFormulaConfirmed');
  String get localExpressionConfirmed => _t('localExpressionConfirmed');
  String limitations(String status, String notes, String version) => status == 'review_pending'
      ? (notes.isEmpty ? _t('pendingLimitations') : notes)
      : _t('catalogLimitations').replaceAll('{version}', version);

  String get notationLine => _t('notationLine');
  String get solverMethod => _t('solverMethod');
  String get languageTooltip => _t('languageTooltip');
  String get localeTag => languageCode == 'pt' ? 'pt-PT' : languageCode;

  String formulaMeta(String status, String version, String unit) => _t('formulaMeta')
      .replaceAll('{status}', status)
      .replaceAll('{version}', version)
      .replaceAll('{unit}', unit);

  String present(String raw, {int? statusCode}) {
    if (raw == 'status') return gateway(raw, statusCode);
    const gatewayCodes = {'unconfigured', 'offline', 'quota', 'rejected', 'invalid'};
    if (gatewayCodes.contains(raw)) return gateway(raw, statusCode);
    if (raw.startsWith('ambiguous:')) {
      final names = raw.substring('ambiguous:'.length).split('|').where((id) => id.isNotEmpty).map((id) {
        final formula = formulaById(id);
        if (formula == null) return id;
        return formulaName(formula.id, formula.name);
      }).join(', ');
      return ambiguous(names);
    }
    if (raw.startsWith('missing:')) return missingParams(raw.substring('missing:'.length));
    switch (raw) {
      case 'empty':
        return _t('describeFirst');
      case 'local_found':
        return localFound;
      case 'not_found':
        return unknownFormula;
      case 'unknown_id':
        return _t('unknownId');
      case 'proposal_received':
        return proposalReceived;
      case 'blocked':
        return blockedExecution;
      case 'local_formula':
        return localFormulaConfirmed;
      case 'local_expression':
        return localExpressionConfirmed;
      case 'assisted':
        return assistedResult;
      case 'Dados fora do domínio da fórmula.':
        return domainError;
      case 'O resultado não é finito.':
        return _t('finiteError');
      case 'Preencha a matriz.':
        return _t('fillMatrix');
    }
    const parameterPrefix = 'Preencha o parâmetro ';
    const numberSuffix = ' com um número válido.';
    if (raw.startsWith(parameterPrefix) && raw.endsWith(numberSuffix)) {
      final name = raw.substring(parameterPrefix.length, raw.length - numberSuffix.length);
      return _t('fillNumber').replaceAll('{name}', name);
    }
    const fillPrefix = 'Preencha ';
    if (raw.startsWith(fillPrefix) && raw.endsWith(numberSuffix)) {
      final name = raw.substring(fillPrefix.length, raw.length - numberSuffix.length);
      return _t('fillNumber').replaceAll('{name}', name);
    }
    if (raw.startsWith(fillPrefix) && raw.endsWith('.')) {
      final name = raw.substring(fillPrefix.length, raw.length - 1);
      return _t('fillLabel').replaceAll('{name}', name);
    }
    final localized = phrase(raw);
    final bare = raw.replaceFirst(RegExp(r'^\d+\.\s*'), '');
    if (localized != bare) return localized;
    return raw;
  }

  String solverTab(String canonical) => _solverTabs[languageCode]?[canonical] ?? _solverTabs['en']![canonical] ?? canonical;
  String solverField(String key, {bool derivative = false}) {
    if (key == 'expression' && derivative) return _t('fieldDerivative');
    return _solverFields[languageCode]?[key] ?? _solverFields['en']![key] ?? key;
  }
}

const _menus = <String, Map<String, String>>{
  'en': {
    'Áreas': 'Areas',
    'Volumes': 'Volumes',
    'Fluidos e fluxos': 'Fluids and flows',
    'Eletricidade': 'Electricity',
    'Física': 'Physics',
    'Estatística': 'Statistics',
    'Equações': 'Equations',
    'Limites e cálculo': 'Limits and calculus',
    'Estruturas e equipamentos': 'Structures and equipment',
    'Field Report': 'Field Report',
  },
  'pt': {
    'Áreas': 'Áreas',
    'Volumes': 'Volumes',
    'Fluidos e fluxos': 'Fluidos e fluxos',
    'Eletricidade': 'Eletricidade',
    'Física': 'Física',
    'Estatística': 'Estatística',
    'Equações': 'Equações',
    'Limites e cálculo': 'Limites e cálculo',
    'Estruturas e equipamentos': 'Estruturas e equipamentos',
    'Field Report': 'Relatório de campo',
  },
  'fr': {
    'Áreas': 'Aires',
    'Volumes': 'Volumes',
    'Fluidos e fluxos': 'Fluides et écoulements',
    'Eletricidade': 'Électricité',
    'Física': 'Physique',
    'Estatística': 'Statistique',
    'Equações': 'Équations',
    'Limites e cálculo': 'Limites et calcul',
    'Estruturas e equipamentos': 'Structures et équipements',
    'Field Report': 'Rapport de terrain',
  },
  'es': {
    'Áreas': 'Áreas',
    'Volumes': 'Volúmenes',
    'Fluidos e fluxos': 'Fluidos y flujos',
    'Eletricidade': 'Electricidad',
    'Física': 'Física',
    'Estatística': 'Estadística',
    'Equações': 'Ecuaciones',
    'Limites e cálculo': 'Límites y cálculo',
    'Estruturas e equipamentos': 'Estructuras y equipos',
    'Field Report': 'Informe de campo',
  },
  'de': {
    'Áreas': 'Flächen',
    'Volumes': 'Volumen',
    'Fluidos e fluxos': 'Fluide und Strömung',
    'Eletricidade': 'Elektrizität',
    'Física': 'Physik',
    'Estatística': 'Statistik',
    'Equações': 'Gleichungen',
    'Limites e cálculo': 'Grenzwerte und Analysis',
    'Estruturas e equipamentos': 'Tragwerke und Anlagen',
    'Field Report': 'Feldbericht',
  },
};

const _solverTabs = <String, Map<String, String>>{
  'en': {
    'Descrever': 'Describe',
    'Média ponderada': 'Weighted mean',
    'Pearson': 'Pearson',
    'Regressão': 'Regression',
    'Percentil': 'Percentile',
    'Binomial': 'Binomial',
    'Polinómio': 'Polynomial',
    'Sistema': 'System',
    'Bisseção': 'Bisection',
    'Newton': 'Newton',
    'Integral': 'Integral',
    'Limite': 'Limit',
    'Derivada': 'Derivative',
    'EDO': 'ODE',
    'EDO 2.ª ordem': 'Second-order ODE',
  },
  'pt': {
    'Descrever': 'Descrever',
    'Média ponderada': 'Média ponderada',
    'Pearson': 'Pearson',
    'Regressão': 'Regressão',
    'Percentil': 'Percentil',
    'Binomial': 'Binomial',
    'Polinómio': 'Polinómio',
    'Sistema': 'Sistema',
    'Bisseção': 'Bisseção',
    'Newton': 'Newton',
    'Integral': 'Integral',
    'Limite': 'Limite',
    'Derivada': 'Derivada',
    'EDO': 'EDO',
    'EDO 2.ª ordem': 'EDO 2.ª ordem',
  },
  'fr': {
    'Descrever': 'Décrire',
    'Média ponderada': 'Moyenne pondérée',
    'Pearson': 'Pearson',
    'Regressão': 'Régression',
    'Percentil': 'Percentile',
    'Binomial': 'Binomiale',
    'Polinómio': 'Polynôme',
    'Sistema': 'Système',
    'Bisseção': 'Dichotomie',
    'Newton': 'Newton',
    'Integral': 'Intégrale',
    'Limite': 'Limite',
    'Derivada': 'Dérivée',
    'EDO': 'EDO',
    'EDO 2.ª ordem': 'EDO du 2e ordre',
  },
  'es': {
    'Descrever': 'Describir',
    'Média ponderada': 'Media ponderada',
    'Pearson': 'Pearson',
    'Regressão': 'Regresión',
    'Percentil': 'Percentil',
    'Binomial': 'Binomial',
    'Polinómio': 'Polinomio',
    'Sistema': 'Sistema',
    'Bisseção': 'Bisección',
    'Newton': 'Newton',
    'Integral': 'Integral',
    'Limite': 'Límite',
    'Derivada': 'Derivada',
    'EDO': 'EDO',
    'EDO 2.ª ordem': 'EDO de 2.º orden',
  },
  'de': {
    'Descrever': 'Beschreiben',
    'Média ponderada': 'Gewichtetes Mittel',
    'Pearson': 'Pearson',
    'Regressão': 'Regression',
    'Percentil': 'Perzentil',
    'Binomial': 'Binomial',
    'Polinómio': 'Polynom',
    'Sistema': 'System',
    'Bisseção': 'Bisektion',
    'Newton': 'Newton',
    'Integral': 'Integral',
    'Limite': 'Grenzwert',
    'Derivada': 'Ableitung',
    'EDO': 'DGL',
    'EDO 2.ª ordem': 'DGL 2. Ordnung',
  },
};

const _solverFields = <String, Map<String, String>>{
  'en': {
    'values': 'Values',
    'weights': 'Weights',
    'xs': 'x',
    'ys': 'y',
    'p': 'Percentile p',
    'n': 'n',
    'k': 'k',
    'sample': 'Sample (1 = yes)',
    'coefficients': 'Coefficients a0, a1, …',
    'matrix': 'Matrix, rows separated by ;',
    'vector': 'Vector b',
    'expression': 'Expression in x',
    'lower': 'Lower limit',
    'upper': 'Upper limit',
    'intervals': 'Even intervals',
    'point': 'Point x',
    'initial': 'Initial value',
    'x0': 'Initial x',
    'y0': 'Initial y',
    'dy0': 'Initial dy/dx',
    'x1': 'Final x',
    'steps': 'Steps',
  },
  'pt': {
    'values': 'Valores',
    'weights': 'Pesos',
    'xs': 'x',
    'ys': 'y',
    'p': 'Percentil p',
    'n': 'n',
    'k': 'k',
    'sample': 'Amostra (1 = sim)',
    'coefficients': 'Coeficientes a₀, a₁, …',
    'matrix': 'Matriz, linhas separadas por ;',
    'vector': 'Vetor b',
    'expression': 'Expressão em x',
    'lower': 'Limite inferior',
    'upper': 'Limite superior',
    'intervals': 'Intervalos pares',
    'point': 'Ponto x',
    'initial': 'Valor inicial',
    'x0': 'x inicial',
    'y0': 'y inicial',
    'dy0': 'dy/dx inicial',
    'x1': 'x final',
    'steps': 'Passos',
  },
  'fr': {
    'values': 'Valeurs',
    'weights': 'Poids',
    'xs': 'x',
    'ys': 'y',
    'p': 'Percentile p',
    'n': 'n',
    'k': 'k',
    'sample': 'Échantillon (1 = oui)',
    'coefficients': 'Coefficients a0, a1, …',
    'matrix': 'Matrice, lignes séparées par ;',
    'vector': 'Vecteur b',
    'expression': 'Expression en x',
    'lower': 'Borne inférieure',
    'upper': 'Borne supérieure',
    'intervals': 'Intervalles pairs',
    'point': 'Point x',
    'initial': 'Valeur initiale',
    'x0': 'x initial',
    'y0': 'y initial',
    'dy0': 'dy/dx initial',
    'x1': 'x final',
    'steps': 'Pas',
  },
  'es': {
    'values': 'Valores',
    'weights': 'Pesos',
    'xs': 'x',
    'ys': 'y',
    'p': 'Percentil p',
    'n': 'n',
    'k': 'k',
    'sample': 'Muestra (1 = sí)',
    'coefficients': 'Coeficientes a0, a1, …',
    'matrix': 'Matriz, filas separadas por ;',
    'vector': 'Vector b',
    'expression': 'Expresión en x',
    'lower': 'Límite inferior',
    'upper': 'Límite superior',
    'intervals': 'Intervalos pares',
    'point': 'Punto x',
    'initial': 'Valor inicial',
    'x0': 'x inicial',
    'y0': 'y inicial',
    'dy0': 'dy/dx inicial',
    'x1': 'x final',
    'steps': 'Pasos',
  },
  'de': {
    'values': 'Werte',
    'weights': 'Gewichte',
    'xs': 'x',
    'ys': 'y',
    'p': 'Perzentil p',
    'n': 'n',
    'k': 'k',
    'sample': 'Stichprobe (1 = ja)',
    'coefficients': 'Koeffizienten a0, a1, …',
    'matrix': 'Matrix, Zeilen getrennt durch ;',
    'vector': 'Vektor b',
    'expression': 'Ausdruck in x',
    'lower': 'Untere Grenze',
    'upper': 'Obere Grenze',
    'intervals': 'Gerade Intervalle',
    'point': 'Punkt x',
    'initial': 'Startwert',
    'x0': 'Anfang x',
    'y0': 'Anfang y',
    'dy0': 'Anfang dy/dx',
    'x1': 'Ende x',
    'steps': 'Schritte',
  },
};
