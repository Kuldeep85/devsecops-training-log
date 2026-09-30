# Day 14 — Docker: running containers

**Week 3 · about 40 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Containers are how modern software ships. You need to be fluent at running, inspecting and cleaning up containers before you can secure them.

## Goal today
Run, inspect, enter and remove containers; understand images vs containers.

## Commands you will learn

| Command | What it does |
|---|---|
| `docker run --rm hello-world` | run a test container and delete it afterwards |
| `docker run -d --name web -p 8080:80 nginx` | run in the background, publish port 8080 |
| `docker ps / ps -a` | running / all containers |
| `docker logs -f web` | follow the logs |
| `docker exec -it web sh` | open a shell inside a container |
| `docker stop / rm` | stop / delete a container |
| `docker images` | list local images |

## Do this (run each block, then read the output before moving on)
```bash
docker version
docker run --rm hello-world
docker run -d --name web -p 8080:80 nginx
docker ps
curl -I http://localhost:8080
docker logs web
docker exec -it web sh
#   inside the container:  whoami ; ls /usr/share/nginx/html ; exit
docker stop web
docker ps -a
docker rm web
docker images
docker run --rm -it ubuntu:24.04 bash    # a throwaway Linux; type exit to leave
```

## What you should see
`curl -I` returns `HTTP/1.1 200 OK` from nginx. Inside the container `whoami` shows `root`, which you will fix on Day 16.

## Your exercise (type it yourself, don't copy)
1. Run a second nginx on port 8081 with a different name. Confirm both work.
2. Stop and remove all your containers with two commands (hint: `docker ps -aq`).
3. Explain the difference between an image and a container in your own words.

## Save your evidence
Paste `docker ps` with both containers running and your image-vs-container explanation into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 14 "docker running containers"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
