Merge a GitHub pull request and clean up the branch.

## Instructions

1. Detect the current branch: `git branch --show-current`
2. Find the PR for this branch: `gh pr view --json number,title,state,mergeable,reviews,statusCheckRollup`
3. If $ARGUMENTS is a PR number, use that instead
4. Verify PR is mergeable (checks passing, approved)
5. Show PR summary and ask for confirmation
6. Merge and clean up

## Pre-merge Checks

- PR state is `OPEN`
- Status checks are passing
- PR is approved (or no reviews required)
- No merge conflicts

If any check fails, report what's wrong and stop.

## Merge Flow

```bash
gh pr merge {number} --squash --delete-branch
git checkout main
git pull
```

## Output Format

```
## Merge: #{number} {title}

- Checks: passing
- Reviews: approved
- Method: squash

Merge and delete branch?
```

After merge:

```
Merged #{number} into main
Branch {branch} deleted (local + remote)
Now on main (up to date)
```

## Rules

- Default merge method: squash (project convention)
- Always delete branch after merge (local + remote)
- Always checkout main and pull after merge
- If no PR found for current branch, say so
- Do NOT merge without user confirmation
