# Agent skills (canonical)

This directory is the **source of truth** for bundled agent skills used with Cursor and GitHub Copilot (see `.github/copilot-instructions.md`).

## Mirror

`.cursor/skills/` must stay **identical** to `.github/skills/` (same paths, same `SKILL.md` and `README.md` bytes). After editing here, copy the updated tree to `.cursor/skills/`.

### Verify parity (PowerShell, repo root)

```powershell
$gRoot = Join-Path (Get-Location) ".github\skills"
$cRoot = Join-Path (Get-Location) ".cursor\skills"
Get-ChildItem $gRoot -Recurse -Filter SKILL.md | ForEach-Object {
 $rel = $_.FullName.Substring($gRoot.Length + 1)
 $c = Join-Path $cRoot $rel
 if (-not (Test-Path $c)) { Write-Host "Missing in .cursor/skills: $rel"; return }
 if ((Get-FileHash $_.FullName -Algorithm SHA256).Hash -ne (Get-FileHash $c -Algorithm SHA256).Hash) {
 Write-Host "MISMATCH: $rel"
 }
}
Get-ChildItem $cRoot -Recurse -Filter SKILL.md | ForEach-Object {
 $rel = $_.FullName.Substring($cRoot.Length + 1)
 $g = Join-Path $gRoot $rel
 if (-not (Test-Path $g)) { Write-Host "Extra in .cursor/skills (not in .github): $rel" }
}
```

## Bundled skills

| Folder | Purpose |
|--------|---------|
| `ann-foundations` | Domain context for this repository |
| `topic-companions` | Four-layer topic SOP, parity, definition of done |
| `ci-checks` | Local commands aligned with `.github/workflows/ci-*.yml` |
| `docs-verification` | Markdown / four-layer bundle checks vs `docs/01_repository-structure.md` |
| `workspace-review` | Full audit checklist for this educational repo |
| `e2e-testing` | Smoke checks (env, notebook parse, optional manual run) |

**CI:** Pushes that touch skills run `.github/workflows/ci-skills-parity.yml`; agent docs changes also run `.github/workflows/ci-agent-docs-guard.yml`.
