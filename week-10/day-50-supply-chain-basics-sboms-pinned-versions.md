# Day 50 — Supply chain basics: SBOMs, pinned versions and digests

**Week 10 · about 45 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Software supply-chain security is a headline topic. Pinning versions and producing SBOMs are simple, demonstrable controls.

## Goal today
Generate an SBOM, scan it, pin an image by digest, and understand lockfiles.

## Commands you will learn

| Command | What it does |
|---|---|
| `trivy image --format cyclonedx` | produce an SBOM |
| `trivy sbom sbom.json` | scan an SBOM |
| `docker inspect --format '{{index .RepoDigests 0}}'` | get an image's digest |
| `npm ci` | install exactly what the lockfile says |
| `image@sha256:...` | pin by content, not by a movable tag |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/lab/day50 && cd ~/lab/day50
docker pull nginx:1.27-alpine
trivy image --format cyclonedx --output sbom.json nginx:1.27-alpine
trivy sbom --severity HIGH,CRITICAL sbom.json | tail -15

DIGEST=$(docker inspect --format '{{index .RepoDigests 0}}' nginx:1.27-alpine)
echo "$DIGEST"
docker run --rm "$DIGEST" nginx -v

# Lockfiles: npm ci installs exactly what package-lock.json says
cd ~/repos/devsecops-pipeline-lab/app
npm ci
npm ls --depth=0
```

## What you should see
The SBOM can be scanned later without re-pulling the image. Running by digest always gives the exact same image bytes, unlike a tag that can move.

## Your exercise (type it yourself, don't copy)
1. Explain in two sentences why `latest` is risky in production.
2. Explain why `npm ci` is preferred over `npm install` in pipelines.
3. In one paragraph, describe what image signing (for example cosign) would add.

## Save your evidence
Paste the digest line (it is public information) and your three explanations into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 50 "supply chain basics"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
