# Day 26 — Project: set up the DevSecOps pipeline lab and scan for secrets

**Week 6 · about 75 minutes · Run in: Ubuntu (WSL) terminal + browser**

## Why this matters
This is the project a recruiter can open, read and re-run. Everything from Weeks 1–5 comes together.

## Goal today
Put the starter project into your own GitHub repo and run the first scan locally.

## Commands you will learn

| Command | What it does |
|---|---|
| `unzip` | extract the starter |
| `git init -b main` | create the repository |
| `make secrets` | run the gitleaks scan |
| `cat reports/gitleaks.json` | read the finding |

## Do this (run each block, then read the output before moving on)
```bash
cd ~/repos
unzip ~/Downloads/devsecops-pipeline-lab.zip        # adjust the path to where you saved it
cd devsecops-pipeline-lab
git init -b main
git add . && git commit -m "Import starter: deliberately vulnerable demo app and pipeline scripts"
```

On GitHub create a **public** repo `devsecops-pipeline-lab` (no README), then:

```bash
git remote add origin git@github.com:<your-username>/devsecops-pipeline-lab.git
git push -u origin main
```

If GitHub blocks the push because of the fake key, use the link it prints to allow it (the value is fake), or change the string in `app/server.js`.

```bash
make secrets
python3 -m json.tool reports/gitleaks.json | head -30
```

Open `docs/findings-log.md` and fill row 1.

## What you should see
gitleaks reports one leak in `app/server.js`, and the JSON shows the rule and line. Report-only mode means `make` still finishes successfully.

## Your exercise (type it yourself, don't copy)
1. Add a `.env.example` file (fake placeholders only) and confirm gitleaks does not complain.

2. Write in the findings log why this finding matters and what you would do if it were a real key (rotate first).
If this were a real key: rotate it first, meaning revoke it at the provider and issue a new one, because it's already public in the repo and its history. Then check the provider's logs for misuse, move the key to an environment variable or secret store, optionally rewrite git history, and prevent a repeat with a gitleaks gate in the pipeline plus .env in .gitignore.

3. Read `scripts/lib.sh` and `scan-secrets.sh` and explain in your notes what `ENFORCE` does.
scan-secrets.sh runs gitleaks and passes its exit code to finish() in lib.sh. finish() checks enforce(), which is true only when the environment variable ENFORCE is true (or 1). If the scan found issues and ENFORCE is true, the script prints an ERROR and exits with that non-zero code, failing the build. If ENFORCE is not set, it prints a WARNING and exits 0 (report-only mode). So the default is "scan and report", and ENFORCE=true turns the scan into a gate that blocks.

## Save your evidence
Fill in row 1 of `docs/findings-log.md`, commit as `Day 26: ...`, and push. Read the project README's **Before you start** section again.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 26 "project setup and secrets scan"
```

## My notes (fill in before you commit)
- Commands I ran: unzip, git init -b main, git add / commit, git remote add origin, git push -u origin main, make secrets, python3 -m json.tool reports/gitleaks.json. Exercises: added .env.example and ignored .env, then ran ENFORCE=true make secrets.

- What I learned: gitleaks found one leak: a generic-api-key in app/server.js line 10. Report-only mode (default) prints a WARNING and continues; ENFORCE=true makes lib.sh's finish() exit non-zero and fail the build. If it were a real key I would rotate it first, because it is already in git history and the repo is public. gitleaks detect scans commits, so I had to commit .env.example before scanning.

- What went wrong and how I fixed it: The starter zip was not in ~/Downloads, so I downloaded it to Windows and used the /mnt/c/Users/<name>/Downloads path. I typed python instead of python3 and corrected it.
