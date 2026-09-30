# Day 01 — Linux navigation and files

**Week 1 · about 30 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Every DevOps task starts in a Linux shell: build agents, containers and Kubernetes nodes are Linux. Interviewers check that you can move around and manage files without a mouse.

## Goal today
Move around the file system and create, copy, move and delete files and folders safely.

## Commands you will learn

| Command | What it does |
|---|---|
| `pwd` | print the folder you are in |
| `ls -la` | list files, including hidden ones, with details |
| `cd` | change folder (cd .. = up, cd - = back, cd ~ = home) |
| `mkdir -p` | create a folder (and parents) |
| `touch` | create an empty file |
| `cp -r` | copy a file or folder |
| `mv` | move or rename |
| `rm / rm -r` | delete a file / a folder (there is NO recycle bin) |
| `tree` | draw a folder tree |

## Do this (run each block, then read the output before moving on)
```bash
sudo apt install -y tree          # once
mkdir -p ~/lab/day01 && cd ~/lab/day01
pwd
mkdir -p project/{src,docs,logs}
touch project/src/app.js project/docs/readme.txt
ls -la project
tree project
cp project/docs/readme.txt project/docs/readme.bak
mv project/docs/readme.bak project/logs/readme.old
ls -R project
rm project/logs/readme.old
rm -r project/docs
cd ~ ; cd - ; cd ..
pwd
```

## What you should see
`tree project` shows `src`, `docs` and `logs`. After `rm -r project/docs` the `docs` folder is gone. `cd -` jumps back to the previous folder and prints its path.

## Your exercise (type it yourself, don't copy)
1. Build a fake web-app layout: `webapp/src`, `webapp/tests`, `webapp/config`. Put one empty file in each.
2. Copy `config` to `config-backup`, rename it to `config.old`, then delete `tests`.
3. Run `tree webapp` and write one sentence on the difference between an absolute path (`/home/you/lab`) and a relative path (`lab`).

## Save your evidence
Paste the final `tree webapp` output and your one-sentence answer into **My notes** below. No other files needed today.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 01 "linux navigation and files"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
