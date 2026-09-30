# Day 30 — Project: fix the findings, one commit per fix

**Week 6 · about 90 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Finding problems is half the job. Fixing them cleanly, with one commit per fix and a clear message, shows engineering discipline.

## Goal today
Fix the secret, SQL injection and XSS in the demo app, and re-run the scans.

## Commands you will learn

| Command | What it does |
|---|---|
| `process.env.API_KEY` | read a secret from the environment |
| `db.query(sql, [params])` | parameterised query |
| `res.json({...})` | return data, not raw HTML |
| `git commit per fix` | small, reviewable changes |
| `.gitleaksignore` | record a fingerprint of a known, already-rotated finding |

## Do this (run each block, then read the output before moving on)
```bash
cd ~/repos/devsecops-pipeline-lab
git switch -c fix/security-findings
code app/server.js
```

Make these edits, **committing after each one**:

```js
// 1. Secret: read from the environment (add .env to .gitignore, never commit it)
const API_KEY = process.env.API_KEY;

// 2. SQL injection: parameterised query (update the stub so it accepts params)
const db = { query: (sql, params) => ({ sql, params, rows: [] }) };
app.get('/user', (req, res) => {
  const result = db.query('SELECT * FROM users WHERE name = ?', [req.query.name]);
  res.json(result);
});

// 3. XSS: return JSON instead of building HTML from user input
app.get('/hello', (req, res) => {
  res.json({ message: 'Hello ' + String(req.query.name || 'guest') });
});
```

```bash
git commit -am "Fix: read API key from environment"    # after edit 1, and so on for 2 and 3
make sast
make secrets        # still flags the OLD commit: that is expected
```

The secret is still in Git **history**. Copy the `Fingerprint` from the gitleaks output into a `.gitleaksignore` file and commit it, and write in the findings log that a *real* key would have been **rotated** first. Then open a pull request and squash-merge it.

## What you should see
Semgrep no longer reports the SQL injection or XSS. `make secrets` reports nothing new after the fingerprint is ignored. Your PR history shows one commit per fix.

## Your exercise (type it yourself, don't copy)
1. Weekend: update dependencies (`cd app && npm install express@latest lodash@latest`), commit the lockfile, re-run `make sca`, and record anything left.
2. Weekend: copy `app/Dockerfile.hardened` over `app/Dockerfile`, re-run `make container`, record the 'after' numbers.
3. Weekend: set `ENFORCE` to `true`, open a PR that re-introduces a vulnerable dependency, and screenshot the pipeline failing; then revert and screenshot it passing.

## Save your evidence
Merge the PR. Your repo now contains the before/after evidence. Update `docs/findings-log.md` with fix commits and re-scan results.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 30 "project fix findings"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
