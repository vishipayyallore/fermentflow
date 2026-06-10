# Architecture Decision Records

Swamy's personal ADR log for FermentFlow branch decisions. Each ADR maps to a stage in the [nine-branch roadmap](../01_repository-structure.md#architecture-evolution-roadmap).

| ADR | Branch | Decision |
|-----|--------|----------|
| [ADR-001](ADR-001-introduce-modular-monolith.md) | 02-ModularMonolith | Introduce modular monolith and bounded contexts |
| [ADR-002](ADR-002-introduce-cqrs.md) | 03-CQRS-VerticalSlices | Adopt CQRS with vertical slice architecture |
| [ADR-003](ADR-003-introduce-event-sourcing.md) | 04-CQRS-EventSourcing | Add event sourcing while retaining CQRS |
| [ADR-004](ADR-004-introduce-microservices.md) | 05-Microservices | Decompose into independently deployable services |
| [ADR-005](ADR-005-introduce-outbox.md) | 06-OutboxPattern | Adopt transactional outbox for integration events |
| [ADR-006](ADR-006-introduce-circuit-breaker.md) | 07-CircuitBreaker | Add Polly resilience pipelines |
| [ADR-007](ADR-007-introduce-observability.md) | 08-Observability | Adopt OpenTelemetry, Prometheus, and Grafana |
| [ADR-008](ADR-008-introduce-aspire.md) | 09-Aspire | Adopt .NET Aspire for orchestration and local DX |

**Format:** MADR-inspired — Status, Context, Decision, Consequences.
