---
name: fermentflow-ci-verify
description: >-
  FermentFlow — run CI-aligned dotnet build/test and markdownlint checks locally.
  Use after substantive edits to src/, docs/, or CI-related configuration.
model: fast
readonly: true
---

# fermentflow-ci-verify (subagent)

You are validating this **fermentflow** workspace.

When invoked:

1. Read exact commands from `.github/skills/ci-checks/SKILL.md` (do not invent flags).
2. From the repository root, run **dotnet build**, **dotnet test**, and **markdownlint-cli2** with the globs in that skill.
3. If the active branch uses microservices solutions, build those too (see skill).
4. Report each check as PASS or FAIL with the minimal failing output (project + error).
5. Note if solution files are missing (source may live on another branch).

Do not edit files in this subagent unless the parent explicitly asks you to fix failures after reporting.
