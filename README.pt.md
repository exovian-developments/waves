<div align="center">

# Waves™

**[English](README.md) | [Español](README.es.md) | [Português](README.pt.md)**

*O Product Consciousness Framework para a era dos agentes IA*

</div>

## Por que Waves

O desenvolvimento de produtos como conhecíamos mudou. Agentes IA (Claude Code, Codex, Gemini CLI) comprimem o que antes levava 6 meses de desenvolvimento em dias ou semanas. Sprints de 2 semanas já não refletem o ritmo real do trabalho — o desenvolvimento não é mais o gargalo.

Mas existe um problema mais profundo: **seu agente IA não tem discernimento.** Ele trata renomear uma variável da mesma forma que mudar seu modelo de negócio. Ele não sabe quando prosseguir e quando parar. Sem classificação, não há confiança — e sem confiança, você não pode realmente delegar.

Waves substitui sprints fixos por **ondas**: ciclos orgânicos de duração variável onde cada onda leva um incremento de produto desde a validação até a produção. E com o **Waves 2.0**, o agente se torna um consultor estratégico com autonomia graduada — ele conhece seu negócio, aplica suas regras mecanicamente, classifica cada decisão por nível de impacto, e te alerta sobre o que você não consegue ver porque está focado na tarefa imediata.

## O que é

Waves é um Product Consciousness Framework que dá ao **time humano + IA**:

1. **Estrutura** — quais artefatos existem e como se relacionam
2. **Ordem** — em que sequência o valor é produzido
3. **Memória** — persistência estruturada entre sessões e agentes
4. **Governança** — aplicação mecânica que não degrada
5. **Confiança** — autonomia graduada por nível de decisão
6. **Percepção estendida** — o agente vê o tabuleiro inteiro enquanto você foca na peça

Funciona com `Claude Code` (funcionalidades completas 2.0), `Claude Desktop` (plugin), `Codex` e `Gemini CLI` através de comandos interativos e schemas JSON estruturados.

### O Ciclo de Vida do Produto

Waves organiza o trabalho em cinco níveis, onde cada um se constrói sobre o anterior:

**1. Viabilidade** → *Podemos construir isso? Devemos?*
Você descreve sua ideia em linguagem natural. O agente atua como consultor de negócios: analisa o mercado, identifica concorrentes, constrói projeções de receita com simulações Monte Carlo, e te dá números honestos sobre se isso pode funcionar. O resultado é uma análise de viabilidade com dados reais — não opiniões.

**2. Foundation** → *O que aprendemos?*
A viabilidade pode produzir milhares de simulações em múltiplos cenários. O foundation compacta tudo em um resumo executivo limpo: o problema validado, quem são seus usuários, o modelo de receita com unit economics, análise SWOT, as capacidades essenciais necessárias, restrições de timeline, e um sinal claro de go/no-go. Esta é a ponte entre pesquisa e definição de produto.

**3. Blueprint** → *O que estamos construindo e por quê?*
Usando o foundation como input, você define o produto: suas capacidades (o que os usuários podem fazer), os fluxos de usuário (como fazem), princípios de design, regras de produto, métricas de sucesso e stack tecnológico. Cada seção conecta com o caso de negócio. Nada especulativo — cada capacidade rastreia a uma fonte de receita, cada regra rastreia a um princípio.

**4. Roadmap** → *Quando construímos e em que ordem?*
O roadmap pega as capacidades do blueprint e as organiza em fases com milestones, dependências e pontos de decisão. Ele responde perguntas como: o que vai no MVP? O que pode esperar? O que bloqueia o quê?

**5. Logbook** → *Como implementamos esta peça específica?*
Para cada ticket ou tarefa, um logbook divide o trabalho em objetivos principais e secundários com guias de completação. O agente os implementa continuamente, atualiza o progresso em tempo real, e preserva o contexto completo entre sessões para que nenhum conhecimento se perca.

```
viabilidade → foundation → blueprint → roadmap → logbook
 PODEMOS?     O QUE         O QUÊ/POR  QUANDO?   COMO?
              APRENDEMOS?   QUÊ?
```

