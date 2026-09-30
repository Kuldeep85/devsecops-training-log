# Day 36 — OpenShift: the free Developer Sandbox and the oc client

**Week 8 · about 60 minutes · Run in: Ubuntu (WSL) terminal + browser (Red Hat)**

## Why this matters
OpenShift appears in your work already. Practising on Red Hat's free sandbox lets you learn the same `oc` commands safely, on a cluster that belongs to you.

## Goal today
Create a Red Hat account, start the Developer Sandbox, install `oc`, and log in from your Ubuntu terminal using a separate kubeconfig.

## Commands you will learn

| Command | What it does |
|---|---|
| `oc login --token=... --server=...` | log in to a cluster |
| `oc whoami` | who am I logged in as |
| `oc project` | which project (namespace) am I in |
| `oc status` | summary of what runs in the project |
| `export KUBECONFIG=file` | keep each cluster's credentials in a separate file |

## Do this (run each block, then read the output before moving on)
1. Go to `developers.redhat.com/developer-sandbox`, create a free Red Hat account and start the sandbox. (Red Hat describes it as a free cluster for 30 days with one project and small resource limits; it may ask you to verify a phone number.)
2. In the OpenShift web console click your name (top right) → **Copy login command** → **Display Token** and keep that page open.

```bash
mkdir -p ~/lab/day36 && cd ~/lab/day36
# Download the oc client: in the console use the ? menu -> Command line tools, or:
curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz
tar xzf openshift-client-linux.tar.gz oc
sudo mv oc /usr/local/bin/
oc version --client

# Keep this cluster's credentials separate from kind and from anything work-related
mkdir -p ~/.kube
export KUBECONFIG=~/.kube/sandbox-config
# Paste the "oc login --token=... --server=..." line you copied from the console
oc whoami
oc project
oc status
oc get all
```

**Never** paste the token into GitHub, notes or screenshots. It expires, but treat it like a password.

## What you should see
`oc whoami` prints your sandbox user name, `oc project` shows something like `<user>-dev`, and `oc status` says there is nothing deployed yet.

## Your exercise (type it yourself, don't copy)
1. Open a **new** terminal (without the `KUBECONFIG` export) and run `oc whoami` to see that it is *not* logged in. Explain why separate kubeconfig files reduce the risk of running a command against the wrong cluster.
2. Run `oc get projects`. How many projects do you see?
3. Write down the differences you notice between `oc` and `kubectl` commands you know (`oc login`, `oc project`).

## Save your evidence
Paste `oc whoami` and `oc status` (redact the user name if you like) and your separate-kubeconfig explanation into **My notes**. Not the token.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 36 "openshift sandbox and oc login"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
