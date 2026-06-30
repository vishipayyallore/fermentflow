# Branching, Tags, and Releases

> **Purpose:** Define how FermentFlow's nine-stage architecture laboratory is branched, tagged, and released.
> **Audience:** Swamy PKV — personal study checkpoints, reproducible stage snapshots, and GitHub Release notes.

Git workflow for freezing the blueprint, implementing each stage, and returning to any milestone.

**Related:** [Repository structure](../01_repository-structure.md) · [Stage vs git branch](../01_repository-structure.md#stage-vs-git-branch) · [Architecture governance](09-architecture-governance.md) · [Blueprint status](01-project-overview.md#blueprint-status)

---

## 1. Philosophy

| Principle | Rule |
|-----------|------|
| **Nine stages, one domain** | Extend the same brewery logistics codebase incrementally — no parallel `stage01/`, `stage02/` app folders |
| **Permanent stage branches** | `01-LegacyMonolith` … `09-Aspire` are personal checkpoints — **do not delete** after completion |
| **`main` is the living index** | Holds latest approved documentation; stage branches hold full code snapshots |
| **Tags = milestones** | Annotated tags mark blueprint freeze and stage completion; optional `-start` tags mark stage baselines |
| **Release per milestone** | Create a GitHub Release for blueprint and each completed stage so notes and diffs stay easy for Swamy to revisit |
| **Stage fidelity** | Implement only the patterns for the active stage — no skipping ahead |

This is an **architecture laboratory** repository. Permanent stage branches preserve Swamy's study checkpoints — `git checkout 03-CQRS-VerticalSlices` returns to exactly what Stage 03 looked like.

---

## 2. Repository model

```text
main
│
├── tag: v1.0-blueprint-approved     ← architecture frozen, pre-implementation
├── tag: v1.1-stage01-start          ← optional baseline when Stage 01 branch opens
├── tag: v1.1-stage01-complete       ← Stage 01 Definition of Done met
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
| **Tags** | Immutable snapshots for comparison, releases, and time travel |

---

## 3. Tag naming convention

```text
v1.0-blueprint-approved              # Architecture frozen before Stage 01 code

v1.1-stage01-start                   # Optional: branch 01-LegacyMonolith created, ready to implement
v1.1-stage01-complete                # Stage 01 DoD met on 01-LegacyMonolith

v1.2-stage02-start
v1.2-stage02-complete
…
v1.9-stage09-complete                # Stage 09 DoD met on 09-Aspire
```

**Format:** `v1.<stage>-<descriptor>`

- `<stage>` = 1–9 (matches modernization stage number)
- `<descriptor>` = `blueprint-approved`, `stageNN-start` (optional baseline), or `stageNN-complete`
- **All tags are annotated** (`git tag -a`) with a message describing intent

Release note templates: `docs/01-overview/release-notes/`

---

## 4. Branching strategy

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

### Merge policy

| Approach | When | Effect on `main` |
|----------|------|------------------|
| **A — Permanent stage branches only (recommended)** | Default for FermentFlow | `main` gets doc fixes; stage branches hold stage-specific code |
| **B — Merge each stage to `main`** | Production-style repos | `main` always has latest code; tags still mark stage completion |

**Recommendation:** Approach **A** — keep `01-LegacyMonolith` … `09-Aspire` as permanent personal checkpoints. Update `main` documentation as the living index; merge stage code to `main` only if Swamy decides to maintain a single "latest code" line.

---

## 5. Blueprint freeze

### Readiness checklist (v1.0)

| Area | Status |
|------|--------|
| Domain identified | ✅ |
| Bounded contexts identified | ✅ |
| Ubiquitous language defined | ✅ |
| Aggregate decisions resolved (`InventoryItem`) | ✅ |
| Invariants documented | ✅ |
| Context collaboration defined (ADR-013) | ✅ |
| Compensation strategy defined (ADR-014) | ✅ |
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

### Create blueprint tag (one-time)

Run from a clean commit that includes all blueprint docs:

```powershell
git checkout main
git pull

git status   # ensure intended files are committed

git tag -a v1.0-blueprint-approved -m "FermentFlow blueprint approved before Stage 01 implementation"
git show v1.0-blueprint-approved --no-patch

git push origin v1.0-blueprint-approved
```

---

## 6. Per-stage release workflow

### 6.1 Before starting a stage

```powershell
# 1. Ensure main (or previous stage branch) is clean
git checkout 01-LegacyMonolith   # or main for Stage 01
git pull

# 2. Optional: create stage baseline tag (what you will implement from)
git tag -a v1.1-stage01-start -m "Stage 01 baseline: branch 01-LegacyMonolith opened, pre-implementation"
git push origin v1.1-stage01-start

# 3. Implement per stage blueprint only — e.g. docs/01-overview/13-stage-01-overview.md
```

### 6.2 During stage work (live implementation safety)

Before **any** risky refactor or live experimentation:

```powershell
git tag -a stage-01-live-start -m "Checkpoint before Stage 01 live implementation"
```

If the implementation breaks:

```powershell
git checkout stage-01-live-start
# Rebuild: dotnet build / dotnet test
```

These are **lightweight recovery tags** — distinct from official milestone tags in §3. Delete after the stage if desired, or keep for post-mortem.

### 6.3 After stage completion (release)

```powershell
# 1. Confirm stage branch meets Definition of Done
git checkout 01-LegacyMonolith

# 2. Run quality gates
dotnet build src/FermentFlow.sln --configuration Release
dotnet test src/FermentFlow.sln --configuration Release --no-build
npx --yes markdownlint-cli2 "README.md" "docs/**/*.md" "src/**/*.md" "tools/**/*.md"

# 3. Update docs touched by the stage (overview, ADRs, branch roadmap)
# 3b. Draft release notes — learning objectives, patterns introduced, key ADRs
#     Save under docs/01-overview/release-notes/v1.1-stage01-complete.md

# 4. Create the milestone tag
git tag -a v1.1-stage01-complete -m "Stage 01 Legacy Monolith complete — DoD met"
git push origin v1.1-stage01-complete

# 5. Create GitHub Release
gh release create v1.1-stage01-complete `
  --title "FermentFlow v1.1 — Stage 01 Legacy Monolith Complete" `
  --notes-file docs/01-overview/release-notes/v1.1-stage01-complete.md

# 6. Open next stage branch from this one
git checkout -b 02-ModularMonolith
```

### 6.4 Stage summary line (personal checkpoint)

> "Blueprint frozen at `v1.0-blueprint-approved`. Stage 01 started from `v1.1-stage01-start` and completed at `v1.1-stage01-complete` on branch `01-LegacyMonolith`. Stage 02 continues on `02-ModularMonolith`."

---

## 7. GitHub Releases

Releases attach human-readable notes to tags. Create from the GitHub UI (**Releases → Draft a new release**) or with `gh`.

### Release: `v1.0-blueprint-approved`

**Title:** `FermentFlow v1.0 — Architecture Blueprint Approved`

**Body (template):**

```markdown
This release freezes the FermentFlow architecture before implementation begins.

## Highlights

- Nine-stage modernization roadmap finalized
- `InventoryItem` confirmed as aggregate root; `Availability` derived
- Production promoted to full bounded context (ADR-012)
- Stage 03: consumer-owned application contracts (ADR-013)
- Stage 03: compensation over TransactionScope; `InventoryReservation` (ADR-014)
- Cross-context MediatR forbidden
- Architecture governance and fitness functions completed
- Stage 01 implementation blueprint ready

## What is included

- `docs/` — overview, ADRs 001–014, stage blueprints
- Governance, event catalog, domain invariants
- No Stage 01 application code (by design)

## Next step

Create branch `01-LegacyMonolith` and implement per [Stage 01 blueprint](docs/01-overview/13-stage-01-overview.md).

This release is the architectural baseline for all future development.
```

### Create release via CLI

```powershell
gh release create v1.0-blueprint-approved `
  --title "FermentFlow v1.0 - Architecture Blueprint Approved" `
  --notes-file docs/01-overview/release-notes/v1.0-blueprint-approved.md
```

---

## 8. Time travel and comparison

### View repository at blueprint

```powershell
git checkout v1.0-blueprint-approved
```

Detached HEAD — read docs as they were at freeze. Return:

```powershell
git checkout main
```

### Inspect a stage branch or completed tag

```powershell
git checkout 03-CQRS-VerticalSlices
git checkout v1.3-stage03-complete
git checkout main
```

| Goal | Command |
|------|---------|
| Blueprint snapshot | `git checkout v1.0-blueprint-approved` |
| Stage 01 baseline (optional) | `git checkout v1.1-stage01-start` |
| Stage 01 completed | `git checkout v1.1-stage01-complete` |
| Stage 03 code as implemented | `git checkout 03-CQRS-VerticalSlices` |
| Latest documentation index | `git checkout main` |
| List curriculum tags | `git tag -l "v1.*" \| sort -V` |

### Compare stages

```powershell
git diff v1.0-blueprint-approved..HEAD
git diff v1.0-blueprint-approved..03-CQRS-VerticalSlices -- docs/
git diff v1.2-stage02-complete..v1.3-stage03-complete --stat
git log v1.2-stage02-complete..v1.3-stage03-complete --oneline
```

---

## 9. Workflow summary

```text
1. Freeze docs on main
2. Tag v1.0-blueprint-approved + GitHub Release
3. git checkout -b 01-LegacyMonolith
4. (Optional) tag v1.1-stage01-start
5. Implement Stage 01 only (13-stage-01-overview.md)
6. Tag v1.1-stage01-complete when DoD met + GitHub Release
7. git checkout -b 02-ModularMonolith from 01-LegacyMonolith
8. Repeat through Stage 09
```

---

## 10. What not to do

| Anti-pattern | Why it breaks the model |
|--------------|------------------------|
| Implement Stage 03 patterns on Stage 01 branch | Skips learning pressure; diff noise |
| Delete stage branches after merge | Loses personal checkpoints |
| Redesign architecture without ADR during implementation | Breaks freeze discipline |
| Force-push or move milestone tags | Destroys reproducibility |
| Skip the optional `-start` tag when you need a clean baseline | No stable pre-implementation checkpoint |
| Release without docs / release-notes update | Breaks audit trail for future you |
| Use `v1.1` without descriptor | Ambiguous; `v1.1-stage01-start` vs `v1.1-stage01-complete` differ |
| Create parallel `stage01/`, `stage02/` source trees | Violates single-app evolution |

---

## 11. Quick reference

| Action | Command |
|--------|---------|
| Start Stage 01 branch | `git checkout -b 01-LegacyMonolith` |
| Create stage baseline (optional) | `git tag -a v1.N-stageNN-start -m "..." && git push origin v1.N-stageNN-start` |
| Create live checkpoint | `git tag -a stage-NN-live-start -m "Checkpoint before Stage NN work"` |
| Create stage complete tag | `git tag -a v1.N-stageNN-complete -m "..." && git push origin v1.N-stageNN-complete` |
| Inspect Stage 03 code | `git checkout 03-CQRS-VerticalSlices` |
| Blueprint snapshot | `git checkout v1.0-blueprint-approved` |
| Diff since blueprint | `git diff v1.0-blueprint-approved..HEAD` |
| List tags | `git tag -l "v1.*" \| sort -V` |
| Push tag | `git push origin <tagname>` |

---

## 12. Related docs

- **Repository structure:** [docs/01_repository-structure.md](../01_repository-structure.md)
- **Branch roadmap:** [docs/01-overview/08-branch-roadmap.md](08-branch-roadmap.md)
- **Architecture governance / DoD:** [docs/01-overview/09-architecture-governance.md](09-architecture-governance.md)
- **Release notes folder:** [docs/01-overview/release-notes/](release-notes/)
- **File naming (tags, branches):** [.cursor/rules/07_file-naming-conventions.mdc](../../.cursor/rules/07_file-naming-conventions.mdc)
- **Docs verification skill:** [.github/skills/docs-verification/SKILL.md](../../.github/skills/docs-verification/SKILL.md)
