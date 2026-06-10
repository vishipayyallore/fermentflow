# Project Overview

## What Is BrewUp?

**BrewUp** is a sample application for the Packt book *Domain-driven Refactoring*. It models a fictional brewery logistics company that manages beer sales, warehouse inventory, and production-driven availability.

The repository's primary value is not the application itself — it is the **refactoring journey** encoded in four git branches.

## Repository Structure

```
Domain-driven-Refactoring/
├── docs/                  # This documentation
├── docker/                # Infrastructure (MongoDB, EventStore, RabbitMQ)
├── src/                   # Application source code
│   ├── BrewUp.sln         # Monolith solution (branches 01–03)
│   ├── Sales/             # Sales bounded context (branches 02–04)
│   └── Warehouses/        # Warehouses bounded context (branches 02–04)
├── tools/                 # Utility scripts
└── README.md
```

## Architectural Evolution Branches

| Branch | Summary |
|--------|---------|
| `01-monolith_legacy` | Single solution, layered architecture, shared MongoDB |
| `02-monolith_with_cqrs` | Bounded contexts, CQRS read/write split, Mediator orchestration |
| `03-monolith_with_cqrs_and_event_sourcing` | Muflone event sourcing, RabbitMQ, ACL, modular monolith |
| `04-microservices` | Two deployable services: Sales and Warehouses |

## Technology Stack

| Technology | Usage |
|------------|-------|
| .NET 8 | ASP.NET Core minimal APIs |
| .NET 7 | Shared library (branch 01) |
| MongoDB | Read models, saga state, legacy persistence |
| EventStoreDB | Event sourcing (branches 03–04) |
| RabbitMQ | Async messaging between contexts (branches 03–04) |
| Muflone | CQRS/event sourcing framework (branches 03–04) |
| FluentValidation | Request validation |
| Serilog | Structured logging |
| Swashbuckle | OpenAPI at `/documentation` |
| xUnit | Integration and domain tests |
| Docker Compose | Local infrastructure |

## Getting Started

### Prerequisites

- .NET 8 SDK
- Docker Desktop

### Run Branch 01 (Monolith)

```bash
git checkout 01-monolith_legacy
cd docker && docker compose up -d
cd ../src
dotnet restore BrewUp.sln
dotnet run --project BrewUp.Rest
```

API: `http://localhost:5098`  
Swagger: `http://localhost:5098/documentation`

### Run Branch 04 (Microservices)

```bash
git checkout 04-microservices
cd docker && docker compose up -d
cd ../src/Sales && dotnet run --project BrewUp.Sales.Rest
cd ../Warehouses && dotnet run --project BrewUp.Warehouses.Rest
```

## Solutions by Branch

| Branch | Solution(s) |
|--------|-------------|
| 01 | `src/BrewUp.sln` (6 projects) |
| 02 | `src/BrewUp.sln` (~15 projects) |
| 03 | `src/BrewUp.sln` (~18 projects) |
| 04 | `src/Sales/BrewUp.Sales.sln`, `src/Warehouses/BrewUp.Warehouses.sln` |

## API Endpoints (Evolution)

| Endpoint | Branch 01 | Branch 02 | Branch 03–04 |
|----------|-----------|-----------|--------------|
| `POST /v1/sales/` | Create order | — (moved) | Create order (command bus) |
| `GET /v1/sales/` | List orders | List orders | List orders |
| `POST /v1/brewup/` | — | Create order (mediator) | — (removed) |
| `POST /v1/warehouses/availabilities` | Set availability | Set availability | Set availability |
