# Branch Roadmap

Per-branch source layout and learning focus for the nine-stage FermentFlow evolution.

**Canonical index:** [Repository structure](../01_repository-structure.md) — roadmap, naming, and documentation layout.  
**Decisions:** [Architecture Decision Records](../adr/README.md) — one ADR per major branch from 02 onward.

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

tests/
└── FermentFlow.Architecture.Tests
```

Characteristics:

- Bounded contexts
- Modular monolith
- Shared deployment
- Explicit domain boundaries
- **Architecture tests** (NetArchTest.Rules or ArchUnitNET) — see [ADR-001](../adr/ADR-001-introduce-modular-monolith.md)

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

tests/
└── FermentFlow.Architecture.Tests
```

Characteristics:

- MediatR
- CQRS
- Vertical Slice Architecture
- Feature-based organization
- Independent use-case slices

Decision: [ADR-002](../adr/ADR-002-introduce-cqrs.md)

---

## Branch 04 — CQRS + Event Sourcing

Branch **04** retains CQRS and vertical slices from branch 03 and **adds** event sourcing — see [ADR-003](../adr/ADR-003-introduce-event-sourcing.md).

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

Decision: [ADR-004](../adr/ADR-004-introduce-microservices.md)

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

- Transactional outbox (before circuit breaker — see [ADR-005](../adr/ADR-005-introduce-outbox.md))
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
- Resilience pipelines for sync calls — [ADR-006](../adr/ADR-006-introduce-circuit-breaker.md)

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

- OpenTelemetry, Prometheus, Grafana — [ADR-007](../adr/ADR-007-introduce-observability.md)
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

- .NET Aspire — [ADR-008](../adr/ADR-008-introduce-aspire.md)
- Service discovery, resource orchestration, Aspire dashboard
- Local cloud-native development

---

## Optional Future Stages

```text
10-Kubernetes
11-GitHubActions
12-AzureContainerApps
13-EventDrivenSagas      # Production → Inventory → Sales saga
14-MultiTenancy
```
