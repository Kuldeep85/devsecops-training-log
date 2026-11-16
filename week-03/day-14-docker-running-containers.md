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
Image vs container (one sentence each):

An image is a read-only template, the packaged app and its files.
A container is a running, or stopped, instance of an image.

Proof: docker images still lists nginx after docker rm web.

## Save your evidence
Paste `docker ps` with both containers running and your image-vs-container explanation into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 14 "docker running containers"
```

## My notes (fill in before you commit)
- Commands I ran: docker version, docker run -d --name web -p 8080:80 nginx, docker ps / ps -a, curl -I localhost:8080, docker exec -it web sh, docker stop, docker rm, docker images, docker run --rm -it ubuntu:24.04 bash

- What I learned: An image is a template; a container is a running copy of it. -p 8080:80 maps my port 8080 to the container's port 80. Containers stay in `docker ps -a` after stopping until I docker rm them. whoami inside the nginx container showed root, so I should look at non-root containers later.

- What went wrong and how I fixed it: Docker wasn't installed, so `docker version` said "command not found". I installed Docker Engine from Docker's official apt repository, started the service and added myself to the docker group (then wsl --shutdown) so I can run it without sudo. I also made a typo in a path (/use instead of /usr) and fixed it.


