[
CmdletBinding()
]
param(
    [Parameter()]
    [string]$RepoRoot = "",

    [Parameter()]
    [string]$Path = "",

    [Parameter()]
    [switch]$IncludeSourceMaterial
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $scriptRoot = if ([string]::IsNullOrWhiteSpace($PSScriptRoot)) {
        Split-Path -Parent $MyInvocation.MyCommand.Path
    } else {
        $PSScriptRoot
    }
    $RepoRoot = (Resolve-Path (Join-Path $scriptRoot "..\..")).Path
}

function Write-ValidationError {
    param([string]$Message)
    Write-Host "ERROR: $Message" -ForegroundColor Red
}

function Write-ValidationWarning {
    param([string]$Message)
    Write-Host "WARNING: $Message" -ForegroundColor Yellow
}

function Get-TrackedMarkdownFiles {
    param([string]$Root)

    $paths = Get-ChildItem -Path $Root -Recurse -File -Filter "*.md" -Force -ErrorAction SilentlyContinue |
        Where-Object {
            $_.FullName -notmatch '\\.git\\' -and
            $_.FullName -notmatch '\\.archive\\' -and
            $_.FullName -notmatch '\\.github\\workitems\\' -and
            $_.FullName -notmatch '\\node_modules\\' -and
            $_.FullName -notmatch '\\docs\\review-reports\\' -and
            ($IncludeSourceMaterial -or $_.FullName -notmatch '\\source-material\\')
        } |
        Sort-Object -Property FullName -Unique

    return $paths
}

function Get-MarkdownFilesForScope {
    param([string]$ScopePath)

    if ((Test-Path -LiteralPath $ScopePath -PathType Leaf) -and $ScopePath -match '\.md$') {
        return @(Get-Item -LiteralPath $ScopePath)
    }

    return Get-TrackedMarkdownFiles -Root $ScopePath
}

function Get-YamlFrontmatter {
    param([string[]]$Lines)

    $inFrontmatter = $false
    $frontmatterLines = @()
    $lineIndex = 0

    foreach ($line in $Lines) {
        if ($lineIndex -eq 0 -and $line -match '^---\s*$') {
            $inFrontmatter = $true
            $lineIndex++
            continue
        }

        if ($inFrontmatter) {
            if ($line -match '^---\s*$') {
                break
            }
            $frontmatterLines += $line
        }

        $lineIndex++
    }

    return $frontmatterLines -join "`n"
}

function Parse-YamlReferences {
    param([string]$YamlContent, [string]$FilePath)

    $references = @()

    # Note: 'related_topics' is a mapping and should NOT be treated as a direct reference value.
    # We scan for reference-like keys wherever they appear in the frontmatter.
    $referenceKeys = @('prerequisites', 'builds_upon', 'enables', 'cross_refs')

    foreach ($key in $referenceKeys) {
        $pattern = "(?m)^\s*$key\s*:\s*(.+?)\s*$"
        $keyMatches = [regex]::Matches($YamlContent, $pattern)
        foreach ($keyMatch in $keyMatches) {
            $value = $keyMatch.Groups[1].Value.Trim()
            if ([string]::IsNullOrWhiteSpace($value) -or $value -eq '[]') { continue }
            # Handle array format: - file.md or [file1.md, file2.md]
            if ($value -match '^\[(.*)\]$') {
                if ([string]::IsNullOrWhiteSpace($matches[1])) { continue }
                $items = $matches[1] -split ',' | ForEach-Object { ($_.Trim() -replace '^[''"]|[''"]$', '') }
                foreach ($item in $items) {
                    if (-not [string]::IsNullOrWhiteSpace($item)) {
                        if ($item -notmatch '(?i)\.md($|[?#])') { continue }
                        $references += [PSCustomObject]@{
                            Type = 'yaml'
                            Key = $key
                            Target = $item
                            File = $FilePath
                        }
                    }
                }
            } elseif ($value -match '^-\s*(.+)$') {
                $item = ($matches[1].Trim() -replace '^[''"]|[''"]$', '')
                if (-not [string]::IsNullOrWhiteSpace($item)) {
                    if ($item -notmatch '(?i)\.md($|[?#])') { continue }
                    $references += [PSCustomObject]@{
                        Type = 'yaml'
                        Key = $key
                        Target = $item
                        File = $FilePath
                    }
                }
            } else {
                $item = ($value.Trim() -replace '^[''"]|[''"]$', '')
                if (-not [string]::IsNullOrWhiteSpace($item)) {
                    if ($item -notmatch '(?i)\.md($|[?#])') { continue }
                    $references += [PSCustomObject]@{
                        Type = 'yaml'
                        Key = $key
                        Target = $item
                        File = $FilePath
                    }
                }
            }
        }
    }

    return $references
}

