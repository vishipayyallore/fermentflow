# Repository structure

**Project**: FermentFlow  
**Purpose**: Single source of truth for repository layout and naming conventions.

## Top-level layout

```
fermentflow/
├── docs/                  # Documentation
│   └── 01-overview/       # Project, domain, architecture, running locally
├── docker/                # Infrastructure (MongoDB, EventStore, RabbitMQ)
├── src/                   # Application source (branch-dependent)
├── tools/                 # Maintenance scripts
│   └── psscripts/         # PowerShell helpers
├── .github/               # CI, issue templates, agent skills/agents
├── .cursor/               # Cursor rules, mirrored skills/agents
├── README.md
└── CLAUDE.md              # Assistant entry point
```

## Source layout by branch

| Branch | Solution(s) | Notes |
|--------|-------------|-------|
| `01-monolith_legacy` | `src/FermentFlow.sln` | Layered monolith, ~6 projects |
| `02-monolith_with_cqrs` | `src/FermentFlow.sln` | Bounded contexts, ~15 projects |
| `03-monolith_with_cqrs_and_event_sourcing` | `src/FermentFlow.sln` | Event sourcing, ~18 projects |
| `04-microservices` | `src/Sales/FermentFlow.Sales.sln`, `src/Warehouses/FermentFlow.Warehouses.sln` | Two deployable services |

## Documentation layout

| Path | Content |
|------|---------|
| `docs/01-overview/01-project-overview.md` | Stack, branches, endpoints |
| `docs/01-overview/02-business-domain.md` | Brewery logistics domain |
| `docs/01-overview/03-architecture-evolution.md` | Branch-by-branch patterns |
| `docs/01-overview/04-ubiquitous-language.md` | Domain vocabulary |
| `docs/01-overview/05-ddd-reverse-engineering-report.md` | Reverse-engineering notes |
| `docs/01-overview/06-running-locally.md` | Local run instructions |
| `docs/01-overview/07-fermentflow-modernization-vision.md` | Future evolution plan |
| `docs/agent-skills.md` | Agent skills pattern |
| `docs/agent-subagents.md` | Subagent index |
| `docs/agent-governance-recovery.md` | Governance recovery |

## Agent governance mirrors

| Canonical | Mirror |
|-----------|--------|
| `.github/skills/` | `.cursor/skills/` |
| `.github/agents/` | `.cursor/agents/` |

Both trees must stay byte-identical. CI enforces parity via `ci-skills-parity.yml` and `ci-agent-docs-guard.yml`.

## Naming conventions

- **Docs**: numbered prefixes under `docs/01-overview/` (`01-`, `02-`, …)
- **C# projects**: `FermentFlow.<Context>.<Layer>` (e.g., `FermentFlow.Sales.Domain`)
- **REST projects**: `FermentFlow.<Context>.Rest` or `FermentFlow.Rest` (branch 01)
