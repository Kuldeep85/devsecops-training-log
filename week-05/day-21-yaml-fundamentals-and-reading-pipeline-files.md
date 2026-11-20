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

kuldeepyadav@IN-LT-PF5GKA9R:~/lab/day21$ python3 -c "import yaml; yaml.safe_load(open('sample-pipeline.yml')); print('valid YAML')"
Traceback (most recent call last):
  File "<string>", line 1, in <module>
  File "/usr/lib/python3/dist-packages/yaml/__init__.py", line 125, in safe_load
    return load(stream, SafeLoader)
           ^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3/dist-packages/yaml/__init__.py", line 81, in load
    return loader.get_single_data()
           ^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3/dist-packages/yaml/constructor.py", line 49, in get_single_data
    node = self.get_single_node()
           ^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3/dist-packages/yaml/composer.py", line 36, in get_single_node
    document = self.compose_document()
               ^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3/dist-packages/yaml/composer.py", line 55, in compose_document
    node = self.compose_node(None, None)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3/dist-packages/yaml/composer.py", line 84, in compose_node
    node = self.compose_mapping_node(anchor)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3/dist-packages/yaml/composer.py", line 127, in compose_mapping_node
    while not self.check_event(MappingEndEvent):
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3/dist-packages/yaml/parser.py", line 98, in check_event
    self.current_event = self.state()
                         ^^^^^^^^^^^^
  File "/usr/lib/python3/dist-packages/yaml/parser.py", line 438, in parse_block_mapping_key
    raise ParserError("while parsing a block mapping", self.marks[-1],
yaml.parser.ParserError: while parsing a block mapping
  in "sample-pipeline.yml", line 1, column 1
expected <block end>, but found '<block mapping start>'
  in "sample-pipeline.yml", line 6, column 2

kuldeepyadav@IN-LT-PF5GKA9R:~/lab/day21$ python3 -c "import yaml; yaml.safe_load(open('sample-pipeline.yml')); print('valid YAML')"
valid YAML

## Your exercise (type it yourself, don't copy)
1. Add a second job to `sample-pipeline.yml` that runs `echo hello` and validate it.
2. Add a `parameters:` block with a boolean `enforce` and reference it as `${{ parameters.enforce }}`.
3. Write a 6-line glossary (`trigger`, `stage`, `job`, `step`, `pool`, `task`) in your own words.

trigger: what starts the pipeline, such as a push to main.
stage: a big phase of the pipeline, such as Build, Test or Deploy.
job: a group of steps that runs together on one agent.
step: one single action inside a job, either a script or a task.
pool: the machines (agents) the job runs on, such as ubuntu-latest.
task: a ready-made step, such as NodeTool@0 for installing Node.

## Save your evidence
Commit `sample-pipeline.yml` as `labs/day-21/sample-pipeline.yml` and your glossary in **My notes**. **Never commit or paste a client's real pipeline file, names, URLs or screenshots** — write only your own generic examples.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 21 "yaml fundamentals"
```

## My notes (fill in before you commit)
- Commands I ran: sudo apt install -y python3-yaml, python3 -c "import yaml; yaml.safe_load(...)" to check a file, and I wrote sample-pipeline.yml with a trigger, variables, pool, a stage with two jobs, and a parameters block. [add your 6-line glossary here]

- What I learned: In YAML, indentation is structure: keys at the same level must line up, with spaces only. When I put one extra space before stages: the parser said "expected <block end>" with a line and column number. The validity check only tests syntax, not whether Azure Pipelines would accept the file. ${{ parameters.enforce }} is a template expression that Azure fills in before the run.

- What went wrong and how I fixed it: I mistyped python3-yaml as pyhton3-yaml, and my first pasted file was cut off because the EOF line got other text on it. I also made the one-space mistake on stages: (the planned test), then removed the space and rewrote the file. I did the client pipeline reading privately, without screenshots or names in the repo.

