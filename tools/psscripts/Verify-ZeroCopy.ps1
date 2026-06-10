[CmdletBinding()]
param(
    [Parameter()]
    [string]$RepoRoot = "",

    [Parameter()]
    [string[]]$AdditionalSourceFiles = @(),

    [Parameter()]
    [switch]$Strict
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $scriptRoot = if ([string]::IsNullOrWhiteSpace($PSScriptRoot)) {
        Split-Path -Parent $MyInvocation.MyCommand.Path
    } else {
        $PSScriptRoot
    }
    $RepoRoot = (Resolve-Path (Join-Path $scriptRoot "..\..") | Select-Object -First 1 -ExpandProperty Path)
}

function Write-ZeroCopyWarning {
    param([string]$Message)
    Write-Host "⚠️  ZERO-COPY WARNING: $Message" -ForegroundColor Yellow
}

function Write-ZeroCopyError {
    param([string]$Message)
    Write-Host "❌ ZERO-COPY VIOLATION: $Message" -ForegroundColor Red
}

function Write-ZeroCopySuccess {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

# Get source material files
$sourceMaterialPath = Join-Path $RepoRoot "source-material"
$sourceFiles = @()

if (Test-Path $sourceMaterialPath) {
    $sourceFiles = @(Get-ChildItem -Path $sourceMaterialPath -Filter "*.md" -Recurse -ErrorAction SilentlyContinue)
}

if ($AdditionalSourceFiles.Count -gt 0) {
    $sourceFiles += @($AdditionalSourceFiles | ForEach-Object { Get-Item $_ -ErrorAction SilentlyContinue })
}

$sourceFiles = @($sourceFiles | Where-Object { $_ })

if ($sourceFiles.Count -eq 0) {
    Write-Host "No source material files found to check against." -ForegroundColor Yellow
    Write-Host "This check requires source material files in 'source-material/' directory." -ForegroundColor Yellow
    return
}

# Get content files to check
$contentFiles = Get-ChildItem -Path (Join-Path $RepoRoot "src") -Filter "*.md" -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch '\\resources\\' }

$contentFiles = @($contentFiles)

Write-Host "Zero-Copy Policy Verification" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host ""
Write-Host "Source Material Files: $($sourceFiles.Count)" -ForegroundColor Cyan
Write-Host "Content Files to Check: $($contentFiles.Count)" -ForegroundColor Cyan
Write-Host ""

# Extract quotes and key phrases from source material
$sourceQuotes = @()
$sourcePhrases = @()

foreach ($sourceFile in $sourceFiles) {
    try {
        $content = Get-Content -LiteralPath $sourceFile.FullName -Raw -ErrorAction Stop
        if ($null -eq $content) { $content = "" }

        # Extract quoted text (lines starting with >)
        $quoteMatches = [regex]::Matches($content, '(?m)^>\s*"([^"]+)"')
        foreach ($match in $quoteMatches) {
            $quote = $match.Groups[1].Value.Trim()
            if ($quote.Length -gt 20) {  # Only check substantial quotes
                $sourceQuotes += [PSCustomObject]@{
                    Quote = $quote
                    Source = $sourceFile.Name
                }
            }
        }
        
        # Extract common phrases (3+ word sequences that might be copied)
        # This is a simple heuristic - in strict mode, check more carefully
        if ($Strict) {
            $sentences = $content -split '[.!?]' | Where-Object { $_.Trim().Length -gt 30 }
            foreach ($sentence in $sentences) {
                $words = $sentence.Trim() -split '\s+' | Where-Object { $_.Length -gt 3 }
                if ($words.Count -ge 5) {
                    # Take first 5-7 words as a potential phrase
                    $phrase = ($words[0..6] -join ' ').Trim()
                    if ($phrase.Length -gt 20) {
                        $sourcePhrases += $phrase
                    }
                }
            }
        }
    }
    catch {
        Write-ZeroCopyWarning "Failed to read source file: $($sourceFile.FullName)"
    }
}

