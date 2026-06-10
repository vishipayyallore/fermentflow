# Workitem 08 — Validation Review After Fixes

## Purpose

Run a focused validation pass after content, governance, or tooling fixes.

## Scope

- Check active `src/weekN/` bundles.
- Check modified governance files.
- Check mirrored skills and agents when either mirror changes.
- Leave preserved archive folders unchanged.

## Required Checks

- `uv sync`
- isort, black, and flake8 on `src/`
- notebook JSON parse for `src/**/*.ipynb`
- markdownlint on README, docs, src, and tools
- Lychee link check when link-sensitive files changed
- `.\tools\psscripts\Quick-HealthCheck.ps1`
- `.\tools\psscripts\Validate-FileReferences.ps1`

## Acceptance Criteria

- Checks are reported as PASS, FAIL, or Not Applicable.
- Any Windows `uv run` fallback is documented.
- Remaining issues include concrete file paths and next actions.
