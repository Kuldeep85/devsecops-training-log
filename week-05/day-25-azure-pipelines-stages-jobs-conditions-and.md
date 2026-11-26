# Day 25 — Azure Pipelines: stages, jobs, conditions and templates

**Week 5 · about 60 minutes · Run in: Browser (Azure DevOps personal org) + Ubuntu terminal**

## Why this matters
Real pipelines have stages, dependencies and reusable templates, just like the Android/iOS/Electron files you fix at work. This day makes those structures second nature.

## Goal today
Write a multi-stage pipeline with dependencies, a condition, a template and a published artifact.

## Commands you will learn

| Command | What it does |
|---|---|
| `stages: / - stage:` | big phases (Build, Test, Deploy) |
| `jobs: / - job:` | units that run on an agent |
| `dependsOn / condition` | ordering and when to run |
| `template: file.yml` | reuse steps |
| `- publish: path` | save build output as an artifact |

## Do this (run each block, then read the output before moving on)
```bash
cd ~/repos/cicd-practice
mkdir -p templates
cat > templates/greet.yml <<'EOF'
parameters:
  - name: who
    type: string
    default: world

steps:
  - script: echo "Hello ${{ parameters.who }}"
    displayName: Greet ${{ parameters.who }}
EOF

cat > azure-pipelines.yml <<'EOF'
trigger:
  branches:
    include: [main]

parameters:
  - name: runDeploy
    displayName: Run the deploy stage?
    type: boolean
    default: false

pool:
  vmImage: ubuntu-latest   # or: name: Default

stages:
  - stage: Build
    jobs:
      - job: build
        steps:
          - template: templates/greet.yml
            parameters:
              who: Build
          - script: |
              mkdir -p out && echo "build $(Build.BuildId)" > out/build.txt
            displayName: Create output
          - publish: out
            artifact: build-output

  - stage: Test
    dependsOn: Build
    jobs:
      - job: test
        steps:
          - script: echo "tests would run here"
            displayName: Test

  - stage: Deploy
    dependsOn: Test
    condition: and(succeeded(), eq('${{ parameters.runDeploy }}', 'true'))
    jobs:
      - job: deploy
        steps:
          - script: echo "deploying"
EOF
git add . && git commit -m "Multi-stage pipeline with template and artifact" && git push
```

Run it from Azure DevOps twice: once normally (Deploy is skipped) and once with **Run pipeline → tick 'Run the deploy stage?'**.

## What you should see
Build and Test run every time; Deploy is skipped unless you tick the box. The Build stage publishes an artifact you can download from the run page.

## Your exercise (type it yourself, don't copy)
1. Add a second job to Test that runs in parallel. Check whether it really runs in parallel on your free agent (it may queue: explain why).
2. Change the template so it prints a second parameter.

3. Draw the stage diagram (boxes and arrows) for your file and save it as `labs/day-25/stages.png` or as text.
[ Build ] ---> [ Test ] ---> [ Deploy ]
  build job      test job      deploy job
  + artifact     lint job      runs only if Test succeeded
                               AND runDeploy = true

## Save your evidence
Save the two YAML files under `labs/day-25/` and put your parallelism explanation into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 25 "azure pipelines stages and templates"
```

## My notes (fill in before you commit)
- Commands I ran: wrote templates/greet.yml and a multi-stage azure-pipelines.yml (Build, Test, Deploy) with a template, a boolean parameter, a condition and publish: out; ran it twice, once with the deploy box ticked. Exercises: added a second job (lint) to Test with sleep, added a second template parameter, drew the stage diagram.

- What I learned: Stages run in order using dependsOn. The Deploy stage was skipped normally and ran when I ticked runDeploy (condition and(succeeded(), eq(parameters.runDeploy, 'true'))). A template is reusable steps with its own parameters. publish: out saves build output as an artifact. My two jobs in Test did not run in parallel: I have one self-hosted agent and a free organisation has one self-hosted parallel job, so the second job waited for the first.

- What went wrong and how I fixed it: I pasted YAML into the terminal with heredocs several times and the EOF line got mixed up with other text, so I abandoned them and edited the file in VS Code instead. I also saved my Day 24 screenshot in week-05 instead of labs/day-24, and moved it.

