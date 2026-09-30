# Day 46 — Terraform checks in a pipeline

**Week 10 · about 45 minutes · Run in: Ubuntu (WSL) terminal + browser (GitHub)**

## Why this matters
Format, validate and scan on every pull request is what 'shift left' looks like for infrastructure.

## Goal today
Add a GitHub Actions workflow that runs terraform fmt, validate and a scan.

## Commands you will learn

| Command | What it does |
|---|---|
| `hashicorp/setup-terraform@v3` | install Terraform in a workflow |
| `terraform init -backend=false` | initialise without a remote state |
| `terraform fmt -check` | format gate |
| `terraform validate` | validity gate |

## Do this (run each block, then read the output before moving on)
```bash
cd ~/repos
mkdir -p terraform-lab/infra terraform-lab/.github/workflows && cd terraform-lab
git init -b main
cp ~/lab/day44/main.tf infra/main.tf
printf '.terraform/\n*.tfstate*\n*.tfvars\n' > .gitignore
cat > .github/workflows/terraform.yml <<'EOF'
name: terraform-checks
on:
  pull_request:
  push:
    branches: [main]

jobs:
  checks:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: infra
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
      - run: terraform init -backend=false
      - run: terraform fmt -check
      - run: terraform validate
EOF
git add . && git commit -m "Terraform lab with format and validate checks"
# create a public GitHub repo terraform-lab, then:
git remote add origin git@github.com:<your-username>/terraform-lab.git
git push -u origin main
```

Then open a pull request that breaks the formatting on purpose and watch the check fail.

## What you should see
The workflow passes on `main`. On the pull request with bad formatting, `terraform fmt -check` fails and the PR shows a red cross.

## Your exercise (type it yourself, don't copy)
1. Fix the formatting with `terraform fmt` locally, push, and see the check go green.
2. Require the check on `main` in branch protection.
3. Explain in two sentences why a failing check on a PR helps a team.

## Save your evidence
Put the link to your failing-then-passing PR in **My notes** and copy the workflow to `labs/day-46/terraform.yml`.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 46 "terraform checks in ci"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
