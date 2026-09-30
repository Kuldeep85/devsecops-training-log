# Day 38 — OpenShift: port-forward, events and why root images fail

**Week 8 · about 60 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
You already use `oc port-forward` at work. Today you master it on your own app, plus the debugging commands you reach for when a pod will not start.

## Goal today
Use port-forward, events and describe to debug, and see OpenShift refuse a root container.

## Commands you will learn

| Command | What it does |
|---|---|
| `oc port-forward pod/x 8080:8080` | tunnel a pod port to your laptop |
| `oc get events --sort-by=.lastTimestamp` | recent cluster events |
| `oc describe pod x` | details and events of one pod |
| `oc logs --previous pod` | logs of the crashed container |
| `oc get pod x -o yaml` | full pod spec |

## Do this (run each block, then read the output before moving on)
```bash
export KUBECONFIG=~/.kube/sandbox-config
oc new-app https://github.com/sclorg/nodejs-ex.git --name nodejs-ex
oc get pods -w
POD=$(oc get pods -l deployment=nodejs-ex -o jsonpath='{.items[0].metadata.name}')

oc port-forward pod/$POD 8081:8080 &
sleep 2 && curl -I http://localhost:8081
kill %1

oc get events --sort-by=.lastTimestamp | tail -10
oc get pod $POD -o yaml | grep -A6 securityContext

# Try a root-only image: OpenShift's default security policy should stop it
oc create deployment root-test --image=nginx:1.27
sleep 15
oc get pods
oc describe pod -l app=root-test | tail -15
oc logs -l app=root-test --tail=5
oc delete deployment root-test
oc delete all -l app=nodejs-ex
```

## What you should see
The port-forward works exactly like the one you use at work. The plain `nginx` deployment fails or crash-loops with a permission error (for example writing to `/var/cache/nginx`), because OpenShift runs it as a random non-root user.

## Your exercise (type it yourself, don't copy)
1. Explain in three sentences why an image that works on plain Docker can fail on OpenShift, and what you would change in the Dockerfile (numeric non-root USER, writable folders, ports above 1024).
2. Write the steps you take when a pod is `CrashLoopBackOff` (events → describe → logs → previous logs).
3. Note which commands were denied (`Forbidden`) in the sandbox. Being denied is expected and is itself a good security lesson.

## Save your evidence
Save your troubleshooting steps as `labs/day-38/pod-troubleshooting.md` and paste the security-policy explanation into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 38 "openshift port-forward and events"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
