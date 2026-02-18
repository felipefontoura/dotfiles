Perform a security audit of $ARGUMENTS.

## Instructions

1. Read the target file(s) or directory specified
2. Analyze against OWASP Top 10 and common vulnerability patterns
3. Check for secrets, credentials, and sensitive data exposure
4. Report findings with severity levels and remediation guidance

## Checklist

### A. Injection
- [ ] SQL injection (raw queries, string concatenation)
- [ ] NoSQL injection
- [ ] Command injection (exec, spawn, system calls)
- [ ] LDAP injection
- [ ] Template injection (SSTI)

### B. Authentication & Authorization
- [ ] Missing auth checks on routes/endpoints
- [ ] Broken access control (IDOR, privilege escalation)
- [ ] Hardcoded credentials or tokens
- [ ] Weak session management
- [ ] Missing CSRF protection

### C. Data Exposure
- [ ] Sensitive data in logs (passwords, tokens, PII)
- [ ] Sensitive data in error messages
- [ ] Missing encryption for sensitive fields
- [ ] Overly permissive CORS
- [ ] Exposed internal paths or stack traces

### D. Input Validation
- [ ] Missing input validation/sanitization
- [ ] XSS (reflected, stored, DOM-based)
- [ ] Path traversal
- [ ] File upload without validation
- [ ] Missing rate limiting

### E. Configuration
- [ ] Debug mode enabled in production code
- [ ] Insecure defaults
- [ ] Missing security headers
- [ ] Exposed .env or config files
- [ ] Outdated dependencies with known CVEs

### F. Cryptography
- [ ] Weak hashing algorithms (MD5, SHA1 for passwords)
- [ ] Predictable random values for security contexts
- [ ] Missing HTTPS enforcement
- [ ] Insecure key storage

## Output Format

```
## Security Audit: {target}

### Summary
- Critical: X | High: X | Medium: X | Low: X | Info: X

### Findings

#### [CRITICAL] {title}
- **Location:** {file}:{line}
- **Category:** {OWASP category}
- **Description:** {what's wrong}
- **Impact:** {what could happen}
- **Remediation:** {how to fix}

#### [HIGH] ...
#### [MEDIUM] ...
#### [LOW] ...
#### [INFO] ...

### Recommendations
{prioritized action items}
```

## Rules

- Do NOT modify any files - this is read-only analysis
- Prioritize findings by severity and exploitability
- Include specific remediation steps for each finding
- If no target is specified, ask the user what to audit
