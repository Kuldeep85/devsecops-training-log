# Day 40 — Checkpoint: project write-up and start applying

**Week 8 · about 90 minutes · Run in: VS Code + browser**

## Why this matters
Week 8 is when you start applying. Evidence beats claims, so today you polish what a recruiter will actually open.

## Goal today
Finish the project README, update your CV placeholders honestly, and run the ready-to-apply checklist.

## Do this (run each block, then read the output before moving on)
Work through this list on the project repo `devsecops-pipeline-lab`:

1. **README top box:** replace the status text with one honest sentence (personal learning project, deliberately vulnerable app).
2. **Pipeline diagram:** a simple box diagram of the stages (secrets → SAST → SCA → container → DAST) added as an image or Mermaid block.
3. **Before/after table:** findings before, findings after, fix commit links.
4. **Screenshots:** baseline run, enforced failure, final green run (no client or personal data).
5. **What I would do next:** 4 bullet points (Terraform scanning, signed images, secrets in a vault, policy as code).
6. **Pin** `devsecops-training-log` and `devsecops-pipeline-lab` on your GitHub profile.
7. **CV:** open `Kuldeep_Yadav_DevSecOps_Engineer_CV.docx`, replace each yellow placeholder with real numbers and links, and **delete every line you cannot demonstrate live**.

**Ready-to-apply checklist** — answer yes/no to each:
- I can write and explain a short Bash script.
- I can explain each stage of my pipeline and what each tool catches.
- I have a screenshot of an enforced pipeline failing, then passing.
- I built and hardened a Docker image and can explain every change.
- I ran the hardened manifest on kind and OpenShift.
- Every claim on my CV is demonstrable.

## What you should see
If all six checklist answers are yes, start applying to Tier 1 employers from the roadmap page. If not, list the gaps and fix them first.

## Your exercise (type it yourself, don't copy)
1. Have a friend or a recording of yourself explain the project in 2 minutes without notes.
2. Send the repo link to one person and ask what was unclear.
3. Start your application log in the tracker workbook.

## Save your evidence
Commit the updated READMEs. In **My notes** write the checklist with yes/no and the gaps you found.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 40 "week 8 checkpoint"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
