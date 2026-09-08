# Apex and trigger review

## Bulkification and governors

- No SOQL, SOSL, or DML inside `for`/`while` loops. Collect IDs, query once, DML once.
- No DML or queries inside `@AuraEnabled`/`@Http*` methods that iterate request lists without aggregation.
- Avoid querying inside loops over `Trigger.new`, related lists, or JSON payloads.
- Heap: do not load unbounded child collections. Use selective filters and indexed fields.
- CPU: move heavy work to Queueable/Batch when a trigger cannot finish within limits.
- Callouts: never from a trigger directly if a DML has occurred; use async with callout-enabled Queueable. Cap callouts per transaction.

## Sharing and CRUD/FLS

- Default to `with sharing` (or inherited sharing on utility classes).
- `without sharing` requires a comment explaining why, plus explicit user-mode enforcement at the entry point.
- User-facing CRUD must use `WITH USER_MODE`, `Security.stripInaccessible`, or equivalent. `WITH SECURITY_ENFORCED` is acceptable for simple reads; it throws rather than stripping.
- Prefer `Database` DML/query overloads that take `AccessLevel.USER_MODE` (or `AccessLevel.SYSTEM_MODE` only when system mode is intentional and documented).
- System-mode service code that bypasses sharing must not expose stripped-inaccessible fields back to Lightning/LWC.

## Injection and dynamic code

- Bind variables in SOQL/SOSL. `String.escapeSingleQuotes` is not enough for all dynamic SOQL.
- Do not pass client input into `Database.query`, `Search.query`, or dynamic DML field maps without allowlists.
- Avoid `Type.forName` + `JSON.deserialize` of untrusted types.

## Triggers

- One trigger per object. No logic in the trigger body beyond handing off to a handler.
- Recursion guards for workflows that update the same object.
- Handle `before` vs `after` correctly: before for field updates on `Trigger.new`, after for DML on other objects and async.
- Do not put callouts, email, or extra DML in `before` without a documented reason.

## API and async

- Prefer Queueable over `@future` when chaining or large payloads are needed.
- Queueable chains must stay within platform depth limits; Batch Apex should own large fan-out work.
- `@AuraEnabled(cacheable=true)` methods must be read-only (no DML).
- REST/SOAP classes: enforce auth, CRUD/FLS, and input validation. Return generic errors to clients.
- Named Credentials / External Credentials for callouts. No endpoint + secret in code.
- Platform Events and Change Data Capture subscribers must be bulk-safe and idempotent.

## Maintainability

- No hardcoded Salesforce IDs. Use Custom Metadata, Custom Settings, or Custom Labels.
- Catch blocks must log and rethrow or convert to a user-safe error. Empty `catch` is a finding.
- Keep classes focused. New business logic belongs in service/domain layers, not triggers or controllers.
