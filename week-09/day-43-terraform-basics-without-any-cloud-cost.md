# Day 43 — Terraform basics without any cloud cost

**Week 9 · about 45 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Infrastructure as code is the biggest skill gap in your profile. You will learn the workflow with a local provider first, so nothing costs money.

## Goal today
Install Terraform and run init, plan, apply and destroy on local files.

## Commands you will learn

| Command | What it does |
|---|---|
| `terraform init` | download providers |
| `terraform plan` | preview changes |
| `terraform apply` | make the changes |
| `terraform destroy` | remove what Terraform created |
| `terraform show` | display the state |

## Do this (run each block, then read the output before moving on)
```bash
# Install (HashiCorp's apt repository)
sudo apt update && sudo apt install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform
terraform version

mkdir -p ~/lab/day43 && cd ~/lab/day43
cat > main.tf <<'EOF'
terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "greeting" {
  filename = "${path.module}/hello.txt"
  content  = "Hello from Terraform"
}
EOF
terraform init
terraform plan
terraform apply -auto-approve
cat hello.txt
terraform show
terraform destroy -auto-approve
ls
```

## What you should see
`plan` says `1 to add`, `apply` creates `hello.txt`, and `destroy` removes it. Terraform keeps a `terraform.tfstate` file recording what it manages.

## Your exercise (type it yourself, don't copy)
1. Change the content in `main.tf`, run `plan`, and read the diff it shows before applying.
2. Add a second `local_file` resource and apply.
3. Explain in one sentence what the state file is and why it can contain secrets.

## Save your evidence
Save `main.tf` as `labs/day-43/main.tf`. Do NOT commit `terraform.tfstate` or `.terraform/`.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 43 "terraform basics"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