Write-Host "Extracted $($sourceQuotes.Count) quotes from source material" -ForegroundColor Cyan
if ($Strict) {
    Write-Host "Extracted $($sourcePhrases.Count) phrases for strict checking" -ForegroundColor Cyan
}
Write-Host ""

# Check content files for matches
$violations = @()
$warnings = @()

foreach ($contentFile in $contentFiles) {
    try {
        $content = Get-Content -LiteralPath $contentFile.FullName -Raw -ErrorAction Stop
        if ($null -eq $content) { $content = "" }

        # Check for quote matches
        foreach ($sourceQuote in $sourceQuotes) {
            # Check for exact or near-exact matches
            $quoteWords = $sourceQuote.Quote -split '\s+' | Where-Object { $_.Length -gt 3 }
            $quotePattern = ($quoteWords[0..([Math]::Min(7, $quoteWords.Count - 1))] -join '\s+')
            
            if ($content -match [regex]::Escape($sourceQuote.Quote)) {
                $violations += [PSCustomObject]@{
                    File = $contentFile.FullName.Replace($RepoRoot, '').TrimStart('\\')
                    Type = "Exact Quote Match"
                    Source = $sourceQuote.Source
                    Quote = $sourceQuote.Quote.Substring(0, [Math]::Min(80, $sourceQuote.Quote.Length))
                }
            }
            elseif ($content -match $quotePattern) {
                $warnings += [PSCustomObject]@{
                    File = $contentFile.FullName.Replace($RepoRoot, '').TrimStart('\\')
                    Type = "Potential Quote Match"
                    Source = $sourceQuote.Source
                    Quote = $sourceQuote.Quote.Substring(0, [Math]::Min(80, $sourceQuote.Quote.Length))
                }
            }
        }
        
        # In strict mode, check for phrase matches
        if ($Strict) {
            foreach ($phrase in $sourcePhrases) {
                if ($content -match [regex]::Escape($phrase)) {
                    $warnings += [PSCustomObject]@{
                        File = $contentFile.FullName.Replace($RepoRoot, '').TrimStart('\\')
                        Type = "Potential Phrase Match"
                        Source = "source-material"
                        Quote = $phrase.Substring(0, [Math]::Min(80, $phrase.Length))
                    }
                }
            }
        }
    }
    catch {
        Write-ZeroCopyWarning "Failed to read content file: $($contentFile.FullName)"
    }
}

# Report results
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host ""

if ($violations.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-ZeroCopySuccess "No zero-copy violations detected!"
    Write-Host ""
    return
}

if ($violations.Count -gt 0) {
    Write-Host "❌ ZERO-COPY VIOLATIONS FOUND: $($violations.Count)" -ForegroundColor Red
    Write-Host ""
    foreach ($violation in $violations) {
        Write-ZeroCopyError "$($violation.File)"
        Write-Host "   Type: $($violation.Type)" -ForegroundColor Red
        Write-Host "   Source: $($violation.Source)" -ForegroundColor Red
        Write-Host "   Quote: $($violation.Quote)..." -ForegroundColor Red
        Write-Host ""
    }
}

if ($warnings.Count -gt 0) {
    Write-Host "⚠️  POTENTIAL MATCHES (Review Recommended): $($warnings.Count)" -ForegroundColor Yellow
    Write-Host ""
    foreach ($warning in $warnings) {
        Write-ZeroCopyWarning "$($warning.File)"
        Write-Host "   Type: $($warning.Type)" -ForegroundColor Yellow
        Write-Host "   Source: $($warning.Source)" -ForegroundColor Yellow
        Write-Host "   Match: $($warning.Quote)..." -ForegroundColor Yellow
        Write-Host ""
    }
}

Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host ""
Write-Host "Remember: All content must be transformative, not reformative." -ForegroundColor Cyan
Write-Host "Even quotes and 'Key Principle' sections must use original phrasing." -ForegroundColor Cyan
Write-Host ""

if ($violations.Count -gt 0) {
    throw "Zero-copy violations found."
}

return
