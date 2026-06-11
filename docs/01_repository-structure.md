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
├── tests/                 # Architecture tests (02+); domain + Testcontainers (03+)
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
Governance (ADRs, architecture tests, Definition of Done): [09-architecture-governance.md](01-overview/09-architecture-governance.md).

### Optional future stages (after 09-Aspire)

```text
10-EventDrivenSagas → 11-Kubernetes → 12-GitHubActions → 13-AzureContainerApps → 14-MultiTenancy
```

---

## Branch Learning Goals

| Branch | Main Learning Goal |
| ------ | ------------------ |
| 01-LegacyMonolith | Layered Architecture |
| 02-ModularMonolith | DDD + bounded contexts + **architecture tests** |
| 03-CQRS-VerticalSlices | CQRS + vertical slices + **domain unit tests** + **Testcontainers** |
| 04-CQRS-EventSourcing | CQRS retained + domain events + EventStoreDB |
| 05-Microservices | Service Decomposition |
| 06-OutboxPattern | Reliable Messaging |
| 07-CircuitBreaker | Resilience with Polly |
| 08-Observability | OpenTelemetry, Prometheus, Grafana |
| 09-Aspire | Service Orchestration and Cloud-Native Development |

---

## Documentation Layout

### `docs/01-overview/` numbering

| Range | Purpose | Examples |
|-------|---------|----------|
| **01–12** | Cross-cutting reference (stable reading order) | `04-ubiquitous-language.md`, `08-branch-roadmap.md` |
| **13+** | Per-stage implementation blueprints | `13-stage-01-overview.md`, `14-stage-01-smells.md` |

Add new stage blueprints as `15-stage-02-…`, `16-stage-02-…`, and so on. Do not renumber 01–12 when adding stage docs.

`03-architecture-evolution.md` is optional historical comparison only — not part of the greenfield implementation path.

```text
docs/
├── 01_repository-structure.md    # This file — layout, roadmap, naming
├── adr/                          # Architecture Decision Records
│   ├── README.md
│   ├── ADR-000-establish-fermentflow.md
│   ├── ADR-001-introduce-modular-monolith.md
│   └── … (through ADR-013)
├── agent-skills.md
├── agent-subagents.md
├── agent-governance-recovery.md
└── 01-overview/
    ├── 01-project-overview.md
    ├── 02-business-domain.md
    ├── 03-architecture-evolution.md    # optional — external baseline comparison
    ├── 04-ubiquitous-language.md
    ├── 05-ddd-reverse-engineering-report.md
    ├── 06-running-locally.md
    ├── 07-fermentflow-modernization-vision.md
    ├── 08-branch-roadmap.md
    ├── 09-architecture-governance.md
    ├── 10-event-catalog.md
    ├── 11-domain-invariants.md
    ├── 12-inventory-aggregate-model.md
    ├── 13-stage-01-overview.md         # Stage 01 implementation blueprint
    ├── 14-stage-01-smells.md           # Stage 01 intentional smells
    ├── 15-baseline-import-running.md   # optional — external baseline run reference
    └── 16-stage-03-cross-context-collaboration.md
```

---

## Naming Conventions

### Stage vs git branch

Use **Stage** in prose (learning step). Use the **git branch** slug for `git checkout` and folder strategy.

| Stage (prose) | Git branch |
|---------------|------------|
| Stage 01 — Legacy Monolith | `01-LegacyMonolith` |
| Stage 02 — Modular Monolith | `02-ModularMonolith` |
| Stage 03 — CQRS + Vertical Slices | `03-CQRS-VerticalSlices` |
| Stage 04 — CQRS + Event Sourcing | `04-CQRS-EventSourcing` |
| Stage 05 — Microservices | `05-Microservices` |
| Stage 06 — Outbox Pattern | `06-OutboxPattern` |
| Stage 07 — Circuit Breaker | `07-CircuitBreaker` |
| Stage 08 — Observability | `08-Observability` |
| Stage 09 — Aspire | `09-Aspire` |

In documentation, prefer **“Stage 03 introduces CQRS”** over ambiguous **“branch 03”** unless referring explicitly to git.

### Git branches

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
```

Avoid `BuildingBlocks.Infrastructure` as a long-term home — it becomes a dumping ground. Use thin context-level Infrastructure projects only where needed until branch 04 splits building blocks.

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
├── Sagas                # branch 10+ (proposed — ADR-009)
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

See [ADR-001](adr/ADR-001-introduce-modular-monolith.md). Root context: [ADR-000](adr/ADR-000-establish-fermentflow.md).

---

## Agent Governance Mirrors

| Canonical | Mirror |
|-----------|--------|
| `.github/skills/` | `.cursor/skills/` |
| `.github/agents/` | `.cursor/agents/` |

Both trees must stay byte-identical. CI enforces parity via `ci-skills-parity.yml` and `ci-agent-docs-guard.yml`.
