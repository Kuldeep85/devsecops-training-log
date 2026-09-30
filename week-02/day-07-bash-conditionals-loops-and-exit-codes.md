# Day 07 — Bash conditionals, loops and exit codes

**Week 2 · about 40 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Every pipeline step passes or fails based on an exit code. If you understand `$?`, `&&`, `||` and `if`, you understand why a build goes red.

## Goal today
Use exit codes, if/else, for and while loops.

## Commands you will learn

| Command | What it does |
|---|---|
| `echo $?` | exit code of the last command (0 = success) |
| `if [[ -f file ]]; then ... fi` | test a condition |
| `for x in a b c; do ... done` | loop over items |
| `while read line; do ... done < file` | loop over lines of a file |
| `cmd1 && cmd2 / cmd1 \|\| cmd2` | run cmd2 only if cmd1 succeeded / failed |
| `grep -q` | search silently, use only the exit code |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/lab/day07 && cd ~/lab/day07
ls /etc/hostname; echo "exit code: $?"
ls /nope; echo "exit code: $?"

printf 'alpha\nbeta\nERROR gamma\n' > sample.log
if grep -q "ERROR" sample.log; then
  echo "errors found"
else
  echo "clean"
fi

for f in alpha beta gamma; do
  echo "processing $f"
done

n=1
while [[ $n -le 3 ]]; do
  echo "attempt $n"
  n=$((n+1))
done

while read -r line; do
  echo "line: $line"
done < sample.log

mkdir -p out && echo "made out/" || echo "failed"
false && echo "not printed" ; true || echo "not printed either"
```

## What you should see
Exit code 0 for the existing file and 2 for the missing one. `errors found` prints because the log contains `ERROR`.

## Your exercise (type it yourself, don't copy)
1. Write a loop that prints `checking <name>` for the names `web`, `api`, `db`.
2. Write an `if` that prints `PASS` when `sample.log` has no line containing `ERROR`, otherwise `FAIL`. Test it both ways.
3. Explain in one sentence what a pipeline does when a script exits with a non-zero code.

## Save your evidence
Save your `if` snippet as `labs/day-07/check.sh` in the training repo and paste one run of it into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 07 "bash conditionals loops exit codes"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
