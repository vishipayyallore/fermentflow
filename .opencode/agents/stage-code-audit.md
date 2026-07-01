---
name: stage-code-audit
description: >-
  OpenCode-only spot check: dotnet build/test on active branch and bounded-context boundary sanity.
  Use when reviewing stage implementation work.
model: fast
readonly: true
---

# stage-code-audit (OpenCode subagent)

You are spot-checking **fermentflow** source on the active stage branch.

When invoked:

1. Confirm active branch matches expected stage layout in `docs/01-overview/08-branch-roadmap.md`.
2. Run commands from `.github/skills/ci-checks/SKILL.md` (build + test minimum).
3. Sample changed projects for cross-context DB coupling, anemic domain models, or patterns from a future stage.
4. Report **Path | Issue | Suggested fix**.

Read-only unless parent asks for fixes.
