# `.claude/` — optional Claude Code extras

This folder is for **Claude Code** (or similar) **runtime** add-ons beside the repo's main agent layout.

## Canonical layout (do not duplicate here)

| Need | Use this (single source) |
|------|--------------------------|
| Always-on assistant rules | `.github/copilot-instructions.md`, `.cursor/rules/` |
| Repeatable procedures | `.github/skills/` ↔ `.cursor/skills/` (`SKILL.md` files) |
| Delegated audits | `.cursor/agents/` ↔ `.github/agents/` |
| Reusable prompt skeletons | `.github/prompts/` |
| Entry + map | Root **`CLAUDE.md`** |

## What you may put under `.claude/`

Short, **task-local** files for Claude Code CLI use — **if** you use that tool and its conventions.

This repo does **not** require a `.claude/agents/` tree; custom subagents live under **`.cursor/agents/`** (mirrored to **`.github/agents/`**). Copy from there rather than maintaining divergent definitions.

## FermentFlow context

FermentFlow is a **.NET DDD reference application** — bounded contexts, branch evolution, and architecture docs under `docs/01-overview/`. See `.github/copilot-instructions.md` and `.cursor/rules/01_architecture-guidelines.mdc`.
