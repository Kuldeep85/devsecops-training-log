# Day 32 — Kubernetes: pods, deployments, scaling and rollouts

**Week 7 · about 45 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Deployments, scaling and rollbacks are what Kubernetes exists to do, and they are daily topics in DevOps roles.

## Goal today
Create a deployment, scale it, inspect pods, watch self-healing, and roll an update back.

## Commands you will learn

| Command | What it does |
|---|---|
| `kubectl create deployment` | create a deployment |
| `kubectl scale --replicas=3` | change the number of copies |
| `kubectl describe / logs / exec` | inspect a pod |
| `kubectl set image` | change the image (a rollout) |
| `kubectl rollout status / history / undo` | watch and reverse rollouts |

## Do this (run each block, then read the output before moving on)
```bash
kubectl create deployment web --image=nginx:1.25 --replicas=2
kubectl get deploy,pods
kubectl scale deployment web --replicas=3
kubectl get pods
POD=$(kubectl get pods -l app=web -o jsonpath='{.items[0].metadata.name}')
kubectl describe pod $POD | head -30
kubectl logs $POD
kubectl exec -it $POD -- sh -c 'whoami; nginx -v'

# Self-healing: delete a pod and watch a new one appear
kubectl delete pod $POD
kubectl get pods

# Rollout and rollback
kubectl set image deployment/web nginx=nginx:1.27
kubectl rollout status deployment/web
kubectl rollout history deployment/web
kubectl rollout undo deployment/web
kubectl describe deployment web | grep Image
```

## What you should see
Three pods run; after you delete one, Kubernetes immediately creates a replacement. After `rollout undo` the image is back to `nginx:1.25`.

## Your exercise (type it yourself, don't copy)
1. Set an image that does not exist (`nginx:does-not-exist`), watch the pod fail (`ImagePullBackOff`), read `kubectl describe`, then fix it with `rollout undo`.
2. Scale to 0 and back to 2. What happens to the pods?
3. Explain why running `nginx` as root here is a problem you will fix on Day 35.

## Save your evidence
Paste the `ImagePullBackOff` event message and your explanation into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 32 "kubernetes deployments and scaling"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
