# Day 35 — Kubernetes: RBAC, securityContext and scanning manifests

**Week 7 · about 60 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
This is the day Docker hardening, Trivy and Kubernetes meet. Being able to show the difference between an insecure and a hardened manifest is direct evidence for DevSecOps roles.

## Goal today
Create a least-privilege role, test it, and prove a security context blocks a root container.

## Commands you will learn

| Command | What it does |
|---|---|
| `kubectl create role / rolebinding` | grant a small set of permissions |
| `kubectl auth can-i ... --as user` | test what an identity may do |
| `securityContext: runAsNonRoot` | refuse to start a root container |
| `trivy config dir` | scan manifests for misconfiguration |
| `kubectl get events` | see why a pod did not start |

## Do this (run each block, then read the output before moving on)
```bash
kubectl create namespace rbac-lab
kubectl create role pod-reader --verb=get,list --resource=pods -n rbac-lab
kubectl create rolebinding rb --role=pod-reader --user=jane -n rbac-lab
kubectl auth can-i list pods -n rbac-lab --as jane           # yes
kubectl auth can-i delete pods -n rbac-lab --as jane         # no
kubectl auth can-i list pods -n default --as jane            # no

# A root image with runAsNonRoot: the pod must be refused
mkdir -p ~/lab/day35 && cd ~/lab/day35
cat > root-blocked.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: root-blocked
spec:
  securityContext:
    runAsNonRoot: true
  containers:
    - name: c
      image: nginx:1.27
EOF
kubectl apply -f root-blocked.yaml -n rbac-lab
sleep 5 && kubectl get pod root-blocked -n rbac-lab
kubectl describe pod root-blocked -n rbac-lab | tail -8

# Compare the two manifests from the project
cd ~/repos/devsecops-pipeline-lab
trivy config k8s/insecure-example
trivy config k8s/hardened
kubectl delete namespace rbac-lab
```

## What you should see
Jane can list pods in `rbac-lab` only. `root-blocked` shows `CreateContainerConfigError`: the container would run as root, so Kubernetes refuses. Trivy reports findings on the insecure manifest and (almost) none on the hardened one.

## Your exercise (type it yourself, don't copy)
1. Explain each line of `k8s/hardened/deployment.yaml` (`readOnlyRootFilesystem`, `capabilities.drop`, `resources.limits`, `seccompProfile`) in your own words.
2. Deploy `k8s/hardened/deployment.yaml` on kind after changing the image to `nginxinc/nginx-unprivileged:1.27` and the port to 8080. Does it start?
3. Note what you had to change and why.

## Save your evidence
Put your line-by-line explanation into `labs/day-35/hardening-explained.md` and paste the Trivy before/after counts into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 35 "kubernetes rbac and securitycontext"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
