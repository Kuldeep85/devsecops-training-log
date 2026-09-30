# Day 11 — Undoing things in Git safely

**Week 3 · about 40 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Everyone commits the wrong thing eventually. Knowing the safe undo for each situation (local vs already pushed) separates confident engineers from nervous ones.

## Goal today
Undo changes at every stage: working tree, staging, last commit, older commits, and recover 'lost' work with reflog.

## Commands you will learn

| Command | What it does |
|---|---|
| `git restore file` | discard uncommitted changes in a file |
| `git restore --staged file` | unstage a file |
| `git commit --amend` | fix the last commit (message or content) |
| `git reset --soft HEAD~1` | undo last commit, keep changes staged |
| `git revert <sha>` | make a new commit that undoes an old one (safe for shared branches) |
| `git reflog` | history of where HEAD has been, even after a reset |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/lab/day11/undo && cd ~/lab/day11/undo
git init -b main
echo "v1" > a.txt && git add . && git commit -m "v1"
echo "v2" > a.txt && git commit -am "v2"
echo "v3" > a.txt && git commit -am "v3 (oops)"

# 1. Discard an uncommitted edit
echo "junk" >> a.txt && git restore a.txt && cat a.txt
# 2. Unstage
echo "extra" > b.txt && git add b.txt && git restore --staged b.txt && git status --short
# 3. Fix the last commit message
git commit --amend -m "v3 (fixed message)"
# 4. Safe undo of an older commit (creates a new commit)
git revert --no-edit HEAD
git log --oneline
# 5. Rewrite local history, then rescue it
git reset --hard HEAD~2
git log --oneline
git reflog | head -5
git reset --hard HEAD@{2}      # pick the reflog entry you want back
git log --oneline
```

## What you should see
Each step behaves as described; after `reset --hard HEAD@{n}` the 'lost' commits are back. `reset --hard` is dangerous on real work; reflog is your safety net.

## Your exercise (type it yourself, don't copy)
1. Make a commit that accidentally includes `notes.txt`. Remove the file from that commit without losing the rest (hint: `git reset --soft HEAD~1`, unstage, recommit).
2. Explain when you must use `revert` instead of `reset` (hint: the commit is already pushed).
3. Deliberately `reset --hard` away a commit, then recover it with `reflog`.

## Save your evidence
Paste your `git reflog` output after recovery and the revert-vs-reset explanation into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 11 "undoing things in git"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
