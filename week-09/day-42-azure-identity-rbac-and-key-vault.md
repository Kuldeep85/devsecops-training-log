# Day 42 — Azure identity, RBAC and Key Vault

**Week 9 · about 60 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Identity and secrets management are where cloud security lives. Key Vault plus RBAC is the standard Azure answer to 'where do you keep secrets?'.

## Goal today
Create a Key Vault with RBAC, store and read a secret, then delete everything.

## Commands you will learn

| Command | What it does |
|---|---|
| `az keyvault create --enable-rbac-authorization true` | create a vault that uses RBAC |
| `az role assignment create` | grant a role |
| `az keyvault secret set / show` | store / read a secret |
| `az role assignment list` | see who has access |
| `az group delete` | clean up |

## Do this (run each block, then read the output before moving on)
```bash
az login --use-device-code
UPN=$(az ad signed-in-user show --query userPrincipalName -o tsv)
SUB=$(az account show --query id -o tsv)
KV=kv-lab-$RANDOM$RANDOM           # vault names must be globally unique
az group create --name lab-kv-rg --location centralindia
az keyvault create --name $KV --resource-group lab-kv-rg --location centralindia --enable-rbac-authorization true
SCOPE=$(az keyvault show --name $KV --query id -o tsv)
az role assignment create --assignee "$UPN" --role "Key Vault Secrets Officer" --scope "$SCOPE"
sleep 30                             # role assignments take a moment
az keyvault secret set --vault-name $KV --name demo-secret --value "lab-only-value"
az keyvault secret show --vault-name $KV --name demo-secret --query value -o tsv
az role assignment list --scope "$SCOPE" -o table
az group delete --name lab-kv-rg --yes --no-wait
```

If the role assignment is refused, your account may lack permission on the subscription; note that and read the RBAC documentation instead.

## What you should see
The secret value prints back once you have the role. The assignment list shows only you. After deletion nothing is left to pay for.

## Your exercise (type it yourself, don't copy)
1. Explain in three sentences why RBAC on a vault beats sharing one connection string in a pipeline variable.
2. Describe how a pipeline could read this secret without storing it (a service connection or managed identity with a role on the vault).
3. List two things you should never do with secrets in pipelines.

## Save your evidence
Paste the role assignment table (redact the sign-in name) and your explanations into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 42 "azure rbac and key vault"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
