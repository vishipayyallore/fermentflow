# Pull Request

## Description

A clear and concise description of what this PR does.

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Documentation update
- [ ] Refactoring (no functional change)
- [ ] Test addition/update
- [ ] Build/CI changes
- [ ] Infrastructure (Docker, messaging, persistence)

## Branch / Context

- [ ] `01-LegacyMonolith`
- [ ] `02-ModularMonolith`
- [ ] `03-CQRS-VerticalSlices`
- [ ] `04-EventSourcing`
- [ ] `05-Microservices`
- [ ] `06-OutboxPattern`
- [ ] `07-CircuitBreaker`
- [ ] `08-Observability`
- [ ] `09-Aspire`
- [ ] Main/docs only (no branch-specific source change)

## Changes Made

### Files Changed

- `path/to/file`

### Summary

Brief summary of what was changed and why.

## Checklist

### Pre-Submission

- [ ] `dotnet build` succeeds (when source changed)
- [ ] `dotnet test` passes (when source changed)
- [ ] Bounded context boundaries respected
- [ ] Ubiquitous language matches `docs/01-overview/04-ubiquitous-language.md`
- [ ] No secrets or connection strings committed
- [ ] Markdown lint passes (when docs changed)

### Documentation

- [ ] `docs/01-overview/` updated if behaviour changed
- [ ] Cross-references valid

## Related Issues

Closes #(issue number)

## Additional Notes

Any additional context for reviewers.
