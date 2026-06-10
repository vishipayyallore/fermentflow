# Running Locally

Step-by-step guide for each branch.

---

## Prerequisites

- **.NET 10 SDK** (target — for roadmap branches as they are implemented)
- **.NET 8 SDK** (required only for **imported baseline branches** until ported)
- Docker Desktop (running)

> FermentFlow is positioned as a **.NET 10 architecture laboratory**. Baseline branches (`01-monolith_legacy` … `04-microservices`) may still target .NET 7/8 until each stage is ported forward. See [Project overview](01-project-overview.md).

---

## Branch 01 — Monolith Legacy (simplest)

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
| Swagger | http://localhost:5098/documentation |
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
→ http://localhost:5155/documentation

**Terminal 2 — Warehouses:**
```bash
cd src/Warehouses
dotnet run --project FermentFlow.Warehouses.Rest
```
→ http://localhost:5112/documentation

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `NETSDK1004` assets file not found | Run `dotnet restore` in `src/` |
| MongoDB connection refused | Ensure `docker compose up -d` completed; check port 17017 |
| Order returns 201 but empty rows | Beer not in availability — set availability first with matching `beerId` |
| Branch 03+ services fail to start | Wait for EventStore/RabbitMQ containers; check `docker ps` |
| Integration tests fail | MongoDB must be reachable at `host.docker.internal:17017` |
