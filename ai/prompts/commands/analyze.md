Analyze the code quality of $ARGUMENTS.

## Instructions

1. Read the target file(s) or directory specified
2. Evaluate multiple quality dimensions
3. Identify technical debt and areas for improvement
4. Provide actionable recommendations

## Quality Dimensions

### 1. Complexity
- Function/method length
- Cyclomatic complexity (branches, loops)
- Nesting depth
- Number of parameters

### 2. Coupling
- Import dependencies (fan-in, fan-out)
- Direct references to external modules
- Shared mutable state
- God objects or modules

### 3. Cohesion
- Single responsibility adherence
- Related functionality grouped together
- Unrelated concerns mixed in same file/module

### 4. Conventions
- Consistency with project patterns
- Naming conventions followed
- File organization aligned with project structure
- Import ordering

### 5. Technical Debt
- TODO/FIXME/HACK comments
- Workarounds or temporary solutions
- Outdated patterns vs modern alternatives
- Missing types or `any` usage (TypeScript)

### 6. Documentation
- Public API documented
- Complex logic explained
- Types serving as documentation
- Missing context for non-obvious decisions

## Output Format

```
## Quality Analysis: {target}

### Scores

| Dimension | Score | Notes |
|-----------|-------|-------|
| Complexity | X/10 | ... |
| Coupling | X/10 | ... |
| Cohesion | X/10 | ... |
| Conventions | X/10 | ... |
| Tech Debt | X/10 | ... |
| Documentation | X/10 | ... |

### Overall: X/10

### Key Findings

#### Strengths
- {what's done well}

#### Issues
- **{dimension}:** {file}:{line} - {description}

### Technical Debt Items
1. {item} - Effort: {low/medium/high} - Impact: {low/medium/high}
2. {item}

### Recommendations
1. {highest priority action}
2. {next priority}

### Metrics
- Files analyzed: X
- Total lines: X
- Average function length: X lines
- Max nesting depth: X
- External dependencies: X
```

## Rules

- Do NOT modify any files - this is read-only analysis
- Be constructive - highlight strengths alongside issues
- Prioritize recommendations by effort vs impact
- If no target is specified, ask the user what to analyze
