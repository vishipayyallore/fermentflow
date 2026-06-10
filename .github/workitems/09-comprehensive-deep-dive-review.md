# Workitem 09 — Comprehensive Deep Dive Review

## Purpose

Perform a careful end-to-end review of the workspace when Swamy requests a deep audit.

## Scope

- Read active governance: `CLAUDE.md`, `.github/copilot-instructions.md`, `.cursor/rules/`, skills, and agents.
- Review active `src/weekN/` content.
- Review public docs and tools for consistency with the current week-based model.
- Treat preserved archive folders as reference-only unless Swamy explicitly asks for migration or cleanup.

## Review Questions

- Are all active week bundles complete across the four layers?
- Is public content zero-copy and written for Swamy's personal learning?
- Do docs match the current implementation?
- Are there stale references to old active folder layouts?
- Do CI and repository health checks pass?

## Acceptance Criteria

- Findings are prioritized by severity.
- CI/test applicability is explained.
- Source-material coverage is reported without treating preserved archives as automatic failures.
- Suggested follow-ups are concrete and scoped.
