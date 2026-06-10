# Repository skills (FermentFlow)

This file is **local to `fermentflow`**. It complements `.cursor/rules/*.mdc` and `.github/copilot-instructions.md`.

**Strict scope:** Swamy PKV's personal architecture laboratory only — see `README.md` **Scope (read this first)** and `.cursor/rules/00_project_scope.mdc`.

**Bundled agent skills:** `.github/skills/` is canonical; `.cursor/skills/` is a **byte-identical mirror**. Bundles: **`fermentflow-foundations`**, **`ci-checks`**, **`docs-verification`**, **`workspace-review`**, **`e2e-testing`**.

**Subagents:** **`fermentflow-ci-verify`**, **`fermentflow-architecture-review`**.

**Learning roadmap:** nine stages from legacy monolith to .NET Aspire — see `README.md`.

---

## CI expectations

- **.NET 10:** `dotnet build`, `dotnet test` — `ci-dotnet.yml`
- **Docs:** Markdown lint and Lychee — `ci-documentation.yml`
- **Parity / guard:** skills and agents mirrors; **`ci-agent-docs-guard.yml`**

Use the **`ci-checks`** skill for exact local commands.
