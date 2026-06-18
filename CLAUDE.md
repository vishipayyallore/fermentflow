# CLAUDE.md — Claude Code entry point

## Repository

**fermentflow** — Swamy PKV's personal .NET 10 architecture laboratory. Explores DDD, CQRS, Event Sourcing, Outbox, Circuit Breaker, Observability, and .NET Aspire through incremental refactoring of a brewery logistics domain. **Not** production software; not public courseware.

## Non-negotiable: Swamy only

This repository is **Swamy PKV's personal learning and experimentation workspace**. Do **not** reword `README.md` or docs to imply a general audience unless Swamy explicitly asks. Preserve the **Scope (read this first)** block in `README.md`. Do **not** reference Packt, BrewUp, or source book names in public docs unless Swamy explicitly asks.

## Learning roadmap

Nine intentional stages — see `README.md`:

```text
01-LegacyMonolith → … → 09-Aspire
```

Detail: `docs/01_repository-structure.md` and `docs/01-overview/08-branch-roadmap.md`

## Project layout

| Path | Purpose |
|------|---------|
| `docs/01-overview/` | Architecture, domain language, evolution vision |
| `docker/` | Local infrastructure |
| `src/` | Application source (stage-dependent) |
| `tools/` | Maintenance scripts (`psscripts/`) |

## Agent skills (`SKILL.md`)

Bundled on-demand procedures live under `.github/skills/` (mirrored at `.cursor/skills/`). How that complements `CLAUDE.md`, rules, and MCP: **`docs/agent-skills.md`**.

## Agent subagents (Cursor)

**Custom subagents** live under **`.cursor/agents/`** (YAML frontmatter + instructions), mirrored at **`.github/agents/`**. Index: **`docs/agent-subagents.md`**.

**Invocation:** natural language ("use the fermentflow-ci-verify subagent") or `/fermentflow-ci-verify` when supported.

## Context layering

| Layer | In this repository | Holds |
|------|---------------------|--------|
| **Global contract** | **`CLAUDE.md` (this file)** | What this repo *is*, Swamy-only scope, layout, env, CI pointers |
| **Playbooks** | **`.github/skills/`**, **`.cursor/agents/`**, **`.github/prompts/`** | How to run CI, audit architecture docs, write prompts |
| **Optional Claude Code extras** | **`.claude/`** | Short CLI-only additions; see **`.claude/README.md`** |

## Governance integrity

Assistant behaviour is defined under `.github/copilot-instructions.md`, `.cursor/rules/` (including `.cursor/rules/00_project_scope.mdc` and `.cursor/rules/02_repository-structure.mdc`), mirrored skills and agents, and **`CLAUDE.md`**. Index: **`.cursor/skills.md`**. Change both mirror trees in the same commit; rely on **`ci-skills-parity.yml`** / **`ci-agent-docs-guard.yml`** to catch drift. Recovery: **`docs/agent-governance-recovery.md`**.

## Environment

```powershell
# Prerequisites: .NET 10 SDK, Docker Desktop
cd docker
docker compose up -d
cd ..\src
dotnet restore FermentFlow.sln
dotnet build FermentFlow.sln
dotnet test FermentFlow.sln
```

See `docs/01-overview/06-running-locally.md` for stage-specific run instructions.

## CI checks (run locally)

Aligned with `.github/workflows/ci-dotnet.yml`, `.github/workflows/ci-documentation.yml`, `.github/workflows/ci-skills-parity.yml`, and `.github/workflows/ci-agent-docs-guard.yml`. Full detail: `.github/skills/ci-checks/SKILL.md`.

```powershell
dotnet build src/FermentFlow.sln --configuration Release
dotnet test src/FermentFlow.sln --configuration Release --no-build
npx --yes markdownlint-cli2 "README.md" "docs/**/*.md" "src/**/*.md" "tools/**/*.md"
```

Optional link check: `.\tools\psscripts\Run-MarkdownLintAndLychee.ps1`

## Key files

| Path | Purpose |
|------|---------|
| `README.md` | Overview, scope, learning roadmap |
| `docs/01-overview/07-fermentflow-modernization-vision.md` | 9-stage modernization plan |
| `docs/01_repository-structure.md` | Structural SSOT — layout, roadmap, naming |
| `docs/01-overview/08-branch-roadmap.md` | Per-branch source trees (01–09) |
| `docs/01-overview/09-architecture-governance.md` | Governance, DoD, dependency rules |
| `docs/02-adr/README.md` | ADR index (branch 02 onward) |
| `.github/copilot-instructions.md` | Canonical Copilot / agent instructions |
| `.cursor/rules/00_project_scope.mdc` | Swamy-only scope (always apply) |
| `.github/skills/fermentflow-foundations/SKILL.md` | DDD workspace SOP |
| `.github/workflows/ci-dotnet.yml` | .NET build and test |
| `.github/workflows/ci-skills-parity.yml` | Skills mirror parity |
| `.github/workflows/ci-agent-docs-guard.yml` | Agent docs guard |
