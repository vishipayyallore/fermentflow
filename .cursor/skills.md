# Repository skills (Artificial Neural Networks)

This file is **local to `t2-artificial-neural-networks`**. It complements `.cursor/rules/*.mdc` and `.github/copilot-instructions.md` with concise guidance for assistants editing this repo.

**Strict scope:** Swamy PKV's personal learning only — see `README.md` and `.cursor/rules/00_swamy_personal_learning_only.mdc`.

**Bundled agent skills:** `.github/skills/` is canonical; `.cursor/skills/` is a **byte-identical mirror** (see `.github/skills/README.md`). Bundles: **`ann-foundations`**, **`topic-companions`**, **`ci-checks`**, **`docs-verification`**, **`workspace-review`**, **`e2e-testing`**. Pushes under skills paths run **`.github/workflows/ci-skills-parity.yml`**; agent-facing path changes also run **`.github/workflows/ci-agent-docs-guard.yml`**.

**Governance integrity (primary):** Commit or stash before another tool touches copilot, rules, skills, agents, or `CLAUDE.md`; keep `.github/skills` ↔ `.cursor/skills` and agent mirrors in one change; prefer small diffs. **Secondary (restore only if damaged):** **`docs/agent-governance-recovery.md`**.

**Teaching content:** For each active week, maintain four aligned companions under `src/weekN/` — see `.github/copilot-instructions.md` and **`topic-companions`** skill. Subagents: **`ann-ci-verify`** (CI-aligned checks), **`ann-topic-bundle-review`** (one week bundle), **`ann-zero-copy-review`** (targeted paths).

---

## Four-layer topic companions (this repo only)

All learning content is organised by week under `src/weekN/`:

1. `src/weekN/01-notes/NN-<topic>.md` — theory (`01-` = week introduction + topic index)
2. `src/weekN/02-quizzes/NN-<topic>-quiz.md` — self-assessment (curriculum topic index)
3. `src/weekN/03-notebooks/NN-<topic>-implementation.ipynb` — from-scratch code (layer order)
4. `src/weekN/04-discussions/NN-<topic>-discussion.md` — worked examples (layer order)

**Term map:** `src/course-roadmap-and-module-overview.md`. **Cross-layer map:** `01-introduction-to-neural-networks.md` topic index (Week 1) and each week's `01-introduction-*.md` note. See `docs/01_repository-structure.md` and `.cursor/rules/07_file-naming-conventions.mdc`.

---

## Tools (maintenance)

- **Index:** `tools/README.md` → `pyscripts/README.md`, `psscripts/README.md`.
- **Markdown / links:** `.github/skills/ci-checks/SKILL.md`; **Lychee** via Docker or `.\tools\psscripts\Run-MarkdownLintAndLychee.ps1`.
- **Zero-copy spot checks:** `tools/psscripts/Verify-ZeroCopy.ps1` when applicable.
- **Conversions (internal):** `tools/psscripts/Convert-SourceMaterialPdfsToMarkdown.ps1`, `tools/pyscripts/pdf_to_md.py`, `tools/pyscripts/html_to_md.py`, `tools/pyscripts/pptx_to_md.py`, `tools/pyscripts/md_to_pdf_reportlab.py`.
- **Quiz fence fix:** `tools/pyscripts/fix_quiz_code_fences.py` (scans active `src/weekN` quiz/discussion folders).
- **Public docs hygiene:** Never put `source-material/` paths or labels in `README.md`, `docs/`, or public content trees; see `.cursor/rules/06_source_material_rules.mdc`.

---

## CI expectations

- **Python:** `uv sync`, isort / black / flake8, notebook JSON — `ci-python.yml`.
- **Docs:** Markdown lint and Lychee — `ci-documentation.yml`.
- **Parity / guard:** `.github/skills/` ↔ `.cursor/skills/`; **`.github/agents/` ↔ `.cursor/agents/`**; **`ci-agent-docs-guard.yml`** when `.cursor/`, `.github/` skills or agents, or `CLAUDE.md` change.

Use the **`ci-checks`** skill for exact local commands.
