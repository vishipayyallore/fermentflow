# Agent instructions (index)

This repository is Swamy PKV's **personal architecture laboratory** for FermentFlow — exploring DDD, CQRS, Event Sourcing, and modernization patterns in .NET 10 through a brewery logistics domain.

## Scope

Applies to: code changes, documentation edits, Docker infrastructure, automation, and reference implementations inside this repo. Does **not** apply to external repos, one-off shell sessions, or anything outside `d:\GitHub\fermentflow\`.

## Read first

1. `README.md` — **Scope (read this first)** and learning roadmap.
2. `CLAUDE.md` — repo-level assistant entry point and key policies.
3. `.github/copilot-instructions.md` — canonical assistant rules for this repository.
4. `.cursor/rules/00_project_scope.mdc` — Swamy-only scope (always apply).
5. `.cursor/rules/05_primary-directives.mdc` — primary engineering directives for agent work.

### Precedence on conflict

When the files above disagree, resolve in this order (highest wins):

1. `.cursor/rules/00_project_scope.mdc`
2. `.github/copilot-instructions.md` (canonical assistant rules; overrides `CLAUDE.md`)
3. `.cursor/rules/05_primary-directives.mdc`
4. `CLAUDE.md`
5. `README.md`

When you resolve a conflict between files, explicitly note in your response which file won and which rule you applied.

### Missing or unreadable files

If any referenced file is missing, empty, or unreadable, proceed with the remaining files and explicitly note the missing reference in your response.

## Claude-specific emphasis

- `.claude/README.md` — how the optional Claude Code tree maps to repo skills and agents.

## Bundled skills

Treat `.github/skills/` as the source of truth for reading and editing skill files. `.cursor/skills/` is its byte-identical mirror; if you must change either tree, update both trees in the same operation. The same rule applies to `.github/agents/` ↔ `.cursor/agents/` (enforced by `ci-agent-docs-guard`). If both sides cannot be updated atomically, do not edit either side yet.

## Prompts

- `.github/prompts/` contains repo-specific task and audit prompts.
