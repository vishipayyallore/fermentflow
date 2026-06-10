# ADR-001: Introduce Modular Monolith

**Status:** Accepted  
**Branch:** `02-ModularMonolith`  
**Date:** 2026-06-10

## Context

Branch 01 uses a layered monolith with shared persistence and direct cross-module coupling. Brewery logistics already has natural boundaries (Sales, Inventory, Production) but they are not reflected in the code structure.

## Decision

Split the monolith into physical bounded contexts under `src/` with per-context Domain, Application, and Infrastructure projects. Keep a single deployable and shared runtime while enforcing explicit boundaries.

Introduce `tests/FermentFlow.Architecture.Tests` using **NetArchTest.Rules** (or ArchUnitNET) from this branch onward.

### Dependency rules (baseline set)

| Rule | Rationale |
|------|-----------|
| Sales must not reference `Inventory.Infrastructure` or `Production.Infrastructure` | Bounded context isolation |
| Domain must not reference Application or Infrastructure | Onion / clean architecture |
| Application must not reference another context's Infrastructure | No cross-context persistence coupling |
| Domain must not reference MediatR | Keep domain free of application framework |
| Domain must not reference MassTransit | Messaging belongs in application/infrastructure |
| Domain must not reference Entity Framework | Persistence is an infrastructure concern |
| `Features/*` may depend only on Application + Domain | Vertical slices stay thin |
| Infrastructure may depend on Domain, Application, and framework libraries | Adapters live at the outer ring |

Extend this rule set on each subsequent branch (see [Architecture governance](../01-overview/09-architecture-governance.md)).

## Alternatives Considered

| Alternative | Outcome |
|-------------|---------|
| Logical namespaces only (no physical project split) | **Rejected** — boundaries erode under pressure; folders do not enforce compile-time rules. |
| Microservices immediately after monolith | **Rejected** — skips modular monolith and DDD boundary learning (ADR-004 comes later). |
| Modular monolith + NetArchTest from branch 02 | **Accepted** — boundaries visible in structure and enforced in CI. |

## Consequences

- **Positive:** Boundaries become visible in the folder structure; architecture tests catch dependency violations early.
- **Negative:** More projects and references to manage within one solution.
- **Follow-up:** ADR-002 adds CQRS and vertical slices on top of these boundaries.
