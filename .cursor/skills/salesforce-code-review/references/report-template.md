# Report template

```markdown
# Salesforce code review

**Scope:** <branch, PR, or file list>
**Verdict:** Approve | Approve with comments | Request changes

## Findings

| Severity | File:line | Area | Finding | Suggested fix |
|----------|-----------|------|---------|---------------|
| Critical | `force-app/main/default/classes/Foo.cls:42` | Governors | SOQL inside loop over `Trigger.new` | Collect IDs, query once into a Map, then DML once |

## What looks solid

- ...

## Test gaps

- ...

## Residual risk

- ...
```

Rules:

- Sort findings Critical → Low.
- Skip empty sections.
- One row per distinct issue. Group repeats with "also `Bar.cls:18`".
- Suggested fix must be implementable in Salesforce (Apex/LWC/Flow), not generic advice.
