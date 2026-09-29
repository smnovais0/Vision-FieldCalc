# Vision World Apps — índice documental v1.2

Revisão de calendário e do Vision Field Calc: 28 de setembro de 2026. Língua: português de Portugal.

## Prazo e âmbito vigentes

**27 de setembro a 10 de novembro de 2026, 45 dias numa contagem inclusiva.** A aplicação comercial do primeiro lote é Vision Field Report. A entrega inclui o Core necessário, Vision Cloud Services, VisionWorldApps.com e a integração necessária com o Backoffice existente.

PhotoProof e Field Calc conservam os seus requisitos e fases. As datas comerciais anteriormente propostas foram retiradas; a calendarização do lote próprio depende de aprovação. Este pacote não apresenta essas apps como prontas para o mercado em 10 de novembro.

## Documentos atuais

| Documento | Versão | Páginas | Ficheiro |
|---|---|---:|---|
| Compliance Pack — lojas, legal e privacidade | 1.1 | 19 | [00_Vision_World_Apps_Store_Legal_Privacy_Compliance_Pack_v1.1.docx](00_Governance_Compliance/00_Vision_World_Apps_Store_Legal_Privacy_Compliance_Pack_v1.1.docx) |
| Vision Cloud Services — PRD | 1.1 | 16 | [01_Vision_Cloud_Services_PRD_v1.1.docx](01_Vision_Cloud_Services/01_Vision_Cloud_Services_PRD_v1.1.docx) |
| Vision Cloud Services — System Architecture | 1.1 | 16 | [01_Vision_Cloud_Services_System_Architecture_v1.1.docx](01_Vision_Cloud_Services/01_Vision_Cloud_Services_System_Architecture_v1.1.docx) |
| Vision Field Tools Core — PRD | 1.1 | 15 | [02_Vision_Field_Tools_Core_PRD_v1.1.docx](02_Vision_Field_Tools_Core/02_Vision_Field_Tools_Core_PRD_v1.1.docx) |
| Vision Field Report — PRD | 1.1 | 17 | [03_Vision_Field_Report_PRD_v1.1.docx](03_Vision_Field_Report/03_Vision_Field_Report_PRD_v1.1.docx) |
| Vision World Apps Website — PRD | 1.1 | 14 | [04_Vision_World_Apps_Website_PRD_v1.1.docx](04_Vision_World_Apps_Website/04_Vision_World_Apps_Website_PRD_v1.1.docx) |
| Vision Field PhotoProof — PRD | 1.1 | 15 | [05_Vision_Field_PhotoProof_PRD_v1.1.docx](05_Vision_Field_PhotoProof/05_Vision_Field_PhotoProof_PRD_v1.1.docx) |
| Vision Field Calc — PRD | 2.0 | 13 | [06_Vision_Field_Calc_PRD_v2.0.docx](06_Vision_Field_Calc/06_Vision_Field_Calc_PRD_v2.0.docx) |
| Backoffice existente — Gap Analysis e atualização do PRD | 1.1 | 18 | [07_Vision_World_Apps_Backoffice_Gap_Analysis_and_PRD_Update_v1.1.docx](07_Backoffice/07_Vision_World_Apps_Backoffice_Gap_Analysis_and_PRD_Update_v1.1.docx) |
| Calendário do primeiro lote de 45 dias | 1.0 | 12 | [08_Vision_World_Apps_Calendario_Primeiro_Lote_45_Dias_v1.0.docx](13_Release_Management/08_Vision_World_Apps_Calendario_Primeiro_Lote_45_Dias_v1.0.docx) |

Total: 10 Word atuais, 155 páginas na pré-visualização verificada. A paginação pode variar ligeiramente com a versão do Word e as fontes locais.

## Marcos principais

