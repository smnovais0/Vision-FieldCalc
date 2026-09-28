/// Eventos locais com esquema fechado. Não guarda valores, pedidos nem credenciais.
class PrivacyAnalytics {
  static final events = <AnalyticsEvent>[];

  static const names = {
    'formula_opened',
    'calculation_completed',
    'validation_failed',
    'solver_completed',
    'ai_parse_result',
  };

  static const fields = {
    'formula_id',
    'formula_version',
    'engine_version',
    'menu',
    'outcome',
    'code',
    'method',
    'mode',
    'status',
  };

  static void record(String name, Map<String, String> payload) {
    if (!names.contains(name)) {
      throw ArgumentError('Evento de analytics não permitido.');
    }
    for (final entry in payload.entries) {
      if (!fields.contains(entry.key) || entry.value.length > 80) {
        throw ArgumentError('Campo de analytics não permitido.');
      }
    }
    events.add(AnalyticsEvent(name, Map<String, String>.unmodifiable(payload)));
  }

  static void clear() => events.clear();
}

class AnalyticsEvent {
  final String name;
  final Map<String, String> fields;
  const AnalyticsEvent(this.name, this.fields);
}
