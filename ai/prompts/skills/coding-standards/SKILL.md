---
trigger: When writing or modifying code in any project
---

# Coding Standards

Apply these principles when writing or modifying code.

## Clean Code

- **Meaningful names:** Variables, functions, and classes should reveal intent. Avoid abbreviations, single letters (except loop counters), and generic names like `data`, `info`, `item`.
- **Small functions:** Each function should do one thing. If you need to describe what it does with "and", it's doing too much.
- **DRY but pragmatic:** Don't repeat yourself, but don't create premature abstractions for two similar lines. Three is a pattern.
- **Avoid comments for "what":** Code should be self-documenting. Comments should explain "why", not "what".
- **No dead code:** Remove unused variables, functions, and imports. Don't comment out code.

## SOLID Principles

- **S - Single Responsibility:** A module/class/function should have one reason to change.
- **O - Open/Closed:** Open for extension, closed for modification. Use composition over inheritance.
- **L - Liskov Substitution:** Subtypes must be substitutable for their base types.
- **I - Interface Segregation:** Many specific interfaces are better than one general-purpose interface.
- **D - Dependency Inversion:** Depend on abstractions, not concretions.

## Error Handling

- Handle errors at the appropriate level (not too early, not too late).
- Provide meaningful error messages that help debugging.
- Don't swallow errors silently. Either handle or propagate.
- Use typed errors when the language supports it.
- Validate at system boundaries (user input, external APIs), trust internal code.

## TypeScript Specifics

- Avoid `any`. Use `unknown` when type is truly unknown.
- Prefer type inference when types are obvious from context.
- Use discriminated unions for state management.
- Use `as const` for literal types.
- Export types alongside their implementations.
