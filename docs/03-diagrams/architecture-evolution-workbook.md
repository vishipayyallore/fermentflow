# Architecture Evolution Workbook

Step-by-step guide for working through FermentFlow's modernization stages. Use this as a checklist while switching git branches.

**Related:** [Architecture evolution](../01-overview/03-architecture-evolution.md) · [Modernization vision](../01-overview/07-fermentflow-modernization-vision.md) · [Branch roadmap](../01-overview/08-branch-roadmap.md)

---

## Before you start

1. Install **.NET 10 SDK** and **Docker Desktop**
2. Read [Running locally](../01-overview/06-running-locally.md) for the active branch
3. Skim [ADR-001](../02-adr/ADR-001-establish-fermentflow.md) — root decision for the laboratory

---

## Stage checklist (01 → 09)

| Stage | Branch | One thing to learn | ADR |
|-------|--------|-------------------|-----|
| 01 | `01-LegacyMonolith` | Layered monolith pain points | — |
| 02 | `02-ModularMonolith` | Bounded contexts + architecture tests | [ADR-002](../02-adr/ADR-002-introduce-modular-monolith.md) |
| 03 | `03-CQRS-VerticalSlices` | MediatR, slices, domain unit tests, Testcontainers | [ADR-003](../02-adr/ADR-003-introduce-cqrs.md) |
| 04 | `04-CQRS-EventSourcing` | EventStoreDB + projections (CQRS retained) | [ADR-004](../02-adr/ADR-004-introduce-event-sourcing.md) |
| 05 | `05-Microservices` | Service extraction + gateway | [ADR-005](../02-adr/ADR-005-introduce-microservices.md) |
| 06 | `06-OutboxPattern` | Reliable integration events | [ADR-006](../02-adr/ADR-006-introduce-outbox.md) |
| 07 | `07-CircuitBreaker` | Polly for sync cross-service calls | [ADR-007](../02-adr/ADR-007-introduce-circuit-breaker.md) |
| 08 | `08-Observability` | OpenTelemetry + dashboards | [ADR-008](../02-adr/ADR-008-introduce-observability.md) |
| 09 | `09-Aspire` | Cloud-native orchestration | [ADR-009](../02-adr/ADR-009-introduce-aspire.md) |

---

## Per-stage verification

After each branch implementation:

```powershell
dotnet build src/FermentFlow.sln --configuration Release
dotnet test tests/ --configuration Release
```

From branch 02+: architecture tests must pass. From branch 03+: domain unit tests and Testcontainers integration tests.

---

## Optional stage 10

Event-driven sagas (orchestration, MassTransit state machine): [ADR-010](../02-adr/ADR-010-introduce-event-driven-sagas.md).

```text
ProductionCompleted → InventoryUpdated → InventoryAvailable → ReleasePendingSalesOrders
```
