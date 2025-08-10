#!/usr/bin/env bash
set -euo pipefail

COMPOSE_FILE="compose.yaml"
BACKUP_FILE="compose.yaml.bak"
TMP_FILE="$(mktemp)"

cp "$COMPOSE_FILE" "$BACKUP_FILE"
cp "$COMPOSE_FILE" "$TMP_FILE"

# Cross-platform sed -i helper (GNU vs BSD/macOS)
sed_inplace() {
  if sed --version >/dev/null 2>&1; then
    sed -r -i "$@"
  else
    sed -E -i '' "$@"
  fi
}

# Update one service version in compose.yaml
update_version() {
  local file="$1"
  [[ -f "$file" ]] || return 0

  # First non-empty line, first token = version (strip CR if present)
  local version
  version="$(grep -m1 -E '\S' "$file" | tr -d '\r' | awk '{print $1}')"

  [[ -n "$version" ]] || return 0

  # Replace tag after repasscloud/<name>:<tag> with the new version
  # Only changes the image line for this exact service
  sed_inplace "s|(repasscloud/${file}:)[^[:space:]]+|\\1${version}|" "$TMP_FILE"
}

# Iterate over all telecasino-*gameservice files (no extensions)
for f in telecasino-*gameservice; do
  [[ -e "$f" ]] || continue
  update_version "$f"
done

mv "$TMP_FILE" "$COMPOSE_FILE"
echo "compose.yaml updated (backup at $BACKUP_FILE)"


# Update git repo
git add compose.yaml*
git commit -m "compose.yaml updated (backup at $BACKUP_FILE)"