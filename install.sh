#!/usr/bin/env bash
# AI-SDLC adapter installer.
#
# Installs adapter routing files into the project root by SYMLINKING them to
# the framework copies under .ai-sdlc/adapters/<vendor>/. Symlinks mean a
# `git pull` inside .ai-sdlc/ updates routing automatically — single source
# of truth, no stale stubs.
#
# If symlinks aren't supported (e.g. Windows without dev mode), falls back to
# copying. Routing files are tiny and stable, so the fallback stays reliable.
#
# Usage:
#   ./install.sh                    # auto-detect installed CLIs and install all matching adapters
#   ./install.sh claude-code        # install one or more named adapters
#   ./install.sh claude-code cursor-cli
#   ./install.sh --check            # report what would be installed; make no changes
#   ./install.sh --uninstall        # remove links/files this installer placed
#   ./install.sh --force            # overwrite existing files at target paths
#
# Run from anywhere; the script resolves its own directory.

set -euo pipefail

FRAMEWORK_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PROJECT_DIR="$(cd -- "$FRAMEWORK_DIR/.." &>/dev/null && pwd)"

CHECK_ONLY=0
UNINSTALL=0
FORCE=0
ADAPTERS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check)     CHECK_ONLY=1; shift ;;
    --uninstall) UNINSTALL=1; shift ;;
    --force)     FORCE=1; shift ;;
    -h|--help)
      sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
      exit 0 ;;
    -*)
      echo "unknown flag: $1" >&2; exit 2 ;;
    *)
      ADAPTERS+=("$1"); shift ;;
  esac
done

# Adapter routing table: source-relative-to-framework -> dest-relative-to-project
# Format: "adapter|src|dest"
ROUTES=(
  "claude-code|adapters/claude-code/skills/sdlc-start.md|.claude/skills/sdlc-start.md"
  "claude-code|adapters/claude-code/agents/sdlc-orchestrator.md|.claude/agents/sdlc-orchestrator.md"
  "cursor-cli|adapters/cursor-cli/sdlc.mdc|.cursor/rules/sdlc.mdc"
  "gemini-cli|adapters/gemini-cli/GEMINI.md|.gemini/GEMINI.md"
  "codex|adapters/codex/AGENTS.md|AGENTS.md"
)

# Auto-detection hints: adapter name -> directory (relative to project) whose
# existence implies the CLI is in use.
detect_adapter() {
  local adapter="$1"
  case "$adapter" in
    claude-code) [[ -d "$PROJECT_DIR/.claude" ]] ;;
    cursor-cli)  [[ -d "$PROJECT_DIR/.cursor" || -f "$PROJECT_DIR/.cursorrules" ]] ;;
    gemini-cli)  [[ -d "$PROJECT_DIR/.gemini" || -f "$PROJECT_DIR/GEMINI.md" ]] ;;
    codex)       [[ -f "$PROJECT_DIR/AGENTS.md" ]] ;;
    *) return 1 ;;
  esac
}

if [[ ${#ADAPTERS[@]} -eq 0 ]]; then
  for a in claude-code cursor-cli gemini-cli codex; do
    if detect_adapter "$a"; then ADAPTERS+=("$a"); fi
  done
  if [[ ${#ADAPTERS[@]} -eq 0 ]]; then
    echo "No CLI projects detected (.claude/, .cursor/, .gemini/, AGENTS.md)."
    echo "Pass adapter names explicitly, e.g.: $0 claude-code cursor-cli"
    exit 1
  fi
  echo "Auto-detected adapters: ${ADAPTERS[*]}"
fi

link_or_copy() {
  local src_abs="$1" dest_abs="$2"
  mkdir -p "$(dirname "$dest_abs")"
  # Try symlink first (relative path keeps the link portable across clones).
  local rel_src
  rel_src="$(python3 -c "import os.path,sys; print(os.path.relpath(sys.argv[1], os.path.dirname(sys.argv[2])))" "$src_abs" "$dest_abs" 2>/dev/null || echo "$src_abs")"
  if ln -s "$rel_src" "$dest_abs" 2>/dev/null; then
    echo "  linked  $dest_abs -> $rel_src"
    return 0
  fi
  # Fallback: copy with a managed-file warning prepended.
  {
    case "$dest_abs" in
      *.json) printf '{ "_managed_by": ".ai-sdlc/install.sh — do not edit; re-run installer to update" }\n' ;;
      *)      printf '<!-- Managed by .ai-sdlc/install.sh — do not edit; re-run installer to update. Source: %s -->\n\n' "$rel_src" ;;
    esac
    cat "$src_abs"
  } > "$dest_abs"
  echo "  copied  $dest_abs (symlink unavailable)"
}

remove_target() {
  local dest_abs="$1"
  if [[ -L "$dest_abs" ]]; then
    rm -f "$dest_abs" && echo "  removed link  $dest_abs"
  elif [[ -f "$dest_abs" ]] && grep -q "Managed by .ai-sdlc/install.sh" "$dest_abs" 2>/dev/null; then
    rm -f "$dest_abs" && echo "  removed copy  $dest_abs"
  elif [[ -e "$dest_abs" ]]; then
    echo "  skipped       $dest_abs (not installer-managed)"
  fi
}

acted=0
for route in "${ROUTES[@]}"; do
  IFS='|' read -r adapter src dest <<<"$route"
  # Skip routes whose adapter wasn't requested.
  match=0
  for a in "${ADAPTERS[@]}"; do [[ "$a" == "$adapter" ]] && match=1; done
  [[ $match -eq 0 ]] && continue

  src_abs="$FRAMEWORK_DIR/$src"
  dest_abs="$PROJECT_DIR/$dest"

  if [[ ! -f "$src_abs" ]]; then
    echo "  MISSING source: $src_abs (skipped)" >&2
    continue
  fi

  if [[ $UNINSTALL -eq 1 ]]; then
    if [[ $CHECK_ONLY -eq 1 ]]; then
      echo "  would remove  $dest_abs"
    else
      remove_target "$dest_abs"
    fi
    acted=1
    continue
  fi

  if [[ -e "$dest_abs" || -L "$dest_abs" ]]; then
    if [[ $FORCE -eq 1 ]]; then
      [[ $CHECK_ONLY -eq 1 ]] && echo "  would replace $dest_abs" || rm -f "$dest_abs"
    else
      echo "  exists        $dest_abs (use --force to replace)"
      continue
    fi
  fi

  if [[ $CHECK_ONLY -eq 1 ]]; then
    echo "  would install $dest_abs <- $src"
  else
    link_or_copy "$src_abs" "$dest_abs"
  fi
  acted=1
done

if [[ $acted -eq 0 ]]; then
  echo "Nothing to do."
fi
