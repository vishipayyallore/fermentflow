# Branch Roadmap

Per-branch source layout and learning focus for the nine-stage FermentFlow evolution.

**Canonical index:** [Repository structure](../01_repository-structure.md) — roadmap, naming, and documentation layout.

---

## Branch 01 — Legacy Monolith

```text
src/
│
├── FermentFlow.DomainModel
├── FermentFlow.Infrastructure
├── FermentFlow.ReadModel
├── FermentFlow.Rest
├── FermentFlow.Shared
└── FermentFlow.sln
```

Characteristics:

- Layered architecture
- Single deployable
- Shared database
- Direct repository coupling
- No domain events

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
```

Characteristics:

- Bounded contexts
- Modular monolith
- Shared deployment
- Explicit domain boundaries

---

## Branch 03 — CQRS + Vertical Slice Architecture

```text
src/
│
├── BuildingBlocks/
│   ├── FermentFlow.BuildingBlocks.Domain
│   ├── FermentFlow.BuildingBlocks.Application
│   └── FermentFlow.BuildingBlocks.Infrastructure
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
│   │   ├── CreateAvailability/
│   │   ├── UpdateAvailability/
│   │   ├── GetAvailability/
│   │   └── ReserveInventory/
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
```

Characteristics:

- MediatR
- CQRS
- Vertical Slice Architecture
- Feature-based organization
- Independent use-case slices

---

## Branch 04 — Event Sourcing

```text
src/
│
├── BuildingBlocks/
│   ├── Domain/
│   ├── Application/
│   ├── EventSourcing/
│   └── Infrastructure/
│
├── Sales/
├── Inventory/
├── Production/
│
└── FermentFlow.sln
```

Characteristics:

- EventStoreDB
- Domain Events
- Aggregate Rehydration
- Projections
- Event-Driven Domain Model

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
```

Characteristics:

- Independent services
- RabbitMQ integration events
- Separate databases
- Separate deployments

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
└── Tests/
```

Characteristics:

- Transactional Outbox
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
└── Tests/
```

Characteristics:

- Polly v8
- Retry
- Timeout
- Circuit Breaker
- Fallback
- Resilience Pipelines

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
└── Tests/
```

Characteristics:

- OpenTelemetry
- Distributed Tracing
- Metrics
- Dashboards
- Structured Logging

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
└── Tests/
```

Characteristics:

- .NET Aspire
- Service Discovery
- Resource Orchestration
- Aspire Dashboard
- Distributed Application Host
- Local Cloud-Native Development
