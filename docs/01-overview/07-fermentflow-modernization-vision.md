# FermentFlow — Modernization Vision

A personal architecture laboratory that extends the brewery logistics domain through nine modernization stages — from legacy monolith to .NET Aspire orchestration.

---

## Why FermentFlow?

| Criterion | Starting point | FermentFlow direction |
|-----------|----------------|----------------------|
| Domain fit | Brewery logistics | Same — Production → Inventory → Sales |
| Identity | Imported baseline code | Personal architecture laboratory |
| Process metaphor | Implicit | **Flow**: Production → Inventory → Sales |
| Learning value | Four baseline branches | Nine intentional stages |
| Production patterns | Core DDD/CQRS/ES | Outbox, resilience, observability, Aspire |

**Verdict:** FermentFlow gives Swamy a coherent domain story, a structured learning path, and room to experiment beyond any single baseline implementation.

### Recommended naming

```text
Repository:     fermentflow
Solution:         FermentFlow.sln
Namespaces:       FermentFlow.Sales, FermentFlow.Inventory, FermentFlow.Production
Building blocks:  FermentFlow.BuildingBlocks.*
```

### Repository name alternatives

| Name | Best for |
|------|----------|
| **fermentflow** | Primary repo (recommended) |
| **FermentFlow.NET** | NuGet / package branding |
| **FermentFlow-DDD** | DDD-focused course material |
| **FermentFlow-ReferenceApp** | GitHub portfolio showcase |

---

## Core Business Process

The name maps directly to the domain flow documented in [Business Domain](02-business-domain.md):

```text
Production
    ↓  (beer batch completed)
Inventory (`InventoryItem`; availability derived)
    ↓  (stock updated, Sales notified)
Sales Orders
    ↓  (customer purchases in-stock beer)
```

This is the same process FermentFlow models today — FermentFlow makes it explicit in the name.

---

## Mapping FermentFlow → FermentFlow

| FermentFlow (current) | FermentFlow (proposed) | Notes |
|------------------|------------------------|-------|
| `FermentFlow` | `FermentFlow` | Rename solution, namespaces, Docker services |
| `Warehouses` | `Inventory` | Better ubiquitous language; "warehouse" becomes implementation detail |
| `Availability` (legacy entity) | `InventoryItem` aggregate | `Availability` becomes derived (`OnHand - Reserved`); see [ADR-011](../02-adr/ADR-011-inventory-item-aggregate-root.md) |
| `Production` (contracts only) | `FermentFlow.Production` | Promote to full bounded context |
| `FermentFlow.Shared` | `FermentFlow.BuildingBlocks.*` | Replace duplicated shared libs with building blocks |
| Muflone | MediatR + MassTransit | Modern .NET ecosystem; easier for learners |
| MongoDB (writes, branch 01) | PostgreSQL | Relational outbox, EF Core familiarity |
| MongoDB (read models) | PostgreSQL or MongoDB | Either works; Postgres simplifies local dev |
| No outbox | Outbox pattern | Biggest production gap in original |
| No resilience | Polly v8 | Circuit breaker, retry, timeout, fallback |
| No observability | OpenTelemetry + Prometheus + Grafana | Production-grade tracing and metrics |

---

## Extended Stage Journey

FermentFlow extends the four baseline branches into nine intentional stages:

```text
01-LegacyMonolith          ← baseline 01-monolith_legacy
02-ModularMonolith         ← split from baseline 02
03-CQRS-VerticalSlices                    ← CQRS + vertical slice / feature folders
04-CQRS-EventSourcing           ← baseline 03-monolith_with_cqrs_and_event_sourcing
05-Microservices           ← baseline 04-microservices
06-OutboxPattern           ← NEW
07-CircuitBreaker          ← NEW
08-Observability           ← NEW
09-Aspire                  ← NEW (service discovery, orchestration, local DX)
```

### Why separate modular monolith, CQRS + vertical slices, and event sourcing?

