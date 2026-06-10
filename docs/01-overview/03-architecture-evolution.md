# Architecture Evolution

This document compares all four branches side by side. Use it as a quick reference when studying what changed and why.

## Evolution Summary

```
01-monolith_legacy
  Layered monolith, shared DB, direct coupling
        |
        v
02-monolith_with_cqrs
  Bounded contexts, CQRS, Mediator orchestration
        |
        v
03-monolith_with_cqrs_and_event_sourcing
  Event sourcing, RabbitMQ, ACL, modular monolith
        |
        v
04-microservices
  Two deployable services, per-service infrastructure
```

## Comparison Matrix

| Area | Branch 01 | Branch 02 | Branch 03 | Branch 04 |
|------|-----------|-----------|-----------|-----------|
| **Monolith** | Yes | Yes | Yes (modular) | No |
| **Bounded Contexts** | Logical only | Physical folders | Physical folders | Separate solutions |
| **CQRS** | Partial (read/write split) | Yes | Yes | Yes |
| **Event Sourcing** | No | No | Yes (Muflone) | Yes (Muflone) |
| **Domain Events** | No | No | Yes | Yes |
| **RabbitMQ** | No | Docker only | Yes | Yes (per service) |
| **EventStoreDB** | No | Docker only | Yes | Yes (per service) |
| **Mediator** | No | Yes | No (replaced by ACL) | No |
| **ACL** | No | No | Yes (`Sales.Acl`) | Yes |
| **Microservices** | No | No | No | Yes |
| **Architecture Tests** | No | Yes | No | No |
| **Domain Unit Tests** | No | No | Yes | Yes |

## Project Count

| Branch | Projects | Source Files (src/) |
|--------|----------|---------------------|
| 01 | 6 | 66 |
| 02 | ~15 | 125 |
| 03 | ~18 | 156 |
| 04 | 2 solutions, ~16 total | 196 |

## Persistence Evolution

| Branch | Write Store | Read Store | Cross-Context Access |
|--------|-------------|------------|----------------------|
| 01 | MongoDB (`Sales` DB) | Same MongoDB | Direct repository injection |
| 02 | MongoDB (per context) | MongoDB (per context) | Mediator calls facades |
| 03 | EventStore + Mongo persister | MongoDB read models | RabbitMQ integration events |
| 04 | EventStore (per service) | MongoDB (per service) | RabbitMQ integration events |

## API Evolution

| Capability | Branch 01 | Branch 02 | Branch 03 | Branch 04 |
|------------|-----------|-----------|-----------|-----------|
| Create order | `POST /v1/sales/` | `POST /v1/brewup/` (mediator) | `POST /v1/sales/` (command) | `POST /v1/sales/` (Sales service) |
| List orders | `GET /v1/sales/` | `GET /v1/sales/` | `GET /v1/sales/` | `GET /v1/sales/` (Sales service) |
| Set availability | `POST /v1/warehouses/availabilities` | `POST /v1/wareHouses/availabilities` | `POST /v1/warehouses/availabilities` | `POST /v1/warehouses/availabilities` (Warehouses service) |

## What Was Removed at Each Step

### 01 → 02

- `BrewUp.DomainModel` (replaced by per-context Domain projects)
- `BrewUp.ReadModel` as standalone project (moved into contexts)
- Direct cross-context repository coupling in domain services

### 02 → 03

- `BrewUp.Mediator` (replaced by event-driven integration)
- `BrewUp.Mediator.Tests`
- Anemic domain services (`SalesDomainService`, `WarehousesDomainService`)
- DTO-first persistence (replaced by event sourcing)

### 03 → 04

- Root `BrewUp.sln` and `BrewUp.Rest` host
- Root `BrewUp.Infrastructure` and `BrewUp.Shared`
- `BrewUp.Rest.Tests` integration tests
- Architecture test projects

## What Was Added at Each Step

### 01 → 02

- Sales and Warehouses bounded context projects
- `BrewUp.Mediator` for cross-context orchestration
- Facade layer per context
- Modular `Program.cs` with `IModule` pattern
- Architecture tests

### 02 → 03

- Muflone framework (commands, events, aggregates)
- EventStoreDB persistence
- RabbitMQ consumers and publishers
- Command handlers and event handlers
- `BrewUp.Sales.Acl` anti-corruption layer
- Saga support (`BeerAvailabilityCommunicated`)
- Domain unit tests

### 03 → 04

- `BrewUp.Sales.Rest` and `BrewUp.Warehouses.Rest` hosts
- Per-service `BrewUp.Shared` copies
- Per-service infrastructure configuration
- `CreateAvailabilityDueToProductionOrder` command pipeline

## Key Design Smells Fixed

| Smell (Branch 01) | Fix |
|-------------------|-----|
| Sales queries warehouse repository directly | Branch 02: Mediator; Branch 03+: integration events |
| Shared MongoDB database for all contexts | Branch 02+: separate collections/databases per context |
| Anemic aggregates (factory + DTO mapping) | Branch 03+: rich aggregates with `RaiseEvent`/`Apply` |
| No domain events | Branch 03+: explicit event types in SharedKernel |
| Single deployable unit | Branch 04: independent services |

## Related Documents

- [Architecture Evolution Workbook](../diagrams/architecture-evolution-workbook.md) — step-by-step learning guide
- [ADR-001: Introduce CQRS](../adr/ADR-001-introduce-cqrs.md)
- [ADR-002: Introduce Event Sourcing](../adr/ADR-002-introduce-event-sourcing.md)
- [ADR-003: Extract Microservices](../adr/ADR-003-extract-microservices.md)
