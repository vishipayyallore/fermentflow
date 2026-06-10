---
name: fermentflow-foundations
description: Work on FermentFlow — Swamy's personal DDD architecture laboratory, nine-branch evolution (CQRS-VerticalSlices at 03), bounded contexts, event sourcing, .NET 10, Aspire, brewery logistics domain, and architecture documentation.
---

# FermentFlow Foundations

**Scope:** Swamy PKV's personal architecture laboratory only. See `README.md` **Scope (read this first)** and `.cursor/rules/00_project_scope.mdc`.

## Layout

| Path | Purpose |
|------|---------|
| `docs/01_repository-structure.md` | Layout, branch strategy, naming (SSOT) |
| `docs/01-overview/08-branch-roadmap.md` | Per-branch folder trees and characteristics |
| `docker/` | Local infrastructure compose |
| `src/` | Application source (branch-dependent) |
| `tests/` | Cross-service and architecture tests (from stage 06+) |
| `tools/psscripts/` | Maintenance scripts |

## Nine-branch evolution

Always confirm the active git branch before editing source:

```text
01-LegacyMonolith → 02-ModularMonolith → 03-CQRS-VerticalSlices → 04-EventSourcing
→ 05-Microservices → 06-OutboxPattern → 07-CircuitBreaker
→ 08-Observability → 09-Aspire
```

**Branch 03** combines CQRS, MediatR, and **Vertical Slice Architecture** (feature folders per use case). Do not split CQRS from vertical slices on this branch — they are one learning step.

Legacy baseline branches map to early stages — see `docs/01_repository-structure.md`.

## Domain theme

Brewery logistics: Production → Inventory → Sales. Ubiquitous language in `docs/01-overview/04-ubiquitous-language.md`.

## Design quality

- Respect bounded context boundaries — no cross-context DB coupling
- Use domain language in type and method names
- From branch 03 onward: organize by feature slice (`Features/CreateSalesOrder/`, etc.)
- Explain pattern choices (vertical slices, CQRS, ACL, outbox, Aspire) in comments and docs
- Do not reference Packt, BrewUp, or source book names in public docs unless Swamy explicitly asks
- Include Mermaid context or sequence diagrams with ASCII fallbacks when explaining flows

## Related

- **Architecture rules:** `.cursor/rules/01_architecture-guidelines.mdc`
- **CI commands:** `.github/skills/ci-checks/SKILL.md`
- **Subagent:** `.cursor/agents/fermentflow-architecture-review.md`
