[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)]
  [string]$FileA,
  [Parameter(Mandatory=$true)]
  [string]$FileB
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $FileA -PathType Leaf)) { throw "File not found: $FileA" }
if (-not (Test-Path -LiteralPath $FileB -PathType Leaf)) { throw "File not found: $FileB" }

$a = Get-Content -LiteralPath $FileA
$b = Get-Content -LiteralPath $FileB

Compare-Object -ReferenceObject $a -DifferenceObject $b -IncludeEqual:$false | Format-Table -AutoSize
