---
name: salesforce-code-review
description: Reviews Salesforce DX changes for Apex, Lightning Web Components, Flows, and metadata against security, governor limits, bulkification, CRUD/FLS, and test standards. Use when reviewing pull requests, diffs, Apex classes, triggers, LWC, Aura, Flows, or when the user asks for a Salesforce code review.
icon: shield
color: orange
---

# Salesforce code review

Review Salesforce source the way a platform architect would. Read this file first, then open only the reference files you need.

## When to use

- User asks to review Salesforce / Apex / LWC / Flow / metadata
- A PR or diff includes `force-app/`, `.cls`, `.trigger`, `lwc/`, `aura/`, or `.flow-meta.xml`
- Agent just wrote Salesforce code and should verify it before deploy

## Workflow

1. **Scope the review**
   - Named files, class, PR, or branch if the user provided one
   - Else uncommitted changes
   - Else branch changes vs the default base branch (`main` / `master` / `develop`)
2. **Read the diff**, then enough surrounding code to judge bulkification, sharing, and CRUD/FLS.
3. **Load references as needed**
   - Apex / triggers → [references/apex.md](references/apex.md)
   - LWC / Aura → [references/lwc.md](references/lwc.md)
   - Flow / orchestration → [references/flow.md](references/flow.md)
   - Security / credentials / permissions → [references/security.md](references/security.md)
   - Tests → [references/tests.md](references/tests.md)
   - Report shape → [references/report-template.md](references/report-template.md)
4. **Report only.** Do not edit, deploy, or commit unless the user asks for fixes after the review.

## What to flag first

| Priority | Look for |
|----------|----------|
| Critical | SOQL/SOSL/DML in loops on trigger paths; missing sharing on sensitive queries; injection; secrets; XSS via `innerHTML` / `lwc:dom="manual"` |
| High | Missing CRUD/FLS (`USER_MODE` / `AccessLevel.USER_MODE` / `stripInaccessible` / `SECURITY_ENFORCED`); Flow DML in loops; guest-user access; callouts without Named Credentials |
| Medium | Hardcoded record IDs; `@future` where Queueable is safer; non-idempotent Platform Event subscribers; tests without assertions or bulk setup; `SeeAllData=true` |
| Low | Naming, comments, unused code, optional refactors |

## Salesforce-specific constraints

- Prefer `with sharing` plus explicit CRUD/FLS. `without sharing` needs a written reason and still must enforce FLS when running as a user.
- Bind SOQL variables. Never concatenate user or request input into a query string.
- One trigger per object, logic in a handler. Triggers must be bulk-safe.
- No hardcoded credentials, private keys, or org-specific IDs in source.
- Do not change Salesforce `User.Title`, `ManagerId`, `Name`, or org-specific role fields as part of a review or a "helpful" fix.

## Optional static analysis

If the Salesforce CLI and Code Analyzer are installed, you may run a read-only scan and merge results into the report:

```bash
sf code-analyzer run --target <changed-paths> --view table
```

If the scanner is missing, continue with the checklist. Do not install packages unless the user asks.
