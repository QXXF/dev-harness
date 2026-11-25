#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CURSOR_SKILLS="${CURSOR_SKILLS_DIR:-$HOME/.cursor/skills}"
CURSOR_AGENTS="${CURSOR_AGENTS_DIR:-$HOME/.cursor/agents}"

SKILLS=(
  dev-core
  voice-core
  code-integrity-audit
  design-core
  breakdown
  flow-mirror
  nxd
)

# Skill fuse in dev-core: rimuovi eventuali symlink obsoleti
STALE_SKILLS=(
  generalist-engineer
  compact-communication
  direct-answers
  ponytail
  node
)

to_win_path() {
  if command -v cygpath >/dev/null 2>&1; then
    cygpath -w "$1"
  else
    printf '%s\n' "$1"
  fi
}

# Rimuove symlink, junction o directory. Preferisce rmdir su Windows cosi
# un junction non cancella il contenuto del target.
remove_path() {
  local path="$1"
  [[ -e "$path" || -L "$path" ]] || return 0

  if [[ -L "$path" ]]; then
    rm -f "$path"
    return
  fi

  if command -v cmd.exe >/dev/null 2>&1; then
    local win
    win="$(to_win_path "$path")"
    if cmd.exe //c "rmdir \"$win\"" >/dev/null 2>&1; then
      [[ ! -e "$path" && ! -L "$path" ]] && return
    fi
  fi

  rm -rf "$path"
}

# Symlink reale se possibile; su Windows Git Bash spesso copia → junction.
link_skill() {
  local src="$1" dest="$2"

  remove_path "$dest"

  if ln -s "$src" "$dest" 2>/dev/null && [[ -L "$dest" ]]; then
    return 0
  fi

  remove_path "$dest"

  if command -v powershell.exe >/dev/null 2>&1; then
    local win_src win_dest
    win_src="$(to_win_path "$src")"
    win_dest="$(to_win_path "$dest")"
    powershell.exe -NoProfile -Command \
      "New-Item -ItemType Junction -Path '$win_dest' -Target '$win_src' | Out-Null"
    return
  fi

  echo "Could not create symlink or junction: $dest" >&2
  exit 1
}

mkdir -p "$CURSOR_SKILLS" "$CURSOR_AGENTS"

echo "Installing dev-harness skills into $CURSOR_SKILLS"
for skill in "${SKILLS[@]}"; do
  src="$REPO_ROOT/.agents/skills/$skill"
  dest="$CURSOR_SKILLS/$skill"

  if [[ ! -d "$src" ]]; then
    echo "Missing skill directory: $src" >&2
    exit 1
  fi

  link_skill "$src" "$dest"
  echo "  linked $skill -> $src"
done

for skill in "${STALE_SKILLS[@]}"; do
  dest="$CURSOR_SKILLS/$skill"
  if [[ -e "$dest" || -L "$dest" ]]; then
    remove_path "$dest"
    echo "  removed stale $skill"
  fi
done

# Subagent generati in passato da questo script: le skill li sostituiscono
for agent in generalist-engineer compact-communication code-integrity-audit; do
  dest="$CURSOR_AGENTS/$agent.md"
  if [[ -e "$dest" ]]; then
    rm -f "$dest"
    echo "  removed stale agent $agent"
  fi
done

echo
echo "Done. Restart Cursor or open a new chat to pick up global skills."
echo
echo "Update the Cursor User Rule (Settings → Rules → User Rules) to:"
echo "  Segui sempre le skill dev-core e voice-core: le altre skill decidono cosa fare, voice-core decide come me lo racconti e prevale sul loro registro. Usa la skill nxd per comandi npm/node, code-integrity-audit quando chiedo audit o review, design-core per lavoro UI/frontend (layout, colori, tipografia, accessibilità, animazioni, review di design), e flow-mirror a fine analisi quando serve lo specchio UI/UX completo. Non usare breakdown a meno che la invoco con /breakdown o \$breakdown."
echo
echo "Examples:"
echo "  Use \$dev-core as the default engineering and communication mode."
echo "  Use \$voice-core to shape the prose of the final answer."
echo "  Use \$code-integrity-audit to review this change."
echo "  Use \$design-core for UI/frontend work or design reviews."
echo "  Use \$breakdown only when explicitly invoked (/breakdown or \$breakdown)."
echo "  Use \$flow-mirror for the complete FE/BE UI/UX flow mirror."
