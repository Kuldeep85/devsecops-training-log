# Day 21 — YAML fundamentals and reading pipeline files

**Week 5 · about 45 minutes · Run in: Ubuntu (WSL) terminal + your work Azure DevOps (read-only)**

## Why this matters
You already fix your clients' pipeline YAML. Today you turn 'basic working knowledge' into vocabulary you can explain: mappings, lists, multi-line scripts, and what each pipeline block does.

## Goal today
Write valid YAML and explain each part of an Azure Pipelines file.

## Commands you will learn

| Command | What it does |
|---|---|
| `key: value` | a mapping |
| `- item` | a list entry |
| `\| (pipe)` | a multi-line block, used for scripts |
| `# comment` | comment |
| `python3 -c "import yaml..."` | check a file is valid YAML |
| `indentation` | 2 spaces, never tabs |

## Do this (run each block, then read the output before moving on)
```bash
sudo apt install -y python3-yaml
mkdir -p ~/lab/day21 && cd ~/lab/day21
cat > sample-pipeline.yml <<'EOF'
trigger:
  branches:
    include:
      - main

variables:
  - name: nodeVersion
    value: 22

pool:
  vmImage: ubuntu-latest

stages:
  - stage: Build
    displayName: Build the app
    jobs:
      - job: BuildNode
        steps:
          - task: NodeTool@0
            displayName: Use Node $(nodeVersion)
            inputs:
              versionSpec: '$(nodeVersion).x'
          - script: |
              node --version
              npm --version
            displayName: Show versions
EOF
python3 -c "import yaml; yaml.safe_load(open('sample-pipeline.yml')); print('valid YAML')"
# Break it on purpose: change 'stages:' indentation by one space, then re-run the check
```

**Now the work part (no copying, no screenshots to GitHub):** open one of your client pipeline files in Azure DevOps (read-only, as part of your normal job). In a private notebook, list each top-level key (`trigger`, `variables`, `name`, `stages`, `pool`, `steps`) and write one line on what it does. Note any special tasks such as `DownloadSecureFile@1` and what problem they solve (keeping files like server URLs out of the repo).

## What you should see
`valid YAML` prints. After you break the indentation the check prints a parser error with a line number. You will see this kind of error in real pipeline failures.

## Your exercise (type it yourself, don't copy)
1. Add a second job to `sample-pipeline.yml` that runs `echo hello` and validate it.
2. Add a `parameters:` block with a boolean `enforce` and reference it as `${{ parameters.enforce }}`.
3. Write a 6-line glossary (`trigger`, `stage`, `job`, `step`, `pool`, `task`) in your own words.

## Save your evidence
Commit `sample-pipeline.yml` as `labs/day-21/sample-pipeline.yml` and your glossary in **My notes**. **Never commit or paste a client's real pipeline file, names, URLs or screenshots** — write only your own generic examples.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 21 "yaml fundamentals"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
