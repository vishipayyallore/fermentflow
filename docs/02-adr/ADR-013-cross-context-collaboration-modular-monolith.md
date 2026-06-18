# ADR-013: Cross-Context Collaboration in Modular Monolith

**Status:** Accepted  
**Branch:** `03-CQRS-VerticalSlices` (contracts from `02-ModularMonolith`; HTTP/events from `05-Microservices`)  
**Date:** 2026-06-11

## Context

Stage 03 introduces `CreateSalesOrder` — a Sales command that must respect inventory stock. The architectural pressure point: **how does Sales learn whether stock is available without recreating Stage 01 coupling?**

Three tempting approaches each fail a governance goal:

| Approach | Problem |
|----------|---------|
| Sales queries Inventory **read model / repository** directly | Recreates `Sales → Inventory persistence` coupling; violates Branch 02 infrastructure isolation |
| Sales sends **MediatR query** to Inventory handler | Hidden application-layer service locator; `Sales Handler → Inventory Handler → …` chains |
| Sales **duplicates** stock rules in its handler | Wrong aggregate owns the invariant; diverges from `InventoryItem` authority |

Stage 03 must solve cross-context consistency **while treating the modular monolith as a distributed system in a single process** — so Stage 05 replaces transport, not use-case shape.

## Decision

### 1. Application-layer contracts owned by the consumer

Sales defines what it needs; Inventory implements it.

```csharp
// Sales.Application — consumer owns the abstraction
public interface IInventoryReservationService
{
    Task<InventoryReservationResult> ReserveStockAsync(
        BeerId beerId, Quantity quantity, CancellationToken ct);

    Task ReleaseStockReservationAsync(
        ReservationId reservationId, CancellationToken ct);
}
```

```text
Sales.Application
    ↓ depends on interface
Inventory.Application
    ↓ implements via application service
InventoryItem aggregate
```

**Forbidden from Sales (Stages 02–04):**

- `Inventory.Infrastructure` references
- Inventory `DbContext`, repositories, or read-model queries
- Cross-context MediatR `Send` to Inventory query/command handlers

**Allowed:**

- Interfaces and DTOs in `Sales.Application` (or a thin `Sales.Contracts` assembly if preferred)
- Implementation registered in composition root from `Inventory.Application`

### 2. InventoryItem is the invariant authority

The rule *cannot reserve more than available* belongs to **Inventory**, not Sales.

```csharp
inventoryItem.ReserveStock(quantity);  // throws or returns failure — final authority
```

**Reservation** (`ReserveStock`) is the consistency gate before `SalesOrder` is created. On failure after reserve, **compensate** via `ReleaseStockReservationAsync` — see [ADR-014](ADR-014-compensating-actions-stage-03.md). Do **not** use `TransactionScope` across contexts.

### 3. Preferred Stage 03 use-case flow

Model collaboration, not validation-then-create in isolation:

```text
CreateSalesOrderCommand
        │
        ▼
CreateSalesOrderHandler
        │
        ├──► ReserveStock (via IInventoryReservationService or equivalent)
        │         │
        │         ▼
        │    InventoryItem.ReserveStock
        │         │
        │         ▼
        │    StockReserved (domain event, Stage 04+)
        │
        └──► SalesOrder.Create(...)   // only after successful reservation
```

Even inside one deployable, the mental model is **two contexts collaborating through application contracts**.

### 4. Evolution by stage

| Stage | Mechanism |
|-------|-----------|
| **03** | In-process `IInventoryReservationService`; compensation on failure ([ADR-014](ADR-014-compensating-actions-stage-03.md)) |
| **05** | Replace with HTTP/gRPC client to Inventory service; same interface shape at Sales boundary |
| **06** | `StockReserved` / `InventoryUpdated` integration events via outbox; async read-model sync where needed |

The use case stays stable; only transport changes.

## Alternatives Considered

| Alternative | Outcome |
|-------------|---------|
| Direct Inventory read-repository from Sales handler | **Rejected** — infrastructure leakage; Stage 01 smell in new clothes. |
| Cross-context MediatR queries | **Rejected** — obscures boundaries; encourages handler chains. |
| Shared database join in Sales query | **Rejected** — violates modular monolith boundaries. |
| Application service contract; Inventory owns invariants | **Accepted** — this record. |
| Saga orchestration at Stage 03 | **Rejected** — premature; Stage 10 after outbox and microservices. |

## Consequences

- **Positive:** Stage 05 microservice extraction is largely mechanical (swap implementation for remote client).
- **Positive:** Architecture tests can enforce “Sales never references Inventory.Infrastructure.”
- **Positive:** Aligns with `ReserveStock` → `StockReserved` → future integration events.
- **Negative:** Requires composition-root registration of cross-context services; more wiring than a direct repository call.
- **Follow-up:** [ADR-014](ADR-014-compensating-actions-stage-03.md) (`InventoryReservation`, compensation). Document in [16-stage-03-cross-context-collaboration.md](../01-overview/16-stage-03-cross-context-collaboration.md).

**Related:** [ADR-003](ADR-003-introduce-cqrs.md) · [ADR-011](ADR-011-inventory-item-aggregate-root.md) · [ADR-014](ADR-014-compensating-actions-stage-03.md) · [Architecture governance](../01-overview/09-architecture-governance.md)
