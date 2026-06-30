# Agent skills

FermentFlow uses the **SKILL.md** pattern for on-demand agent procedures.

## Layout

- **Canonical:** `.github/skills/<name>/SKILL.md`
- **Mirror:** `.cursor/skills/<name>/SKILL.md` (byte-identical)

## Bundled skills

| Skill | Purpose |
|-------|---------|
| `fermentflow-foundations` | DDD workspace layout, branch evolution, domain rules |
| `ci-checks` | Local dotnet build/test + markdownlint (+ optional Lychee) |
| `docs-verification` | Architecture doc consistency and link checks |
| `workspace-review` | Comprehensive repo review |
| `e2e-testing` | Docker + build/test smoke verification |

## Progressive disclosure

Skills use YAML frontmatter (`name`, `description`) so agents match tasks without loading full playbooks upfront. Universal behaviour lives in `.github/copilot-instructions.md` and `.cursor/rules/`.

## Parity

Changes to either skills tree must update both in the same commit. `ci-skills-parity.yml` validates on push.

## Related

- `.cursor/skills.md` — quick index
- `docs/agent-subagents.md` — delegated subagents (`fermentflow-ci-verify`, `fermentflow-architecture-review`, `docs-originality-review`)
- `CLAUDE.md` — entry point table
