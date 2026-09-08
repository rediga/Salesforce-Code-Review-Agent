# Salesforce Code Review Agent

This repository is a Cursor plugin and project skill pack. It is not a Salesforce DX app.

When you copy `.cursor/` into a Salesforce project, Cursor should:

- Use the `salesforce-code-review` skill for Apex, LWC, Flow, and metadata reviews
- Delegate to the `salesforce-code-reviewer` subagent for isolated, read-only reviews
- Follow the rules in `.cursor/rules/` when those file types are in scope

Do not edit, deploy, or commit during a review unless the user asks for fixes afterward.
