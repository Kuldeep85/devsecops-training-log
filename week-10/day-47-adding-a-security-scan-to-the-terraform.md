# Day 47 — Adding a security scan to the Terraform pipeline

**Week 10 · about 45 minutes · Run in: Ubuntu (WSL) terminal + browser (GitHub)**

## Why this matters
Adding a scanner that fails on serious findings turns a formatting check into a real security gate.

## Goal today
Add Trivy config scanning to the workflow and watch it block an insecure change.

## Commands you will learn

| Command | What it does |
|---|---|
| `trivy config --exit-code 1 --severity HIGH,CRITICAL infra` | fail on serious IaC findings |
| `workflow steps` | install then run the scanner |
| `branch protection` | require the check before merge |

## Do this (run each block, then read the output before moving on)
```bash
cd ~/repos/terraform-lab
git switch -c add-security-scan
cp ~/lab/day45/storage.tf infra/storage.tf              # the INSECURE version
```

Add these steps to the end of the job in `.github/workflows/terraform.yml`:

```yaml
      - name: Install Trivy
        run: curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin v0.74.0
        working-directory: .
      - name: Scan infrastructure code
        run: trivy config --severity HIGH,CRITICAL --exit-code 1 infra
```

```bash
git add . && git commit -m "Add insecure storage example and Trivy scan"
git push -u origin add-security-scan
```

Open a PR: the scan should fail. Fix `storage.tf` (TLS 1.2, no public access), push again, and confirm it turns green, then merge.

## What you should see
The first run fails at the scan step with the storage findings; after the fix it passes.

## Your exercise (type it yourself, don't copy)
1. Screenshot the failing and the passing PR checks.
2. Add an ignore for one finding using a `.trivyignore` file and write why it is acceptable (or why you would never do that).
3. Write a 5-line note: what should happen when a scan is flaky or produces a false positive?

## Save your evidence
Save the failing/passing screenshots in `labs/day-47/`, and link the PR in **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 47 "terraform security scan in ci"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
