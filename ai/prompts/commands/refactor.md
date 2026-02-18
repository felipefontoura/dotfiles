Analyze $ARGUMENTS and suggest refactoring opportunities.

## Instructions

1. Read the target file(s) or directory specified
2. Identify code smells, complexity issues, and duplication
3. Suggest specific refactoring techniques with before/after examples
4. Ensure suggestions preserve existing behavior (no functional changes)

## What to Look For

### Code Smells
- Long functions (>30 lines)
- Deep nesting (>3 levels)
- Large parameter lists (>3 params)
- Feature envy (accessing other object's data too much)
- Primitive obsession (strings/numbers instead of domain types)
- Duplicate code (copy-paste patterns)

### Complexity
- Cyclomatic complexity (too many branches)
- Cognitive complexity (hard to follow logic)
- God objects/functions (doing too many things)

### Design Issues
- Tight coupling between modules
- Violation of single responsibility
- Missing abstractions
- Inconsistent patterns within the codebase
- Dead code or unused imports

### Naming
- Vague names (data, info, item, result)
- Misleading names (function name doesn't match behavior)
- Inconsistent naming conventions

## Output Format

```
## Refactoring Analysis: {target}

### Summary
- Code Smells: X | Complexity: X | Design: X | Naming: X

### Findings

#### 1. {title} ({file}:{line})
- **Type:** {code smell / complexity / design / naming}
- **Severity:** {high / medium / low}
- **Description:** {what's wrong}
- **Technique:** {Extract Method / Rename / Introduce Parameter Object / etc.}

**Before:**
```{lang}
{current code}
```

**After:**
```{lang}
{suggested refactoring}
```

### Priority Order
1. {most impactful refactoring first}
2. {next}

### Notes
- {any risks or considerations}
```

## Rules

- Do NOT modify any files - only suggest changes
- Suggestions must NOT change external behavior
- Prioritize by impact: readability > maintainability > performance
- Be pragmatic - not every pattern needs refactoring
- If no target is specified, ask the user what to analyze
