# Day 18 — Scanning images with Trivy and creating an SBOM

**Week 4 · about 40 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Image scanning is the most visible DevSecOps skill. You will scan real images, compare a bad base with a good one, and generate an SBOM.

## Goal today
Install Trivy, scan images and files, filter by severity, and produce an SBOM.

## Commands you will learn

| Command | What it does |
|---|---|
| `trivy image name` | scan an image for known vulnerabilities |
| `--severity HIGH,CRITICAL` | only show serious findings |
| `--ignore-unfixed` | hide findings with no fix available yet |
| `trivy fs .` | scan a folder (dependencies, secrets, config) |
| `trivy image --format cyclonedx --output sbom.json name` | write a software bill of materials |

## Do this (run each block, then read the output before moving on)
```bash
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin v0.74.0
trivy --version
mkdir -p ~/lab/day18 && cd ~/lab/day18

docker pull node:14
docker pull node:22-alpine
trivy image --severity HIGH,CRITICAL --ignore-unfixed node:14 | tail -15
trivy image --severity HIGH,CRITICAL --ignore-unfixed node:22-alpine | tail -15

trivy image --format cyclonedx --output sbom.json node:22-alpine
jq '.components | length' sbom.json
jq -r '.components[0:5][] | .name + " " + (.version // "")' sbom.json
```

## What you should see
`node:14` (an old end-of-life base) shows far more HIGH/CRITICAL findings than `node:22-alpine`. The SBOM lists every package inside the image. The first run downloads the vulnerability database, so it is slower.

## Your exercise (type it yourself, don't copy)
1. Record the count of HIGH+CRITICAL findings for both images in a small table.
2. Scan the Day 15 image (`my-site:1.0`) and the Day 16 `nonroot-demo`. Which has fewer findings and why?
3. Explain in two sentences what an SBOM is and who might ask for one.

## Save your evidence
Save your comparison table as `labs/day-18/trivy-comparison.md`. Do NOT commit `sbom.json` if it is large; paste a 5-line excerpt into **My notes** instead.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 18 "trivy image scanning and sbom"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
