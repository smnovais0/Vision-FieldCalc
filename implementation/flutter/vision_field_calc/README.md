# Vision Field Calc

Interface Flutter da Vision Field Calc (catálogo 2.0.0, motor 0.3.0). O cálculo é local. A IA só entra quando o catálogo não tem fórmula, e só depois de o utilizador confirmar a proposta.

## Executar

```text
flutter pub get
flutter analyze
flutter test
flutter run
```

O endpoint do gateway, quando existir uma instalação autorizada, entra só por compilação:

```text
flutter run --dart-define=VISION_AI_GATEWAY_URL=https://<gateway-autorizado>
```

A aplicação não inclui chaves de fornecedores de IA. Cálculos `review_pending` continuam visíveis com o aviso de que o resultado não certifica conformidade.

O tipo editorial usa Inter (OFL). A notação matemática usa Noto Sans Math (OFL). Waldenburg não está incluída.
