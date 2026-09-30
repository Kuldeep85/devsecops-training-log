# Day 23 — GitHub Actions: matrix, secrets and artifacts

**Week 5 · about 45 minutes · Run in: Ubuntu (WSL) terminal + browser (GitHub)**

## Why this matters
Matrices, secrets and artifacts appear in almost every real pipeline. How secrets are masked and where they must never appear is a classic interview topic.

## Goal today
Run a job across several versions, use an encrypted secret, and upload a build artifact.

## Commands you will learn

| Command | What it does |
|---|---|
| `strategy: matrix` | run the job several times with different values |
| `${{ secrets.NAME }}` | read an encrypted repository secret |
| `env:` | set environment variables |
| `actions/upload-artifact@v4` | save files from a run |
| `needs:` | make one job wait for another |

## Do this (run each block, then read the output before moving on)
```bash
cd ~/repos/cicd-practice
```

On GitHub: repo → **Settings → Secrets and variables → Actions → New repository secret** → name `DEMO_TOKEN`, value `not-a-real-token`.

```bash
cat > .github/workflows/matrix.yml <<'EOF'
name: matrix
on: [workflow_dispatch, push]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node: [20, 22]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
      - run: node --version
      - name: Use a secret safely
        env:
          DEMO_TOKEN: ${{ secrets.DEMO_TOKEN }}
        run: |
          echo "token length: ${#DEMO_TOKEN}"
          echo "printing it: $DEMO_TOKEN"        # GitHub masks this as ***
      - run: echo "build ${{ github.run_number }}" > build.txt
      - uses: actions/upload-artifact@v4
        with:
          name: build-info-node${{ matrix.node }}
          path: build.txt

  report:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - run: echo "all matrix jobs passed"
EOF
git add . && git commit -m "Add matrix workflow with secret and artifact" && git push
```

## What you should see
The `test` job runs twice (Node 20 and 22). The secret prints as `***` in the log. Two artifacts appear on the run page, and `report` runs only after both tests pass.

## Your exercise (type it yourself, don't copy)
1. Add Node 24 to the matrix and observe the extra job.
2. Make one matrix entry fail. Does `report` still run? Add `fail-fast: false` and compare.
3. Write two rules for handling secrets in pipelines (for example: never echo them, never put them in the YAML).

## Save your evidence
Save `matrix.yml` as `labs/day-23/matrix.yml` and paste your two secret-handling rules into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 23 "github actions matrix secrets artifacts"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
