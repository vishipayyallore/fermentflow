# ADR-011: InventoryItem as Inventory Aggregate Root

**Status:** Accepted  
**Branch:** Applies from `02-ModularMonolith`; conceptual target from `01-LegacyMonolith`  
**Date:** 2026-06-11

## Context

The Inventory bounded context (renamed from legacy `Warehouses`) must own stock lifecycle: receiving production output, reserving stock for sales, and exposing what can be sold.

Documentation previously left the aggregate name undecided (`Availability` vs `StockLevel` vs `InventoryItem`). That ambiguity blocks Stage 03 (CQRS commands), Stage 04 (event streams), Stage 06 (outbox integration events), and Stage 10 (sagas).

| Option | Problem |
|--------|---------|
| **`Availability` as aggregate** | Models a derived state, not stock lifecycle; stretches when adding reserved, damaged, or in-transit quantities |
| **`InventoryItem` as aggregate** | Richer model; aligns with event-sourced facts (`StockReceived`, `StockReserved`) |
| **Undecided** | **Rejected** — commands, events, invariants, and projections cannot be named consistently |

## Decision

Standardize on **`InventoryItem`** as the **aggregate root** of the Inventory bounded context from branch **02-ModularMonolith** onward.

Treat **`Availability`** as a **derived business concept**, not a separate aggregate:

```text
AvailableQuantity = OnHandQuantity - ReservedQuantity
```

### Stage-specific modelling

| Stage | Inventory persistence | Domain shape | Rationale |
|-------|----------------------|--------------|-----------|
| **01-LegacyMonolith** | `Availabilities` table | Anemic `Availability` entity | Intentional legacy smell; single quantity column |
| **02-ModularMonolith** | Migrate toward `InventoryItems` | `InventoryItem` aggregate with `OnHand` / `Reserved` | DDD boundaries without distribution |
| **03+** | EF Core / projections | `InventoryItem` + commands (`ReceiveStock`, `ReserveStock`, …) | CQRS and invariants on one root |
| **04+** | EventStoreDB stream per `InventoryItem` | Domain events record **why** stock changed | Event sourcing |

Stage 01 keeps a simplified legacy shape so the refactoring story remains teachable:

```text
Availabilities table (Stage 01)
        ↓
InventoryItem aggregate (Stage 02)
        ↓
Event-sourced InventoryItem (Stage 04)
        ↓
Inventory microservice (Stage 05)
```

### Target aggregate (branch 02+)

```text
InventoryItem
├── BeerId
├── BeerName
├── OnHandQuantity
├── ReservedQuantity
└── AvailableQuantity  (= OnHand - Reserved, derived, not persisted separately)
```

### Invariants

| Rule | Constraint |
|------|------------|
| Non-negative on-hand | `OnHandQuantity >= 0` |
| Non-negative reserved | `ReservedQuantity >= 0` |
| Reservation cap | `ReservedQuantity <= OnHandQuantity` |
| Derived availability | `AvailableQuantity >= 0` |
| Identity | One `InventoryItem` per beer (extend with location later if needed) |

### Commands (branch 03+)

```text
ReceiveStock
ReserveStock
ReleaseStockReservation
AdjustInventory
```

### Domain events (branch 04+)

```text
StockReceived
StockReserved
StockReservationReleased
InventoryAdjusted
```

### Integration events (branch 05+)

```text
InventoryUpdated
StockAvailable
StockUnavailable
```

Baseline import code may still use legacy names (`Availability`, `AvailabilityChanged`) — documented separately in [Event catalog](../01-overview/10-event-catalog.md) under **Baseline import only**.

## Alternatives Considered

| Alternative | Outcome |
|-------------|---------|
| Keep `Availability` as aggregate through all stages | **Rejected** — poor fit for reservations, event facts, and saga orchestration. |
| Introduce `InventoryItem` only at Stage 04 | **Rejected** — Stage 03 domain unit tests need a stable aggregate before event sourcing. |
| `StockLevel` as aggregate name | **Rejected** — `InventoryItem` better expresses a trackable product-stock lifecycle. |
| `InventoryItem` aggregate; `Availability` derived | **Accepted** — this record. |

## Consequences

- **Positive:** Commands, domain events, integration events, invariants, and sagas share one vocabulary.
- **Positive:** Stage 01 legacy `Availability` entity becomes an explicit refactoring target for Stage 02.
- **Negative:** Stage 02 introduces a schema/entity rename from `Availabilities` to `InventoryItems` (intentional learning step).
- **Follow-up:** Update [Ubiquitous language](../01-overview/04-ubiquitous-language.md), [Domain invariants](../01-overview/11-domain-invariants.md), [Event catalog](../01-overview/10-event-catalog.md), and [Branch roadmap](../01-overview/08-branch-roadmap.md) Inventory feature slices.

**Teaching reference:** [Inventory aggregate model](../01-overview/12-inventory-aggregate-model.md)
