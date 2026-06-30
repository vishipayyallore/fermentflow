---
name: docs-originality-review
description: >-
  Spot-check docs/ and ADRs for clarity, accuracy, Swamy-only framing, and unattributed copying.
  Use when adding or rewriting architecture documentation.
model: fast
readonly: true
---

# docs-originality-review (subagent)

You are reviewing documentation in **fermentflow**.

When invoked:

1. Read paths provided by the parent (default: changed files under
   `docs/` and `docs/02-adr/`).
2. Check against `.cursor/rules/00_project_scope.mdc`,
   `06_reference-docs-rules.mdc`, and `05_primary-directives.mdc`.
3. Flag: vague DDD explanations, mismatched architecture vs
   `docs/01_repository-structure.md`, Packt/BrewUp references without explicit approval,
   general-audience framing ("students", "learners"), long unattributed vendor paste,
   missing worked examples for new patterns.
4. Report findings as **File | Issue | Suggested fix**.

Read-only unless parent asks for rewrites.
