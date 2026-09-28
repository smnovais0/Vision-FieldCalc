# Vision Field Calc — guia obrigatório de UI

Referência visual pedida: site público atual da ElevenLabs, observado em 28 de setembro de 2026 em `https://elevenlabs.io/`, nos formatos desktop 1280 × 720 e móvel 390 × 844.

## Regra de execução

A interface da Vision Field Calc deve reproduzir com grande fidelidade o sistema visual, a composição, a densidade, os raios, a hierarquia, a tipografia, os botões, os cartões e o comportamento responsivo observados na referência. Todo o conteúdo, marca, ícones próprios, textos e imagens continuam a ser Vision World Apps. Não copiar o logótipo, textos comerciais, imagens, ilustrações ou outros ativos da ElevenLabs.

## Tokens visuais medidos

| Token | Valor de referência | Aplicação na app |
|---|---:|---|
| Fundo principal | `#FDFCFC` | Scaffold, páginas e app bar |
| Painel creme | `#F5F3F1` | Área de cálculo, catálogo e grupos de controlos |
| Superfície | `#FFFFFF` | Campos, opção ativa, botões secundários e cartões interiores |
| Texto principal | `#000000` | Títulos, valores, fórmulas e ações principais |
| Texto secundário | `#5F5F5F` | Ajuda, unidades, descrições e metadados |
| Contorno subtil | preto a 7,5% (`#13000000`) | Limites de cartões, campos e separadores |
| Raio de painel | `24 px` | Painéis principais e área de trabalho |
| Raio de controlos | `14 px` | Campos, tabs ativas e caixas interiores |
| Raio de botão | `9999 px` | Botões em cápsula |
| Conteúdo desktop | aproximadamente `1137 px` num viewport de `1280 px` | Margens laterais próximas de `64 px` |
| Padding de painel | `32 px` desktop; `20 px` móvel | Interior dos painéis principais |
| Gap de grelha | `64 px` desktop | Colunas principais |

## Tipografia

- Texto, menus, controlos e botões: **Inter**.
- Título editorial de grande dimensão da referência: **Waldenburg**, 48 px, peso 300, altura de linha 52 px, letter-spacing -0,96 px.
- A fonte Waldenburg só pode ser incluída se existir licença válida. Até essa licença existir, usar Inter com peso 300 e as mesmas métricas; não extrair a fonte do site.
- Fórmulas e passos matemáticos: **STIX Two Math** ou **Noto Sans Math**, para garantir ∫, ∑, π, σ, μ, Δ, θ, λ, ρ, ω, x, y e dy/dx.
- Corpo de destaque: 18 px, 28,8 px de altura de linha.
- Corpo normal: 16 px, 24 px de altura de linha.
- Navegação e botões: 14 px, 21 px de altura de linha.
- Títulos de secção da aplicação: 28–32 px, peso 400, espaçamento ligeiramente negativo.

## Escala de espaçamento

Usar apenas a escala `4, 8, 12, 16, 20, 24, 32, 48, 64, 96, 120` px. O espaço em branco é parte central do estilo. Evitar ecrãs densos, linhas de contorno pesadas e cartões encaixados sem respiração.

## Estrutura desktop

1. Barra superior baixa para estado do motor: “Cálculo local” ou “Interpretação por IA”, com ação curta à direita.
2. Cabeçalho limpo, fundo `#FDFCFC`, marca Vision Field Calc à esquerda e ações utilitárias à direita.
3. Área introdutória em duas colunas: título/ação à esquerda, explicação curta à direita.
4. Painel principal creme com raio de 24 px e contorno interior de 0,5 px.
5. Primeira linha do painel: tabs horizontais para Áreas, Volumes, Fluidos, Eletricidade, Física, Estatística, Equações, Cálculo, Estruturas e Field Report.
6. Corpo do painel em duas colunas: catálogo e pesquisa à esquerda; fórmula, parâmetros e passos à direita.
7. Largura máxima entre 1120 e 1140 px, centrada, com margens laterais de 64 px quando houver espaço.

## Estrutura móvel

