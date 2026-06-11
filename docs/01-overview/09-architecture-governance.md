# Architecture Governance

How FermentFlow enforces architectural decisions across the nine-stage evolution and beyond.

**Related:** [Branch roadmap](08-branch-roadmap.md) · [ADRs](../adr/README.md) · [Repository structure](../01_repository-structure.md) · [Stage vs git branch](../01_repository-structure.md#stage-vs-git-branch)

---

## Stage evolution philosophy

Each **stage** (one git branch) introduces **one major architectural leap** while preserving the same brewery logistics domain:

```text
01-LegacyMonolith → … → 09-Aspire
```

Rules:

1. **Do not skip stages** when learning — each branch builds on the previous capability set.
2. **Retain capabilities** — CQRS and vertical slices introduced at Stage 03 continue through Stage 09; event sourcing at Stage 04 does not replace them.
3. **Outbox before circuit breaker** — reliable messaging (Stage 06) precedes sync resilience (Stage 07).
4. **Document the decision** — [ADR-000](../adr/ADR-000-establish-fermentflow.md) establishes the laboratory; Stages 02–09 each have a matching ADR; [ADR-009](../adr/ADR-009-introduce-event-driven-sagas.md) is reserved for Stage 10.

Optional future stages after Aspire:

```text
10-EventDrivenSagas → 11-Kubernetes → 12-GitHubActions → 13-AzureContainerApps → 14-MultiTenancy
```

Stage 10 models the natural long-running workflow: Production → Inventory → Sales.

---

## ADR process

Architecture Decision Records live under [`docs/adr/`](../adr/README.md).

| Step | Action |
|------|--------|
| 1 | Identify the branch/stage that introduces the change |
| 2 | Create or update the ADR (Status, Context, Decision, **Alternatives Considered**, Consequences) |
| 3 | Update [branch roadmap](08-branch-roadmap.md) and [repository structure](../01_repository-structure.md) if layout changes |
| 4 | Extend architecture tests if new dependency rules apply |
| 5 | Mark ADR **Accepted** when the branch implementation matches the decision |

### ADR chain

```text
ADR-000  Establish FermentFlow       (foundation)
ADR-001  Modular Monolith          (02)
ADR-002  CQRS + Vertical Slices    (03)
ADR-003  CQRS + Event Sourcing     (04)
ADR-004  Microservices              (05)
ADR-005  Outbox Pattern             (06)
ADR-006  Circuit Breaker            (07)
ADR-007  Observability              (08)
ADR-008  .NET Aspire                (09)
ADR-009  Event-Driven Sagas         (10 — Proposed)
ADR-010  InventoryItem Aggregate    (domain — from 02)
ADR-011  Production Bounded Context (from 02 module; deployable 05)
ADR-012  Cross-Context Collaboration (Stage 03 application contracts)
```

---

## Architecture tests

Introduced on **`02-ModularMonolith`** in:

```text
tests/FermentFlow.Architecture.Tests
```

**Tooling:** [NetArchTest.Rules](https://github.com/BenMorris/NetArchTest) or [ArchUnitNET](https://github.com/TNG/ArchUnitNET).

### Dependency rules (baseline set)

| Rule | Rationale |
|------|-----------|
| `Sales` must not reference `Inventory.Infrastructure` or `Production.Infrastructure` | Bounded context isolation |
| `Domain` must not reference `Application` or `Infrastructure` | Onion / clean architecture |
| `Domain` must not reference MediatR, MassTransit, or Entity Framework | Domain stays framework-free |
| `Application` must not reference another context's `Infrastructure` | No cross-context persistence coupling |
| `Features/*` may depend only on Application + Domain | Vertical slice boundaries |
| Infrastructure may depend on Domain, Application, and adapters | Outer ring owns EF, MassTransit, etc. |
| `Features/*` handlers must not reference EF Core or MassTransit directly | Keep slices thin; use abstractions |

Extend rules each stage — for example, Stage 06 forbids direct broker publish outside `BuildingBlocks.Outbox`.

### Cross-context collaboration (Stage 03+)

Inside the modular monolith, contexts collaborate through **application-layer contracts** owned by the consumer context. See [ADR-012](../adr/ADR-012-cross-context-collaboration-modular-monolith.md).

| Rule | Rationale |
|------|-----------|
| Sales must not reference Inventory or Production **Infrastructure** | No cross-context persistence coupling |
| Sales must not query Inventory repositories, `DbContext`, or read models | Prevents Stage 01 smell in CQRS clothing |
| No cross-context MediatR `Send` between contexts | MediatR stays within one bounded context |
| Consumer context owns the interface; provider implements in **Application** | Clear dependency direction |
| `InventoryItem.ReserveStock` is the stock invariant authority | Sales orchestrates; Inventory enforces |

Preferred flow: **ReserveStock → SalesOrder.Create** — not Sales-only validation against a foreign read model.

### Database ownership (Stage 05+)

From **`05-Microservices`** onward, each bounded context **owns its PostgreSQL database**. No shared database between Sales, Inventory, and Production.

| Rule | Rationale |
|------|-----------|
| Each service has exactly one primary application database | Service autonomy and independent deployment |
| No cross-context `DbContext` or connection string references | Prevents hidden coupling through shared tables |
| Integration only via APIs or integration events (outbox from Stage 06) | Replaces monolithic shared-database joins |

Example architecture test (Stage 05+):

```text
Sales.Infrastructure must not reference Inventory or Production connection strings
Inventory.Infrastructure must not reference Sales or Production DbContext types
```

### When to run

```powershell
dotnet test tests/FermentFlow.Architecture.Tests
```

Run on every PR that touches `src/` or `tests/`. CI should fail on boundary violations before integration tests run.

---

## Architectural fitness functions

Evolutionary architecture checks — automated where possible, manual where not yet codified.

| Fitness function | Validation | Introduced |
|------------------|------------|------------|
| Context isolation | NetArchTest / ArchUnitNET — no cross-context Infrastructure references | Stage 02 |
| Cross-context collaboration | Application contracts only; no cross-context repos, DbContext, or MediatR | Stage 03 |
| No infrastructure leakage | Domain must not reference EF, MassTransit, MediatR | Branch 02 |
| Vertical slice boundaries | Features depend only on Application + Domain | Branch 03 |
| No direct RabbitMQ publish | Architecture tests — integration events via outbox only | Branch 06 |
| **Database per bounded context** | Each microservice owns one PostgreSQL database; no shared `DbContext` or cross-service connection strings | Stage 05 |
| No cross-service DB access | Architecture tests enforce connection-string and DbContext isolation between services | Stage 05 |
| Domain invariants | Domain unit tests (Given/When/Then) | Branch 03 |
| Trace coverage | OpenTelemetry integration tests — spans present on HTTP and messaging | Branch 08 |
| Saga orchestration isolation | Saga state machines not in domain aggregates | Branch 10 (proposed) |

Extend this table as new branches add constraints. Prefer encoding rules in `FermentFlow.Architecture.Tests` over prose-only governance.

---

## Domain unit tests

Introduced on **`03-CQRS-VerticalSlices`** — one test project per bounded context:

```text
tests/
├── FermentFlow.Sales.UnitTests
├── FermentFlow.Inventory.UnitTests
└── FermentFlow.Production.UnitTests
```

Focus on **aggregate invariants** and domain services — no EF, MassTransit, or HTTP.

Example (Given/When/Then):

```text
Given stock of 10
When order requests 5
Then order is accepted

Given stock of 10
When order requests 15
Then order is rejected
```

These tests pay off immediately on branch 04 when aggregates become event-sourced — replay and projection logic stay guarded.

---

## Integration tests (Testcontainers)

Introduced on **`03-CQRS-VerticalSlices`** in `tests/FermentFlow.IntegrationTests`:

| Branch | Containers |
|--------|------------|
| 03 | PostgreSQL |
| 04+ | PostgreSQL, RabbitMQ, EventStoreDB |

**Tooling:** [Testcontainers for .NET](https://dotnet.testcontainers.org/) + xUnit.

By branch 04, real infrastructure is required — Testcontainers becomes a natural learning objective rather than a late add-on.

### When to run

```powershell
dotnet test tests/
```

---

## Building blocks governance

Avoid a monolithic `BuildingBlocks.Infrastructure` project — it becomes a dumping ground.

| Phase | Building blocks |
|-------|-----------------|
| Branch 03 (transitional) | `Domain`, `Application`, minimal shared helpers only |
| Branch 04+ (target) | `Persistence`, `EventSourcing`, `Messaging`, … |
| Branch 06+ | `Outbox` |
| Branch 07+ | `Resilience` |
| Branch 08+ | `Observability` |
| Branch 10+ (proposed) | `Sagas` |
| All branches 02+ | `Testing` (shared fakes/fixtures) |

Target layout:

```text
BuildingBlocks/
├── Domain
├── Application
├── Persistence
├── EventSourcing
├── Messaging
├── Outbox
├── Resilience
├── Observability
├── Sagas                  # branch 10+ (proposed)
└── Testing
```

---

## Definition of Done (per branch)

A branch is **complete** when:

- [ ] Source layout matches [08-branch-roadmap.md](08-branch-roadmap.md) for that stage
- [ ] Matching ADR is **Accepted** and reflects actual code
- [ ] `dotnet build` and `dotnet test` pass
- [ ] Architecture tests pass (branch 02+)
- [ ] Domain unit tests pass (branch 03+)
- [ ] Integration tests with Testcontainers pass (branch 03+)
- [ ] Domain terms match [ubiquitous language](04-ubiquitous-language.md)
- [ ] [Running locally](06-running-locally.md) instructions work for that branch (or baseline import path is documented)
- [ ] No Packt/BrewUp framing added to public docs

---

## Capability retention checklist

When implementing a new branch, confirm prior capabilities still hold:

| Capability | Introduced | Must remain through 09 |
|------------|------------|-------------------------|
| Bounded contexts | 02 | ✓ |
| Architecture tests | 02 | ✓ |
| Domain unit tests | 03 | ✓ |
| Testcontainers | 03 | ✓ |
| Vertical slices | 03 | ✓ |
| CQRS (MediatR) | 03 | ✓ |
| Event sourcing | 04 | ✓ |
| Outbox | 06 | ✓ |
| Polly resilience | 07 | ✓ |
| OpenTelemetry | 08 | ✓ |

See the capabilities matrix in [Modernization vision](07-fermentflow-modernization-vision.md).