Cada nível alimenta o próximo. Você pode começar em qualquer nível — se já tem um produto e só precisa de logbooks para o trabalho diário, comece aí. O pipeline completo é para quando você está construindo algo do zero.

### O que há de novo na 2.0

Waves 1.x deu estrutura ao caos. **Waves 2.0 dá consciência à estrutura.**

| Capacidade | O que faz | Como funciona |
|-----------|-------------|-------------|
| **Percepção** | O agente inicia cada sessão conhecendo o estado completo do produto | Hook SessionStart lê artefatos, injeta resumo de estado + força leitura de blueprint, roadmap, logbook |
| **Aplicação Mecânica** | Regras que não podem ser ignoradas | Hook PreToolUse bloqueia ações (exit 2) quando blueprint/roadmap/logbook estão ausentes |
| **Classificação de Decisões** | Autonomia graduada em 5 níveis | Lembrete de classificação injetado em cada ação, re-injetado após compactação |
| **Metacognição Proativa** | O agente reflete em momentos estratégicos | Hooks PostToolUse disparam na conclusão de objetivos, mudanças no blueprint, conclusão de fases |
| **Sobrevivência de Contexto** | Regras sobrevivem sessões longas | SessionStart re-dispara após compactação de contexto, re-injetando estado e regras |
| **Governança Graduada** | Aplicação proporcional à maturidade | Sem blueprint → permite tudo; blueprint sem roadmap → bloqueia; artefatos completos → permite + classifica |

**Classificação de Decisões — O Contrato de Confiança:**

| Nível | Tipo | Ação do agente |
|-------|------|-------------|
| 1 | Mecânica (nomes, formatação) | Prossegue silenciosamente |
| 2 | Técnica (padrão, estrutura) | Prossegue + documenta no logbook |
| 3 | Escopo (fora do objetivo atual) | **PARA.** Informa. Espera. |
| 4 | Negócio (afeta capacidade do blueprint) | **PARA.** Projeta cenários. Espera. |
| 5 | Descoberta (valor de mercado independente) | **PARA.** Documenta. Projeta. Aconselha. |

> Em caso de dúvida, o agente classifica **PARA CIMA** (mais cautela), nunca para baixo. Validado com 18 cenários de benchmark: 100% de ações corretas.

**Disponibilidade por plataforma:** Funcionalidades completas 2.0 (hooks, enforcement, metacognição) requerem Claude Code. Funcionalidades baseadas em schemas (artefatos, persistência, comandos) funcionam em todas as plataformas.

### Três formas de usar

1. **Plugin Cowork (Recomendado)** — Instale o plugin no Claude Desktop para experiência completa com GUI
2. **Slash Commands** — Comandos interativos para Claude Code CLI
3. **Prompts Manuais** — Copie/cole prompts para gerar arquivos a partir dos schemas

### Como funcionam os schemas

Cada JSON schema usa um padrão de dupla instrução:

- `description` = O que o campo representa, para que o LLM entenda que conteúdo gerar
- `$comment` = Como o LLM deve operar nesse campo, melhorando a precisão e consistência

---

## Características

| Característica | Descrição |
|----------------|-----------|
| **Percepção** | O agente inicia cada sessão informado — estado do produto, onda ativa, fase atual, próximo objetivo |
| **Enforcement** | Hooks mecânicos que bloqueiam ações quando artefatos estão ausentes — não sugestões, código |
| **Classificação** | Autonomia de decisão em 5 níveis — o agente sabe quando prosseguir e quando parar |
| **Metacognição** | Reflexão proativa na conclusão de objetivos, mudanças no blueprint e conclusão de fases |
| **Multi-Agente** | Os mesmos arquivos funcionam com Claude Code, Claude Desktop, Codex e Gemini CLI |
| **Multi-Sessão** | Logbooks + hooks preservam contexto entre sessões e após compactação |
| **Software + Geral** | Suporta projetos de software E acadêmicos, criativos, de negócio |
| **Validação de Negócio** | Análise de viabilidade com simulações Monte Carlo antes de escrever uma linha de código |

