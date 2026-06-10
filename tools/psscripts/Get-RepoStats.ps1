[CmdletBinding()]
param(
  [Parameter(ValueFromPipelineByPropertyName)]
  [string]$RepoRoot
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

Write-Host "RepoRoot: $RepoRoot" 

$allFiles = Get-ChildItem -Path $RepoRoot -Recurse -File | Where-Object { -not (Test-IsExcludedPath $_.FullName) }

$total = $allFiles.Count
$byExt = $allFiles | Group-Object Extension | Sort-Object Count -Descending

$mdFiles = $allFiles | Where-Object { $_.Extension -ieq '.md' }

$topFolders = Get-ChildItem -Path $RepoRoot -Directory | Select-Object -ExpandProperty Name

Write-Host "" 
Write-Host "Top-level folders:" 
$topFolders | ForEach-Object { Write-Host "- $_" }

Write-Host "" 
Write-Host "File counts:" 
Write-Host "- Total files: $total" 
Write-Host "- Markdown files: $($mdFiles.Count)" 

Write-Host "" 
Write-Host "Counts by extension:" 
$byExt | ForEach-Object {
  $ext = if ([string]::IsNullOrWhiteSpace($_.Name)) { '(no extension)' } else { $_.Name }
  Write-Host ("- {0}: {1}" -f $ext, $_.Count)
}
