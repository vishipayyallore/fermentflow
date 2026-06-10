# ADR-004: Introduce Microservices

**Status:** Accepted  
**Branch:** `05-Microservices`  
**Date:** 2026-06-10

## Context

Branch 04 runs as a modular monolith with event sourcing. Deployment, scaling, and failure isolation are still monolithic despite clear bounded contexts.

## Decision

Extract **Sales**, **Inventory**, and **Production** into independently deployable services under `src/Services/`. Add an API **Gateway**. Use **RabbitMQ** and **MassTransit** for integration events. Each service owns its database.

CQRS, vertical slices, and event sourcing patterns carry forward inside each service.

## Consequences

- **Positive:** Independent deploy and scale; clearer ownership; production-like topology.
- **Negative:** Distributed operations, network failures, and eventual consistency become first-class concerns.
- **Follow-up:** ADR-005 addresses reliable messaging with the outbox pattern before adding sync resilience (ADR-006).
