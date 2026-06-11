# Stage 03 — Cross-Context Collaboration

How Sales and Inventory cooperate inside the **modular monolith** without recreating Stage 01 coupling.

**Canonical decision:** [ADR-012](../adr/ADR-012-cross-context-collaboration-modular-monolith.md)

**Related:** [Domain invariants](11-domain-invariants.md) · [Inventory aggregate model](12-inventory-aggregate-model.md) · [Event catalog](10-event-catalog.md) · [Architecture governance](09-architecture-governance.md)

---

## Mental model

Treat Stage 03 as a **distributed system running in a single process**. If you maintain that discipline, Stage 05 (microservices) becomes a transport swap, not a rewrite.

```text
Stage 03   Sales Handler → IInventoryReservationService (in-process)
Stage 05   Sales Handler → Inventory HTTP/gRPC client
Stage 06   + StockReserved integration event via outbox
```

---

## What not to do

### Do not query Inventory persistence from Sales

```csharp
// ❌ Stage 01 smell — weaker coupling, same boundary violation
var inventory = await inventoryReadRepository.GetByBeerId(beerId);
if (inventory.AvailableQuantity < requested) { ... }
```

Sales must not depend on Inventory repositories, `DbContext`, or read-model infrastructure.

### Do not use cross-context MediatR

```csharp
// ❌ Hidden service locator across contexts
await mediator.Send(new CheckInventoryAvailabilityQuery(...));
```

MediatR stays **within** a bounded context's vertical slices. Do not `Send` across Sales → Inventory handler boundaries.

---

## What to do

### Consumer-owned application contract

```csharp
// Sales.Application
public interface IInventoryReservationService
{
    Task<ReservationResult> ReserveForOrder(
        BeerId beerId,
        Quantity quantity,
        SalesOrderId orderId,
        CancellationToken ct);
}
```

```text
Sales.Features.CreateSalesOrder
        │
        ▼
CreateSalesOrderHandler
        │
        ▼
IInventoryReservationService  ← interface lives in Sales.Application
        │
        ▼
Inventory.Application implementation
        │
        ▼
InventoryItem.ReserveStock(quantity)
```

Registration happens in the composition root (API `Program.cs` or modular monolith host).

---

## Where invariants live

| Rule | Owner |
|------|-------|
| Cannot reserve more than available | **`InventoryItem`** |
| Order must have at least one line | **`SalesOrder`** |
| Cannot close order twice | **`SalesOrder`** |

Sales performs **orchestration** (call reservation, then create order). Inventory performs **stock authority**.

```csharp
// Inventory — final authority
inventoryItem.ReserveStock(quantity);

// Sales — only after successful reservation
var order = SalesOrder.Create(...);
```

---

## Recommended command flow

```text
CreateSalesOrder
        │
        ▼
For each line: ReserveStock
        │
        ▼
InventoryItem (invariant enforcement)
        │
        ▼
StockReserved          ← domain event (Stage 04+)
        │
        ▼
SalesOrder.Create
```

This aligns with Stage 04 event streams and Stage 06 integration events without changing the use-case story.

---

## Architecture tests (Stage 03)

Add to `FermentFlow.Architecture.Tests`:

```text
Sales must not reference Inventory.Infrastructure
Sales must not reference Inventory.Persistence types
Sales.Features must not reference Inventory.Features
```

Optional: NetArchTest rule forbidding `MediatR` usage from Sales handlers targeting Inventory assembly types.

---

## Domain unit tests

| Context | Test focus |
|---------|------------|
| **Inventory** | `InventoryItem.ReserveStock` — Given/When/Then on stock invariants |
| **Sales** | `SalesOrder.Create` — mock `IInventoryReservationService`; test order rules in isolation |

Do not test stock math inside Sales unit tests — that belongs on `InventoryItem`.

---

## Stage 05 migration checklist

When extracting microservices:

1. Keep `IInventoryReservationService` (or equivalent) as Sales boundary port
2. Replace in-process implementation with HTTP/gRPC adapter
3. Add `StockReserved` / `InventoryUpdated` to outbox (Stage 06)
4. Remove any remaining shared-database assumptions from Stage 01–02
