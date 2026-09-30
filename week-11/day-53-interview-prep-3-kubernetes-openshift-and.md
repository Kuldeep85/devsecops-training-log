# Day 53 — Interview prep 3: Kubernetes, OpenShift and CI/CD questions

**Week 11 · about 60 minutes · Run in: Any**

## Why this matters
This is where your work experience (Azure DevOps pipelines, OpenShift port-forward) meets your new skills.

## Goal today
Answer 15 more questions, mixing your real work with your lab evidence.

## Do this (run each block, then read the output before moving on)
Write your answers in `interview/k8s-cicd.md`.

**Kubernetes / OpenShift**
1. Pod vs deployment vs service?
2. How does `oc port-forward` work, and when do you use it?
3. Why can an image fail on OpenShift but run on Docker?
4. Are Kubernetes Secrets encrypted? (Base64 only by default.)
5. What does `runAsNonRoot` do?
6. A pod is CrashLoopBackOff: your steps?

**CI/CD (use your real work here)**
7. What are the main blocks of an Azure Pipelines YAML file?
8. How do you keep files such as server URLs out of the repo? (Secure Files, variable groups, Key Vault.)
9. A build worked yesterday and fails today: how do you investigate? (Your incident/RCA background is a real strength.)
10. Stages vs jobs vs steps?

**Security in pipelines**
11. SAST vs DAST vs SCA?
12. What is a false positive and how do you handle it?
13. How would you roll out security gates without blocking every team? (Report-only first, then enforce; start with the highest-risk checks.)
14. What is an SBOM?
15. What would you do first in a team with no security scanning?

## What you should see
Each answer uses one real example from your own work or your lab.

## Your exercise (type it yourself, don't copy)
1. Mark which answers use work experience and which use lab experience. Aim for both in questions 7–10.
2. Prepare a 'what I don't know yet' answer: name the gap, and say what you are doing about it.
3. Do one mock interview with a friend.

## Save your evidence
Commit `interview/k8s-cicd.md`.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 53 "interview prep k8s and cicd"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
