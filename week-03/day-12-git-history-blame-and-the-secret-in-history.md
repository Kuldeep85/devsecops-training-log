# Day 12 — Git history, blame and the secret-in-history problem

**Week 3 · about 45 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Committed secrets are the most common real-world pipeline security failure. Deleting the file does NOT remove it from history. This day is core DevSecOps knowledge, and it is where you install gitleaks.

## Goal today
Search history, prove a deleted secret is still recoverable, scan with gitleaks, and know the correct response.

## Commands you will learn

| Command | What it does |
|---|---|
| `git log -p -S"text"` | find commits that added or removed a piece of text |
| `git blame file` | who last changed each line |
| `git rm --cached file` | stop tracking a file but keep it on disk |
| `git show <sha>` | view an old commit |
| `gitleaks detect --source . --redact -v` | scan the repo and its history for secrets |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/lab/day12/secretdemo && cd ~/lab/day12/secretdemo
git init -b main
echo "app" > app.txt && git add . && git commit -m "Initial"
# build a fake-but-realistic key from two halves (so this guide itself contains no secret-looking text)
PART_ONE="f3a9c1e7b2d84a6f"; PART_TWO="9e0c5b7d1a3e8f42"
echo "API_KEY=\"${PART_ONE}${PART_TWO}\"" > .env
git add .env && git commit -m "Oops: add env file"
git rm --cached .env && echo ".env" >> .gitignore
git add .gitignore && git commit -m "Remove .env from tracking"
ls -a                              # .env is still on disk, untracked
git log -p -S"$PART_ONE" --oneline
git blame app.txt
```

Install gitleaks (once) and scan:

```bash
curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_x64.tar.gz | tar -xz gitleaks
sudo mv gitleaks /usr/local/bin/ && gitleaks version
gitleaks detect --source . --redact -v
```

## What you should see
`git log -p -S...` still shows the fake key in the old commit. gitleaks reports a `generic-api-key` finding even though `.env` is no longer tracked (the history still holds it, and `.env` is still on disk).

## Your exercise (type it yourself, don't copy)
1. Explain why `git rm` does not fix a leaked secret. What are the correct steps? (Answer: **rotate/revoke the secret first**, then optionally rewrite history, then add prevention such as pre-commit scanning.)
2. Run gitleaks with `--no-git` to scan only the current files. Compare with the history scan.
3. Install gitleaks in the training repo scan: from now on `tools/finish-day.sh` will scan before every commit.

## Save your evidence
Paste the gitleaks summary (finding count, rule name, file, commit — redacted output is fine) and your 3-step response plan into **My notes**. Never commit a real secret.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 12 "git history and secrets"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
