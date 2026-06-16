# ADR-012: Promote Production to Full Bounded Context

**Status:** Accepted  
**Branch:** Physical module from `02-ModularMonolith`; full lifecycle from `05-Microservices`  
**Date:** 2026-06-11

## Context

Brewery logistics naturally includes **Production** — brewing batches that create stock consumed by **Inventory** and sold through **Sales**.

In Stage 01, Production appears only as a DTO and a thin API endpoint that updates inventory directly. That is intentional legacy smell. Without an explicit decision, documentation scatters “contracts only” vs “full bounded context” across multiple files.

## Decision

Promote **Production** to a **first-class bounded context** on the greenfield path:

| Stage | Git branch | Production shape |
|-------|------------|------------------|
| **01** | `01-LegacyMonolith` | `ProductionOrderDto` + `POST /api/production/completed` — no Production module; updates Inventory directly (smell) |
| **02** | `02-ModularMonolith` | Physical `FermentFlow.Production.{Domain,Application,Infrastructure}` module inside modular monolith |
| **03–04** | `03`–`04` | CQRS features: `CreateProductionOrder`, `StartProductionBatch`, `CompleteProductionBatch` |
| **05** | `05-Microservices` | Separate deployable `FermentFlow.Production` service with own PostgreSQL database |
| **06+** | `06`–`09` | `ProductionCompleted` integration event via outbox; consumed by Inventory (`ReceiveStock`) |

### Integration flow (target)

```text
ProductionOrderCompleted  (domain, Production)
        ↓  outbox (Stage 06)
ProductionCompleted       (integration)
        ↓
Inventory.ReceiveStock    → StockReceived (domain)
```

### What Stage 01 deliberately does *not* have

- No `FermentFlow.Production` projects
- No `ProductionOrder` aggregate
- No domain events from production
- Production endpoint mutates Inventory persistence directly

That gap is the motivation for Stage 02 boundaries and Stage 05 decomposition.

## Alternatives Considered

| Alternative | Outcome |
|-------------|---------|
| Production remains external/contracts forever | **Rejected** — hides core domain flow; sagas (Stage 10) need a Production context. |
| Full Production microservice at Stage 02 | **Rejected** — skips modular monolith learning. |
| Promote to physical module at 02, deployable at 05 | **Accepted** — matches nine-stage roadmap. |
| Shared Production tables in Sales or Inventory DB | **Rejected** — violates context ownership; forbidden from Stage 05 per database fitness function. |

## Consequences

- **Positive:** `Production → Inventory → Sales` is enforceable in architecture tests from Stage 02.
- **Positive:** Event catalog and saga design have a clear Production event source.
- **Negative:** Stage 02 adds a third context module before CQRS — more projects to navigate.
- **Follow-up:** Implement `ProductionOrder` aggregate and invariants from Stage 05; Stage 02–04 may use thinner production models until then.

**Related:** [ADR-001](ADR-001-introduce-modular-monolith.md) · [Business domain](../01-overview/02-business-domain.md) · [Event catalog](../01-overview/10-event-catalog.md)
