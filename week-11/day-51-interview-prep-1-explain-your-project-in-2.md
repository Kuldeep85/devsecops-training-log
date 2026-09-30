# Day 51 — Interview prep 1: explain your project in 2 minutes

**Week 11 · about 60 minutes · Run in: Any (record yourself)**

## Why this matters
Recruiters remember clear stories. A tight two-minute explanation of the pipeline lab can carry an entire interview.

## Goal today
Write and rehearse a two-minute project story, then a 30-second version.

## Do this (run each block, then read the output before moving on)
Write your story using this structure, in full sentences, in `interview/project-story.md`:

1. **Problem (10 s):** teams ship code faster than they can review it for security.
2. **What I built (30 s):** a CI/CD pipeline in Azure DevOps YAML and GitHub Actions running five checks (secrets, SAST, dependencies, container and Kubernetes config, DAST baseline).
3. **What I found (30 s):** the numbers from your findings log (secret, SQL injection, XSS, vulnerable dependencies, root container).
4. **What I fixed and how (20 s):** one commit per fix; then switched the pipeline from report-only to enforce.
5. **Proof it works (15 s):** a pull request that reintroduced a vulnerability and was blocked.
6. **What I would do next (15 s):** Terraform scanning, image signing, secrets in a vault.

Then record yourself on your phone, watch it, and cut anything vague.

## What you should see
A recording under 2 minutes 10 seconds that uses real numbers from your repo.

## Your exercise (type it yourself, don't copy)
1. Record a 30-second version for the 'tell me about a project' question.
2. Prepare the honest answer to 'Have you used this in production?' (For example: no, this is a self-built lab; at work I set up and troubleshoot client pipelines, and I applied the same thinking.)
3. Prepare one 'what went wrong' story from the lab (a scanner error, a permission problem) and how you solved it.

## Save your evidence
Commit `interview/project-story.md`. Do not commit the video.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 51 "interview prep project story"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
