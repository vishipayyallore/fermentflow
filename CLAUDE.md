# CLAUDE.md — Claude Code entry point

## Repository

**t2-artificial-neural-networks** — academic learning workspace for the M.Sc. DSAI program (Term 2). Python, Jupyter, from-scratch neural network implementations. **Not** a web application or production system.

## Non-negotiable: Swamy only

This repository is **Swamy PKV's personal learning** material. It is **not** maintained for other learners, employers, or the public. Do **not** reword `README.md`, reading notes, or docs to imply a general audience unless Swamy explicitly asks. Preserve the **Scope (read this first)** block in `README.md`.

## Learning layout (this repo)

Companion artifacts follow the **four-layer** pattern in `.github/copilot-instructions.md`, organized by week under `src/weekN/` (`01-notes/`, `02-quizzes/`, `03-notebooks/`, `04-discussions/`).

## Agent skills (`SKILL.md`)

Bundled on-demand procedures live under `.github/skills/` (mirrored at `.cursor/skills/`). They use YAML frontmatter plus a Markdown body so agents can match tasks without loading everything up front. How that complements `CLAUDE.md`, rules, and MCP: **`docs/agent-skills.md`**.

## Agent subagents (Cursor)

**Custom subagents** live under **`.cursor/agents/`** (YAML frontmatter + instructions). Cursor uses them for delegated tasks with a **fresh context** (for example CI verification or a single-topic audit). The same files are **mirrored** at **`.github/agents/`** for visibility in Git; keep both trees identical when editing.

- **Index and how this fits `CLAUDE.md`:** **`docs/agent-subagents.md`**
- **Invocation:** natural language ("use the ann-ci-verify subagent") or `/ann-ci-verify` when supported.

**Claude Code** reads this **`CLAUDE.md`** as the project entry point; for Claude-native agent files, vendors document **`.claude/agents/`**. This repo does not create that folder unless you add it for CLI use — copy from `.cursor/agents/` if needed.

**How to extend `CLAUDE.md` for agents:** keep `CLAUDE.md` as a **table of contents** (scope, layout, env, CI, pointers). Put long playbooks in **skills** or **subagents**, not in `CLAUDE.md`, so the always-loaded file stays small.

## Context layering: global contract vs playbooks

| Layer | In this repository | Holds |
|------|---------------------|--------|
| **Global contract** | **`CLAUDE.md` (this file)** | What this repo *is*, Swamy-only scope, four-layer layout pointer, governance and CI pointers, key-file table. **Not** a second full copy of `.github/copilot-instructions.md` or `.cursor/rules/`. |
| **Playbooks** | **`.github/skills/`** (mirrored **`.cursor/skills/`**), **`.cursor/agents/`** (mirrored **`.github/agents/`**), **`.github/prompts/`** | How to run CI, audit a topic, write prompts, etc. |
| **Optional Claude Code extras** | **`.claude/`** | Short, CLI-only additions if you use them; see **`.claude/README.md`**. Avoid pasting long rules there (drift risk). |

**Rule of thumb:** universal behaviour → **`.github/copilot-instructions.md`** + **`.cursor/rules/`**. Repeatable procedure → **`SKILL.md`** or a **subagent**. **`CLAUDE.md`** → **links and summaries** only.

## Governance integrity (primary)

Assistant behaviour is defined under `.github/copilot-instructions.md`, `.cursor/rules/`, mirrored **`.github/skills` ↔ `.cursor/skills`**, mirrored **`.github/agents` ↔ `.cursor/agents`**, and **`CLAUDE.md`**. **Do not corrupt these:** commit or stash before another tool bulk-edits them; change both skill/agent mirrors in the same commit; prefer small scoped diffs; rely on `ci-skills-parity` / `ci-agent-docs-guard` to catch drift.

**Secondary (only if damage already happened):** restore from Git using **`docs/agent-governance-recovery.md`**.

## Key rules (summary)

