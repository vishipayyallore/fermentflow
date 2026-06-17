# ADR-001: Establish FermentFlow

**Status:** Accepted  
**Branch:** *(repository foundation — precedes `01-LegacyMonolith`)*  
**Date:** 2026-06-10

## Context

Swamy PKV needs a personal workspace to explore how a business domain evolves from a legacy monolith into a modern, resilient, cloud-native distributed system. An imported brewery logistics baseline provides realistic domain complexity (orders, inventory, production-driven stock) without inventing a toy CRUD example.

The workspace must teach **incremental refactoring** — not a single "final" architecture snapshot.

## Decision

Establish **FermentFlow** as Swamy's personal **architecture modernization laboratory**. All later ADRs (002–010) descend from this root decision.

### Why FermentFlow

- Name reflects the domain flow: **Production → Inventory → Sales**
- Staged git branches make architectural evolution visible and reproducible
- ADRs and architecture tests enforce decisions — not just prose

### Why brewery logistics

- Natural bounded contexts (Sales, Inventory, Production)
- Long-running workflow suitable for sagas (stage 10)
- Stock validation rules teach invariants before event sourcing

### Why nine stages

Each branch introduces **one major leap** while retaining prior capabilities (CQRS does not disappear when event sourcing arrives). See [repository structure](../01_repository-structure.md#architecture-evolution-roadmap).

### Why .NET 10

- Single SDK target for all branches — imported baseline code is **ported to .NET 10 on import**, not maintained on .NET 7/8 long term
- Aligns with Aspire, modern MediatR/MassTransit, and portfolio presentation

### Why a modernization laboratory (not a snapshot)

Patterns taught: DDD, CQRS + vertical slices, event sourcing, microservices, outbox, Polly, OpenTelemetry, Aspire, and (proposed) event-driven sagas.

**Governance from day one:** [ADR-001](ADR-001-establish-fermentflow.md) (this record) → branch ADRs 002–009 → proposed ADR-010; architecture tests from branch 02; domain unit tests + Testcontainers from branch 03.

Do **not** frame the repository as third-party courseware or an official book sample in public documentation.

## Alternatives Considered

| Alternative | Outcome |
|-------------|---------|
| Single-repo snapshot of "best practices" only | **Rejected** — hides the learning journey. |
| Greenfield toy domain (e.g. generic Todo app) | **Rejected** — too shallow for DDD, sagas, and outbox. |
| Document-only repo without runnable code | **Rejected** — decisions must be provable on buildable branches. |
| Dual .NET 8 / .NET 10 SDK requirement indefinitely | **Rejected** — port baseline to .NET 10 on `01-LegacyMonolith`. |
| Staged laboratory with ADRs + tests | **Accepted** — this repository. |

## Consequences

- **Positive:** All future architectural decisions are evaluated against the [staged learning roadmap](../01_repository-structure.md#architecture-evolution-roadmap).
- **Positive:** Documentation, ADRs, and branch names stay aligned — ADRs reinforce the roadmap rather than duplicating it.
- **Negative:** High documentation and branch-maintenance overhead before every stage has code.
- **Follow-up:** Implement **`01-LegacyMonolith`** as a **greenfield** Stage 01 monolith per [Stage 01 blueprint](../01-overview/13-stage-01-overview.md) (PostgreSQL, EF Core, intentional smells). Optional external baseline import (MongoDB, legacy branch names) is reference-only — [15-baseline-import-running.md](../01-overview/15-baseline-import-running.md). Evolve stage by stage through `09-Aspire`.
