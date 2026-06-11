# Domain Invariants

Explicit aggregate rules for FermentFlow. These become **Given/When/Then domain unit tests** from branch **03-CQRS-VerticalSlices** onward.

**Related:** [Business domain](02-business-domain.md) · [Event catalog](10-event-catalog.md) · [Inventory aggregate model](12-inventory-aggregate-model.md) · [ADR-010](../adr/ADR-010-inventory-item-aggregate-root.md) · [Architecture governance](09-architecture-governance.md) · [ADR-002](../adr/ADR-002-introduce-cqrs.md)

---

## SalesOrder

| Invariant | Rule |
|-----------|------|
| Minimum lines | Must contain at least one order row |
| Stock availability | Cannot order unavailable stock (line quantity must not exceed `AvailableQuantity` per beer) |
| Lifecycle | Cannot be closed twice |
| Customer | Must reference a valid customer identity |

### Example unit tests (branch 03+)

```text
Given InventoryItem with AvailableQuantity 10 for Beer-A
When CreateSalesOrder requests 5 of Beer-A
Then order is accepted

Given InventoryItem with AvailableQuantity 10 for Beer-A
When CreateSalesOrder requests 15 of Beer-A
Then order is rejected
```

```text
Given a closed SalesOrder
When Close is invoked again
Then operation is rejected
```

---

## InventoryItem

Aggregate root of the Inventory bounded context (branch 02+). Stage 01 uses a simplified anemic `Availability` entity without these invariants — see [Stage 01 blueprint](13-stage-01-overview.md).

| Invariant | Rule |
|-----------|------|
| Non-negative on-hand | `OnHandQuantity >= 0` |
| Non-negative reserved | `ReservedQuantity >= 0` |
| Reservation cap | `ReservedQuantity <= OnHandQuantity` |
| Derived availability | `AvailableQuantity = OnHandQuantity - ReservedQuantity`; must be `>= 0` |
| Identity | One `InventoryItem` per beer (extend with location when modeled) |

### Example unit tests (branch 03+)

```text
Given OnHand 10, Reserved 0
When ReserveStock 5
Then Reserved 5, Available 5

Given OnHand 10, Reserved 0
When ReserveStock 15
Then operation is rejected

Given OnHand 5, Reserved 0
When AdjustInventory by -10
Then operation is rejected
```

```text
Given OnHand 10, Reserved 5
When ReceiveStock 20
Then OnHand 30, Available 25
```

---

## ProductionOrder

*(Target bounded context from branch 02 module; full lifecycle from branch 05+; contracts-only on Stage 01.)*

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
| `InventoryItem` | `tests/FermentFlow.Inventory.UnitTests` | Branch 03 |
| `ProductionOrder` | `tests/FermentFlow.Production.UnitTests` | Branch 05 |

Keep tests **framework-free** — no EF Core, MassTransit, or HTTP in domain unit tests.

---

## Maintenance

When a branch adds or changes aggregate behaviour:

1. Update the invariant table for that aggregate
2. Add or adjust domain unit tests before merging
3. If the change emits a new event, update [Event catalog](10-event-catalog.md)
