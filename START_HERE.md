# Vision Field Calc — começar aqui

Este pacote contém os ficheiros necessários para continuar a implementação da aplicação noutro chat ou estação de desenvolvimento.

## Ordem de leitura

1. `PRD_e_Arquitetura/06_Vision_Field_Calc_PRD_v2.0.docx`
2. `UX_UI/GUIA_UI_ELEVENLABS_REFERENCE.md`
3. `implementation/README.md`
4. `implementation/catalog/formulas_v2.json`
5. `implementation/flutter/vision_field_calc/lib/main.dart`
6. `implementation/vision_field_calc/engine.py` e `solvers.py`
7. PRDs do Core e Vision Cloud Services, antes de integrar serviços comuns ou IA.

## Estado recebido

- Catálogo versionado com 129 fórmulas em 10 menus.
- 15 solucionadores especiais para estatística, equações, limites, derivadas, integrais e equações diferenciais.
- Motor Python local executável e 10 testes aprovados em 28 de setembro de 2026.
- Fonte Flutter com menus, parâmetros, passos matemáticos e encaminhamento local-first.
- Tema Flutter inicial inspirado no sistema visual atual da ElevenLabs, em `lib/vision_theme.dart`.
- Símbolos apresentados no ecrã: ∫, ∑, π, σ, μ, Δ, θ, λ, ρ, ω, x, y e dy/dx.
- Cliente para `Vision AI Gateway` preparado em `lib/ai_gateway.dart`.

## Regra funcional obrigatória

1. Procurar e calcular localmente primeiro.
2. Usar IA apenas quando o motor local não resolver ou não interpretar o pedido.
3. A IA propõe fórmula, variáveis, unidades, hipóteses e passos.
4. O utilizador confirma ou corrige a proposta.
5. Sempre que possível, o cálculo final volta a ser executado pelo motor determinístico local.
6. Mostrar todos os passos e a notação matemática no ecrã.

## Primeiro trabalho na nova estação

1. Confirmar Flutter/Dart e criar as pastas de plataforma que ainda não existem.
2. Executar `flutter pub get`, `flutter analyze` e os testes Flutter.
3. Aplicar integralmente o guia `UX_UI/GUIA_UI_ELEVENLABS_REFERENCE.md` e criar os componentes reutilizáveis ali definidos.
4. Criar testes Dart para o catálogo completo e comparar resultados com `example_results.json`.
5. Corrigir qualquer erro de compilação antes de ampliar funcionalidades.
6. Configurar o endereço do gateway apenas através de `VISION_AI_GATEWAY_URL`.
7. Manter credenciais de fornecedores de IA fora da app; o cliente fala apenas com Vision Cloud Services.
8. Tratar entradas `review_pending` como funcionais mas dependentes de validação técnica, norma, edição e fatores de projeto.

## Limitação conhecida

O executável Dart/Flutter foi bloqueado pela política de controlo de aplicações da estação Windows de origem. O código Flutter ainda precisa de compilação e testes numa estação autorizada. O motor Python e o catálogo foram testados.

## Comandos de referência

Na pasta `implementation`:

```text
python -m unittest discover -s tests -v
python -m vision_field_calc.cli calculate AREA_CIRCLE_RADIUS "{"r": 2}"
python -m vision_field_calc.cli integral "sin(x)" x 0 3.141592653589793
```
