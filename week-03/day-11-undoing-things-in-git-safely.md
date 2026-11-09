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
- Commands I ran:git restore, git restore --staged, git commit --amend, git revert --no-edit, git reset --soft HEAD~1, git reset --hard, git reflog, git show --stat

- What I learned:restore discards uncommitted edits, restore --staged unstages, amend fixes the last commit, revert makes a new commit that undoes an old one, reset --soft undoes a commit but keeps the changes, reset --hard throws changes away. reflog shows where HEAD has been, so I can get lost commits back with `git reset --hard HEAD@{n}`. It cannot recover uncommitted work.


- What went wrong and how I fixed it:I typed `--online` instead of `--oneline` several times and never saw the log; I added an alias `git lg`. `git add .` committed an unwanted file (b.txt). I removed it with `git reset --soft HEAD~1`, `git restore --staged`, and a new commit. I also typed notest.txt instead of notes.txt.

- **git reflog after recovery:** kuldeepyadav@IN-LT-PF5GKA9R:~/lab/day11/undo2$ echo "important" > keep.txt && git add . && git commit -m "Add important work"
[main f34cbca] Add important work
 2 files changed, 2 insertions(+)
 create mode 100644 keep.txt
 create mode 100644 notest.txt
kuldeepyadav@IN-LT-PF5GKA9R:~/lab/day11/undo2$ git lg
git: 'lg' is not a git command. See 'git --help'.

The most similar command is
        log
kuldeepyadav@IN-LT-PF5GKA9R:~/lab/day11/undo2$ git log
commit f34cbcaf3103b049f29c63b9f52b15dbcd1cff1f (HEAD -> main)
Author: kuldeepyadav <42803571+Kuldeep85@users.noreply.github.com>
Date:   Mon Nov 9 13:23:17 2026 +0000

    Add important work

commit 469bffc5c2db6dfe9371f5a3ee390076434f697d
Author: kuldeepyadav <42803571+Kuldeep85@users.noreply.github.com>
Date:   Mon Nov 9 13:20:05 2026 +0000

    Add feature

commit 243766c31ccd3c3613d05b3723748583620ada39
Author: kuldeepyadav <42803571+Kuldeep85@users.noreply.github.com>
Date:   Mon Nov 9 13:16:10 2026 +0000

    Add app
kuldeepyadav@IN-LT-PF5GKA9R:~/lab/day11/undo2$ git reset --hard HEAD~1
HEAD is now at 469bffc Add feature
kuldeepyadav@IN-LT-PF5GKA9R:~/lab/day11/undo2$ git log
commit 469bffc5c2db6dfe9371f5a3ee390076434f697d (HEAD -> main)
Author: kuldeepyadav <42803571+Kuldeep85@users.noreply.github.com>
Date:   Mon Nov 9 13:20:05 2026 +0000

    Add feature

commit 243766c31ccd3c3613d05b3723748583620ada39
Author: kuldeepyadav <42803571+Kuldeep85@users.noreply.github.com>
Date:   Mon Nov 9 13:16:10 2026 +0000

    Add app
kuldeepyadav@IN-LT-PF5GKA9R:~/lab/day11/undo2$ git reflog
469bffc (HEAD -> main) HEAD@{0}: reset: moving to HEAD~1
f34cbca HEAD@{1}: commit: Add important work
469bffc (HEAD -> main) HEAD@{2}: commit: Add feature
243766c HEAD@{3}: reset: moving to HEAD~1
14e798b HEAD@{4}: commit: Add feature
243766c HEAD@{5}: commit (initial): Add app
kuldeepyadav@IN-LT-PF5GKA9R:~/lab/day11/undo2$ git reset --hard HEAD@{1}
HEAD is now at f34cbca Add important work
kuldeepyadav@IN-LT-PF5GKA9R:~/lab/day11/undo2$ git log
commit f34cbcaf3103b049f29c63b9f52b15dbcd1cff1f (HEAD -> main)
Author: kuldeepyadav <42803571+Kuldeep85@users.noreply.github.com>
Date:   Mon Nov 9 13:23:17 2026 +0000

    Add important work

commit 469bffc5c2db6dfe9371f5a3ee390076434f697d
Author: kuldeepyadav <42803571+Kuldeep85@users.noreply.github.com>
Date:   Mon Nov 9 13:20:05 2026 +0000

    Add feature

commit 243766c31ccd3c3613d05b3723748583620ada39
Author: kuldeepyadav <42803571+Kuldeep85@users.noreply.github.com>
Date:   Mon Nov 9 13:16:10 2026 +0000

    Add app
kuldeepyadav@IN-LT-PF5GKA9R:~/lab/day11/undo2$ git reflog
f34cbca (HEAD -> main) HEAD@{0}: reset: moving to HEAD@{1}
469bffc HEAD@{1}: reset: moving to HEAD~1
f34cbca (HEAD -> main) HEAD@{2}: commit: Add important work
469bffc HEAD@{3}: commit: Add feature
243766c HEAD@{4}: reset: moving to HEAD~1
14e798b HEAD@{5}: commit: Add feature
243766c HEAD@{6}: commit (initial): Add app
kuldeepyadav@IN-LT-PF5GKA9R:~/lab/day11/undo2$ 

- **revert vs reset:** If a commit is already pushed, you must use revert. A reset rewrites history, so your branch would no longer match what others already pulled, and you would have to force-push and break their work. A revert adds a new commit that undoes the old one, so history only moves forward and is safe on a shared branch. Use reset only for local, unpushed commits.

cd ~/repos/devsecops-training-log
git status
tools/finish-day.sh 11 "undoing things in git"