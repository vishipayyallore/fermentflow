# Cursor rules

FermentFlow assistant rules (`.mdc` files). **Mirror:** `.github/rules/` (byte-identical).

Universal behaviour is also in `.github/copilot-instructions.md`.

| Rule | Purpose |
|------|---------|
| `00_project_scope.mdc` | Swamy-only scope (always apply) |
| `01_architecture-guidelines.mdc` | DDD and bounded-context guidelines |
| `02_repository-structure.mdc` | Layout pointer |
| `03_quality-assurance.mdc` | C# and test QA |
| `04_markdown-standards.mdc` | Markdown conventions |
| `05_primary-directives.mdc` | Primary engineering directives |
| `06_reference-docs-rules.mdc` | External refs and doc originality |
| `07_file-naming-conventions.mdc` | Docs, code, branches, and tags |
| `08_copilot-instructions-extract.mdc` | Condensed Copilot guardrails |

Structural detail: `docs/01_repository-structure.md`

## CI workflows

| Workflow | Scope |
| -------- | ----- |
| `ci-dotnet.yml` | .NET build and test |
| `ci-documentation.yml` | Markdown lint + links |
| `ci-skills-parity.yml` | Skills mirror parity |
| `ci-agent-docs-guard.yml` | Governance + agent mirrors |
