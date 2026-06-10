---
name: ci-checks
description: Run CI-aligned checks for FermentFlow (.NET build/test, markdown lint, optional Lychee). Use when asked to run CI, lint, or verify code quality.
---

# CI Checks — Local Runner (FermentFlow)

Commands mirror `.github/workflows/ci-dotnet.yml` and `.github/workflows/ci-documentation.yml`.

## Policy

- **Quality expectations:** `.cursor/rules/03_quality-assurance.mdc` and `.github/copilot-instructions.md`.

## Prerequisites

- **Prerequisites:** .NET 10 SDK at repo root
- **Docker:** Docker Desktop for integration tests that require infrastructure (optional for build-only)
- **Node.js:** **20.x** for `markdownlint-cli2` (match `ci-documentation.yml`)
- **Link checks:** Docker with `lycheeverse/lychee:latest`, local `lychee`, or `.\tools\psscripts\Run-MarkdownLintAndLychee.ps1`

## Checks to run

Report each as PASS or FAIL with output.

### 1. dotnet build

```powershell
dotnet build src/FermentFlow.sln --configuration Release
```

If the active branch uses microservices (branch 04), also build:

```powershell
dotnet build src/Sales/FermentFlow.Sales.sln --configuration Release
dotnet build src/Warehouses/FermentFlow.Warehouses.sln --configuration Release
```

### 2. dotnet test

```powershell
dotnet test src/FermentFlow.sln --configuration Release --no-build
```

### 3. markdownlint-cli2

```powershell
npx --yes markdownlint-cli2 "README.md" "docs/**/*.md" "src/**/*.md" "tools/**/*.md"
```

### Optional — Lychee (Docker, recommended)

```powershell
docker run --rm `
  -v "${PWD}:/workspace" `
  -w /workspace `
  lycheeverse/lychee:latest `
  --config lychee.toml --cache --max-cache-age 1d '**/*.md'
```

Or: `.\tools\psscripts\Run-MarkdownLintAndLychee.ps1 -LycheeOnly`

## On failure

- **dotnet build/test:** report project, file, and error message
- **markdownlint:** report file and rule; do not skip silently

## Summary format

| # | Check | Status | Notes |
|---|--------|--------|-------|
| 1 | dotnet build | | |
| 2 | dotnet test | | |
| 3 | markdownlint | | |
