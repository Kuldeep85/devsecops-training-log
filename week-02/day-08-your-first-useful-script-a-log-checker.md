# Day 08 — Your first useful script: a log checker

**Week 2 · about 45 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
A small, tidy script with arguments, error handling and a proper exit code is exactly the kind of evidence a recruiter can read in 30 seconds.

## Goal today
Write a script that takes arguments, uses functions and `set -euo pipefail`, and exits 0/1/2.

## Commands you will learn

| Command | What it does |
|---|---|
| `#!/usr/bin/env bash` | tells Linux which interpreter runs the script |
| `set -euo pipefail` | stop on errors, unset variables and pipe failures |
| `$1, $2, $#` | script arguments and their count |
| `${var:-default}` | use a default value |
| `(( a > b ))` | numeric comparison |
| `exit N` | finish with an exit code |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/lab/day08 && cd ~/lab/day08
cat > loganalyse.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

usage() { echo "Usage: $0 <logfile> [max_errors]"; exit 2; }
[[ $# -ge 1 ]] || usage
file="$1"; max="${2:-3}"
[[ -f "$file" ]] || { echo "File not found: $file"; exit 2; }

errors=$(grep -c "ERROR" "$file" || true)
warns=$(grep -c "WARN" "$file" || true)
echo "File: $file"
echo "ERROR lines: $errors"
echo "WARN lines:  $warns"
if (( errors > max )); then
  echo "FAIL: more than $max errors"
  exit 1
fi
echo "PASS"
EOF
chmod +x loganalyse.sh
printf 'INFO a\nERROR b\nWARN c\nERROR d\n' > sample.log
./loganalyse.sh sample.log ; echo "exit code: $?"
./loganalyse.sh sample.log 1 ; echo "exit code: $?"
./loganalyse.sh nofile.log ; echo "exit code: $?"
./loganalyse.sh
```

## What you should see
Exit code 0 (PASS) with the default limit of 3, exit code 1 (FAIL) with a limit of 1, and exit code 2 for a missing file or missing argument.

## Your exercise (type it yourself, don't copy)
1. Add a third counter for lines containing `INFO` and print it.
2. Add a `--quiet` style behaviour: if a third argument is `quiet`, print only PASS or FAIL.
3. Write down why `|| true` is needed after `grep -c` under `set -e` (hint: what does grep return when it finds zero matches?).

## Save your evidence
Copy your final script to `~/repos/devsecops-training-log/labs/day-08/loganalyse.sh` (create the folder) and paste one PASS run and one FAIL run into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 08 "first script log checker"
```

## My notes (fill in before you commit)
- Commands I ran: `cat > file <<'EOF'`, `chmod +x`, `printf`, `./loganalyse.sh`, `echo "exit code: $?"`, `grep -c`, `cp`, `rm`, `cat -n`, `code`

- What I learned:   
  - A script needs `#!/usr/bin/env bash` on the first line, and `set -euo pipefail` makes it stop on errors, unset variables and pipe failures.
  - `$1`, `$2`, `$3` are the script arguments and `$#` is how many there are. `${2:-3}` and `${3:-normal}` give defaults.
  - Exit codes: 0 = PASS, 1 = FAIL (too many errors), 2 = bad input (missing file or argument). A pipeline step fails when a script exits non-zero.
  - `grep -c` prints the count but exits with 1 when the count is 0. Under `set -e` that would stop the script, so `|| true` is needed after it. I proved it with a copy of the script: without `|| true`, a log with no errors printed nothing and exited with 1.
  - Changes to a script are typed into the script file and saved, not at the terminal. Variables like `$file` and `$mode` only exist while the script runs.
  - Quiet mode (`./loganalyse.sh sample.log 3 quiet`) prints only PASS or FAIL, which is what a pipeline log needs.

- What went wrong and how I fixed it:
  - I put `#!/usr/bin/env bash` and `set -euo pipefail` on the same line as `<<'EOF'`, so they became a comment and were missing from the script. The script also printed PASS twice. I fixed both by editing the file in VS Code and checking it with `cat -n`.
  - I typed exercise code at the terminal instead of in the script, so `$file` and `$mode` were empty and nothing changed. I moved the changes into the script file.
  - I made quote and `$` typos (`"$warns;`, `&max`, mismatched `"` and `'`), and fixed them by rereading each line.

**PASS run**
```text
$ ./loganalyse.sh sample.log
File: sample.log
ERROR lines: 2
WARN lines:  1
INFO lines:  1
PASS
(exit code 0)
```

**FAIL run**
```text
$ ./loganalyse.sh sample.log 1
File: sample.log
ERROR lines: 2
WARN lines:  1
INFO lines:  1
FAIL: more than 1 errors
(exit code 1)
```

**Quiet mode**
```text
$ ./loganalyse.sh sample.log 1 quiet
FAIL