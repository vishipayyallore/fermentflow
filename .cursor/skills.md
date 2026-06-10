# Repository skills (FermentFlow)

This file is **local to `fermentflow`**. It complements `.cursor/rules/*.mdc` and `.github/copilot-instructions.md` with concise guidance for assistants editing this repo.

**Bundled agent skills:** `.github/skills/` is canonical; `.cursor/skills/` is a **byte-identical mirror** (see `.github/skills/README.md`). Bundles: **`fermentflow-foundations`**, **`ci-checks`**, **`docs-verification`**, **`workspace-review`**, **`e2e-testing`**. Pushes under skills paths run **`.github/workflows/ci-skills-parity.yml`**; agent-facing path changes also run **`.github/workflows/ci-agent-docs-guard.yml`**.

**Governance integrity:** Commit or stash before another tool touches copilot, rules, skills, agents, or `CLAUDE.md`; keep mirrors in one change; prefer small diffs. Recovery: **`docs/agent-governance-recovery.md`**.

**Subagents:** **`fermentflow-ci-verify`** (CI-aligned checks), **`fermentflow-architecture-review`** (architecture docs and DDD alignment).

---

## Project layout

| Path | Purpose |
|------|---------|
| `docs/01-overview/` | Architecture, domain, evolution |
| `docker/` | Local infrastructure |
| `src/` | Application source (branch-dependent) |
| `tools/psscripts/` | Maintenance scripts |

Branch evolution is the primary learning axis — see `docs/01-overview/03-architecture-evolution.md`.

---

## Tools (maintenance)

- **Index:** `tools/README.md` → `psscripts/README.md`
- **Markdown / links:** `.github/skills/ci-checks/SKILL.md`; **Lychee** via Docker or `.\tools\psscripts\Run-MarkdownLintAndLychee.ps1`
- **File references:** `tools/psscripts/Validate-FileReferences.ps1`
- **Health check:** `tools/psscripts/Quick-HealthCheck.ps1`

---

## CI expectations

- **.NET:** `dotnet build`, `dotnet test` — `ci-dotnet.yml`
- **Docs:** Markdown lint and Lychee — `ci-documentation.yml`
- **Parity / guard:** `.github/skills/` ↔ `.cursor/skills/`; `.github/agents/` ↔ `.cursor/agents/`; **`ci-agent-docs-guard.yml`**

Use the **`ci-checks`** skill for exact local commands.
