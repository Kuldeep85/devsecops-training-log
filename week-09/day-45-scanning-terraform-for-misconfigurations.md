# Day 45 — Scanning Terraform for misconfigurations

**Week 9 · about 45 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Infrastructure-as-code scanning is a headline DevSecOps skill, and it needs no cloud account: scanners read the files.

## Goal today
Scan an intentionally insecure Terraform file, fix it, and scan again.

## Commands you will learn

| Command | What it does |
|---|---|
| `trivy config .` | scan Terraform, Kubernetes and Docker files |
| `--severity HIGH,CRITICAL` | show serious findings only |
| `--exit-code 1` | fail when findings exist (for pipelines) |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/lab/day45 && cd ~/lab/day45
cat > storage.tf <<'EOF'
resource "azurerm_storage_account" "bad" {
  name                            = "labstoragebad001"
  resource_group_name             = "lab-rg"
  location                        = "centralindia"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_0"
  allow_nested_items_to_be_public = true
}
EOF
trivy config .
trivy config --severity HIGH,CRITICAL --exit-code 1 . ; echo "exit code: $?"
```

Now fix the file (set `min_tls_version = "TLS1_2"` and `allow_nested_items_to_be_public = false`, and try adding `https_traffic_only_enabled = true`), then:

```bash
trivy config .
```

**Nothing is applied to Azure today.** The scanner only reads the file.

## What you should see
The first scan lists misconfigurations (old TLS version, public access). The exit code is 1. After the fix, findings drop or disappear.

## Your exercise (type it yourself, don't copy)
1. Record before/after finding counts in a small table.
2. Write two more insecure settings you would expect a scanner to catch in a storage account or virtual machine.
3. Explain why catching this in a pull request is better than finding it in production.

## Save your evidence
Save the insecure and fixed `storage.tf` files under `labs/day-45/` with your before/after table in `labs/day-45/results.md`.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 45 "scanning terraform"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
