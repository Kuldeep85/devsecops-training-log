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
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
