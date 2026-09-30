# Day 31 — Kubernetes: install kind and kubectl, create a cluster

**Week 7 · about 45 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Kubernetes is the platform most containers run on, and OpenShift is Kubernetes with extra security. You will build a private cluster on your laptop in a few minutes.

## Goal today
Install kubectl and kind, create a local cluster, and read its basic status.

## Commands you will learn

| Command | What it does |
|---|---|
| `kind create cluster --name lab` | create a Kubernetes cluster in Docker |
| `kubectl get nodes` | list cluster nodes |
| `kubectl get pods -A` | all pods in all namespaces |
| `kubectl config get-contexts` | which clusters kubectl can talk to |
| `kubectl config current-context` | which cluster the next command will hit |

## Do this (run each block, then read the output before moving on)
```bash
# kubectl (official method)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

# kind: check the current version number at kind.sigs.k8s.io/docs/user/quick-start and put it in place of vX.Y.Z
curl -Lo ./kind https://kind.sigs.k8s.io/dl/vX.Y.Z/kind-linux-amd64
chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind
kind version

kind create cluster --name lab
kubectl cluster-info --context kind-lab
kubectl config current-context
kubectl get nodes -o wide
kubectl get pods -A
```

**Safety habit from day one:** always run `kubectl config current-context` before changing anything. This shell must only ever point at your own `kind-lab` cluster, never at a client or work cluster.

## What you should see
One node in `Ready` state and system pods running in `kube-system`. The current context is `kind-lab`.

## Your exercise (type it yourself, don't copy)
1. Run `docker ps` and find the container that is your Kubernetes 'node'.
2. Create a second cluster named `lab2`, list contexts, switch between them with `kubectl config use-context`, then delete `lab2`.
3. Write in your own words: what is a node, a pod and a namespace?

## Save your evidence
Paste `kubectl get nodes` and your three definitions into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 31 "kubernetes kind and kubectl"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
