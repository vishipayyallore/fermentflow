---
name: docs-verification
description: Verify FermentFlow markdown structure, architecture doc consistency, ubiquitous language alignment, and broken links. Use when auditing docs or cross-references.
---

# Docs Verification — FermentFlow

## Protocol

1. Read `.github/copilot-instructions.md` and `docs/01-overview/01-project-overview.md`.
2. Compare tree to `docs/01_repository-structure.md` and `README.md`.
3. Verify ubiquitous language in code comments and docs matches `docs/01-overview/04-ubiquitous-language.md`.
4. Confirm nine-branch roadmap matches `docs/01_repository-structure.md` and `docs/01-overview/08-branch-roadmap.md` (branch 03 = CQRS + Vertical Slices).
5. Use `docs/01-overview/03-architecture-evolution.md` only for baseline import comparison.
6. Check internal markdown links resolve (run **ci-checks** Lychee step or `Validate-FileReferences.ps1`).
7. Spot-check Mermaid diagrams have ASCII fallbacks where used.
8. Run markdownlint per **ci-checks** skill.

## Key docs

| Doc | Validates |
|-----|-----------|
| `01_repository-structure.md` | Layout, roadmap, naming (SSOT) |
| `08-branch-roadmap.md` | Per-branch trees; branch 03 vertical slices |
| `01-project-overview.md` | Stack, baseline mapping, endpoints |
| `02-business-domain.md` | Domain flows |
| `03-architecture-evolution.md` | Baseline import comparison only |
| `04-ubiquitous-language.md` | Term consistency |
| `06-running-locally.md` | Run instructions |
| `07-fermentflow-modernization-vision.md` | Modernization narrative |

## Output

Critical / Major / Minor findings; link check summary; terminology mismatches.