Each branch introduces one major leap. Branch 02 establishes bounded contexts; branch 03 adds **CQRS and Vertical Slice Architecture together** (MediatR, feature folders); branch 04 adds event sourcing.

| Branch | Focus | Key addition |
|--------|-------|--------------|
| 01 | Layered monolith, smells | Baseline |
| 02 | Physical bounded contexts, modular monolith | Folder isolation, **architecture tests** |
| 03 | CQRS + Vertical Slice Architecture | MediatR (intra-context), application contracts, **compensation**, `InventoryReservation`, **domain unit tests**, **Testcontainers** |
| 04 | CQRS + Event sourcing | EventStoreDB; **CQRS and vertical slices retained** |
| 05 | Microservices | Separate deployables per context |
| 06 | Outbox pattern | Reliable messaging, no lost events |
| 07 | Circuit breaker | Polly v8, sync call resilience |
| 08 | Observability | OpenTelemetry, Prometheus, Grafana |
| 09 | .NET Aspire | Service discovery, orchestration, dashboards, container lifecycle |

### Architecture capabilities matrix

| Capability | 01 | 02 | 03 | 04 | 05 | 06 | 07 | 08 | 09 |
|------------|----|----|----|----|----|----|----|----|-----|
| Monolith | ✓ | ✓ | ✓ | ✓ | | | | | |
| Bounded contexts | | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Architecture tests | | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Domain unit tests | | | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Testcontainers (integration) | | | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Vertical slices | | | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| CQRS | | | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Event sourcing | | | | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Microservices | | | | | ✓ | ✓ | ✓ | ✓ | ✓ |
| Outbox | | | | | | ✓ | ✓ | ✓ | ✓ |
| Circuit breaker | | | | | | | ✓ | ✓ | ✓ |
| Observability | | | | | | | | ✓ | ✓ |
| Aspire / orchestration | | | | | | | | | ✓ |

---

## Modernized Bounded Contexts

### Keep all three — promote Production

```text
FermentFlow.Sales         — customer orders, pricing, order lifecycle
FermentFlow.Inventory     — `InventoryItem` aggregates; availability derived from on-hand minus reserved
FermentFlow.Production    — brewing batches, production orders, completion events
```

### Why Inventory over Warehouses?

| Term | Audience understanding | DDD fit |
|------|------------------------|---------|
| **Warehouses** | Physical location / infrastructure | Implementation detail |
| **Inventory** | Business concept everyone knows | Core domain language |

**Aggregate decision (accepted):** `InventoryItem` is the aggregate root; `Availability` is a derived business concept, not a separate aggregate. Stage 01 intentionally keeps an anemic `Availability` entity for refactoring practice — see [Stage 01 blueprint](13-stage-01-overview.md) and [ADR-011](../02-adr/ADR-011-inventory-item-aggregate-root.md).

### Context map (target state)

Domain events are **internal** to each context; arrows show **integration** events only. See [Event catalog](10-event-catalog.md).

```text
┌─────────────────┐
│   Production    │  domain: ProductionOrderStarted, ProductionOrderCompleted
└────────┬────────┘
         │ integration: ProductionCompleted
         v
┌─────────────────┐
│   Inventory     │  domain: StockReceived, StockReserved, StockReservationReleased
└────────┬────────┘
         │ integration: InventoryUpdated, StockAvailable, StockUnavailable
         v
┌─────────────────┐
│     Sales       │  domain: SalesOrderCreated, SalesOrderClosed
└─────────────────┘
         │ integration: OrderPlaced, OrderConfirmed (downstream)
```

Sales may also call Inventory synchronously (with circuit breaker) for real-time stock checks during order placement.

---

## Saga strategy (stage 10 — reserved)

The domain flow `Production → Inventory → Sales` is a natural **long-running workflow**. Stage **`10-EventDrivenSagas`** is reserved before Kubernetes.

