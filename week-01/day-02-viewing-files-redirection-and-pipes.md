# Day 02 — Viewing files, redirection and pipes

**Week 1 · about 35 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Logs are how you find out why a pipeline or container failed. Pipes let you turn a 10,000-line log into the three lines that matter.

## Goal today
Read files, send output to files, and chain commands with pipes.

## Commands you will learn

| Command | What it does |
|---|---|
| `cat, less` | show a file / page through a file (q to quit in less) |
| `head -n 5, tail -n 5` | first / last lines |
| `tail -f` | follow a file as it grows (Ctrl+C to stop) |
| `wc -l` | count lines |
| `>, >>` | write / append output to a file |
| `\|` | send one command's output into another |
| `sort, uniq -c` | sort lines / count duplicates |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/lab/day02 && cd ~/lab/day02
seq 1 50 > numbers.txt
head -n 5 numbers.txt
tail -n 5 numbers.txt
wc -l numbers.txt
printf 'error\nok\nerror\nwarn\nok\nerror\n' > app.log
cat app.log
sort app.log | uniq -c | sort -nr
echo "one more line" >> app.log
wc -l app.log
less numbers.txt            # arrow keys to scroll, q to quit
```

Now watch a file grow live:

```bash
(for i in 1 2 3 4 5; do echo "tick $i" >> live.log; sleep 1; done &)
tail -f live.log            # press Ctrl+C after the 5th tick
```

## What you should see
`sort app.log | uniq -c | sort -nr` prints `3 error`, `2 ok`, `1 warn`, biggest first. `tail -f` prints one `tick` per second.

## Your exercise (type it yourself, don't copy)
1. Create `access.log` with 8 lines of your own: mix of `GET /home 200`, `GET /admin 403`, `POST /login 500`.
2. Use one pipeline to show how many times each status code appears (hint: `grep -o` or `awk '{print $NF}'`, then `sort | uniq -c`).
3. Append a new line with `>>` and confirm the count with `wc -l`.

## Save your evidence
Paste your pipeline command and its output into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 02 "viewing files redirection and pipes"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
