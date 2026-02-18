Create a new branch with proper naming convention.

## Instructions

1. Parse the description from $ARGUMENTS
2. Detect the type from context or keywords
3. Generate branch name in the correct format
4. Create the branch from the current base branch

## Branch Name Format

```
{type}/{short-kebab-description}
```

## Type Detection

Infer from the description or ask if ambiguous:

| Keywords | Type |
|----------|------|
| add, create, implement, new | `feature` |
| fix, bug, resolve, broken, crash | `fix` |
| refactor, clean, simplify, extract, move | `refactor` |
| doc, readme, guide, comment | `docs` |
| test, spec, coverage | `test` |
| update deps, ci, config, lint, format | `chore` |
| perf, optimize, speed, cache | `perf` |

## Rules

- Kebab-case, lowercase, no special characters
- Max 4-5 words in the description part
- Create from `main` unless user specifies otherwise
- Run `git fetch origin main` before branching
- If branch already exists, warn and ask

## Examples

| Input | Branch |
|-------|--------|
| `add coupon system` | `feature/add-coupon-system` |
| `fix payment timeout` | `fix/payment-timeout` |
| `refactor provider types` | `refactor/provider-types` |
| `update dependencies` | `chore/update-dependencies` |
