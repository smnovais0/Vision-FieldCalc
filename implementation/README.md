# Vision Field Calc — implementação de referência v2.0

Esta pasta contém um motor de cálculo local, determinístico e sem dependências de rede. O catálogo inclui 129 fórmulas versionadas em 10 menus e 15 solucionadores especiais para estatística, equações, limites, derivadas, integrais e equações diferenciais.

## Política de cálculo

1. A aplicação procura primeiro uma fórmula ou solucionador local.
2. O utilizador confirma parâmetros, unidades e hipóteses.
3. O motor local calcula e mostra a fórmula, a substituição e o resultado passo a passo.
4. A IA só é chamada para interpretar linguagem natural ou um problema ainda não suportado.
5. Uma proposta da IA não substitui a confirmação do utilizador nem a verificação local.

Os cálculos marcados `review_pending` já produzem resultados, mas continuam a exigir validação técnica, escolha explícita da norma/edição e confirmação dos fatores aplicáveis antes de uma decisão de engenharia real.

## Executar a referência Python

```text
python -m vision_field_calc.cli menus
python -m vision_field_calc.cli calculate AREA_CIRCLE_RADIUS "{\"r\": 2}"
python -m vision_field_calc.cli integral "sin(x)" x 0 3.141592653589793
python -m unittest discover -s tests -v
```

## Interface Flutter

A pasta `flutter/vision_field_calc` contém a interface cross-platform. O catálogo JSON é um asset da aplicação. A interface procura primeiro no catálogo local e só apresenta o envio para IA quando não encontra uma solução. A chamada usa exclusivamente o endpoint intermédio `VISION_AI_GATEWAY_URL`; a app não contém credenciais de fornecedores de IA nem acede diretamente a esses serviços.

O Vision AI Gateway recebe um pedido de interpretação e devolve fórmula, variáveis, unidades, hipóteses e passos. O utilizador tem de confirmar a proposta antes de o motor local calcular. Configuração prevista para o build autorizado:

```text
cd flutter/vision_field_calc
flutter pub get
flutter analyze
flutter test
flutter run --dart-define=VISION_AI_GATEWAY_URL=https://<gateway-autorizado>
```

Sem esse `dart-define`, o cliente recusa a chamada e mostra que o Vision AI Gateway ainda não está configurado. Um resultado `review_pending` não certifica conformidade: a interface mantém o aviso de revisão pendente depois do cálculo.
