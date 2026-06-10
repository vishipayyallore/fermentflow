---
name: topic-companions
description: >-
  Four-layer topic companion architecture for t2-artificial-neural-networks — parity checks, migration SOP,
  and definition of done. Use when adding a topic, renaming files, or auditing a week bundle.
  Learning content should stay beginner friendly and grounded in realistic business use cases.
  Other repos use different layer counts (e.g. six-layer weeks in t1-feature-engineering).
---

# Topic companions — four-layer SOP (Artificial Neural Networks)

**Applies to**: `t2-artificial-neural-networks` **only**. Do not assume the same layer count or filenames in other course repositories.

**Canonical governance**: `.github/copilot-instructions.md`, `docs/01_repository-structure.md`, and `.cursor/rules/01_educational-content-rules.mdc`.

## Layers (four) per week under `src/`

| # | Path pattern | Role |
|---|--------------|------|
| 1 | `src/weekN/01-notes/` | Notes — first-person learning journey |
| 2 | `src/weekN/02-quizzes/` | Quizzes — self-assessment (original synthesis only) |
| 3 | `src/weekN/03-notebooks/` | Notebooks — from-scratch implementations |
| 4 | `src/weekN/04-discussions/` | Discussions — worked examples and discussion scenarios |

**Week folder naming:** lowercase `weekN` (e.g. `week1`, `week2`).

**Term-wide map:** `src/course-roadmap-and-module-overview.md` (no `NN-` prefix).

## Topic-block numbering (incremental learning order)

Before renames or new topics, read `.cursor/rules/07_file-naming-conventions.mdc`.

| Rule | Detail |
|------|--------|
| Forbidden | Never `00-` or `00_` on learning artifacts; start at `01` |
| Term map | `src/course-roadmap-and-module-overview.md` — no `NN-` prefix |
| Notes | Continuous `01`–`NN` in read order; `01-` = week introduction |
| Quizzes | `01`–`NN` by curriculum topic index |
| Notebooks / discussions | Continuous `01`–`NN` within each layer |
| Cross-layer map | Week topic index in each week's `01-introduction-*.md` note |
| After rename | Fix cross-links; run **`ci-checks`** skill locally |

## Migration SOP (on demand)

1. Confirm **naming contract** (`.cursor/rules/07_file-naming-conventions.mdc`) before renames.
2. For each **active** week, ensure all **four** subfolders exist (or document WIP in `docs/reviews/`).
3. Add new week folders **only when starting** that week — no empty future scaffolding.
4. After each phase: fix cross-links; run **`ci-checks`** skill locally.
5. Mark a week **done** only if all four layers have content, notebook health passes, and zero-copy passes.

## Definition of done (per week)

- [ ] All four subfolders exist: `01-notes/`, `02-quizzes/`, `03-notebooks/`, `04-discussions/`.
- [ ] Prefixes follow layer-aware rules in `07_file-naming-conventions.mdc`; no `00-` / `00_` learning-artifact names.
- [ ] Topic index in the week's `01-introduction-*.md` note matches the filesystem and cross-layer links.
- [ ] Content across notes, quizzes, notebooks, and discussions is aligned.
- [ ] Notebooks parse and run top-to-bottom (fixed seeds where stochastic).
- [ ] No broken internal links for that week.
- [ ] Quiz answers and worked steps match explanations.
- [ ] Active quizzes use `<details>` answer keys with per-option rationales and business use cases where helpful.
- [ ] Teaching content explains ideas in layman language and uses beginner-friendly wording.
- [ ] At least one realistic business use case appears where it helps make the topic concrete.
- [ ] Mermaid diagrams include ASCII fallbacks wherever a visual explanation is applicable.

## Related

- **Docs audit matrix:** `.github/skills/docs-verification/SKILL.md`
- **Subagent:** `.cursor/agents/ann-topic-bundle-review.md` (one topic pass)
