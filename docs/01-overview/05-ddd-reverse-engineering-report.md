# DDD Reverse Engineering Report

Complete inventory of domain concepts and architectural elements discovered across all four branches.

---

## 1. Business Domain

**Core domain:** Brewery logistics — selling beer products with warehouse inventory management.

**Subdomains:** Sales (core), Warehouses (core), Production (supporting/external), Read Model (generic).

See [Business Domain](02-business-domain.md).

---

## 2. Ubiquitous Language

22 domain terms identified from code. See [Ubiquitous Language](04-ubiquitous-language.md).

---

## 3. Bounded Contexts

| Context | Branch 01 | Branch 02+ | Branch 04 |
|---------|-----------|------------|-----------|
| **Sales** | Logical (in `DomainModel`) | `src/Sales/` | `BrewUp.Sales.Rest` service |
| **Warehouses** | Logical (in `DomainModel`) | `src/Warehouses/` | `BrewUp.Warehouses.Rest` service |
| **Production** | Contracts only | Contracts only | Contracts only |

---

## 4. Aggregates

### SalesOrder

| Attribute | Branch 01 | Branch 03+ |
|-----------|-----------|------------|
| **Location** | `BrewUp.DomainModel.Entities.Sales.SalesOrder` | `BrewUp.Sales.Domain.Entities.SalesOrder` |
| **Root** | Yes (`AggregateRoot`) | Yes (Muflone `AggregateRoot`) |
| **Behavior** | Factory method only | `CreateSalesOrder` → `RaiseEvent(SalesOrderCreated)` |
| **Invariants** | Filters rows by availability (in service) | Checked in command handler |
| **Events** | None | `SalesOrderCreated`, `SalesOrderClosed` |

### Availability (Warehouses)

| Attribute | Branch 01 | Branch 03+ |
|-----------|-----------|------------|
| **Location** | `BrewUp.DomainModel.Entities.Warehouses.Availability` | `BrewUp.Warehouses.Domain.Entities.Availability` |
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

All implemented as `record` types in `BrewUp.Shared.CustomTypes`:

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
| `BrewUp.Rest.Services.SalesOrderService` | API (static handlers) | 01 |
| `BrewUp.Rest.Services.WarehousesService` | API (static handlers) | 01 |
| `BrewUp.Mediator.BrewUpMediator` | Orchestration | 02 |
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
| **Sales** | Orders, sales-side availability | `BrewUp.Sales.Rest` | `BrewUp.Sales.sln` |
| **Warehouses** | Inventory, production-driven stock | `BrewUp.Warehouses.Rest` | `BrewUp.Warehouses.sln` |

Integration: RabbitMQ integration events + Sales ACL.

---

## 13. Architecture Evolution

| Step | Key Change | ADR |
|------|------------|-----|
| 01 → 02 | Bounded contexts + CQRS + Mediator | [ADR-001](../adr/ADR-001-introduce-cqrs.md) |
| 02 → 03 | Event sourcing + RabbitMQ + ACL | [ADR-002](../adr/ADR-002-introduce-event-sourcing.md) |
| 03 → 04 | Extract microservices | [ADR-003](../adr/ADR-003-extract-microservices.md) |

Full comparison: [Architecture Evolution](03-architecture-evolution.md).

---

## Appendix: File Inventory by Concern

| Concern | Branch 01 Path | Branch 04 Path |
|---------|----------------|----------------|
| Sales aggregate | `BrewUp.DomainModel/Entities/Sales/SalesOrder.cs` | `Sales/BrewUp.Sales.Domain/Entities/SalesOrder.cs` |
| Warehouse aggregate | `BrewUp.DomainModel/Entities/Warehouses/Availability.cs` | `Warehouses/BrewUp.Warehouses.Domain/Entities/Availability.cs` |
| API host | `BrewUp.Rest/Program.cs` | `Sales/BrewUp.Sales.Rest/Program.cs` + `Warehouses/BrewUp.Warehouses.Rest/Program.cs` |
| MongoDB | `BrewUp.Infrastructure/MongoDb/` | Per-service `Infrastructures/MongoDb/` |
| RabbitMQ | — | Per-service `Infrastructures/RabbitMq/` |
| EventStore | — | Per-service `InfrastructureHelper.cs` |
