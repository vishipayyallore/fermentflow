# Stage 01 — Architectural Smells

Catalog of **intentional** problems in `01-LegacyMonolith`. Each smell maps to a later stage that removes it.

**Related:** [Stage 01 blueprint](13-stage-01-overview.md) · [Modernization vision](07-fermentflow-modernization-vision.md)

---

## Smell catalog

| Smell | Present in Stage 01 | Resolved in |
|-------|---------------------|-------------|
| Shared database | Single PostgreSQL, one `DbContext` | 02+ per-context persistence boundaries; 05 separate databases |
| Tight coupling | `SalesOrderService` → `InventoryRepository` | 02 modular monolith; 05 service boundaries |
| No bounded contexts | Logical subdomains only | 02 physical modules |
| Anemic domain model | Entities with little behaviour | 03 aggregate enforcement + domain unit tests |
| Transaction script services | Business rules in application services | 03 commands on aggregates |
| No domain events | Direct `SaveChanges` | 04 EventStoreDB streams |
| No integration events | Production updates DB directly | 05–06 outbox + messaging |
| Generic repositories | `InventoryRepository`, `SalesRepository` | 03 vertical slices, explicit handlers |
| Cross-subdomain data access | Sales reads inventory tables/repos | 02 dependency rules; 05 APIs/events |
| No architecture tests | No compile-time boundary enforcement | 02 NetArchTest / ArchUnitNET |
| No resiliency | Synchronous, no timeouts/breakers | 07 Polly |
| No observability | No traces or metrics | 08 OpenTelemetry |
| Simplified inventory model | Single `AvailableQuantity` on `Availability` | 02 `InventoryItem` with on-hand / reserved |
| Production as DTO only | `ProductionOrderDto`, no context | 02 full Production bounded context |

---

## Smell deep-dives

### Shared database

All modules read and write the same tables. Any schema change affects Sales, Inventory, and read models together. There is no context-owned schema.

**Later fix:** Module boundaries (02), then database-per-service (05).

### Direct repository coupling

```text
SalesOrderService → InventoryRepository → Availabilities table
```

Sales knows how inventory is stored. You cannot extract Inventory without rewriting Sales.

**Later fix:** Application-layer boundaries (02), integration events (05–06).

### Anemic `Availability`

Stage 01 stores one quantity per beer. There is no model for reserved stock, adjustments, or production receipts as distinct facts.

**Later fix:** `InventoryItem` aggregate ([ADR-011](../02-adr/ADR-011-inventory-item-aggregate-root.md)); derived `AvailableQuantity = OnHand - Reserved`.

### No domain events

When production completes, code updates a row. The system cannot answer “what happened?” — only “what is the current value?”

**Later fix:** `StockReceived`, `StockReserved`, … in EventStoreDB (04).

---

## What Stage 01 should demonstrate

Stage 01 should feel **easy to write** and **hard to evolve**. That discomfort is the motivation for Stage 02 onward.

When refactoring, use this document as a checklist: if a smell is gone before its stage, Swamy probably skipped a planned refactoring constraint.
