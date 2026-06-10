---
name: docs-verification
description: Verify FermentFlow markdown structure, architecture doc consistency, ubiquitous language alignment, and broken links. Use when auditing docs or cross-references.
---

# Docs Verification — FermentFlow

## Protocol

1. Read `.github/copilot-instructions.md` and `docs/01-overview/01-project-overview.md`.
2. Compare tree to `docs/01_repository-structure.md` and `README.md`.
3. Verify ubiquitous language in code comments and docs matches `docs/01-overview/04-ubiquitous-language.md`.
4. Confirm branch evolution docs match `docs/01-overview/03-architecture-evolution.md`.
5. Check internal markdown links resolve (run **ci-checks** Lychee step or `Validate-FileReferences.ps1`).
6. Spot-check Mermaid diagrams have ASCII fallbacks where used.
7. Run markdownlint per **ci-checks** skill.

## Key docs

| Doc | Validates |
|-----|-----------|
| `01-project-overview.md` | Stack, branches, endpoints |
| `02-business-domain.md` | Domain flows |
| `03-architecture-evolution.md` | Branch patterns |
| `04-ubiquitous-language.md` | Term consistency |
| `06-running-locally.md` | Run instructions |
| `07-fermentflow-modernization-vision.md` | Future direction |

## Output

Critical / Major / Minor findings; link check summary; terminology mismatches.
