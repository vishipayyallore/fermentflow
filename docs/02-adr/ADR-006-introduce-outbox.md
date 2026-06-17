# ADR-006: Introduce Outbox Pattern

**Status:** Accepted  
**Branch:** `06-OutboxPattern`  
**Date:** 2026-06-10

## Context

Branch 05 publishes integration events directly after a database commit. Process crashes between commit and publish cause **lost events** — a common production failure mode that circuit breakers do not fix.

FermentFlow also uses **EventStoreDB** for domain events (branch 04+). EventStore catch-up subscriptions *can* propagate some changes, but this repository intentionally separates:

```text
Domain Event        → persisted in EventStoreDB (aggregate history)
Integration Event   → crosses bounded contexts via RabbitMQ / MassTransit
```

## Decision

Adopt the **transactional outbox** for **integration events**:

- Write integration events to an outbox table in the same transaction as domain state (PostgreSQL)
- Process outbox rows with a background worker
- Publish to RabbitMQ via MassTransit with at-least-once delivery semantics

Add `BuildingBlocks/Outbox/` and extend architecture tests to forbid direct broker publish from domain handlers.

> **Teaching note:** This repository **intentionally demonstrates the Outbox pattern** even when EventStore subscriptions could relay some changes, because Outbox remains one of the most common reliability patterns in event-driven microservice systems — and because **domain events ≠ integration events**.

**Storage split (branch 04+):** EventStoreDB holds **domain events** (aggregate history). PostgreSQL holds **projections**, **relational state where needed**, and the **outbox table** for integration events. There is no two-phase commit across EventStore and PostgreSQL — the application writes to EventStore first, then records pending integration events in the outbox (same PostgreSQL transaction as projection/outbox row updates, or via a dedicated integration-event step with idempotent outbox inserts).

## EventStore and Outbox consistency model

FermentFlow intentionally accepts **eventual consistency** between:

- **Aggregate event stream** (EventStoreDB)
- **Integration event publication** (PostgreSQL outbox → RabbitMQ)

There is **no two-phase commit** across EventStore and PostgreSQL. The write path is sequential and idempotent:

```text
1. Append domain event(s) to EventStoreDB
2. Update PostgreSQL projection / read model (if applicable)
3. Insert integration event row(s) into outbox (PostgreSQL transaction)
4. Background publisher relays outbox rows to RabbitMQ
```

The goal is to teach:

- **Domain events** — aggregate history inside a bounded context
- **Integration events** — cross-context messaging contracts
- **Reliable messaging** — outbox pattern for at-least-once delivery

…rather than distributed transactions or dual-write atomicity across heterogeneous stores.

## Alternatives Considered

| Alternative | Outcome |
|-------------|---------|
| **EventStore catch-up subscriptions only** (no outbox) | **Rejected for this lab** — valid in some systems, but skips the integration-event reliability lesson; domain events ≠ integration events. |
| **Direct RabbitMQ publish** after `SaveChanges` | **Rejected** — crash between commit and publish loses events. |
| **Circuit breaker** on publish calls (ADR-007) | **Rejected as substitute** — retries failed calls but does not fix the lost-event window; outbox must come first. |
| **Transactional outbox** in the same DB transaction | **Accepted** — reliable integration events; teaches correct ordering before Polly. |

## Consequences

- **Positive:** Reliable integration events; teaches the right ordering (outbox before circuit breaker).
- **Negative:** Background processing, idempotent consumers, and duplicate handling required.
- **Follow-up:** ADR-007 adds Polly for remaining synchronous cross-service calls.