function Parse-MarkdownLinks {
    param([string[]]$Lines, [string]$FilePath)

    $references = @()
    $linkRegex = [regex]'\[([^\]]+)\]\(([^\)]+)\)'

    $inFence = $false
    $fenceMarker = $null

    for ($i = 0; $i -lt $Lines.Count; $i++) {
        $line = $Lines[$i]

        # Ignore links inside fenced code blocks (``` or ~~~). Templates frequently contain example links.
        if ($line -match '^\s*(```|~~~)') {
            if (-not $inFence) {
                $inFence = $true
                $fenceMarker = $matches[1]
            } elseif ($matches[1] -eq $fenceMarker) {
                $inFence = $false
                $fenceMarker = $null
            }
            continue
        }
        if ($inFence) { continue }

        foreach ($match in $linkRegex.Matches($line)) {
            $target = $match.Groups[2].Value.Trim()
            if ([string]::IsNullOrWhiteSpace($target)) { continue }
            if ($target.StartsWith('#')) { continue } # Anchor link
            if ($target -match '^(https?://|mailto:|tel:)') { continue } # External link
            if ($target -match '^<.*>$') { continue } # Auto-link

            $targetNoAnchor = $target.Split('#')[0]
            $targetNoQuery = $targetNoAnchor.Split('?')[0]
            if ([string]::IsNullOrWhiteSpace($targetNoQuery)) { continue }

            # Skip image files
            if ($targetNoQuery -match '\.(png|jpg|jpeg|gif|svg|webp)$') { continue }

            $references += [PSCustomObject]@{
                Type = 'markdown'
                Key = 'link'
                Target = $targetNoQuery
                File = $FilePath
                Line = $i + 1
            }
        }
    }

    return $references
}

function Resolve-FileReference {
    param(
        [string]$ReferencePath,
        [string]$SourceFile
    )

    $sourceDir = Split-Path -Path $SourceFile -Parent
    $resolved = Join-Path -Path $sourceDir -ChildPath $ReferencePath
    $resolved = [System.IO.Path]::GetFullPath($resolved)

    return $resolved
}

$repoRootPath = (Resolve-Path $RepoRoot).Path
$scanRootPath = if ([string]::IsNullOrWhiteSpace($Path)) {
    $repoRootPath
} else {
    (Resolve-Path (Join-Path $repoRootPath $Path)).Path
}

Write-Host "Validating file references in: $scanRootPath" -ForegroundColor Cyan
Write-Host ""

$mdFiles = @(Get-MarkdownFilesForScope -ScopePath $scanRootPath)
Write-Host "Found $($mdFiles.Count) markdown files to check" -ForegroundColor Cyan
Write-Host ""

$allReferences = @()
$errors = @()

foreach ($file in $mdFiles) {
    try {
        $lines = Get-Content -LiteralPath $file.FullName -ErrorAction Stop

        # Parse YAML frontmatter
        $yamlContent = Get-YamlFrontmatter -Lines $lines
        if ($yamlContent) {
            $yamlRefs = Parse-YamlReferences -YamlContent $yamlContent -FilePath $file.FullName
            $allReferences += $yamlRefs
        }

        # Parse markdown links
        $mdRefs = Parse-MarkdownLinks -Lines $lines -FilePath $file.FullName
        $allReferences += $mdRefs
    }
    catch {
        Write-ValidationWarning "Failed to read file: $($file.FullName) - $($_.Exception.Message)"
    }
}

Write-Host "Checking $($allReferences.Count) file references..." -ForegroundColor Cyan
Write-Host ""

foreach ($ref in $allReferences) {
    $resolved = Resolve-FileReference -ReferencePath $ref.Target -SourceFile $ref.File

    if (-not (Test-Path -LiteralPath $resolved)) {
        $relativePath = $ref.File.Replace($repoRootPath, '').TrimStart('\\')
        $lineProp = $ref.PSObject.Properties['Line']
        $lineInfo = if ($lineProp -and $lineProp.Value) { " (line $($lineProp.Value))" } else { "" }
        $errors += "  - $relativePath$lineInfo : References '$($ref.Target)' (resolved: $resolved)"
    }
}

# Summary
Write-Host "=" * 60 -ForegroundColor Cyan
if ($errors.Count -eq 0) {
    Write-Host "SUCCESS: All file references are valid" -ForegroundColor Green
    Write-Host ""
    return
} else {
    Write-Host "FAILED: Found $($errors.Count) broken file reference(s)" -ForegroundColor Red
    Write-Host ""
    foreach ($validationError in $errors) {
        Write-ValidationError $validationError
    }
    Write-Host ""
    throw "Found broken file references."
}

