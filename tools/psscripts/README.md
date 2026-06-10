# PowerShell Scripts

**Location**: `tools/psscripts/`

**Purpose**: Automation scripts for validation and repository maintenance (Windows + PowerShell).

---

## Script set

### Health check and validation

#### `RepoConfig.psd1`

Per-repo settings consumed by shared scripts.

#### `Quick-HealthCheck.ps1`

Fast workspace health check. Reads expected folders from `RepoConfig.psd1`.

```powershell
.\tools\psscripts\Quick-HealthCheck.ps1
```

#### `Validate-FileReferences.ps1`

Validates markdown file references point to existing files.

```powershell
.\tools\psscripts\Validate-FileReferences.ps1
.\tools\psscripts\Validate-FileReferences.ps1 -Path "docs"
```

### Linting and link checking

#### `Run-MarkdownLintAndLychee.ps1`

Runs Markdown lint (`markdownlint-cli2`) and link checking (Lychee) using repo `lychee.toml`.

```powershell
.\tools\psscripts\Run-MarkdownLintAndLychee.ps1
.\tools\psscripts\Run-MarkdownLintAndLychee.ps1 -MarkdownOnly
.\tools\psscripts\Run-MarkdownLintAndLychee.ps1 -LycheeOnly
```

### Repo stats and utilities

- `Get-RepoStats.ps1`
- `Get-FileStats.ps1`
- `Get-MarkdownSummary.ps1`
- `Compare-DocFiles.ps1`
- `Find-DuplicateContent.ps1`
- `Run-AllPSScripts.ps1`

### Diagram management

#### `Export-Diagrams.ps1`

Exports Mermaid diagram source files (`.mmd`) to PNG.

Requires: `npm install -g @mermaid-js/mermaid-cli`

---

## Quick start

```powershell
.\tools\psscripts\Quick-HealthCheck.ps1
.\tools\psscripts\Validate-FileReferences.ps1
.\tools\psscripts\Run-MarkdownLintAndLychee.ps1
```

---

## Related documentation

- [Repository structure](../../docs/01_repository-structure.md)
- [Quality assurance](../../.cursor/rules/03_quality-assurance.mdc)
- [CI checks skill](../../.github/skills/ci-checks/SKILL.md)
