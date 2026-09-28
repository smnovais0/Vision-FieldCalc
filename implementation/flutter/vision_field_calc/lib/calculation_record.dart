import 'dart:convert';

import 'package:crypto/crypto.dart';

Map<String, Object?> calculationRecord({
  required String formulaId,
  required String formulaVersion,
  required String engineVersion,
  required String status,
  required Map<String, double> inputs,
  required double result,
  required String unit,
  required String limitations,
  required DateTime confirmedAt,
}) {
  final body = <String, Object?>{
    'formula_id': formulaId,
    'formula_version': formulaVersion,
    'engine_version': engineVersion,
    'status': status,
    'inputs': inputs,
    'result': result,
    'unit': unit,
    'limitations': limitations,
    'confirmed_at': confirmedAt.toUtc().toIso8601String(),
  };
  final encoded = jsonEncode(body);
  return {
    ...body,
    'sha256': sha256.convert(utf8.encode(encoded)).toString(),
  };
}
