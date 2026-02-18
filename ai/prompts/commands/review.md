Perform an impartial code review of $ARGUMENTS.

## Instructions

1. Read the target file(s) or directory specified
2. If a CLAUDE.md exists in the project root, read it to understand project conventions
3. Analyze the code against the criteria below
4. Rate each criterion from 0-10
5. List specific issues with file:line references
6. Be direct and concise - bullets, not paragraphs

## Criteria

| # | Criterion | What to evaluate |
|---|-----------|-----------------|
| 1 | **Correctness** | Logic errors, edge cases, off-by-one, null handling |
| 2 | **Readability** | Naming, structure, complexity, self-documenting code |
| 3 | **Security** | Injection, XSS, auth bypasses, data exposure, OWASP Top 10 |
| 4 | **Testing** | Coverage, edge cases, meaningful assertions, test quality |
| 5 | **Conventions** | Adherence to project CLAUDE.md and standard patterns |
| 6 | **Error Handling** | Graceful failures, meaningful messages, recovery |
| 7 | **Performance** | N+1 queries, unnecessary allocations, algorithmic complexity |
| 8 | **Maintainability** | Coupling, cohesion, single responsibility, extensibility |

## Output Format

```
## Review: {target}

| Criterion | Score | Note |
|-----------|-------|------|
| Correctness | X/10 | {one short phrase} |
| Readability | X/10 | {one short phrase} |
| Security | X/10 | {one short phrase} |
| Testing | X/10 | {one short phrase} |
| Conventions | X/10 | {one short phrase} |
| Error Handling | X/10 | {one short phrase} |
| Performance | X/10 | {one short phrase} |
| Maintainability | X/10 | {one short phrase} |

**Overall: X/10**

### Critical
- `{file}:{line}` - {one sentence max}

### Warnings
- `{file}:{line}` - {one sentence max}

### Suggestions
- `{file}:{line}` - {one sentence max}
```

## Style Rules

- **Be terse.** One sentence per issue. No preamble, no filler.
- Each issue: `file:line` + what's wrong. That's it.
- Notes column in the table: max 6-8 words.
- Skip empty severity sections (no "None." lines).
- No "Summary" section - the table and issues speak for themselves.
- Do NOT explain things the developer already knows.
- Do NOT repeat information that's already in the score table.
- Do NOT modify any files - this is read-only analysis.
- If no target is specified, ask the user what to review.
