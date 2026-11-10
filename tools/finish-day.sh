   #!/usr/bin/env bash
   # Usage: tools/finish-day.sh 07 "bash conditionals and loops"
   # Stages everything, scans the STAGED changes for secrets (if gitleaks is installed),
   # commits with a "Day NN: message" title, and pushes.
   set -euo pipefail

   if [[ $# -lt 2 ]]; then
     echo 'Usage: tools/finish-day.sh <day-number> "<short message>"'
     exit 2
   fi

   day="$1"; msg="$2"
   cd "$(git rev-parse --show-toplevel)"

   git add -A
   if git diff --cached --quiet; then
     echo "Nothing to commit."
     exit 0
   fi

   if command -v gitleaks >/dev/null 2>&1; then
     echo "Scanning staged changes for secrets..."
     if ! gitleaks git --staged --no-banner --redact -v; then
       echo "STOP: possible secret found in the files you are about to commit."
       echo "Remove it (and rotate it if it was real), then run this script again."
       git reset -q          # unstage everything so nothing is half-committed
       exit 1
     fi
   else
     echo "(gitleaks is not installed - check your files for secrets by eye.)"
   fi

   git status --short
   git commit -m "Day ${day}: ${msg}"
   git push