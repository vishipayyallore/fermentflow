# Architecture Decision Records

Swamy's personal ADR log for FermentFlow. ADRs **reinforce** the [nine-branch roadmap](../01_repository-structure.md#architecture-evolution-roadmap) — they record *why*, not a second copy of *what*.

| ADR | Branch | Status | Decision |
|-----|--------|--------|----------|
| [ADR-000](ADR-000-establish-fermentflow.md) | *(foundation)* | Accepted | Establish FermentFlow as a staged architecture laboratory |
| [ADR-001](ADR-001-introduce-modular-monolith.md) | 02-ModularMonolith | Accepted | Modular monolith + architecture tests |
| [ADR-002](ADR-002-introduce-cqrs.md) | 03-CQRS-VerticalSlices | Accepted | CQRS + vertical slice architecture |
| [ADR-003](ADR-003-introduce-event-sourcing.md) | 04-CQRS-EventSourcing | Accepted | Event sourcing while retaining CQRS |
| [ADR-004](ADR-004-introduce-microservices.md) | 05-Microservices | Accepted | Independent deployable services |
| [ADR-005](ADR-005-introduce-outbox.md) | 06-OutboxPattern | Accepted | Transactional outbox |
| [ADR-006](ADR-006-introduce-circuit-breaker.md) | 07-CircuitBreaker | Accepted | Polly resilience pipelines |
| [ADR-007](ADR-007-introduce-observability.md) | 08-Observability | Accepted | OpenTelemetry + Prometheus + Grafana |
| [ADR-008](ADR-008-introduce-aspire.md) | 09-Aspire | Accepted | .NET Aspire orchestration |
| [ADR-009](ADR-009-introduce-event-driven-sagas.md) | 10-EventDrivenSagas | Proposed | Event-driven sagas across Production → Inventory → Sales |
| [ADR-010](ADR-010-inventory-item-aggregate-root.md) | `02-ModularMonolith`+ | Accepted | `InventoryItem` aggregate; `Availability` derived |
| [ADR-011](ADR-011-promote-production-bounded-context.md) | `02-ModularMonolith`+ | Accepted | Production as full bounded context |
| [ADR-012](ADR-012-cross-context-collaboration-modular-monolith.md) | `03-CQRS-VerticalSlices` | Accepted | Application contracts; no cross-context repos or MediatR |

**Format:** MADR-inspired — Status, Context, Decision, **Alternatives Considered**, Consequences.

**Governance:** [Architecture governance](../01-overview/09-architecture-governance.md) — ADR workflow, architecture tests, Definition of Done.
