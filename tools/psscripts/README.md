# PowerShell Scripts

**Location**: `tools/psscripts/`

**Purpose**: Automation scripts for validation and repository maintenance (Windows 11 + PowerShell).

---

## 📋 Script Set (Standardized)

### Health Check & Validation

#### `RepoConfig.psd1`

Per-repo settings consumed by shared scripts (keeps behavior consistent across repos while allowing repo-specific structure/policy).

---

#### `Quick-HealthCheck.ps1`

Fast workspace health check. Reads expected folders from `RepoConfig.psd1`.

**Usage:**

```powershell
.\tools\psscripts\Quick-HealthCheck.ps1
```

---

#### `Validate-FileReferences.ps1`

Validates markdown file references point to existing files.

**Usage:**

```powershell
.\tools\psscripts\Validate-FileReferences.ps1
.\tools\psscripts\Validate-FileReferences.ps1 -Path "src"
```

---

#### `Test-ContentCompliance.ps1`

Repository content-policy checks (rules vary by repo via `RepoConfig.psd1`).

**Usage:**

```powershell
.\tools\psscripts\Test-ContentCompliance.ps1
```

---

#### `Verify-ZeroCopy.ps1`

Zero-copy policy verification for content in `src/` (see .cursor rules and copilot-instructions for policy).

**Usage:**

```powershell
.\tools\psscripts\Verify-ZeroCopy.ps1
.\tools\psscripts\Verify-ZeroCopy.ps1 -Strict
```

---

### Linting & Link Checking

#### `Run-MarkdownLintAndLychee.ps1`

Runs Markdown lint (`markdownlint-cli2`) and link checking (Lychee) using repo `lychee.toml`.

**Usage:**

```powershell
.\tools\psscripts\Run-MarkdownLintAndLychee.ps1
.\tools\psscripts\Run-MarkdownLintAndLychee.ps1 -IncludeSourceMaterials
```

---

### Repo Stats / Utilities

- `Get-RepoStats.ps1`
- `Get-FileStats.ps1`
- `Get-MarkdownSummary.ps1`
- `Compare-DocFiles.ps1`
- `Find-DuplicateContent.ps1`

---

### Diagram Management

#### `Export-Diagrams.ps1`

Exports all Mermaid diagram source files (`.mmd`) to PNG format with consistent configuration.

**Usage:**

```powershell
# Export all diagrams with default settings
.\tools\psscripts\Export-Diagrams.ps1

# Custom path and settings
.\tools\psscripts\Export-Diagrams.ps1 -DiagramsPath "docs\diagrams" -Width 2560 -BackgroundColor "white" -Scale 2

# Export and automatically stage PNG files for git
.\tools\psscripts\Export-Diagrams.ps1 -StageForGit
```

**Parameters:**

- `-DiagramsPath`: Path to diagrams directory (default: `docs\diagrams`)
- `-Width`: PNG width in pixels (default: 1920)
- `-BackgroundColor`: Background color (default: `white`, use `transparent` for dark mode)
- `-Scale`: Scale factor for retina displays (default: 2)
- `-StageForGit`: Automatically stage exported PNG files for git commit

**Requirements:**

- Mermaid CLI installed: `npm install -g @mermaid-js/mermaid-cli`
- Node.js installed
- Configuration file: `docs/diagrams/mermaid-config.json` (optional but recommended)

**Output:**

- Generates `.png` files alongside `.mmd` source files
- Uses high-resolution (1920px default) for professional quality
- Reports total file size and success count

---

### One-off Maintenance

#### `Convert-SourceMaterialPdfsToMarkdown.ps1`

Batch-converts **PDF**, **HTML**, and **PPTX** under `source-material/` to colocated `.md` files via `pdf_to_md.py`, `html_to_md.py`, and `pptx_to_md.py`.

```powershell
.\tools\psscripts\Convert-SourceMaterialPdfsToMarkdown.ps1
```

---

## 🚀 Quick Start

```powershell
.\tools\psscripts\Quick-HealthCheck.ps1
.\tools\psscripts\Validate-FileReferences.ps1
.\tools\psscripts\Run-MarkdownLintAndLychee.ps1

# Run checks independently
.\tools\psscripts\Run-MarkdownLintAndLychee.ps1 -MarkdownOnly
.\tools\psscripts\Run-MarkdownLintAndLychee.ps1 -LycheeOnly
```

---

## 🔗 Related Documentation

- [Project Rules](../../.cursor/rules/01_educational-content-rules.mdc)
- [Repository Structure](../../.cursor/rules/02_repository-structure.mdc)
- [Quality Assurance](../../.cursor/rules/03_quality-assurance.mdc)
