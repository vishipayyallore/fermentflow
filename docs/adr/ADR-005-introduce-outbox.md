# ADR-005: Introduce Outbox Pattern

**Status:** Accepted  
**Branch:** `06-OutboxPattern`  
**Date:** 2026-06-10

## Context

Branch 05 publishes integration events directly after a database commit. Process crashes between commit and publish cause **lost events** — a common production failure mode that circuit breakers do not fix.

## Decision

Adopt the **transactional outbox**:

- Write integration events to an outbox table in the same transaction as domain state
- Process outbox rows with a background worker
- Publish to RabbitMQ via MassTransit with at-least-once delivery semantics

Add `BuildingBlocks/Outbox/` and extend architecture tests to forbid direct broker publish from domain handlers.

## Consequences

- **Positive:** Reliable integration events; teaches the right ordering (outbox before circuit breaker).
- **Negative:** Background processing, idempotent consumers, and duplicate handling required.
- **Follow-up:** ADR-006 adds Polly for remaining synchronous cross-service calls.