| Aspect | Choice |
|--------|--------|
| **Saga style** | Orchestration |
| **Technology** | MassTransit state machine |
| **Saga persistence** | PostgreSQL |
| **Stage** | `10-EventDrivenSagas` |
| **Stack fit** | MassTransit + RabbitMQ + .NET Aspire (branch 09) |

Example orchestrated saga:

```text
ProductionCompleted
        ↓
InventoryUpdated
        ↓
InventoryAvailable
        ↓
ReleasePendingSalesOrders
```

Decision record: [ADR-010](../02-adr/ADR-010-introduce-event-driven-sagas.md) *(Proposed)*. Detail: [Architecture governance](09-architecture-governance.md).

---

## Solution Structure

```text
src/
├── FermentFlow.sln
│
├── BuildingBlocks/
│   ├── FermentFlow.BuildingBlocks.Domain/         # Entity, AggregateRoot, ValueObject, IDomainEvent
│   ├── FermentFlow.BuildingBlocks.Application/    # ICommand, IQuery, pipeline behaviors
│   ├── FermentFlow.BuildingBlocks.Persistence/    # EF Core, repositories (not generic Infrastructure)
│   ├── FermentFlow.BuildingBlocks.EventSourcing/  # EventStore client, aggregate rehydration
│   ├── FermentFlow.BuildingBlocks.Messaging/      # MassTransit abstractions, integration events
│   ├── FermentFlow.BuildingBlocks.Outbox/         # Outbox table, background publisher (branch 06+)
│   ├── FermentFlow.BuildingBlocks.Resilience/     # Polly v8 policies (branch 07+)
│   ├── FermentFlow.BuildingBlocks.Observability/  # OpenTelemetry, Serilog enrichers (branch 08+)
│   └── FermentFlow.BuildingBlocks.Testing/        # Shared test fixtures and fakes
│
├── Services/
│   ├── Sales/
│   │   ├── FermentFlow.Sales.Api/
│   │   ├── FermentFlow.Sales.Application/
│   │   ├── FermentFlow.Sales.Domain/
│   │   └── FermentFlow.Sales.Infrastructure/
│   ├── Inventory/
│   │   ├── FermentFlow.Inventory.Api/
│   │   ├── FermentFlow.Inventory.Application/
│   │   ├── FermentFlow.Inventory.Domain/
│   │   └── FermentFlow.Inventory.Infrastructure/
│   └── Production/
│       ├── FermentFlow.Production.Api/
│       ├── FermentFlow.Production.Application/
│       ├── FermentFlow.Production.Domain/
│       └── FermentFlow.Production.Infrastructure/
│
├── Gateway/
│   └── FermentFlow.ApiGateway/                   # YARP or Aspire service discovery
│
└── Tests/
    ├── FermentFlow.Architecture.Tests/
    ├── FermentFlow.Sales.UnitTests/
    ├── FermentFlow.Inventory.UnitTests/
    ├── FermentFlow.Production.UnitTests/
    └── FermentFlow.IntegrationTests/             # Testcontainers
```

### Per-service internal layout (clean architecture)

```text
Api            → HTTP endpoints, request validation
Application    → MediatR handlers, DTOs, integration event handlers
Domain         → Aggregates, value objects, domain events, invariants
Infrastructure → EF Core, EventStore, MassTransit adapters (per context — not BuildingBlocks.Infrastructure)
```

> **Governance:** avoid `FermentFlow.BuildingBlocks.Infrastructure`; split into `Persistence`, `Messaging`, `EventSourcing`, etc. See [Architecture governance](09-architecture-governance.md).

---

## Circuit Breaker Placement

FermentFlow branch 04 uses **only async messaging** between services. FermentFlow adds **synchronous paths with resilience** where low-latency reads are needed.

### When to use sync + Polly vs async messaging

