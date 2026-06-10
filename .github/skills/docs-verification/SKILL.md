---
name: docs-verification
description: Verify markdown structure, four-layer week companions, folder naming, beginner-friendly explanations, and business-use-case grounding. Use when auditing docs, broken links, or cross-layer consistency.
---

# Documentation Verification — Artificial Neural Networks

**Four-layer** companions are organized by week under `src/weekN/` with four subfolders: `01-notes/`, `02-quizzes/`, `03-notebooks/`, `04-discussions/`.

## Verification matrix

| Concern | Source of truth | Common errors |
|--------|-----------------|---------------|
| Layout | `docs/01_repository-structure.md`, `README.md` | Missing layer for a week; wrong subfolder name |
| Notes | `src/weekN/01-notes/` | Instructor tone; concepts without layman intuition before math; missing business use case where helpful |
| Quizzes | `src/weekN/02-quizzes/` | Marked answers inconsistent with explanations; copied institution questions; bare `**Correct answer**:` without `<details>` rationales on active quizzes |
| Notebooks | `src/weekN/03-notebooks/` | Missing `-implementation` suffix; broken JSON; hidden cell state |
| Discussions | `src/weekN/04-discussions/` | Copied institution scenarios; missing original synthesis |
| Reusable code | `src/` (alongside week folders) | Network logic duplicated in notebooks without clear separation |
| Public docs | `.cursor/rules/06_source_material_rules.mdc` | Listing `source-material/` in `README.md`, `docs/**/*.md`, or structure diagrams |
| Diagrams | `.cursor/rules/01_educational-content-rules.mdc` | Mermaid diagram missing an ASCII fallback where a visual explanation is applicable |
| Week folders | `src/week1/`, `src/week2/`, … | Wrong casing (`Week1` instead of `week1`); content in wrong week |
| Topic numbering | `src/weekN/*/` | `00-` / `00_` prefix; topic index out of sync with filesystem; assuming same `NN` across layers when index differs |

## Archive handling

- `.archive/` (if present) is preserved legacy content and is not part of active docs parity unless Swamy asks for migration.
- `source-material/.archive/` (if present) is preserved raw/reference material; keep it internal-only and read-only.
- Do not require archive content to appear in `src/weekN/` during ordinary documentation audits.

## Output format

Use a table: **File | Status | Issues**. Concrete paths only; offer fixes when requested.

When noting teaching issues, explain them in beginner-friendly terms and mention when a missing business use case weakens the real-world explanation.
When noting diagram issues, mention whether a Mermaid diagram needs an ASCII fallback for environments that do not render Mermaid.
