# Day 10 — Branches, merging and resolving conflicts

**Week 2 · about 45 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Pull requests, feature branches and merge conflicts are the daily reality of team pipelines. Being calm with a conflict is a very visible skill.

## Goal today
Create branches, merge them, cause a conflict on purpose and resolve it; use stash.

## Commands you will learn

| Command | What it does |
|---|---|
| `git switch -c name` | create and move to a branch |
| `git branch -vv` | list branches and tracking info |
| `git merge branch` | bring a branch into the current one |
| `git rebase main` | replay your commits on top of main |
| `git stash / git stash pop` | shelve and restore uncommitted work |
| `git log --graph --oneline --all` | see all branches |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/lab/day10/conflict && cd ~/lab/day10/conflict
git init -b main
echo "hello" > greeting.txt && git add . && git commit -m "Base"

git switch -c feature-a
echo "hello from A" > greeting.txt && git commit -am "A changes greeting"
git switch main
git switch -c feature-b
echo "hello from B" > greeting.txt && git commit -am "B changes greeting"

git switch main
git merge feature-a            # fast-forward: no conflict
git merge feature-b            # CONFLICT
git status
cat greeting.txt               # see the <<<<<<< ======= >>>>>>> markers
```

Resolve it: open the file (`code greeting.txt`), keep the text you want, delete the marker lines, then:

```bash
git add greeting.txt
git commit -m "Merge feature-b, keep both greetings"
git log --graph --oneline --all

# Stash: park unfinished work
echo "unfinished" >> greeting.txt
git stash
git status                     # clean
git stash pop                  # work is back
```

## What you should see
The first merge fast-forwards. The second stops with `CONFLICT (content)`, and `cat` shows conflict markers. After resolving and committing, the graph shows the two branches joining.

## Your exercise (type it yourself, don't copy)
1. Repeat the conflict, but this time resolve it by keeping only the B version.
2. Create a branch, add two commits, then `git rebase main` from it. Compare the graph to the merge result.
3. Write two sentences: when would you prefer merge, and when rebase?

## Save your evidence
Paste the `git log --graph --oneline --all` output after your resolution and your merge-vs-rebase answer into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 10 "branches merge and conflicts"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
