# Stage 03 — Cross-Context Collaboration

How Sales and Inventory cooperate inside the **modular monolith** without recreating Stage 01 coupling — and how to handle partial failure without `TransactionScope`.

**Canonical decisions:** [ADR-012](../adr/ADR-012-cross-context-collaboration-modular-monolith.md) · [ADR-013](../adr/ADR-013-compensating-actions-stage-03.md)

**Related:** [Domain invariants](11-domain-invariants.md) · [Inventory aggregate model](12-inventory-aggregate-model.md) · [Event catalog](10-event-catalog.md) · [Architecture governance](09-architecture-governance.md)

---

## Mental model

Treat Stage 03 as a **distributed system in a single process**. Stage 05 swaps transport; Stage 06 adds outbox; Stage 10 adds saga orchestration — **the business steps do not change**.

```text
Reserve Inventory → Create Order → (on failure) Release Reservation
```

---

## What not to do

### Do not query Inventory persistence from Sales

```csharp
// ❌ Stage 01 smell
var inventory = await inventoryReadRepository.GetByBeerId(beerId);
```

### Do not use cross-context MediatR

```csharp
// ❌ MediatR as distributed service locator
await mediator.Send(new CheckInventoryAvailabilityQuery(...));
```

MediatR is **intra-context only**. Architecture tests must enforce this from Stage 03.

### Do not use TransactionScope across contexts

```csharp
// ❌ False autonomy — must be removed at Stage 06
using var scope = new TransactionScope(...);
await ReserveStock(...);
await CreateOrder(...);
scope.Complete();
```

Even if both contexts share a database in early branches, **do not** teach cross-context atomicity as the strategic solution.

---

## Application contract (consumer-owned)

```csharp
// Sales.Application
public interface IInventoryReservationService
{
    Task<InventoryReservationResult> ReserveStockAsync(
        BeerId beerId, Quantity quantity, CancellationToken ct);

    Task ReleaseStockReservationAsync(
        ReservationId reservationId, CancellationToken ct);
}
```

```text
Sales.Application  →  interface
Inventory.Application  →  implementation  →  InventoryItem
```

---

## Compensating action flow (ghost reservation)

```text
CreateSalesOrderHandler
        │
        ├─► ReserveStockAsync → ReservationId
        │
        ├─► SalesOrder.Create(reservationId, ...)
        │
        ├─► Save Sales (unit of work — Sales context only)
        │
        └─ on failure after reserve:
              ReleaseStockReservationAsync(reservationId)
```

Example handler structure:

```csharp
public async Task<Guid> Handle(
    CreateSalesOrderCommand command,
    CancellationToken cancellationToken)
{
    InventoryReservationResult? reservation = null;

    try
    {
        reservation = await _inventoryReservationService.ReserveStockAsync(
            command.BeerId, command.Quantity, cancellationToken);

        var order = SalesOrder.Create(
            reservation.ReservationId,
            command.CustomerId,
            command.Lines);

        await _salesOrderRepository.AddAsync(order, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return order.Id;
    }
    catch
    {
        if (reservation is not null)
        {
            await _inventoryReservationService.ReleaseStockReservationAsync(
                reservation.ReservationId, cancellationToken);
        }

        throw;
    }
}
```

---

## First-class `InventoryReservation`

Do not reserve stock as anonymous quantity deltas.

```text
InventoryItem
 ├── OnHandQuantity
 ├── ReservedQuantity
 └── Reservations[]     ← InventoryReservation (ReservationId, BeerId, Quantity, …)
```

Compensation:

```csharp
inventoryItem.ReleaseReservation(reservationId);  // idempotent
```

Benefits: idempotency, auditability, clean path to `StockReservationReleased` (Stage 04) and outbox (Stage 06).

---

## Where invariants live

| Rule | Owner |
|------|-------|
| Cannot reserve more than available | **`InventoryItem`** |
| Reservation identity and release | **`InventoryReservation`** / **`InventoryItem`** |
| Order line and lifecycle rules | **`SalesOrder`** |

---

## Consistency evolution (same behaviour, different mechanism)

| Stage | Mechanism |
|-------|-----------|
| 01–02 | Single DB transaction (smell) |
| **03** | Handler compensation |
| 04 | Workflow + domain events |
| 06 | Outbox + integration events |
| 10 | Saga process manager |

---

## Architecture tests (Stage 03)

```text
Sales must not reference Inventory.Infrastructure
Sales must not reference Inventory DbContext or repositories
Sales.Features must not reference Inventory.Features
Sales.Application must not reference Inventory.Application types
   (except via consumer-owned interfaces registered at composition root)
Sales must not invoke IMediator across bounded-context assemblies
```

---

## Domain unit tests

| Context | Focus |
|---------|-------|
| **Inventory** | `ReserveStock`, `ReleaseReservation`, invariants on `InventoryItem` |
| **Sales** | `SalesOrder.Create`; mock `IInventoryReservationService`; test compensation path |

---

## Stage 05+ migration

1. Keep `IInventoryReservationService` as Sales port
2. Replace in-process adapter with HTTP/gRPC (Stage 05)
3. Publish `StockReserved` / `StockReservationReleased` via outbox (Stage 06)
4. Promote orchestration to saga state machine when appropriate (Stage 10)
