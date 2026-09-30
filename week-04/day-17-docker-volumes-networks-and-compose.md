# Day 17 — Docker volumes, networks and compose

**Week 4 · about 40 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Real systems are several containers talking to each other. Networks and volumes are also where data leaks and lost data happen.

## Goal today
Persist data with volumes, connect containers on a private network, and describe a stack in a compose file.

## Commands you will learn

| Command | What it does |
|---|---|
| `docker volume create / ls` | named storage that outlives containers |
| `-v name:/path` | mount a volume |
| `docker network create` | private network with name-based discovery |
| `docker compose up -d / down` | start / stop a multi-container stack |
| `docker compose logs -f` | follow logs of all services |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/lab/day17 && cd ~/lab/day17
# Volumes
docker volume create demo-data
docker run --rm -v demo-data:/data alpine sh -c 'echo "kept" > /data/file.txt'
docker run --rm -v demo-data:/data alpine cat /data/file.txt     # data survived

# A private network
docker network create lab-net
docker run -d --name web --network lab-net nginx:alpine
docker run --rm --network lab-net alpine wget -qO- http://web | head -3   # reach it by NAME
docker rm -f web
docker network rm lab-net
```

Now the same idea as a compose file:

```bash
cat > compose.yaml <<'EOF'
services:
  web:
    image: nginx:alpine
    ports:
      - "8083:80"
  client:
    image: alpine
    command: sh -c "sleep 3 && wget -qO- http://web | head -3"
    depends_on:
      - web
EOF
docker compose up -d
docker compose logs client
docker compose ps
curl -I http://localhost:8083
docker compose down
```

## What you should see
The file written in one container is readable from another because it lives in the volume. `wget http://web` works because containers on the same user-defined network resolve each other by name.

## Your exercise (type it yourself, don't copy)
1. Add a third service to the compose file (for example `redis:alpine`) and confirm `docker compose ps` lists three.
2. Remove the port mapping from `web` and show that `curl localhost:8083` no longer works but `client` still reaches it.
3. Write one sentence on why not publishing a port is a security advantage.

## Save your evidence
Save `compose.yaml` as `labs/day-17/compose.yaml` and paste the `docker compose ps` output into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 17 "docker volumes networks compose"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
