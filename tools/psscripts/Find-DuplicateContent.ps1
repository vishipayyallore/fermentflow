[CmdletBinding()]
param(
  [string]$RepoRoot,
  [ValidateRange(2,50)]
  [int]$MinOccurrences = 3
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
  $scriptDir = if (-not [string]::IsNullOrWhiteSpace($PSScriptRoot)) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
  $RepoRoot = (Resolve-Path (Join-Path $scriptDir "..\\.." )).Path
}

$excludedDirNames = @('.git', 'node_modules', '.venv', '.idea', '.vscode')
function Test-IsExcludedPath {
  param([string]$FullName)
  foreach ($dir in $excludedDirNames) {
    if ($FullName -match ([regex]::Escape("\\$dir\\"))) { return $true }
  }
  return $false
}

$headingRegex = [regex]'^(#{1,6})\s+(.+?)\s*$'
$mdFiles = Get-ChildItem -Path $RepoRoot -Recurse -File -Filter '*.md' | Where-Object { -not (Test-IsExcludedPath $_.FullName) }

$map = @{}
foreach ($file in $mdFiles) {
  $content = @(Get-Content -LiteralPath $file.FullName -ErrorAction Stop)
  for ($i = 0; $i -lt $content.Count; $i++) {
    $m = $headingRegex.Match($content[$i])
    if (-not $m.Success) { continue }

    $text = $m.Groups[2].Value.Trim()
    if ([string]::IsNullOrWhiteSpace($text)) { continue }

    $key = $text.ToLowerInvariant()
    if (-not $map.ContainsKey($key)) {
      $map[$key] = New-Object System.Collections.Generic.List[object]
    }

    $map[$key].Add([pscustomobject]@{ Heading=$text; File=$file.FullName; Line=($i+1) })
  }
}

$dupes = $map.GetEnumerator() | Where-Object { $_.Value.Count -ge $MinOccurrences } | Sort-Object { $_.Value.Count } -Descending

$dupes | ForEach-Object {
  $items = $_.Value
  [pscustomobject]@{
    Heading = $items[0].Heading
    Occurrences = $items.Count
    Examples = ($items | Select-Object -First 3 | ForEach-Object { "$(Split-Path -Leaf $_.File):$($_.Line)" }) -join ', '
  }
} | Format-Table -AutoSize