- Cabeçalho compacto com marca, uma ação principal preta e menu hambúrguer.
- Título e explicação em coluna única.
- Margem lateral de 20 px.
- Tabs dentro do painel, horizontalmente deslocáveis; opção ativa em branco com sombra muito suave.
- Catálogo abre como folha inferior ou painel recolhível.
- Campos e botões ocupam a largura disponível.
- Passos matemáticos aparecem numa lista vertical; nunca reduzir a fórmula até ficar ilegível. Permitir deslocamento horizontal dentro da linha matemática quando necessário.

## Componentes obrigatórios

### Botão principal

- Fundo preto, texto branco, altura mínima 44 px, padding horizontal 20 px e forma de cápsula.
- Usar para “Calcular localmente”, “Confirmar parâmetros” e a ação decisiva de cada passo.

### Botão secundário

- Fundo branco, texto preto, forma de cápsula, contorno muito subtil e sombra: 0 1 px 1 px preto a 4%, 0 2 px 4 px preto a 4%.
- Usar para limpar, voltar, alterar fórmula e abrir opções.

### Tabs

- Tabs dentro de painel creme, sem divisórias verticais.
- Tab ativa branca, raio 14 px, contorno subtil e sombra baixa.
- Tabs inativas transparentes, texto preto ou cinzento escuro.

### Campos

- Fundo branco, raio 14 px e contorno subtil.
- Label sempre visível; unidade alinhada à direita.
- Foco com contorno preto de 1,25 px.
- Erro imediatamente abaixo, sem alterar bruscamente o tamanho do painel.

### Cartão de fórmula

- Fórmula em 24–28 px com fonte matemática.
- Separar fórmula, dados introduzidos, substituição, operação e resultado.
- O resultado final usa fundo preto e texto branco ou cartão branco com valor preto grande, conforme o contexto.

### Passos da resolução

- Um cartão por passo, numerado.
- Título curto, expressão matemática selecionável e explicação em português.
- Espaço vertical de 12–16 px entre passos.
- Usar símbolos reais: `∫`, `∑`, `√`, `π`, letras gregas e expoentes; nunca substituir por palavras ou imagens.

### IA

- A entrada de linguagem natural tem o mesmo tratamento visual de uma área editorial ampla da referência.
- Se houver solução local, a app entra diretamente no fluxo determinístico.
- Se não houver, mostrar uma caixa clara com: fórmula proposta, variáveis, unidades, hipóteses e passos.
- O botão preto confirma os parâmetros; a app não apresenta o resultado de IA como cálculo validado sem confirmação.

## Movimento e estados

- Transições entre 150 e 220 ms, com aceleração suave.
- Hover: alteração mínima de fundo ou opacidade; sem aumentar o componente.
- Pressed: opacidade 88–92%.
- Loading: indicador fino dentro da área do resultado; manter a estrutura estável.
- Skeletons usam tons creme/cinza, sem brilho excessivo.
- Respeitar `reduce motion`.

## Requisitos de acessibilidade

- Contraste WCAG AA.
- Área de toque mínima 44 × 44 px.
- Navegação completa por teclado, foco visível e ordem lógica.
- Sem depender apenas da cor para estados ou erros.
- Texto escalável até 200% e suporte a leitores de ecrã.
- Fórmulas recebem descrição textual acessível além da notação visual.

## Ficheiro inicial fornecido

`implementation/flutter/vision_field_calc/lib/vision_theme.dart` contém os tokens iniciais. O outro chat deve transformá-los em componentes reutilizáveis e validar cada breakpoint com golden tests ou screenshots comparáveis.

## Critérios de aceitação visual

1. Comparação lado a lado em 1280 × 720, 1440 × 900, 768 × 1024 e 390 × 844.
2. Fundo, largura máxima, margens, raios, altura dos botões, tipografia e escala de espaçamento conferem com este guia.
3. Nenhum componente Material mantém a aparência azul/teal padrão.
4. Todos os estados de formulário, cálculo, erro, loading, revisão pendente e IA foram desenhados.
5. Fórmulas longas permanecem legíveis em móvel.
6. O produto usa apenas marca e conteúdos Vision World Apps.
