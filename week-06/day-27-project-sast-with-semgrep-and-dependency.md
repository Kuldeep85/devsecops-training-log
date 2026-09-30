# Day 27 — Project: SAST with Semgrep and dependency scanning

**Week 6 · about 75 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
SAST finds insecure code; SCA finds vulnerable libraries. You will run both, read the output, and decide which findings matter.

## Goal today
Run Semgrep and npm audit locally and log each finding.

## Commands you will learn

| Command | What it does |
|---|---|
| `make sast` | run Semgrep with the custom rule and community rule packs |
| `make sca` | install dependencies and run npm audit |
| `cat reports/semgrep.json \| jq` | inspect findings |
| `npm audit` | list known vulnerable packages |

## Do this (run each block, then read the output before moving on)
```bash
cd ~/repos/devsecops-pipeline-lab
sudo apt install -y python3-venv
make sast
jq '.results[] | {rule: .check_id, file: .path, line: .start.line}' reports/semgrep.json
make sca
cat reports/npm-audit.txt | head -40
```

For each finding, add a row to `docs/findings-log.md`: tool, finding, severity, why it matters.

## What you should see
Semgrep flags the SQL string-concatenation (from your custom rule) and usually the reflected-XSS pattern. `npm audit` lists several high-severity issues (old `express`/`lodash`).

## Your exercise (type it yourself, don't copy)
1. Decide whether each Semgrep finding is a true positive. Note one that might be a false positive or low value and say why.
2. Look up one npm advisory on `github.com/advisories` and summarise the vulnerability in two sentences.
3. Write your own second Semgrep rule (for example flag `eval(`) in `semgrep/custom-rules.yml`, test it, and commit it.

## Save your evidence
Commit the updated findings log and any new rule. Save the two report files' key lines (not the whole files) into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 27 "project sast and sca"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
