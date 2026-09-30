# Day 34 — Kubernetes: ConfigMaps and Secrets

**Week 7 · about 45 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Secrets management is the centre of DevSecOps. A very common interview trap: Kubernetes Secrets are only base64-encoded, not encrypted by default.

## Goal today
Create a ConfigMap and a Secret, use them in a pod, and see why base64 is not protection.

## Commands you will learn

| Command | What it does |
|---|---|
| `kubectl create configmap` | store non-secret settings |
| `kubectl create secret generic` | store sensitive values |
| `kubectl get secret name -o yaml` | see how it is stored |
| `base64 -d` | decode a base64 string |
| `env: valueFrom:` | inject into a container |

## Do this (run each block, then read the output before moving on)
```bash
kubectl create namespace secrets-lab
kubectl create configmap app-config --from-literal=APP_MODE=demo -n secrets-lab
kubectl create secret generic app-secret --from-literal=API_KEY=lab-only-12345 -n secrets-lab

kubectl get secret app-secret -n secrets-lab -o yaml
kubectl get secret app-secret -n secrets-lab -o jsonpath='{.data.API_KEY}' | base64 -d ; echo

mkdir -p ~/lab/day34 && cd ~/lab/day34
cat > pod.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: env-demo
spec:
  restartPolicy: Never
  containers:
    - name: c
      image: busybox:1.36
      command: ["sh", "-c", "echo MODE=$APP_MODE; echo KEY_LENGTH=${#API_KEY}; sleep 5"]
      env:
        - name: APP_MODE
          valueFrom:
            configMapKeyRef: { name: app-config, key: APP_MODE }
        - name: API_KEY
          valueFrom:
            secretKeyRef: { name: app-secret, key: API_KEY }
EOF
kubectl apply -f pod.yaml -n secrets-lab
sleep 8 && kubectl logs env-demo -n secrets-lab
kubectl delete namespace secrets-lab
```

## What you should see
Decoding the secret prints the original text, proving base64 is encoding, not encryption. The pod logs show the mode and the key **length** (not the key).

## Your exercise (type it yourself, don't copy)
1. List three ways to protect real secrets (encryption at rest, RBAC on secrets, an external vault such as Azure Key Vault, not putting them in Git).
2. Explain why printing the key length instead of the key is a good habit in logs.
3. Find out who can read secrets: run `kubectl auth can-i get secrets -n kube-system`.

## Save your evidence
Paste your three protections and the decode demonstration (with the fake value) into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 34 "kubernetes configmaps and secrets"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
