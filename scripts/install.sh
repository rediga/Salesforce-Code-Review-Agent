#!/usr/bin/env bash
set -euo pipefail

SCOPE="${1:-Project}"
TARGET="${2:-}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

copy_tree() {
  local from="$1"
  local to="$2"
  mkdir -p "$to"
  cp -R "$from"/. "$to"/
}

case "$SCOPE" in
  Project)
    if [[ -z "$TARGET" ]]; then
      echo "Usage: ./scripts/install.sh Project /path/to/sfdx-project" >&2
      exit 1
    fi
    TARGET="$(cd "$TARGET" && pwd)"
    if [[ ! -f "$TARGET/sfdx-project.json" && ! -d "$TARGET/force-app" ]]; then
      echo "Warning: target does not look like a Salesforce DX project. Continuing." >&2
    fi
    copy_tree "$ROOT/.cursor/skills" "$TARGET/.cursor/skills"
    copy_tree "$ROOT/.cursor/agents" "$TARGET/.cursor/agents"
    copy_tree "$ROOT/.cursor/commands" "$TARGET/.cursor/commands"
    copy_tree "$ROOT/.cursor/rules" "$TARGET/.cursor/rules"
    [[ -f "$TARGET/BUGBOT.md" ]] || cp "$ROOT/BUGBOT.md" "$TARGET/BUGBOT.md"
    [[ -f "$TARGET/AGENTS.md" ]] || cp "$ROOT/templates/AGENTS.md" "$TARGET/AGENTS.md"
    echo "Installed Salesforce Code Review Agent into $TARGET"
    echo "Reload Cursor (Developer: Reload Window), then in Agent chat type /review-salesforce"
    ;;
  UserPlugin)
    DEST="${HOME}/.cursor/plugins/local/salesforce-code-review"
    rm -rf "$DEST"
    mkdir -p "$DEST"
    for name in .cursor .cursor-plugin AGENTS.md BUGBOT.md LICENSE README.md scripts templates; do
      if [[ -e "$ROOT/$name" ]]; then
        cp -R "$ROOT/$name" "$DEST/$name"
      fi
    done
    echo "Installed local Cursor plugin at $DEST"
    echo "Enable third-party plugins if needed, then run Developer: Reload Window"
    ;;
  UserSkills)
    copy_tree "$ROOT/.cursor/skills/salesforce-code-review" "${HOME}/.cursor/skills/salesforce-code-review"
    mkdir -p "${HOME}/.cursor/agents"
    cp "$ROOT/.cursor/agents/salesforce-code-reviewer.md" "${HOME}/.cursor/agents/salesforce-code-reviewer.md"
    echo "Installed personal skill and subagent"
    echo "Reload Cursor. Invoke with /salesforce-code-review"
    ;;
  *)
    echo "Usage: ./scripts/install.sh [Project /path/to/sfdx-project | UserPlugin | UserSkills]" >&2
    exit 1
    ;;
esac
