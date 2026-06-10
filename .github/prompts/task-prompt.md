# FermentFlow Repository Verification

## Context

You are working with **FermentFlow**, a .NET reference application for Domain-Driven Design in a brewery logistics domain. The repository demonstrates architectural evolution across git branches (monolith → CQRS → event sourcing → microservices).

**Repository Structure:**

- `docs/01-overview/` — project overview, domain, architecture evolution, running locally
- `docker/` — MongoDB, EventStoreDB, RabbitMQ infrastructure
- `src/` — application source (structure varies by branch)
- `tools/psscripts/` — maintenance and CI helper scripts
- `.github/` — workflows, prompts, mirrored skills and agents
- `.cursor/` — Cursor rules, skills mirror, agents

**Primary Objective:**
Perform a structured audit using FermentFlow standards. Verify file contents, run CI-aligned checks, and produce actionable findings.

---

## Verification Checks

### A. Documentation

- Open and verify key files under `docs/01-overview/`
- Check markdown formatting and internal link validity
- Confirm ubiquitous language consistency with `04-ubiquitous-language.md`
- Verify branch evolution docs match `03-architecture-evolution.md`

### B. Domain and Architecture

- Respect bounded context boundaries (Sales, Warehouses, Production)
- Validate CQRS separation on branches 02+
- Check integration events and ACL patterns on branches 03–04
- Ensure type names align with ubiquitous language

### C. Code Quality (when source present)

- `dotnet build` succeeds
- `dotnet test` passes
- No secrets or connection strings committed
- REST endpoints delegate to application/domain layers

### D. Governance

- `.github/skills/` ↔ `.cursor/skills/` mirror parity
- `.github/agents/` ↔ `.cursor/agents/` mirror parity
- Required `.cursor/rules/*.mdc` files present

### E. CI

Run checks from `.github/skills/ci-checks/SKILL.md`:

- dotnet build / test
- markdownlint-cli2
- optional Lychee link check

---

## Output Format

Produce findings grouped by severity:

- **Critical** — blocks build, breaks domain invariants, or corrupts governance
- **Major** — incorrect docs, broken links, bounded-context violations
- **Minor** — style, naming nits, optional improvements

Include file paths and suggested fixes for each finding.
