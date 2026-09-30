# Day 52 — Interview prep 2: Linux, Git and Docker questions

**Week 11 · about 60 minutes · Run in: Any**

## Why this matters
Fundamentals questions come first in almost every DevOps interview. Answer them with the commands you practised.

## Goal today
Answer 15 questions aloud in two sentences each and write your answers down.

## Do this (run each block, then read the output before moving on)
Answer each aloud in 2–3 sentences, then write it in `interview/linux-git-docker.md`.

**Linux**
1. How do you find which process is using port 8080? (`ss -tulpn | grep 8080`)
2. What does `chmod 640 file` mean?
3. How do you find files modified in the last day?
4. What does `set -euo pipefail` do?
5. What is an exit code, and how does a pipeline use it?

**Git**
6. Merge vs rebase?
7. You committed a password. What do you do? (Rotate first; then clean; then prevent.)
8. Revert vs reset?
9. How do you find who changed a line and when?
10. What is a pull request for?

**Docker**
11. Image vs container?
12. Why run as non-root?
13. What does a multi-stage build achieve?
14. Why avoid the `latest` tag?
15. What does `--cap-drop ALL` do?

## What you should see
You can answer each without notes in under 30 seconds.

## Your exercise (type it yourself, don't copy)
1. Time yourself on five random questions.
2. Find the two answers you hesitate on and re-practise the matching command from Weeks 1–4.
3. Add three more questions of your own from your work experience.

## Save your evidence
Commit `interview/linux-git-docker.md`.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 52 "interview prep linux git docker"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
