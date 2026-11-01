#!/usr/bin/env bash
# Links every skill in this repo into ~/.claude/skills and ~/.agents/skills
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for target in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
  mkdir -p "$target"
  for skill in "$repo"/skills/*/*/; do
    [ -d "$skill" ] || continue
    name="$(basename "$skill")"
    rm -rf "$target/$name"
    ln -s "$skill" "$target/$name"
    echo "$target/$name -> $skill"
  done
done

echo "Skills linked successfully."
