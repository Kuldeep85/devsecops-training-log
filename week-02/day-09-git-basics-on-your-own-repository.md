# Day 09 — Git basics on your own repository

**Week 2 · about 40 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
You use Git daily at work, but interviewers ask how it works, not just push and pull. Clean, small commits with clear messages also make your GitHub evidence look professional.

## Goal today
Create a repository, stage, commit, inspect history and ignore files.

## Commands you will learn

| Command | What it does |
|---|---|
| `git init -b main` | start a repository |
| `git status` | what changed? |
| `git add file / git add -p` | stage a file / stage chunks interactively |
| `git commit -m "msg"` | record a snapshot |
| `git log --oneline --graph` | compact history |
| `git diff / git diff --staged` | unstaged / staged changes |
| `git show <sha>` | what a commit changed |
| `.gitignore` | list files Git must not track |

## Do this (run each block, then read the output before moving on)
```bash
git config --global user.name "Your Name"          # skip if done in setup
git config --global user.email "you@personal-email"
mkdir -p ~/lab/day09/gitdemo && cd ~/lab/day09/gitdemo
git init -b main
echo "# demo" > README.md
git status
git add README.md
git commit -m "Add README"
echo "line two" >> README.md
git diff
git add README.md && git commit -m "Add second line"
printf '.env\nnode_modules/\n*.log\n' > .gitignore
echo "TOKEN=fake" > .env
git status                    # .env must NOT be listed
git add .gitignore && git commit -m "Add .gitignore"
git log --oneline --graph
git show HEAD
```

## What you should see
`git status` never lists `.env`, because `.gitignore` covers it. `git log --oneline` shows three commits, newest first.

## Your exercise (type it yourself, don't copy)
1. Make three more commits, each changing one thing, each with a message that starts with a verb (`Add`, `Fix`, `Remove`).
2. Change two different lines in one file and use `git add -p` to commit them as two separate commits.
3. Explain the difference between the working tree, the staging area and the repository.

## Save your evidence
Paste your `git log --oneline` output and your three-part explanation into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 09 "git basics local repo"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
