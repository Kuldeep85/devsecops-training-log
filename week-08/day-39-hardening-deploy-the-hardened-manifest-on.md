# Day 39 — Hardening: deploy the hardened manifest on OpenShift

**Week 8 · about 60 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
This connects your project to a real OpenShift cluster and closes the loop from 'scanner found it' to 'deployed the safe version'.

## Goal today
Adjust the hardened manifest for OpenShift, deploy it, and compare with the insecure version.

## Commands you will learn

| Command | What it does |
|---|---|
| `oc apply -f file` | apply a manifest |
| `oc get deploy,pods` | check the result |
| `oc set env deployment/x KEY=value` | set environment values |
| `trivy config file` | scan before you deploy |

## Do this (run each block, then read the output before moving on)
```bash
export KUBECONFIG=~/.kube/sandbox-config
cd ~/repos/devsecops-pipeline-lab
cp k8s/hardened/deployment.yaml ~/lab/day39-deploy.yaml
code ~/lab/day39-deploy.yaml
```

For the sandbox, edit the copy: use an image that runs as non-root on port 8080 (for example `docker.io/openshift/hello-openshift`), set `containerPort: 8080` and the probe port to 8080, and remove `readOnlyRootFilesystem` if the pod complains.

```bash
trivy config ~/lab/day39-deploy.yaml
oc apply -f ~/lab/day39-deploy.yaml
oc get deploy,pods
oc describe pod -l app=demo-app | tail -15
oc delete -f ~/lab/day39-deploy.yaml
```

## What you should see
The hardened pod starts under OpenShift's restricted security policy. Write down every change you had to make and why.

## Your exercise (type it yourself, don't copy)
1. Add a `NetworkPolicy` example file to your repo (docs only) and explain what it restricts.
2. Write the 'insecure vs hardened' comparison table for your project README (6 rows).
3. Explain what would still be missing for production (image signing, admission policy, secrets in a vault, monitoring).

## Save your evidence
Commit the comparison table into the project README under `k8s/`, and paste your 'what changed and why' notes into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 39 "hardened manifest on openshift"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
