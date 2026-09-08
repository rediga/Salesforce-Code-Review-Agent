# Salesforce review (Bugbot / Agent Review)

When reviewing this repository or a Salesforce DX project that includes these rules:

- Treat SOQL/DML in loops, missing CRUD/FLS, SOQL injection, hardcoded secrets, and LWC XSS as bugs, not style.
- Prefer findings with `file:line` and a Salesforce-specific fix (Apex bind variable, `USER_MODE`, collection DML, Named Credential).
- Ignore generated `*.cls-meta.xml` noise unless permissions or API version are wrong.
- Do not suggest changing Salesforce User Title, Manager, Name, or org-specific role fields.

Use the checklists in `.cursor/skills/salesforce-code-review/references/`.
