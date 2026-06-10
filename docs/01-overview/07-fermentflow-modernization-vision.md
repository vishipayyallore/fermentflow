# FermentFlow — Modernization Vision

A proposed evolution of the FermentFlow reference application into **FermentFlow**: a distinct, production-grade DDD learning platform that preserves the brewery logistics domain while extending the architectural journey.

---

## Why FermentFlow?

| Criterion | FermentFlow (original) | FermentFlow (proposed) |
|-----------|-------------------|------------------------|
| Domain fit | Brewery logistics | Same — brewery logistics |
| Name distinctiveness | Packt book sample | Standalone product identity |
| Process metaphor | Implicit | **Flow**: Production → Inventory → Sales |
| Learning value | 4 branches | 9 branches (legacy → cloud-native) |
| Production readiness | Teaching sample | Outbox, resilience, observability |

**Verdict:** FermentFlow is a strong choice. It reads as a real product, a learning platform, and a portfolio project simultaneously.

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
Inventory / Availability
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
| `Availability` | `InventoryItem` or keep `Availability` | Aggregate name can stay; context is `Inventory` |
| `Production` (contracts only) | `FermentFlow.Production` | Promote to full bounded context |
| `FermentFlow.Shared` | `FermentFlow.BuildingBlocks.*` | Replace duplicated shared libs with building blocks |
| Muflone | MediatR + MassTransit | Modern .NET ecosystem; easier for learners |
| MongoDB (writes, branch 01) | PostgreSQL | Relational outbox, EF Core familiarity |
| MongoDB (read models) | PostgreSQL or MongoDB | Either works; Postgres simplifies local dev |
| No outbox | Outbox pattern | Biggest production gap in original |
| No resilience | Polly v8 | Circuit breaker, retry, timeout, fallback |
| No observability | OpenTelemetry + Prometheus + Grafana | Production-grade tracing and metrics |

---

## Extended Branch Journey

The original Packt repo has 4 branches. FermentFlow extends to 9:

```text
01-LegacyMonolith          ← maps to FermentFlow 01-monolith_legacy
02-ModularMonolith         ← maps to FermentFlow 02-monolith_with_cqrs
03-CQRS                    ← split from FermentFlow 02 (explicit CQRS step)
04-EventSourcing           ← maps to FermentFlow 03-monolith_with_cqrs_and_event_sourcing
05-Microservices           ← maps to FermentFlow 04-microservices
06-OutboxPattern           ← NEW
07-CircuitBreaker          ← NEW
08-Observability           ← NEW
09-CloudNative             ← NEW (Aspire, containers, deployment)
```

### Why split CQRS and Event Sourcing?

FermentFlow branch 02 already has CQRS but branch 03 adds event sourcing — they are combined in one jump. Separating them makes each concept easier to teach:

| Branch | Focus | Key addition |
|--------|-------|--------------|
| 01 | Layered monolith, smells | Baseline |
| 02 | Physical bounded contexts, modular monolith | Folder isolation, `IModule` |
| 03 | CQRS (command/query split) | MediatR, separate read/write paths |
| 04 | Event sourcing | EventStoreDB, domain events, projections |
| 05 | Microservices | Separate deployables per context |
| 06 | Outbox pattern | Reliable messaging, no lost events |
| 07 | Circuit breaker | Polly v8, sync call resilience |
| 08 | Observability | OpenTelemetry, Prometheus, Grafana |
| 09 | Cloud-native | .NET Aspire, container orchestration |

### Architecture capabilities matrix

| Capability | 01 | 02 | 03 | 04 | 05 | 06 | 07 | 08 | 09 |
|------------|----|----|----|----|----|----|----|----|-----|
| Monolith | ✓ | ✓ | ✓ | ✓ | | | | | |
| Bounded contexts | | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| CQRS | | | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Event sourcing | | | | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Microservices | | | | | ✓ | ✓ | ✓ | ✓ | ✓ |
| Outbox | | | | | | ✓ | ✓ | ✓ | ✓ |
| Circuit breaker | | | | | | | ✓ | ✓ | ✓ |
| Observability | | | | | | | | ✓ | ✓ |
| Cloud-native | | | | | | | | | ✓ |

---

## Modernized Bounded Contexts

### Keep all three — promote Production

```text
FermentFlow.Sales         — customer orders, pricing, order lifecycle
FermentFlow.Inventory     — stock levels, availability, reservations
FermentFlow.Production    — brewing batches, production orders, completion events
```

### Why Inventory over Warehouses?

| Term | Audience understanding | DDD fit |
|------|------------------------|---------|
| **Warehouses** | Physical location / infrastructure | Implementation detail |
| **Inventory** | Business concept everyone knows | Core domain language |

