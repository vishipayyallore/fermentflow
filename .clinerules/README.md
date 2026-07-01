# Cline rules — fermentflow

Mirrors Cursor/GitHub governance for Cline. **Canonical source:** `.cursor/rules/` and `.github/copilot-instructions.md`.

## Sync sources

| Cline path | Canonical |
|------------|-----------|
| `rules/` | `.cursor/rules/*.mdc` (same numbering, `-` in filename, `.md` extension) |
| `skills/` | `.github/skills/*/SKILL.md` |
| `agents/` | `.github/agents/*.md` |
| `AGENTS.md` | Workspace entry for Cline |

## Bundled skills

- `fermentflow-foundations`
- `ci-checks`
- `docs-verification`
- `workspace-review`
- `e2e-testing`

## Subagents

- `fermentflow-ci-verify`
- `fermentflow-architecture-review`
- `docs-originality-review`

When editing governance, update canonical paths first, then resync this tree.

## CI workflows

`ci-dotnet.yml`, `ci-documentation.yml`, `ci-skills-parity.yml`, `ci-agent-docs-guard.yml` — see `CLAUDE.md`.
