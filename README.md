# FermentFlow

![.NET](https://img.shields.io/badge/.NET-10-512BD4)
![DDD](https://img.shields.io/badge/DDD-Domain--Driven--Design-blue)
![CQRS](https://img.shields.io/badge/CQRS-MediatR-green)
![Vertical Slice](https://img.shields.io/badge/Architecture-Vertical%20Slices-orange)
![Event Sourcing](https://img.shields.io/badge/EventStoreDB-Event%20Sourcing-red)
![MassTransit](https://img.shields.io/badge/MassTransit-Messaging-purple)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-336791)
![RabbitMQ](https://img.shields.io/badge/RabbitMQ-Broker-FF6600)
![OpenTelemetry](https://img.shields.io/badge/OpenTelemetry-Observability-informational)
![Aspire](https://img.shields.io/badge/.NET-Aspire-6E4AFF)

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
| Architecture  | DDD, CQRS, Vertical Slice Architecture, Event Sourcing, Microservices                          |
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
03-CQRS-VerticalSlices
        ↓
04-CQRS-EventSourcing
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

Each stage introduces a single major architectural concept while preserving the same business domain.

Full per-branch layouts: [Branch roadmap](docs/01-overview/08-branch-roadmap.md) · [Stage 01 blueprint](docs/01-overview/13-stage-01-overview.md) · [Repository structure](docs/01_repository-structure.md)

Optional future stages:

```text
10-EventDrivenSagas
11-Kubernetes
12-GitHubActions
13-AzureContainerApps
14-MultiTenancy
```

---

## Technology Stack

Target stack by stage — Stage 01 uses .NET 10, PostgreSQL, EF Core, and xUnit only.

| Area              | Technology                | From stage |
| ----------------- | ------------------------- | ---------- |
| Runtime           | .NET 10                   | 01         |
| API               | ASP.NET Core Minimal APIs | 01         |
| Architecture      | Domain-Driven Design      | 02         |
| CQRS              | MediatR                   | 03         |
| Messaging         | MassTransit               | 05         |
| Broker            | RabbitMQ                  | 05         |
| Event Store       | EventStoreDB              | 04         |
| Database          | PostgreSQL                | 01         |
| Resilience        | Polly                     | 07         |
| Service Discovery | .NET Aspire               | 09         |
| Orchestration     | .NET Aspire               | 09         |
| Observability     | OpenTelemetry             | 08         |
| Metrics           | Prometheus                | 08         |
| Dashboards        | Grafana                   | 08         |
| Logging           | Serilog                   | 08         |
| Testing           | xUnit; Testcontainers     | 01 / 03    |
| Containers        | Docker                    | 01         |

---

## Repository Layout

Target/staged layout. On the current docs-only blueprint branch, `src/` is intentionally empty until Stage 01 implementation begins.

```text
src/
├── BuildingBlocks/
├── Services/          # from stage 05; Features/ folders from stage 03
│   ├── Sales/
│   ├── Inventory/
│   └── Production/
├── Gateway/           # stage 05+
└── Tests/

tests/                 # cross-service tests from stage 06+
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
- Vertical Slice Architecture
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

See [Running locally (greenfield)](docs/01-overview/06-running-locally.md) and [Modernization vision](docs/01-overview/07-fermentflow-modernization-vision.md).

---

## Status

**Blueprint approved; Stage 01 code not yet implemented.** The repository currently ships architecture documentation, ADRs, and Docker PostgreSQL infrastructure. Application source arrives on **`01-LegacyMonolith`** per the [Stage 01 blueprint](docs/01-overview/13-stage-01-overview.md).

This is an active learning project — expect refactoring and experimentation as each stage lands.

---

## Documentation

| Document | Purpose |
| -------- | ------- |
| [Stage 01 blueprint](docs/01-overview/13-stage-01-overview.md) | Legacy monolith implementation guide |
| [Stage 01 smells](docs/01-overview/14-stage-01-smells.md) | Intentional architectural problems |
| [Inventory aggregate model](docs/01-overview/12-inventory-aggregate-model.md) | `InventoryItem` aggregate; derived availability |
| [Project overview](docs/01-overview/01-project-overview.md) | Structure and learning roadmap |
| [Business domain](docs/01-overview/02-business-domain.md) | Domain flows and rules |
| [Architecture evolution](docs/01-overview/03-architecture-evolution.md) | Baseline import comparison |
| [Branch roadmap](docs/01-overview/08-branch-roadmap.md) | Per-branch layout and learning goals |
| [Architecture governance](docs/01-overview/09-architecture-governance.md) | ADRs, architecture tests, fitness functions, Definition of Done |
| [Event catalog](docs/01-overview/10-event-catalog.md) | Domain, integration, and saga events |
| [Domain invariants](docs/01-overview/11-domain-invariants.md) | Aggregate rules → branch 03 unit tests |
| [Architecture decisions](docs/02-adr/README.md) | ADR index (branch 02 onward) |
| [Repository structure](docs/01_repository-structure.md) | Layout, naming, branch strategy |
| [Branching, tags, releases](docs/01-overview/17-branching-tags-and-releases.md) | Blueprint freeze, stage branches, GitHub releases |
| [Ubiquitous language](docs/01-overview/04-ubiquitous-language.md) | Domain vocabulary |
| [Modernization vision](docs/01-overview/07-fermentflow-modernization-vision.md) | Full 9-stage roadmap |

Assistant and CI governance: [CLAUDE.md](CLAUDE.md)