| Scenario | Pattern | Polly policies |
|----------|---------|----------------|
| Order placement needs live stock check | Sales → Inventory (HTTP/gRPC) | Retry, Timeout, CircuitBreaker, Fallback |
| Inventory needs production schedule | Inventory → Production (HTTP/gRPC) | Retry, Timeout, CircuitBreaker |
| Stock update notification | Inventory → Sales (async) | Outbox + MassTransit (no Polly on publish) |
| Read model refresh | Event handler → DB | Retry, Timeout |
| External payment / shipping | Sales → External API | Full suite + RateLimiter |

### Polly v8 policy example (conceptual)

```csharp
// FermentFlow.BuildingBlocks.Resilience
services.AddResilienceHandler("inventory-check", builder =>
{
    builder
        .AddRetry(new RetryStrategyOptions { MaxRetryAttempts = 3 })
        .AddCircuitBreaker(new CircuitBreakerStrategyOptions
        {
            FailureRatio = 0.5,
            MinimumThroughput = 10,
            BreakDuration = TimeSpan.FromSeconds(30)
        })
        .AddTimeout(TimeSpan.FromSeconds(5))
        .AddFallback(fallback);
});
```

### Fallback strategy for Sales → Inventory

When the circuit is open during order placement:

1. **Reject order** with "inventory service unavailable" (safest)
2. **Use cached read model** with stale-stock warning (pragmatic)
3. **Queue order** for later validation (eventual)

Option 1 is recommended for learning; option 2 is common in production.

---

## Outbox Pattern

The single biggest improvement over the original FermentFlow architecture.

### Current FermentFlow flow (branch 03–04)

```text
Aggregate → RaiseEvent → EventStore + RabbitMQ publish
```

**Risk:** EventStore commit succeeds but RabbitMQ publish fails → lost integration event.

### FermentFlow flow (branch 06+)

```text
Aggregate
   │
   v
Domain Event(s) collected in aggregate
   │
   v
Single DB transaction:
   ├── Aggregate state / event stream (EventStore or outbox-compatible store)
   └── Outbox table (pending integration events)
   │
   v
Background publisher (hosted service / MassTransit outbox)
   │
   v
RabbitMQ → consumer in target service
```

### Benefits

| Benefit | Explanation |
|---------|-------------|
| **No lost events** | Outbox row committed in same transaction as domain change |
| **At-least-once delivery** | Publisher retries until broker acknowledges |
| **Transactional consistency** | Domain write and event intent are atomic |
| **Production-ready** | Industry standard for reliable messaging |

### Implementation options

| Option | Complexity | Recommendation |
|--------|------------|----------------|
| Custom outbox table + background worker | Medium | Good for learning (branch 06) |
| MassTransit EF outbox | Lower | Use from branch 07 onward |
| PostgreSQL + `INSERT ... RETURNING` | Low | Natural fit with EF Core |

### Outbox table schema (minimal)

```sql
CREATE TABLE outbox_messages (
    id            UUID PRIMARY KEY,
    occurred_on   TIMESTAMPTZ NOT NULL,
    type          VARCHAR(500) NOT NULL,
    payload       JSONB NOT NULL,
    processed_on  TIMESTAMPTZ,
    error         TEXT
);
```

---

## Technology Stack

| Area | FermentFlow (original) | FermentFlow (proposed) | Rationale |
|------|-------------------|------------------------|-----------|
| Runtime | .NET 7/8 | **.NET 10** | Latest LTS trajectory |
| API | Minimal APIs | ASP.NET Core Minimal APIs | Keep simplicity |
| CQRS | Muflone / manual | **MediatR** | De-facto .NET standard, huge community |
| Messaging | Muflone.Transport.RabbitMQ | **MassTransit** | Outbox built-in, sagas, test harness |
| Broker | RabbitMQ | RabbitMQ | Keep — works well with MassTransit |
| Write DB | MongoDB / EventStore | **PostgreSQL** + EventStoreDB | Outbox needs relational transactions |
| Read model | MongoDB | PostgreSQL or MongoDB | Postgres reduces moving parts locally |
| Event store | EventStoreDB | EventStoreDB | Keep — purpose-built |
| Resilience | None | **Polly v8** | `Microsoft.Extensions.Resilience` |
| Logging | Serilog | Serilog | Keep |
| Tracing | None | **OpenTelemetry** | W3C trace context across services |
| Metrics | None | **Prometheus** + Grafana | Standard cloud-native stack |
| Tests | xUnit | **xUnit + Testcontainers** | Real Postgres/RabbitMQ in CI |
| Orchestration | Docker Compose | Docker Compose → **.NET Aspire** | Branch 09 |

