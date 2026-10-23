#!/bin/bash
# Installs Documa (with dev extras) into $CLAUDE_PROJECT_DIR/.venv for Claude Code cloud sessions.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

if [ ! -x .venv/bin/python ]; then
  python3 -m venv .venv
fi

# Fresh setuptools is required: the system one cannot build red-black-tree-mod (extract-msg dependency).
.venv/bin/python -m pip install -q -U pip setuptools wheel
# Editable install builds the vendored Rust extensions (needs cargo); idempotent on re-run.
.venv/bin/python -m pip install -q -e ".[dev]"

if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export PATH=\"$CLAUDE_PROJECT_DIR/.venv/bin:\$PATH\"" >> "$CLAUDE_ENV_FILE"
fi
