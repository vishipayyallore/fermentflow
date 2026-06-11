# Event Catalog

Cross-context catalog of **domain events**, **integration events**, and **saga events** in FermentFlow. Populated as branches 03–10 introduce event types.

**Related:** [Business domain](02-business-domain.md) · [Domain invariants](11-domain-invariants.md) · [Inventory aggregate model](12-inventory-aggregate-model.md) · [ADR-003](../adr/ADR-003-introduce-event-sourcing.md) · [ADR-005](../adr/ADR-005-introduce-outbox.md) · [ADR-009](../adr/ADR-009-introduce-event-driven-sagas.md) · [ADR-010](../adr/ADR-010-inventory-item-aggregate-root.md)

---

## Legend

| Kind | Scope | Persisted in | Published via |
|------|-------|--------------|---------------|
| **Domain** | Inside one bounded context | EventStoreDB (branch 04+) | Projections, optional integration mapping |
| **Integration** | Cross bounded context | PostgreSQL outbox (branch 06+) | RabbitMQ / MassTransit |
| **Saga** | Long-running workflow (stage 10) | PostgreSQL saga state | MassTransit state machine |

**Naming principle:** Domain events record **business facts** (`StockReceived`), not opaque state deltas (`AvailabilityChanged`).

---

## Domain event → integration event mapping (Stage 06+)

From **Stage 06 (Outbox)**, domain events do not cross context boundaries directly. An integration mapper writes to the **outbox** in the same PostgreSQL transaction as the projection or application state; a worker publishes **integration events** to RabbitMQ/MassTransit.

```text
Domain Event (EventStoreDB / aggregate)
        ↓
Integration event mapper (Application layer)
        ↓
Outbox row (PostgreSQL, same transaction)
        ↓
Outbox worker → MassTransit publish
        ↓
Integration Event (cross-context)
```

| Domain event | Source context | Integration event | Notes |
|--------------|----------------|-------------------|-------|
| `StockReceived` | Inventory | `InventoryUpdated` | Stock entered inventory |
| `StockReserved` | Inventory | `InventoryUpdated` | Reservation changed |
| `StockReservationReleased` | Inventory | `InventoryUpdated` | Reservation released |
| `InventoryAdjusted` | Inventory | `InventoryUpdated` | On-hand correction |
| *(derived)* `AvailableQuantity > 0` after change | Inventory | `StockAvailable` | Optional; may batch with `InventoryUpdated` |
| *(derived)* insufficient stock for demand | Inventory | `StockUnavailable` | Optional signal to Sales |
| `ProductionOrderCompleted` | Production | `ProductionCompleted` | Triggers Inventory `ReceiveStock` handler |
| `SalesOrderCreated` | Sales | `OrderPlaced` | Notify downstream contexts |
| `SalesOrderClosed` | Sales | `OrderConfirmed` | Order accepted / fulfilled |

**Stage 05** may publish integration events directly (at-least-once risk). **Stage 06** replaces direct publish with outbox for all rows above.

---

## Sales context

| Type | Event | Introduced | Notes |
|------|-------|------------|-------|
| Domain | `SalesOrderCreated` | Stage 03 | Raised after successful `ReserveStock` and order aggregate creation |
| Domain | `SalesOrderClosed` | Branch 03 | Order lifecycle complete |
| Integration | `OrderPlaced` | Branch 05+ | Cross-context notification |
| Integration | `OrderConfirmed` | Branch 05+ | Stock validated and order accepted |

---

## Inventory context (target)

Aggregate: **`InventoryItem`** ([ADR-010](../adr/ADR-010-inventory-item-aggregate-root.md)).

| Type | Event | Introduced | Notes |
|------|-------|------------|-------|
| Domain | `StockReceived` | Branch 04 | Production or adjustment increased on-hand |
| Domain | `StockReserved` | Branch 04 | Quantity reserved for a sales order |
| Domain | `StockReservationReleased` | Branch 04 | Reservation cancelled or fulfilled |
| Domain | `InventoryAdjusted` | Branch 04 | Manual or system on-hand correction |
| Integration | `InventoryUpdated` | Branch 05+ | Stock change visible to other contexts |
| Integration | `StockAvailable` | Branch 05+ | Beer can be sold (derived availability > 0) |
| Integration | `StockUnavailable` | Branch 05+ | Insufficient stock for demand |
| Integration | `StockProduced` | Branch 05+ | Production batch reflected in inventory (from Production context) |

### Baseline import only (legacy `Warehouses` / Muflone)

Not used on the greenfield nine-stage path. Preserved for [architecture evolution](03-architecture-evolution.md) comparison:

| Type | Event | Notes |
|------|-------|-------|
| Domain | `AvailabilityUpdatedDueToProductionOrder` | Legacy production-driven stock increase |
| Domain | `AvailabilityUpdatedForNotification` | Legacy Sales read-model sync trigger |

---

## Production context

| Type | Event | Introduced | Notes |
|------|-------|------------|-------|
| Domain | `ProductionOrderStarted` | Branch 05+ | Full bounded context lifecycle |
| Domain | `ProductionOrderCompleted` | Branch 05+ | Batch ready for inventory |
| Integration | `ProductionCompleted` | Branch 05+ | Triggers `ReceiveStock` / saga flow |

---

## Saga events (stage 10 — proposed)

Orchestration via MassTransit state machine — see [ADR-009](../adr/ADR-009-introduce-event-driven-sagas.md).

| Type | Event | Correlates |
|------|-------|------------|
| Saga | `ProductionCompleted` | Start of Production → Inventory → Sales flow |
| Saga | `InventoryUpdated` | `InventoryItem` processed production output |
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