### MediatR vs Muflone

| Aspect | Legacy baseline (Muflone) | Target stack (FermentFlow) |
|--------|---------------------------|----------------------------|
| Learning curve | Steeper, less docs | Gentle, massive community |
| Event sourcing | Built-in | EventStore client + custom aggregate base |
| Messaging | Built-in RabbitMQ | MassTransit (outbox, sagas) |
| Ecosystem | Older patterns | Modern .NET 10 defaults |

Keeping event sourcing concepts from the baseline but implementing with MediatR + MassTransit is the intended modernization path.

---

## Evolution Within This Repository

This repo is Swamy's **personal architecture laboratory**. Baseline branches provide a starting implementation; stages 06–09 add production-oriented patterns on top.

### Migration strategy

```text
Phase 1 — Document (in progress)
  └── Nine-stage roadmap in README and /docs

Phase 2 — Port baseline
  └── Stages 01–05 from legacy branch names and stack

Phase 3 — Modernize stack
  └── .NET 10, PostgreSQL, MediatR, MassTransit, Inventory rename

Phase 4 — Extend stages 06–09
  └── Outbox, Polly, OpenTelemetry, .NET Aspire
```

### What to preserve

- Domain rules (availability check before order, production-driven stock)
- Aggregate boundaries (SalesOrder, InventoryItem)
- Evolution narrative (monolith → microservices → Aspire)
- ADR format and architecture workbook structure

### What to change

- Context naming: Warehouses → Inventory
- Production promoted to **full bounded context** from branch 02 target (baseline import: contracts only — see [Business Domain](02-business-domain.md))
- Muflone → MediatR + MassTransit
- MongoDB writes → PostgreSQL + outbox
- Add resilience, observability, and Aspire orchestration

---

## Architecture Decision Records

All major branch decisions are documented under [`docs/02-adr/`](../02-adr/README.md):

| ADR | Branch |
|-----|--------|
| ADR-001 | *(Establish FermentFlow — foundation)* |
| ADR-002 | 02-ModularMonolith |
| ADR-003 | 03-CQRS-VerticalSlices |
| ADR-004 | 04-CQRS-EventSourcing |
| ADR-005 | 05-Microservices |
| ADR-006 | 06-OutboxPattern |
| ADR-007 | 07-CircuitBreaker |
| ADR-008 | 08-Observability |
| ADR-009 | 09-Aspire |
| ADR-010 | 10-EventDrivenSagas *(Proposed)* |
| ADR-011 | `02-ModularMonolith`+ *(InventoryItem aggregate)* |
| ADR-012 | `02-ModularMonolith`+ *(Production bounded context)* |
| ADR-013 | `03-CQRS-VerticalSlices` *(cross-context contracts)* |
| ADR-014 | `03-CQRS-VerticalSlices` *(compensating actions)* |

Process, architecture tests, and Definition of Done: [Architecture governance](09-architecture-governance.md).

---

## Summary

FermentFlow is Swamy's personal architecture laboratory for brewery logistics:

1. **Nine stages** — from legacy monolith to .NET Aspire
2. **Inventory** — clearer ubiquitous language than Warehouses
3. **Architecture tests + ADRs** — from branch 02; see `docs/02-adr/` and [Architecture governance](09-architecture-governance.md)
4. **Outbox** — reliable integration events
5. **Polly + OpenTelemetry** — resilience and observability
6. **Aspire at stage 09** — service discovery, orchestration, and local developer experience
7. **Stack** — .NET 10, MediatR, MassTransit, PostgreSQL as modern defaults
