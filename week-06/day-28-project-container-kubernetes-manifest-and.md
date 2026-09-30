# Day 28 — Project: container, Kubernetes manifest and DAST scans

**Week 6 · about 75 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
This adds the container and running-application checks, the layers where most real DevSecOps value sits.

## Goal today
Build the image, scan it, scan the Kubernetes manifests and run a ZAP baseline against the running container.

## Commands you will learn

| Command | What it does |
|---|---|
| `make container` | build image, Trivy image scan, Trivy config scan, SBOM |
| `trivy config k8s/insecure-example` | scan the deliberately insecure manifest |
| `make dast` | run the ZAP baseline against the container |
| `open reports/zap-baseline.html` | read the DAST report |

## Do this (run each block, then read the output before moving on)
```bash
cd ~/repos/devsecops-pipeline-lab
bash scripts/install-trivy.sh                    # skip if trivy is already installed
make container
trivy config k8s/insecure-example                # capture the BEFORE evidence
make dast
ls reports
```

Open `reports/zap-baseline.html` in a browser (from Windows Explorer: `\\wsl$\Ubuntu\home\<you>\repos\devsecops-pipeline-lab\reports`).

## What you should see
Trivy reports HIGH/CRITICAL issues in the `node:14` image and in the insecure manifest (privileged, root). ZAP lists passive findings such as missing security headers.

## Your exercise (type it yourself, don't copy)
1. Count HIGH and CRITICAL findings in the image scan and record them as your 'before' number.
2. Explain in your log why `privileged: true` and `runAsUser: 0` are dangerous.
3. If any script fails (path, permission, missing tool), write down the error and your fix. These notes are valuable in interviews.

## Save your evidence
Commit the updated log with the 'before' numbers. Save one screenshot of the Trivy summary in `evidence/` (no client data, no tokens).

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 28 "project container and dast scans"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
