# Flow and orchestration review

## Bulkification

- Record-triggered flows must not perform Get/Update/Create/Delete inside a loop over a collection that could be bulk-invoked.
- Use Assignment + single DML elements on collections.
- Before-save flows: field updates only. No DML on other objects, no callouts, no email.

## Recursion and entry

- Entry conditions should be selective (changed fields, status gates). Unfiltered `isChanged` on many fields causes extra interviews.
- After-save flows that update the triggering record need a recursion path or a guard field.
- Avoid overlapping workflow, process builder, trigger, and flow on the same object doing the same update.
- Scheduled and autolaunched flows that query large sets must filter early and DML in collections, not per-record loops.
- Record-triggered entry criteria that fire on every edit of high-volume objects are a governor risk — prefer formula/status gates.

## Faults and security

- Every DML, Get Records, and Action needs a Fault path or a documented reason.
- Run in user context unless a documented reason requires system context. System context bypasses sharing.
- Do not query or update objects the running user should not see. Pair with permission sets, not hidden screens.
- Subflows that perform DML inherit bulk and sharing risk — review them as part of the parent.

## Callouts and async

- HTTP callouts belong in invocable Apex with Named Credentials, or in async paths that cannot hit mixed DML/callout limits.
- Screen flows: do not perform DML on Next unless the transaction is clearly bounded.
- Pause / Wait / Resume paths must re-check entry conditions and sharing when they continue; do not assume prior interview state is still valid.

## Maintainability

- Names should describe the object + reason (`Account_After_Update_Set_Owner`).
- Version description should say what changed. Unused versions and dead decision outcomes are noise — mention them, do not block on them unless they are reachable.
