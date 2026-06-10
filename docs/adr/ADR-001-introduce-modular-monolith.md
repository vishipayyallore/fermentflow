# ADR-001: Introduce Modular Monolith

**Status:** Accepted  
**Branch:** `02-ModularMonolith`  
**Date:** 2026-06-10

## Context

Branch 01 uses a layered monolith with shared persistence and direct cross-module coupling. Brewery logistics already has natural boundaries (Sales, Inventory, Production) but they are not reflected in the code structure.

## Decision

Split the monolith into physical bounded contexts under `src/` with per-context Domain, Application, and Infrastructure projects. Keep a single deployable and shared runtime while enforcing explicit boundaries.

Introduce `tests/FermentFlow.Architecture.Tests` using **NetArchTest.Rules** (or ArchUnitNET) from this branch onward to guard:

- Sales must not reference `Inventory.Infrastructure` or `Production.Infrastructure`
- Domain must not reference Application or Infrastructure
- Application must not reference Infrastructure in another context

## Consequences

- **Positive:** Boundaries become visible in the folder structure; architecture tests catch dependency violations early.
- **Negative:** More projects and references to manage within one solution.
- **Follow-up:** ADR-002 adds CQRS and vertical slices on top of these boundaries.
