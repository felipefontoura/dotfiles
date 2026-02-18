Analyze all changes and create atomic commits in logical order.

## Instructions

1. Run `git status` to see staged, unstaged, and untracked files
2. Run `git diff` (unstaged) and `git diff --cached` (staged) to read all changes
3. Check untracked files for relevance (ignore build artifacts, node_modules, etc.)
4. Group changes into logical atomic commits
5. Present the full commit plan and ask for confirmation
6. Execute each commit in order

## Grouping Order

Commit in dependency order — foundations first, consumers last:

1. **Schema/migrations** — DB tables, enums, indexes, relations
2. **Types/interfaces** — Shared types, Zod schemas, contracts
3. **Services/lib** — Business logic, utilities, helpers
4. **Routes/API** — Endpoints, middleware, plugins
5. **Components/UI** — React components, stories, styles
6. **Tests** — Unit, integration, e2e tests for the above
7. **Config/chore** — ESLint, tsconfig, package.json, Dockerfile, CI
8. **Docs** — README, CLAUDE.md, .claude/ docs, comments

If all changes fit a single logical group, make one commit.

## Scope Detection

Infer scope from file paths:

| Path contains | Scope |
|---------------|-------|
| `db/schema`, `db/migrations` | `db` |
| `routes/`, `schemas/` (API) | `api` |
| `services/` | `api` |
| `packages/ui/` | `ui` |
| `packages/auth/` | `auth` |
| `apps/payment/checkout/` | `checkout` |
| `apps/payment/merchant/` | `merchant` |
| `apps/payment/customer/` | `customer` |
| `apps/payment/admin/` | `admin` |
| `apps/exchange/` | `exchange` |
| `infrastructure/` | `infra` |
| `.github/` | `ci` |
| Multiple areas | most relevant or omit scope |

## Commit Message Format

Single line, no body, conventional commit:

```
type(scope): concise description in imperative mood
```

- **Types:** `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `style`, `perf`
- Lowercase, no period, under 72 chars
- Imperative mood: "add" not "added"/"adds"

## Plan Format

Present a clean, message-focused plan. Files go in a collapsed detail — the commits are the star:

```
## Commit Plan (X commits)

1. `refactor(api): extract shared BACEN PIX types`
2. `feat(api): add Sicredi PIX provider with mTLS support`
3. `test(api): add Sicredi provider unit tests`
4. `chore(infra): add Sicredi environment variables`
5. `docs: add Claude Code commands and skills`

<details>
<summary>Files per commit</summary>

1. bacen.types.ts, types.ts, c6bank.provider.ts, fixtures/c6bank.ts
2. sicredi.provider.ts, index.ts, env.ts, server.ts, webhooks.ts
3. sicredi.provider.test.ts, fixtures/sicredi.ts, fixtures/index.ts
4. .env.example, configmap.yaml, main.tf, variables.tf
5. .claude/commands/, .claude/skills/

</details>

Proceed?
```

- List only commit messages in the main view (numbered)
- Show filenames (basename only, no full paths) inside a collapsed `<details>` block
- Keep it scannable — the user should see the story of commits at a glance

## Safety Rules

- **NEVER** commit `.env`, credentials, secrets, private keys — warn and skip
- **NEVER** commit `node_modules/`, `dist/`, `coverage/`, build artifacts
- **ALWAYS** show the plan and wait for user confirmation before executing
- Each commit should not break the build in isolation when possible
- If there are no changes, say so and stop
- Do NOT amend existing commits
- Do NOT push — only commit locally
