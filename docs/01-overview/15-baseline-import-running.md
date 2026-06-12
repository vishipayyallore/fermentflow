# Running Locally (Baseline Import Reference)

**Optional reference only** — for comparing against an **external** baseline import (MongoDB, Muflone, legacy git branch names). **Not** the greenfield nine-stage path.

**Greenfield path:** [06-running-locally.md](06-running-locally.md) · **Comparison doc:** [03-architecture-evolution.md](03-architecture-evolution.md)

---

## Prerequisites

- .NET 10 SDK (after port)
- Docker Desktop
- Legacy-named git branches from the external import (if available)

---

## Legacy branch 01 — `01-monolith_legacy`

### Start MongoDB

```bash
cd docker
docker compose up -d
```

MongoDB listens on **port 17017**.

### Run the API

```bash
cd src
dotnet run --project FermentFlow.Rest
```

| Resource | URL |
|----------|-----|
| Swagger | <http://localhost:5098/documentation> |
| Health | API responds on port 5098 |

### Test order creation

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

Set availability first:

```bash
curl -X POST http://localhost:5098/v1/warehouses/availabilities \
  -H "Content-Type: application/json" \
  -d '{
    "beerId": "3fa85f64-5717-4562-b3fc-2c963f66afa8",
    "beerName": "FermentFlow IPA",
    "quantity": { "value": 100, "unitOfMeasure": "Lt" }
  }'
```

### Tests

```bash
cd src
dotnet test FermentFlow.Rest.Tests
```

Tests expect MongoDB at `mongodb://host.docker.internal:17017`.

---

## Legacy branch 02 — `02-monolith_with_cqrs`

```bash
git checkout 02-monolith_with_cqrs
cd docker && docker compose up -d
cd ../src && dotnet run --project FermentFlow.Rest
```

Create order via **`POST /v1/FermentFlow/`** (not `/v1/sales/`).

---

## Legacy branch 03 — `03-monolith_with_cqrs_and_event_sourcing`

```bash
git checkout 03-monolith_with_cqrs_and_event_sourcing
cd docker && docker compose up -d
cd ../src && dotnet run --project FermentFlow.Rest
```

Requires EventStore, RabbitMQ, and multiple MongoDB instances. Startup may take 30–60 seconds.

**Order of operations:**

1. `POST /v1/warehouses/availabilities` — set stock
2. Wait for ACL to sync Sales read model (async)
3. `POST /v1/sales/` — create order

---

## Legacy branch 04 — `04-microservices`

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

## Troubleshooting (baseline import)

| Issue | Fix |
|-------|-----|
| MongoDB connection refused | Ensure `docker compose up -d` completed; check port 17017 |
| Order returns 201 but empty rows | Set availability first with matching `beerId` |
| Integration tests fail | MongoDB at `host.docker.internal:17017` |
