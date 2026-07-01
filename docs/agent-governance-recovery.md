# Agent governance recovery

Use this guide only when assistant governance files (`.cursor/rules/`, skills mirrors, agents mirrors, `CLAUDE.md`, `.github/copilot-instructions.md`) are corrupted or out of sync.

## Primary prevention

1. Commit or stash before bulk AI edits to governance paths
2. Update `.github/skills/` and `.cursor/skills/` in the same commit
3. Update `.github/agents/` and `.cursor/agents/` in the same commit
4. Prefer small scoped diffs
5. Run local parity checks before push

## Local parity check

```powershell
# Skills
Get-ChildItem -Recurse .github\skills -Filter SKILL.md | ForEach-Object {
  $rel = $_.FullName.Replace((Resolve-Path .github\skills).Path + '\', '')
  $cursor = Join-Path .cursor\skills $rel
  if (-not (Test-Path $cursor)) { Write-Host "MISSING: $rel" }
  elseif ((Get-FileHash $_.FullName).Hash -ne (Get-FileHash $cursor).Hash) { Write-Host "MISMATCH: $rel" }
}

# Agents
Get-ChildItem .github\agents -Filter *.md | ForEach-Object {
  $cursor = Join-Path .cursor\agents $_.Name
  if (-not (Test-Path $cursor)) { Write-Host "MISSING agent: $($_.Name)" }
  elseif ((Get-FileHash $_.FullName).Hash -ne (Get-FileHash $cursor).Hash) { Write-Host "MISMATCH agent: $($_.Name)" }
}
```

## Git restore (secondary)

If files are damaged beyond manual repair:

```powershell
git checkout HEAD -- CLAUDE.md AGENTS.md .github/copilot-instructions.md
git checkout HEAD -- .cursor/rules/ .github/rules/ .github/skills/ .cursor/skills/ .github/agents/ .cursor/agents/
git checkout HEAD -- .cursor/skills.md
```

Adjust commit ref if restoring from a known-good tag or branch.

## CI validation

Push triggers:

- `ci-skills-parity.yml` — skills mirror
- `ci-agent-docs-guard.yml` — required files, references, agents mirror, markdown lint
