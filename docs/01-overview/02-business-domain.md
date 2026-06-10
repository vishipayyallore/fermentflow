# Business Domain

## Core Domain

**Brewery Logistics Management** — coordinating the sale of beer products with warehouse inventory and production output.

## Business Capabilities

The system supports these major capabilities:

- **Create Sales Orders** — customers place orders for beer products
- **Manage Inventory** — track beer availability in warehouses
- **Check Beer Availability** — validate that ordered beers are in stock
- **Produce Beer** — production orders update warehouse stock (external trigger)
- **Generate Read Models** — query optimized views for reporting and UI

## Subdomains

| Subdomain | Type | Purpose | Bounded Context |
|------------|------|---------|-----------------|
| **Sales** | Core | Customer order management | `Sales` |
| **Warehouse** | Core | Inventory and availability | `Warehouses` |
| **Production** | Supporting | Beer manufacturing triggers | External (contracts only) |
| **Read Model** | Generic | Query-optimized projections | Per-context `ReadModel` |
| **Shared Kernel** | Shared | Common types and contracts | `FermentFlow.Shared` |

## Context Map (Branch 01 — Legacy)

In the legacy monolith, contexts are **logical only** — they share code, database, and repositories:

```
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

## Context Map (Branch 04 — Microservices)

In the final architecture, contexts are **physically separated** and communicate via integration events:

```
+----------------+         integration event          +----------------+
|     Sales      | <-------------------------------   |   Warehouse    |
|  (microservice)|   AvailabilityUpdatedForNotification|  (microservice)|
+----------------+                                    +----------------+
        |                                                     |
        | SalesOrderCreated                                   | AvailabilityUpdatedDueToProductionOrder
        v                                                     v
+----------------+                                    +----------------+
|  Sales Read    |                                    | Warehouse Read |
|     Model      |                                    |     Model      |
+----------------+                                    +----------------+
```

See [Context Map Evolution](../diagrams/context-map-evolution.md) for the full progression.

## Key Business Rules

### Sales Order Creation

1. Customer submits an order with one or more beer line items
2. System checks warehouse availability for each beer
3. Only beers with sufficient stock are included in the order
4. Order is persisted (and later, events are published)

### Availability Management

1. Production completes for a beer batch
2. Warehouse availability is created or updated
3. Sales context is notified of the change (branches 03–04)
4. Sales read model reflects updated availability

## Contracts (Integration Points)

Production is not a full bounded context in this codebase, but contracts exist for future integration:

| Contract | Location | Purpose |
|----------|----------|---------|
| `ProductionOrderJson` | `FermentFlow.Shared.Contracts` | Production order payload |
| `ProductionOrderRowJson` | `FermentFlow.Shared.Contracts` | Production line item |
| `SetAvailabilityJson` | `FermentFlow.Shared.Contracts` | Warehouse availability update |
| `BeerAvailabilityJson` | `FermentFlow.Shared.Contracts` | Availability query result |
