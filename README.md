# Salesforce Code Review Agent

A [Cursor](https://cursor.com) agent that reviews Salesforce DX source the way a platform architect would: Apex, Lightning Web Components, Aura, Flows, and metadata.

It packages:

- A **skill** (`/salesforce-code-review`) with checklists for governors, CRUD/FLS, injection, tests, LWC XSS, and Flow bulkification
- A read-only **subagent** (`salesforce-code-reviewer`) so reviews run in their own context
- A **slash command** (`/review-salesforce`)
- **Rules** that apply when Apex, LWC, or Flow files are in scope
- `BUGBOT.md` so Cursor Agent Review / Bugbot uses the same Salesforce bar

Repository: [github.com/rediga/Salesforce-Code-Review-Agent](https://github.com/rediga/Salesforce-Code-Review-Agent)

## Prerequisites

- [Cursor](https://cursor.com) (desktop)
- Git
- A Salesforce DX project (`sfdx-project.json` and usually `force-app/`) if you are installing into a project
- Optional: [Salesforce CLI](https://developer.salesforce.com/tools/salesforcecli) and Code Analyzer, if you want the agent to merge scanner output into the report

## Install

Pick one path. **Project install** is the usual choice for a team Salesforce repo.

### 1. Clone this repository

```powershell
git clone https://github.com/rediga/Salesforce-Code-Review-Agent.git
cd Salesforce-Code-Review-Agent
```

macOS / Linux:

```bash
git clone https://github.com/rediga/Salesforce-Code-Review-Agent.git
cd Salesforce-Code-Review-Agent
chmod +x scripts/install.sh
```

### 2a. Install into a Salesforce DX project (recommended)

Copies skills, the subagent, commands, and rules into that project's `.cursor/` folder. Commit those files so everyone on the repo gets the same reviewer.

Windows (PowerShell):

```powershell
.\scripts\install.ps1 -Target "C:\path\to\your-sfdx-project"
```

macOS / Linux:

```bash
./scripts/install.sh Project /path/to/your-sfdx-project
```

The script also adds `BUGBOT.md` and `AGENTS.md` if those files are not already present.

Then:

1. Open the Salesforce DX project in Cursor.
2. Command Palette → **Developer: Reload Window**.
3. Open **Agent** chat and type `/review-salesforce` to confirm the command appears.

### 2b. Install as a local Cursor plugin (all local projects)

Use this when you want the reviewer on every project on your machine without copying files into each repo.

Windows:

```powershell
.\scripts\install.ps1 -Scope UserPlugin
```

macOS / Linux:

```bash
./scripts/install.sh UserPlugin
```

Then:

1. In Cursor Settings, allow third-party plugins / local plugin imports if your org requires it (Teams and Enterprise: an admin may need to enable **Allow Local Plugin Imports**).
2. Command Palette → **Developer: Reload Window**.
3. Open **Customize → Plugins** and confirm **salesforce-code-review** is listed.

### 2c. Install as personal skills (this Cursor user only)

Windows:

```powershell
.\scripts\install.ps1 -Scope UserSkills
```

macOS / Linux:

```bash
./scripts/install.sh UserSkills
```

This writes:

- `~/.cursor/skills/salesforce-code-review/`
- `~/.cursor/agents/salesforce-code-reviewer.md`

Reload the window. Invoke with `/salesforce-code-review`.

### 2d. Team marketplace (Teams / Enterprise)

The most reliable team rollout is **2a**: commit `.cursor/` into each Salesforce DX repo.

Admins on Teams or Enterprise can also import this GitHub repo from the Cursor Dashboard → **Plugins**. If the import UI expects a multi-plugin marketplace manifest, use **2a** or **2b** instead.

## Use

Open your **Salesforce DX project** in Cursor (not only this agent repo). Then run a review in any of these ways.

### Agent chat

Examples:

- `Review this Apex class for CRUD/FLS and bulkification`
- `Review the current branch against main as a Salesforce code review`
- `Review PR 1234 for Salesforce security issues`
- `/review-salesforce`
- `/salesforce-code-review`

Keep the skill on for the whole session by using it as a **Custom Mode** (Windows: Alt+Enter on the skill, macOS: Option+Enter).

### What the agent reviews

| Area | Typical files | What it checks |
|------|----------------|----------------|
| Apex / triggers | `.cls`, `.trigger` | SOQL/DML in loops, sharing, CRUD/FLS, injection, handler pattern, Named Credentials |
| LWC / Aura | `lwc/`, `aura/` | XSS, cacheable DML, error handling, `@api` mutation, a11y |
| Flows | `.flow-meta.xml` | Collection DML, recursion, fault paths, user vs system context |
| Tests | `*Test.cls`, `test*.cls` | Isolation, asserts, bulk, `runAs`, callout mocks |
| Security metadata | permission sets, guest access, credentials | Least privilege, secrets, Experience Cloud |

### Report shape

You should get a markdown report with:

- **Verdict:** Approve / Approve with comments / Request changes
- A table of findings sorted Critical → Low, with `file:line` and a Salesforce-specific fix
- Notes on tests and residual risk

The subagent is **read-only**. It will not edit or deploy unless you separately ask to apply fixes.

### Agent Review / Bugbot

After project install, `BUGBOT.md` is in the Salesforce repo root.

- Slash: `/agent-review` or `/review-bugbot`
- Or enable Agent Review in **Cursor Settings → Agents** (or **Git & PRs → Pull Requests** on newer Cursor)

### Optional scanner

If Salesforce Code Analyzer is installed, you can ask:

```text
Run sf code-analyzer on the changed Apex and include those results in the review
```

The skill will use the CLI when it is available and will skip it when it is not.

## Update

From this clone:

```powershell
git pull
.\scripts\install.ps1 -Target "C:\path\to\your-sfdx-project"
```

For a user plugin or personal skills install, re-run the same `-Scope` you used originally, then reload Cursor.

## Customize

| Goal | Where |
|------|--------|
| Change review checklists | `.cursor/skills/salesforce-code-review/references/` |
| Change when the subagent is used | `.cursor/agents/salesforce-code-reviewer.md` (`description` field) |
| Org-specific rules (naming, trigger framework) | Add another `.cursor/rules/*.mdc` in the DX project |
| Stop auto-invoking the skill | Set `disable-model-invocation: true` in the skill frontmatter |

Do not put secrets in rules or skills. Named Credential configuration belongs in the org, not in this repo.

## Layout

```text
.cursor-plugin/plugin.json          Cursor plugin manifest
.cursor/skills/salesforce-code-review/
.cursor/agents/salesforce-code-reviewer.md
.cursor/commands/review-salesforce.md
.cursor/rules/                      Apex, LWC, Flow, security
scripts/install.ps1                 Windows installer
scripts/install.sh                  macOS / Linux installer
templates/AGENTS.md                 Copied into DX projects if missing
BUGBOT.md                           Agent Review / Bugbot guidance
```

## License

MIT. See [LICENSE](LICENSE).
