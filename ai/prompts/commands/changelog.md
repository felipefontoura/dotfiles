Generate a changelog from commits between two refs.

## Instructions

1. Determine the range from $ARGUMENTS (e.g., `v1.0.0..v1.1.0`, `main..stable`, or last tag to HEAD)
2. If no range given, detect the last tag: `git describe --tags --abbrev=0`
3. Run `git log {range} --oneline --no-merges` to get commits
4. Group by conventional commit type
5. Output formatted changelog

## Range Detection

| Input | Range |
|-------|-------|
| `v1.0.0..v1.1.0` | Use as-is |
| `v1.0.0` | `v1.0.0..HEAD` |
| (none) | `{last_tag}..HEAD` |
| `main` | `main..HEAD` |

## Output Format

```markdown
## {version or range} ({date})

### Features
- {scope}: {description} ({short_sha})

### Bug Fixes
- {scope}: {description} ({short_sha})

### Refactoring
- {scope}: {description} ({short_sha})

### Tests
- {scope}: {description} ({short_sha})

### Chores
- {scope}: {description} ({short_sha})
```

## Grouping

| Commit type | Section |
|-------------|---------|
| `feat` | Features |
| `fix` | Bug Fixes |
| `refactor` | Refactoring |
| `perf` | Performance |
| `test` | Tests |
| `docs` | Documentation |
| `chore`, `style`, `ci` | Chores |

## Rules

- Skip empty sections
- Include short SHA for reference
- Parse scope from `type(scope): msg` format
- Commits without conventional format go under "Other"
- Do NOT modify any files — only output the changelog text
- If no commits in range, say so
