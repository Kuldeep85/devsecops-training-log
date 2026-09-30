# Day 33 — Kubernetes: services, port-forward and YAML manifests

**Week 7 · about 45 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
`port-forward` is the technique you already use at work with `oc`. Today you understand it properly and learn to write manifests instead of typing commands.

## Goal today
Expose a deployment with a service, reach it with port-forward, and manage everything from YAML files.

## Commands you will learn

| Command | What it does |
|---|---|
| `kubectl expose deployment web --port 80` | create a service |
| `kubectl port-forward svc/web 8080:80` | tunnel a cluster service to your laptop |
| `kubectl apply -f file.yaml` | create or update from a file |
| `kubectl delete -f file.yaml` | delete what a file created |
| `kubectl create namespace / -n` | separate environments |

## Do this (run each block, then read the output before moving on)
```bash
kubectl expose deployment web --port 80
kubectl get svc web
kubectl port-forward svc/web 8080:80 &
sleep 2 && curl -I http://localhost:8080
kill %1

# Same thing, as a manifest
mkdir -p ~/lab/day33 && cd ~/lab/day33
kubectl create namespace demo
cat > app.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello
spec:
  replicas: 2
  selector:
    matchLabels: { app: hello }
  template:
    metadata:
      labels: { app: hello }
    spec:
      containers:
        - name: hello
          image: nginx:1.27
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: hello
spec:
  selector: { app: hello }
  ports:
    - port: 80
      targetPort: 80
EOF
kubectl apply -f app.yaml -n demo
kubectl get all -n demo
kubectl diff -f app.yaml -n demo
kubectl delete -f app.yaml -n demo
```

## What you should see
`curl -I` through the tunnel returns `HTTP/1.1 200 OK`. `kubectl get all -n demo` shows your deployment, pods and service, and they are gone after `delete -f`.

## Your exercise (type it yourself, don't copy)
1. Change `replicas` to 3 in the file and re-`apply`. Use `kubectl diff` first to preview.
2. Deploy the same file into a second namespace `demo2` and compare.
3. Explain in one sentence how `kubectl port-forward` differs from exposing a service on the internet.

## Save your evidence
Save `app.yaml` as `labs/day-33/app.yaml` and paste your port-forward explanation into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 33 "kubernetes services and manifests"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
