# Day 03 — Searching with grep and find

**Week 1 · about 35 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Finding a needle in a repo is daily work: which file sets this variable, where is the password committed, which logs are from yesterday.

## Goal today
Search inside files with grep and search for files with find, including a simple hard-coded-secret hunt.

## Commands you will learn

| Command | What it does |
|---|---|
| `grep -rn` | search text in all files under a folder, show line numbers |
| `grep -i / -v / -c` | ignore case / invert match / count matches |
| `grep -E` | extended regular expressions |
| `find . -name` | find files by name |
| `find . -type f -mtime -1` | files changed in the last day |
| `find . -size +1M` | files bigger than 1 MB |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/lab/day03/app/config && cd ~/lab/day03
printf 'name=demo\nTODO: remove debug\n' > app/main.txt
printf 'password=demo123\napi_key = "abc-not-real"\nport=8080\n' > app/config/settings.txt
grep -rn "TODO" .
grep -rni "password" .
grep -rc "port" app
grep -rv "port" app/config/settings.txt
find . -name "*.txt"
find . -type f -mtime -1
find . -type f -size -1k

# A naive secret hunt: keywords followed by "="
grep -rniE "(password|secret|token|api[_-]?key)\s*=" .
```

## What you should see
The last command prints both lines from `settings.txt` with file name and line number. This is exactly what tools like gitleaks automate.

## Your exercise (type it yourself, don't copy)
1. Create three more files, one containing `secret_token = xyz`, one containing `Password: abc` (with a colon) and one with nothing sensitive.
2. Run the hunt again. Does it find the colon version? Change the regex so it catches both `=` and `:`.
3. Use `find` to list only files modified in the last day and whose names end in `.txt`.

## Save your evidence
Paste your improved regex and its output into **My notes**. This regex idea reappears on Day 12 with gitleaks.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 03 "grep and find"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
