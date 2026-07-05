#!/usr/bin/env bash
#
# new-project.sh — scaffold a new self-contained project in projects/<name>/
#
# Usage:
#   ./scripts/new-project.sh <project-name> [template]
#   ./scripts/new-project.sh -h | --help
#
# <project-name> must be kebab-case (letters, digits, hyphens).
# [template] defaults to "python". Available templates live in templates/.
#
set -euo pipefail

# Resolve repo root relative to this script so it works from any CWD.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATES_DIR="$REPO_ROOT/templates"
PROJECTS_DIR="$REPO_ROOT/projects"

list_templates() {
  if [ -d "$TEMPLATES_DIR" ]; then
    find "$TEMPLATES_DIR" -mindepth 1 -maxdepth 1 -type d -printf '  %f\n' | sort
  fi
}

usage() {
  cat <<EOF
Scaffold a new self-contained project under projects/.

Usage:
  $(basename "$0") <project-name> [template]

Arguments:
  project-name   kebab-case name (letters, digits, hyphens), e.g. csv-diff
  template       template to copy (default: python)

Available templates:
$(list_templates)

Example:
  $(basename "$0") url-shortener
  $(basename "$0") log-parser python
EOF
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

NAME="${1:-}"
TEMPLATE="${2:-python}"

if [ -z "$NAME" ]; then
  echo "error: missing <project-name>" >&2
  echo >&2
  usage >&2
  exit 1
fi

# Validate the name: kebab-case, must start/end alphanumeric.
if ! printf '%s' "$NAME" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$'; then
  echo "error: '$NAME' is not valid kebab-case (use lowercase letters, digits, and single hyphens)" >&2
  exit 1
fi

TEMPLATE_DIR="$TEMPLATES_DIR/$TEMPLATE"
if [ ! -d "$TEMPLATE_DIR" ]; then
  echo "error: template '$TEMPLATE' not found in templates/" >&2
  echo "available templates:" >&2
  list_templates >&2
  exit 1
fi

DEST="$PROJECTS_DIR/$NAME"
if [ -e "$DEST" ]; then
  echo "error: projects/$NAME already exists" >&2
  exit 1
fi

# Derived names for substitution.
PACKAGE_NAME="$(printf '%s' "$NAME" | tr '-' '_')"   # snake_case for Python

mkdir -p "$PROJECTS_DIR"
cp -R "$TEMPLATE_DIR" "$DEST"

# Rename any placeholder package directory (templates/python/src/package).
if [ -d "$DEST/src/package" ]; then
  mv "$DEST/src/package" "$DEST/src/$PACKAGE_NAME"
fi

# Substitute placeholders in every file. Tokens:
#   {{PROJECT_NAME}} -> kebab-case name
#   {{PACKAGE_NAME}} -> snake_case name
find "$DEST" -type f -print0 | while IFS= read -r -d '' file; do
  # Use a temp file for portable, in-place editing (avoids sed -i differences).
  sed -e "s/{{PROJECT_NAME}}/$NAME/g" \
      -e "s/{{PACKAGE_NAME}}/$PACKAGE_NAME/g" \
      "$file" > "$file.tmp" && mv "$file.tmp" "$file"
done

cat <<EOF
Created projects/$NAME/ from the '$TEMPLATE' template.

Next steps:
  1. cd projects/$NAME
  2. Read and complete SPEC.md from the request.
  3. Follow the TDD workflow in that project's CLAUDE.md (red -> green -> refactor).

Happy building.
EOF
