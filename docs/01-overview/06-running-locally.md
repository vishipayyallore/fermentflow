# Running Locally

Step-by-step guide for each branch.

**Greenfield Stage 01** (`01-LegacyMonolith`): PostgreSQL + `FermentFlow.Api` — see [Stage 01 blueprint](13-stage-01-overview.md). Sections below labelled **Baseline import** describe legacy branch names and MongoDB from an external import path.

---

## Branch 01 — Legacy Monolith (target)

When `01-LegacyMonolith` is implemented per [13-stage-01-overview.md](13-stage-01-overview.md):

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

Endpoints: `POST /api/inventory/availability`, `POST /api/sales/orders`, `POST /api/production/completed` — see blueprint.

Tests: `dotnet test tests/FermentFlow.Api.Tests`

---

## Prerequisites

- **.NET 10 SDK** (all branches — imported baseline is ported to .NET 10 on `01-LegacyMonolith`)
- Docker Desktop (running)

> FermentFlow targets a **single SDK** (.NET 10) across every stage to reduce friction for CI, demos, and portfolio review.

### Recommended hardware

Branch 04 onward runs PostgreSQL, RabbitMQ, and EventStoreDB concurrently (via Docker Compose or Testcontainers).

| Profile | RAM | Notes |
|---------|-----|-------|
| **Minimum** | 16 GB | Adequate for one branch at a time; close other heavy apps |
| **Recommended** | 32 GB | Comfortable for Aspire (branch 09), Testcontainers, and IDE together |

---

## Baseline import — Branch 01 (legacy MongoDB path)

### 1. Start MongoDB

```bash
cd docker
docker compose up -d
```

MongoDB listens on **port 17017**.

### 2. Run the API

```bash
cd src
dotnet run --project FermentFlow.Rest
```

### 3. Verify

| Resource | URL |
|----------|-----|
| Swagger | <http://localhost:5098/documentation> |
| Health | API responds on port 5098 |

### 4. Test Order Creation

```bash
curl -X POST http://localhost:5098/v1/sales/ \
  -H "Content-Type: application/json" \
  -d '{
    "salesOrderId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "salesOrderNumber": "20260610-2130",
    "customerId": "3fa85f64-5717-4562-b3fc-2c963f66afa7",
    "customerName": "Test Customer",
    "orderDate": "2026-06-10T21:30:00Z",
    "rows": [{
      "beerId": "3fa85f64-5717-4562-b3fc-2c963f66afa8",
      "beerName": "FermentFlow IPA",
      "quantity": { "value": 10, "unitOfMeasure": "Lt" },
      "price": { "value": 5, "currency": "EUR" }
    }]
  }'
```

**Note:** On branch 01, the order only succeeds if availability for that `beerId` already exists in MongoDB. Set availability first:

```bash
curl -X POST http://localhost:5098/v1/warehouses/availabilities \
  -H "Content-Type: application/json" \
  -d '{
    "beerId": "3fa85f64-5717-4562-b3fc-2c963f66afa8",
    "beerName": "FermentFlow IPA",
    "quantity": { "value": 100, "unitOfMeasure": "Lt" }
  }'
```

### 5. Run Tests

```bash
cd src
dotnet test FermentFlow.Rest.Tests
```

Tests expect MongoDB at `mongodb://host.docker.internal:17017`.

---

## Branch 02 — CQRS + Mediator

```bash
git checkout 02-monolith_with_cqrs
cd docker && docker compose up -d
cd ../src && dotnet run --project FermentFlow.Rest
```

Create order via **`POST /v1/FermentFlow/`** (not `/v1/sales/`).

---

## Branch 03 — Event Sourcing

```bash
git checkout 03-monolith_with_cqrs_and_event_sourcing
cd docker && docker compose up -d
cd ../src && dotnet run --project FermentFlow.Rest
```

Requires **all** Docker services: 3 EventStores, RabbitMQ, 4 MongoDB instances.  
Startup may take 30–60 seconds for infrastructure to be ready.

**Order of operations:**
1. `POST /v1/warehouses/availabilities` — set stock
2. Wait for ACL to sync Sales read model (async)
3. `POST /v1/sales/` — create order

---

## Branch 04 — Microservices

```bash
git checkout 04-microservices
cd docker && docker compose up -d
```

**Terminal 1 — Sales:**
```bash
cd src/Sales
dotnet run --project FermentFlow.Sales.Rest
```
→ <http://localhost:5155/documentation>

**Terminal 2 — Warehouses:**
```bash
cd src/Warehouses
dotnet run --project FermentFlow.Warehouses.Rest
```
→ <http://localhost:5112/documentation>

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `NETSDK1004` assets file not found | Run `dotnet restore` in `src/` |
| MongoDB connection refused | Ensure `docker compose up -d` completed; check port 17017 |
| Order returns 201 but empty rows | Beer not in availability — set availability first with matching `beerId` |
| Branch 03+ services fail to start | Wait for EventStore/RabbitMQ containers; check `docker ps` |
| Integration tests fail | MongoDB must be reachable at `host.docker.internal:17017` |
