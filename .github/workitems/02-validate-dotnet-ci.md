# Work item: Add dotnet CI workflow validation

## Goal

Validate `ci-dotnet.yml` against available solutions on each evolution branch.

## Tasks

- [ ] Confirm `src/FermentFlow.sln` exists on branches 01–03
- [ ] Add matrix or conditional jobs for branch 04 microservice solutions
- [ ] Document CI limitations in `docs/agent-skills.md` or CI skill

## Definition of done

CI builds and tests pass on main branch; branch gaps documented.
