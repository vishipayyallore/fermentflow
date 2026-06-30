# Claude Code — fermentflow

This folder documents how Claude Code should use repository governance.

## Canonical map

| Resource | Path |
|----------|------|
| Entry point | `CLAUDE.md` (repo root) |
| Copilot instructions | `.github/copilot-instructions.md` |
| Cursor rules | `.cursor/rules/` (mirror: `.github/rules/`) |
| Skills | `.github/skills/` (mirror: `.cursor/skills/`) |
| Subagents | `.github/agents/` (mirror: `.cursor/agents/`) |

## What this repo is

**fermentflow** — Swamy PKV's personal .NET 10 architecture laboratory for DDD modernization in a brewery logistics domain. Nine permanent stage branches (`01-LegacyMonolith` … `09-Aspire`); not production software; not public courseware.

## Before large edits

1. Read `CLAUDE.md` and `.github/copilot-instructions.md`
2. Confirm active git branch and stage scope with `README.md` and `docs/01-overview/08-branch-roadmap.md`
3. Preserve Swamy-only framing — do not generalize docs for other audiences

## CI

- `ci-agent-docs-guard.yml` — governance file presence and mirrors
- `ci-skills-parity.yml` — skills byte parity
- `ci-dotnet.yml` — .NET build and test
- `ci-documentation.yml` — markdown lint and link checks

Local runner: `.github/skills/ci-checks/SKILL.md`.
