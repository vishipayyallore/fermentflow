# CLAUDE.md — Claude Code entry point

## Repository

**fermentflow** — a .NET reference application for brewery logistics. Demonstrates DDD, CQRS, Event Sourcing, Outbox Pattern, Circuit Breaker, and microservices through a refactoring journey across git branches. **Not** a production system; it is a teaching and portfolio sample.

## Project layout

| Path | Purpose |
|------|---------|
| `docs/01-overview/` | Architecture, domain language, evolution vision |
| `docker/` | Local infrastructure (MongoDB, EventStore, RabbitMQ) |
| `src/` | Application source (branch-dependent: monolith or microservices) |
| `tools/` | Maintenance scripts (`psscripts/`) |

Branch evolution is the primary learning axis — see `docs/01-overview/03-architecture-evolution.md`.

## Agent skills (`SKILL.md`)

Bundled on-demand procedures live under `.github/skills/` (mirrored at `.cursor/skills/`). How that complements `CLAUDE.md`, rules, and MCP: **`docs/agent-skills.md`**.

## Agent subagents (Cursor)

**Custom subagents** live under **`.cursor/agents/`** (YAML frontmatter + instructions), mirrored at **`.github/agents/`**. Index: **`docs/agent-subagents.md`**.

**Invocation:** natural language ("use the fermentflow-ci-verify subagent") or `/fermentflow-ci-verify` when supported.

## Context layering

| Layer | In this repository | Holds |
|------|---------------------|--------|
| **Global contract** | **`CLAUDE.md` (this file)** | What this repo *is*, layout, env, CI pointers, key-file table |
| **Playbooks** | **`.github/skills/`**, **`.cursor/agents/`**, **`.github/prompts/`** | How to run CI, audit architecture docs, write prompts |
| **Optional Claude Code extras** | **`.claude/`** | Short CLI-only additions; see **`.claude/README.md`** |

**Rule of thumb:** universal behaviour → **`.github/copilot-instructions.md`** + **`.cursor/rules/`**. Repeatable procedure → **`SKILL.md`** or **subagent**. **`CLAUDE.md`** → **links and summaries** only.

## Governance integrity

Assistant behaviour is defined under `.github/copilot-instructions.md`, `.cursor/rules/`, mirrored skills and agents, and **`CLAUDE.md`**. Change both mirror trees in the same commit; rely on `ci-skills-parity` / `ci-agent-docs-guard` to catch drift. Recovery: **`docs/agent-governance-recovery.md`**.

## Environment

```powershell
# Prerequisites: .NET 8 SDK, Docker Desktop
cd docker
docker compose up -d
cd ..\src
dotnet restore FermentFlow.sln
dotnet build FermentFlow.sln
dotnet test FermentFlow.sln
```

See `docs/01-overview/06-running-locally.md` for branch-specific run instructions.

## CI checks (run locally)

Aligned with `.github/workflows/ci-dotnet.yml` and `.github/workflows/ci-documentation.yml`. Full detail: `.github/skills/ci-checks/SKILL.md`.

```powershell
dotnet build src/FermentFlow.sln --configuration Release
dotnet test src/FermentFlow.sln --configuration Release --no-build
npx --yes markdownlint-cli2 "README.md" "docs/**/*.md" "src/**/*.md" "tools/**/*.md"
```

Optional link check: `.\tools\psscripts\Run-MarkdownLintAndLychee.ps1`

## Key files

| Path | Purpose |
|------|---------|
| `README.md` | Project overview |
| `docs/01-overview/01-project-overview.md` | Structure, stack, branches |
| `docs/01-overview/04-ubiquitous-language.md` | Domain vocabulary |
| `docs/01_repository-structure.md` | Structural single source of truth |
| `docs/agent-skills.md` | SKILL.md pattern and skills mirror |
| `docs/agent-subagents.md` | Subagent index |
| `.github/copilot-instructions.md` | Canonical Copilot / agent instructions |
| `.github/skills/fermentflow-foundations/SKILL.md` | DDD/CQRS workspace SOP |
| `.github/skills/ci-checks/SKILL.md` | Local CI runner |
| `tools/README.md` | Repo-local helpers |
| `.cursor/rules/00_project_scope.mdc` | Project scope (always apply) |
| `.cursor/rules/01_architecture-guidelines.mdc` | DDD and bounded-context rules |
| `.cursor/rules/02_repository-structure.mdc` | Layout pointer |
| `.cursor/rules/05_primary-directives.mdc` | Primary directives |
| `.cursor/skills.md` | Bundled skills pointer |
| `.github/workflows/ci-dotnet.yml` | .NET build and test |
| `.github/workflows/ci-documentation.yml` | Markdown lint and Lychee |
| `.github/workflows/ci-skills-parity.yml` | Skills mirror parity |
| `.github/workflows/ci-agent-docs-guard.yml` | Agent docs guard |
