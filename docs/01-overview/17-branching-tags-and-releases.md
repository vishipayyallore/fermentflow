# Branching, Tags, and Releases

Git workflow for FermentFlow's nine-stage architecture laboratory — how to freeze the blueprint, implement each stage, and return to any milestone.

**Related:** [Repository structure](../01_repository-structure.md) · [Stage vs git branch](../01_repository-structure.md#stage-vs-git-branch) · [Architecture governance](09-architecture-governance.md) · [Blueprint status](01-project-overview.md#blueprint-status)

---

## Repository model (recommended)

```text
main
│
├── tag: v1.0-blueprint-approved     ← architecture frozen, pre-implementation
├── tag: v1.1-stage01-complete       ← (after Stage 01 DoD)
├── …
│
├── branch: 01-LegacyMonolith        ← permanent stage checkpoint
├── branch: 02-ModularMonolith
├── …
└── branch: 09-Aspire
```

| Ref | Role |
|-----|------|
| **`main`** | Latest approved documentation; may advance as stages complete (merge policy below) |
| **Stage branches** (`01-LegacyMonolith` … `09-Aspire`) | Permanent checkpoints — each holds docs + code as of that stage |
| **Tags** | Immutable snapshots for comparison, releases, and "time travel" |

This is an **architecture-learning** repository. Keeping stage branches permanent preserves educational value — you can always `git checkout 03-CQRS-VerticalSlices` and see exactly what Stage 03 looked like.

---

## Blueprint freeze

### Readiness checklist (v1.0)

| Area | Status |
|------|--------|
| Domain identified | ✅ |
| Bounded contexts identified | ✅ |
| Ubiquitous language defined | ✅ |
| Aggregate decisions resolved (`InventoryItem`) | ✅ |
| Invariants documented | ✅ |
| Context collaboration defined (ADR-012) | ✅ |
| Compensation strategy defined (ADR-013) | ✅ |
| Cross-context MediatR rule defined | ✅ |
| Evolution roadmap defined | ✅ |
| Architecture governance + fitness functions | ✅ |
| Stage-by-stage learning objectives | ✅ |
| Definition of Done | ✅ |

### Freeze rule

> **No further architectural changes unless implementation reveals a real problem.**

Documentation is frozen **for implementation**, not forever. If Stage 01 or 02 exposes a wrong aggregate boundary, awkward repository abstraction, or impractical fitness function:

1. Create a new ADR ([governance process](09-architecture-governance.md))
2. Update affected docs in the same commit as the code change
3. Do not redesign ahead of the current stage

---

## Branching strategy

### `main`

- Holds the **canonical blueprint** and the latest merged work Swamy approves
- Before Stage 01 code lands: docs-only blueprint on `main`
- After each stage: optionally merge documentation updates; stage branch retains full code snapshot

### Stage branches (permanent)

Create one branch per stage. **Do not delete** after completion.

| Stage | Git branch | Created from |
|-------|------------|--------------|
| 01 | `01-LegacyMonolith` | `main` at `v1.0-blueprint-approved` (or current `main`) |
| 02 | `02-ModularMonolith` | `01-LegacyMonolith` when Stage 01 DoD met |
| 03 | `03-CQRS-VerticalSlices` | `02-ModularMonolith` when Stage 02 DoD met |
| … | … | Previous stage branch |
| 09 | `09-Aspire` | `08-Observability` when Stage 08 DoD met |

### Start Stage 01

```powershell
git checkout main
git pull

# Optional: verify blueprint tag
git checkout v1.0-blueprint-approved   # read-only inspection
git checkout main

git checkout -b 01-LegacyMonolith
# implement per 13-stage-01-overview.md — do not skip ahead
```

### Branch from a stage (experimentation)

```powershell
git checkout -b experiment-from-stage03 03-CQRS-VerticalSlices
```

### Merge policy

| Approach | When | Effect on `main` |
|----------|------|------------------|
| **A — Permanent stage branches only (recommended)** | Default for FermentFlow | `main` gets doc fixes; stage branches hold stage-specific code |
| **B — Merge each stage to `main`** | Production-style repos | `main` always has latest code; tags still mark stage completion |

**Recommendation:** Approach **A** — keep `01-LegacyMonolith` … `09-Aspire` as permanent teaching checkpoints. Update `main` documentation as the living index; merge stage code to `main` only if you want a single "latest code" line (optional).

---

## Tags

### Naming convention

| Tag | When |
|-----|------|
| `v1.0-blueprint-approved` | Architecture blueprint frozen; **before** Stage 01 implementation |
| `v1.1-stage01-complete` | Stage 01 Definition of Done met on `01-LegacyMonolith` |
| `v1.2-stage02-complete` | Stage 02 DoD met |
| … | … |
| `v1.9-stage09-complete` | Stage 09 DoD met |

Use **annotated tags** (`-a`) so the message records intent.

### Create blueprint tag (one-time)

Run from a clean commit that includes all blueprint docs:

```powershell
git status   # ensure intended files are committed

git tag -a v1.0-blueprint-approved -m "FermentFlow blueprint approved before Stage 01 implementation"

# Verify
git show v1.0-blueprint-approved --no-patch

# Publish (when ready)
git push origin v1.0-blueprint-approved
```

### Stage completion tag

After a stage branch meets [Definition of Done](09-architecture-governance.md):

```powershell
git checkout 01-LegacyMonolith
# confirm dotnet build/test pass, DoD checklist complete

git tag -a v1.1-stage01-complete -m "Stage 01 Legacy Monolith complete"
git push origin v1.1-stage01-complete
```

---

## GitHub Releases

Releases attach human-readable notes to tags. Create from the GitHub UI (**Releases → Draft a new release**) or with `gh`.

### Release: `v1.0-blueprint-approved`

**Title:** `FermentFlow v1.0 — Architecture Blueprint Approved`

**Body (template):**

```markdown
This release freezes the FermentFlow architecture before implementation begins.

## Highlights

- Nine-stage modernization roadmap finalized
- `InventoryItem` confirmed as aggregate root; `Availability` derived
- Production promoted to full bounded context (ADR-011)
- Stage 03: consumer-owned application contracts (ADR-012)
- Stage 03: compensation over TransactionScope; `InventoryReservation` (ADR-013)
- Cross-context MediatR forbidden
- Architecture governance and fitness functions completed
- Stage 01 implementation blueprint ready

## What is included

- `docs/` — overview, ADRs 000–013, stage blueprints
- Governance, event catalog, domain invariants
- No Stage 01 application code (by design)

## Next step

Create branch `01-LegacyMonolith` and implement per [Stage 01 blueprint](docs/01-overview/13-stage-01-overview.md).

This release is the architectural baseline for all future development.
```

### Create release via CLI

```powershell
# From repository root; run after the tag is pushed
gh release create v1.0-blueprint-approved `
  --title "FermentFlow v1.0 - Architecture Blueprint Approved" `
  --notes-file docs/01-overview/release-notes/v1.0-blueprint-approved.md
```

Release note templates live under `docs/01-overview/release-notes/`.

---

## Time travel and comparison

### View repository at blueprint

```powershell
git checkout v1.0-blueprint-approved
```

Detached HEAD — read docs as they were at freeze. Return:

```powershell
git checkout main
```

### Compare blueprint to current work

```powershell
git diff v1.0-blueprint-approved..HEAD
git diff v1.0-blueprint-approved..03-CQRS-VerticalSlices -- docs/
```

### List tags

```powershell
git tag -l "v1.*"
```

---

## Workflow summary

```text
1. Freeze docs on main
2. Tag v1.0-blueprint-approved + GitHub Release
3. git checkout -b 01-LegacyMonolith
4. Implement Stage 01 only (13-stage-01-overview.md)
5. Tag v1.1-stage01-complete when DoD met
6. git checkout -b 02-ModularMonolith from 01-LegacyMonolith
7. Repeat through Stage 09
```

---

## What not to do

| Anti-pattern | Why |
|--------------|-----|
| Implement Stage 03 patterns on Stage 01 branch | Skips learning pressure |
| Delete stage branches after merge | Loses teaching checkpoints |
| Redesign architecture without ADR during implementation | Breaks freeze discipline |
| Force-push stage branches | Destroys reproducible history |

---

## Related commands quick reference

| Goal | Command |
|------|---------|
| Start Stage 01 | `git checkout -b 01-LegacyMonolith` |
| Inspect Stage 03 code | `git checkout 03-CQRS-VerticalSlices` |
| Blueprint snapshot | `git checkout v1.0-blueprint-approved` |
| Diff since blueprint | `git diff v1.0-blueprint-approved..HEAD` |
| Push tag | `git push origin <tagname>` |
