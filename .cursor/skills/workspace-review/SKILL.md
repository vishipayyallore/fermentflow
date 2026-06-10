---
name: workspace-review
description: Comprehensive workspace review for FermentFlow — structure, DDD alignment, CI, architecture docs, and bounded-context consistency.
---

# Workspace Review — FermentFlow

## Protocol

1. Read `.github/copilot-instructions.md` and `docs/01-overview/`.
2. Compare tree to `docs/01_repository-structure.md` and `README.md`.
3. Confirm active branch matches documented architecture stage.
4. **Bounded contexts:** verify Sales/Warehouses/Production boundaries in source match docs.
5. **Ubiquitous language:** spot-check type names against `docs/01-overview/04-ubiquitous-language.md`.
6. **Docker:** confirm `docker/` compose services match branch requirements.
7. Run the **ci-checks** skill (dotnet build/test + markdownlint + optional Lychee).
8. Optionally run **docs-verification**.
9. **Skills parity:** `.github/skills/**` ↔ `.cursor/skills/**` byte-identical.
10. **Agents parity:** `.github/agents/**` ↔ `.cursor/agents/**` byte-identical.

## Output

Critical / Major / Minor findings; CI summary; doc accuracy notes.

**Governance integrity:** do not bulk-edit copilot, rules, skills, or agents without mirror-safe diffs. Recovery: **`docs/agent-governance-recovery.md`**.
