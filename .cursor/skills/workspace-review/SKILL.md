---
name: workspace-review
description: Comprehensive workspace review for Artificial Neural Networks — structure, zero-copy, CI, four-layer companions, source-material hygiene, beginner-friendly teaching quality, and business-use-case grounding.
---

# Workspace Review — Artificial Neural Networks

## Protocol

1. Read `.github/copilot-instructions.md` (four-layer model, zero-copy, `source-material/` read-only — never listed in public `README.md` or `docs/`).
2. Compare the tree to `docs/01_repository-structure.md` and `README.md`.
3. Python: `uv sync` at repo root; `uv run …` per `pyproject.toml` / CI.
4. **Zero-copy:** original synthesis in public folders (`src/weekN/01-notes/`, `src/weekN/02-quizzes/`, `src/weekN/03-notebooks/`, `src/weekN/04-discussions/`).
5. **Four-layer parity:** for each active week, confirm `01-notes/`, `02-quizzes/`, `03-notebooks/`, and `04-discussions/` subfolders exist under `src/weekN/`.
6. **Concept-first prose:** spot-check reading notes and notebook Markdown cells that introduce architectures and training math before code.
7. **Teaching clarity:** confirm important concepts use beginner-friendly wording and layman explanations before formal detail.
8. **Topic numbering:** confirm layer-aware prefixes (`01`–`99`, never `00-` / `00_`); term map at `src/course-roadmap-and-module-overview.md`; week topic indexes match filesystem.
9. **Business grounding:** confirm realistic business use cases are present where they help the topic feel concrete.
10. **Diagram accessibility:** confirm Mermaid diagrams include ASCII fallbacks wherever a visual explanation is applicable.
11. **Quiz format:** confirm active quizzes use `<details>` answer keys with per-option rationales (not bare `**Correct answer**:` blocks).
12. Run the **ci-checks** skill (Python + notebook JSON + markdownlint + optional Lychee).
13. Optionally run **docs-verification**.
14. **Skills parity:** `.github/skills/**` ↔ `.cursor/skills/**` byte-identical — see `.github/skills/README.md`.
15. **Agents parity:** `.github/agents/**` ↔ `.cursor/agents/**` byte-identical.

## Archive handling

- `.archive/` (if present) is preserved legacy content; do not flag it as stale active content unless Swamy asks to migrate it.
- `source-material/.archive/` (if present) is preserved raw/reference material; keep it read-only and do not count it as an automatic migration gap.
- Reviews should focus on active `src/weekN/` bundles plus governance/tooling consistency.

## Output

Critical / Major / Minor findings; CI summary; doc accuracy notes.

**Governance integrity (primary):** do not bulk-edit copilot, rules, skills, or agents without commits and mirror-safe diffs. If trees are **already** clearly corrupted, **then** use **`docs/agent-governance-recovery.md`** (secondary: Git restore) before continuing the review.
