# DDD Reverse Engineering Report

Complete inventory of domain concepts from **external baseline import** analysis. **Greenfield target** decisions (Stages 01–09) may differ — see ADRs and stage blueprints.

> **Current workspace note:** On the docs-only blueprint branch, the baseline source is not present under `src/` or `source-material/`. This report captures analysis of the external baseline branches, not implemented FermentFlow code in the current workspace.

### Greenfield target additions (not in baseline import)

| Concept | Stage | Decision |
|---------|-------|----------|
| `InventoryItem` aggregate | 02+ | [ADR-011](../02-adr/ADR-011-inventory-item-aggregate-root.md) |
| `InventoryReservation` entity | 03+ | [ADR-014](../02-adr/ADR-014-compensating-actions-stage-03.md) |
| Cross-context application contracts | 03+ | [ADR-013](../02-adr/ADR-013-cross-context-collaboration-modular-monolith.md) |
| Compensation (no cross-context `TransactionScope`) | 03+ | [ADR-014](../02-adr/ADR-014-compensating-actions-stage-03.md) |
| Production bounded context module | 02+ | [ADR-012](../02-adr/ADR-012-promote-production-bounded-context.md) |

---

## 1. Business Domain

**Core domain:** Brewery logistics — selling beer products with warehouse inventory management.

**Subdomains:** Sales (core), Warehouses (core), Production (supporting/external), Read Model (generic).

See [Business Domain](02-business-domain.md).

---

## 2. Ubiquitous Language

22 domain terms identified from external baseline code analysis. See [Ubiquitous Language](04-ubiquitous-language.md).

---

## 3. Baseline Bounded Contexts

Imported baseline code through branch 04 microservices import. **Production remains contracts-only** on these branches.

| Context | Branch 01 | Branch 02+ | Branch 04 |
|---------|-----------|------------|-----------|
| **Sales** | Logical (in `DomainModel`) | `src/Sales/` | `FermentFlow.Sales.Rest` service |
| **Warehouses** | Logical (in `DomainModel`) | `src/Warehouses/` | `FermentFlow.Warehouses.Rest` service |
| **Production** | Contracts only | Contracts only | Contracts only |

### Target FermentFlow state

From branch **02-ModularMonolith** onward (target roadmap), three full bounded contexts:

```text
Sales
Inventory        (renamed from Warehouses)
Production       (promoted from contracts-only)
```

See [Business domain](02-business-domain.md) for baseline vs target integration styles.

---

## 4. Aggregates

### SalesOrder

| Attribute | Branch 01 | Branch 03+ |
|-----------|-----------|------------|
| **Location** | `FermentFlow.DomainModel.Entities.Sales.SalesOrder` | `FermentFlow.Sales.Domain.Entities.SalesOrder` |
| **Root** | Yes (`AggregateRoot`) | Yes (Muflone `AggregateRoot`) |
| **Behavior** | Factory method only | `CreateSalesOrder` → `RaiseEvent(SalesOrderCreated)` |
| **Invariants** | Filters rows by availability (in service) | Checked in command handler |
| **Events** | None | `SalesOrderCreated`, `SalesOrderClosed` |

### Availability (Warehouses)

| Attribute | Branch 01 | Branch 03+ |
|-----------|-----------|------------|
| **Location** | `FermentFlow.DomainModel.Entities.Warehouses.Availability` | `FermentFlow.Warehouses.Domain.Entities.Availability` |
| **Root** | Yes | Yes (Muflone `AggregateRoot`) |
| **Behavior** | Factory method only | `CreateAvailability` / `UpdateAvailability` → events |
| **Events** | None | `AvailabilityUpdatedDueToProductionOrder`, `AvailabilityUpdatedForNotification` |

### Availability (Sales — Branch 03+)

Sales maintains its own `Availability` entity for read-side synchronization from warehouse notifications.

---

## 5. Entities

| Entity | Context | Type | Children |
|--------|---------|------|----------|
| `SalesOrder` | Sales | Aggregate Root | `SalesOrderRow` |
| `SalesOrderRow` | Sales | Entity (within aggregate) | — |
| `Availability` | Warehouses | Aggregate Root | — |
| `Availability` | Sales | Entity (read-side copy) | — |

---

## 6. Value Objects

The external baseline implements these as `record` types in `FermentFlow.Shared.CustomTypes`:

| Value Object | Used By |
|--------------|---------|
| `BeerId` | Sales, Warehouses |
| `BeerName` | Sales, Warehouses |
| `CustomerId` | Sales |
| `CustomerName` | Sales |
| `SalesOrderId` | Sales |
| `SalesOrderNumber` | Sales |
| `OrderDate` | Sales |
| `Quantity` | Sales, Warehouses |
| `Price` | Sales |
| `Availability` (typed wrapper) | Shared |

Branch 03+ adds `DomainIds/` per context: `ProductionOrderId`, `PurchaseOrderId`, `SupplierId`, `ProductId`, `OrderId`.

---

## 7. Repositories

| Branch | Interface | Implementations |
|--------|-----------|-----------------|
| 01 | `IRepository` (keyed) | `SaleRepository`, `WarehouseRepository` |
| 02 | `IRepository` (keyed per context) | `SalesRepository`, `WarehousesRepository` |
| 03+ | `IRepository` (Muflone) + `IPersister` | `SalesPersister`, `WarehousesPersister` |

