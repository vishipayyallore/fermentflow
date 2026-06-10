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

Introduce **event-driven sagas** as stage **10-EventDrivenSagas**, **before** Kubernetes (stage 11).

| Aspect | Choice |
|--------|--------|
| **Saga style** | **Orchestration** (explicit process manager / state machine) |
| **Technology** | **MassTransit state machine** on existing RabbitMQ |
| **Stage** | `10-EventDrivenSagas` |
| **Fit** | MassTransit + RabbitMQ + Aspire (branch 09) |

Example orchestrated flow:

```text
ProductionCompleted
        ↓
InventoryUpdated
        ↓
InventoryAvailable
        ↓
ReleasePendingSalesOrders
```

Use correlation identifiers, idempotent handlers, and persisted saga state. Extend architecture tests to keep saga orchestration out of domain aggregates.

## Alternatives Considered

| Alternative | Outcome |
|-------------|---------|
| Choreography-only sagas (no orchestrator) | **Rejected for stage 10** — harder to trace; orchestration is the clearer teaching path with MassTransit. |
| Skip sagas; rely on integration events only | **Rejected** — the Production → Inventory → Sales flow is the richest distributed-systems exercise in this domain. |
| Two-phase commit across services | **Rejected** — impractical at microservice scale. |
| Jump to Kubernetes before sagas | **Rejected** — saga design is more valuable than deployment tooling alone. |
| MassTransit orchestration at stage 10 | **Proposed** — implement after ADR-008 (Aspire) is complete. |

## Consequences

- **Positive:** Teaches long-running workflows, compensations, and correlation in a domain Swamy already models.
- **Positive:** Natural capstone before infrastructure-focused stages (Kubernetes, GitHub Actions, Azure Container Apps).
- **Negative:** Saga state persistence and failure recovery add significant complexity.
- **Follow-up:** ADR-010+ may cover Kubernetes deployment once saga behaviour is stable.
