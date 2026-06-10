# ADR-002: Introduce CQRS with Vertical Slice Architecture

**Status:** Accepted  
**Branch:** `03-CQRS-VerticalSlices`  
**Date:** 2026-06-10

## Context

Branch 02 separates bounded contexts but still organizes code by technical layer inside each context. Use cases span Domain, Application, and Infrastructure folders, which slows change and obscures intent.

## Decision

Adopt **CQRS** with **MediatR** and organize each context by **vertical slice** under `Features/`:

```text
Sales/Features/CreateSalesOrder/
Sales/Features/GetSalesOrders/
```

Each slice colocates command/query handler, validator, and endpoint for one use case. Shared abstractions move to `BuildingBlocks/Domain` and `BuildingBlocks/Application` initially.

## Alternatives Considered

| Alternative | Outcome |
|-------------|---------|
| CQRS with horizontal layers only (`Commands/`, `Queries/` folders) | **Rejected** — use-case changes touch many folders; common in older .NET samples. |
| Vertical slices without CQRS | **Rejected** — misses explicit read/write separation teaching goal. |
| CQRS + vertical slices together (MediatR, `Features/`) | **Accepted** — one branch, one coherent modern .NET story. |

## Consequences

- **Positive:** One folder per use case; aligns with modern .NET and MediatR practice; CQRS read/write paths stay explicit.
- **Negative:** Some duplication across slices until shared building blocks mature.
- **Follow-up:** ADR-003 adds event sourcing while **retaining** CQRS and vertical slices — branch 04 is not a rollback of either pattern.
