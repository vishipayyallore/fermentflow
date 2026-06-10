---
name: ann-foundations
description: Work on t2-artificial-neural-networks — week folders under src/, four-layer companions (01-notes, 02-quizzes, 03-notebooks, 04-discussions), from-scratch neural network implementations, zero-copy, beginner-friendly explanations, and realistic business use cases.
---

# Artificial Neural Networks

**Scope:** Swamy PKV's personal learning only. See `README.md` and `.cursor/rules/00_swamy_personal_learning_only.mdc`.

## Layout

Content is organized by **week** under `src/weekN/`. Each week has four companion subfolders:

| Layer | Path |
|-------|------|
| Notes | `src/weekN/01-notes/` |
| Quizzes | `src/weekN/02-quizzes/` |
| Notebooks | `src/weekN/03-notebooks/` |
| Discussions | `src/weekN/04-discussions/` |

Shared reusable logic (layer classes, activations, losses, training loops) lives in `src/` alongside the week folders.

## Topic-block numbering

- **Term map:** `src/course-roadmap-and-module-overview.md` — no `NN-` prefix.
- **`01-notes/`:** continuous `01`–`NN` in read order; `01-` = week introduction.
- **`02-quizzes/`:** `01`–`NN` by curriculum topic index.
- **`03-notebooks/` / `04-discussions/`:** continuous `01`–`NN` within each layer.
- **Cross-layer map:** topic index in `01-introduction-to-neural-networks.md`.
- **Never** `00-` / `00_` on learning files. Full rules: `.cursor/rules/07_file-naming-conventions.mdc`.

## Topic theme

Neural-network fundamentals from first principles: perceptrons and MLPs; activation functions; loss functions; forward and backward propagation; gradient-based optimization; regularization; common architectures introduced as the syllabus progresses. Frameworks (PyTorch / TensorFlow) may appear for **reference comparison**; the learning intent is from-scratch.

## Teaching quality

- Explain concepts in beginner-friendly language before using formal neural-network terms.
- Add layman explanations for important ideas, formulas, training steps, and architecture choices.
- Use realistic business use cases whenever practical so the concept is tied to a real application.
- Pair display equations with plain-English intuition and a numeric walkthrough when the topic is quantitative.
- Include a Mermaid diagram with an ASCII fallback wherever a network flow, layer relationship, training loop, or architecture is easier to understand visually.

## Related

- **Topic SOP:** `.github/skills/topic-companions/SKILL.md`
- **CI commands:** `.github/skills/ci-checks/SKILL.md`
- **Subagent:** `.cursor/agents/ann-topic-bundle-review.md`
