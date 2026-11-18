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
Not publishing a port means the service is reachable only from other containers on the private network, not from the host or the internet, so it has a smaller attack surface.

## Save your evidence
Save `compose.yaml` as `labs/day-17/compose.yaml` and paste the `docker compose ps` output into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 17 "docker volumes networks compose"
```

## My notes (fill in before you commit)

kuldeepyadav@IN-LT-PF5GKA9R:~/lab/day17$ docker compose ps -a
NAME             IMAGE          COMMAND                  SERVICE   CREATED              STATUS                          PORTS
day17-cache-1    redis:alpine   "docker-entrypoint.s…"   cache     About a minute ago   Up About a minute               6379/tcp
day17-client-1   alpine         "sh -c 'sleep 3 && w…"   client    About a minute ago   Exited (0) About a minute ago   
day17-web-1      nginx:alpine   "/docker-entrypoint.…"   web       About a minute ago   Up About a minute               80/tcp


- Commands I ran: docker volume create, docker run -v demo-data:/data, docker network create, docker run --network lab-net, docker compose up -d / ps -a / logs / down. Exercises: added a redis:alpine service (three services), then removed the ports mapping from web.

- What I learned: A volume keeps data after the container is gone. Containers on the same user-defined network reach each other by name (http://web). Without a ports mapping, web was not reachable from the host (curl localhost:8083 failed) but the client container still reached it, so services I don't publish are not exposed. compose ps only lists running containers unless I add -a, and client exits after its one command. [paste docker compose ps -a output here]

- What went wrong and how I fixed it: I typed `cache:` at the shell prompt instead of into the file (command not found), then overwrote compose.yaml with only the cache service. I rewrote the whole file with all three services and used docker compose down to clean up.