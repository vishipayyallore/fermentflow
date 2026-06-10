# GitHub Copilot Instructions for FermentFlow

**Version**: 1.1  
**Last Updated**: June 10, 2026  
**Repository**: `fermentflow`  
**Context**: Personal DDD architecture laboratory (.NET 10)

**Environment**: Windows, PowerShell, .NET 10 SDK, Docker Desktop  
**Note**: All commands and scripts should use PowerShell syntax. File paths use Windows format.

---

## Strict scope (non-negotiable)

This repository is **Swamy PKV's personal architecture laboratory only**. It is **not** for anyone else as courseware, templates, tutorials, or a reference corpus. **Do not** frame content for a general audience (other students, "learners," recruiters). Public visibility is **not** an invitation to use this repo for third-party purposes. Keep `README.md` aligned with the **Scope (read this first)** section.

**Do not** reference Packt, BrewUp, or other source book/product names in public docs unless Swamy explicitly asks.

---

## Repository Purpose

**FermentFlow** is Swamy's personal laboratory for exploring how a brewery logistics domain evolves from a legacy monolith into a modern, resilient, cloud-native distributed system using contemporary .NET practices.

The business domain is **brewery logistics management**: Production → Inventory → Sales.

### What This Repository Provides

- **Bounded contexts**: Sales, Inventory, Production
- **Architectural patterns**: DDD, CQRS, Event Sourcing, Outbox, Circuit Breaker, Observability, .NET Aspire
- **Branch evolution**: Nine intentional stages from legacy monolith to Aspire orchestration
- **Documentation**: Architecture evolution, ubiquitous language, modernization vision

### Who this is for

- **Swamy PKV only** — personal study, experimentation, and reference implementations. Not written for, maintained for, or aimed at any other audience.

---

## Repository Structure

**Quick Reference:**

- `docs/01-overview/` — Project overview, domain, architecture evolution, modernization vision
- `docker/` — Infrastructure compose files
- `src/` — Application source (evolves by branch/stage)
- `tools/psscripts/` — Maintenance and CI helper scripts

**Learning roadmap** (primary axis):

```text
01-LegacyMonolith → 02-ModularMonolith → 03-CQRS-VerticalSlices → 04-EventSourcing
→ 05-Microservices → 06-OutboxPattern → 07-CircuitBreaker
→ 08-Observability → 09-Aspire
```

See `README.md`, `docs/01_repository-structure.md`, and `docs/01-overview/08-branch-roadmap.md`.

---

## Development Guidelines

### Domain-Driven Design

- Respect **bounded context** boundaries — no direct cross-context database access
- Use **ubiquitous language** from `docs/01-overview/04-ubiquitous-language.md`
- Keep aggregates small; enforce invariants inside aggregate roots
- Prefer explicit commands and queries (CQRS) over anemic service layers

### Code Style (.NET 10)

- Follow standard C# conventions and nullable reference type annotations
- Use meaningful names aligned with domain language
- Keep REST endpoints thin — delegate to application layer (MediatR/command bus)
- Use FluentValidation for request validation where applicable
- Structured logging via Serilog; observability via OpenTelemetry in later stages

### Documentation Standards

- **Overview docs**: `docs/01-overview/`
- Update docs when architecture or stage behaviour changes
- Use Mermaid diagrams with ASCII fallbacks for architecture sketches
- Write in first-person learning/reflection tone where appropriate (Swamy's notes)

### Testing

- xUnit + Testcontainers where infrastructure is involved
- Tests must pass on the active branch before merging
- Domain tests should exercise aggregate invariants

---

## Running the Code

**Prerequisites:** .NET 10 SDK, Docker Desktop

```powershell
cd docker
docker compose up -d
cd ..\src
dotnet restore FermentFlow.sln
dotnet build FermentFlow.sln --configuration Release
dotnet test FermentFlow.sln --configuration Release --no-build
```

See `docs/01-overview/06-running-locally.md` for stage-specific instructions.

---

## Prompt Engineering

When asking Copilot for help:

- Name the bounded context and evolution stage (e.g., "Sales aggregate on stage 04-EventSourcing")
- Specify whether the change is a command, query, domain event, or infrastructure concern
- Ask for DDD rationale when introducing new types or cross-context communication
- Request integration test coverage for behavioural changes

---

## Protecting assistant governance

**Primary:** these files must stay **uncorrupted** — `.cursor/rules/`, mirrored **`.github/skills` ↔ `.cursor/skills`**, mirrored **`.github/agents` ↔ `.cursor/agents`**, `CLAUDE.md`, and **this** `copilot-instructions.md`. Before another AI tool or mass refactor touches them: **commit or stash**; edit **both** sides of each mirror in one change; prefer **small scoped diffs**; rely on **`ci-skills-parity.yml`** and **`ci-agent-docs-guard.yml`** on push.

**Secondary (only if damage already happened):** restore from Git — **`docs/agent-governance-recovery.md`**.
