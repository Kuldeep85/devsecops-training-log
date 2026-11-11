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

- Commands I ran: git remote -v, git branch -vv, git switch -c, git push -u origin, git pull, git pull --rebase, git branch -d, git fetch, git fetch --prune, git commit --allow-empty, git reset --soft

- What I learned: The full cycle is branch, commit, push the branch, open a PR, squash and merge, pull, delete the branch. Squash and merge makes a new commit, so `git branch -d` warns that the branch is not merged to HEAD. `git fetch` downloads without changing my files, while `git pull` fetches and then merges or rebases into my branch. Branch protection stops direct pushes to main.



- What went wrong and how I fixed it: My `cat >` overwrote the starter cheat sheet table and I left a typo ("sheer"), so I fixed it in a second PR edited in the browser. 

Test a direct push:
bash
   git switch main && git pull
   git commit --allow-empty -m "test: direct push to protected main"
   git push

Expect a rejection starting with remote: error: GH006: Protected branch update failed for refs/heads/main.

Undo the test commit, which is safe because it is empty:

bash
   git reset --soft HEAD~1
   git status

git status should say your branch is up to date with origin/main.

[Write what happened with the protected-branch test and how you relaxed the rule so my daily push works.]

- Merged PRs: https://github.com/Kuldeep85/devsecops-training-log/pull/1 and https://github.com/Kuldeep85/devsecops-training-log/pull/2

- fetch vs pull: `git fetch` downloads new commits without changing my files or branch, while `git pull` does a fetch and then merges (or rebases) them into my current branch.

git fetch downloads new commits from the remote without touching my files or branch, while git pull does a fetch and then merges those commits (or, with --rebase, replays mine on top) into my current branch.

- Branch protection result: kuldeepyadav@IN-LT-PF5GKA9R:~/repos/devsecops-training-log$ git push
Enumerating objects: 1, done.
Counting objects: 100% (1/1), done.
Writing objects: 100% (1/1), 220 bytes | 220.00 KiB/s, done.
Total 1 (delta 0), reused 0 (delta 0), pack-reused 0
remote: error: GH006: Protected branch update failed for refs/heads/main.
remote: 
remote: - Changes must be made through a pull request.
To github.com:Kuldeep85/devsecops-training-log.git
 ! [remote rejected] main -> main (protected branch hook declined)
error: failed to push some refs to 'github.com:Kuldeep85/devsecops-training-log.git'