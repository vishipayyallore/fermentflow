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

Introduce **domain unit tests** per context and **Testcontainers** for integration tests:

```text
tests/
├── FermentFlow.Architecture.Tests
├── FermentFlow.Sales.UnitTests
├── FermentFlow.Inventory.UnitTests
├── FermentFlow.Production.UnitTests
└── FermentFlow.IntegrationTests    # Testcontainers — PostgreSQL from branch 03
```

Example domain tests (Given/When/Then):

```text
Given stock of 10
When order requests 5
Then order is accepted

Given stock of 10
When order requests 15
Then order is rejected
```

These tests become essential when event sourcing arrives on branch 04.

## Alternatives Considered

| Alternative | Outcome |
|-------------|---------|
| CQRS with horizontal layers only (`Commands/`, `Queries/` folders) | **Rejected** — use-case changes touch many folders; common in older .NET samples. |
| Vertical slices without CQRS | **Rejected** — misses explicit read/write separation teaching goal. |
| CQRS + vertical slices together (MediatR, `Features/`) | **Accepted** — one branch, one coherent modern .NET story. |

## Consequences

- **Positive:** One folder per use case; aligns with modern .NET and MediatR practice; CQRS read/write paths stay explicit.
- **Negative:** Some duplication across slices until shared building blocks mature.
- **Follow-up:** [ADR-012](ADR-012-cross-context-collaboration-modular-monolith.md) defines how Sales collaborates with Inventory without cross-context repositories or MediatR. ADR-003 adds event sourcing while **retaining** CQRS and vertical slices — Stage 04 is not a rollback of either pattern.
