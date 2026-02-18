Create a pull request on GitHub for the current branch.

## Instructions

1. Run `git status` to check for uncommitted changes (warn if any)
2. Detect the base branch: `main` unless configured otherwise
3. Run `git log {base}..HEAD --oneline` to see commits
4. Run `git diff {base}...HEAD --stat` to see changed files
5. Run `git diff {base}...HEAD` to read the full diff
6. Check if branch is pushed: `git rev-parse --abbrev-ref --symbolic-full-name @{u}`
7. Analyze all commits (not just latest) and generate PR content
8. **Show preview and ask for confirmation before proceeding:**
   - Display the PR title and body
   - Show what will happen (push + create PR)
   - Wait for user approval
9. Push branch if needed: `git push -u origin HEAD`
10. Create PR with `gh pr create`

## Analysis

- Categorize: feat, fix, refactor, docs, test, chore
- Identify scope: which apps/packages are affected
- Infer intent from commits + diff
- Detect breaking changes

## PR Format

**Title:** `{type}({scope}): {concise description}` (under 72 chars)

**Body:**

```markdown
## Summary
- {bullet 1}
- {bullet 2}
- {bullet 3}

## Test plan
- [ ] Unit tests pass
- [ ] {specific checks based on what changed}

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## Create with gh

```bash
gh pr create --title "{title}" --body "$(cat <<'EOF'
{body}
EOF
)"
```

## Preview Format

Show the PR preview and ask for confirmation:

```
## PR Preview

**Title:** `feat(api): add order creation endpoint`
**Base:** main ← feature/order-creation
**Commits:** 3
**Files changed:** 7

**Body:**
> ## Summary
> - Add POST /orders endpoint with Zod validation
> - Add order creation service with PIX integration
> - Add unit and integration tests
>
> ## Test plan
> - [ ] Unit tests pass
> - [ ] POST /orders returns 201 with valid payload

**Actions:** push to origin + create PR

Proceed?
```

## Rules

- Read ALL commits on the branch, not just the latest
- Do not invent changes - only describe what the diff shows
- Title: conventional commit format, imperative mood, lowercase
- Body: bullets, not paragraphs. Focus on "why" not "what"
- If there are uncommitted changes, warn before proceeding
- If there are no commits ahead of base, abort
- **ALWAYS show preview and wait for confirmation before push/create**
- Push the branch before creating the PR
- Return the PR URL when done
