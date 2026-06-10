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

## Consequences

- **Positive:** Graceful degradation; teaches resilience after reliable messaging.
- **Negative:** Fallback logic must preserve domain invariants; tuning thresholds is non-trivial.