| Data de 2026 | Marco |
|---|---|
| 30 setembro | Catálogo completo de inspeções, arquitetura, capacidade e início/verificação das contas |
| 7 outubro | Base local, API e identidade; contas, banco, fiscalidade, acordos e recrutamento de testers |
| 14 outubro | Beta Android utilizável e preparação administrativa para a track fechada |
| 15–29 outubro | Teste fechado Google, quando aplicável, com opt-in contínuo e feedback real |
| 21 outubro | Normas, exportação, sincronização, suporte e analytics; revisão legal |
| 29 outubro | Candidato completo Windows/Android; pedido de acesso à produção se elegível e pronto |
| 30–31 outubro | Reserva de correções; marco próprio do Backoffice; configuração do Mac se recebido |
| 1–5 novembro | Build, testes físicos, assinatura e dossiê Apple |
| 6–10 novembro | Auditoria final e submissões elegíveis após aprovação por plataforma |
| 10 novembro | Gate de prontidão do primeiro lote para deployment e submissão |


## Vision Field Calc — implementação disponível

- Motor determinístico local com 129 fórmulas, distribuídas por 10 menus.
- 15 solucionadores para estatística, equações, limites, derivadas, integrais e equações diferenciais.
- Interface Flutter com seleção por menu, pesquisa local, parâmetros, resultado e resolução passo a passo.
- Notação visual no ecrã para ∫, ∑, π, σ, μ, Δ, θ, λ, ρ, ω, x, y e dy/dx.
- Encaminhamento local-first: a IA apenas interpreta pedidos sem solução local; fórmula, unidades, variáveis e hipóteses exigem confirmação antes do cálculo.
- Resultado de verificação: 10 testes aprovados, 129/129 fórmulas executadas e 129/129 casos gerados para Flutter.
- Limitação atual: a política Windows bloqueou o executável Dart/Flutter nesta estação; o build da interface permanece por executar numa estação autorizada.

Artefactos: [README](06_Vision_Field_Calc/implementation/README.md), [catálogo](06_Vision_Field_Calc/implementation/catalog/formulas_v2.json), [resultados de exemplo](06_Vision_Field_Calc/implementation/example_results.json) e [relatório de verificação](06_Vision_Field_Calc/implementation/verification_report.json).

## Estado e dependências

- Os documentos definem trabalho a executar. Não confirmam implementação, aprovação de fase, inscrição nas lojas, execução de testes das apps ou submissão.
- O catálogo nominal histórico de TODOS os tipos de inspeção ainda não foi recuperado. O requisito FR 000 deve ser reconciliado até 30 de setembro e bloqueia o gate R0 enquanto estiver pendente.
- Apple mantém Pending Hardware até testes reais. A chegada do Mac no fim de outubro e a disponibilidade dos dispositivos são dependências explícitas.
- A regra Google aplicável às novas contas pessoais exige pelo menos 12 testers durante 14 dias contínuos; a aprovação de acesso à produção e a revisão da app são decisões externas. Confirmar elegibilidade na consola.
- A capacidade deve ser reconciliada com o trabalho do Backoffice já em curso. A meta de 10 de novembro não constitui uma estimativa de esforço validada.
- A inspeção do Backoffice foi feita em modo de leitura. O projeto existente não foi recomeçado, movido ou alterado por este pacote.

## Localização e preservação

Os ficheiros estão guardados em `C:\Users\smnov\Documents\Codex\2026-09-27\referenced-chatgpt-conversation-this-is-an\outputs\VisionWorldApps`. A estrutura contém as 16 pastas pedidas.

O destino pedido `C:\VISION\VisionWorldApps` ainda não foi criado: esta sessão não recebeu a permissão de escrita necessária. Não se afirma que os documentos estejam nesse destino.

As nove versões v1.0 e o pacote anterior foram preservados e verificados por SHA-256. Para execução, usar as revisões v1.1, o Vision Field Calc v2.0 e o calendário 08 deste índice. O ZIP v1.1 contém apenas os dez Word atuais, este índice, o manifesto de integridade e as 16 pastas; não inclui pré-visualizações internas.

## Verificação documental

Confirmada a coerência das datas, a contagem dos 45 dias, a integridade dos ficheiros Word e a paginação. Todas as páginas foram inspecionadas visualmente, incluindo a correção de um parágrafo final isolado no PhotoProof. Esta verificação refere-se aos documentos, não a testes de software das apps.

As fontes oficiais e as regras administrativas aplicáveis estão identificadas no Compliance Pack e no calendário. Devem ser reconfirmadas nas plataformas nos gates previstos.
