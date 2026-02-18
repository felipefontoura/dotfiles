Generate a pull request summary for the current branch.

## Instructions

1. Run `git log main..HEAD --oneline` to see commits on this branch
2. Run `git diff main...HEAD --stat` to see changed files summary
3. Run `git diff main...HEAD` to see the full diff
4. If the base branch is not `main`, detect it from git config or ask
5. Analyze all changes and generate a PR description

## Analysis Steps

1. **Categorize changes:** feature, fix, refactor, docs, test, chore
2. **Identify scope:** which apps/packages are affected
3. **Summarize what changed and why** (infer intent from commits + diff)
4. **List breaking changes** if any
5. **Generate testing checklist** based on what was modified

## Output Format

```markdown
## PR Title
{type}({scope}): {concise description}

---

## Summary

{2-3 sentences explaining what this PR does and why}

## Changes

- {change 1}
- {change 2}
- {change 3}

## Files Changed

| Area | Files | Type |
|------|-------|------|
| {area} | {count} | {added/modified/deleted} |

## Testing

- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing done
- [ ] {specific test based on changes}

## Breaking Changes

{none, or list of breaking changes}

## Notes

{anything reviewers should pay attention to}
```

## Rules

- Read git data to produce the summary - do not invent changes
- Use conventional commit format for the title
- Focus on the "why" not just the "what"
- If there are no changes (clean branch), say so
- Do NOT push or create the PR - only generate the text
