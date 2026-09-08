# LWC and Aura review

## Security

- Never assign untrusted HTML to `innerHTML` or `lwc:dom="manual"` without sanitization.
- Do not use `eval`, `new Function`, or dynamic `import()` of user-controlled URLs.
- `@salesforce/userPermission` / `@salesforce/customPermission` for UI gating is not a substitute for Apex CRUD/FLS.
- Do not store secrets, session IDs, or Named Credential passwords in JS, `localStorage`, or static resources.

## Data and Apex wire-up

- Cacheable `@wire` adapters and `cacheable=true` Apex must not perform DML.
- Prefer Lightning Data Service (`uiRecordApi`) for simple record CRUD; use Apex for complex, sharing-sensitive operations.
- Validate and reduce payload size. Do not return entire objects to the client when a DTO will do.
- Handle `error` from `@wire` and imperative Apex. Show a toast; do not fail silently.

## LWC structure

- Public API (`@api`) should be minimal and documented by usage in the parent.
- Mutating `@api` objects in the child is a bug. Copy, then emit an event.
- Use `lwc:if`/`lwc:elseif`/`lwc:else` (not deprecated `if:true` in new code).
- Keep business rules in Apex when they enforce security or reuse. JS is for presentation and client orchestration.

## Performance

- Avoid rendering huge unvirtualized lists. Use `lightning-datatable` or pagination.
- Debounce expensive `@wire` refreshes and input handlers.
- Do not import the entire `lightning/*` surface when a base component exists.

## Tests and a11y

- Jest tests should cover user-visible behavior and error paths, not only happy Apex mocks.
- Interactive controls need accessible names, keyboard support, and `lightning-*` base components where possible.

## Aura (legacy)

- Flag new Aura components when LWC is viable.
- Check `aura:handler` and application events for unexpected broad coupling.
- Same XSS and Apex CRUD rules as LWC.
