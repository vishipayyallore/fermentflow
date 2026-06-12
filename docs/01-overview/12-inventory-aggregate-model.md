# Inventory Aggregate Model

Teaching reference for the Inventory bounded context aggregate decision. **Canonical decision:** [ADR-010](../adr/ADR-010-inventory-item-aggregate-root.md).

**Related:** [Ubiquitous language](04-ubiquitous-language.md) · [Domain invariants](11-domain-invariants.md) · [Event catalog](10-event-catalog.md) · [Business domain](02-business-domain.md)

---

## Why this decision matters

The aggregate choice drives every downstream pattern:

| Concern | Driven by aggregate |
|---------|---------------------|
| Command names | `ReceiveStock` vs `SetAvailability` |
| Domain events | `StockReceived` vs `AvailabilityChanged` |
| Invariants | On-hand vs reserved vs derived available |
| Event streams | One stream per `InventoryItem` (Stage 04) |
| Integration events | `InventoryUpdated` payload shape |
| Saga steps | Production → reserve → release across contexts |

An **`Availability`** aggregate models *whether* beer can be sold. An **`InventoryItem`** aggregate models *why* stock changed — the fact event sourcing needs.

---

## Target model (branch 02+)

```text
Inventory Context
     │
     └── InventoryItem (Aggregate Root)
              ├── BeerId
              ├── BeerName
              ├── OnHandQuantity
              ├── ReservedQuantity
              ├── AvailableQuantity  → derived: OnHand - Reserved
              └── Reservations[]     → InventoryReservation (Stage 03+)
```

`InventoryReservation` is a first-class concept — compensation uses `ReleaseReservation(reservationId)`, not anonymous stock bumps ([ADR-013](../adr/ADR-013-compensating-actions-stage-03.md)).

**Availability** is not persisted as its own aggregate. Queries that answer “how much can we sell?” project `AvailableQuantity`.

---

## Stage evolution

```text
Stage 01   Anemic Availability entity + Availabilities table
              ↓  (intentional smell)
Stage 02   InventoryItem aggregate inside Inventory module
              ↓
Stage 03   Commands enforce invariants; domain unit tests
              ↓
Stage 04   Event stream: StockReceived, StockReserved, …
              ↓
Stage 05   Inventory deployable; integration events via outbox (Stage 06)
```

---

## Invariants

See [Domain invariants — InventoryItem](11-domain-invariants.md#inventoryitem).

---

## Commands and events (target)

### Commands (branch 03+)

| Command | Effect |
|---------|--------|
| `ReceiveStock` | Increase `OnHandQuantity` (production completed, adjustment) |
| `ReserveStock` | Increase `ReservedQuantity` when Sales holds stock for an order |
| `ReleaseStockReservation` | Decrease `ReservedQuantity` (order cancelled or fulfilled) |
| `AdjustInventory` | Correct on-hand quantity (shrinkage, recount) |

### Domain events (branch 04+)

| Event | Business fact |
|-------|---------------|
| `StockReceived` | Stock entered inventory (e.g. batch completed) |
| `StockReserved` | Quantity reserved for a sales order |
| `StockReservationReleased` | Reservation cancelled or converted to shipment |
| `InventoryAdjusted` | Manual or system adjustment to on-hand |

Prefer these over generic `AvailabilityChanged` — the event name should explain **why** quantity moved.

### Integration events (branch 05+)

| Event | Consumers |
|-------|-----------|
| `InventoryUpdated` | Sales read models, saga orchestrator |
| `StockAvailable` | Signal that a beer can be sold again |
| `StockUnavailable` | Signal insufficient stock for pending demand |

---

## Legacy baseline import (reference only)

Imported baseline branches use `Warehouses` context naming and `Availability` as aggregate with Muflone-oriented events (`AvailabilityUpdatedDueToProductionOrder`). Those names are preserved in [03-architecture-evolution.md](03-architecture-evolution.md) for historical comparison — **not** the target FermentFlow greenfield path.

---

## Sales interaction

| Stage | Pattern |
|-------|---------|
| 01 | `SalesOrderService` calls `InventoryRepository` directly (smell) |
| 02–05 | Application services within modular monolith; no cross-context infrastructure references |
| 05+ | Separate services; async integration events + optional sync stock check (Stage 07 circuit breaker) |
| 10 | Saga orchestrates Production → Inventory → Sales |

Stock validation invariant on `SalesOrder`: line quantity must not exceed `AvailableQuantity` for each beer.
