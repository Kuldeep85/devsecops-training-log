# Day 16 — Docker hardening: non-root, read-only, no capabilities

**Week 4 · about 40 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
'Why should a container not run as root?' is one of the most common DevSecOps interview questions. Today you prove the answer yourself.

## Goal today
Run containers with least privilege and see the protections working.

## Commands you will learn

| Command | What it does |
|---|---|
| `--user 1000:1000` | run as a non-root user |
| `--read-only` | make the container's filesystem read-only |
| `--cap-drop ALL` | remove all Linux capabilities |
| `--security-opt no-new-privileges` | block privilege escalation |
| `USER 1000 (Dockerfile)` | set the non-root user in the image |

## Do this (run each block, then read the output before moving on)
```bash
docker run --rm alpine id                              # root by default
docker run --rm --user 1000:1000 alpine id             # non-root
docker run --rm alpine sh -c 'touch /test && echo "write ok"'
docker run --rm --read-only alpine sh -c 'touch /test && echo "write ok"'     # fails
docker run --rm alpine sh -c 'chown nobody /tmp && echo "chown ok"'
docker run --rm --cap-drop ALL alpine sh -c 'chown nobody /tmp && echo "chown ok"'   # fails
docker run --rm --user 1000:1000 --read-only --cap-drop ALL \
  --security-opt no-new-privileges alpine id
```

Now bake it into an image:

```bash
mkdir -p ~/lab/day16 && cd ~/lab/day16
cat > Dockerfile <<'EOF'
FROM alpine:3.20
RUN adduser -D -u 1000 appuser
USER 1000
CMD ["sh", "-c", "id && echo running as non-root"]
EOF
docker build -t nonroot-demo .
docker run --rm nonroot-demo
```

## What you should see
The default container prints `uid=0(root)`. With `--read-only` the `touch` fails with `Read-only file system`. With `--cap-drop ALL` the `chown` fails with `Operation not permitted`.

## Your exercise (type it yourself, don't copy)
1. Explain in three sentences why a compromised root container is worse than a compromised non-root one.
2. Take the Day 15 image and add a non-root user. Confirm with `docker run --rm my-site:2.0 id`. (nginx needs extra port and folder changes — if it fights back, switch the base to `nginxinc/nginx-unprivileged` and note what you learned.)
3. List the four flags you would want in every production container.

## Save your evidence
Save the Dockerfile as `labs/day-16/Dockerfile` and paste your explanation and flag list into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 16 "docker hardening flags"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
