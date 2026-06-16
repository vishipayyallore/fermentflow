# ADR-006: Introduce Circuit Breaker

**Status:** Accepted  
**Branch:** `07-CircuitBreaker`  
**Date:** 2026-06-10

## Context

Branch 06 guarantees reliable async messaging. Synchronous calls (gateway to service, read-model enrichment) can still cascade failures when a dependency is slow or unavailable.

## Decision

Add **Polly v8** resilience pipelines in `BuildingBlocks/Resilience/`:

- Retry with backoff
- Timeout
- Circuit breaker
- Fallback where appropriate

Apply pipelines to HTTP and other sync integration paths — not as a substitute for the outbox.

## Alternatives Considered

| Alternative | Outcome |
|-------------|---------|
| Circuit breaker before outbox (stage 06/07 swapped) | **Rejected** — sync resilience does not fix lost async events (see ADR-005). |
| Retry-only policies without circuit breaker | **Rejected** — incomplete resilience story for teaching. |
| Polly v8 pipelines after outbox is in place | **Accepted** — stage 07. |

## Consequences

- **Positive:** Graceful degradation; teaches resilience after reliable messaging.
- **Negative:** Fallback logic must preserve domain invariants; tuning thresholds is non-trivial.
