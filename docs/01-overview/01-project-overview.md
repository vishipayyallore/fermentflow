# Project Overview

## What Is FermentFlow?

**FermentFlow** is Swamy PKV's personal architecture laboratory for exploring Domain-Driven Design and modernization patterns in .NET 10. It models brewery logistics: coordinating beer production, inventory availability, and customer sales orders.

The primary value is the **incremental refactoring journey** — nine intentional stages from legacy monolith to .NET Aspire orchestration. See the [Learning Roadmap](../../README.md#learning-roadmap) in `README.md`.

## Target Repository Structure

As stages progress, source organizes around bounded contexts and building blocks:

```text
fermentflow/
├── docs/                  # Documentation
├── docker/                # Infrastructure
├── src/
│   ├── BuildingBlocks/
│   ├── Services/
│   │   ├── Sales/
│   │   ├── Inventory/
│   │   └── Production/
│   ├── Gateway/
│   └── Tests/
├── tools/
└── README.md
```

Early baseline stages may use a flatter layout (monolith solution, legacy context names such as `Warehouses`) before the Inventory rename and service split.

## Learning Roadmap (Nine Stages)

| Stage | Focus |
|-------|-------|
| `01-LegacyMonolith` | Layered monolith, architectural smells |
| `02-ModularMonolith` | Physical bounded contexts, modular monolith |
| `03-CQRS-VerticalSlices` | CQRS, MediatR, vertical slices, domain unit tests, Testcontainers |
| `04-CQRS-EventSourcing` | CQRS retained + EventStoreDB, domain events, projections |
| `05-Microservices` | Separate deployables per context |
| `06-OutboxPattern` | Reliable integration events |
| `07-CircuitBreaker` | Polly resilience |
| `08-Observability` | OpenTelemetry, Prometheus, Grafana |
| `09-Aspire` | Service discovery, orchestration, local developer experience |

Full detail: [Branch roadmap](08-branch-roadmap.md) · [Architecture governance](09-architecture-governance.md) · [ADRs](../adr/README.md) · [Repository structure](../01_repository-structure.md)

## Baseline Stages (Imported Starting Point)

The earliest working code may arrive on legacy-named branches before the full nine-stage rename:

| Legacy branch | Maps to stage | Summary |
|---------------|---------------|---------|
| `01-monolith_legacy` | 01-LegacyMonolith | Single solution, layered architecture, shared MongoDB |
| `02-monolith_with_cqrs` | 02-ModularMonolith → 03-CQRS-VerticalSlices | Layered monolith with early CQRS patterns |
| `03-monolith_with_cqrs_and_event_sourcing` | 04-CQRS-EventSourcing | Event sourcing, RabbitMQ, ACL |
| `04-microservices` | 05-Microservices | Sales and Warehouses as separate services |

## Target Technology Stack

| Area | Technology |
|------|------------|
| Runtime | .NET 10 |
| API | ASP.NET Core Minimal APIs |
| CQRS | MediatR |
| Messaging | MassTransit + RabbitMQ |
| Event Store | EventStoreDB |
| Database | PostgreSQL |
| Resilience | Polly |
| Observability | OpenTelemetry, Prometheus, Grafana |
| Orchestration | .NET Aspire (stage 09) |
| Testing | xUnit + Testcontainers |
| Containers | Docker |

Baseline branches may use older **patterns** (MongoDB, Muflone) until ported forward — runtime is **.NET 10** on import.

## Getting Started

Baseline import git names (`01-monolith_legacy`, etc.) map to roadmap stages — code on each branch is **.NET 10** after port.

### Prerequisites

- .NET 10 SDK
- Docker Desktop

### Run Baseline Stage 01 (when branch exists)

```powershell
git checkout 01-monolith_legacy
cd docker; docker compose up -d
cd ..\src
dotnet restore FermentFlow.sln
dotnet run --project FermentFlow.Rest
```

API: [http://localhost:5098](http://localhost:5098)  
Swagger: [http://localhost:5098/documentation](http://localhost:5098/documentation)

### Run Baseline Stage 05 / Microservices (when branch exists)

```powershell
git checkout 04-microservices
cd docker; docker compose up -d
cd ..\src\Sales; dotnet run --project FermentFlow.Sales.Rest
cd ..\Warehouses; dotnet run --project FermentFlow.Warehouses.Rest
```

## Solutions by Baseline Branch

| Branch | Solution(s) |
|--------|-------------|
| 01 | `src/FermentFlow.sln` (~6 projects) |
| 02 | `src/FermentFlow.sln` (~15 projects) |
| 03 | `src/FermentFlow.sln` (~18 projects) |
| 04 | `src/Sales/FermentFlow.Sales.sln`, `src/Warehouses/FermentFlow.Warehouses.sln` |

## API Endpoints (Baseline Evolution)

| Endpoint | Branch 01 | Branch 02 | Branch 03–04 |
|----------|-----------|-----------|--------------|
| `POST /v1/sales/` | Create order | — (moved) | Create order (command bus) |
| `GET /v1/sales/` | List orders | List orders | List orders |
| `POST /v1/FermentFlow/` | — | Create order (mediator) | — (removed) |
| `POST /v1/warehouses/availabilities` | Set availability | Set availability | Set availability |
