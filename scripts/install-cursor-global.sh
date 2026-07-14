#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CURSOR_SKILLS="${CURSOR_SKILLS_DIR:-$HOME/.cursor/skills}"
CURSOR_AGENTS="${CURSOR_AGENTS_DIR:-$HOME/.cursor/agents}"

SKILLS=(
  dev-core
  code-integrity-audit
  node
)

# Skill fuse in dev-core: rimuovi eventuali symlink obsoleti
STALE_SKILLS=(
  generalist-engineer
  compact-communication
  direct-answers
  ponytail
)

mkdir -p "$CURSOR_SKILLS" "$CURSOR_AGENTS"

echo "Installing dev-harness skills into $CURSOR_SKILLS"
for skill in "${SKILLS[@]}"; do
  src="$REPO_ROOT/.agents/skills/$skill"
  dest="$CURSOR_SKILLS/$skill"

  if [[ ! -d "$src" ]]; then
    echo "Missing skill directory: $src" >&2
    exit 1
  fi

  ln -sfn "$src" "$dest"
  echo "  linked $skill -> $src"
done

for skill in "${STALE_SKILLS[@]}"; do
  dest="$CURSOR_SKILLS/$skill"
  if [[ -e "$dest" || -L "$dest" ]]; then
    rm -rf "$dest"
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
echo "Examples:"
echo "  Use \$dev-core as the default engineering and communication mode."
echo "  Use \$code-integrity-audit to review this change."
