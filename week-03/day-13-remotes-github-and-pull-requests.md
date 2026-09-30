# Day 13 — Remotes, GitHub and pull requests

**Week 3 · about 45 minutes · Run in: Ubuntu (WSL) terminal + browser (GitHub)**

## Why this matters
Recruiters will look at your GitHub. This day makes sure your workflow is professional: branch, push, pull request, review, merge.

## Goal today
Understand remotes, fetch vs pull, tracking branches, and run one full pull-request cycle on your own repo.

## Commands you will learn

| Command | What it does |
|---|---|
| `git remote -v` | show remotes |
| `git push -u origin branch` | push and set upstream |
| `git fetch` | download remote changes without merging |
| `git pull --rebase` | fetch and replay your commits on top |
| `git clone URL` | copy a repository |
| `gh pr create` | open a pull request from the terminal (needs GitHub CLI) |

## Do this (run each block, then read the output before moving on)
```bash
cd ~/repos/devsecops-training-log
git remote -v
git branch -vv

# A full pull-request cycle on your own repo
git switch -c docs/add-cheatsheet
cat > notes/command-cheatsheet.md <<'EOF'
# My command cheat sheet
- pwd — where am I
- ls -la — list everything
- grep -rn "text" . — search
EOF
git add notes/command-cheatsheet.md
git commit -m "Add command cheat sheet"
git push -u origin docs/add-cheatsheet
```

In the browser: open your repo on GitHub → **Compare & pull request** → write a short description → **Create pull request** → **Squash and merge**. Then back in the terminal:

```bash
git switch main
git pull --rebase
git branch -d docs/add-cheatsheet
git log --oneline | head -5
```

## What you should see
After the merge on GitHub and `git pull --rebase`, your local `main` contains the cheat sheet commit, and the feature branch is deleted.

## Your exercise (type it yourself, don't copy)
1. Do a second pull request, this time editing the file directly on GitHub in the browser, then `git fetch` and `git pull` it down.
2. Explain the difference between `git fetch` and `git pull` in one sentence.
3. Turn on branch protection for `main` (Settings → Branches) and note what changes when you try to push directly.

## Save your evidence
Put the link to your merged pull request and your fetch-vs-pull sentence into **My notes**. A merged PR on your public repo is real evidence.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 13 "remotes github and pull requests"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
