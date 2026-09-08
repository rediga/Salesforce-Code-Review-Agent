# Security review

## Secrets and endpoints

- No passwords, tokens, private keys, or refresh tokens in Apex, LWC, custom metadata samples, or repo files.
- Callouts must use Named Credentials / External Credentials / Auth Providers. Hardcoded hosts plus secrets are Critical.
- `Remote Site Settings` alone is not an auth strategy.

## CRUD, FLS, sharing

- Every user-facing read/write path must enforce object CRUD and field FLS.
- `without sharing` + query of Person Accounts, Cases, Health, or custom PII is High/Critical unless scoped and documented.
- Inner classes, selectors, and "util" DAOs inherit the caller’s sharing only if declared `inherited sharing`.

## Injection and XSS

- Dynamic SOQL/SOSL: bind variables or allowlisted field/object names.
- LWC/Aura: no untrusted HTML. Encode output. Avoid `lwc:dom="manual"` unless required.
- Email / PageReference / `window.open` URLs must be allowlisted.

## Permissions metadata

- New permission sets should be least-privilege. Flag `Modify All Data`, `View All Data`, `Author Apex`, `Manage Users`, `Password Never Expires` on unexpected personas.
- Guest / Experience Cloud profiles: no object access beyond the published site contract. No Apex that trusts the guest user without captcha/rate limits where relevant.
- Do not grant CRUD on `User` beyond what the persona needs.

## Insecure Apex patterns

- `SeeAllData=true` in tests that touch production-like data.
- `Test.isRunningTest()` branches that skip security checks.
- Crypto with hardcoded IVs/keys. Use Platform Encryption / Protect / Named Credentials instead.
- Debug logs that print PII, tokens, or full request bodies.

## Auth Z on User records

- Reviews must not recommend anonymous Apex or MCP updates to `User.Title`, `ManagerId`, `Name`, or org-specific role fields. Those belong to HR/Workday or a governed change-request process.
