# Convert all PDF and HTML files under source-material/ to Markdown in the same folder as each source file.
# Requires: uv sync (pypdf), run from repo root.
# Usage (from repo root): .\tools\psscripts\Convert-SourceMaterialPdfsToMarkdown.ps1

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Push-Location $repoRoot

try {
    uv run python tools/pyscripts/pdf_to_md.py --input "source-material" --recursive --output-same-folder --allow-source-material-output
    uv run python tools/pyscripts/html_to_md.py --input "source-material" --recursive --output-same-folder --allow-source-material-output
} finally {
    Pop-Location
}
