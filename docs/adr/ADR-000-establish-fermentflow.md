# ADR-000: Establish FermentFlow

**Status:** Accepted  
**Branch:** *(repository foundation — precedes `01-LegacyMonolith`)*  
**Date:** 2026-06-10

## Context

Swamy PKV needs a personal workspace to explore how a business domain evolves from a legacy monolith into a modern, resilient, cloud-native distributed system. An imported brewery logistics baseline provides realistic domain complexity (orders, inventory, production-driven stock) without inventing a toy CRUD example.

The workspace must teach **incremental refactoring** — not a single "final" architecture snapshot.

## Decision

Establish **FermentFlow** as a personal architecture laboratory that explores, in staged git branches:

- Domain-Driven Design (bounded contexts, ubiquitous language)
- CQRS + Vertical Slice Architecture
- Event Sourcing (retaining CQRS)
- Microservices
- Transactional Outbox
- Circuit Breaker (Polly)
- Observability (OpenTelemetry)
- .NET Aspire

**Domain:** brewery logistics — `Production → Inventory → Sales`.

**Runtime target:** .NET 10 (baseline import branches may remain on .NET 7/8 until ported).

**Governance:** architecture tests from branch 02; ADRs from branch 01 foundation (this record) through branch 08; future ADR-009 for event-driven sagas.

Do **not** frame the repository as third-party courseware or an official book sample in public documentation.

## Alternatives Considered

| Alternative | Outcome |
|-------------|---------|
| Single-repo snapshot of "best practices" only | **Rejected** — hides the learning journey; FermentFlow's value is evolution across branches. |
| Greenfield toy domain (e.g. generic Todo app) | **Rejected** — too shallow for DDD, sagas, and outbox lessons. |
| Document-only repo without runnable code | **Rejected** — architecture decisions must be provable with buildable branches. |
| Staged laboratory with ADRs + architecture tests | **Accepted** — this repository. |

## Consequences

- **Positive:** All future architectural decisions are evaluated against the [staged learning roadmap](../01_repository-structure.md#architecture-evolution-roadmap).
- **Positive:** Documentation, ADRs, and branch names stay aligned — ADRs reinforce the roadmap rather than duplicating it.
- **Negative:** High documentation and branch-maintenance overhead before code exists on every stage.
- **Follow-up:** Implement `01-LegacyMonolith` by importing baseline code, then port forward branch by branch.
