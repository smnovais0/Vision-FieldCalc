# Vision Field Calc

Interface Flutter da Vision Field Calc (catálogo 2.0.0, motor 0.3.0). O cálculo é local. A IA só entra quando o catálogo não tem fórmula, e só depois de o utilizador confirmar a proposta.

## Versão inicial: web

A primeira versão é a aplicação web. Android, iOS, Windows e macOS ficam para a versão seguinte; esta entrega não inclui esses builds. Apple continua pendente de hardware.

```text
flutter pub get
flutter analyze
flutter test
flutter run -d web-server
flutter build web
```

O ecrã abre em inglês. O seletor muda para português, francês, espanhol e alemão. Árabe, mandarim e indonésio ficam reservados e não aparecem no seletor. O catálogo interno continua em português; a pesquisa usa os nomes do catálogo e os nomes traduzidos.

O JSON do catálogo é compilado para `lib/generated/formula_engine.g.dart`. Não é um asset de runtime. O histórico existe apenas em memória durante a sessão: o registo inclui um sha256 e aparece no ecrã, sem descarga de ficheiro. Em Python, `CalculationRouter.route_natural_language` devolve sempre confirmação de IA. Esta aplicação continua a procurar primeiro no catálogo local.

O endpoint do gateway, quando existir uma instalação autorizada, entra só por compilação:

```text
flutter run -d web-server --dart-define=VISION_AI_GATEWAY_URL=https://<gateway-autorizado>
```

A aplicação não inclui chaves de fornecedores de IA. Cálculos `review_pending` continuam visíveis com o aviso de que o resultado não certifica conformidade, em qualquer língua disponível.

O tipo editorial usa Inter (OFL). A notação matemática usa Noto Sans Math (OFL). Waldenburg não está incluída.
