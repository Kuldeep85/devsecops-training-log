# Day 22 — GitHub Actions: your first workflow

**Week 5 · about 45 minutes · Run in: Ubuntu (WSL) terminal + browser (GitHub)**

## Why this matters
GitHub Actions pipelines are public on your profile, so recruiters can see them run. They use the same ideas as your Azure DevOps YAML.

## Goal today
Create a workflow, push it, and watch it run.

## Commands you will learn

| Command | What it does |
|---|---|
| `on: push / workflow_dispatch` | when the workflow starts |
| `jobs / runs-on` | which machine runs it |
| `steps / uses / run` | actions and shell commands |
| `actions/checkout@v4` | get your code |
| `Actions tab` | see runs and logs |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/repos && cd ~/repos
# On GitHub: create a NEW PUBLIC repo called cicd-practice (add a README), then:
git clone git@github.com:<your-username>/cicd-practice.git
cd cicd-practice
mkdir -p .github/workflows
cat > .github/workflows/hello.yml <<'EOF'
name: hello
on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  hello:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Say hello
        run: echo "Hello from GitHub Actions on $(uname -s)"
      - name: Show repo files
        run: ls -la
EOF
git add . && git commit -m "Add hello workflow" && git push
```

In the browser: repo → **Actions** → open the run → open the `hello` job → read each step's log. Then use **Run workflow** to trigger it manually.

## What you should see
A green run appears in the Actions tab within a minute. The log shows your `echo` line and the file listing.

## Your exercise (type it yourself, don't copy)
1. Make the workflow fail on purpose (`run: exit 1`), push, and read how failure looks. Then fix it.
2. Add a step that prints the commit SHA using `${{ github.sha }}`.
3. Add a status badge for the workflow to the top of the repo README (Actions → workflow → ... → Create status badge).

## Save your evidence
Put the link to the repo and to one green run in **My notes**. Also copy `hello.yml` to `labs/day-22/hello.yml`.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 22 "github actions first workflow"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