All use MongoDB. Branch 03+ adds EventStore as the write-side event store.

---

## 8. Domain Services

| Service | Branch | Responsibility |
|---------|--------|----------------|
| `SalesOrderService` | 01 | Create order, check warehouse availability |
| `WarehouseService` | 01 | Update availability from production |
| `SalesDomainService` | 02 | Create order (delegates to repository) |
| `WarehousesDomainService` | 02 | Set availability (delegates to repository) |

Replaced by command handlers in branch 03+.

---

## 9. Application Services

| Service | Layer | Branch |
|---------|-------|--------|
| `FermentFlow.Rest.Services.SalesOrderService` | API (static handlers) | 01 |
| `FermentFlow.Rest.Services.WarehousesService` | API (static handlers) | 01 |
| `FermentFlow.Mediator.FermentFlowMediator` | Orchestration | 02 |
| `ISalesFacade` / `IWarehousesFacade` | Facade | 02–04 |
| `SalesQueryService` / `AvailabilityQueryService` | Read model | All |

---

## 10. CQRS

| Side | Branch 01 | Branch 02+ |
|------|-----------|------------|
| **Commands (write)** | Application services → repository | Command handlers → event store |
| **Queries (read)** | `IQueries<T>` → MongoDB | `IQueries<T>` → MongoDB read models |

### Commands (Branch 03+)

| Command | Context | Handler |
|---------|---------|---------|
| `CreateSalesOrder` | Sales | `CreateSalesOrderCommandHandler` |
| `UpdateAvailabilityDueToWarehousesNotification` | Sales | `UpdateAvailabilityDueToWarehousesNotificationCommandHandler` |
| `UpdateAvailabilityDueToProductionOrder` | Warehouses | `UpdateAvailabilityDueToProductionOrderCommandHandler` |
| `CreateAvailabilityDueToProductionOrder` | Warehouses | `CreateAvailabilityDueToProductionOrderCommandHandler` |

### Queries (All Branches)

| Query | Context | Implementation |
|-------|---------|----------------|
| Get sales orders (paginated) | Sales | `SalesOrderQueries` |
| Get availability by beer | Warehouses | `AvailabilityQueries` |

---

## 11. Event Sourcing

Introduced in branch 03 using **Muflone** framework.

| Component | Purpose |
|-----------|---------|
| `AggregateRoot` (Muflone) | Base class with `RaiseEvent` / `Apply` |
| EventStoreDB | Append-only event store per context |
| `IPersister` | Saves aggregate state to event store |
| `LastEventPosition` | Tracks projection checkpoint |
| `EventStorePositionRepository` | Persists projection position |

### Event Flow

```
Command → CommandHandler → Aggregate.RaiseEvent()
  → EventStore (append)
  → DomainEvent published
  → ReadModel EventHandler (projection)
  → MongoDB read model updated
```

---

## 12. Microservices

Branch 04 splits into two services:

| Service | Owns | Host | Solution |
|---------|------|------|----------|
| **Sales** | Orders, sales-side availability | `FermentFlow.Sales.Rest` | `FermentFlow.Sales.sln` |
| **Warehouses** | Inventory, production-driven stock | `FermentFlow.Warehouses.Rest` | `FermentFlow.Warehouses.sln` |

Integration: RabbitMQ integration events + Sales ACL.

---

## 13. Architecture Evolution

| Step | Key Change | ADR |
|------|------------|-----|
| 01 → 02 | Modular monolith + bounded contexts + architecture tests | [ADR-002](../02-adr/ADR-002-introduce-modular-monolith.md) |
| 02 → 03 | CQRS + vertical slices | [ADR-003](../02-adr/ADR-003-introduce-cqrs.md) |
| 03 → 04 | Event sourcing (CQRS retained) | [ADR-004](../02-adr/ADR-004-introduce-event-sourcing.md) |
| 04 → 05 | Extract microservices | [ADR-005](../02-adr/ADR-005-introduce-microservices.md) |

Full comparison: [Architecture Evolution](03-architecture-evolution.md).

---

## Appendix: File Inventory by Concern

| Concern | Branch 01 Path | Branch 04 Path |
|---------|----------------|----------------|
| Sales aggregate | `FermentFlow.DomainModel/Entities/Sales/SalesOrder.cs` | `Sales/FermentFlow.Sales.Domain/Entities/SalesOrder.cs` |
| Warehouse aggregate | `FermentFlow.DomainModel/Entities/Warehouses/Availability.cs` | `Warehouses/FermentFlow.Warehouses.Domain/Entities/Availability.cs` |
| API host | `FermentFlow.Rest/Program.cs` | `Sales/FermentFlow.Sales.Rest/Program.cs` + `Warehouses/FermentFlow.Warehouses.Rest/Program.cs` |
| MongoDB | `FermentFlow.Infrastructure/MongoDb/` | Per-service `Infrastructures/MongoDb/` |
| RabbitMQ | — | Per-service `Infrastructures/RabbitMq/` |
| EventStore | — | Per-service `InfrastructureHelper.cs` |
