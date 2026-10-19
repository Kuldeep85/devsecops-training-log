# Day 05 — Processes, ports, disk and network

**Week 1 · about 35 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
When a service is 'down' you need to know whether the process is running, which port it listens on, and whether the disk is full. Security reviews also ask 'what is listening on this machine?'.

## Goal today
Inspect running processes, listening ports, disk and memory, and make an HTTP request from the terminal.

## Commands you will learn

| Command | What it does |
|---|---|
| `ps aux` | list all processes |
| `top` | live process view (q to quit) |
| `kill PID` | stop a process |
| `ss -tulpn` | list listening TCP/UDP ports and their processes |
| `df -h, du -sh` | disk free / size of a folder |
| `free -h` | memory |
| `curl -I URL` | fetch only HTTP response headers |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/lab/day05 && cd ~/lab/day05
ps aux | head -5
top                              # look, then press q
df -h
du -sh ~/lab
free -h

# Start a tiny web server in the background and inspect it
python3 -m http.server 8000 &
sleep 1
ss -tulpn | grep 8000
curl -I http://localhost:8000
ps aux | grep "http.server" | grep -v grep

# Stop it
kill %1                          # or: kill <PID from the ps output>
ss -tulpn | grep 8000 || echo "port 8000 is free again"
```

## What you should see
`ss` shows `LISTEN` on port 8000 with `python3`. `curl -I` shows `HTTP/1.0 200 OK`. After `kill`, the port is free.

## Your exercise (type it yourself, don't copy)
1. Start the server on port 9000 instead (`python3 -m http.server 9000 &`). Find its PID two different ways.
2. Use `curl -I` on `https://example.com` and note the `content-type` and `server` headers.
3. List every listening port on your machine and write down which process owns each.

## Save your evidence
Paste your `ss -tulpn` output (remove anything you consider private) and the answer to exercise 3 into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 05 "processes ports disk network"
```

## My notes (fill in before you commit)
- Commands I ran: top, ps aux, free -h, df -h, du -sh, python3 -m http.server &, ss -tulpn, curl -I, kill %1, jobs
- What I learned: `ss -tulpn` shows listening ports and which process owns them. `0.0.0.0` means listening on all interfaces, `127.0.0.1` means local only. Only one process can use a port ("Address already in use"). `kill %1` stops a background job. In `df -h`, read the Mounted on column; the 100% WSL tools mount is normal. Use `||` to run a command only when the previous one fails.
- What went wrong and how I fixed it: I piped grep into echo, so the "port is free" message printed even when it wasn't checked. I typed `https;//` instead of `https://`, so the shell ran two commands. I started a second server on port 9000 and got "Address already in use", and I left the first one running until I killed it.