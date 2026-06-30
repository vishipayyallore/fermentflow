# Reference and documentation rules

**Scope**: `docs/`, ADRs, and public-facing markdown.

## External references

- **Prefer official docs**: Microsoft Learn (.NET, ASP.NET Core, Aspire), DDD/CQRS community references, EventStoreDB, MassTransit, Polly
- **Link, don't copy**: Summarize concepts in your own words; link to authoritative sources for API details
- **Version awareness**: Note .NET or package versions when behaviour is version-specific

## Originality

- Architecture docs should be **original synthesis** for Swamy's laboratory — not pasted vendor tutorials or book excerpts
- Code examples in docs should match this repository's actual layout on the active stage branch (`src/`, `tests/`, `docker/`)
- Diagrams should reflect **FermentFlow** bounded contexts (Sales, Inventory, Production), not generic stock diagrams

## Reviews

- Substantive doc rewrites can be spot-checked with the `docs-originality-review` subagent
- Formal audit reports go in `docs/reviews/` when needed

## Do not

- Reference Packt, BrewUp, or source book names in public docs unless Swamy explicitly requests it
- Document features not yet implemented on the active stage without marking them as planned
- Frame content for a general audience — this repository is Swamy-only personal study
