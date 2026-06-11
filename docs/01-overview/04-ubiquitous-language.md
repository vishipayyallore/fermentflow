# Ubiquitous Language

The shared vocabulary used across all bounded contexts. Terms are derived from business capabilities and the nine-stage target architecture.

**Inventory aggregate decision:** [ADR-010](../adr/ADR-010-inventory-item-aggregate-root.md) · [Inventory aggregate model](12-inventory-aggregate-model.md)

## Core Terms

| Term | Meaning | Code Representation |
|------|---------|---------------------|
| **Beer** | A product sold by the brewery | `BeerId`, `BeerName` |
| **Sales Order** | A customer's request to purchase beer | `SalesOrder`, `SalesOrderId`, `SalesOrderNumber` |
| **Sales Order Row** | A single line item in an order (beer + quantity + price) | `SalesOrderRow` |
| **InventoryItem** | Aggregate root — stock lifecycle for a beer (branch 02+) | `InventoryItem` in `FermentFlow.Inventory.Domain` |
| **Availability** | Derived business concept: quantity available to sell (`OnHand - Reserved`) | Computed property; Stage 01 legacy entity/table name only |
| **Production Order** | A manufacturing request that produces beer | `ProductionOrder` (branch 05+); `ProductionOrderDto` (Stage 01) |
| **Customer** | The buyer placing a sales order | `CustomerId`, `CustomerName` |
| **Quantity** | Number of units (with unit of measure, e.g. "Lt") | `Quantity` value object |
| **Price** | Monetary amount (with currency, e.g. "EUR") | `Price` value object |
| **Order Date** | When the sales order was placed | `OrderDate` value object |

### InventoryItem quantities (branch 02+)

| Term | Meaning |
|------|---------|
| **OnHandQuantity** | Physical stock in inventory |
| **ReservedQuantity** | Stock held for pending sales orders |
| **AvailableQuantity** | `OnHandQuantity - ReservedQuantity` — what can still be sold |

## Context-Specific Terms

### Sales Context

| Term | Meaning | Introduced In |
|------|---------|---------------|
| **SalesOrderCreated** | Domain event raised when an order is created | Branch 03 |
| **SalesOrderClosed** | Domain event raised when an order is closed | Branch 03 |
| **CreateSalesOrder** | Command to create a new sales order | Branch 03 |
| **SyncInventoryNotification** | Command to update Sales read model from inventory change | Branch 03 |

### Inventory Context

| Term | Meaning | Introduced In |
|------|---------|---------------|
| **ReceiveStock** | Command to increase on-hand quantity | Branch 03 |
| **ReserveStock** | Command to reserve quantity for a sales order | Branch 03 |
| **ReleaseStockReservation** | Command to release a reservation | Branch 03 |
| **AdjustInventory** | Command to correct on-hand quantity | Branch 03 |
| **StockReceived** | Domain event — stock entered inventory | Branch 04 |
| **StockReserved** | Domain event — quantity reserved | Branch 04 |
| **StockReservationReleased** | Domain event — reservation released | Branch 04 |
| **InventoryAdjusted** | Domain event — on-hand corrected | Branch 04 |
| **InventoryUpdated** | Integration event — stock change visible to other contexts | Branch 05+ |

### Legacy baseline import (reference)

Imported baseline branches use `Warehouses` naming and Muflone-oriented terms (`AvailabilityUpdatedDueToProductionOrder`, `Set Availability`). See [Architecture evolution](03-architecture-evolution.md) — not the greenfield target vocabulary.

### Cross-Context

| Term | Meaning | Introduced In |
|------|---------|---------------|
| **CorrelationId** | Links related events across contexts | Branch 03 |
| **LastEventPosition** | Tracks read-model projection progress | Branch 04 |

## Value Objects

| Value Object | Properties | Validation |
|--------------|------------|------------|
| `BeerId` | `Guid Value` | Non-empty GUID |
| `BeerName` | `string Value` | Non-empty string |
| `CustomerId` | `Guid Value` | Non-empty GUID |
| `CustomerName` | `string Value` | Non-empty string |
| `SalesOrderId` | `Guid Value` | Non-empty GUID |
| `SalesOrderNumber` | `string Value` | Format: `YYYYMMDD-HHMM` |
| `OrderDate` | `DateTime Value` | Valid date |
| `Quantity` | `decimal Value`, `string UnitOfMeasure` | Positive value |
| `Price` | `decimal Value`, `string Currency` | Positive value |

## Anti-Patterns in Language (Stage 01)

Stage 01 intentionally blurs boundaries:

| Misleading Term | Problem | Fixed In |
|-----------------|---------|----------|
| `Availability` as entity/aggregate | Models derived state, not stock lifecycle | 02: `InventoryItem` aggregate |
| Shared `Availabilities` table | Single DB coupling | 02: context-owned modules; 05: separate DB |
| `SalesOrderService` → `InventoryRepository` | Cross-subdomain coupling | 02: dependency rules; 05: service APIs |
| `ProductionOrderDto` only | Production not a bounded context | 02: `FermentFlow.Production` module |

## Glossary by Layer

| Layer | Terms Used |
|-------|------------|
| **API** | Sales Order JSON, Inventory availability JSON, Production completed JSON |
| **Domain** | Aggregate Root, Entity, Value Object, Domain Event, Command |
| **Infrastructure** | Repository, DbContext, Event Store, Outbox, Consumer |
| **Read Model** | Query, Projection, DTO |
