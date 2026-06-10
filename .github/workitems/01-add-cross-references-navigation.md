# Workitem 01 — Add Cross-Layer Navigation

## Purpose

Add simple navigation between the active four layers for each `src/weekN/` bundle.

## Scope

- Start with `src/week1/`.
- Future work should repeat the same pattern for each active week only.
- Leave preserved archive folders unchanged.

## Target Pattern

Each week should make it easy for Swamy to move through:

1. `src/weekN/01-notes/`
2. `src/weekN/02-quizzes/`
3. `src/weekN/03-notebooks/`
4. `src/weekN/04-discussions/`

## Acceptance Criteria

- Markdown links are relative and resolve correctly.
- Links do not mention internal-only reference folders.
- Navigation preserves Swamy's first-person learning voice.
- `npx --yes markdownlint-cli2 "README.md" "docs/**/*.md" "src/**/*.md" "tools/**/*.md"` passes.
- `.\tools\psscripts\Validate-FileReferences.ps1` passes.
