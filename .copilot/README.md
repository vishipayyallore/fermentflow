# GitHub Copilot — fermentflow

Copilot uses **`.github/copilot-instructions.md`** as the primary instruction file for this repository.

## CI workflows

| Workflow | Scope |
| -------- | ----- |
| `ci-dotnet.yml` | .NET build and test |
| `ci-documentation.yml` | markdownlint (+ Lychee when configured) |
| `ci-skills-parity.yml` | `.github/skills/` ↔ `.cursor/skills/` byte parity |
| `ci-agent-docs-guard.yml` | Governance files and agent mirrors |

Local commands: `.github/skills/ci-checks/SKILL.md`.

See also `CLAUDE.md` and `.cursor/skills.md`.
