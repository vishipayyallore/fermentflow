# Agent subagents

Cursor custom subagents live under `.cursor/agents/` (mirrored at `.github/agents/`).

## Bundled subagents

| Subagent | Purpose | Invoke |
|----------|---------|--------|
| `fermentflow-ci-verify` | Run CI-aligned dotnet + markdownlint checks | "use fermentflow-ci-verify" or `/fermentflow-ci-verify` |
| `fermentflow-architecture-review` | Audit architecture docs and DDD alignment | "use fermentflow-architecture-review" |
| `docs-originality-review` | Spot-check docs for clarity, Swamy-only framing, unattributed copying | "use docs-originality-review" |

## Mirror parity

`.github/agents/` ↔ `.cursor/agents/` must stay byte-identical. `ci-agent-docs-guard.yml` validates on push.

## When to use subagents

- **CI verify** — after substantive edits to `src/` or CI config
- **Architecture review** — when changing bounded contexts, integration events, or overview docs
- **Docs originality** — when rewriting substantive content under `docs/` or ADRs

Subagents run with fresh context and are read-only unless the parent task explicitly requests fixes.

## Related

- `docs/agent-skills.md` — SKILL.md playbooks
- `CLAUDE.md` — entry point
