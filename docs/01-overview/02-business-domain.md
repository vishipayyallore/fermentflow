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
| **Production** | Supporting; **contracts only** — not a full bounded context | **Full bounded context** — brewing batches, production orders, completion events |
| **Inventory** | Named `Warehouses` in code and APIs | Renamed to **Inventory** — business capability, not a physical location |
| **Sales** | Core context | Core context (unchanged role) |
| **Integration** | Direct calls (branch 01) → events (branch 04+) | Production → Inventory → Sales via integration events and sagas (stage 10+) |

See [Modernization vision](07-fermentflow-modernization-vision.md) and [Business flow target](#target-context-map-branch-02).

---

## Business Capabilities

The system supports these major capabilities:

- **Create Sales Orders** — customers place orders for beer products
- **Manage Inventory** — track beer availability and stock levels
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
| **Inventory** | Core | Stock, availability, reservations | `FermentFlow.Inventory` |
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
│   Inventory     │  AvailabilityChanged, StockReserved
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

1. Customer submits an order with one or more beer line items
2. System checks inventory availability for each beer
3. Only beers with sufficient stock are included in the order
4. Order is persisted (and later, events are published)

### Availability Management

1. Production completes for a beer batch
2. Inventory availability is created or updated
3. Sales context is notified of the change (branches 03–04 baseline; all target branches)
4. Sales read model reflects updated availability

---

## Contracts (baseline import only)

On **imported baseline branches**, Production is not a full bounded context — integration uses shared contracts:

| Contract | Location | Purpose |
|----------|----------|---------|
| `ProductionOrderJson` | `FermentFlow.Shared.Contracts` | Production order payload |
| `ProductionOrderRowJson` | `FermentFlow.Shared.Contracts` | Production line item |
| `SetAvailabilityJson` | `FermentFlow.Shared.Contracts` | Warehouse availability update |
| `BeerAvailabilityJson` | `FermentFlow.Shared.Contracts` | Availability query result |

**Target state:** replace contract-only integration with the **Production** bounded context and domain/integration events — see [ADR-001](../adr/ADR-001-introduce-modular-monolith.md) and [ADR-004](../adr/ADR-004-introduce-microservices.md).
