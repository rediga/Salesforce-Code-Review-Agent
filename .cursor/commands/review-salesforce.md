---
name: review-salesforce
description: Run a Salesforce code review on the current diff, branch, or named files.
---

# Review Salesforce code

Review the current Salesforce changes using the `salesforce-code-review` skill and the `salesforce-code-reviewer` subagent.

## Scope

1. If the user named files, a class, a PR, or a branch, review that.
2. Otherwise review uncommitted changes. If the working tree is clean, review branch changes against the repository default base branch.
3. Include Apex (`.cls`, `.trigger`), LWC, Aura, Flows, permission sets, profiles, custom metadata, and named/external credentials when they appear in the diff.

## Rules

- Read-only. Do not edit, deploy, or commit.
- Follow `.cursor/skills/salesforce-code-review/SKILL.md`.
- Return the report template from that skill.
- Severity-order findings. Cite `file:line`. Suggest a concrete fix for each finding.
