Create a pull request on GitHub for the current branch.

## Instructions

1. Run `git status` to check for uncommitted changes (warn if any)
2. Detect the base branch: `main` unless configured otherwise
3. Run `git log {base}..HEAD --oneline` to see commits
4. Run `git diff {base}...HEAD --stat` to see changed files
5. Run `git diff {base}...HEAD` to read the full diff
6. Check if branch is pushed: `git rev-parse --abbrev-ref --symbolic-full-name @{u}`
7. Analyze all commits (not just latest) and generate PR content
8. Push branch if needed: `git push -u origin HEAD`
9. Create PR with `gh pr create`

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

## Rules

- Read ALL commits on the branch, not just the latest
- Do not invent changes - only describe what the diff shows
- Title: conventional commit format, imperative mood, lowercase
- Body: bullets, not paragraphs. Focus on "why" not "what"
- If there are uncommitted changes, warn before proceeding
- If there are no commits ahead of base, abort
- Push the branch before creating the PR
- Return the PR URL when done
