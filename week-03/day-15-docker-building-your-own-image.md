# Day 15 — Docker: building your own image

**Week 3 · about 45 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Writing a clean Dockerfile is a core DevOps task, and Dockerfile mistakes (root user, latest tag, bloated image) are the first things security scanners flag.

## Goal today
Write a Dockerfile, build, tag and run an image; see how layers and image size work.

## Commands you will learn

| Command | What it does |
|---|---|
| `docker build -t name:tag .` | build an image from a Dockerfile |
| `docker history name:tag` | show the layers |
| `docker tag src dst` | add another name/tag |
| `docker image ls` | list images and sizes |
| `.dockerignore` | files that must not go into the image |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/lab/day15/site && cd ~/lab/day15/site
echo "<h1>Hello from my first image</h1>" > index.html
cat > Dockerfile <<'EOF'
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EOF
printf '.git\n*.md\n' > .dockerignore
docker build -t my-site:1.0 .
docker run -d --name my-site -p 8082:80 my-site:1.0
curl http://localhost:8082
docker history my-site:1.0
docker tag my-site:1.0 my-site:latest
docker image ls | grep -E "my-site|nginx"
docker rm -f my-site
```

## What you should see
`curl` prints your `<h1>`. `docker image ls` shows `my-site` is only a little larger than `nginx:alpine`, because it reuses the base layers.

## Your exercise (type it yourself, don't copy)
1. Change the HTML, rebuild as `my-site:1.1`, and run both versions on different ports.
2. Build the same site on `nginx:latest` instead of `nginx:alpine`. Compare image sizes.
3. Write two reasons why a small base image is better for security.

## Save your evidence
Save the Dockerfile as `labs/day-15/Dockerfile` and paste your size comparison into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 15 "docker building images"
```

## My notes (fill in before you commit)

Two reasons a small base image is better for security (my wording, so write your own):

Smaller attack surface. Fewer packages and tools means fewer vulnerabilities to patch, and fewer tools such as a shell or compilers for an attacker to use.
Faster to scan, patch and rebuild. Scanners report fewer findings, and pulls are quicker.

Interview point: the lesson’s other flagged mistakes are the latest tag and running as root. Pin a version such as nginx:1.27-alpine, because latest can change under you.

- Commands I ran: docker build -t my-site:1.0 ., docker run -d -p 8082:80, docker history, docker tag, docker image ls, docker rm -f. Exercises: built my-site:1.1 and ran both versions on 8082 and 8083, then built the same site on nginx:latest to compare sizes.

- What I learned: An image is built in layers, and my Dockerfile adds only one small layer (COPY, 24.6kB) on top of the nginx:alpine base. A tag is just a label, and my-site:1.0 and :latest share one image ID. Size: alpine-based 93.7MB vs nginx:latest-based [your number]. A small base image means a smaller attack surface and quicker scans. I should pin versions rather than use latest.

- What went wrong and how I fixed it: Running `docker run --name my-site` a second time failed with "container name already in use". I removed the old container with docker rm -f my-site.


## My notes
- **Commands I ran:** 
- **What I learned:** 
- **What went wrong and how I fixed it:** 