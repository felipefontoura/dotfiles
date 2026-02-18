Create a comprehensive test plan for $ARGUMENTS.

## Instructions

1. Read the target file(s) or directory specified
2. Identify all testable behaviors (functions, routes, components, schemas)
3. For each, list happy path, edge cases, and error scenarios
4. Suggest appropriate test types (unit, integration, e2e)
5. If project has testing conventions (CLAUDE.md or test config), follow them

## Test Categories

### Unit Tests
- Individual functions and methods
- Pure logic, transformations, validations
- Schema structure and constraints
- Component rendering and interactions

### Integration Tests
- API routes with database
- Service interactions
- Middleware chains
- Component + API integration

### E2E Tests
- Full user flows
- Cross-service interactions
- Browser-based scenarios

## Output Format

```
## Test Plan: {target}

### Overview
{what is being tested, current coverage if detectable}

### Test Cases

#### {function/route/component name}

**Happy Path:**
- [ ] {scenario} - {expected result}
- [ ] {scenario} - {expected result}

**Edge Cases:**
- [ ] {scenario} - {expected result}
- [ ] {scenario} - {expected result}

**Error Cases:**
- [ ] {scenario} - {expected result}
- [ ] {scenario} - {expected result}

### Test Structure Suggestion

```typescript
describe("{subject}", () => {
  describe("{group}", () => {
    it("should {behavior}", () => {
      // {brief setup/assertion hint}
    });
  });
});
```

### Dependencies
- {mocks, fixtures, factories needed}

### Priority
1. {highest priority tests to write first}
2. {next priority}
```

## Rules

- Do NOT write or modify any files - only produce the plan
- Be specific about assertions - not just "should work"
- Consider both positive and negative test cases
- Include boundary values and null/undefined handling
- If no target is specified, ask the user what to plan tests for
