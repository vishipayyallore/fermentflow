# Ubiquitous Language

The shared vocabulary used across all bounded contexts. Terms are derived from code (`CustomTypes`, `Contracts`, `SharedKernel`) and business capabilities.

## Core Terms

| Term | Meaning | Code Representation |
|------|---------|---------------------|
| **Beer** | A product sold by the brewery | `BeerId`, `BeerName`, `BeerJson` |
| **Sales Order** | A customer's request to purchase beer | `SalesOrder`, `SalesOrderId`, `SalesOrderNumber` |
| **Sales Order Row** | A single line item in an order (beer + quantity + price) | `SalesOrderRow`, `SalesOrderRowJson` |
| **Availability** | Warehouse stock level for a beer | `Availability` (entity), `BeerAvailabilityJson` |
| **Production Order** | A manufacturing request that produces beer | `ProductionOrderJson`, `ProductionOrderId` |
| **Customer** | The buyer placing a sales order | `CustomerId`, `CustomerName` |
| **Quantity** | Number of units (with unit of measure, e.g. "Lt") | `Quantity` value object |
| **Price** | Monetary amount (with currency, e.g. "EUR") | `Price` value object |
| **Order Date** | When the sales order was placed | `OrderDate` value object |

## Context-Specific Terms

### Sales Context

| Term | Meaning | Introduced In |
|------|---------|---------------|
| **SalesOrderCreated** | Domain event raised when an order is created | Branch 03 |
| **SalesOrderClosed** | Domain event raised when an order is closed | Branch 03 |
| **CreateSalesOrder** | Command to create a new sales order | Branch 03 |
| **UpdateAvailabilityDueToWarehousesNotification** | Command to sync availability from warehouse | Branch 03 |

### Warehouses Context

| Term | Meaning | Introduced In |
|------|---------|---------------|
| **Set Availability** | Update warehouse stock for a beer | All branches |
| **AvailabilityUpdatedDueToProductionOrder** | Domain event when production updates stock | Branch 03 |
| **AvailabilityUpdatedForNotification** | Integration event sent to Sales | Branch 03 |
| **UpdateAvailabilityDueToProductionOrder** | Command to update stock from production | Branch 03 |
| **CreateAvailabilityDueToProductionOrder** | Command to create initial stock from production | Branch 04 |

### Cross-Context

| Term | Meaning | Introduced In |
|------|---------|---------------|
| **BeerAvailabilityCommunicated** | Saga message for availability communication | Branch 03 |
| **CorrelationId** | Links related events across contexts | Branch 03 |
| **LastEventPosition** | Tracks read-model projection progress | Branch 03 |

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

## Anti-Patterns in Language (Branch 01)

In the legacy branch, some terms blur context boundaries:

| Misleading Term | Problem | Fixed In |
|-----------------|---------|----------|
| Shared `Availability` entity in Sales and Warehouses | Same name, different responsibilities | Branch 02+: separate context entities |
| `IRepository` (generic) | No context ownership | Branch 02+: keyed repositories per context |
| `Sales` MongoDB database for warehouse data | Database name implies Sales owns warehouse data | Branch 02+: per-context databases |

## Glossary by Layer

| Layer | Terms Used |
|-------|------------|
| **API** | Sales Order JSON, Set Availability JSON, Beer Availability JSON |
| **Domain** | Aggregate, Entity, Value Object, Domain Event, Command |
| **Infrastructure** | Repository, Persister, Event Store, Consumer, Publisher |
| **Read Model** | Query, Projection, DTO, Event Handler |
