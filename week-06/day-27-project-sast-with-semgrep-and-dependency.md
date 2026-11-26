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
SQL injection: a true positive in the code pattern. In this demo the db object is a stub and doesn't actually run SQL, so it isn't exploitable here. With a real database it would be.
XSS: a true positive.
Low value: direct-response-write is the same issue as raw-html-format, flagged a second time, so it adds noise and not a new finding. That's the one to name as low value.
Dockerfile missing-user: a true positive, but it's a container hardening issue, which Day 28 covers.

2. Look up one npm advisory on `github.com/advisories` and summarise the vulnerability in two sentences.
Lodash's _.template function lets an attacker run commands if they control the template's variable option. Upgrading lodash removes the issue.

3. Write your own second Semgrep rule (for example flag `eval(`) in `semgrep/custom-rules.yml`, test it, and commit it.

## Save your evidence
Commit the updated findings log and any new rule. Save the two report files' key lines (not the whole files) into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 27 "project sast and sca"
```

## My notes (fill in before you commit)
- Commands I ran: make sast, jq on reports/semgrep.json, make sca, cat reports/npm-audit.txt, plus a second custom Semgrep rule for eval and a test file.

- What I learned: Semgrep: "4 Code Findings (4 blocking)", 81 rules, 6 files: SQL injection (custom rule), reflected XSS flagged by two rules, and a Dockerfile without USER. npm audit: "8 vulnerabilities (3 low, 5 high)", caused by pinned old express 4.17.1 and lodash 4.17.15. Two Semgrep rules flagging the same XSS line is noise, not a second issue. An advisory only matters if my code uses the affected function (my app calls _.merge, not _.template). 

- What went wrong and how I fixed it: My first eval test scanned 0 files because Semgrep ignores folders named tests/ by default (.semgrepignore). I renamed the folder to semgrep/samples/ and the rule then fired.
