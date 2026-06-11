# Running Locally (Greenfield Path)

Step-by-step guide for the **nine-stage greenfield** implementation. This is the target path — PostgreSQL, stage-named git branches, and `FermentFlow.Api` at Stage 01.

**Not on this path?** External baseline import (MongoDB, legacy branch names) is documented separately in [15-baseline-import-running.md](15-baseline-import-running.md).

**Terminology:** [Stage vs git branch](../01_repository-structure.md#stage-vs-git-branch) in repository structure.

---

## Prerequisites

- **.NET 10 SDK** (all stages)
- Docker Desktop (running)

> FermentFlow targets a **single SDK** (.NET 10) across every stage.

### Recommended hardware

Stage 04 onward runs PostgreSQL, RabbitMQ, and EventStoreDB concurrently.

| Profile | RAM | Notes |
|---------|-----|-------|
| **Minimum** | 16 GB | One stage at a time; close other heavy apps |
| **Recommended** | 32 GB | Comfortable for Stage 09 (Aspire), Testcontainers, and IDE together |

---

## Stage 01 — Legacy Monolith

Git branch: **`01-LegacyMonolith`**

Blueprint: [13-stage-01-overview.md](13-stage-01-overview.md)

```powershell
git checkout 01-LegacyMonolith
cd docker
docker compose up -d
cd ..\src
dotnet restore FermentFlow.sln
dotnet run --project FermentFlow.Api
```

| Resource | URL |
|----------|-----|
| API | <http://localhost:5000> (configure in `launchSettings.json`) |
| Health | `GET /health` (when added) |

**Endpoints:** `POST /api/inventory/availability`, `POST /api/sales/orders`, `POST /api/production/completed`

**Tests:** `dotnet test tests/FermentFlow.Api.Tests`

---

## Stage 02 — Modular Monolith

Git branch: **`02-ModularMonolith`**

*(Run instructions added when Stage 02 is implemented.)*

---

## Stage 03 — CQRS + Vertical Slices

Git branch: **`03-CQRS-VerticalSlices`**

*(Run instructions added when Stage 03 is implemented.)*

---

## Stage 04 — CQRS + Event Sourcing

Git branch: **`04-CQRS-EventSourcing`**

*(Run instructions added when Stage 04 is implemented.)*

---

## Stage 05 — Microservices

Git branch: **`05-Microservices`**

*(Run instructions added when Stage 05 is implemented — separate Sales, Inventory, and Production hosts.)*

---

## Stages 06–09

| Stage | Git branch | Notes |
|-------|------------|-------|
| 06 — Outbox | `06-OutboxPattern` | Reliable integration events |
| 07 — Circuit breaker | `07-CircuitBreaker` | Polly on sync calls |
| 08 — Observability | `08-Observability` | OpenTelemetry, Prometheus, Grafana |
| 09 — Aspire | `09-Aspire` | AppHost orchestration |

Per-stage run sections will be added as each branch is implemented.

---

## Troubleshooting (greenfield)

| Issue | Fix |
|-------|-----|
| `NETSDK1004` assets file not found | Run `dotnet restore` in `src/` |
| PostgreSQL connection refused | Ensure `docker compose up -d` completed; check compose logs |
| Order rejected — insufficient stock | Set availability first via `POST /api/inventory/availability` |
| Stage 04+ services fail to start | Wait for EventStore/RabbitMQ containers; check `docker ps` |
