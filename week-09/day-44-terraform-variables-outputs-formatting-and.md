# Day 44 — Terraform variables, outputs, formatting and validation

**Week 9 · about 45 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Variables, outputs and automatic formatting/validation are what make Terraform reviewable in a pull request and checkable in a pipeline.

## Goal today
Parameterise a config, add outputs, and use fmt and validate.

## Commands you will learn

| Command | What it does |
|---|---|
| `variable "x" {}` | an input |
| `output "x" {}` | a value shown after apply |
| `terraform fmt -check` | fail if formatting is off |
| `terraform validate` | check the config is valid |
| `terraform apply -var 'name=x'` | pass a value |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/lab/day44 && cd ~/lab/day44
cat > main.tf <<'EOF'
terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

variable "owner" {
  type    = string
  default = "you"
}

variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be dev, test or prod."
  }
}

resource "local_file" "info" {
  filename = "${path.module}/info-${var.environment}.txt"
  content  = "owner=${var.owner} env=${var.environment}"
}

output "file_path" {
  value = local_file.info.filename
}
EOF
terraform init
terraform fmt -check ; echo "fmt exit: $?"
terraform validate
terraform apply -var 'environment=staging' -auto-approve     # rejected by the validation rule
terraform apply -var 'environment=dev' -auto-approve
terraform output
terraform destroy -var 'environment=dev' -auto-approve
```

## What you should see
`environment=staging` is rejected with your custom error message; `dev` works and prints the file path as an output.

## Your exercise (type it yourself, don't copy)
1. Mess up the indentation, run `terraform fmt -check` (it fails), then run `terraform fmt` to fix it.
2. Add a `.gitignore` for `.terraform/`, `*.tfstate*` and `*.tfvars` in your training repo.
3. Explain in one sentence why `terraform plan` output in a pull request is valuable for review.

## Save your evidence
Save `main.tf` and the `.gitignore` under `labs/day-44/`.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 44 "terraform variables and validation"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
