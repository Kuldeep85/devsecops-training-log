# Day 04 — Permissions, users and sudo

**Week 1 · about 35 minutes · Run in: Ubuntu (WSL) terminal**

## Why this matters
Most container and server hardening is permissions: who can read a secret file, who can run a script, why a process must not run as root. This is core security knowledge.

## Goal today
Read and change file permissions, understand users and groups, and know when sudo is needed.

## Commands you will learn

| Command | What it does |
|---|---|
| `ls -l` | show permissions, owner and group |
| `chmod 600 file` | numeric permissions (r=4, w=2, x=1) |
| `chmod u+x,g-w file` | symbolic permissions |
| `stat -c '%a %U %n' file` | show numeric mode, owner, name |
| `whoami, id, groups` | who you are and which groups you belong to |
| `sudo` | run one command as root |

## Do this (run each block, then read the output before moving on)
```bash
mkdir -p ~/lab/day04 && cd ~/lab/day04
touch secret.txt hello.sh
echo 'echo "hello from a script"' > hello.sh
ls -l
./hello.sh                      # fails: Permission denied
chmod +x hello.sh
./hello.sh                      # works now
chmod 600 secret.txt            # owner read+write only
stat -c '%a %U %n' secret.txt
chmod 644 secret.txt            # owner rw, everyone else read
ls -l secret.txt
whoami; id; groups
ls /root                        # fails as a normal user
sudo ls /root                   # works, asks for your password
```

How to read `-rw-r--r--`: first `-` = file; then three triplets = owner, group, others. `rw-` = 6, `r--` = 4, so `644`.

## What you should see
`./hello.sh` first says `Permission denied`, then prints the message after `chmod +x`. `stat` shows `600 <your user> secret.txt`.

## Your exercise (type it yourself, don't copy)
1. Make `private.key` readable only by you (mode 600). Prove it with `stat`.
2. Make a script executable by you and your group but not others (mode 750).
3. Explain in two sentences why a private key file with mode 777 is a security problem.

## Save your evidence
Paste the `stat` outputs and your two-sentence explanation into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 04 "permissions users and sudo"
```

## My notes (fill in before you commit)
- Commands I ran: touch, echo >, ls -l, chmod +x, chmod 600/644/750, stat -c, whoami, id, groups, sudo ls
- What I learned: Permissions are read=4, write=2, execute=1 for owner, group, others. A script needs the execute bit to run. Private keys should be 600. `sudo` runs a command as root, and my user is in the sudo group.
- What went wrong and how I fixed it: I typed `~lab` instead of `~/lab`, so `mkdir` created a folder named `~lab` inside the repo. I removed it with `rmdir`. I also left private.key at 750, which is too open, and set it back to 600.