---

## Início Rápido (Plugin Cowork)

### Instalar

Baixe `waves.plugin` de [Releases](https://github.com/exovian-developments/waves/releases) e clique duas vezes para instalar no Claude Desktop. Ou compile do código:

```bash
cd plugin/
zip -r ../waves.plugin . -x "*.DS_Store"
```

### Uso

O plugin auto-carrega o contexto do projeto ao iniciar sessão. Use os comandos:

```
/project-init          # Inicializar preferências e contexto
/manifest-create       # Analisar projeto e criar manifesto
/logbook-create        # Criar logbook com objetivos
/logbook-update        # Registrar progresso nos objetivos
```

O plugin delega trabalho de análise para 16 agentes especializados, mantendo a thread principal leve para sessões longas de trabalho.

Veja [`plugin/README.md`](plugin/README.md) para documentação completa do plugin.

---

## Início Rápido (Claude Code)

### 1. Instalar

**Opção A: Homebrew (recomendado)**

```bash
brew tap exovian-developments/waves
brew install waves

# Inicializar no seu projeto
cd seu-projeto
waves init claude
```

**Opção B: Manual**

```bash
# Clonar o repositório
git clone https://github.com/exovian-developments/waves.git

# Copiar para seu projeto
mkdir -p seu-projeto/.claude/{commands,hooks}
cp -r waves/.claude/commands/* seu-projeto/.claude/commands/
cp waves/.claude/hooks/*.sh seu-projeto/.claude/hooks/
chmod +x seu-projeto/.claude/hooks/*.sh
cp waves/.claude/settings.json seu-projeto/.claude/settings.json
mkdir -p seu-projeto/ai_files/schemas
cp waves/schemas/*.json seu-projeto/ai_files/schemas/
```

**Atualizando um projeto existente:**

```bash
# Com Homebrew:
brew upgrade waves
cd seu-projeto && waves update

# Ou a partir de clone local:
cd seu-projeto
/caminho/para/waves/bin/waves update
```

### 2. Inicializar

No Claude Code, execute:
```
/waves:project-init
```

Isso vai:
- Perguntar seu idioma preferido (English, Español, Português, etc.)
- Configurar suas preferências de interação
- Configurar o contexto do projeto (software vs geral, nível de familiaridade)
- Criar `ai_files/user_pref.json`

### 3. Criar Manifesto do Projeto

```
/waves:manifest-create
```

Isso vai analisar seu projeto e criar um manifesto completo com tecnologias, arquitetura, funcionalidades e recomendações.

### 4. Trabalhar com Logbooks

```
/waves:logbook-create TICKET-123.json
```

Cria um logbook estruturado com objetivos e guias de completação para seu ticket/tarefa.

```
/waves:logbook-update TICKET-123.json
```

Atualiza o progresso, muda status de objetivos, adiciona novos objetivos descobertos durante o trabalho.

---

## Comandos Disponíveis

| Comando | Descrição | Status |
|---------|-----------|--------|
| `/waves:project-init` | Inicializar preferências e contexto | 🟢 Pronto |
| `/waves:manifest-create` | Analisar projeto e criar manifesto | 🟢 Pronto |
| `/waves:manifest-update` | Atualizar manifesto com mudanças | 🟢 Pronto |
| `/waves:rules-create` | Extrair regras de codificação | 🟢 Pronto |
| `/waves:rules-update` | Atualizar regras por mudanças no código | 🟢 Pronto |
| `/waves:user-pref-create` | Criar preferências de usuário detalhadas | 🟢 Pronto |
| `/waves:user-pref-update` | Editar preferências existentes | 🟢 Pronto |
| `/waves:logbook-create` | Criar logbook de desenvolvimento | 🟢 Pronto |
| `/waves:logbook-update` | Atualizar logbook com progresso | 🟢 Pronto |
| `/waves:resolution-create` | Gerar documento de resolução | 🟢 Pronto |
| `/waves:objectives-implement` | Implementar objetivos com auditoria | 🟢 Pronto |
| `/waves:roadmap-create` | Criar roadmap com fases e milestones | 🟢 Pronto |
| `/waves:roadmap-update` | Atualizar progresso e decisões do roadmap | 🟢 Pronto |
| `/waves:feasibility-analyze` | Análise de viabilidade com Monte Carlo e projeções Bayesian | 🟢 Pronto |
| `/waves:foundation-create` | Compactar viabilidade em fatos validados e benchmarks financeiros | 🟢 Pronto |
| `/waves:blueprint-create` | Criar blueprint completo a partir do foundation com validação do owner | 🟢 Pronto |

**Legenda:** 🟢 Pronto

---

## Schemas

| Schema | Propósito | Tipo de Projeto |
|--------|-----------|-----------------|
| `user_pref_schema.json` | Preferências de interação | Ambos |
| `software_manifest_schema.json` | Estrutura e tecnologia do projeto | Software |
| `general_manifest_schema.json` | Estrutura de projeto não-software | Geral |
| `project_rules_schema.json` | Regras e padrões de codificação | Software |
| `project_standards_schema.json` | Padrões para projetos gerais | Geral |
| `logbook_software_schema.json` | Logbook com refs de código | Software |
| `logbook_general_schema.json` | Logbook com refs de documentos | Geral |
| `ticket_resolution_schema.json` | Resumo de fechamento de ticket | Software |
| `logbook_roadmap_schema.json` | Roadmap com fases e milestones | Ambos |
| `feasibility_analysis_schema.json` | Análise de viabilidade com projeções | Ambos |
| `product_foundation_schema.json` | Ponte viabilidade → blueprint | Ambos |

---

## Estrutura do Projeto

Após a instalação, seu projeto terá:

```
seu-projeto/
├── .claude/
│   ├── settings.json               # Configuração de hooks (Waves 2.0)
│   ├── commands/                    # Slash commands
│   │   ├── waves:project-init.md
│   │   ├── waves:blueprint-create.md
│   │   ├── waves:roadmap-create.md
│   │   ├── waves:logbook-create.md
│   │   └── ... (16 comandos no total)
│   └── hooks/                       # Hooks executáveis (Waves 2.0)
│       ├── waves-perceive.sh        # SessionStart: injeta estado do produto
│       ├── waves-gate.sh            # PreToolUse: enforcement graduado
│       ├── waves-doc-enforce.sh     # PostToolUse: enforcement de documentação
│       ├── waves-metacognition.sh   # PostToolUse: gatilhos de reflexão
│       ├── waves-blueprint-impact.sh # PostToolUse: projeção de impacto
│       ├── waves-phase-audit.sh     # PostToolUse: auditoria estratégica
│       └── waves-dart-analyze.sh    # PostToolUse: análise dart
├── ai_files/
│   ├── schemas/                     # JSON schemas
│   ├── user_pref.json               # Suas preferências
│   ├── project_manifest.json        # Análise do projeto
│   ├── project_rules.json           # Regras de codificação
│   ├── blueprint.json               # Definição do produto (O QUÊ/POR QUÊ)
│   └── waves/
│       └── wN/
│           ├── roadmap.json         # Plano da onda (QUANDO/ORDEM)
│           └── logbooks/            # Implementação (COMO/DETALHE)
└── CLAUDE.md                        # Protocolo Operacional do Agente
```

---

## Fluxo de Trabalho

### Para Projetos de Software

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  project-init   │ ──▶ │ manifest-create  │ ──▶ │  rules-create   │
│ (preferências)  │     │(analisar projeto)│     │(extrair regras) │
└─────────────────┘     └──────────────────┘     └─────────────────┘
                                                          │
         ┌────────────────────────────────────────────────┘
         ▼
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│ logbook-create  │ ──▶ │  logbook-update  │ ──▶ │resolution-create│
│  (novo ticket)  │     │(acompanhar work) │     │ (fechar ticket) │
└─────────────────┘     └──────────────────┘     └─────────────────┘
```

### Para Projetos Gerais (Acadêmico, Criativo, Negócio)

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  project-init   │ ──▶ │ manifest-create  │ ──▶ │ logbook-create  │
│ (preferências)  │     │(definir projeto) │     │(acompanhar tasks)│
└─────────────────┘     └──────────────────┘     └─────────────────┘
```

---

## Fluxos de Criação de Manifesto

O comando `manifest-create` se adapta ao seu projeto:

### Projetos de Software
- **A1: Projeto Novo** - 5 perguntas para definir stack e funcionalidades
- **A2.1: Existente (Conhecido)** - 2 checkpoints + 6 analisadores paralelos
- **A2.2: Existente (Desconhecido)** - Zero perguntas, análise completa com prints de progresso

### Projetos Gerais
- **B1: Acadêmico** - Tema de pesquisa, metodologia, marcos, citações
- **B2: Criativo** - Conceito, estilo, ativos, entregáveis
- **B3: Negócio** - 9 perguntas do Business Model Canvas
- **B4: Outro** - Objetivos genéricos e entregáveis
- **BE: Existente** - Descoberta de diretórios e análise de conteúdo

---

## Subagentes Especializados

Os comandos utilizam 33 subagentes especializados:

| Categoria | Subagentes | Status |
|-----------|-----------|--------|
| **Core** | project-initializer, manifest-creator-new-software, secondary-objective-generator, context-summarizer | ✅ Completo |
| **Análise de Software** | entry-point-analyzer, navigation-mapper, flow-tracker, dependency-auditor, architecture-detective, feature-extractor | ✅ Completo |
| **Projetos Gerais** | manifest-creator-academic/creative/business/generic, general-project-scanner, directory-analyzer | ✅ Completo |
| **Regras** | pattern-extractor, convention-detector, antipattern-detector, criteria-validator, standards-structurer | ✅ Completo |
| **Atualizações** | git-history-analyzer, autogen-detector, manifest-change-analyzer, timestamp-analyzer, manifest-updater, rule-comparator | ✅ Completo |
| **Implementação** | code-implementer, code-auditor | ✅ Completo |
| **Roadmap** | roadmap-creator, roadmap-updater | ✅ Completo |

Veja [subagents/README.md](subagents/README.md) para detalhes completos.

---

## Instalação Manual (Alternativa)

Se preferir não usar slash commands, você ainda pode usar os schemas diretamente:

### 1. Configuração

```bash
git clone https://github.com/exovian-developments/waves.git
cd seu-projeto
mkdir -p ai_files/schemas .claude/{commands,hooks}
cp waves/schemas/*.json ai_files/schemas/
cp waves/.claude/commands/*.md .claude/commands/
cp waves/.claude/hooks/*.sh .claude/hooks/ && chmod +x .claude/hooks/*.sh
cp waves/.claude/settings.json .claude/settings.json
```

### 2. Adicionar ao CLAUDE.md

```markdown
# Key files to review on session start:
required_reading:
  - path: "ai_files/project_manifest.json"
    description: "Project structure, technologies, architecture"
    when: "always"

  - path: "ai_files/project_rules.json"
    description: "Coding rules and conventions to follow"
    when: "always"

  - path: "ai_files/user_pref.json"
    description: "User interaction preferences"
    when: "always"

  - path: "ai_files/logbooks/"
    description: "Development logbooks for tickets"
    when: "always"
```

### 3. Usar Prompts

**Criar Preferências de Usuário:**
```
Analyze ai_files/schemas/user_pref_schema.json and ask me questions to generate ai_files/user_pref.json. Be concise and follow the schema structure.
```

**Criar Manifesto do Projeto:**
```
Analyze ai_files/schemas/software_manifest_schema.json, then analyze this project thoroughly (all directories and files). Generate ai_files/project_manifest.json following the schema.
```

**Criar Logbook:**
```
Analyze ai_files/schemas/logbook_software_schema.json. Based on the ticket I'll describe, create a logbook with objectives and completion guides.
```

---

## Estrutura do Logbook

Cada logbook contém:

```json
{
  "ticket": {
    "title": "Implement GET /products/:id endpoint",
    "url": "https://jira.company.com/PROJ-123",
    "description": "Full ticket details..."
  },
  "objectives": {
    "main": [
      {
        "id": 1,
        "content": "Endpoint returns product with specifications",
        "context": "Frontend needs complete data for detail page",
        "scope": {
          "files": ["src/controllers/ProductController.ts"],
          "rules": [3, 7]
        },
        "status": "active"
      }
    ],
    "secondary": [
      {
        "id": 1,
        "content": "ProductDetailDTO includes specifications array",
        "completion_guide": [
          "Use pattern from src/dtos/BaseDTO.ts:12",
          "Apply rule #3: @Expose() decorators"
        ],
        "status": "not_started"
      }
    ]
  },
  "recent_context": [
    {
      "id": 1,
      "created_at": "2025-12-11T10:00:00Z",
      "content": "Logbook created. Ready to start."
    }
  ],
  "history_summary": [],
  "future_reminders": []
}
```

**Valores de status:** `not_started`, `active`, `blocked`, `achieved`, `abandoned`

---

## Convenções

- **IDs:** Inteiros começando em 1, imutáveis uma vez criados
- **Timestamps:** UTC ISO 8601, `created_at` imutável
- **Limite de contexto:** 20 entradas recentes, auto-compacta para history_summary
- **Limite de histórico:** Máximo de 10 resumos
- **YAGNI:** Todos os guias de completação aplicam o princípio YAGNI

---

## Validação

```bash
# Node (AJV)
npx ajv validate -s ai_files/schemas/logbook_software_schema.json -d ai_files/logbooks/TICKET-123.json

# Python
python -c "import json,jsonschema; jsonschema.validate(json.load(open('data.json')), json.load(open('schema.json')))"
```

---

## Estrutura do Repositório

```
waves/
├── bin/waves             # Instalador CLI (brew install waves)
├── schemas/              # Fonte de verdade: JSON schemas
├── .claude/
│   ├── commands/         # 16 slash commands executáveis
│   ├── hooks/            # 7 hooks Waves 2.0 (perceive, gate, enforce, metacognition, ...)
│   └── settings.json     # Configuração de hooks (SessionStart, PreToolUse, PostToolUse)
├── plugin/               # Plugin Cowork (Claude Desktop)
│   ├── agents/           # Agentes especializados
│   ├── commands/         # Slash commands
│   ├── skills/           # Conhecimento do protocolo + referências de schemas
│   └── hooks/            # Hook SessionStart baseado em prompt
├── subagents/            # Design canônico: especificações de subagentes
├── commands/             # Documentos de design de comandos (numerados, detalhados)
├── FRAMEWORK.md          # Documentação completa do framework (v2.0)
├── CHANGELOG.md          # Histórico de versões
└── README.md
```

---

## Compatibilidade

| Plataforma | Hooks (2.0) | Plugin | Slash Commands | Prompts Manuais |
|----------|-------------|--------|---------------|----------------|
| Claude Code | ✅ Completo (enforcement, metacognição, classificação) | ❌ | ✅ | ✅ |
| Claude Desktop | ❌ | ✅ (percepção baseada em prompt) | ✅ | ✅ |
| Codex | ❌ | ❌ | ❌ | ✅ |
| Gemini CLI | ❌ | ❌ | ❌ | ✅ |

**Nota:** Funcionalidades baseadas em hooks (enforcement mecânico, metacognição, classificação de decisões) são atualmente exclusivas do Claude Code. Funcionalidades baseadas em schemas (artefatos, persistência, comandos) funcionam em todas as plataformas.

---

## Licença

- Código e schemas: AGPL-3.0-or-later (veja `LICENSE`)
- Documentação: CC BY 4.0 (opcional)

---

## Contribuindo

Veja [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) para detalhes da arquitetura e [subagents/README.md](subagents/README.md) para status de implementação.

**Prioridades atuais:**
1. Feedback da comunidade sobre os níveis de classificação de decisões
2. Suporte a hooks para plataformas adicionais (Codex, Gemini CLI) se solicitado
3. Manter agentes do plugin sincronizados com mudanças canônicas de subagentes
