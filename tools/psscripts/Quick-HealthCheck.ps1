<#
.SYNOPSIS
    Quick workspace health check (repo-aware via RepoConfig.psd1).

.DESCRIPTION
    Consistent, fast health check across repositories:
    - Validates expected folder structure from tools/psscripts/RepoConfig.psd1
    - Counts markdown files
    - Reports YAML frontmatter presence and 150-line guideline as warnings

    Exit code:
    - 0 if expected folders exist
    - 1 if any expected folder is missing

.PARAMETER Path
    Optional subpath (relative to repo root) to limit markdown counting/YAML checks.

.EXAMPLE
    .\tools\psscripts\Quick-HealthCheck.ps1

.EXAMPLE
    .\tools\psscripts\Quick-HealthCheck.ps1 -Path "src"
#>

[CmdletBinding()]
param(
    [string]$Path = "."
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\.." )).Path
$configPath = Join-Path $repoRoot "tools\psscripts\RepoConfig.psd1"
if (-not (Test-Path -LiteralPath $configPath)) {
    throw "Missing repo config: $configPath"
}

$config = Import-PowerShellDataFile -Path $configPath
$repoName = if ($config.ContainsKey('RepoName') -and $config['RepoName']) {
    $config['RepoName']
} else {
    (Split-Path -Leaf $repoRoot)
}

$scanRoot = if ($Path -eq ".") {
    $repoRoot
} else {
    $resolved = Resolve-Path -LiteralPath (Join-Path $repoRoot $Path) -ErrorAction SilentlyContinue
    if ($resolved) { $resolved.Path } else { $repoRoot }
}

Write-Host "=== Quick Health Check ===" -ForegroundColor Cyan
Write-Host "Repo: $repoName" -ForegroundColor Gray
Write-Host "Root: $repoRoot" -ForegroundColor Gray
Write-Host "Scan: $scanRoot" -ForegroundColor Gray
Write-Host ""

Write-Host "📁 Folder Structure:" -ForegroundColor Yellow
$expectedFolders = if ($config.ContainsKey('ExpectedFolders')) { @($config['ExpectedFolders']) } else { @() }
if (-not $expectedFolders -or @($expectedFolders).Count -eq 0) {
    throw "RepoConfig.psd1 must define ExpectedFolders"
}

$structureOk = $true
foreach ($folder in $expectedFolders) {
    $fullPath = Join-Path $repoRoot $folder
    if (Test-Path -LiteralPath $fullPath) {
        Write-Host "  ✅ $folder" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $folder - MISSING" -ForegroundColor Red
        $structureOk = $false
    }
}

Write-Host ""

Write-Host "📄 Markdown Files:" -ForegroundColor Yellow
$mdFiles = @(Get-ChildItem -Path $scanRoot -Recurse -Filter '*.md' -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch 'node_modules|\\.git' })

Write-Host "  Total: $(@($mdFiles).Count) files" -ForegroundColor Cyan
$byDir = $mdFiles | Group-Object DirectoryName | Sort-Object Count -Descending | Select-Object -First 5
foreach ($dir in $byDir) {
    $relPath = $dir.Name.Replace($repoRoot, '').TrimStart('\\')
    Write-Host "  - $relPath`: $($dir.Count) files" -ForegroundColor Gray
}

Write-Host ""

Write-Host "📋 YAML + Line-Length (Warnings):" -ForegroundColor Yellow
$yamlCheckRoots = if ($config.ContainsKey('YamlCheckRoots')) { @($config['YamlCheckRoots']) } else { @() }
if (-not $yamlCheckRoots -or @($yamlCheckRoots).Count -eq 0) {
    $yamlCheckRoots = @('src')
}

$filesWithYaml = 0
$filesWithoutYaml = 0
$filesOverLimit = 0

$checkedFiles = @()
foreach ($rootRel in $yamlCheckRoots) {
    $rootPath = Join-Path $repoRoot $rootRel
    if (-not (Test-Path -LiteralPath $rootPath)) { continue }
    $checkedFiles += Get-ChildItem -Path $rootPath -Recurse -File -Filter '*.md' -ErrorAction SilentlyContinue
}

$checkedFiles = @($checkedFiles | Sort-Object FullName -Unique)
foreach ($file in $checkedFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction SilentlyContinue
    $lineCount = @(Get-Content -LiteralPath $file.FullName -ErrorAction SilentlyContinue).Count

    if ($content -match '^---\s*\r?\n') {
        $filesWithYaml++
    } else {
        $filesWithoutYaml++
    }

    if ($lineCount -gt 150) {
        $filesOverLimit++
    }
}

Write-Host "  ✅ Files with YAML: $filesWithYaml" -ForegroundColor Green
if ($filesWithoutYaml -gt 0) {
    Write-Host "  ⚠️  Files without YAML: $filesWithoutYaml" -ForegroundColor Yellow
}
if ($filesOverLimit -gt 0) {
    Write-Host "  ⚠️  Files over 150 lines: $filesOverLimit" -ForegroundColor Yellow
}

Write-Host ""

Write-Host "=== Summary ===" -ForegroundColor Cyan
if ($structureOk) {
    Write-Host "✅ Health Check: PASSED" -ForegroundColor Green
    return
}

Write-Host "❌ Health Check: FAILED" -ForegroundColor Red
Write-Host "  - Missing expected folders" -ForegroundColor Red
throw "Health Check failed: missing expected folders."
