# Day 29 — Project: run the pipelines in report-only mode

**Week 6 · about 75 minutes · Run in: Ubuntu (WSL) terminal + browser (GitHub and Azure DevOps personal org)**

## Why this matters
Starting in report-only mode and then enforcing is how real teams roll out security gates without blocking everyone. It is also a great interview story.

## Goal today
Run the same scans in GitHub Actions and Azure DevOps and download the reports.

## Commands you will learn

| Command | What it does |
|---|---|
| `git push` | triggers the GitHub Actions workflow |
| `Actions → run → Artifacts` | download reports |
| `Pipelines → New pipeline → azure-pipelines.yml` | create the Azure DevOps pipeline |
| `Pipelines → run → Artifacts` | download reports |

## Do this (run each block, then read the output before moving on)
```bash
cd ~/repos/devsecops-pipeline-lab
git status
git push          # if anything is unpushed
```

1. **GitHub:** open the **Actions** tab. Open the `devsecops` run and read every step. Download the `security-reports` artifact.
2. **Azure DevOps (personal org):** **Pipelines → New pipeline → GitHub → this repo → Existing Azure Pipelines YAML file → `/azure-pipelines.yml` → Run.** (Use `pool: name: Default` if you have no hosted agent.)
3. Compare: which scans behave differently on the two platforms?

Take screenshots of both run summaries (green build, with warnings in the log).

## What you should see
Both builds are green even though the scans find problems, because `ENFORCE` is `false`. The log lines say `WARNING: ... found issues (report-only mode)`.

## Your exercise (type it yourself, don't copy)
1. Fix any tool/pipeline errors that show up (path, permissions, missing Docker). Write each error and fix into the log.
2. Add a README section with a small table: scan → tool → finding count.
3. Add the GitHub Actions status badge to the project README.

## Save your evidence
Put both screenshots in `evidence/`, update the README, commit and push.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 29 "project pipelines report-only"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
