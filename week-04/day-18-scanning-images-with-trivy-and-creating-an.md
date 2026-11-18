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
An SBOM (software bill of materials) is a list of every package and version inside a piece of software or image. Customers, auditors and security teams ask for one so they can quickly check whether a newly published vulnerability affects what they run.

## Save your evidence
Save your comparison table as `labs/day-18/trivy-comparison.md`. Do NOT commit `sbom.json` if it is large; paste a 5-line excerpt into **My notes** instead.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 18 "trivy image scanning and sbom"
```

## My notes (fill in before you commit)
- Commands I ran: trivy --version, docker pull node:14 / node:22-alpine, trivy image --severity HIGH,CRITICAL --ignore-unfixed, trivy image --format cyclonedx --output sbom.json, jq '.components | length' sbom.json, and a loop using --format json and jq to count CRITICAL and HIGH findings.

kuldeepyadav@IN-LT-PF5GKA9R:~/repos/devsecops-training-log$ trivy image --format cyclonedx --output sbom.json node:22-alpine
2026-11-18T09:20:14Z    INFO    "--format cyclonedx" disables security scanning. Specify "--scanners vuln" explicitly if you want to include vulnerabilities in the "cyclonedx" report.
2026-11-18T09:20:16Z    INFO    Detected OS     family="alpine" version="3.24.4"
2026-11-18T09:20:16Z    INFO    Number of language-specific files       num=1

📣 Notices:
  - Version 0.76.2 of Trivy is now available, current version is 0.74.0

To suppress version checks, run Trivy scans with the --skip-version-check flag

kuldeepyadav@IN-LT-PF5GKA9R:~/repos/devsecops-training-log$ cat labs/day-18/trivy-comparison.md
# Trivy comparison (HIGH + CRITICAL, --ignore-unfixed, Trivy 0.74.0)

| Image | CRITICAL | HIGH | Notes |
|---|---|---|---|
| node:14 | 18 | 439 | Debian 10, end-of-life |
| node:22-alpine | 0 | 10 | Alpine, 19 OS packages |
| my-site:1.0 | 0 | 3 | nginx:alpine base |
| nonroot-demo | 0 | 2 | alpine:3.20 base |

Fewer findings: nonroot-demo (2 vs 3), because it is bare Alpine with no nginx, so it has fewer packages and a smaller attack surface. node:14 has 457 because it is end-of-life Debian 10 with old Node tooling.

- What I learned: node:14 had 18 CRITICAL and 439 HIGH, against 0 and 10 for node:22-alpine, because it is end-of-life Debian 10. my-site:1.0 had 3 HIGH and nonroot-demo had 2 HIGH, and nonroot-demo is smaller (12.1MB vs 93.7MB) with fewer packages. Counts exclude unfixed vulnerabilities (--ignore-unfixed). An SBOM is a list of every package in an image (218 for node:22-alpine); customers and auditors ask for one to check whether a new CVE affects them. SBOM excerpt: ansi-regex 6.2.2, emoji-regex 9.2.2, spdx-expression-parse 3.0.1, strip-ansi 7.2.0, string-width 5.1.2.

- What went wrong and how I fixed it: I ran the commands in the repo, not ~/lab/day18, so sbom.json landed in the repo; I moved it out before committing. I also typed `.componenets` instead of `.components`, so jq printed nothing; I corrected the spelling. My first trivy-comparison.md still had `?` placeholders, so I rewrote it with the real counts.
