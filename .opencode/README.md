# OpenCode — fermentflow

OpenCode plugin config for this repository. Governance canonical sources: `.github/copilot-instructions.md`, `.cursor/rules/`, `.github/skills/`.

## Layout

```text
docs/01-overview/    docker/    src/    tests/    tools/psscripts/
```

## Rules

`rules/` mirrors `.cursor/rules/` (00–08).

## Skills

Same bundles as `.github/skills/` — see `skills/README.md`.

## Agents

- `fermentflow-ci-verify`
- `fermentflow-architecture-review`
- `docs-originality-review`
- `stage-code-audit` (OpenCode-only: dotnet build/test + architecture spot check)

## CI workflows

| Workflow | Scope |
| -------- | ----- |
| `ci-dotnet.yml` | .NET build and test |
| `ci-documentation.yml` | Markdown lint + links |
| `ci-skills-parity.yml` | Skills mirror parity |
| `ci-agent-docs-guard.yml` | Governance + agent mirrors |

Local runner: `skills/ci-checks/SKILL.md`.

## Package

`package.json` pins `@opencode-ai/plugin` for local OpenCode integration.
