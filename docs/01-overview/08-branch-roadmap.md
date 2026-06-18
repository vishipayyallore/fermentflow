# Branch Roadmap

Per-stage source layout and learning focus for the nine-stage FermentFlow evolution.

**Terminology:** [Stage vs git branch](../01_repository-structure.md#stage-vs-git-branch) — use **Stage NN** in prose; use git branch slugs for `git checkout`.

**Canonical index:** [Repository structure](../01_repository-structure.md) — roadmap, naming, and documentation layout.  
**Decisions:** [Architecture Decision Records](../02-adr/README.md) — one ADR per major branch from 02 onward.

---

## Branch 01 — Legacy Monolith

**Blueprint:** [13-stage-01-overview.md](13-stage-01-overview.md) · **Smells:** [14-stage-01-smells.md](14-stage-01-smells.md)

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

Characteristics:

- Layered architecture
- Single deployable
- PostgreSQL + EF Core (shared `FermentFlowDbContext`)
- Anemic `Availability` entity / `Availabilities` table (refactored to `InventoryItem` in branch 02)
- Direct repository coupling (`SalesOrderService` → `InventoryRepository`)
- No domain events, CQRS, or DDD tactical patterns

---

## Branch 02 — Modular Monolith

```text
src/
│
├── Sales/
│   ├── FermentFlow.Sales.Domain
│   ├── FermentFlow.Sales.Application
│   ├── FermentFlow.Sales.Infrastructure
│
├── Inventory/
│   ├── FermentFlow.Inventory.Domain
│   ├── FermentFlow.Inventory.Application
│   ├── FermentFlow.Inventory.Infrastructure
│
├── Production/
│   ├── FermentFlow.Production.Domain
│   ├── FermentFlow.Production.Application
│   └── FermentFlow.Production.Infrastructure
│
├── BuildingBlocks/
│
└── FermentFlow.sln

tests/
└── FermentFlow.Architecture.Tests
```

Characteristics:

- Bounded contexts
- Modular monolith
- Shared deployment
- Explicit domain boundaries
- **`InventoryItem` aggregate** replaces Stage 01 anemic `Availability` — [ADR-011](../02-adr/ADR-011-inventory-item-aggregate-root.md)
- **Architecture tests** (NetArchTest.Rules or ArchUnitNET) — see [ADR-002](../02-adr/ADR-002-introduce-modular-monolith.md)

Example rules:

```text
Sales must not reference Inventory.Infrastructure
Domain must not reference Application or Infrastructure
Application must not reference another context's Infrastructure
```

---

## Branch 03 — CQRS + Vertical Slice Architecture

```text
src/
│
├── BuildingBlocks/
│   ├── FermentFlow.BuildingBlocks.Domain
│   ├── FermentFlow.BuildingBlocks.Application
│   └── (minimal shared helpers — avoid a monolithic Infrastructure project)
│
├── Sales/
│   ├── Features/
│   │   ├── CreateSalesOrder/
│   │   ├── GetSalesOrder/
│   │   ├── GetSalesOrders/
│   │   └── CloseSalesOrder/
│   │
│   ├── Domain/
│   └── Infrastructure/
│
├── Inventory/
│   ├── Features/
│   │   ├── ReceiveStock/
│   │   ├── ReserveStock/
│   │   ├── ReleaseStockReservation/
│   │   ├── GetInventoryItem/
│   │   └── AdjustInventory/
│   │
│   ├── Domain/
│   └── Infrastructure/
│
├── Production/
│   ├── Features/
│   │   ├── CreateProductionOrder/
│   │   ├── StartProductionBatch/
│   │   └── CompleteProductionBatch/
│   │
│   ├── Domain/
│   └── Infrastructure/
│
└── FermentFlow.sln

tests/
├── FermentFlow.Architecture.Tests
├── FermentFlow.Sales.UnitTests
├── FermentFlow.Inventory.UnitTests
├── FermentFlow.Production.UnitTests
└── FermentFlow.IntegrationTests    # Testcontainers — PostgreSQL
```

Characteristics:

- MediatR **within** each context only (not cross-context)
- CQRS + Vertical Slice Architecture (`Features/` per use case)
- **Cross-context collaboration** via consumer-owned contracts — [ADR-013](../02-adr/ADR-013-cross-context-collaboration-modular-monolith.md)
- **Compensation** on partial failure (`ReleaseStockReservation`); **no** `TransactionScope` across contexts — [ADR-014](../02-adr/ADR-014-compensating-actions-stage-03.md)
- **`InventoryReservation`** as first-class entity; MediatR **intra-context only** (architecture tests)
- Preferred flow: `ReserveStock` → `SalesOrder.Create` → compensate on failure
- **Domain unit tests** per context (aggregate invariants, Given/When/Then)
- **Testcontainers** for integration tests against real PostgreSQL

Example domain test:

```text
Given stock of 10
When order requests 15
Then order is rejected
```

Decisions: [ADR-003](../02-adr/ADR-003-introduce-cqrs.md) · [ADR-013](../02-adr/ADR-013-cross-context-collaboration-modular-monolith.md) · [ADR-014](../02-adr/ADR-014-compensating-actions-stage-03.md) · [16-stage-03-cross-context-collaboration.md](16-stage-03-cross-context-collaboration.md)

---

## Branch 04 — CQRS + Event Sourcing

Branch **04** retains CQRS and vertical slices from branch 03 and **adds** event sourcing — see [ADR-004](../02-adr/ADR-004-introduce-event-sourcing.md).

```text
src/
│
├── BuildingBlocks/
│   ├── Domain/
│   ├── Application/
│   ├── Persistence/
│   ├── EventSourcing/
│   └── Messaging/
│
├── Sales/          # Features/, Domain/, Infrastructure/ retained
├── Inventory/
├── Production/
│
└── FermentFlow.sln

tests/
└── FermentFlow.Architecture.Tests
```

Characteristics:

- **CQRS retained** (commands, queries, MediatR, vertical slices)
- EventStoreDB
- Domain events and aggregate rehydration
- Projections for read models
- Event-driven domain model
- Testcontainers extended: **PostgreSQL + RabbitMQ + EventStoreDB**

---

## Branch 05 — Microservices

```text
src/
│
├── Services/
│   ├── Sales/
│   │   ├── Features/
│   │   ├── Domain/
│   │   └── Infrastructure/
│   │
│   ├── Inventory/
│   │   ├── Features/
│   │   ├── Domain/
│   │   └── Infrastructure/
│   │
│   └── Production/
│       ├── Features/
│       ├── Domain/
│       └── Infrastructure/
│
├── BuildingBlocks/
│
└── Gateway/

tests/
└── FermentFlow.Architecture.Tests
```

Characteristics:

- Independent services
- RabbitMQ + MassTransit integration events
- Separate databases per service
- Separate deployments

Decision: [ADR-005](../02-adr/ADR-005-introduce-microservices.md)

---

## Branch 06 — Outbox Pattern

```text
src/
│
├── BuildingBlocks/
│   ├── Messaging/
│   └── Outbox/
│
├── Services/
│
tests/
├── FermentFlow.Architecture.Tests
└── FermentFlow.Integration.Tests
```

Characteristics:

- Transactional outbox (before circuit breaker — see [ADR-006](../02-adr/ADR-006-introduce-outbox.md))
- Reliable publishing
- Background processors
- At-least-once delivery

---

## Branch 07 — Circuit Breaker

```text
src/
│
├── BuildingBlocks/
│   └── Resilience/
│
├── Services/
│
tests/
├── FermentFlow.Architecture.Tests
└── FermentFlow.Integration.Tests
```

Characteristics:

- Polly v8
- Retry, timeout, circuit breaker, fallback
- Resilience pipelines for sync calls — [ADR-007](../02-adr/ADR-007-introduce-circuit-breaker.md)

---

## Branch 08 — Observability

```text
src/
│
├── BuildingBlocks/
│   └── Observability/
│
├── Services/
│
├── Monitoring/
│   ├── Prometheus/
│   └── Grafana/
│
tests/
├── FermentFlow.Architecture.Tests
└── FermentFlow.Integration.Tests
```

Characteristics:

- OpenTelemetry, Prometheus, Grafana — [ADR-008](../02-adr/ADR-008-introduce-observability.md)
- Distributed tracing, metrics, structured logging

---

## Branch 09 — Aspire

```text
src/
│
├── FermentFlow.AppHost
├── FermentFlow.ServiceDefaults
│
├── Services/
│   ├── Sales/
│   ├── Inventory/
│   └── Production/
│
├── BuildingBlocks/
│
tests/
├── FermentFlow.Architecture.Tests
└── FermentFlow.Integration.Tests
```

Characteristics:

- .NET Aspire — [ADR-009](../02-adr/ADR-009-introduce-aspire.md)
- Service discovery, resource orchestration, Aspire dashboard
- Local cloud-native development

---

## Optional Future Stages

```text
10-EventDrivenSagas      # Production → Inventory → Sales orchestration
11-Kubernetes
12-GitHubActions
13-AzureContainerApps
14-MultiTenancy
```

Stage 10 additions:

```text
BuildingBlocks/
└── Sagas/               # MassTransit state machine, PostgreSQL saga persistence
```

Saga persistence: **PostgreSQL** (see [ADR-010](../02-adr/ADR-010-introduce-event-driven-sagas.md)).

Example saga flow (stage 10):

```text
ProductionCompleted → InventoryUpdated → StockAvailable → PendingSalesOrdersReleased
```

Decision record: [ADR-010](../02-adr/ADR-010-introduce-event-driven-sagas.md) *(Proposed)*.
