# Business Domain

## Core Domain

**Brewery Logistics Management** — coordinating the sale of beer products with inventory availability and production output.

```text
Production → Inventory → Sales
```

---

## Current state vs target state

FermentFlow documentation describes both the **imported baseline** (legacy branches) and the **target architecture** (nine-branch roadmap). They differ mainly in context boundaries and naming.

| Aspect | Current state (baseline import) | Target state (branch 02 onward) |
|--------|--------------------------------|----------------------------------|
| **Production** | Stage 01: DTO/endpoint only (smell) | **Full bounded context** from Stage 02 module — [ADR-011](../adr/ADR-011-promote-production-bounded-context.md) |
| **Inventory** | Named `Warehouses` in baseline import | **Inventory** context with **`InventoryItem`** aggregate; **Availability** is derived (`OnHand - Reserved`) — [ADR-010](../adr/ADR-010-inventory-item-aggregate-root.md) |
| **Sales** | Core context | Core context (unchanged role) |
| **Integration** | Direct calls (branch 01) → events (branch 04+) | Production → Inventory → Sales via integration events and sagas (stage 10+) |

See [Modernization vision](07-fermentflow-modernization-vision.md) and [Business flow target](#target-context-map-branch-02).

---

## Business Capabilities

The system supports these major capabilities:

- **Create Sales Orders** — customers place orders for beer products
- **Manage Inventory** — `InventoryItem` aggregates track on-hand and reserved stock; **availability** is derived
- **Check Beer Availability** — validate that ordered beers are in stock
- **Produce Beer** — production batches create or update inventory (full context from branch 02 target)
- **Generate Read Models** — query-optimized views for reporting and UI

---

## Subdomains

### Baseline import (branch 01)

| Subdomain | Type | Purpose | Bounded Context |
|-----------|------|---------|-----------------|
| **Sales** | Core | Customer order management | `Sales` |
| **Warehouse** | Core | Inventory and availability | `Warehouses` (legacy name) |
| **Production** | Supporting | Beer manufacturing triggers | **External (contracts only)** |
| **Read Model** | Generic | Query-optimized projections | Per-context `ReadModel` |
| **Shared Kernel** | Shared | Common types and contracts | `FermentFlow.Shared` |

### Target state (branch 02 onward)

| Subdomain | Type | Purpose | Bounded Context |
|-----------|------|---------|-----------------|
| **Sales** | Core | Customer orders, order lifecycle | `FermentFlow.Sales` |
| **Inventory** | Core | `InventoryItem` lifecycle — on-hand, reserved, derived availability | `FermentFlow.Inventory` |
| **Production** | Core | Brewing batches, production orders | `FermentFlow.Production` |

---

## Context maps

### Baseline — branch 01 (legacy monolith)

Contexts are **logical only** — shared code, database, and repositories:

```text
+----------------+
|     Sales      |  (logical subdomain)
+----------------+
        |
        | direct repository call
        v
+----------------+
|   Warehouse    |  (logical subdomain)
+----------------+
        |
        | triggered by
        v
+----------------+
|   Production   |  (external, contracts only)
+----------------+
```

### Target context map (branch 02+)

```text
┌─────────────────┐
│   Production    │  BatchCompleted, StockProduced
└────────┬────────┘
         │ integration event
         v
┌─────────────────┐
│   Inventory     │  StockReceived, StockReserved, InventoryUpdated
└────────┬────────┘
         │ integration event
         v
┌─────────────────┐
│     Sales       │  OrderPlaced, OrderConfirmed
└─────────────────┘
```

Future stage **10-EventDrivenSagas** orchestrates the long-running flow across these contexts (see [Architecture governance](09-architecture-governance.md)).

### Baseline — branch 04 import (microservices)

Physically separated services; legacy `Warehouses` service name:

```text
+----------------+         integration event          +----------------+
|     Sales      | <-------------------------------   |   Warehouses   |
|  (microservice)|   AvailabilityUpdatedForNotification|  (microservice)|
+----------------+                                    +----------------+
```

See [Context Map Evolution](../diagrams/context-map-evolution.md) for the full baseline progression.

---

## Key Business Rules

### Sales Order Creation

From **Stage 03** onward (see [ADR-012](../adr/ADR-012-cross-context-collaboration-modular-monolith.md)):

1. Customer submits an order with one or more beer line items
2. Sales orchestrates **reservation** per line via application contract (`IInventoryReservationService`)
3. **Inventory** enforces stock invariants on `InventoryItem.ReserveStock` — final authority
4. On successful reservation, `SalesOrder` is created
5. Domain and integration events follow in Stages 04–06 (`StockReserved`, `SalesOrderCreated`, outbox)

### Inventory and availability

1. Production completes for a beer batch
2. Inventory context receives stock (`ReceiveStock` / `StockReceived` from branch 04)
3. `AvailableQuantity` is derived: `OnHandQuantity - ReservedQuantity`
4. Sales validates orders against available quantity; read models sync via integration events (branch 05+)

Stage 01 uses a simplified anemic `Availability` entity — see [Stage 01 blueprint](13-stage-01-overview.md).

---

## Production evolution (greenfield)

| Stage | Production shape |
|-------|------------------|
| 01 | `ProductionOrderDto`; `POST /api/production/completed` updates Inventory directly |
| 02–04 | `FermentFlow.Production.*` module; `ProductionOrder` aggregate emerges |
| 05+ | Separate deployable; `ProductionCompleted` integration event |

Detail: [ADR-011](../adr/ADR-011-promote-production-bounded-context.md).

## Contracts (baseline import only)

On **external baseline imports**, Production is not a full bounded context — integration uses shared contracts:

| Contract | Location | Purpose |
|----------|----------|---------|
| `ProductionOrderJson` | `FermentFlow.Shared.Contracts` | Production order payload |
| `ProductionOrderRowJson` | `FermentFlow.Shared.Contracts` | Production line item |
| `SetAvailabilityJson` | `FermentFlow.Shared.Contracts` | Warehouse availability update |
| `BeerAvailabilityJson` | `FermentFlow.Shared.Contracts` | Availability query result |

**Target state:** replace contract-only integration with the **Production** bounded context and domain/integration events — see [ADR-001](../adr/ADR-001-introduce-modular-monolith.md) and [ADR-004](../adr/ADR-004-introduce-microservices.md).

---

## Related documents

- [Inventory aggregate model](12-inventory-aggregate-model.md) — `InventoryItem` vs derived availability
- [Domain invariants](11-domain-invariants.md) — explicit aggregate rules for branch 03 unit tests
- [Event catalog](10-event-catalog.md) — domain, integration, and saga events
- [Stage 01 blueprint](13-stage-01-overview.md) — legacy monolith before DDD tactical patterns
- [DDD reverse engineering report](05-ddd-reverse-engineering-report.md) — baseline vs target bounded contexts
