# E2E Smoke — FermentFlow

## Prerequisites

- .NET 10 SDK
- Docker Desktop

## Smoke steps

1. **Infrastructure**

   ```powershell
   cd docker
   docker compose up -d
   docker compose ps
   ```

2. **Build and test**

   ```powershell
   cd ..\src
   dotnet restore FermentFlow.sln
   dotnet build FermentFlow.sln --configuration Release
   dotnet test FermentFlow.sln --configuration Release --no-build
   ```

3. **Run API** (branch 01 example)

   ```powershell
   dotnet run --project FermentFlow.Rest
   ```

   Verify Swagger at `http://localhost:5098/documentation`

4. **Docs lint**

   ```powershell
   npx --yes markdownlint-cli2 "README.md" "docs/**/*.md"
   ```

## Branch notes

- Branch 03+: domain unit tests and Testcontainers integration tests under `tests/`
- Branch 04: run Sales and Warehouses REST projects separately — see `docs/01-overview/06-running-locally.md`
- If solution paths differ on the active branch, document the mismatch as a finding

## Output

PASS/FAIL per step; blockers for local development.
