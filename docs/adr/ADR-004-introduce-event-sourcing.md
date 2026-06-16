# ADR-004: Introduce Event Sourcing (Retain CQRS)

**Status:** Accepted  
**Branch:** `04-CQRS-EventSourcing`  
**Date:** 2026-06-10

## Context

Branch 03 uses CQRS with vertical slices and mutable persistence. Domain history is lost on update, and cross-context integration relies on state diffs rather than explicit domain events.

## Decision

Rename stage **04** to **`04-CQRS-EventSourcing`** to make clear that CQRS and vertical slices **continue** while event sourcing is added.

- Persist aggregate state via **EventStoreDB**
- Model state changes as **domain events** with aggregate rehydration
- Build **projections** for read models
- Add `BuildingBlocks/EventSourcing/` for shared event store abstractions

Commands and queries from branch 03 remain; write models become event-sourced aggregates.

## Alternatives Considered

| Alternative | Outcome |
|-------------|---------|
| Replace CQRS with event sourcing on branch 04 | **Rejected** — many teams conflate the two; FermentFlow keeps **CQRS + vertical slices + event sourcing**. |
| Event sourcing without renaming branch to `04-CQRS-EventSourcing` | **Rejected** — name hides that CQRS continues. |
| Add EventStoreDB while retaining CQRS and slices | **Accepted** — branch 04 explicit naming and behaviour. |

## Consequences

- **Positive:** Full audit trail; natural domain events for integration; explicit CQRS + ES story.
- **Negative:** Higher complexity, EventStore operational overhead, projection lag to manage.
- **Follow-up:** ADR-005 extracts services once event-driven boundaries are stable.
