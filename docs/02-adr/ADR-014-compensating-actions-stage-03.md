# ADR-014: Compensating Actions in Stage 03

**Status:** Accepted  
**Branch:** `03-CQRS-VerticalSlices` (precursor to outbox/saga at Stages 06–10)  
**Date:** 2026-06-11

## Context

[ADR-013](ADR-013-cross-context-collaboration-modular-monolith.md) defines how Sales and Inventory collaborate through application contracts. A second pressure point remains: **what happens when reservation succeeds but order creation fails?**

Two approaches compete:

| Approach | Appeal | Hidden cost |
|----------|--------|-------------|
| **Shared `TransactionScope`** across Sales + Inventory | Atomic commit feels safe | Models wrong autonomy; breaks when contexts split; must be ripped out at Stage 06 |
| **Compensating action** (`ReleaseReservation`) | Matches future saga/outbox | Requires explicit failure handling now |

The **ghost reservation** problem (stock reserved, order never created) is exactly the failure mode microservices expose. FermentFlow should confront it at Stage 03 while the system is still a modular monolith.

## Decision

### 1. No shared TransactionScope across bounded contexts (Stage 03+)

Do **not** wrap `ReserveStock` and `CreateSalesOrder` in a single distributed or ambient transaction spanning Sales and Inventory persistence.

```text
❌ Begin Transaction → Reserve Inventory → Create Sales Order → Commit
```

Bounded contexts remain **operationally autonomous** even when deployed together. Stages 01–02 may use a single database transaction inside one monolith — that is a documented smell, not the Stage 03 target.

### 2. Mini-saga with explicit compensation in the Sales handler

```text
1. ReserveStock (Inventory) → returns ReservationId
2. SalesOrder.Create (Sales)
3. Save Sales order

On failure after step 1:
   ReleaseStockReservation(ReservationId)
```

Business behaviour is stable across stages; only the mechanism evolves:

| Stage | Consistency mechanism |
|-------|----------------------|
| 01–02 | Single DB transaction (intentional smell) |
| **03** | Compensation in command handler |
| 04 | Compensation in application workflow; domain events recorded |
| 06 | Outbox + integration events |
| 10 | Saga / process manager |

### 3. First-class `InventoryReservation` (not anonymous quantity bumps)

Reservations are identifiable business facts, not opaque counter adjustments.

```text
InventoryItem
 ├── OnHandQuantity
 ├── ReservedQuantity
 └── Reservations[]          ← InventoryReservation entities
```

Compensation is:

```csharp
ReleaseReservation(reservationId);  // idempotent, auditable
```

not:

```csharp
IncreaseStock(quantity);  // ❌ loses identity and audit trail
```

`InventoryReservation` carries at minimum: `ReservationId`, `BeerId`, `Quantity`, correlating `SalesOrderId` (or correlation token), and lifecycle state.

### 4. Application contract shape

```csharp
// Sales.Application — consumer owns interface
public interface IInventoryReservationService
{
    Task<InventoryReservationResult> ReserveStockAsync(
        BeerId beerId, Quantity quantity, CancellationToken ct);

    Task ReleaseStockReservationAsync(
        ReservationId reservationId, CancellationToken ct);
}
```

`InventoryReservationResult` includes `ReservationId` for compensation.

## Alternatives Considered

| Alternative | Outcome |
|-------------|---------|
| `TransactionScope` across Sales + Inventory (Stage 03) | **Rejected** — false autonomy; breaking change at Stage 06; hides ghost-reservation problem. |
| Hope single SaveChanges is enough (shared DbContext) | **Rejected** — still couples persistence; wrong constraint for Stage 05 split. |
| Anonymous reserve/unreserve by quantity | **Rejected** — not idempotent; poor audit trail; hard to migrate to events. |
| Compensation + `InventoryReservation` entity | **Accepted** — this record. |
| Full saga orchestrator at Stage 03 | **Rejected** — premature; ADR-010 at Stage 10. |

## Consequences

- **Positive:** Same workflow vocabulary from Stage 03 through Stage 10.
- **Positive:** Ghost-reservation handling is practiced before network partitions.
- **Positive:** `ReleaseReservation(reservationId)` maps cleanly to `StockReservationReleased` events and outbox messages.
- **Negative:** Sales handler gains orchestration + try/catch compensation logic.
- **Follow-up:** Model `InventoryReservation` in [Domain invariants](../01-overview/11-domain-invariants.md); teach in [16-stage-03-cross-context-collaboration.md](../01-overview/16-stage-03-cross-context-collaboration.md).

**Related:** [ADR-013](ADR-013-cross-context-collaboration-modular-monolith.md) · [ADR-011](ADR-011-inventory-item-aggregate-root.md) · [ADR-010](ADR-010-introduce-event-driven-sagas.md)
