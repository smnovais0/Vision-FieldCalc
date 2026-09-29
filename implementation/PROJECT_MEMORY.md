# Vision Field Calc — memória do projeto

Pessoa: Sérgio, Operations. Fala em português. Prefere trabalhar no código.

Repositório: smnovais0/Vision-FieldCalc
Ramo: cursor/vision-field-calc-app-0c94
PR rascunho: https://github.com/smnovais0/Vision-FieldCalc/pull/1 (base main)
Último commit de correções de auditoria: 8b27477

Produto: calculadora técnica local-first. Organização com.visionworldapps. Catálogo 2.0.0, motor 0.3.0, 129 fórmulas, 10 menus, 99 implemented e 30 review_pending. Menus só com solucionadores (sem fórmulas de catálogo): Estatística, Equações, Limites e cálculo.
Código: implementation/flutter/vision_field_calc (UI) e implementation/vision_field_calc (motor Python de referência).

## O que já está feito

- Fases 0, 1 e 2 estão no código. A versão inicial é web (`flutter run -d web-server` ou `flutter build web` dentro de implementation/flutter/vision_field_calc).
- Inglês por defeito. Seletor: Português, Français, Español, Deutsch. Árabe, mandarim e indonésio (ar, zh, id) estão reservados e não aparecem no seletor.
- Os identificadores e os menus canónicos do catálogo continuam em português. A pesquisa usa o nome do catálogo, o id e os nomes traduzidos. O mapa de frases pt está vazio de propósito, para o português mostrar o texto original. Os títulos dos passos do motor (incluindo Substituir) ficam em português no código e só se traduzem no ecrã.
- Flutter procura primeiro no catálogo. Correspondência única é local. Empate (por exemplo «circulo») pede confirmação por IA e não escolhe sozinho. «circulo pelo raio» continua a ser AREA_CIRCLE_RADIUS.
- O router Python route_natural_language devolve sempre IA. Não mudar o Flutter para copiar esse comportamento.
- Gateway: só VISION_AI_GATEWAY_URL por dart-define. POST {url}/v1/calc/interpret. Sem chaves de fornecedor no cliente. Sem cabeçalho Authorization. HTTPS obrigatório, exceto localhost e 127.0.0.1. Timeout 20s. Códigos: unconfigured, offline, quota, rejected, status, invalid, insecure. Credenciais rejeitadas em proposal_guard (api_key, sk-, bearer, password, token, secret). Um número remoto não é resultado. Confirmar recalcula no dispositivo.
- review_pending continua visível e tem de dizer que não certifica conformidade, em todas as línguas entregues.
- Histórico só na sessão, com sha256, mostrado no ecrã. Não há ficheiro nem descarga.
- O catálogo JSON não é asset de runtime. Vai compilado em lib/generated/formula_engine.g.dart.
- Expressão local: comprimento ≤ 2000 e profundidade ≤ 64, alinhado com o Python. Bloqueia __import__, import, eval, subprocess, Process. e open(.
- Última verificação conhecida: flutter analyze limpo, flutter test 21, Python 10/10, tools/verify_field_calc_v2.py passou.
- Scripts já apontados para implementation/: tools/build_field_calc_flutter.py e tools/verify_field_calc_v2.py.
- Scripts que AINDA apontam para outputs/VisionWorldApps/...: tools/generate_field_calc_examples.py e tools/build_field_calc_v2_catalog.py. Não são a aplicação web.
- Aikido pediu sessão. AIKIDO_API_KEY não está definido. O scan não correu.

## O que o utilizador já decidiu

- Lojas da fase 4: só Google Play e App Store (iOS). Sem Microsoft Store.
- Versões posteriores da aplicação, pedidas antes dessa decisão de lojas: Android, iOS, desktop Windows e desktop macOS. A inicial é web. Não afirmar que esses builds existem.
- Apple continua Pending Hardware. Sem Mac ou dispositivo não há release iOS.
- Sérgio tem conta AWS e diz que já tem o endereço HTTPS do Vision AI Gateway, mas ainda não o enviou. Não inventar o URL. Não pedir chaves AWS, password da consola, nem a chave do fornecedor de IA. Se a API exigir API key, ele diz só que exige. A app hoje não envia Authorization.
- Quem revê fórmulas review_pending é uma pessoa autorizada pela Vision (Sérgio, se tiver essa autoridade, ou um engenheiro). O agente regista o parecer. Não inventa aprovação e não certifica.
- Não pedir PDFs pagos nem o texto integral de normas. Só nome, edição e nota curta do revisor, se houver licença para citar. Sem autorização escrita para embutir texto, a fórmula fica pendente.

## Fase 3 — não começada

Validação normativa e catálogo assinado. Para avançar, por fórmula: id, norma e edição, decisão (manter pendente ou passar a implementada), quem aprovou e a data. Não colar a chave privada do catálogo.

## Fase 4 — não começada

Publicação. Só quando Sérgio disser para avançar. Google Play: conta Play Console e keystore, sem enviar passwords nem o ficheiro. iOS: conta Apple Developer e um Mac ou dispositivo. Política de privacidade e URL de suporte ainda não foram dados.

## O que não fazer

- Não tratar a ausência das fases 3 e 4 como bug.
- Não fundir os motores Python e Dart nesta fase.
- Não pôr chaves no código.
- Não dizer que um cálculo review_pending certifica conformidade.
