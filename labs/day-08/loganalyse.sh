#!/usr/bin/env bash
set -euo pipefail

usage() { echo "Usage: $0 <logfile> [max_errors]"; exit 2; }
[[ $# -ge 1 ]] || usage
file="$1"; max="${2:-3}"; mode="${3:-normal}"    #new: third argument
[[ -f "$file" ]] || { echo "File not found: $file"; exit 2; }

errors=$(grep -c "ERROR" "$file" || true)
warns=$(grep -c "WARN" "$file" || true)
infos=$(grep -c "INFO" "$file" || true)

if [[ "$mode" != "quiet" ]]; then
  echo "File: $file"
  echo "ERROR lines: $errors"
  echo "WARN lines:  $warns"
  echo "INFO lines:  $infos"
fi

if (( errors > max )); then
  if [[ "$mode" == "quiet" ]]; then echo "FAIL"; else echo "FAIL: more than $max errors"; fi
  exit 1
fi
echo "PASS"
