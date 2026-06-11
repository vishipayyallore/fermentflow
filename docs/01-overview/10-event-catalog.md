# Event Catalog

Cross-context catalog of **domain events**, **integration events**, and **saga events** in FermentFlow. Populated as branches 03–10 introduce event types.

**Related:** [Business domain](02-business-domain.md) · [Domain invariants](11-domain-invariants.md) · [ADR-003](../adr/ADR-003-introduce-event-sourcing.md) · [ADR-005](../adr/ADR-005-introduce-outbox.md) · [ADR-009](../adr/ADR-009-introduce-event-driven-sagas.md)

---

## Legend

| Kind | Scope | Persisted in | Published via |
|------|-------|--------------|---------------|
| **Domain** | Inside one bounded context | EventStoreDB (branch 04+) | Projections, optional integration mapping |
| **Integration** | Cross bounded context | PostgreSQL outbox (branch 06+) | RabbitMQ / MassTransit |
| **Saga** | Long-running workflow (stage 10) | PostgreSQL saga state | MassTransit state machine |

---

## Sales context

| Type | Event | Introduced | Notes |
|------|-------|------------|-------|
| Domain | `SalesOrderCreated` | Branch 03 | Aggregate raised when order is placed |
| Domain | `SalesOrderClosed` | Branch 03 | Order lifecycle complete |
| Integration | `OrderPlaced` | Branch 04+ | Cross-context notification (name TBD on implementation) |
| Integration | `OrderConfirmed` | Branch 04+ | Stock validated and order accepted |

---

## Inventory context

*(Target name; baseline import uses `Warehouses`.)*

| Type | Event | Introduced | Notes |
|------|-------|------------|-------|
| Domain | `AvailabilityChanged` | Branch 03+ | Stock level updated within aggregate |
| Domain | `AvailabilityUpdatedDueToProductionOrder` | Baseline import | Production-driven stock increase |
| Domain | `AvailabilityUpdatedForNotification` | Baseline import | Triggers Sales read-model sync |
| Integration | `InventoryUpdated` | Branch 04+ | Stock change visible to other contexts |
| Integration | `StockProduced` | Branch 05+ | Production batch reflected in inventory |

---

## Production context

| Type | Event | Introduced | Notes |
|------|-------|------------|-------|
| Domain | `ProductionOrderStarted` | Branch 05+ | Full bounded context (target) |
| Domain | `ProductionOrderCompleted` | Branch 05+ | Batch ready for inventory |
| Integration | `ProductionCompleted` | Branch 05+ | Triggers inventory update in saga flow |

---

## Saga events (stage 10 — proposed)

Orchestration via MassTransit state machine — see [ADR-009](../adr/ADR-009-introduce-event-driven-sagas.md).

| Type | Event | Correlates |
|------|-------|------------|
| Saga | `ProductionCompleted` | Start of Production → Inventory → Sales flow |
| Saga | `InventoryUpdated` | Inventory aggregate processed production output |
| Saga | `InventoryAvailable` | Stock ready for sale |
| Saga | `PendingSalesReleased` | Back-ordered or pending sales orders released |

Example orchestrated sequence:

```text
ProductionCompleted → InventoryUpdated → InventoryAvailable → ReleasePendingSalesOrders
```

---

## Maintenance

When adding a new event on a branch:

1. Add a row to the appropriate context table above
2. Classify as **Domain**, **Integration**, or **Saga**
3. Note the introducing branch
4. Extend [domain invariants](11-domain-invariants.md) if the event implies new aggregate rules
5. Add architecture tests if the event must not be published directly from domain handlers (integration events → outbox only, branch 06+)
