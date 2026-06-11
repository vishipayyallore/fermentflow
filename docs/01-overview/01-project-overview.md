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

Stage 01 starts with a flatter monolith layout — see [Stage 01 blueprint](13-stage-01-overview.md).

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

Full detail: [Branch roadmap](08-branch-roadmap.md) · [Stage 01 blueprint](13-stage-01-overview.md) · [Inventory aggregate model](12-inventory-aggregate-model.md) · [Architecture governance](09-architecture-governance.md) · [Event catalog](10-event-catalog.md) · [Domain invariants](11-domain-invariants.md) · [ADRs](../adr/README.md) · [Repository structure](../01_repository-structure.md)

**Starting Stage 01?** Read [13-stage-01-overview.md](13-stage-01-overview.md) and [14-stage-01-smells.md](14-stage-01-smells.md) before writing code.

## Blueprint status

**Implementation-ready** (blueprint frozen). Architectural unknowns for Stages 01–09 are documented in ADRs 000–013 and overview docs 01–16. Further design changes should follow the ADR process — validate assumptions through code on each stage branch, not additional pre-implementation redesign.

**Git workflow:** Tag `v1.0-blueprint-approved`, stage branches, and releases — [17-branching-tags-and-releases.md](17-branching-tags-and-releases.md).

## Target Technology Stack

| Area | Technology |
|------|------------|
| Runtime | .NET 10 |
| API | ASP.NET Core Minimal APIs |
| CQRS | MediatR (from stage 03) |
| Messaging | MassTransit + RabbitMQ (from stage 05) |
| Event Store | EventStoreDB (from stage 04) |
| Database | PostgreSQL |
| Resilience | Polly (from stage 07) |
| Observability | OpenTelemetry, Prometheus, Grafana (from stage 08) |
| Orchestration | .NET Aspire (stage 09) |
| Testing | xUnit; Testcontainers from stage 03 |
| Containers | Docker |

Stage 01 uses only .NET 10, PostgreSQL, EF Core, and xUnit — see the [Stage 01 blueprint](13-stage-01-overview.md).

## Getting Started

### Prerequisites

- .NET 10 SDK
- Docker Desktop

### Run Stage 01 (`01-LegacyMonolith`)

```powershell
git checkout 01-LegacyMonolith
cd docker
docker compose up -d
cd ..\src
dotnet restore FermentFlow.sln
dotnet run --project FermentFlow.Api
```

Full setup, endpoints, and Definition of Done: [13-stage-01-overview.md](13-stage-01-overview.md) · [Running locally](06-running-locally.md)
