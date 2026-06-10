[CmdletBinding()]
param(
  [string]$Path,
  [string]$Include = '*',
  [switch]$Recurse,
  [ValidateRange(1,5000)]
  [int]$Top = 50,
  [ValidateSet('Lines','Bytes','Name')]
  [string]$SortBy = 'Lines'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($Path)) {
  $scriptDir = if (-not [string]::IsNullOrWhiteSpace($PSScriptRoot)) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
  $Path = (Resolve-Path (Join-Path $scriptDir "..\\.." )).Path
}

$gciParams = @{
  Path = $Path
  File = $true
  Filter = $Include
}
if ($Recurse) { $gciParams.Recurse = $true }

$files = Get-ChildItem @gciParams

$stats = foreach ($f in $files) {
  $lines = 0
  try {
    $lines = (Get-Content -LiteralPath $f.FullName -ErrorAction Stop).Count
  } catch {
    # Non-text/binary or access issues
    $lines = $null
  }

  [pscustomobject]@{
    Name  = $f.Name
    Path  = $f.FullName
    Bytes = $f.Length
    Lines = $lines
  }
}

switch ($SortBy) {
  'Bytes' { $sorted = $stats | Sort-Object Bytes -Descending }
  'Name'  { $sorted = $stats | Sort-Object Name }
  default { $sorted = $stats | Sort-Object Lines -Descending }
}

$sorted | Select-Object -First $Top | Format-Table -AutoSize
