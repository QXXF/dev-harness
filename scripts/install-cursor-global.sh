#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CURSOR_SKILLS="${CURSOR_SKILLS_DIR:-$HOME/.cursor/skills}"
CURSOR_AGENTS="${CURSOR_AGENTS_DIR:-$HOME/.cursor/agents}"

SKILLS=(
  generalist-engineer
  compact-communication
  code-integrity-audit
  direct-answers
  node
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

install_agent() {
  local name="$1"
  local description="$2"
  local source_file="$3"
  local dest="$CURSOR_AGENTS/$name.md"

  {
    printf '%s\n' "---"
    printf '%s\n' "name: $name"
    printf '%s\n' "description: $description"
    printf '%s\n' "---"
    printf '\n'
    cat "$source_file"
  } >"$dest"

  echo "  wrote agent $name -> $dest"
}

echo "Installing dev-harness subagents into $CURSOR_AGENTS"
install_agent \
  "generalist-engineer" \
  "Senior generalist software engineer for frontend, backend, SwiftUI/native, tooling, tests, architecture, implementation, refactoring, debugging, and code review. Use proactively for general development tasks." \
  "$REPO_ROOT/agent-generalist.md"

install_agent \
  "compact-communication" \
  "Concise caveman-style technical communication. Use when the user asks for compact mode, terse responses, or /caveman lite|full|ultra." \
  "$REPO_ROOT/style-caveman.md"

install_agent \
  "code-integrity-audit" \
  "Code review and integrity audit for correctness, state, contracts, security, concurrency, and regressions. Use proactively for audits, reviews, bug hunts, and CI failures." \
  "$REPO_ROOT/audit-code-integrity.md"

echo
echo "Done. Restart Cursor or open a new chat to pick up global skills and agents."
echo
echo "Examples:"
echo "  Use \$generalist-engineer to implement this task."
echo "  Use the code-integrity-audit subagent to review this change."
