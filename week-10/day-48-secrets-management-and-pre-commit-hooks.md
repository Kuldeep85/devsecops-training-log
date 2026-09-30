# Day 48 — Secrets management and pre-commit hooks

**Week 10 · about 50 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Prevention is cheaper than cleanup. A pre-commit hook that blocks secrets before they ever enter Git is a strong, easy-to-demo control.

## Goal today
Install pre-commit with a gitleaks hook and prove it blocks a fake secret.

## Commands you will learn

| Command | What it does |
|---|---|
| `pip install pre-commit` | install the hook manager |
| `.pre-commit-config.yaml` | list the hooks to run |
| `pre-commit install` | enable the hook in a repo |
| `pre-commit run --all-files` | run hooks on everything |
| `git commit` | the hook runs automatically |

## Do this (run each block, then read the output before moving on)
```bash
sudo apt install -y python3-venv          # once
python3 -m venv ~/.venv-tools && source ~/.venv-tools/bin/activate
pip install pre-commit
# gitleaks must already be installed (Day 12): gitleaks version
mkdir -p ~/lab/day48/hookdemo && cd ~/lab/day48/hookdemo
git init -b main
cat > .pre-commit-config.yaml <<'EOF'
repos:
  - repo: local
    hooks:
      - id: gitleaks
        name: gitleaks (staged files)
        entry: gitleaks git --pre-commit --staged --redact --no-banner
        language: system
        pass_filenames: false
EOF
pre-commit install
echo "hello" > README.md && git add . && git commit -m "Add readme"      # passes
# build a fake secret from two halves so this guide contains no secret-looking text
PART_A="wJalrXUtnFEMI/K7MDENG"; PART_B="bPxRfiCYzZ9x8yLkQe"
echo "aws_secret_access_key = \"${PART_A}/${PART_B}\"" > config.txt
git add config.txt
git commit -m "Add config"                                                  # should be blocked
```

(The hook above uses the gitleaks program you installed on Day 12, so it needs no extra downloads. The official hook repository, `https://github.com/gitleaks/gitleaks` with `id: gitleaks`, also works but builds gitleaks on first use, which can take a few minutes.)

## What you should see
The first commit passes. The second is blocked by the gitleaks hook and shows the finding, so the secret never enters history.

## Your exercise (type it yourself, don't copy)
1. Add the same `.pre-commit-config.yaml` to your `devsecops-training-log` repo and run `pre-commit install` there.
2. Explain the three layers: pre-commit hook (developer machine), pipeline scan (shared), and secret rotation (response).
3. Write down how Azure DevOps handles secrets: pipeline secret variables, variable groups linked to Key Vault, and Secure Files (like `DownloadSecureFile@1` you see in your own pipelines).

## Save your evidence
Commit `.pre-commit-config.yaml` to the training repo, and paste your three-layer explanation into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 48 "secrets management and pre-commit"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
