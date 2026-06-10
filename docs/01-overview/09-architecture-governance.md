# Architecture Governance

How FermentFlow enforces architectural decisions across the nine-branch evolution and beyond.

**Related:** [Branch roadmap](08-branch-roadmap.md) · [ADRs](../adr/README.md) · [Repository structure](../01_repository-structure.md)

---

## Branch evolution philosophy

Each git branch introduces **one major architectural leap** while preserving the same brewery logistics domain:

```text
01-LegacyMonolith → … → 09-Aspire
```

Rules:

1. **Do not skip stages** when learning — each branch builds on the previous capability set.
2. **Retain capabilities** — CQRS and vertical slices introduced at branch 03 continue through branch 09; event sourcing at branch 04 does not replace them.
3. **Outbox before circuit breaker** — reliable messaging (branch 06) precedes sync resilience (branch 07).
4. **Document the decision** — [ADR-000](../adr/ADR-000-establish-fermentflow.md) establishes the laboratory; branches 02–09 each have a matching ADR; [ADR-009](../adr/ADR-009-introduce-event-driven-sagas.md) is reserved for stage 10.

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

Extend rules each branch — for example, branch 06 forbids direct broker publish outside `BuildingBlocks.Outbox`.

### When to run

```powershell
dotnet test tests/FermentFlow.Architecture.Tests
```

Run on every PR that touches `src/` or `tests/`. CI should fail on boundary violations before integration tests run.

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
└── Testing
```

---

## Definition of Done (per branch)

A branch is **complete** when:

- [ ] Source layout matches [08-branch-roadmap.md](08-branch-roadmap.md) for that stage
- [ ] Matching ADR is **Accepted** and reflects actual code
- [ ] `dotnet build` and `dotnet test` pass
- [ ] Architecture tests pass (branch 02+)
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
| Vertical slices | 03 | ✓ |
| CQRS (MediatR) | 03 | ✓ |
| Event sourcing | 04 | ✓ |
| Outbox | 06 | ✓ |
| Polly resilience | 07 | ✓ |
| OpenTelemetry | 08 | ✓ |

See the capabilities matrix in [Modernization vision](07-fermentflow-modernization-vision.md).
