# Day 37 — OpenShift: deploy an app, logs, shell and routes

**Week 8 · about 60 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Deploying, reading logs and opening a shell in a pod are exactly what you would do when supporting an OpenShift-hosted application.

## Goal today
Deploy a sample app, inspect it, expose it with a route and clean up.

## Commands you will learn

| Command | What it does |
|---|---|
| `oc new-app <source> --name x` | build and deploy an app |
| `oc get pods / oc logs -f pod` | list pods / follow logs |
| `oc rsh pod` | open a shell inside a pod |
| `oc expose svc/x` | create a public route |
| `oc get route` | show the URL |
| `oc delete all -l app=x` | remove everything the app created |

## Do this (run each block, then read the output before moving on)
```bash
export KUBECONFIG=~/.kube/sandbox-config      # every new terminal
oc whoami

oc new-app https://github.com/sclorg/nodejs-ex.git --name nodejs-ex
oc get pods -w                                  # wait for Running, then Ctrl+C
oc logs -f buildconfig/nodejs-ex                # the build log (Ctrl+C to leave)
oc get pods
POD=$(oc get pods -l deployment=nodejs-ex -o jsonpath='{.items[0].metadata.name}')
oc logs $POD
oc rsh $POD
#   inside: whoami ; id ; exit          <- note the user is NOT root
oc expose svc/nodejs-ex
oc get route nodejs-ex
curl -I http://$(oc get route nodejs-ex -o jsonpath='{.spec.host}')
oc delete all -l app=nodejs-ex
```

If a command or the sample repository has changed, use the current Red Hat Developer Sandbox getting-started guide; the ideas stay the same.

## What you should see
The build completes, a pod runs, and `id` inside it shows a **random non-root user id**. `curl -I` returns HTTP 200 from the route.

## Your exercise (type it yourself, don't copy)
1. Explain why the user inside the pod is not root (OpenShift assigns an arbitrary non-root UID by default).
2. Use `oc describe pod $POD` and find the image, the node and the events.
3. List the `oc` command you used for each of: see pods, see logs, open a shell, see the URL.

## Save your evidence
Paste the `id` output from inside the pod and your explanation into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 37 "openshift deploy logs and routes"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
