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
- Commands I ran:git switch -c, git merge, git status, git add, git commit -am, git log --graph --oneline --all, git stash / stash pop, git diff --check, git rebase main, git checkout --theirs

- What I learned:A conflict means two branches changed the same lines. Git adds <<<<<<< ======= >>>>>>> markers. I must edit the file, remove the markers and check with `git diff --check` before `git add`. `git add` only marks the file as resolved. Stash parks uncommitted work. A merge keeps both histories with a merge commit, while a rebase replays my commits on top of main for a straight line.

- What went wrong and how I fixed it:I committed a conflicted file with the markers still inside, because I used `git add` without editing it. I found it when a later commit showed 3 deletions. I redid the exercise in a clean folder and checked with `git diff --check`. I also typed `git feature-b` and `--online` by mistake, and left an uncommitted change that blocked `git switch`.

- **Graph after resolving (keep only B):
Before the rebase: two lines that split from the same point.
kuldeepyadav@IN-LT-PF5GKA9R:~/lab/day10/conflict2$ git --no-pager log --graph --oneline --all
* 1731f34 (main) Add main change
| * 775b9a0 (HEAD -> feature-c) Add c2
| * 5368f29 Add c1
|/  
*   cd1161e Merge feature-b, keep only B
|\  
| * 7123782 (feature-b) B changes greeting
* | 1cd1b81 (feature-a) A changes greeting
|/  
* d280ee0 Base

After the rebase: one straight line, with your two commits replayed on top of main’s new commit. Their IDs change, because rebase creates new commits.
kuldeepyadav@IN-LT-PF5GKA9R:~/lab/day10/conflict2$ git rebase main
Successfully rebased and updated refs/heads/feature-c.
kuldeepyadav@IN-LT-PF5GKA9R:~/lab/day10/conflict2$ git --no-pager log --graph --oneline --all
* 933ca8d (HEAD -> feature-c) Add c2
* 46bb561 Add c1
* 1731f34 (main) Add main change
*   cd1161e Merge feature-b, keep only B
|\  
| * 7123782 (feature-b) B changes greeting
* | 1cd1b81 (feature-a) A changes greeting
|/  
* d280ee0 Base

- **Merge vs rebase:** -

I would use merge to bring a finished branch into a shared branch like main, because it keeps the real history and never rewrites commits that other people may already have. 

I would use rebase on my own unpushed feature branch to tidy it onto the latest main before a pull request, because it gives a straight history, but I would never rebase commits that others have already pulled, since rebase creates new commit IDs.