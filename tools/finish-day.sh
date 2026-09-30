#!/usr/bin/env bash
# Usage: tools/finish-day.sh 07 "bash conditionals and loops"
# Scans for secrets (if gitleaks is installed), commits everything with a "Day NN: message" title, and pushes.
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo 'Usage: tools/finish-day.sh <day-number> "<short message>"'
  exit 2
fi

day="$1"; msg="$2"
cd "$(git rev-parse --show-toplevel)"

if command -v gitleaks >/dev/null 2>&1; then
  echo "Scanning for secrets..."
  if ! gitleaks detect --source . --no-banner --redact; then
    echo "STOP: possible secret found. Remove it (and rotate it if it was real) before committing."
    exit 1
  fi
else
  echo "(gitleaks is not installed yet - it is installed on Day 12. Check your files for secrets by eye until then.)"
fi

git add -A
if git diff --cached --quiet; then
  echo "Nothing to commit."
  exit 0
fi
git status --short
git commit -m "Day ${day}: ${msg}"
git push
