# ADR-008: Introduce .NET Aspire

**Status:** Accepted  
**Branch:** `09-Aspire`  
**Date:** 2026-06-10

## Context

Branch 08 runs multiple services, brokers, databases, and observability stacks via Docker Compose. Wiring connection strings, health checks, and dashboards manually does not scale as a learning or local-dev experience.

## Decision

Adopt **.NET Aspire** as the distributed application host:

- `FermentFlow.AppHost` orchestrates services and infrastructure resources
- `FermentFlow.ServiceDefaults` provides shared OpenTelemetry, health checks, and service discovery
- Replace ad-hoc Compose wiring with Aspire resource declarations where practical

Aspire is a first-class architectural capability — not an afterthought — for service discovery, orchestration, and the Aspire dashboard.

## Alternatives Considered

| Alternative | Outcome |
|-------------|---------|
| Docker Compose only (indefinitely) | **Rejected** — manual wiring does not scale for local multi-service DX. |
| Kubernetes as the next stage immediately | **Rejected** — sagas (ADR-009) are a richer domain lesson before deployment tooling. |
| .NET Aspire as dedicated stage 09 | **Accepted** — AppHost + ServiceDefaults + dashboard. |

## Consequences

- **Positive:** Unified local cloud-native DX; built-in observability hooks; cleaner onboarding for later stages (Kubernetes, Azure Container Apps).
- **Negative:** Aspire version coupling; team must learn AppHost and resource model.
- **Follow-up:** ADR-009 (Proposed) — event-driven sagas at stage `10-EventDrivenSagas`.
