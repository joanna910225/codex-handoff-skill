#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
STAMP="$(date '+%Y%m%d-%H%M%S')-$$"
BACKUP="$CODEX_HOME/backups/codex-handoff-$STAMP"

SKILL_SRC="$ROOT/skills/handoff"
SKILL_DST="$CODEX_HOME/skills/handoff"
REVIEWER_SRC="$ROOT/codex/agents/reviewer.toml"
REVIEWER_DST="$CODEX_HOME/agents/reviewer.toml"
AGENTS_FRAGMENT="$ROOT/codex/AGENTS.fragment.md"
AGENTS_DST="$CODEX_HOME/AGENTS.md"

for file in \
  "$SKILL_SRC/SKILL.md" \
  "$SKILL_SRC/references/context-rotation.md" \
  "$SKILL_SRC/references/model-routing.md" \
  "$SKILL_SRC/references/subagent-handoff.md" \
  "$REVIEWER_SRC" \
  "$AGENTS_FRAGMENT"; do
  test -f "$file" || { echo "Missing required file: $file" >&2; exit 1; }
done

command -v python3 >/dev/null || { echo "python3 is required." >&2; exit 1; }

if test -f "$AGENTS_DST"; then
  begin_count="$(grep -F -c '<!-- BEGIN codex-handoff-skill -->' "$AGENTS_DST" || true)"
  end_count="$(grep -F -c '<!-- END codex-handoff-skill -->' "$AGENTS_DST" || true)"
  if test "$begin_count" -gt 1 || test "$end_count" -gt 1 || test "$begin_count" -ne "$end_count"; then
    echo "AGENTS.md contains invalid or duplicate codex-handoff marker blocks; fix it manually before installing." >&2
    exit 1
  fi
fi

mkdir -p "$CODEX_HOME/skills" "$CODEX_HOME/agents" "$BACKUP"

if test -e "$SKILL_DST"; then
  cp -R "$SKILL_DST" "$BACKUP/handoff"
  rm -rf "$SKILL_DST"
fi
cp -R "$SKILL_SRC" "$SKILL_DST"

if test -f "$REVIEWER_DST"; then
  cp "$REVIEWER_DST" "$BACKUP/reviewer.toml"
fi
cp "$REVIEWER_SRC" "$REVIEWER_DST"

if test -f "$AGENTS_DST"; then
  cp "$AGENTS_DST" "$BACKUP/AGENTS.md"
fi

python3 - "$AGENTS_DST" "$AGENTS_FRAGMENT" <<'PY'
from pathlib import Path
import sys

destination = Path(sys.argv[1])
fragment = Path(sys.argv[2]).read_text().strip()
begin = "<!-- BEGIN codex-handoff-skill -->"
end = "<!-- END codex-handoff-skill -->"
block = f"{begin}\n{fragment}\n{end}"
current = destination.read_text() if destination.exists() else ""

if (begin in current) != (end in current):
    raise SystemExit("AGENTS.md contains an incomplete codex-handoff marker block; restore or fix it manually.")

if begin in current:
    before, rest = current.split(begin, 1)
    _, after = rest.split(end, 1)
    updated = before.rstrip() + "\n\n" + block + after
else:
    updated = (current.rstrip() + "\n\n" if current.strip() else "") + block + "\n"

destination.write_text(updated)
PY

test -f "$SKILL_DST/SKILL.md"
test -f "$SKILL_DST/references/context-rotation.md"
test -f "$SKILL_DST/references/model-routing.md"
test -f "$SKILL_DST/references/subagent-handoff.md"
test -f "$REVIEWER_DST"
test "$(grep -c '<!-- BEGIN codex-handoff-skill -->' "$AGENTS_DST")" -eq 1
test "$(grep -c '<!-- END codex-handoff-skill -->' "$AGENTS_DST")" -eq 1

echo "Installed Codex handoff setup in: $CODEX_HOME"
echo "Backup directory: $BACKUP"
echo "Open a fresh Codex session to reload skills, agents, and AGENTS.md."
