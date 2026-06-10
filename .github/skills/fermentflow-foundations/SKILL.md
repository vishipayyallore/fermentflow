---
name: fermentflow-foundations
description: Work on FermentFlow — Swamy's personal DDD architecture laboratory, nine-stage evolution, bounded contexts, CQRS, event sourcing, .NET 10, Aspire, brewery logistics domain, and architecture documentation.
---

# FermentFlow Foundations

**Scope:** Swamy PKV's personal architecture laboratory only. See `README.md` **Scope (read this first)** and `.cursor/rules/00_project_scope.mdc`.

## Layout

| Path | Purpose |
|------|---------|
| `docs/01-overview/` | Overview, domain, architecture evolution, modernization vision |
| `docker/` | Local infrastructure compose |
| `src/` | Application source (stage-dependent) |
| `tools/psscripts/` | Maintenance scripts |

## Nine-stage evolution

Always confirm the active git branch/stage before editing source:

```text
01-LegacyMonolith → 02-ModularMonolith → 03-CQRS → 04-EventSourcing
→ 05-Microservices → 06-OutboxPattern → 07-CircuitBreaker
→ 08-Observability → 09-Aspire
```

Legacy baseline branches (`01-monolith_legacy` … `04-microservices`) map to early stages — see `docs/01-overview/01-project-overview.md`.

## Domain theme

Brewery logistics: Production → Inventory → Sales. Ubiquitous language in `docs/01-overview/04-ubiquitous-language.md`.

## Design quality

- Respect bounded context boundaries — no cross-context DB coupling
- Use domain language in type and method names
- Explain pattern choices (CQRS, ACL, outbox, Aspire) in comments and docs
- Do not reference Packt, BrewUp, or source book names in public docs unless Swamy explicitly asks
- Include Mermaid context or sequence diagrams with ASCII fallbacks when explaining flows

## Related

- **Architecture rules:** `.cursor/rules/01_architecture-guidelines.mdc`
- **CI commands:** `.github/skills/ci-checks/SKILL.md`
- **Subagent:** `.cursor/agents/fermentflow-architecture-review.md`
