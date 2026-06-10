# ADR-009: Introduce Event-Driven Sagas (Future)

**Status:** Proposed  
**Branch:** `10-EventDrivenSagas` *(future — after `09-Aspire`)*  
**Date:** 2026-06-10

## Context

After branch 09, FermentFlow runs as orchestrated microservices with reliable messaging (outbox), resilience, and observability. The brewery logistics domain still has a natural **long-running workflow**:

```text
Production completed
    ↓
Inventory updated
    ↓
Stock available
    ↓
Pending sales orders released
```

Individual integration events (ADR-005) are not enough to coordinate multi-step business processes with compensations and timeouts across Sales, Inventory, and Production.

## Decision

Introduce **event-driven sagas** (choreography and/or orchestration) as stage **10-EventDrivenSagas**, **before** Kubernetes (stage 11).

Example event chain:

```text
ProductionCompleted
    ↓
InventoryUpdated
    ↓
StockAvailable
    ↓
PendingSalesOrdersReleased
```

Use MassTransit saga/state machine support (or explicit process managers) with idempotent handlers and correlation identifiers. Extend architecture tests to keep saga orchestration out of domain aggregates.

## Alternatives Considered

| Alternative | Outcome |
|-------------|---------|
| Skip sagas; rely on integration events only | **Rejected** for this stage — the domain workflow is an excellent saga teaching case. |
| Two-phase commit across services | **Rejected** — impractical at microservice scale; conflicts with event-driven lessons. |
| Jump to Kubernetes (stage 11) before sagas | **Rejected** — saga design is a richer DDD/distributed-systems exercise than deployment tooling alone. |
| Event-driven sagas at stage 10 | **Proposed** — implement after ADR-008 (Aspire) is complete. |

## Consequences

- **Positive:** Teaches long-running workflows, compensations, and correlation in a domain Swamy already models.
- **Positive:** Natural capstone before infrastructure-focused stages (Kubernetes, GitHub Actions, Azure Container Apps).
- **Negative:** Saga state persistence and failure recovery add significant complexity.
- **Follow-up:** ADR-010+ may cover Kubernetes deployment once saga behaviour is stable.
