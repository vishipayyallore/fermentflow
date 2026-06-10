---
name: fermentflow-foundations
description: Work on FermentFlow — DDD bounded contexts, CQRS, event sourcing, branch evolution, brewery logistics domain, .NET 8, Docker infrastructure, and architecture documentation.
---

# FermentFlow Foundations

**Scope:** .NET DDD reference application. See `README.md` and `.cursor/rules/00_project_scope.mdc`.

## Layout

| Path | Purpose |
|------|---------|
| `docs/01-overview/` | Overview, domain, architecture evolution |
| `docker/` | Local infrastructure compose |
| `src/` | Application source (branch-dependent) |
| `tools/psscripts/` | Maintenance scripts |

## Branch evolution

Always confirm the active git branch before editing source:

| Branch | Architecture |
|--------|--------------|
| `01-monolith_legacy` | Layered monolith, shared MongoDB |
| `02-monolith_with_cqrs` | Bounded contexts, CQRS |
| `03-monolith_with_cqrs_and_event_sourcing` | Event sourcing, RabbitMQ |
| `04-microservices` | Sales + Warehouses services |

## Domain theme

Brewery logistics: production batches → warehouse availability → sales orders. Ubiquitous language in `docs/01-overview/04-ubiquitous-language.md`.

## Design quality

- Respect bounded context boundaries — no cross-context DB coupling
- Use domain language in type and method names
- Explain pattern choices (CQRS, ACL, outbox) in comments and docs
- Include Mermaid context or sequence diagrams with ASCII fallbacks when explaining flows

## Related

- **Architecture rules:** `.cursor/rules/01_architecture-guidelines.mdc`
- **CI commands:** `.github/skills/ci-checks/SKILL.md`
- **Subagent:** `.cursor/agents/fermentflow-architecture-review.md`
