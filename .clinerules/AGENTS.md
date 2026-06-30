# AGENTS.md — fermentflow

**Repository:** `D:\GitHub\fermentflow`

Swamy PKV's personal **FermentFlow** architecture laboratory — DDD modernization in .NET 10 through nine permanent stage branches.

## Read first

1. `README.md` — scope and learning roadmap
2. `docs/01_repository-structure.md` — folder layout
3. `.github/copilot-instructions.md` — development guidelines
4. `CLAUDE.md` — governance map

## Structure

```text
docs/01-overview/    docker/    src/    tests/    tools/psscripts/
```

## Subagents

Canonical definitions live in `.github/agents/`; `.clinerules/agents/` is a Cline-facing mirror.

| Agent | Use when |
|-------|----------|
| `fermentflow-ci-verify` | After code or governance edits |
| `fermentflow-architecture-review` | Reviewing bounded contexts, ADRs, or overview docs |
| `docs-originality-review` | Doc rewrites under `docs/` |

## CI workflows

| Workflow | Scope |
| -------- | ----- |
| `ci-dotnet.yml` | .NET build and test |
| `ci-documentation.yml` | Markdown lint + links |
| `ci-skills-parity.yml` | Skills mirror parity |
| `ci-agent-docs-guard.yml` | Governance + agent mirrors |

Local runner: `.github/skills/ci-checks/SKILL.md` (Cline mirror: `.clinerules/skills/ci-checks.md`).

## Rules

Canonical rules live in `.github/rules/`; `.clinerules/rules/` is a Cline-facing mirror.

Numbered `00`–`08` — aligned with `.cursor/rules/`.

## Do not

- Generalize docs for a public audience unless Swamy explicitly asks
- Reference Packt, BrewUp, or source book names in public docs unless Swamy explicitly asks
- Implement patterns from a later stage on an earlier stage branch
