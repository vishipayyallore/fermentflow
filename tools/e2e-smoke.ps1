# E2E smoke — FermentFlow (build/test + optional API)
$ErrorActionPreference = "Stop"
$repoRoot = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..")).Path } else { (Get-Location).Path }

Write-Host "=== Repo root: $repoRoot ==="

Write-Host "=== Docker compose status (if docker/ exists) ==="
$dockerDir = Join-Path $repoRoot "docker"
if (Test-Path $dockerDir) {
  Push-Location $dockerDir
  try {
    docker compose ps
  } finally {
    Pop-Location
  }
} else {
  Write-Host "SKIP: no docker/ folder"
}

Write-Host "=== dotnet build ==="
$solution = Join-Path $repoRoot "src\FermentFlow.sln"
if (-not (Test-Path $solution)) {
  throw "Missing solution: $solution (source may live on another stage branch)"
}
dotnet build $solution --configuration Release

Write-Host "=== dotnet test ==="
dotnet test $solution --configuration Release --no-build

Write-Host "=== Optional API probe (Swagger) ==="
$swaggerUrl = "http://127.0.0.1:5098/documentation/index.html"
try {
  $resp = Invoke-WebRequest -Uri $swaggerUrl -TimeoutSec 3 -UseBasicParsing
  if ($resp.StatusCode -ge 200 -and $resp.StatusCode -lt 400) {
    Write-Host "API reachable at $swaggerUrl"
  }
} catch {
  Write-Host "SKIP: API not running at $swaggerUrl (start FermentFlow.Rest to enable)"
}

Write-Host "=== E2E PASS ==="