- **Plain English or worked example**: For each taught concept, include simple plain English or a worked example; pair equations with words. Follow `.cursor/rules/01_educational-content-rules.mdc`.
- **Zero-copy / voice**: Follow `.cursor/rules/01_educational-content-rules.mdc` and related rules.
- **Source material**: Internal-only `source-material/` tree; never reference in public docs (see copilot instructions).

## Environment

```powershell
$Env:UV_LINK_MODE = "copy"
uv sync
jupyter notebook
```

## CI checks (run locally)

Aligned with `.github/workflows/ci-python.yml` and `.github/workflows/ci-documentation.yml`. Full detail: `.github/skills/ci-checks/SKILL.md`.

```bash
uv sync
uv run isort --check-only --diff src/
uv run black --check --line-length 127 --target-version py312 src/
uv run flake8 src/ --count --select=E9,F63,F7,F82 --show-source --statistics
uv run flake8 src/ --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
uv run python -c "import json,glob; [json.load(open(p,encoding='utf-8')) for p in glob.glob('src/**/*.ipynb', recursive=True)]"
npx --yes markdownlint-cli2 "README.md" "docs/**/*.md" "src/**/*.md" "tools/**/*.md"
```

Optional link check (Docker, from repo root): `docker run --rm -v "${PWD}:/workspace" -w /workspace lycheeverse/lychee:latest --config lychee.toml --cache --max-cache-age 1d '**/*.md'` — or `.\tools\psscripts\Run-MarkdownLintAndLychee.ps1`. Fallback: local `lychee` with the same flags.

## Key files

| Path | Purpose |
|------|---------|
| `README.md` | Overview and strict personal scope |
| `docs/agent-skills.md` | SKILL.md pattern, progressive disclosure, skills mirror |
| `.github/skills/topic-companions/SKILL.md` | Four-layer topic SOP, parity, definition of done (mirrored under `.cursor/skills/`) |
| `docs/agent-governance-recovery.md` | Keep governance uncorrupted (primary); Git restore bundle (secondary) |
| `docs/01_repository-structure.md` | Structural single source of truth |
| `.github/copilot-instructions.md` | Canonical Copilot / agent instructions |
| `tools/README.md` | Index of repo-local helpers (`pyscripts/`, `psscripts/`) |
| `.github/prompts/task-prompt.md` | Structured audit template |
| `.github/prompts/smart-prompt-framework-guide.md` | S.M.A.R.T. prompt framework |
| `.claude/README.md` | Optional Claude Code tree: how it maps to skills/agents |
| `.cursor/rules/00_swamy_personal_learning_only.mdc` | Swamy-only scope (always apply) |
| `.cursor/rules/01_educational-content-rules.mdc` | Zero-copy, voice, four-layer companions |
| `.cursor/rules/02_repository-structure.mdc` | Repository layout and naming |
| `.cursor/rules/03_quality-assurance.mdc` | QA checklists for `src/` and notebooks |
| `.cursor/rules/04_markdown-standards.mdc` | Markdown structure for authored `.md` |
| `.cursor/rules/05_primary-directives.mdc` | Primary project directives |
| `.cursor/rules/06_source_material_rules.mdc` | `source-material/` — never named in public docs |
| `.cursor/rules/07_file-naming-conventions.mdc` | Layer-aware prefixes (`01`–`99`), term map under `src/`, week topic index |
| `.cursor/rules/08_copilot-instructions-extract.mdc` | Condensed Copilot guardrails |
| `.cursor/skills.md` | Bundled skills pointer |
| `.github/skills/` | Canonical agent skills; mirrored at `.cursor/skills/` |
| `.cursor/agents/` | Cursor custom subagents; mirrored at `.github/agents/` |
| `docs/agent-subagents.md` | Subagent index; how `CLAUDE.md` relates to skills and agents |
| `.github/workflows/ci-skills-parity.yml` | Skills mirror parity on GitHub Actions |
| `.github/workflows/ci-agent-docs-guard.yml` | Validates rules, `CLAUDE.md` references, skills and agents mirrors |
