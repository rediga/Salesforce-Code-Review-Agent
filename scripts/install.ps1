#Requires -Version 5.1
<#
.SYNOPSIS
  Install the Salesforce Code Review Agent into a Salesforce DX project or Cursor.

.EXAMPLE
  .\scripts\install.ps1 -Target "C:\path\to\sfdx-project"

.EXAMPLE
  .\scripts\install.ps1 -Scope UserPlugin

.EXAMPLE
  .\scripts\install.ps1 -Scope UserSkills
#>
[CmdletBinding()]
param(
    [ValidateSet("Project", "UserPlugin", "UserSkills")]
    [string]$Scope = "Project",

    [string]$Target
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot

function Copy-Tree {
    param([string]$From, [string]$To)
    if (-not (Test-Path $From)) {
        throw "Missing source path: $From"
    }
    New-Item -ItemType Directory -Force -Path $To | Out-Null
    Copy-Item -Path (Join-Path $From "*") -Destination $To -Recurse -Force
}

switch ($Scope) {
    "Project" {
        if (-not $Target) {
            throw "Pass -Target <path-to-salesforce-dx-project> when -Scope Project"
        }
        $Target = (Resolve-Path $Target).Path
        if (-not (Test-Path (Join-Path $Target "sfdx-project.json")) -and
            -not (Test-Path (Join-Path $Target "force-app"))) {
            Write-Warning "Target does not look like a Salesforce DX project (no sfdx-project.json or force-app). Continuing anyway."
        }

        Copy-Tree (Join-Path $RepoRoot ".cursor\skills") (Join-Path $Target ".cursor\skills")
        Copy-Tree (Join-Path $RepoRoot ".cursor\agents") (Join-Path $Target ".cursor\agents")
        Copy-Tree (Join-Path $RepoRoot ".cursor\commands") (Join-Path $Target ".cursor\commands")
        Copy-Tree (Join-Path $RepoRoot ".cursor\rules") (Join-Path $Target ".cursor\rules")

        $bugbot = Join-Path $Target "BUGBOT.md"
        if (-not (Test-Path $bugbot)) {
            Copy-Item (Join-Path $RepoRoot "BUGBOT.md") $bugbot
        }

        $agentsMd = Join-Path $Target "AGENTS.md"
        $template = Join-Path $RepoRoot "templates\AGENTS.md"
        if (-not (Test-Path $agentsMd)) {
            Copy-Item $template $agentsMd
        }

        Write-Host "Installed Salesforce Code Review Agent into $Target"
        Write-Host "Reload Cursor (Developer: Reload Window), then in Agent chat type /review-salesforce"
    }

    "UserPlugin" {
        $dest = Join-Path $env:USERPROFILE ".cursor\plugins\local\salesforce-code-review"
        if (Test-Path $dest) {
            Remove-Item $dest -Recurse -Force
        }
        New-Item -ItemType Directory -Force -Path $dest | Out-Null
        Get-ChildItem -Force $RepoRoot | Where-Object {
            $_.Name -notin @(".git", ".gitignore")
        } | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination (Join-Path $dest $_.Name) -Recurse -Force
        }
        Write-Host "Installed local Cursor plugin at $dest"
        Write-Host "Enable third-party plugins if needed, then run Developer: Reload Window"
        Write-Host "Confirm it appears under Customize > Plugins"
    }

    "UserSkills" {
        Copy-Tree (Join-Path $RepoRoot ".cursor\skills\salesforce-code-review") (Join-Path $env:USERPROFILE ".cursor\skills\salesforce-code-review")
        New-Item -ItemType Directory -Force -Path (Join-Path $env:USERPROFILE ".cursor\agents") | Out-Null
        Copy-Item (Join-Path $RepoRoot ".cursor\agents\salesforce-code-reviewer.md") (Join-Path $env:USERPROFILE ".cursor\agents\salesforce-code-reviewer.md") -Force
        Write-Host "Installed personal skill and subagent for this Windows user"
        Write-Host "Reload Cursor. Invoke with /salesforce-code-review"
    }
}
