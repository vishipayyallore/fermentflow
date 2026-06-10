# GitHub Copilot Instructions for FermentFlow

**Version**: 1.0  
**Last Updated**: June 10, 2026  
**Repository**: `fermentflow`  
**Context**: Domain-Driven Design reference application (.NET)

**Environment**: Windows, PowerShell, .NET 8 SDK, Docker Desktop  
**Note**: All commands and scripts should use PowerShell syntax. File paths use Windows format.

---

## Repository Purpose

**FermentFlow** is a sample application for the Packt book *Domain-driven Refactoring*. It models a fictional brewery logistics company that manages beer sales, warehouse inventory, and production-driven availability.

The repository's primary value is the **refactoring journey** encoded in git branches — from legacy monolith to resilient microservices.

### What This Repository Provides

- **Bounded contexts**: Sales, Warehouses (Inventory in modernization vision), Production
- **Architectural patterns**: DDD, CQRS, Event Sourcing, Outbox, Circuit Breaker
- **Documentation**: Architecture evolution, ubiquitous language, reverse-engineering reports
- **Infrastructure**: Docker Compose for MongoDB, EventStoreDB, RabbitMQ

### Who this is for

- Developers learning DDD and event-driven architecture in .NET
- Readers of the *Domain-driven Refactoring* book
- Portfolio and reference implementations

---

## Repository Structure

**Quick Reference:**

- `docs/01-overview/` — Project overview, domain, architecture evolution, running locally
- `docker/` — Infrastructure compose files
- `src/` — Application source (structure varies by branch)
- `tools/psscripts/` — Maintenance and CI helper scripts

**Branch evolution** (primary learning axis):

| Branch | Summary |
|--------|---------|
| `01-monolith_legacy` | Single solution, layered architecture, shared MongoDB |
| `02-monolith_with_cqrs` | Bounded contexts, CQRS read/write split |
| `03-monolith_with_cqrs_and_event_sourcing` | Event sourcing, RabbitMQ, modular monolith |
| `04-microservices` | Two deployable services: Sales and Warehouses |

See `docs/01-overview/03-architecture-evolution.md` for full detail.

---

## Development Guidelines

### Domain-Driven Design

- Respect **bounded context** boundaries — no direct cross-context database access
- Use **ubiquitous language** from `docs/01-overview/04-ubiquitous-language.md`
- Keep aggregates small; enforce invariants inside aggregate roots
- Prefer explicit commands and queries (CQRS) over anemic service layers

### Code Style (.NET)

- Follow standard C# conventions and nullable reference type annotations
- Use meaningful names aligned with domain language (`SalesOrder`, not `OrderDto`)
- Keep REST endpoints thin — delegate to application layer (Mediator/command bus)
- Use FluentValidation for request validation
- Structured logging via Serilog

### Documentation Standards

- **Overview docs**: `docs/01-overview/`
- **Review reports**: `docs/reviews/` (if present)
- Update docs when architecture or branch behaviour changes
- Use Mermaid diagrams with ASCII fallbacks for architecture sketches

### Testing

- xUnit for integration and domain tests
- Tests must pass on the active branch before merging
- Domain tests should exercise aggregate invariants, not infrastructure details

---

## Running the Code

**Prerequisites:** .NET 8 SDK, Docker Desktop

```powershell
# Start infrastructure
cd docker
docker compose up -d

# Build and test (adjust solution path for branch)
cd ..\src
dotnet restore FermentFlow.sln
dotnet build FermentFlow.sln --configuration Release
dotnet test FermentFlow.sln --configuration Release --no-build
```

API (branch 01): `http://localhost:5098` — Swagger at `/documentation`

See `docs/01-overview/06-running-locally.md` for branch-specific instructions.

---

## Prompt Engineering

When asking Copilot for help:

- Name the bounded context and branch (e.g., "Sales aggregate on branch 03")
- Specify whether the change is a command, query, domain event, or infrastructure concern
- Ask for DDD rationale when introducing new types or cross-context communication
- Request integration test coverage for behavioural changes

---

## Protecting assistant governance

**Primary:** these files must stay **uncorrupted** — `.cursor/rules/`, mirrored **`.github/skills` ↔ `.cursor/skills`**, mirrored **`.github/agents` ↔ `.cursor/agents`**, `CLAUDE.md`, and **this** `copilot-instructions.md`. Before another AI tool or mass refactor touches them: **commit or stash**; edit **both** sides of each mirror in one change; prefer **small scoped diffs**; rely on **`ci-skills-parity.yml`** and **`ci-agent-docs-guard.yml`** on push.

**Secondary (only if damage already happened):** restore from Git — **`docs/agent-governance-recovery.md`**.
