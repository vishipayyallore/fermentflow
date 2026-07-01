# Cursor Rules

Cursor rule files (`.mdc`) for this repository. **Canonical mirror:** `.cursor/rules/` ↔ `.github/rules/` (byte-identical).

## Rule files (load order by `NN_` prefix)

| File | Role |
|------|------|
| `00_project_scope.mdc` | Swamy-only personal laboratory scope |
| `01_architecture-guidelines.mdc` | DDD, bounded contexts, stage patterns |
| `02_repository-structure.mdc` | Layout and nine-branch roadmap |
| `03_quality-assurance.mdc` | C# and test QA |
| `04_markdown-standards.mdc` | Markdown formatting |
| `05_primary-directives.mdc` | Engineering philosophy and stage fidelity |
| `06_reference-docs-rules.mdc` | External refs and doc originality |
| `07_file-naming-conventions.mdc` | Docs, code, branches, and tags |
| `08_copilot-instructions-extract.mdc` | Condensed copilot guardrails |

**Note:** Keep `.cursor/rules/` and `.github/rules/` aligned when editing policy.

## CI workflows

| Workflow | Scope |
| -------- | ----- |
| `ci-dotnet.yml` | .NET build and test |
| `ci-documentation.yml` | Markdown lint + links |
| `ci-skills-parity.yml` | Skills mirror parity |
| `ci-agent-docs-guard.yml` | Governance + agent mirrors |
