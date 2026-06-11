# Domain Invariants

Explicit aggregate rules for FermentFlow. These become **Given/When/Then domain unit tests** from branch **03-CQRS-VerticalSlices** onward.

**Related:** [Business domain](02-business-domain.md) · [Event catalog](10-event-catalog.md) · [Architecture governance](09-architecture-governance.md) · [ADR-002](../adr/ADR-002-introduce-cqrs.md)

---

## SalesOrder

| Invariant | Rule |
|-----------|------|
| Minimum lines | Must contain at least one order row |
| Stock availability | Cannot order unavailable stock (quantity must not exceed available stock per beer) |
| Lifecycle | Cannot be closed twice |
| Customer | Must reference a valid customer identity |

### Example unit tests (branch 03+)

```text
Given stock of 10 for Beer-A
When order requests 5 of Beer-A
Then order is accepted

Given stock of 10 for Beer-A
When order requests 15 of Beer-A
Then order is rejected
```

```text
Given a closed SalesOrder
When Close is invoked again
Then operation is rejected
```

---

## Availability

*(Inventory context; baseline import name: `Warehouses`.)*

| Invariant | Rule |
|-----------|------|
| Non-negative stock | Cannot go below zero |
| Reservation | Cannot reserve more than available quantity |
| Identity | One availability record per beer (or per beer + location, when modeled) |

### Example unit tests (branch 03+)

```text
Given available quantity of 10
When reserve 5
Then available becomes 5

Given available quantity of 10
When reserve 15
Then operation is rejected

Given available quantity of 5
When decrease by 10
Then operation is rejected
```

---

## ProductionOrder

*(Target bounded context from branch 05+; contracts-only on baseline import.)*

| Invariant | Rule |
|-----------|------|
| Sequencing | Cannot complete before start |
| Lifecycle | Cannot start twice |
| Batch identity | Must reference a valid beer and batch size |

### Example unit tests (branch 05+)

```text
Given a new ProductionOrder
When Complete is invoked before Start
Then operation is rejected

Given a started ProductionOrder
When Start is invoked again
Then operation is rejected
```

---

## Mapping to tests

| Aggregate | Test project | Introduced |
|-----------|--------------|------------|
| `SalesOrder` | `tests/FermentFlow.Sales.UnitTests` | Branch 03 |
| `Availability` | `tests/FermentFlow.Inventory.UnitTests` | Branch 03 |
| `ProductionOrder` | `tests/FermentFlow.Production.UnitTests` | Branch 05 |

Keep tests **framework-free** — no EF Core, MassTransit, or HTTP in domain unit tests.

---

## Maintenance

When a branch adds or changes aggregate behaviour:

1. Update the invariant table for that aggregate
2. Add or adjust domain unit tests before merging
3. If the change emits a new event, update [Event catalog](10-event-catalog.md)
