# Repository Structure

**Project**: FermentFlow  
**Purpose**: Single source of truth for repository layout, branch strategy, and naming conventions.

---

## Top-level Layout

```text
fermentflow/
├── docs/                  # Documentation
│   └── 01-overview/       # Project, domain, architecture, running locally
│
├── docker/                # Docker Compose infrastructure
│
├── src/                   # Application source code
│
├── tests/                 # Architecture tests from branch 02; cross-service from branch 06
│
├── tools/
│   └── psscripts/
│
├── .github/
│
├── .cursor/
│
├── README.md
└── CLAUDE.md
```

---

## Architecture Evolution Roadmap

```text
01-LegacyMonolith
        ↓
02-ModularMonolith
        ↓
03-CQRS-VerticalSlices
        ↓
04-CQRS-EventSourcing
        ↓
05-Microservices
        ↓
06-OutboxPattern
        ↓
07-CircuitBreaker
        ↓
08-Observability
        ↓
09-Aspire
```

Each branch introduces a single major architectural concept while preserving the same brewery logistics domain.

Per-branch folder layouts and characteristics: [08-branch-roadmap.md](01-overview/08-branch-roadmap.md).

---

## Branch Learning Goals

| Branch | Main Learning Goal |
| ------ | ------------------ |
| 01-LegacyMonolith | Layered Architecture |
| 02-ModularMonolith | DDD + Bounded Contexts |
| 03-CQRS-VerticalSlices | CQRS + Vertical Slice Architecture |
| 04-CQRS-EventSourcing | CQRS retained + domain events + EventStoreDB |
| 05-Microservices | Service Decomposition |
| 06-OutboxPattern | Reliable Messaging |
| 07-CircuitBreaker | Resilience with Polly |
| 08-Observability | OpenTelemetry, Prometheus, Grafana |
| 09-Aspire | Service Orchestration and Cloud-Native Development |

---

## Documentation Layout

```text
docs/
├── 01_repository-structure.md    # This file — layout, roadmap, naming
├── adr/                          # Architecture Decision Records (branch 02 onward)
│   ├── README.md
│   ├── ADR-001-introduce-modular-monolith.md
│   └── …
├── agent-skills.md
├── agent-subagents.md
├── agent-governance-recovery.md
└── 01-overview/
    ├── 01-project-overview.md
    ├── 02-business-domain.md
    ├── 03-architecture-evolution.md
    ├── 04-ubiquitous-language.md
    ├── 05-ddd-reverse-engineering-report.md
    ├── 06-running-locally.md
    ├── 07-fermentflow-modernization-vision.md
    └── 08-branch-roadmap.md
```

---

## Naming Conventions

### Branches

```text
01-LegacyMonolith
02-ModularMonolith
03-CQRS-VerticalSlices
04-CQRS-EventSourcing
05-Microservices
06-OutboxPattern
07-CircuitBreaker
08-Observability
09-Aspire
```

### Projects

```text
FermentFlow.<Context>.<Layer>
```

Examples:

```text
FermentFlow.Sales.Domain
FermentFlow.Inventory.Application
FermentFlow.Production.Infrastructure
```

### Building Blocks

Early branches (02–03) may start with:

```text
FermentFlow.BuildingBlocks.Domain
FermentFlow.BuildingBlocks.Application
FermentFlow.BuildingBlocks.Infrastructure   # temporary; avoid growing into a dumping ground
```

Target evolution (branch 04 onward) splits concerns explicitly:

```text
BuildingBlocks/
├── Domain
├── Application
├── Persistence          # EF Core, repositories — replaces generic Infrastructure
├── EventSourcing        # branch 04+
├── Messaging            # MassTransit abstractions
├── Outbox               # branch 06+
├── Resilience           # branch 07+
├── Observability        # branch 08+
└── Testing              # shared test fixtures and fakes
```

Project naming: `FermentFlow.BuildingBlocks.<Concern>` (e.g. `FermentFlow.BuildingBlocks.Outbox`).

---

## Architecture Tests (from Branch 02)

```text
tests/
└── FermentFlow.Architecture.Tests    # NetArchTest.Rules or ArchUnitNET
```

Introduced on **`02-ModularMonolith`** and extended each branch. Example rules:

- `Sales` must not reference `Inventory.Infrastructure` or `Production.Infrastructure`
- Domain must not reference Application or Infrastructure
- Application must not reference another context's Infrastructure

See [ADR-001](adr/ADR-001-introduce-modular-monolith.md).

---

## Baseline Import Mapping

Legacy-named branches from the imported baseline map to early roadmap stages:

| Legacy branch | Roadmap stage |
|---------------|---------------|
| `01-monolith_legacy` | 01-LegacyMonolith |
| `02-monolith_with_cqrs` | 02-ModularMonolith (partial) → 03-CQRS-VerticalSlices (target) |
| `03-monolith_with_cqrs_and_event_sourcing` | 04-CQRS-EventSourcing |
| `04-microservices` | 05-Microservices |

---

## Agent Governance Mirrors

| Canonical | Mirror |
|-----------|--------|
| `.github/skills/` | `.cursor/skills/` |
| `.github/agents/` | `.cursor/agents/` |

Both trees must stay byte-identical. CI enforces parity via `ci-skills-parity.yml` and `ci-agent-docs-guard.yml`.
