# ADR-008: Introduce Observability

**Status:** Accepted  
**Branch:** `08-Observability`  
**Date:** 2026-06-10

## Context

Branches 05–07 introduce distributed behaviour that is hard to debug with logs alone. Failures across Sales, Inventory, and Production require correlated traces and metrics.

## Decision

Adopt **OpenTelemetry** for traces and metrics, **Prometheus** for scraping, and **Grafana** for dashboards. Centralize instrumentation in `BuildingBlocks/Observability/`. Enrich **Serilog** logs with trace and span identifiers.

## Alternatives Considered

| Alternative | Outcome |
|-------------|---------|
| Logs only (Serilog without traces) | **Rejected** — insufficient for cross-service debugging after stage 05. |
| Vendor-specific APM only | **Rejected** — OpenTelemetry is the portable .NET default. |
| OpenTelemetry + Prometheus + Grafana | **Accepted** — stage 08. |

## Consequences

- **Positive:** End-to-end visibility across services and messaging; supports learning production debugging.
- **Negative:** Instrumentation boilerplate; local Prometheus/Grafana setup adds Docker resources.
