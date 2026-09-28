/// Conversões de apresentação. O valor calculado permanece na unidade do catálogo.
class UnitPolicy {
  static const footPerMetre = 3.280839895013123;
  static const usGallonLitres = 3.785411784;
  static const imperialGallonLitres = 4.54609;

  static String? imperialEquivalent(double value, String unit) {
    final converted = switch (unit) {
      'm' => (value * footPerMetre, 'ft'),
      'm²' => (value * footPerMetre * footPerMetre, 'ft²'),
      'm/s' => (value * footPerMetre, 'ft/s'),
      'm/s²' => (value * footPerMetre, 'ft/s²'),
      'Pa' => (value / 6894.757293168, 'lbf/in²'),
      'N' => (value / 4.4482216152605, 'lbf'),
      'N·m' => (value / 1.3558179483314004, 'lbf·ft'),
      _ => null,
    };
    if (converted == null) return null;
    return '${_format(converted.$1)} ${converted.$2}';
  }

  static String note(String unit) => switch (unit) {
        'Pa' => 'Pascal do catálogo. O equivalente imperial é só apresentação e não distingue pressão manométrica de absoluta.',
        'C' => 'Coulomb. Esta unidade não é temperatura.',
        'u' || 'u²' || 'u³' => 'Unidade coerente introduzida pelo utilizador. Não há conversão imperial.',
        'm' || 'm²' || 'm/s' || 'm/s²' || 'N' || 'N·m' => 'O número do cálculo permanece nesta unidade. O equivalente imperial é só apresentação.',
        _ => 'Unidade do catálogo, usada tal como foi calculada.',
      };

  static double litresFromUsGallon(double gallons) => gallons * usGallonLitres;

  static double litresFromImperialGallon(double gallons) => gallons * imperialGallonLitres;

  static double fahrenheitFromCelsius(double celsius) => celsius * 9 / 5 + 32;

  static double fahrenheitDifferenceFromCelsius(double difference) => difference * 9 / 5;

  static String _format(double value) {
    final absolute = value.abs();
    if (absolute != 0 && (absolute >= 100000 || absolute < 0.001)) return value.toStringAsExponential(6);
    return value.toStringAsFixed(6);
  }
}