The aggregate can remain `Availability` or become `StockLevel` / `InventoryItem` inside the Inventory context. The context name changes; the concept does not.

### Context map (target state)

```text
┌─────────────────┐
│   Production    │  publishes: BatchCompleted, StockProduced
└────────┬────────┘
         │ integration event
         v
┌─────────────────┐
│   Inventory     │  publishes: AvailabilityChanged, StockReserved
└────────┬────────┘
         │ integration event
         v
┌─────────────────┐
│     Sales       │  publishes: OrderPlaced, OrderConfirmed
└─────────────────┘
```

Sales may also call Inventory synchronously (with circuit breaker) for real-time stock checks during order placement.

---

## Solution Structure

```text
src/
├── FermentFlow.sln
│
├── BuildingBlocks/
│   ├── FermentFlow.BuildingBlocks.Domain/        # Entity, AggregateRoot, ValueObject, IDomainEvent
│   ├── FermentFlow.BuildingBlocks.Application/   # ICommand, IQuery, pipeline behaviors
│   ├── FermentFlow.BuildingBlocks.Infrastructure/ # EF Core, EventStore client
│   ├── FermentFlow.BuildingBlocks.Messaging/     # MassTransit abstractions, integration events
│   ├── FermentFlow.BuildingBlocks.Outbox/        # Outbox table, background publisher
│   ├── FermentFlow.BuildingBlocks.Resilience/    # Polly v8 policies, HttpClient factory
│   └── FermentFlow.BuildingBlocks.Observability/   # OpenTelemetry, Serilog enrichers
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
│   │   └── FermentFlow.Infrastructure/
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
Api          → HTTP endpoints, request validation
Application  → MediatR handlers, DTOs, integration event handlers
Domain       → Aggregates, value objects, domain events, invariants
Infrastructure → EF Core, EventStore, MassTransit, outbox, Polly
```

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

| Aspect | Muflone (FermentFlow) | MediatR (FermentFlow) |
|--------|------------------|----------------------|
| Learning curve | Steeper, less docs | Gentle, massive community |
| Event sourcing | Built-in | Pair with EventStore client + custom aggregate base |
| Messaging | Built-in RabbitMQ | MassTransit (better outbox, sagas) |
| Book alignment | Packt original | Modern .NET ecosystem |

Keeping event sourcing concepts from FermentFlow but implementing with MediatR + MassTransit is the right trade-off for a learning platform.

---

## Relationship to Current Repository

This repo (**Domain-driven-Refactoring**) remains the **FermentFlow baseline**. FermentFlow is the proposed **successor project**.

### Migration strategy

```text
Phase 1 — Document (done)
  └── FermentFlow docs in /docs (current repo)

Phase 2 — Scaffold FermentFlow
  └── New repo: fermentflow
  └── Branch 01: port FermentFlow 01-monolith_legacy → FermentFlow 01-LegacyMonolith
  └── Rename Warehouses → Inventory in docs and code

Phase 3 — Extend branches 02–05
  └── Port and modernize FermentFlow branches with new stack

Phase 4 — Add branches 06–09
  └── Outbox, Polly, OpenTelemetry, Aspire
```

### What to keep from FermentFlow verbatim

- Domain rules (availability check before order, production-driven stock)
- Aggregate boundaries (SalesOrder, Availability/InventoryItem)
- Evolution narrative (monolith → microservices)
- ADR format and workbook structure

### What to change

- Name, namespaces, Docker service names
- Warehouses → Inventory context
- Production promoted from contracts to full service
- Muflone → MediatR + MassTransit
- MongoDB writes → PostgreSQL + outbox
- Add resilience and observability layers

---

## Suggested ADRs for New Branches

| ADR | Branch | Decision |
|-----|--------|----------|
| ADR-004 | 06 | Adopt transactional outbox for integration events |
| ADR-005 | 07 | Add Polly resilience for sync cross-service calls |
| ADR-006 | 08 | Adopt OpenTelemetry + Prometheus for observability |
| ADR-007 | 09 | Adopt .NET Aspire for local orchestration and deployment |

---

## Summary

FermentFlow is a well-aligned modernization of FermentFlow:

1. **Name** — strong, domain-fitting, distinct
2. **Inventory** — better ubiquitous language than Warehouses
3. **9 branches** — significantly more learning value than 4
4. **Building blocks** — eliminates duplicated `FermentFlow.Shared` anti-pattern from branch 04
5. **Outbox** — the highest-impact production improvement
6. **Polly + OpenTelemetry** — completes the cloud-native story
7. **Stack** — MediatR, MassTransit, PostgreSQL are modern .NET defaults

The current FermentFlow repo is the foundation. FermentFlow is where the architecture earns production credibility.
