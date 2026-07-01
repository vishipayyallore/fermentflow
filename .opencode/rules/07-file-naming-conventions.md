# File Naming Conventions

## Documentation (`docs/`)

| Pattern | Example | Notes |
|---------|---------|-------|
| `NN-topic.md` | `04-ubiquitous-language.md` | Two-digit order prefix under `01-overview/` |
| `01_repository-structure.md` | repo root of `docs/` | Structural SSOT |
| `ADR-NNN-slug.md` | `ADR-001-establish-fermentflow.md` | One-based ADR numbering — no `ADR-000` |

## Source code (`src/`)

| Kind | Convention | Example |
|------|------------|---------|
| Projects | PascalCase | `FermentFlow.Sales.Domain` |
| Feature slices (branch 03+) | PascalCase folder per use case | `Features/CreateSalesOrder/` |
| Handlers / validators | `{Action}Handler.cs`, `{Action}Validator.cs` | `CreateSalesOrderHandler.cs` |
| Domain types | PascalCase, ubiquitous language | `InventoryItem`, `SalesOrder` |
| Integration tests | `*Tests.cs` under `tests/` | `CreateSalesOrderTests.cs` |

## Git branches (permanent stage checkpoints)

```text
01-LegacyMonolith
02-ModularMonolith
03-CQRS-VerticalSlices
04-CQRS-EventSourcing
05-Microservices
06-OutboxPattern
07-CircuitBreaker
08-Observability
09-Aspire
```

## Git tags (milestones)

```text
v1.0-blueprint-approved
v1.1-stage01-start          # optional baseline when Stage 01 branch opens
v1.1-stage01-complete
v1.2-stage02-start
v1.2-stage02-complete
…
v1.9-stage09-complete
```

**Format:** `v1.<stage>-<descriptor>` — annotated tags (`git tag -a`) with intent in the message.

## Images and diagrams

- kebab-case descriptive names: `sales-inventory-context-map.png`
- Prefer Mermaid in markdown with ASCII fallbacks

## Governance rules (exception)

- `.cursor/rules/` and `.github/rules/` use numbered `NN_` prefixes for load order — not stage numbering.
