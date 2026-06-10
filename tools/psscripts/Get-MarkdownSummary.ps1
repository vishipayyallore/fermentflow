[CmdletBinding()]
param(
  [Parameter(Mandatory=$false)]
  [string]$Path,
  [switch]$Recurse
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($Path)) {
  $scriptDir = if (-not [string]::IsNullOrWhiteSpace($PSScriptRoot)) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
  $Path = (Resolve-Path (Join-Path $scriptDir "..\\.." )).Path
}

$headingRegex = [regex]'^(#{1,6})\s+(.+?)\s*$'

$files = @()
if (Test-Path -LiteralPath $Path -PathType Leaf) {
  $files = @(Get-Item -LiteralPath $Path)
} else {
  $gciParams = @{ Path = $Path; Filter = '*.md'; File = $true }
  if ($Recurse) { $gciParams.Recurse = $true }
  $files = @(Get-ChildItem @gciParams)
}

$results = foreach ($file in $files) {
  $content = Get-Content -LiteralPath $file.FullName -ErrorAction Stop
  $headings = @()
  foreach ($line in $content) {
    $m = $headingRegex.Match($line)
    if ($m.Success) {
      $headings += $m.Groups[2].Value.Trim()
    }
  }

  $wordCount = ($content -join "\n").Split([char[]]@(' ',"`t","`r","`n"), [System.StringSplitOptions]::RemoveEmptyEntries).Count

  [pscustomobject]@{
    File = $file.FullName
    Lines = $content.Count
    Words = $wordCount
    Headings = $headings.Count
    FirstHeadings = ($headings | Select-Object -First 5) -join '; '
  }
}

$results | Format-Table -AutoSize
