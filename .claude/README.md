# `.claude/` — optional Claude Code extras

This folder is for **Claude Code** (or similar) **runtime** add-ons you choose to keep **beside** the repo's main agent layout.

## Canonical layout (do not duplicate here)

| Need | Use this (single source) |
|------|--------------------------|
| Always-on assistant rules | `.github/copilot-instructions.md`, `.cursor/rules/` |
| Repeatable procedures | `.github/skills/` ↔ `.cursor/skills/` (`SKILL.md` files) |
| Delegated audits / fresh-context tasks | `.cursor/agents/` ↔ `.github/agents/` |
| Reusable prompt skeletons | `.github/prompts/` (for example `task-prompt.md`, `smart-prompt-framework-guide.md`) |
| Entry + map | Root **`CLAUDE.md`** |

Keeping long policy **only** in copilot instructions + Cursor rules avoids **drift** between `CLAUDE.md`, `.claude/`, and Cursor.

## What you *may* put under `.claude/`

Short, **task-local** files (for example one-off prompt fragments or Claude Code–specific hooks) that are **not** mirrored elsewhere — **if** you use the Claude Code CLI and its conventions.

Any `.claude/` helper content that guides learning outputs should preserve this repo's teaching style: explain ideas in layman language, stay beginner friendly, and connect concepts to realistic business use cases wherever practical.

This repo does **not** require a `.claude/agents/` tree; custom subagents already live under **`.cursor/agents/`** (mirrored to **`.github/agents/`**). If you need Claude-native agent paths, copy from there rather than maintaining two divergent definitions.

## This learning workspace is not enterprise "clean architecture"

Artificial Neural Networks here is **notes, quizzes, notebooks, and from-scratch code** — not a deployed N-tier product. Borrow the **split** (small global file + deeper playbooks), not production architecture jargon, unless you add it for a different project.

**This repo's topic contract:** four aligned layers per week under `src/weekN/` (`01-notes/`, `02-quizzes/`, `03-notebooks/`, `04-discussions/`) per `.github/copilot-instructions.md` and `.cursor/rules/01_educational-content-rules.mdc`. Where a visual explanation is applicable, prefer a Mermaid diagram plus an ASCII fallback so the idea remains readable in plain-text contexts. **Layer-aware numbering** (`01`–`99`, never `00-` / `00_`): notes count in read order (`01-` = week intro); quizzes follow the curriculum topic index; notebooks and discussions count within their layer; term map at `src/course-roadmap-and-module-overview.md`. Cross-layer map: each week's `01-introduction-*.md` topic index — see `.cursor/rules/07_file-naming-conventions.mdc`.
