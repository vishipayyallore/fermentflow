---
name: e2e-testing
description: Smoke verification for Artificial Neural Networks (environment, notebook JSON, optional manual notebook run). Use when smoke-testing the workspace end-to-end.
---

# Smoke / E2E-style verification — Artificial Neural Networks

No deployed application here. "End-to-end" means **environment + parse + optional notebook execution**.

## Prerequisites

- Python 3.12+ with **`uv`** at repo root
- Optional: Jupyter — **Kernel → Restart & Run All**

## Suggested sequence

1. **Dependencies**

   ```powershell
   $Env:UV_LINK_MODE = "copy"
   uv sync
   ```

2. **Import smoke (optional)**

   ```powershell
   uv run python -c "import numpy, pandas, sklearn, scipy; print('ok')"
   ```

3. **Notebook JSON** (same as CI):

   ```powershell
   uv run python -c "import json,glob; paths=sorted(glob.glob('src/**/*.ipynb',recursive=True)); [json.load(open(p,encoding='utf-8')) for p in paths]"
   ```

4. **Manual (optional)** — open a representative notebook from `src/weekN/03-notebooks/`, run all cells.

## Summary

Report each step **PASS** / **FAIL** / **SKIPPED**.

When the failure affects teaching flow, explain it in beginner-friendly language so the next fix is obvious.
