<#
.SYNOPSIS
  Runs Markdown lint (markdownlint-cli2) and Lychee link checking for the repository.

.DESCRIPTION
  - Markdown lint: Uses `npx markdownlint-cli2` over README/docs/src/tools by default.
  - Lychee: Uses the repository `lychee.toml` configuration.

  This script intentionally excludes `source-material/` by default (it is a staging area).

.PARAMETER IncludeSourceMaterials
  If set, include `source-material/` in markdown linting.

.PARAMETER MarkdownGlobs
  Optional override for markdownlint-cli2 globs.

.PARAMETER LycheeArgs
  Optional extra arguments passed through to lychee.

.EXAMPLE
  .\tools\psscripts\Run-MarkdownLintAndLychee.ps1

.EXAMPLE
  .\tools\psscripts\Run-MarkdownLintAndLychee.ps1 -IncludeSourceMaterials
#>

[CmdletBinding()]
param(
  [switch]$IncludeSourceMaterials,
  [switch]$MarkdownOnly,
  [switch]$LycheeOnly,
  [switch]$SkipMarkdownLint,
  [switch]$SkipLychee,
  [string[]]$MarkdownGlobs,
  [string[]]$LycheeArgs
)

$ErrorActionPreference = 'Stop'

function Assert-CommandExists {
  param([Parameter(Mandatory)][string]$Name)
  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    throw "Required command not found on PATH: $Name"
  }
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\.." )).Path
Set-Location $repoRoot

Write-Host "=== Markdown + Link Validation ===" -ForegroundColor Cyan
Write-Host "Repo: $repoRoot" -ForegroundColor Gray
Write-Host "" 

if ($MarkdownOnly -and $LycheeOnly) {
  throw "Only one of -MarkdownOnly or -LycheeOnly can be specified."
}

if ($MarkdownOnly) {
  $SkipLychee = $true
}

if ($LycheeOnly) {
  $SkipMarkdownLint = $true
}

# ----------------------
# Markdown lint
# ----------------------

$mdExitCode = 0
if (-not $SkipMarkdownLint) {
  Write-Host "==> Running markdownlint-cli2" -ForegroundColor Yellow
  Assert-CommandExists -Name "node"
  Assert-CommandExists -Name "npx"

  if (-not $MarkdownGlobs -or $MarkdownGlobs.Count -eq 0) {
    $MarkdownGlobs = @(
      "README.md",
      "docs/**/*.md",
      "src/**/*.md",
      "tools/**/*.md"
    )

    if ($IncludeSourceMaterials) {
      # Support both legacy and current folder names.
      if (Test-Path (Join-Path $repoRoot 'source-material')) {
        $MarkdownGlobs += "source-material/**/*.md"
      }
      if (Test-Path (Join-Path $repoRoot 'source-materials')) {
        $MarkdownGlobs += "source-materials/**/*.md"
      }
    }
  }

  # markdownlint-cli2 treats arguments as globs. We'll install/run it via npx.
  # NOTE: We do not auto-fix; this is a reporting/validation script.
  try {
    & npx --yes markdownlint-cli2 @MarkdownGlobs
    $mdExitCode = $LASTEXITCODE
  } catch {
    $mdExitCode = 1
    Write-Host $_ -ForegroundColor Red
  }

  if ($mdExitCode -ne 0) {
    Write-Host "markdownlint: FAILED (exit $mdExitCode)" -ForegroundColor Red
  } else {
    Write-Host "markdownlint: PASSED" -ForegroundColor Green
  }

  Write-Host "" 
} else {
  Write-Host "==> Skipping markdownlint-cli2" -ForegroundColor DarkGray
  Write-Host "" 
}

# ----------------------
# Lychee
# ----------------------

$lycheeExitCode = 0
if (-not $SkipLychee) {
  Write-Host "==> Running lychee" -ForegroundColor Yellow

  $lycheeConfigPath = Join-Path $repoRoot "lychee.toml"
  if (-not (Test-Path $lycheeConfigPath)) {
    throw "Missing lychee config: $lycheeConfigPath"
  }

  # Prefer local lychee if installed; otherwise fall back to docker.
  if (Get-Command "lychee" -ErrorAction SilentlyContinue) {
    & lychee --config $lycheeConfigPath @LycheeArgs $repoRoot
    $lycheeExitCode = $LASTEXITCODE
  } else {
    # Prefer Docker CLI if available; otherwise use Podman.
    $containerCmd = $null
    if (Get-Command "docker" -ErrorAction SilentlyContinue) {
      $containerCmd = "docker"
    } elseif (Get-Command "podman" -ErrorAction SilentlyContinue) {
      $containerCmd = "podman"
    }

    if (-not $containerCmd) {
      throw "Neither 'lychee' nor a container runtime ('docker' or 'podman') was found on PATH. Install lychee or Docker/Podman to run link checks."
    }

    # Mount repo into /workspace and run lychee against that folder.
    & $containerCmd run --rm -v "${repoRoot}:/workspace" lycheeverse/lychee --config /workspace/lychee.toml @LycheeArgs /workspace
    $lycheeExitCode = $LASTEXITCODE
  }

  if ($lycheeExitCode -ne 0) {
    Write-Host "lychee: FAILED (exit $lycheeExitCode)" -ForegroundColor Red
  } else {
    Write-Host "lychee: PASSED" -ForegroundColor Green
  }

  Write-Host "" 
} else {
  Write-Host "==> Skipping lychee" -ForegroundColor DarkGray
  Write-Host "" 
}

if ($mdExitCode -ne 0 -or $lycheeExitCode -ne 0) {
  Write-Host "Overall: ISSUES FOUND" -ForegroundColor Yellow
  throw "Markdown/Lychee validation failed."
}

Write-Host "Overall: PASSED" -ForegroundColor Green
return
