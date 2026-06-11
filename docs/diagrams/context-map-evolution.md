# Context Map Evolution

How FermentFlow bounded contexts and integration styles evolve across import branches and the nine-stage roadmap.

**Related:** [Business domain](../01-overview/02-business-domain.md) · [Architecture evolution](../01-overview/03-architecture-evolution.md) · [Branch roadmap](../01-overview/08-branch-roadmap.md)

---

## Branch 01 — Legacy monolith

```text
+------------------+
|   FermentFlow    |
|  (single deploy) |
|  Sales + Stock   |
|  shared MongoDB  |
+------------------+
```

Direct in-process calls; no explicit bounded context boundaries.

---

## Branch 02 — Modular monolith (target)

```text
+----------+     in-process      +-----------+
|  Sales   | ------------------> | Inventory |
+----------+                     +-----------+
      ^                                ^
      |         Mediator / ACL         |
      +--------------------------------+
```

Production remains contract-only on imported baseline until branch 05 target.

---

## Branch 04+ — Event-driven boundaries

```text
+------------+   integration event   +-------------+
| Production | --------------------> |  Inventory  |
+------------+                       +-------------+
                                            |
                                            | integration event
                                            v
                                      +------------+
                                      |   Sales    |
                                      +------------+
```

Stage 10 adds orchestrated sagas across this flow — see [ADR-009](../adr/ADR-009-introduce-event-driven-sagas.md).

---

## Naming evolution

| Baseline import | Target name | Stage |
|-----------------|-------------|-------|
| `Warehouses` | **Inventory** | 02+ |
| `Production.Contracts` only | **Production** bounded context | 05+ |
