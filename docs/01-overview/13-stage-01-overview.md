# Stage 01 — Legacy Monolith Blueprint

Implementation guide for branch **`01-LegacyMonolith`**.

**Purpose:** Build a realistic legacy system with intentional architectural smells — **before** DDD tactical patterns, CQRS, event sourcing, or microservices.

**Related:** [Architectural smells](14-stage-01-smells.md) · [Branch roadmap](08-branch-roadmap.md) · [ADR-000](../adr/ADR-000-establish-fermentflow.md) · [Inventory aggregate model](12-inventory-aggregate-model.md) (target from Stage 02)

---

## Learning outcomes

By the end of Stage 01 you should recognize:

- Shared database coupling
- Direct repository access across logical subdomains
- Anemic domain model and transaction-script services
- No domain events, bounded contexts, architecture tests, resiliency, or observability

These smells are what Stages 02–09 systematically remove.

---

## What not to implement yet

| Pattern | First stage (git branch) |
|---------|------------------------|
| Bounded contexts (physical) | Stage 02 — `02-ModularMonolith` |
| MediatR / CQRS | Stage 03 — `03-CQRS-VerticalSlices` |
| EventStoreDB / domain events | Stage 04 — `04-CQRS-EventSourcing` |
| Separate deployables | Stage 05 — `05-Microservices` |
| Outbox | Stage 06 — `06-OutboxPattern` |
| Polly | Stage 07 — `07-CircuitBreaker` |
| OpenTelemetry | Stage 08 — `08-Observability` |
| Aspire | Stage 09 — `09-Aspire` |

---

## Business capabilities (logical only)

```text
Production  →  Inventory  →  Sales
```

Stage 01 coupling (intentional):

```text
Sales     →  directly calls Inventory repository
Inventory →  directly updates shared database
Production →  contracts/DTO only; POST completes → updates inventory via service
```

---

## Technology stack

| Area | Technology |
|------|------------|
| Runtime | .NET 10 |
| API | ASP.NET Core Minimal API |
| Database | PostgreSQL |
| ORM | EF Core |
| Tests | xUnit (`FermentFlow.Api.Tests`) |
| Containers | Docker Compose (PostgreSQL) |

---

## Solution structure

```text
src/
│
├── FermentFlow.DomainModel
├── FermentFlow.Infrastructure
├── FermentFlow.ReadModel
├── FermentFlow.Api
├── FermentFlow.Shared
└── FermentFlow.sln

tests/
└── FermentFlow.Api.Tests
```

---

## Domain model (Stage 01 — simplified legacy)

### Sales

```text
SalesOrder
 └── SalesOrderRow
```

### Inventory

```text
Availability        ← anemic entity (refactored to InventoryItem in Stage 02)
```

### Production

```text
ProductionOrderDto  ← contract/DTO only; no full bounded context
```

---

## PostgreSQL schema (initial)

Single `FermentFlowDbContext`; table names reflect legacy naming on purpose:

```text
SalesOrders
SalesOrderRows
Availabilities          ← becomes InventoryItems in Stage 02
```

`Availabilities` columns (Stage 01 minimum):

| Column | Type | Notes |
|--------|------|-------|
| `BeerId` | `uuid` PK | One row per beer |
| `BeerName` | `varchar` | Display name |
| `AvailableQuantity` | `decimal` | Single quantity column (no reserved split yet) |

Stage 02 introduces `OnHandQuantity` / `ReservedQuantity` on `InventoryItem`.

---

## API endpoints

### Inventory

```http
POST /api/inventory/availability
GET  /api/inventory/availability/{beerId}
```

### Sales

```http
POST /api/sales/orders
GET  /api/sales/orders
GET  /api/sales/orders/{id}
```

### Production

```http
POST /api/production/completed
```

Updates inventory directly through the same service layer (no events).

---

## Intentional bad design

### Sales depends on Inventory infrastructure

```csharp
public class SalesOrderService
{
    private readonly InventoryRepository _inventoryRepository;
    private readonly SalesRepository _salesRepository;
}
```

### Shared DbContext

```csharp
public class FermentFlowDbContext : DbContext
{
    public DbSet<SalesOrder> SalesOrders { get; set; }
    public DbSet<SalesOrderRow> SalesOrderRows { get; set; }
    public DbSet<Availability> Availabilities { get; set; }
}
```

### No domain events

Persist state directly — no outbox, no broker, no EventStoreDB.

### Rules in services, not aggregates

Stock validation lives in `SalesOrderService`, not on `SalesOrder` — anemic model smell.

---

## Tests (Stage 01 only)

`FermentFlow.Api.Tests` — basic API/integration smoke:

- Create availability
- Create sales order (with stock validation)
- Get sales order
- Production completed updates availability

No architecture tests, domain unit tests, or Testcontainers until later stages.

---

## Docker Compose

```text
docker/
└── docker-compose.yml    # PostgreSQL for local dev
```

---

## Suggested implementation sequence

| Day | Focus |
|-----|-------|
| 1 | Solution skeleton, `FermentFlowDbContext`, Docker PostgreSQL, health endpoint |
| 2 | `Availability` entity + POST/GET inventory endpoints |
| 3 | `SalesOrder` + rows, `SalesOrderService` with direct inventory check |
| 4 | `POST /api/production/completed` → updates availability via service |
| 5 | Read model queries, list orders, `FermentFlow.Api.Tests` |
| 6 | Document smells encountered; prepare Stage 02 context split |

---

## Definition of Done

### Functional

- [ ] Create inventory availability
- [ ] Create sales order with stock validation
- [ ] List and get orders
- [ ] Production-completed endpoint updates availability
- [ ] Persist to PostgreSQL

### Architectural (smells present on purpose)

- [ ] Single solution, single database
- [ ] Layered projects with direct repository coupling
- [ ] No CQRS, MediatR, MassTransit, EventStoreDB, Polly, OTel, Aspire
- [ ] Anemic entities; business rules in services

### Documentation

- [ ] [14-stage-01-smells.md](14-stage-01-smells.md) reviewed
- [ ] This blueprint matches implemented layout on `01-LegacyMonolith`

---

## Next stage

**02-ModularMonolith:** split physical bounded contexts, introduce `InventoryItem` aggregate per [ADR-010](../adr/ADR-010-inventory-item-aggregate-root.md), add architecture tests.
