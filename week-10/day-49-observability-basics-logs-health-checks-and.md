# Day 49 — Observability basics: logs, health checks and alert scripts

**Week 10 · about 45 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
DevOps roles are also about knowing when something is wrong. You will practise the fundamentals with logs and health checks, before tools like Prometheus and Grafana.

## Goal today
Read container logs and stats, and write a health-check script with proper exit codes.

## Commands you will learn

| Command | What it does |
|---|---|
| `docker stats --no-stream` | CPU and memory now |
| `docker logs --since 5m name` | recent logs |
| `curl -fsS --max-time 3 URL` | fail cleanly on errors or timeouts |
| `jq` | parse JSON logs |
| `exit codes 0/1/2` | OK / CRITICAL / UNKNOWN |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/lab/day49 && cd ~/lab/day49
docker run -d --name obs-web -p 8090:80 nginx:alpine
curl -s localhost:8090 >/dev/null && curl -s localhost:8090/missing >/dev/null
docker stats --no-stream obs-web
docker logs --since 5m obs-web

cat > healthcheck.sh <<'EOF'
#!/usr/bin/env bash
set -uo pipefail
url="${1:?Usage: $0 <url>}"
tries="${2:-3}"
for i in $(seq 1 "$tries"); do
  if curl -fsS --max-time 3 -o /dev/null "$url"; then
    echo "OK: $url is healthy (attempt $i)"
    exit 0
  fi
  echo "attempt $i failed"
  sleep 1
done
echo "CRITICAL: $url is not healthy after $tries attempts"
exit 1
EOF
chmod +x healthcheck.sh
./healthcheck.sh http://localhost:8090 ; echo "exit code: $?"
docker stop obs-web
./healthcheck.sh http://localhost:8090 2 ; echo "exit code: $?"
docker rm obs-web

# JSON logs with jq
echo '{"level":"error","msg":"db down"}
{"level":"info","msg":"ok"}
{"level":"error","msg":"timeout"}' > app.jsonl
jq -r 'select(.level=="error") | .msg' app.jsonl
```

## What you should see
Healthy: exit 0. After stopping the container: CRITICAL and exit 1. `jq` prints only the two error messages.

## Your exercise (type it yourself, don't copy)
1. Make the script send its result as JSON (`{"status":"ok"}`).
2. Explain the difference between logs, metrics and traces in three lines.
3. Describe what you would alert on for a web app (availability, error rate, latency) and why.

## Save your evidence
Save the script as `labs/day-49/healthcheck.sh` and paste both runs into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 49 "observability basics"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
