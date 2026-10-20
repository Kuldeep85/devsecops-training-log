# Day 06 — Bash variables, environment and quoting

**Week 2 · about 35 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Pipelines pass everything through environment variables (build numbers, tokens, paths). Understanding them, and keeping secrets out of your shell history, is basic DevSecOps hygiene.

## Goal today
Use variables, environment variables, command substitution and quoting; read a secret without echoing it.

## Commands you will learn

| Command | What it does |
|---|---|
| `NAME=value` | set a shell variable (no spaces around =) |
| `export NAME=value` | make it visible to child processes |
| `printenv, env` | list environment variables |
| `$(command)` | use a command's output as text |
| `"double" vs 'single'` | double quotes expand variables, single quotes do not |
| `read -s` | read input without showing it |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/lab/day06 && cd ~/lab/day06
NAME="devsecops"
echo "Hello $NAME"
echo 'Hello $NAME'                # single quotes: no expansion
TODAY=$(date +%F)
echo "Today is $TODAY"
export APP_ENV=dev
bash -c 'echo "child sees: $APP_ENV"'
NAME2=local-only
bash -c 'echo "child sees: [$NAME2]"'     # empty: not exported
printenv | grep APP_ENV
echo "$PATH" | tr ':' '\n'

# Read a secret without showing it or saving it in history
read -s -p "Enter a fake token: " TOKEN; echo
echo "token length: ${#TOKEN}"
unset TOKEN

# Make a shortcut permanent
echo "alias ll='ls -la'" >> ~/.bashrc
source ~/.bashrc
ll
```

## What you should see
The exported variable is visible in the child shell; the non-exported one prints as empty brackets. The token length prints without ever showing the token.

## Your exercise (type it yourself, don't copy)
1. Create a variable `BUILD_ID=42` and use it in a message: `Build #42 started at <time>`.
2. Prove with `bash -c` that an un-exported variable is invisible to a child process, then export it and repeat.
3. Explain why typing `mycommand --token=abc123` on the command line is risky (hint: `history`).

## Save your evidence
Paste the output of the `bash -c` proof and your history explanation into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 06 "bash variables and environment"
```

## My notes (fill in before you commit)
- Commands I ran: NAME=value, echo with "" and '', $(date +%F), export, bash -c, printenv, echo $PATH | tr, read -s, ${#VAR}, unset, alias, source ~/.bashrc

- What I learned: Double quotes expand $VAR and single quotes don't. Only exported variables reach child processes. $PATH is searched in order and the first match runs. `read -s` keeps a secret off the screen, and `unset` removes it. Always quote "$VAR" because spaces split an unquoted variable into several words. A token on the command line is visible in `ps`, shell history and logs, so pass secrets by environment variable, file or secret store.

- What went wrong and how I fixed it: I used `@NAME` instead of `$NAME`, and `$(time +%F)` instead of `$(date +%F)` because `time` is a shell keyword. I labelled a child-shell test as "main env". My `ll` alias was redundant because Ubuntu already has one.

