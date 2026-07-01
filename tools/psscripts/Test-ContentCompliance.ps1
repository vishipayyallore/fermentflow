[CmdletBinding()]
param(
    [Parameter()]
    [string]$RepoRoot = $(if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path } else { (Get-Location).Path }),

    [Parameter()]
    [switch]$IncludeSourceMaterial
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-RepoConfig {
    param([string]$RepoRootPath)

    $configPath = Join-Path $RepoRootPath 'tools\psscripts\RepoConfig.psd1'
    if (Test-Path -LiteralPath $configPath) {
        return Import-PowerShellDataFile -Path $configPath
    }

    # Safe defaults if config is missing
    return @{
        RepoName = (Split-Path -Leaf $RepoRootPath)
        DisallowInterviewLanguage = $false
    }
}

function Write-ComplianceError {
    param([string]$Message)
    Write-Host "ERROR: $Message" -ForegroundColor Red
}

function Get-TrackedTextFiles {
    param([string]$Root)

    $include = @('*.md', '*.mdc', '*.yml', '*.yaml')

    $paths = foreach ($pattern in $include) {
        Get-ChildItem -Path $Root -Recurse -File -Filter $pattern -Force -ErrorAction SilentlyContinue
    }

    $paths |
        Where-Object {
            $_.FullName -notmatch '\\.git\\' -and
            $_.FullName -notmatch '\\node_modules\\' -and
            $_.FullName -notmatch '\\docs\\review-reports\\' -and
            ($IncludeSourceMaterial -or $_.FullName -notmatch '\\source-material\\')
        } |
        Sort-Object -Property FullName -Unique
}

function Get-FirstNonEmptyLine {
    param([string[]]$Lines)
    foreach ($line in $Lines) {
        if ($null -ne $line -and $line.Trim().Length -gt 0) {
            # Allow leading HTML comments (often used for markdownlint directives)
            if ($line.Trim().StartsWith('<!--')) {
                continue
            }
            return $line
        }
    }
    return $null
}

function Get-FirstNonEmptyContentLine {
    param([string[]]$Lines)

    if ($Lines.Count -gt 0 -and $Lines[0].Trim() -eq '---') {
        # Skip YAML frontmatter block
        for ($i = 1; $i -lt $Lines.Count; $i++) {
            if ($Lines[$i].Trim() -eq '---') {
                # Return first non-empty line after frontmatter
                for ($j = $i + 1; $j -lt $Lines.Count; $j++) {
                    if ($null -ne $Lines[$j] -and $Lines[$j].Trim().Length -gt 0) {
                        return $Lines[$j]
                    }
                }
                return $null
            }
        }
        return $null
    }

    return Get-FirstNonEmptyLine -Lines $Lines
}

$repoRootPath = (Resolve-Path $RepoRoot).Path
Write-Host "Running content compliance checks in: $repoRootPath"

$repoConfig = Get-RepoConfig -RepoRootPath $repoRootPath
$disallowInterview = [bool]$repoConfig.DisallowInterviewLanguage

$failed = $false

# Rule: No 00- / 00_ prefix on learning artifacts
$allowed00Rule = Join-Path $repoRootPath '.cursor\rules\swamy_personal_learning_only.mdc'
$scanRoots = @(
    (Join-Path $repoRootPath 'src')
) | Where-Object { Test-Path -LiteralPath $_ }

$bad00 = foreach ($root in $scanRoots) {
    Get-ChildItem -Path $root -Recurse -Force -ErrorAction SilentlyContinue |
        Where-Object {
            ($_.Name -match '^00[-_]') -and ($_.FullName -ne $allowed00Rule)
        }
}
if ($bad00) {
    $failed = $true
    Write-ComplianceError "Found disallowed '00-' or '00_' file/folder prefix under src/ (topic numbering starts at 01)."
    $bad00 | ForEach-Object { Write-Host "  - $($_.FullName)" }
}

# Rule: Avoid interview language (repo-specific)
if ($disallowInterview) {
    $textFiles = Get-TrackedTextFiles -Root $repoRootPath
    $interviewHits = @()
    foreach ($file in $textFiles) {
        $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction Stop
        if ($content -match '(?i)\binterview(s)?\b') {
            $interviewHits += $file.FullName
        }
    }
    if ($interviewHits.Count -gt 0) {
        $failed = $true
        Write-ComplianceError "Found disallowed interview-language occurrences (use senior technical evaluation contexts framing)."
        $interviewHits | Sort-Object -Unique | ForEach-Object { Write-Host "  - $_" }
    }
}

# Rule: All src markdown files start with an H1
$srcPath = Join-Path $repoRootPath 'src'
if (Test-Path -LiteralPath $srcPath) {
    $srcMarkdown = Get-ChildItem -Path $srcPath -Recurse -File -Filter '*.md' -ErrorAction SilentlyContinue |
        Where-Object {
            $_.FullName -notmatch '\\.git\\' -and
            $_.FullName -notmatch '\\node_modules\\' -and
            $_.FullName -notmatch '\\\.venv\\' -and
            $_.FullName -notmatch '\\dist\\' -and
            $_.FullName -notmatch '\\__pycache__\\'
        }
    foreach ($file in $srcMarkdown) {
        $lines = Get-Content -LiteralPath $file.FullName -ErrorAction Stop
        $first = Get-FirstNonEmptyContentLine -Lines $lines
        if ($null -eq $first -or $first -notmatch '^#\s+\S') {
            $failed = $true
            Write-ComplianceError "File must start with an H1 heading: $($file.FullName)"
        }
    }
}



if ($failed) {
    Write-Host "\nContent compliance: FAILED" -ForegroundColor Red
    throw "Content compliance failed."
}

Write-Host "\nContent compliance: PASSED" -ForegroundColor Green
return
