# Day 41 — Azure CLI basics on a personal account

**Week 9 · about 45 minutes · Run in: Ubuntu (WSL) terminal + browser (Azure portal)**

## Why this matters
Most Bangalore DevSecOps roles ask for one cloud. Azure fits your Azure DevOps background.

## Goal today
Install the Azure CLI, sign in to a personal subscription, and create and delete a resource group safely.

## Commands you will learn

| Command | What it does |
|---|---|
| `az login --use-device-code` | sign in |
| `az account show` | which account and tenant am I using |
| `az group create / list / delete` | manage resource groups |
| `az account list-locations -o table` | available regions |
| `Cost Management + Budgets` | set a spending alert in the portal |

## Do this (run each block, then read the output before moving on)
**Use a personal Microsoft account and a personal subscription. Do not sign in with your work account or tenant.** Create a free Azure account at `azure.microsoft.com/free` (a card is normally required for verification). Then in the portal set a **budget alert** (Cost Management → Budgets) before creating anything.

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az version
az login --use-device-code           # follow the printed link and code
az account show -o table             # CHECK: tenant/subscription must be your personal ones
az group create --name lab-rg --location centralindia
az group list -o table
az group show --name lab-rg -o json | head -20
az group delete --name lab-rg --yes --no-wait
```

## What you should see
The account output shows your personal subscription. The group appears in the list and disappears after the delete completes.

## Your exercise (type it yourself, don't copy)
1. Create two resource groups with tags: `az group create ... --tags env=lab owner=you`. List them with `--query` to show tags.
2. Delete both. Why should every lab resource live in a group you can delete in one command?
3. Explain what a subscription, a tenant and a resource group are.

## Save your evidence
Paste `az group list -o table` (before deleting) and your three definitions into **My notes**. Do not paste subscription IDs.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 41 "azure cli basics"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
