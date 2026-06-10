# FermentFlow

A .NET 10 architecture laboratory that evolves a brewery logistics domain from a legacy monolith to resilient microservices using DDD, CQRS, Event Sourcing, Outbox, Circuit Breaker, Observability, and .NET Aspire.

## Scope (read this first)

This repository is **Swamy PKV's personal software architecture and Domain-Driven Design laboratory**.

FermentFlow explores how a business domain evolves from a legacy monolith into a modern, resilient, cloud-native distributed system using contemporary .NET practices.

The business domain is **brewery logistics management**: coordinating beer production, inventory availability, and customer sales orders.

| Aspect        | Detail                                                                                            |
| ------------- | ------------------------------------------------------------------------------------------------- |
| Audience      | Swamy only                                                                                        |
| Purpose       | DDD learning, architecture experimentation, modernization patterns, and reference implementations |
| Domain        | Brewery logistics (Production → Inventory → Sales)                                                |
| Runtime       | .NET 10                                                                                           |
| Architecture  | DDD, CQRS, Event Sourcing, Microservices                                                          |
| Modernization | Outbox Pattern, Circuit Breaker, Observability, .NET Aspire                                       |
| Goal          | Understand architectural evolution through incremental refactoring                                |

Public visibility is **not** an invitation to treat this repository as production-ready software, a framework, or an official learning resource.

---

## What is FermentFlow?

FermentFlow models a brewery logistics platform.

Core business capabilities:

- Create sales orders
- Manage inventory availability
- Validate stock before sales
- Process production-driven stock updates
- Build query-optimized read models
- Communicate between bounded contexts using events

Business flow:

```text
Production
    ↓
Inventory
    ↓
Sales
```

---

## Learning Roadmap

The repository intentionally evolves through multiple architectural stages.

```text
01-LegacyMonolith
        ↓
02-ModularMonolith
        ↓
03-CQRS
        ↓
04-EventSourcing
        ↓
05-Microservices
        ↓
06-OutboxPattern
        ↓
07-CircuitBreaker
        ↓
08-Observability
        ↓
09-Aspire
```

Each stage introduces a specific architectural concept while preserving the same business domain.

Optional future stages:

```text
10-Kubernetes
11-GitHubActions
12-AzureContainerApps
13-EventDrivenSagas
```

---

## Technology Stack

| Area              | Technology                |
| ----------------- | ------------------------- |
| Runtime           | .NET 10                   |
| API               | ASP.NET Core Minimal APIs |
| Architecture      | Domain-Driven Design      |
| CQRS              | MediatR                   |
| Messaging         | MassTransit               |
| Broker            | RabbitMQ                  |
| Event Store       | EventStoreDB              |
| Database          | PostgreSQL                |
| Resilience        | Polly                     |
| Service Discovery | .NET Aspire               |
| Orchestration     | .NET Aspire               |
| Observability     | OpenTelemetry             |
| Metrics           | Prometheus                |
| Dashboards        | Grafana                   |
| Logging           | Serilog                   |
| Testing           | xUnit + Testcontainers    |
| Containers        | Docker                    |

---

## Repository Layout

```text
src/
├── BuildingBlocks/
├── Services/
│   ├── Sales/
│   ├── Inventory/
│   └── Production/
├── Gateway/
└── Tests/

docs/
tools/
```

---

## Bounded Contexts

### Sales

Responsible for:

- Sales orders
- Order lifecycle
- Customer purchases

### Inventory

Responsible for:

- Stock availability
- Inventory updates
- Stock reservations

### Production

Responsible for:

- Production orders
- Brewing batches
- Stock creation events

---

## Architectural Concepts Covered

- Domain-Driven Design (DDD)
- Strategic Design
- Tactical Design
- Bounded Contexts
- Ubiquitous Language
- Aggregates
- Value Objects
- Domain Events
- CQRS
- Event Sourcing
- Microservices
- Integration Events
- Outbox Pattern
- Circuit Breaker Pattern
- Observability
- .NET Aspire

---

## Local Development

Prerequisites:

- .NET 10 SDK
- Docker Desktop

Infrastructure is started through Docker Compose.

Detailed setup instructions are documented under:

```text
docs/
```

See [Running locally](docs/01-overview/06-running-locally.md) and [Modernization vision](docs/01-overview/07-fermentflow-modernization-vision.md).

---

## Status

This repository is an active learning project and architectural playground.

Expect frequent refactoring, restructuring, and experimentation as new concepts are explored.

---

## Documentation

| Document | Purpose |
| -------- | ------- |
| [Project overview](docs/01-overview/01-project-overview.md) | Structure and baseline stages |
| [Business domain](docs/01-overview/02-business-domain.md) | Domain flows and rules |
| [Architecture evolution](docs/01-overview/03-architecture-evolution.md) | Stage-by-stage patterns |
| [Ubiquitous language](docs/01-overview/04-ubiquitous-language.md) | Domain vocabulary |
| [Modernization vision](docs/01-overview/07-fermentflow-modernization-vision.md) | Full 9-stage roadmap |

Assistant and CI governance: [CLAUDE.md](CLAUDE.md)
