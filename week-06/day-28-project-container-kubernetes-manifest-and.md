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
![alt text](image.png)

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 28 "project container and dast scans"
```

## My notes (fill in before you commit)
- Commands I ran: trivy --version, make container, trivy image --severity HIGH,CRITICAL on demo-app:local, trivy config on the K8s manifest, SBOM generation (CycloneDX).

- What I learned: the image scan before-number is 422 HIGH/CRITICAL before (405 HIGH, 17 CRITICAL; 376 in Debian OS packages, 46 in Node.js packages) on an old Debian 10 base. The K8s manifest scored 0 misconfigurations. privileged: true and runAsUser: 0 are dangerous because a compromise inside the container becomes root on the container and a path to the host. In report-only mode a crashed scan prints the same "found issues" warning as a real finding, so a gate must also check that a report exists.

The OS layer (376) is eight times bigger than the Node.js packages (46), so most of the risk came from the old Debian 10 base image, not my app code

- What went wrong and how I fixed it: docker build failed at "npm ci" with "Cannot read property 'express' of undefined" because node:14 ships npm 6, which can't read my newer package-lock.json. I changed FROM node:14 to node:16 (npm 8) and the build worked. Trivy then failed with "No such image: demo-app:local" because there was nothing built, and the script still printed "found issues (report-only mode)". I also guessed the wrong report filename (trivy-image.json) when counting findings.
