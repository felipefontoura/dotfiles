---
trigger: When performing git operations (commit, branch, PR)
---

# Git Workflow

Apply these conventions for all git operations.

## Commit Messages

Use conventional commits format:

```
type(scope): description

feat(api): add order creation endpoint
fix(checkout): resolve payment timeout issue
refactor(db): simplify customer schema
docs(readme): update setup instructions
test(orders): add integration tests
chore(deps): update dependencies
style(ui): fix button alignment
perf(api): optimize query with index
```

**Types:** `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `style`, `perf`

**Rules:**
- Lowercase type and description
- No period at the end
- Imperative mood ("add" not "added" or "adds")
- Scope is optional but helpful for monorepos
- Keep under 72 characters

## Branch Naming

```
feature/short-description
fix/bug-description
refactor/what-changed
docs/topic
chore/task-description
```

## Pre-Commit Checklist

Before committing, verify:
1. Code compiles/builds without errors
2. Linter passes
3. Tests pass
4. No debug code left (console.log, debugger, TODO)
5. No secrets or credentials in the diff

## Pull Requests

- Title follows conventional commit format
- Description explains what and why (not how)
- Include testing instructions
- Keep PRs focused - one concern per PR
- Link related issues
