Explain the code at $ARGUMENTS in detail.

## Instructions

1. Read the target file(s) specified
2. Identify the purpose and role of the code
3. Trace the execution flow
4. Explain design decisions and patterns used
5. Map dependencies (imports, calls, data flow)
6. Highlight important details and potential gotchas

## Analysis Structure

### 1. Purpose
What does this code do? What problem does it solve? Where does it fit in the system?

### 2. Execution Flow
Step-by-step walkthrough of how the code executes, from entry point to output.

### 3. Key Components
Break down the main parts (functions, classes, hooks, routes) and explain each.

### 4. Design Decisions
Why was it built this way? What patterns are used (Factory, Strategy, Observer, etc.)?

### 5. Dependencies
- **Imports:** What external/internal modules does it use and why?
- **Consumers:** What other code depends on this? (search for imports/references)
- **Data flow:** Where does data come from and where does it go?

### 6. Points of Attention
- Complex logic that needs careful handling
- Edge cases or assumptions
- Potential failure modes
- Performance considerations

## Output Format

```
## Explanation: {target}

### Purpose
{1-2 paragraphs}

### Flow
1. {step}
2. {step}
...

### Key Components

#### `{name}` ({file}:{line})
{explanation}

### Design Decisions
- {decision}: {rationale}

### Dependencies
- **Uses:** {list}
- **Used by:** {list}

### Points of Attention
- {item}
```

## Rules

- Do NOT modify any files - this is read-only analysis
- Use clear, accessible language - avoid unnecessary jargon
- Include file:line references for key pieces
- If no target is specified, ask the user what to explain
